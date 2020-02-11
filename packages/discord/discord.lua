--[[
	Message Styles:
	plain - Plain Text
	code - Code Block
	quotation - Quotation
]]
function SendMessage(channel, style, message)
	channel = channel or nil
	message = message or nil
	style = style or "plain"
	
	if channel == nil or message == nil then
		return false
	end

	if style ~= "plain" and style ~= "code" and style ~= "quotation" then
		return false
	end

	local r = http_create()
	--http_set_resolver_protocol(r, "ipv4")
	http_set_protocol(r, "http")
	http_set_host(r, "localhost")
	http_set_port(r, 3010)
	http_set_target(r, "/discord/sendMessage/")
	http_set_verb(r, "post")
	http_set_timeout(r, 30)
	http_set_version(r, 11)
	http_set_keepalive(r, true)
	http_set_field(r, "user-agent", "Onset Server "..GetGameVersionString())
	
	local body = string.format("channel=%s?style=%s?message=%s", channel, style, message)
	
	http_set_body(r, body)
	http_set_field(r, "content-length", string.len(body))
	http_set_field(r, "content-type", "application/x-www-form-urlencoded; charset=utf-8")
	
	if http_send(r, OnPostComplete, 1, 3.14, "OK s") == false then
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

function OnPostComplete(a, b, c)
	print("OnPostComplete:", a, b, c)
end

AddFunctionExport("SendMessage", SendMessage)
AddFunctionExport("Channel", Channel)
--AddFunctionExport("Embed", Embed)