--[[
	PHONE SYSTEM

	[ ] Extensive cell plans with different abilties.
	[ ] Lose signal on Mountain?
	[ ] Free (and secured) wifi at restaurants?
	[ ] Personal wifi at home?
	[ ] Wifi on phone.  Routers willhave SSID's and passwords.  Players will need to add routers.
	[ ] "What's the time?"  Time synchronization.
	[ ] "Do we get notifications?"  Notifications in the chat, phone and an indicator flash LED on phone.
	[x] Texting, Calling and Data.  Unlimited and limited.
	[ ] Cell Towers placed around Onset.  Lose signal with distance.
	[ ] Change wallpapers.
	[ ] Sound profile modes.
	[ ] SMS
	[ ] CALL
	[ ] HANGUP CALL
	[ ] PICKUP CALL
	[ ] Purchasing packages
]]--

PlayerPhoneData = {}

CellTowerData = {}

PhoneTypes = {
	{
		phone_name = "Starkers", -- Apple iPhone
		has_data = true
	},
	{
		phone_name = "Brick", -- Brick Phone
		has_data = false,
	}
}

CellPlans = {
	--[[ LIMITED/ UNLIMITED TEXTING ONLY ]]--
	{
		plan_name = "Limited Texting (10 mins)",

		texting = true,
		text_limited = true,

		calling = false,
		call_limited = false,

		data = false,
		data_limited = false,

		minutes = 10,
		data_amount = 0
	},
	{
		plan_name = "Limited Texting (25 mins)",

		texting = true,
		text_limited = true,

		calling = false,
		call_limited = false,

		data = false,
		data_limited = false,

		minutes = 25,
		data_amount = 0
	},
	{
		plan_name = "Limited Texting (50 mins)",

		texting = true,
		text_limited = true,

		calling = false,
		call_limited = false,

		data = false,
		data_limited = false,

		minutes = 50,
		data_amount = 0
	},
	{
		plan_name = "Unlimited Texting",

		texting = true,
		text_limited = false,

		calling = false,
		call_limited = false,

		data = false,
		data_limited = false,

		minutes = 0,
		data_amount = 0
	},
	--[[ LIMITED TEXTING AND CALLING ONLY ]]--
	{
		plan_name = "Limited Texting and Calling (15 min)",

		texting = true,
		text_limited = true,

		calling = true,
		call_limited = true,

		data = false,
		data_limited = false,

		minutes = 15,
		data_amount = 0
	},
	{
		plan_name = "Limited Texting and Calling (30 min)",

		texting = true,
		text_limited = true,

		calling = true,
		call_limited = true,

		data = false,
		data_limited = false,

		minutes = 30,
		data_amount = 0
	},
	{
		plan_name = "Limited Texting and Calling (60 min)",

		texting = true,
		text_limited = true,

		calling = true,
		call_limited = true,

		data = false,
		data_limited = false,

		minutes = 60,
		data_amount = 0
	},
	-- [[ UNLIMITED TEXTING AND LIMITED CALLING ONLY ]]--
	{
		plan_name = "Unlimited Texting, Limited Calling (15 min)",

		texting = true,
		text_limited = true,

		calling = true,
		call_limited = true,

		data = false,
		data_limited = false,

		minutes = 15,
		data_amount = 0
	},
	{
		plan_name = "Unlimited Texting, Limited Calling (30 min)",

		texting = true,
		text_limited = true,

		calling = true,
		call_limited = true,

		data = false,
		data_limited = false,

		minutes = 30,
		data_amount = 0
	},
	{
		plan_name = "Unlimited Texting, Limited Calling (60 min)",

		texting = true,
		text_limited = true,

		calling = true,
		call_limited = true,

		data = false,
		data_limited = false,

		minutes = 60,
		data_amount = 0
	},
	-- [[ UNLIMITED TEXTING AND UNLIMITED CALLING ONLY ]]--
	{
		plan_name = "Unlimited Texting and Calling",

		texting = true,
		text_limited = false,

		calling = true,
		call_limited = false,

		data = false,
		data_limited = false,

		minutes = 0,
		data_amount = 0
	},
	-- [[ UNLIMITED TEXTING AND UNLIMITED CALLING AND LIMITED DATA ]]--
	{
		plan_name = "Unlimited Texting and Calling, Limited Data",

		texting = true,
		text_limited = false,

		calling = true,
		call_limited = false,

		data = true,
		data_limited = true,

		minutes = 0,
		data_amount = 25
	},
	{
		plan_name = "Unlimited Texting and Calling, Limited Data",

		texting = true,
		text_limited = false,

		calling = true,
		call_limited = false,

		data = true,
		data_limited = true,

		minutes = 0,
		data_amount = 50
	},
	{
		plan_name = "Unlimited Texting and Calling, Limited Data",

		texting = true,
		text_limited = false,

		calling = true,
		call_limited = false,

		data = true,
		data_limited = true,

		minutes = 0,
		data_amount = 100
	},
	-- [[ UNLIMITED EVERYTHING ]]--
	{
		plan_name = "Unlimited Everything",

		texting = true,
		text_limited = false,

		calling = true,
		call_limited = false,

		data = true,
		data_limited = false,

		minutes = 0,
		data_amount = 0
	}
}

