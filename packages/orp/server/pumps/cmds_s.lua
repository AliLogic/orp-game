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

	if PumpData[id].is_occupied ~= 0 then
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

	PumpData[id].is_occupied = playerid
	PumpData[id].timer = CreateTimer(OnPumpTick, 1000, id, vehicle)
end)

AddCommand("fill", function (playerid)

	local vehicleid = GetNearestVehicle(playerid)

	if (IsPlayerInVehicle(playerid) or vehicleid == 0) then
		return AddPlayerChatError(playerid, "You are not standing near any vehicle.")
	end

	if (not Inventory_HasItem(playerid, INV_ITEM_FUELCAN)) then
		return AddPlayerChatError(playerid, "You don't have any fuel cans on you.")
	end

	if (GetVehicleEngineState(vehicleid)) then
		return AddPlayerChatError(playerid, "You must shut off the engine first.")
	end

	if (GetVehicleFuel(vehicleid) > 95) then
		return AddPlayerChatError(playerid, "This vehicle doesn't need any fuel.")
	end

	if (PlayerData[playerid].fuel_can) then
		return AddPlayerChatError(playerid, "You are already using a can of fuel.")
	end

	PlayerData[playerid].fuel_can = 1

	Inventory_GiveItem(playerid, INV_ITEM_FUELCAN, -1)

	local x, y, z = GetPlayerLocation(playerid)
	AddPlayerChatRange(x, y, 800.0, "* " .. GetPlayerName(playerid) .. " opens a can of fuel and fills the vehicle.")

	SetVehicleFuel(vehicleid, 100)
	return
end)

AddCommand("gotopump", function (playerid, pumpid)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "ou don't have permission to use this command.")
	end

	if pumpid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /gotopump <pump>")
	end

	pumpid = tonumber(pumpid)

	if PumpData[pumpid] == nil then
		return AddPlayerChatError(playerid, "Pump " .. pumpid .. "doesn't exist.")
	end

	SetPlayerLocation(playerid, PumpData[pumpid].x, PumpData[pumpid].y, PumpData[pumpid].z)

	AddPlayerChat(playerid, "You have been teleported to pump ID: " .. pumpid ..".")
end)