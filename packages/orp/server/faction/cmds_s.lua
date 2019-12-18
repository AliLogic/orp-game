local colour = ImportPackage('colours')

AddCommand("factions", function (playerid)
	for i = 1, #FactionData do
		if FactionData[i].id ~= 0 then
			AddPlayerChat(playerid, "#"..i..". "..FactionData[i].name)
		end
	end
end)

AddCommand("facmod", function(playerid)
	local factionId = PlayerData[playerid].faction

	if FactionData[factionId].id == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if PlayerData[playerid].factionRank < FactionData[factionId].leadRank then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	AddPlayerChat(playerid, "Coming soon...")
end)

AddCommand("f", function(playerid, ...)
	local faction_id = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	if FactionData[faction_id].id ~= 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /f <message>")
	end

	local msg = table.concat({...}, " ")

	if (#msg == 0 or #msg > 128) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: message has invalid length 128")
	end

	for k, v in ipairs(GetAllPlayers()) do
		AddPlayerChat(v, "[FACTION CHAT] "..FactionRankData[faction_id][faction_rank].." "..GetPlayerName(playerid)..": "..msg)
	end
end)

function cmd_acf(player, short_name, leadership_rank, fac_type, ...)
	if (PlayerData[player].admin < 4) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	local name = {...}

	if short_name == nil or leadership_rank == nil or fac_type == nil or name == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(f)action <short name> <ranks> <faction type> <name>")
	end

	name = table.concat(name, " ")

	if name < 5 or name > 50 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Faction name length is invalid.</>")
	end

	fac_type = tonumber(fac_type)
	leadership_rank = tonumber(leadership_rank)

	if (fac_type < 0 or fac_type > 1) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid faction type.</>")
	end

	if leadership_rank < 0 or leadership_rank > 16 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: ranks can be between 1 - 16.</>")
	end

	local faction = Faction_Create(name, short_name, leadership_rank, fac_type)
	if faction == 0 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Faction "..short_name.." wasn't able to be created!</>")
	else
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Faction %s (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), short_name, faction))
		Slap(player)
	end
	return
end
AddCommand('acreatefaction', cmd_acf)
AddCommand('acf', cmd_acf)