--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork

Contributors:
* Blue Mountains GmbH
]]--

AddCommand("pos", function (player, id)
	local x, y, z = GetPlayerLocation(player)
	return AddPlayerChat(player, "X: "..x.."Y: "..y.."Z: "..z)
end)

function OnPlayerJoin(player)
	return AddPlayerChat(player, 'Welcome to <span color="#ffff00">Onset</> Roleplay!')
end
AddEvent("OnPlayerJoin", OnPlayerJoin)

function OnPlayerDeath(player, instigator)
	AddPlayerChatAll(GetPlayerName(player).." has died!")
end
AddEvent("OnPlayerDeath", OnPlayerDeath)

function OnPlayerQuit(player)
	AddPlayerChatAll(GetPlayerName(player).." has left the server!")
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function FormatTime(time)
	local minutes = string.format("%02d", math.floor(time / 60.0))
	local seconds = string.format("%02d", math.floor(time - (minutes * 60.0)))
	local milliseconds = string.format("%03d", math.floor((time - (minutes * 60.0) - seconds) * 1000))
	return minutes..':'..seconds..':'..milliseconds
end

function fexist(filename) return file_exists(filename) end
function file_exists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end
