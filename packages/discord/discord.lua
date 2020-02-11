--[[
	Message Types:
	plain - Plain Text
	code - Code Block
	quotation - Quotation
	dm - Direct Message
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
	http_set_host(r, "localhost")
	http_set_port(r, 3997)
	http_set_target(r, "/discord/post")
	http_set_verb(r, "post")
	http_set_timeout(r, 30)
	http_set_version(r, 11)
	http_set_keepalive(r, true)
	http_set_field(r, "user-agent", "Onset Server "..GetGameVersionString())
	http_set_field(r, "Token", "borkland!")

	print(channel, style, message)
	local body = string.format("channelid=%s&type=%s&message=%s", channel, style, message)
	
	http_set_body(r, body)
	http_set_field(r, "content-length", string.len(body))
	http_set_field(r, "content-type", "application/x-www-form-urlencoded; charset=utf-8")
	
	if http_send(r, OnPostComplete, "OK", r) == false then
		print("HTTP REQ NOT SENT :(")
		http_destroy(r)
		return false
	else
		return true
	end
end

function SendEmbed(channel, Embed)
	channel = channel or nil
	if channel == nil then
		return false
	end

	return false -- Incomplete function.
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
AddFunctionExport("Channel", Channel)
--AddFunctionExport("Embed", Embed)