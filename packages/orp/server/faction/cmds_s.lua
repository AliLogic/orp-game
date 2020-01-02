local colour = ImportPackage('colours')

AddCommand("mdc", function (playerid)

	local factionId = PlayerData[playerid].faction

	if factionId == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if FactionData[factionId].type ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be a cop to use this command.</>")
	end

	if not IsPlayerInVehicle(playerid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be in a vehicle.</>")
	end

	if GetPlayerVehicleSeat(playerid) ~= 1 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be in the driver seat.</>")
	end

	local vehicleid = GetPlayerVehicleID(playerid)

	-- if (vehicle faction == 0 or vehicle faction type is not FACTION_POLICE) then
	-- return AddPlayerChat(playerid, "This vehicle doesn't have an MDC.")

	--ShowPlayerMDC(playerid)
	return true
end)

local function cmd_m(playerid, ...)
	local factionId = PlayerData[playerid].faction

	if factionId == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if FactionData[factionId].type ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be a cop to use this command.</>")
	end

	if not IsPlayerInVehicle(playerid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be in a vehicle.</>")
	end

	if #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /megaphone <message>")
	end

	local msg = table.concat({...}, " ")

	local x, y, z = GetPlayerLocation(playerid)
	AddPlayerChatRange(x, y, 2000.0, FactionRankData[factionId].faction_rank .." " .. GetPlayerName(playerid) .. " (megaphone): "..msg)
end
AddCommand("m", cmd_m)
AddCommand("megaphone", cmd_m)

AddCommand("badge", function (playerid, lookupid)
	local factionId = PlayerData[playerid].faction

	if factionId == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if FactionData[factionId].type ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be a cop to use this command.</>")
	end

	if lookupid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /badge <playerid>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	local x, y, z = GetPlayerLocation(playerid)

	if lookupid == playerid then
		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* " .. GetPlayerName(playerid) .. "looks at their badge.</>")
	else
		-- If distance is more than whats normal then send them an error message!

		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* " .. GetPlayerName(playerid) .. "shows " .. GetPlayerName(lookupid) .." their badge.</>")
	end

	AddPlayerChat(lookupid, "______________________________________")
	AddPlayerChat(lookupid, "  Name: "..GetPlayerName(playerid))
	AddPlayerChat(lookupid, "  Rank: "..PlayerData[playerid].faction_rank)
	AddPlayerChat(lookupid, "  Agency: "..FactionData[factionId].name)
	AddPlayerChat(lookupid, "______________________________________")
end)

local function cmd_handcuff(playerid, lookupid)

	local factionId = PlayerData[playerid].faction

	if factionId == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if FactionData[factionId].type ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be a cop to use this command.</>")
	end

	if lookupid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /h(and)cuff <playerid>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	-- If distance is more than whats normal then send them an error message!

	local is_handcuffed = IsPlayerHandcuffed(lookupid)

	if is_handcuffed then
		AddPlayerChat(playerid, "You unhandcuffed "..GetPlayerName(lookupid)..".")
	else
		AddPlayerChat(playerid, "You handcuffed "..GetPlayerName(lookupid)..".")
		AddPlayerChat(lookupid, GetPlayerName(playerid).." handcuffed you.")
	end

	SetPlayerHandcuff(lookupid, not is_handcuffed)
end
AddCommand("hcuff", cmd_handcuff)
AddCommand("handcuff", cmd_handcuff)

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

	if factionId == 0 then
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
			AddPlayerChat(v, "(( "..FactionRankData[factionid][faction_rank].." "..GetPlayerName(playerid).." ("..playerid.."): "..msg.." ))")
		end
	end
end)

local function cmd_acf(player, maxrank, shortname, ...)
	if (PlayerData[player].admin < 5) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	local args = {...}

	if maxrank == nil or shortname == nil or args[1] == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(f)action <maxrank> <shortname> <fullname>")
	end

	maxrank = tonumber(maxrank)

	if maxrank < 0 or maxrank > 10 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Faction max ranks range from 1 - 10.</>")
	end

	if string.len(shortname) < 0 or string.len(shortname) > 6 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Faction short name lengths range from 1 - 6.</>")
	end

	local factionname = table.contact({...}, " ")

	local faction = Faction_Create(factionname, shortname, maxrank)

	AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Faction %s (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), factionname, faction))
end
AddCommand("acreatefaction", cmd_acf)
AddCommand("acf", cmd_acf)

local function cmd_aef(player, faction, prefix, ...)
	if (PlayerData[player].admin < 5) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if faction == nil or prefix == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(f)action <faction> <prefix>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> type, name, shortname, leader, maxrank, bank.")
	end

	faction = tonumber(faction)

	if FactionData[faction] == nil or FactionData[faction].id == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: That faction does not exist.</>")
	end

	local args = {...}

	if prefix == "type" then
		local ftype = tonumber(args[1])

		if ftype == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(f)action <faction> type <type>")
		end

		if ftype < FACTION_CIVILIAN or ftype > FACTION_GOV then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Faction types range from 1 - 4.</>")
		end

		FactionData[faction].type = ftype

		if ftype == FACTION_CIVILIAN then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..FactionData[faction].name.." ("..faction..")'s faction type to Civilian.")
		elseif ftype == FACTION_POLICE then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..FactionData[faction].name.." ("..faction..")'s faction type to Police.")
		elseif ftype == FACTION_MEDIC then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..FactionData[faction].name.." ("..faction..")'s faction type to Medic.")
		elseif ftype == FACTION_GOV then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..FactionData[faction].name.." ("..faction..")'s faction type to Government.")
		end

		return

	elseif prefix == "name" then
		if args[1] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(f)action <faction> name <name>")
		end

		local name = table.concat(args, " ")

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..FactionData[faction].name.." ("..faction..")'s faction name to "..name..".")
		FactionData[faction].name = name

		return

	elseif prefix == "shortname" then
		if args[1] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(f)action <faction> shortname <shortname>")
		end

		local shortname = args[1]

		FactionData[faction].shortname = shortname
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..FactionData[faction].name.." ("..faction..")'s faction shortname to "..shortname..".")

	elseif prefix == "maxrank" then
		if args[1] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(f)action <faction> maxrank <maxrank>")
		end

		local rank = tonumber(args[1])

		FactionData[faction].leadership_rank = rank
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..FactionData[faction].name.." ("..faction..")'s faction max rank to "..rank..".")
	elseif prefix == "bank" then
		if args[1] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(f)action <faction> bank <amount>")
		end

		local bank = tonumber(args[1])

		if bank < 0 or bank > 250000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Faction bank amount must be at minimum $0, maximum $250,000.</>")
		end

		FactionData[faction].bank = bank
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..FactionData[faction].name.." ("..faction..")'s faction bank to "..bank..".")
	elseif prefix == "leader" then
		if args[1] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(f)action <faction> leader <target>")
		end

		local target = tonumber(args[1])

		if IsValidPlayer(target) == nil or PlayerData[target] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
		end

		if PlayerData[target].logged_in == false then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This player is not logged in.</>")
		end

		PlayerData[target].faction = FactionData[faction].leadership_rank

		AddPlayerChat(target, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> "..GetPlayerName(player).." has set you as the faction leader of "..FactionData[faction].name..".")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..GetPlayerName(target).." as the leader of "..FactionData[faction].name..".")
	end

end
AddCommand("aeditfaction", cmd_aef)
AddCommand("aef", cmd_aef)