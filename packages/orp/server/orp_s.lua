--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Raw
* Blue Mountains GmbH
]]--

local colour = ImportPackage('colours')
--local Discord = ImportPackage('discord')

--local dev_talk = 0

AddEvent("OnPackageStart", function()
	SetObjectScale(CreateObject(39, 122080, 90856, 1100), 0.75, 0.75, 0.75)
	--dev_talk = Discord.Channel("653324626977619968")
	--Discord.SendMessage(dev_talk, "plain", "Testing message as requested by daky")
end)

AddEvent("OnPlayerJoin", function (player)
	AddPlayerChatAll(GetPlayerName(player).." has joined the server!")
	SetPlayerDimension(player, player)
	SetPlayerSpawnLocation(player, 170694.51, 194947.45, 1396.96, 90.0)
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
		if IsPlayerInVehicle(hitid) then
			return false
		end
		if weapon == 24 then
			if hittype == HIT_VEHICLE then
				CallRemoteEvent(player, 'SendSpeedgunMessage', GetVehicleModelEx(hitid), hitid)
			end
		elseif weapon == 23 then
			if hittype == HIT_PLAYER then
				if IsValidPlayer(hitid) then

					local x, y, z = GetPlayerLocation(player)
					AddPlayerChatRange(x, y, 1000.0, "<span color=\""..colour.COLOUR_PURPLE().."\">* "..GetPlayerName(hitid).." falls on the ground after being hit by "..GetPlayerName(player).."'s Winchester 1300 BB.</>")

					AddPlayerChat(player, "<span color=\""..colour.COLOUR_YELLOW().."\">-> You hit "..GetPlayerName(hitid).." with your Winchester 1300 BB!</>")
					AddPlayerChat(hitid, "<span color=\""..colour.COLOUR_YELLOW().."\">-> You were just hit by a beanbag. You feel blunt force impact.</>")

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
		elseif weapon == 22 then
			if hittype == HIT_PLAYER then
				if IsValidPlayer(hitid) then

					local x, y, z = GetPlayerLocation(player)
					AddPlayerChatRange(x, y, 1000.0, "<span color=\""..colour.COLOUR_PURPLE().."\">* "..GetPlayerName(hitid).." falls on the ground after being hit by "..GetPlayerName(player).."'s Beratta 92 RB.</>")

					AddPlayerChat(player, "<span color=\""..colour.COLOUR_YELLOW().."\">-> You hit "..GetPlayerName(hitid).." with your Beratta 92 RB!</>")
					AddPlayerChat(hitid, "<span color=\""..colour.COLOUR_YELLOW().."\">-> You were just hit by a rubber bullet. You feel blunt force impact.</>")

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
		elseif weapon == 21 then
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

function fexist(filename) return file_exists(filename) end
function file_exists(filename)
	local file = io.open(filename, "r")
	if file then
		file:close()
		return true
	end
	return false
end