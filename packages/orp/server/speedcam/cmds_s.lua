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
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if speed == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(s)peed(c)am <speed>")
	end

	speed = tonumber(speed)

	if speed < 10 or speed > 100 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Speed must be between 10 to 100.</>")
	end

	local x, y, z = GetPlayerLocation(player)

	local speedcam = Speedcam_Create(x, y, z, speed)
	if speedcam == false then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Speedcam wasn't able to be created.</>")
	else
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Speedcam (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), speedcam))
	end
	return
end

AddCommand('acreatespeedcam', cmd_acsc)
AddCommand('acsc', cmd_acsc)

local function cmd_aesc(player, speedcam, prefix, ...)

	if (PlayerData[player].admin < 4) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
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

		if IsValidText3D(SpeedcamData[speedcam].text3d) then
			DestroyText3D(SpeedcamData[speedcam].text3d)
		end

		SpeedcamData[speedcam].text3d = CreateText3D("Speedcam ("..speedcam..")\nSpeed: "..SpeedcamData[speedcam].speed.." KM/H", 20, SpeedcamData[speedcam].x, SpeedcamData[speedcam].y, SpeedcamData[speedcam].z, 0.0, 0.0, 0.0)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Speedcam (ID: "..speedcam..") speed limit is now set to "..speed..".</>")

	elseif prefix == "location" then

		local x, y, z = GetPlayerLocation(player)

		SpeedcamData[speedcam].x = x
		SpeedcamData[speedcam].y = y
		SpeedcamData[speedcam].z = z

		SetObjectLocation(SpeedcamData[speedcam].objectid, x, y, z)

		if IsValidText3D(SpeedcamData[speedcam].text3d) then
			DestroyText3D(SpeedcamData[speedcam].text3d)
		end

		SpeedcamData[speedcam].text3d = CreateText3D("Speedcam ("..speedcam..")\nSpeed: "..SpeedcamData[speedcam].speed.." KM/H", 20, SpeedcamData[speedcam].x, SpeedcamData[speedcam].y, SpeedcamData[speedcam].z, 0.0, 0.0, 0.0)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Speedcam (ID: "..speedcam..") position changed.</>")
	end

	return
end

AddCommand('aeditspeedcam', cmd_aesc)
AddCommand('aesc', cmd_aesc)