--[[
Copyright (C) 2020 Onset Roleplay

Developers:
* Logic_

Contributors:
* Blue Mountains GmbH
* Kuzkay (( for the undermap script ))
]]--

local MapTime = 5 * 1000 -- 5 seconds
local MapTimer = 0

-- Functions

local function PlayerUnderMapCheck()

	local x, y, z = GetPlayerLocation()
	local height = GetTerrainHeight(x, y, z)

	if z < 0 and height - 400 > z and not IsPlayerInVehicle() then
		CallRemoteEvent("OnPlayerUnderMap", height)
	end
end

-- Events

AddEvent("OnPackageStart", function()

	Delay(MapTime, function ()
		MapTimer = CreateTimer(PlayerUnderMapCheck, MapTime)
	end)
end)