local MIN_BALANCE = 5 -- cost in cents
local SMS_BALANCE = 2 -- cost in cents per message
local CALL_BALANCE = 4 -- cost in cents per second

function CreatePlayerPhoneData(playerid)
	PlayerPhoneData[playerid] = {
		balance = 0, -- balance in cents
		free_sms = 0, -- free sms count
		free_mins = 0, -- free call minutes
		cell_plan = 0, -- cell plan
		phone_numer = 0, -- phone number
		has_phone = 0, -- has phone bool
		loudspeaker = false, -- loudspeaker
		phone_off = true -- phone status bool
	}
end

function DestroyPlayerPhoneData(playerid)
	PlayerPhoneData[playerid] = {}
end

function GetPlayerBalance(playerid)
	return PlayerPhoneData[playerid].balance
end

function IsPlayerPhoneOff(playerid)
	return PlayerPhoneData[playerid].phone_off
end

function IsPlayerPhoneCooldown(playerid)
	return (PlayerPhoneData[playerid].cooldown > GetTimeSeconds()) -- os.time(os.date("!*t"))
end

function SetPlayerCooldown(playerid, seconds)

	if not IsValidPlayer(playerid) then
		return false
	end

	PlayerPhoneData[playerid].cooldown = GetTimeSeconds() + seconds
	return true
end

local function cmd_sms(playerid, phonenumber, ...)

	if not IsPlayerAlive(playerid) then
		return AddPlayerChatError(playerid, "You can't use your phone right now.")
	end

	if IsPlayerPhoneOff(playerid) then
		return AddPlayerChatError(playerid, "Your cellphone is turned off.");
	end

	if IsPlayerHandcuffed(playerid) == 1 then
		return AddPlayerChatError(playerid, "You can't use your phone right now.")
	end

	if IsPlayerPhoneCooldown(playerid) then
		return AddPlayerChatError(playerid, "Please wait before using this command.")
	end

	if phonenumber == nil or #{...} then
		return AddPlayerChat(playerid, "USAGE: /sms <phone number> <message>")
	end

	local msg = table.concat({...}, " ")

	AddPlayerChat(playerid, "Your text message is being sent.");

	SetPlayerChatBubble(playerid, "* "..GetPlayerName(playerid).." takes out their cellphone.", 4)

	-- send the sms to the number (error if number is inactive)
	-- send the sms to the player
end

AddCommand("sms", cmd_sms)
AddCommand("rcs", cmd_sms)

AddCommand("louspeaker", function (playerid)

	if not IsPlayerAlive(playerid) then
		return AddPlayerChatError(playerid, "You can't use your phone right now.")
	end

	if IsPlayerPhoneOff(playerid) then
		return AddPlayerChatError(playerid, "Your cellphone is turned off.");
	end

	if IsPlayerHandcuffed(playerid) == 1 then
		return AddPlayerChatError(playerid, "You can't use your phone right now.")
	end

	if IsPlayerPhoneCooldown(playerid) then
		return AddPlayerChatError(playerid, "Please wait before using this command.")
	end

	PlayerPhoneData[playerid].loudspeaker = not PlayerPhoneData[playerid].loudspeaker

	local x, y, z = GetPlayerLocation(playerid)

	if (PlayerPhoneData[playerid].loudspeaker) then
		AddPlayerChatRange(x, y, 400.0, "<span color=\"#ffffffFF\">* "..GetPlayerName(playerid).." turns their phones loudspeaker on.</>")
	else
		AddPlayerChatRange(x, y, 400.0, "<span color=\"#ffffffFF\">* "..GetPlayerName(playerid).." turns their phones loudspeaker off.</>")
	end
end)