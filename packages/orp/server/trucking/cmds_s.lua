--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_
* Bork

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

-- Functions
function IsPlayerInTruck(player)
	if IsPlayerInVehicle(player) == false then return false end

	local model = GetVehicleModel(GetPlayerVehicle(player))

	for i = 1, #Vehicles, 1 do
		if model == Vehicles[i].id then
			return true
		end
	end
	return false
end

-- Events
AddCommand("tpda", function (player, prefix)
	if GetPlayerJob(player) ~= JOB_TYPE_TRUCKER then
		return AddPlayerChat(player, "<span color=\""..Colours.lightred.."\">Error: You must be a trucker to use this command!</>")
	end

	if prefix == nil then
		AddPlayerChat(player, "<span color=\""..Colours.lightred.."\">Usage:</> /tpda [prefix]")
		AddPlayerChat(player, "Prefixes: industries, businesses, ship")
		return
	end

	return true
end)