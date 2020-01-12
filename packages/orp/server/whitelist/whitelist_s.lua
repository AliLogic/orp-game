--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage("colours")

-- Functions

local function OnPlayerLoadWhitelist(player)
	if mariadb_get_row_count() > 0 then

		local allowed = mariadb_get_value_name_int(1, "allowed")

		if allowed ~= 1 then
			-- AddPlayerChat(player, "<span color=\"#FFFFFFFF\" style=\"normal\">Your account has been put off the</> <span color=\"#FF0000FF\" style=\"bold\">whitelist</> <span color=\"#FFFFFFFF\" style=\"normal\">. Visit the <span color=\"#FF0000FF\" style=\"bold\">roleplaystudios.co</> and contact the staff team.")
			KickPlayer(player, "This account has been put off the whitelist.")
		end
	else
		-- AddPlayerChat(player, "<span color=\"#FFFFFFFF\" style=\"normal\">Your account has not been</> <span color=\"#FF0000FF\" style=\"bold\">whitelisted</><span color=\"#FFFFFFFF\" style=\"normal\"> yet.</> Visit the <span color=\"#FF0000FF\" style=\"bold\">roleplaystudios.co</> to apply.")
		KickPlayer(player, "This account is not whitelisted.")
	end
end

function AddWhitelist(playerid, steam_id)
	local query = mariadb_prepare(sql, "INSERT INTO whitelists (steam_id) VALUES ('?')", tostring(steam_id))
	mariadb_async_query(sql, query)

	query = mariadb_prepare(sql, "INSERT INTO log_whitelists (id, steam_id, timestamp) VALUES (?, '?', UNIX_TIMESTAMP())",
		PlayerData[playerid].accountid, tostring(steam_id))
	mariadb_async_query(sql, query)
end

function OnWhitelistLogLoaded(playerid)
	if mariadb_get_row_count() == 0 then
		return AddPlayerChat(playerid, "No whitelists logged")
	end

	local messages = ""

	for i = 1, mariadb_get_row_count() do
		local player_name = mariadb_get_value_name_int(i, "admin_id")
		local admin_name = mariadb_get_value_name(i, "steam_id")
		local time = mariadb_get_value_name(i, "timestamp")

		messages = messages.."("..time..") "..admin_name.." whitelisted "..player_name.."<br>"
	end

	-- webgui.ShowMessageBox(playerid, messages)
end

-- Events

AddEvent("OnPlayerSteamAuth", function(playerid)

	local query = mariadb_prepare(sql, "SELECT * FROM whitelists WHERE steam_id = '?' LIMIT 1;",
		tostring(GetPlayerSteamId(playerid)))
	mariadb_query(sql, query, OnPlayerLoadWhitelist, playerid)
end)