--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_
* Bork

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage('colours')

-- Commands

AddCommand("callsign", function (player, callsign)
	if GetPlayerFactionType(player) ~= FACTION_POLICE and GetPlayerFactionType(player) ~= FACTION_MEDIC and GetPlayerFactionType(player) ~= FACTION_GOV then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be apart of a government agency to use this command.")
	end

	local vehicle = GetPlayerVehicle(player)

	if vehicle == 0 then
		return AddPlayerChatError(player, "You must be in a vehicle.")
	end

	local faction = GetFactionType(VehicleData[vehicle].faction)

	if VehicleData[vehicle] == nil or (faction == FACTION_CIVILIAN or faction == FACTION_NONE) then
		return AddPlayerChatError(player, "You must be in a faction owned vehicle.")
	end

	if VehicleData[vehicle].callsign ~= 0 and IsValidText3D(VehicleData[vehicle].callsign) then
		SetText3DAttached(VehicleData[vehicle].callsign, ATTACH_NONE, 0, 0.0, 0.0, 0.0)
		DestroyText3D(VehicleData[vehicle].callsign)
		VehicleData[vehicle].callsign = 0
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Your previous callsign was destroyed!")
		return

	elseif callsign == nil then

		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /callsign <text>")
	end

	local length = string.len(callsign)

	if length < 0 or length > 12 then
		return AddPlayerChatError(player, "Callsign length ranges from 1 - 12.")
	end

	VehicleData[vehicle].callsign = CreateText3D(callsign, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	SetText3DAttached(VehicleData[vehicle].callsign, ATTACH_VEHICLE, vehicle, -260, -60, 140, 0.0, 0.0, 0.0) -- coords need adjustments

	AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Callsign "..callsign.." attached!")
end)

-- Events

AddEvent("UnloadCallsigns", function ()
	for i = 1, #VehicleData, 1 do
		if VehicleData[i].callsign ~= 0 and IsValidText3D(VehicleData[i].callsign) then
			DestroyText3D(VehicleData[i].callsign)
		end
	end
	return
end)