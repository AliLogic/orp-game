--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--

local colour = ImportPackage('colours')

local function cmd_acsc(player, speed)

	if (PlayerData[player].admin < 4) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if speed == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(s)peed(c)am <speed>")
	end

	speed = tonumber(speed)

	if speed < 10 or speed > 100 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Speed must be between 10 to 100.</>")
	end

	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)

	local speedcam = Speedcam_Create(x, y, z - 99, h, speed)
	if speedcam == false then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Speedcam wasn't able to be created.</>")
	else
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Speedcam (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), speedcam))
		Slap(player)
	end
	return
end

AddCommand('acreatespeedcam', cmd_acsc)
AddCommand('acsc', cmd_acsc)

local function cmd_aesc(player, speedcam, prefix, ...)

	if (PlayerData[player].admin < 4) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if speedcam == nil or prefix == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(s)peed(c)am <speedcam> <prefix>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> speed, location")
	end

	speedcam = tonumber(speedcam)

	if SpeedcamData[speedcam] == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Speedcam "..speedcam.." doesn't exist or isn't valid.</>")
	end

	local args = {...}

	if prefix == "speed" then

		local speed = args[1]

		if speed == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(s)peed(c)am <speedcam> speed <speed>")
		end

		speed = tonumber(speed)

		if speed < 0 or speed > 100 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Speed must be between 10 to 100.</>")
		end

		SpeedcamData[speedcam].speed = speed

		SetText3DText(SpeedcamData[speedcam].text3d, "Speedcam ("..speedcam..")\nSpeed: "..SpeedcamData[speedcam].speed.." MPH")

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Speedcam (ID: "..speedcam..") speed limit is now set to "..speed..".</>")

	elseif prefix == "location" then

		local x, y, z = GetPlayerLocation(player)
		local h = GetPlayerHeading(player)

		SpeedcamData[speedcam].x = x
		SpeedcamData[speedcam].y = y
		SpeedcamData[speedcam].z = (z - 99)
		SpeedcamData[speedcam].h = h

		SetObjectLocation(SpeedcamData[speedcam].objectid, x, y, (z - 99))
		SetObjectRotation(SpeedcamData[speedcam].objectid, 0.0, h, 0.0)

		if IsValidText3D(SpeedcamData[speedcam].text3d) then
			DestroyText3D(SpeedcamData[speedcam].text3d)
		end

		SpeedcamData[speedcam].text3d = CreateText3D("Speedcam ("..speedcam..")\nSpeed: "..SpeedcamData[speedcam].speed.." MPH", 20, SpeedcamData[speedcam].x, SpeedcamData[speedcam].y, SpeedcamData[speedcam].z + 180.0, 0.0, 0.0, 0.0)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Speedcam (ID: "..speedcam..") position changed.</>")
	else
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(s)peed(c)am <speedcam> <prefix>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> speed, location")
	end

	return
end

AddCommand('aeditspeedcam', cmd_aesc)
AddCommand('aesc', cmd_aesc)

AddCommand("gotospeedcam", function (playerid, speedcamid)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if speedcamid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /gotospeedcam <speedcam>")
	end

	speedcamid = tonumber(speedcamid)

	if SpeedcamData[speedcamid] == nil then
		return AddPlayerChatError(playerid, "Speedcam " .. speedcamid .. " doesn't exist.")
	end

	SetPlayerLocation(playerid, SpeedcamData[speedcamid].x, SpeedcamData[speedcamid].y, SpeedcamData[speedcamid].z)

	AddPlayerChat(playerid, "You have been teleported to speedcam ID: " .. speedcamid ..".")
end)