--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork

Contributors:
* Blue Mountains GmbH
]]--

AddEvent("OnPlayerJoin", function (player)
	SetPlayerDimension(player, player)
    SetPlayerSpawnLocation(player, 170694.515625, 194947.453125, 1396.9643554688, 90.0)
end)

AddEvent("OnPlayerSpawn", function(player)
    if PlayerData[player] ~= nil then
        if PlayerData[player].logged_in ~= false then
            if PlayerData[player].label ~= nil then
                if IsValidText3D(PlayerData[player].label) then
                    DestroyText3D(PlayerData[player].label)
                end
            end
        end
    end
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
