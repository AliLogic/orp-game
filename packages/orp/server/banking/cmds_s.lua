local colour = ImportPackage('colours')


AddCommand("acreateatm", function (player)
    if (PlayerData[player].admin < 5) then
        return AddPlayerChatError(player, "You don't have permission to use this command.")
    end

	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)
	local modelid = 494

	local query = mariadb_prepare(sql, "INSERT INTO atm VALUES(?, ?, ?, ?, 0.0, ?, 0.0);",
		modelid,
		x, y, z, h)

	mariadb_query(sql, query, OnAtmAdded, player, modelid, x, y, z, h)
end)

function OnAtmAdded(player, modelid, x, y, z, h)
	local id = mariadb_get_insert_id()

	if id ~= false then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> ATM ID "..id.." created successfully!")

		CreateATM(id, modelid, x, y, z, 0.0, h, 0.0)

		-- Tell clients
		for _, v in pairs(GetAllPlayers()) do
			CallRemoteEvent(v, "banking:atmsetup", AtmObjectsCached)
		end
	else
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Your ATM couldn't be created.")
	end
end