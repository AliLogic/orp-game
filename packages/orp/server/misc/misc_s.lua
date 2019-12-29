local colour = ImportPackage('colours')

function Slap(player)
	local x, y, z = GetPlayerLocation(player)
	SetPlayerLocation(player, x, y, z + 200)
end

function ViewPlayerStats(player, target)
	target = tonumber(target)

	AddPlayerChat(player, string.format("<span color=\"%s\">|__________________%s [%s]__________________|</>", 
		colour.COLOUR_DARKGREEN(), GetPlayerName(target), PlayerData[target].name)) -- in future, add time.

	AddPlayerChat(player, string.format("<span color=\"%s\">CHARACTER: Gender:[%s] CharID:[%d]</>",
		colour.COLOUR_GRAD2(), (PlayerData[target].gender == 0 and 'Male' or 'Female'), PlayerData[player].id))

	AddPlayerChat(player, string.format("<span color=\"%s\">MONEY: Cash:[$%d] Bank:[$%d]</>",
		colour.COLOUR_GRAD1(), PlayerData[target].cash, PlayerData[target].bank))

	if PlayerData[target].admin > 0 then
		AddPlayerChat(player, string.format("<span color=\"%s\">ADMIN: DBID:[%d] Dimension:[%d] Locale:[%s]</>",
			colour.COLOUR_LIGHTRED(), PlayerData[target].accountid, GetPlayerDimension(target), GetPlayerLocale(target)))

		AddPlayerChat(player, string.format("<span color=\"%s\">CONNECTION: IP:[%s]</>",
			colour.COLOUR_LIGHTRED(), GetPlayerIP(target)))
	end

	AddPlayerChat(player, string.format("<span color=\"%s\">|__________________%s [%s]__________________|</>",
		colour.COLOUR_DARKGREEN(), GetPlayerName(target), PlayerData[target].name)) -- in future, add time.
end

function SetPlayerChatBubble(player, message, seconds)
	if PlayerData[player].label ~= nil then
		if IsValidText3D(PlayerData[player].label) then
			DestroyText3D(PlayerData[player].label)
		end
	end

	PlayerData[player].label = CreateText3D(message, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	SetText3DAttached(PlayerData[player].label, ATTACH_PLAYER, player, 0.0, 0.0, 150.0)

	Delay(seconds * 1000, function (player)
	if PlayerData[player].label ~= nil then
			if IsValidText3D(PlayerData[player].label) then
				DestroyText3D(PlayerData[player].label)
			end
		end
	end)
end

function GetPlayerCash(player)
	if PlayerData[player] ~= nil then
		return PlayerData[player].cash
	end
end

function SetPlayerCash(player, amount)
	if PlayerData[player] ~= nil then
		PlayerData[player].cash = amount
	end
end

function AddPlayerCash(player, amount)
	if PlayerData[player] ~= nil then
		PlayerData[player].cash = PlayerData[player].cash + amount
	end
end

function RemovePlayerCash(player, amount)
	if PlayerData[player] ~= nil then
		PlayerData[player].cash = PlayerData[player].cash - amount
	end
end

function SetPlayerHandcuff(playerid, bToggle)

	PlayerData[playerid].handcuffed = bToggle
	if bToggle then
		SetPlayerAnimation(playerid, "CUFF")
	else
		SetPlayerAnimation(playerid, "STOP")
	end
end

function IsPlayerHandcuffed(playerid)
	if PlayerData[playerid] ~= nil then
		return PlayerData[playerid].handcuffed
	end
	return 0
end

function IsPlayerAlive(playerid)
	if PlayerData[playerid] ~= nil then
		return (PlayerData[playerid].state == CHARACTER_STATE_ALIVE)
	end
	return false
end

AddRemoteEvent("GetPlayerCash", GetPlayerCash)
AddRemoteEvent("SetPlayerCash", SetPlayerCash)
AddRemoteEvent("AddPlayerCash", AddPlayerCash)
AddRemoteEvent("RemovePlayerCash", RemovePlayerCash)

-- In future, with all of these, add some cool server sided code to modify a nice UI or something.
