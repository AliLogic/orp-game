--[[
Copyright (C) 2020 Onset Roleplay

Developers:
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Remote Events

AddRemoteEvent("OnPlayerUnderMap", function (playerid, height)
	local x, y, z = GetPlayerLocation(playerid)
	SetPlayerLocation(playerid, x, y, height + 200)
end)