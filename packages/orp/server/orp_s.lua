--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

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

AddEvent("OnPlayerWeaponShot", function(player, weapon, hittype, hitid, hitX, hitY, hitZ, startX, startY, startY, normalX, normalY, normalZ)
    if player ~= 0 then
        if weapon == 21 then
            if hittype == HIT_PLAYER then
                if IsValidPlayer(hitid) then

                    local x, y, z = GetPlayerLocation(player)
                    AddPlayerChatRange(x, y, 600.0, "* "..GetPlayerName(player).." falls on the ground after being hit by "..GetPlayerName(hitid).."'s taser.")

                    AddPlayerChat(hitid, "-> You hit "..GetPlayerName(hitid).." with your taser!")
                    AddPlayerChat(hitid, "> You were just hit by a taser. 10,000 volts go through your body.")

                    SetPlayerHeading(hitid, GetPlayerHeading(player) - 180)
                    SetPlayerAnimation(hitid, "LAY10")
                    SetPostEffect(hitid, "MotionBlur", "Amount", 1.0)
                    SetCameraShakeRotation(0.0, 0.0, 1.0, 10.0, 0.0, 0.0)
                    SetCameraShakeFOV(5.0, 5.0)
                    PlayCameraShake(5 * 1000, 2.0, 1.0, 1.1)

                    Delay(5 * 1000, function()
                        StopCameraShake(false)
                        SetPlayerHeading(hitid, GetPlayerHeading(player) - 180)
                        SetPlayerAnimation(hitid, "PUSHUP_END")
                    end)
                end
            end
        end
    end
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
