--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

local colour = ImportPackage('colours')

AddCommand("refuel", function (playerid)

	if GetPlayerState(playerid) ~= PS_DRIVER then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be in the driver seat.</>")
	end

	local vehicle = GetPlayerVehicle(playerid)

	if GetVehicleEngineState(vehicle) ~= false then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must turn the engine off first.</>")
	end

	local id = Pump_Nearest(playerid)

	if id == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in range of any gas pump.</>")
	end

	if PumpData[id].is_occupied then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This fuel pump is already occupied.")
	end

	if VehicleData[vehicle].fuel > 95 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This vehicle doesn't need any fuel.</>")
	end

	if PumpData[id].litres == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This pump doesn't have enough fuel.")
	end

	local x, y, z = GetPlayerLocation(playerid)
	AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." has started refilling their vehicle.")

	PumpData[id].is_occupied = true
	PumpData[id].timer = CreateTimer(OnPumpTick, 1000, id, playerid, vehicle)
end)