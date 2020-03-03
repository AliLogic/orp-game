--[[
	Message Types:
	plain - Plain Text
	code - Code Block
	quotation - Quotation
	dm - Direct Message
	embed - embed
]]
function SendMessage(channel, style, message)
	channel = channel or nil
	message = message or nil
	style = style or "plain"

	if channel == nil or message == nil or channel == false then
		return false
	end

	if style ~= "plain" and style ~= "code" and style ~= "quotation" and style ~= "dm" then
		return false
	end

	local r = http_create()
	http_set_resolver_protocol(r, "ipv4")
	http_set_protocol(r, "http")
	http_set_host(r, "127.0.0.1")
	http_set_port(r, 3997)
	http_set_target(r, "/discord/post/")
	http_set_verb(r, "post")
	http_set_timeout(r, 30)
	http_set_version(r, 11)
	http_set_keepalive(r, true)
	http_set_field(r, "User-Agent", "Onset Server "..GetGameVersionString())
	http_set_field(r, "Token", "borkland!")

	local body = json_encode({type = style, channelid = channel, message = message})

	http_set_body(r, body)
	http_set_field(r, "Content-Length", string.len(body))
	http_set_field(r, "Content-Type", "application/json")

	local status = false

	if http_send(r, OnPostComplete, "OK", r) == false then
		print("HTTP REQ NOT SENT :(")
		status = false
	else
		status = true
	end

	http_destroy(r)
	return status
end

function SendEmbed(channel, embed)
	channel = channel or nil
	embed = embed or nil

	if channel == nil then return false end
	if embed == nil then return false end
	if embed.colour == nil or embed.title == nil or embed.description == nil or embed.fields == nil then return false end

	local r = http_create()
	http_set_resolver_protocol(r, "ipv4")
	http_set_protocol(r, "http")
	http_set_host(r, "127.0.0.1")
	http_set_port(r, 3997)
	http_set_target(r, "/discord/post/")
	http_set_verb(r, "post")
	http_set_timeout(r, 30)
	http_set_version(r, 11)
	http_set_keepalive(r, true)
	http_set_field(r, "User-Agent", "Onset Server "..GetGameVersionString())
	http_set_field(r, "Token", "borkland!")

	local body = json_encode({type = 'embed', channelid = channel, colour = embed.colour, title = embed.title, description = embed.description, fields = embed.fields})

	http_set_body(r, body)
	http_set_field(r, "Content-Length", string.len(body))
	http_set_field(r, "Content-Type", "application/json")

	local status = false

	if http_send(r, OnPostComplete, "OK", r) == false then
		print("HTTP REQ NOT SENT :(")
		http_destroy(r)
		status = false
	else
		status = true
	end

	http_destroy(r)
	return status
end

function Channel(channel)
	if string.len(channel) ~= 18 then
		return false
	else
		return channel
	end
end

function Embed()
	return Embed:New()
end

function OnPostComplete(a, http)
	print("OnPostComplete:", a, http)

	if http_is_error(http) then
		print("OnHttpRequestComplete failed for id", http..": "..http_result_error(http))
	else
		print("OnHttpRequestComplete succeeded for id", http)
		print_active_results(http)
	end

	http_destroy(http)
end

function print_active_results(http)
	local body = http_result_body(http)
	local header = http_result_header(http)
	local status = http_result_status(http)

	print("\tBody: ", body)
	print("\tHTTP Status: ", status)
	print("\t Headers:")
	for k, v in pairs(header) do
		print("\t", k, v)
	end
end

AddFunctionExport("SendMessage", SendMessage)
AddFunctionExport("SendEmbed", SendEmbed)
AddFunctionExport("Channel", Channel)
AddFunctionExport("Embed", Embed)