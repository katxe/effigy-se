/obj/item/clothing/under/rank/medical
	worn_icon_digi = 'packages/clothing/assets/mob/under/medical_digi.dmi'	// Anything that was in the medical.dmi, should be in the medical_digi.dmi

/obj/item/clothing/under/rank/medical/doctor/skyrat
	icon = 'packages/clothing/assets/obj/under/medical.dmi'
	worn_icon = 'packages/clothing/assets/mob/under/medical.dmi'


/obj/item/clothing/under/rank/medical/scrubs/skyrat
	icon = 'packages/clothing/assets/obj/under/medical.dmi'
	worn_icon = 'packages/clothing/assets/mob/under/medical.dmi'
	icon_state = "scrubswhite" // Because for some reason TG's scrubs dont have an icon on their basetype
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one seems to be the original Scrub."
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_MONKEY_VARIATION

/obj/item/clothing/under/rank/medical/chemist/skyrat
	icon = 'packages/clothing/assets/obj/under/medical.dmi'
	worn_icon = 'packages/clothing/assets/mob/under/medical.dmi'

/obj/item/clothing/under/rank/medical/paramedic/skyrat
	icon = 'packages/clothing/assets/obj/under/medical.dmi'
	worn_icon = 'packages/clothing/assets/mob/under/medical.dmi'

/obj/item/clothing/under/rank/medical/chief_medical_officer/skyrat
	icon = 'packages/clothing/assets/obj/under/medical.dmi'
	worn_icon = 'packages/clothing/assets/mob/under/medical.dmi'

/*
*	DOCTOR
*/

/obj/item/clothing/under/rank/medical/doctor/skyrat/utility
	name = "medical utility uniform"
	desc = "A utility uniform worn by Medical doctors."
	icon_state = "util_med"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION | CLOTHING_MONKEY_VARIATION

/obj/item/clothing/under/rank/medical/doctor/skyrat/utility/syndicate
	armor_type = /datum/armor/utility_syndicate
	has_sensor = NO_SENSORS

/*
*	SCRUBS
*/

/obj/item/clothing/under/rank/medical/scrubs/skyrat/red
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in a deep red."
	icon_state = "scrubsred"

/obj/item/clothing/under/rank/medical/scrubs/skyrat/white
	desc = "It's made of a special fiber that provides minor protection against biohazards. This one is in a cream white colour."
	icon_state = "scrubswhite"

/*
*	CHEMIST
*/

/obj/item/clothing/under/rank/medical/chemist/skyrat/formal
	name = "chemist's formal jumpsuit"
	desc = "A white shirt with left-aligned buttons and an orange stripe, lined with protection against chemical spills."
	icon_state = "pharmacologist"

/obj/item/clothing/under/rank/medical/chemist/skyrat/formal/skirt
	name = "chemist's formal jumpskirt"
	icon_state = "pharmacologist_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/*
*	PARAMEDIC
*/

/obj/item/clothing/under/rank/medical/paramedic/skyrat/light
	name = "light paramedic uniform"
	desc = "A brighter variant of the typical Paramedic uniform made with special fibers that provide minor protection against biohazards, this one has the reflective strips removed."
	icon_state = "paramedic_light"

/obj/item/clothing/under/rank/medical/paramedic/skyrat/light/skirt
	name = "light paramedic skirt"
	desc = "A brighter variant of the typical Paramedic uniform made with special fibers that provide minor protection against biohazards, this one has had it's legs replaced with a skirt."
	icon_state = "paramedic_light_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/*
*	CHIEF MEDICAL OFFICER
*/

/obj/item/clothing/under/rank/medical/chief_medical_officer/skyrat/imperial //Rank pins of the Brigadier General
	desc = "A teal, sterile naval suit with a rank badge denoting the Officer of the Medical Corps. Doesn't protect against blaster fire."
	name = "chief medical officer's naval jumpsuit"
	icon_state = "impcmo"
