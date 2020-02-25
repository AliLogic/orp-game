--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

KEY_VEHICLE		=	1
KEY_HOUSE		=	2
KEY_BUSINESS	=	3

-- Functions

function LoadPlayerKeys(playerid)

	local query = mariadb_prepare(sql, "SELECT * character_keys WHERE id = ?", PlayerData[playerid].id)
	local result = mariadb_await_query(sql, query, true)
	local row = mariadb_get_row_count()

	mariadb_delete_result(result)

	return row
end

function Key_PlayerHasKey(playerid, type, subject)

	local query = mariadb_prepare(sql, "SELECT 1 FROM character_keys WHERE id = ? AND type = ? AND subject = ?",
		PlayerData[playerid].id, type, subject
	)
	local result = mariadb_await_query(sql, query, true)
	local row = mariadb_get_row_count()

	mariadb_delete_result(result)

	return row
end

function Key_PlayerAddKey(playerid, type, subject)

	local query = mariadb_prepare(sql, "INSERT INTO character_keys (id, type, subject) VALUES(?, ?, ?)", PlayerData[playerid].id, type, subject)
	mariadb_async_query(sql, query)
end

function Key_PlayerRemoveKey(playerid, type, subject)

	local query = mariadb_prepare(sql, "DELETE FROM character_keys WHERE id = ? AND type = ? AND subject = ?", PlayerData[playerid].id, type, subject)
	mariadb_async_query(sql, query)
end

function Key_RemoveKeys(type, subject)

	local query = mariadb_prepare(sql, "DELETE FROM character_keys WHERE type = ? AND subject = ?", type, subject)
	mariadb_async_query(sql, query)
end