--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

local colour = ImportPackage('colours')

AddCommand("whitelist", function(playerid, steam_id)
	if (PlayerData[playerid].admin < 2) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (steam_id == nil or steam_id == 0) then
		return AddPlayerChat(playerid, "Usage: /whitelist <steam id>")
	end

	if (#steam_id < 10 or #steam_id > 20) then
		return AddPlayerChat(playerid, "Parameter \"steam id\" invalid length 10-20")
	end

	AddWhitelist(playerid, steam_id)
	AddPlayerChat(playerid, "You have added whitelist to for account "..steam_id..".")
end)

AddCommand("whitelistlog", function(playerid, otherplayer)
	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	local query = ""

	if (otherplayer == nil) then
		query = "SELECT player.steamname AS player_name, admin.steamname AS admin_name, timestamp\
		FROM log_whitelists\
		INNER JOIN whitelists\
		ON whitelists.id = log_whitelists.id\
		INNER JOIN accounts player\
		ON player.steamid = whitelists.steam_id\
		INNER JOIN accounts admin\
		ON log_whitelists.admin_id = admin.id\
		ORDER BY log_whitelists.timestamp DESC LIMIT 10;"
	else
		otherplayer = math.tointeger(otherplayer)

		if (not IsValidPlayer(otherplayer)) then
			return AddPlayerChat(playerid, "Selected player does not exist")
		end

		query = mariadb_prepare(sql, "SELECT player.steamname AS player_name, admin.steamname AS admin_name, timestamp\
		FROM log_whitelists\
		INNER JOIN whitelists\
		ON whitelists.id = log_whitelists.id\
		INNER JOIN accounts player\
		ON player.steamid = whitelists.steam_id\
		INNER JOIN accounts admin\
		ON log_whitelists.admin_id = admin.id\
		WHERE log_whitelists.admin_id = ?\
		ORDER BY log_whitelists.timestamp DESC LIMIT 10;",
			PlayerData[otherplayer].accountid
		)
	end

	mariadb_async_query(sql, query, OnWhitelistLogLoaded, playerid)
end)