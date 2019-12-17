--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork

Contributors:
* Blue Mountains GmbH
]]--

AddEvent("OnPlayerJoin", function (player)
	SetPlayerDimension(player, player)
    SetPlayerSpawnLocation(player, 179796.234375, 10621.763671875, 10394.176757813, 90.0)
    CallRemoteEvent(player, "FreezePlayer")    
end)

AddEvent("OnPlayerDeath", function (player, instigator)
	AddPlayerChatAll(GetPlayerName(player).." has died!")
end)

AddEvent("OnPlayerQuit", function (player)
	AddPlayerChatAll(GetPlayerName(player).." has left the server!")
end)

function fexist(filename) return file_exists(filename) end
function file_exists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end
