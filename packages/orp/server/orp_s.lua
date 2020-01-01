--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

local colour = ImportPackage('colours')

AddEvent("OnPlayerJoin", function (player)
	AddPlayerChatAll(GetPlayerName(player).." has joined the server!")
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

			if PlayerData[player].id ~= 0 then
				SetPlayerName(player, PlayerData[player].firstname.." "..PlayerData[player].lastname)
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
					AddPlayerChatRange(x, y, 1000.0, "<span color=\""..colour.COLOUR_PURPLE().."\">* "..GetPlayerName(hitid).." falls on the ground after being hit by "..GetPlayerName(player).."'s taser.</>")

					AddPlayerChat(player, "<span color=\""..colour.COLOUR_YELLOW().."\">-> You hit "..GetPlayerName(hitid).." with your taser!</>")
					AddPlayerChat(hitid, "<span color=\""..colour.COLOUR_YELLOW().."\"> -> You were just hit by a taser. 10,000 volts go through your body. </>")

					-- SetPlayerHeading(hitid, GetPlayerHeading(player) - 180)
					-- SetPlayerAnimation(hitid, "LAY10")
					SetPlayerRagdoll(hitid, true)

					CallRemoteEvent(hitid, "ToggleTaseEffect", true)

					Delay(5 * 1000, function()
						CallRemoteEvent(hitid, "ToggleTaseEffect", false)
						-- SetPlayerHeading(hitid, GetPlayerHeading(player) - 180)
						-- SetPlayerAnimation(hitid, "PUSHUP_END")
						SetPlayerRagdoll(hitid, false)
					end)
				end
			end
		end
	end
end)

AddEvent("OnPlayerStreamIn", function (player, otherplayer)
	if PlayerData[otherplayer] ~= nil then
		if PlayerData[otherplayer].id ~= 0 then
			SetPlayerName(otherplayer, PlayerData[otherplayer].firstname.." "..PlayerData[otherplayer].lastname)
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
