/// Effigy API Endpoint Config
/datum/effigy_message_type
	/// Message type of request
	var/endpoint
	/// API URL of the endpoint
	var/url
	/// The HTTP method of this endpoint
	var/method

/datum/effigy_message_type/new_ticket
	endpoint = EFFIGY_ENDPOINT_NEW_TICKET
	method = RUSTG_HTTP_METHOD_POST

/datum/effigy_message_type/get
	method = RUSTG_HTTP_METHOD_GET

/// Generates the request header
/datum/effigy_message_type/proc/construct_api_message_header(efapi_auth, efapi_key)
	var/list/processed_content = list(
		"Authorization" = "[efapi_auth] [efapi_key]",
		"content-type" = "application/x-www-form-urlencoded"
		)
	return processed_content

/// Generates the request body
/datum/effigy_message_type/proc/construct_api_message_body(list/raw_content)
	var/list/processed_content = list(
		"forum=[raw_content["box"]]",
		"author=[raw_content["link_id"]]",
		"title=\[[GLOB.round_id]] [raw_content["title"]]",
		"post=[raw_content["message"]]"
	)

	var/joined = jointext(processed_content, "&")
	return joined

/datum/effigy_message_type/proc/create_http_request(content)
	// Set up the required headers for the Effigy API
	var/list/headers = construct_api_message_header(SSeffigy.efapi_auth, SSeffigy.efapi_key)

	// Create the JSON body for the request
	var/body = construct_api_message_body(content)

	// Make the API URL
	url = "[SSeffigy.efapi_url]?[endpoint]"

	// Create a new HTTP request
	var/datum/http_request/request = new()

	// Set up the HTTP request
	request.prepare(method, url, body, headers)

	return request
