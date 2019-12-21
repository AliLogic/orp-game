local colour = ImportPackage('colours')

AddCommand("factions", function (player)
	if #FactionData < 1 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> No factions currently exist.")
	end

    AddPlayerChat(player, string.format("<span color=\"%s\">|_____________[</>List of Factions<span color=\"%s\">]_____________|</>",
        colour.COLOUR_LIGHTRED(), colour.COLOUR_LIGHTRED()
    ))

	for i = 1, #FactionData, 1 do
		print("Faction name is "..FactionData[i].name)
		AddPlayerChat(player, string.format("<span color=\"%s\">(%d)</> %s",
			colour.COLOUR_DARKGREEN(), i, FactionData[i].name
		))
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
	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	if FactionData[factionid].id ~= 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /f <message>")
	end

	local msg = table.concat({...}, " ")

	--[[if (#msg == 0 or #msg > 128) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Message has invalid length 128")
	end]]--

	for _, v in ipairs(GetAllPlayers()) do
		if FactionData[factionid].id == FactionData[PlayerData[v].faction].id then
			AddPlayerChat(v, "(( "..FactionRankData[faction_id][faction_rank].." "..GetPlayerName(playerid).." ("..playerid.."): "..msg.." ))")
		end
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

	if (fac_type < FACTION_CIVILIAN or fac_type > FACTION_GOV) then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid faction type.</>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Types:</> 1 (Civilian), 2 (Police), 3 (Medic), 4 (Government).")
		return 
	end

	if leadership_rank < 0 or leadership_rank > 16 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Ranks range from 1 - 16.</>")
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