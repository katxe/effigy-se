/obj/machinery/computer/icts_controls
	name = "tram controls"
	desc = "An interface for the tram that lets you tell the tram where to go and hopefully it makes it there. I'm here to describe the controls to you, not to inspire confidence."
	icon_state = "tram_controls"
	base_icon_state = "tram_"
	icon_screen = "tram_Central Wing_idle"
	icon_keyboard = null
	layer = SIGN_LAYER
	density = FALSE
	circuit = /obj/item/circuitboard/computer/tram_controls
	flags_1 = NODECONSTRUCT_1 | SUPERMATTER_IGNORES_1
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	light_color = COLOR_BLUE_LIGHT
	light_range = 0 //we dont want to spam SSlighting with source updates every movement

	///Weakref to the tram piece we control
	var/datum/weakref/tram_ref

	var/specific_lift_id = MAIN_STATION_TRAM

/obj/machinery/computer/icts_controls/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	AddComponent(/datum/component/usb_port, list(/obj/item/circuit_component/tram_controls))
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/icts_controls/LateInitialize()
	. = ..()
	find_tram()

	var/datum/lift_master/tram/tram_part = tram_ref?.resolve()
	if(tram_part)
		RegisterSignal(tram_part, COMSIG_TRAM_SET_TRAVELLING, PROC_REF(update_tram_display))

/**
 * Finds the tram from the console
 *
 * Locates tram parts in the lift global list after everything is done.
 */
/obj/machinery/computer/icts_controls/proc/find_tram()
	for(var/datum/lift_master/lift as anything in GLOB.active_lifts_by_type[TRAM_LIFT_ID])
		if(lift.specific_lift_id == specific_lift_id)
			tram_ref = WEAKREF(lift)

/obj/machinery/computer/icts_controls/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/obj/machinery/computer/icts_controls/ui_status(mob/user,/datum/tgui/ui)
	var/datum/lift_master/tram/tram = tram_ref?.resolve()

	if(tram?.travelling)
		return UI_CLOSE
	if(!in_range(user, src) && !isobserver(user))
		return UI_CLOSE
	return ..()

/obj/machinery/computer/icts_controls/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TramControl", name)
		ui.open()

/obj/machinery/computer/icts_controls/ui_data(mob/user)
	var/datum/lift_master/tram/tram_lift = tram_ref?.resolve()
	var/list/data = list()
	data["moving"] = tram_lift?.travelling
	data["broken"] = tram_lift ? FALSE : TRUE
	var/obj/effect/landmark/tram/current_loc = tram_lift?.idle_platform
	if(current_loc)
		data["tram_location"] = current_loc.name
	return data

/obj/machinery/computer/icts_controls/ui_static_data(mob/user)
	var/list/data = list()
	data["destinations"] = get_destinations()
	return data

/**
 * Finds the destinations for the tram console gui
 *
 * Pulls tram landmarks from the landmark gobal list
 * and uses those to show the proper icons and destination
 * names for the tram console gui.
 */
/obj/machinery/computer/icts_controls/proc/get_destinations()
	. = list()
	for(var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[specific_lift_id])
		var/list/this_destination = list()
		this_destination["name"] = destination.name
		this_destination["dest_icons"] = destination.tgui_icons
		this_destination["id"] = destination.platform_code
		. += list(this_destination)

/obj/machinery/computer/icts_controls/ui_act(action, params)
	. = ..()
	if (.)
		return

	switch (action)
		if ("send")
			var/obj/effect/landmark/tram/destination_platform
			for (var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[specific_lift_id])
				if(destination.platform_code == params["destination"])
					destination_platform = destination
					break

			if (!destination_platform)
				return FALSE

			return try_send_tram(destination_platform)

/// Attempts to sends the tram to the given destination
/obj/machinery/computer/icts_controls/proc/try_send_tram(obj/effect/landmark/tram/destination_platform)
	var/datum/lift_master/tram/tram_part = tram_ref?.resolve()
	if(!tram_part)
		return FALSE
	if(tram_part.controls_locked || tram_part.travelling) // someone else started already
		return FALSE
	tram_part.tram_travel(destination_platform)
	say("The next station is: [destination_platform.name]")
	update_appearance()
	return TRUE

/obj/machinery/computer/icts_controls/proc/update_tram_display(obj/effect/landmark/tram/idle_platform, travelling)
	SIGNAL_HANDLER
	var/datum/lift_master/tram/tram_part = tram_ref?.resolve()
	if(travelling)
		icon_screen = "[base_icon_state][tram_part.idle_platform.name]_active"
	else
		icon_screen = "[base_icon_state][tram_part.idle_platform.name]_idle"
	update_appearance(UPDATE_ICON)
	return PROCESS_KILL

/obj/machinery/computer/icts_controls/power_change() // Change tram operating status on power loss/recovery
	. = ..()
	var/datum/lift_master/tram/tram_part = tram_ref?.resolve()
	update_operating()
	if(tram_part)
		if(!tram_part.travelling)
			if(is_operational)
				for(var/obj/machinery/crossing_signal/xing as anything in GLOB.tram_signals)
					xing.set_signal_state(XING_STATE_MALF, TRUE)
				for(var/obj/machinery/destination_sign/desto as anything in GLOB.tram_signs)
					desto.icon_state = "[desto.base_icon_state][DESTINATION_OFF]"
					desto.update_appearance()
			else
				for(var/obj/machinery/crossing_signal/xing as anything in GLOB.tram_signals)
					xing.set_signal_state(XING_STATE_MALF, TRUE)
				for(var/obj/machinery/destination_sign/desto as anything in GLOB.tram_signs)
					desto.icon_state = "[desto.base_icon_state][DESTINATION_NOT_IN_SERVICE]"
					desto.update_appearance()

/obj/machinery/computer/icts_controls/proc/update_operating() // Pass the operating status from the controls to the lift_master
	var/datum/lift_master/tram/tram_part = tram_ref?.resolve()
	if(tram_part)
		if(machine_stat & NOPOWER)
			tram_part.is_operational = FALSE
		else
			tram_part.is_operational = TRUE
