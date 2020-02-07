local colour = ImportPackage('colours')
local borkui = ImportPackage('borkui')

AddCommand("fhelp", function (playerid)
	local faction_type = GetPlayerFactionType(playerid)

	if faction_type ~= FACTION_NONE then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /online, /f, /fquit, /flocker, /finvite, /fremove, /frank</>")
	end

	if faction_type == FACTION_CIVILIAN then
	elseif faction_type == FACTION_POLICE then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /hcuff, /drag, /detain, /mdc, /arrest, /radio, /d, /callsign, /take</>")
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /ticket, /spike, /roadblock, /fingerprint, /impound, /revokeweapon, /checkproperties</>")
	elseif faction_type == FACTION_MEDIC then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /radio, /d, /bandage, /revive</>")
	elseif faction_type == FACTION_GOV then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /radio, /d, /checkproperties</>")
	end

	return 1
end)

AddCommand("frank", function (playerid, lookupid, rank)

	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	if factionid == 0 or rank == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	lookupid = tonumber(lookupid)

	if (not IsValidPlayer(lookupid)) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have specified an invalid player ID.</>")
	end

	if lookupid == playerid then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot change your own rank, request an admin or a colleague!</>")
	end

	if PlayerData[playerid].faction ~= PlayerData[lookupid].faction then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot change rank of someone who is not in your faction!</>")
	end

	if PlayerData[playerid].faction_rank < PlayerData[lookupid].faction_rank then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot change rank of someone whose rank is higher than yours!</>")
	end

	rank = tonumber(rank)

	if rank < 0 or rank > FactionData[factionid].leadership_rank then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid faction rank specified.</>")
	end

	PlayerData[lookupid].faction_rank = rank

	AddPlayerChat(playerid, "You have changed the rank of "..GetPlayerName(lookupid).." to "..rank..".")
	AddPlayerChat(lookupid, ""..GetPlayerName(playerid).." changed your rank to "..rank..".")

	return
end)

AddCommand("online", function (playerid)
	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	if factionid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	local message = ""

	for _, v in pairs(GetAllPlayers()) do
		if FactionData[factionid].id == FactionData[PlayerData[v].faction].id then
			message = message .. FactionRankData[factionid][faction_rank].rank_name.." "..GetPlayerName(playerid).." ("..playerid..")"
		end

		if playerid == v then
			message = message .. " (YOU)"
		end
		message = message .. "<br>"
	end

	DialogString = message
	borkui.createUI(playerid, 0, DIALOG_FACTION_ONLINE)
	return 1
end)

AddCommand("finvite", function (playerid, lookupid)

	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	if factionid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if lookupid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /finvite <playerid>")
	end

	lookupid = tonumber(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	if lookupid == playerid then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot invite yourself!</>")
	end

	if PlayerData[playerid].faction == PlayerData[lookupid].faction then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The specified player is already in your faction!</>")
	end

	if GetFactionType(lookupid) ~= FACTION_NONE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The specified player is already in a faction!</>")
	end

	-- Do the invite code here

	return
end)

AddCommand("fremove", function (playerid, lookupid)

	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	if factionid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if lookupid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /fremove <playerid>")
	end

	lookupid = tonumber(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	if lookupid == playerid then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot kick yourself out of the faction, use /fquit!</>")
	end

	if PlayerData[playerid].faction ~= PlayerData[lookupid].faction then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot kick someone who is not in your faction!</>")
	end

	if PlayerData[playerid].faction_rank < PlayerData[lookupid].faction_rank then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot kick someone whose rank is higher than you!</>")
	end

	PlayerData[lookupid].faction = 0
	PlayerData[lookupid].faction_rank = 0

	AddPlayerChat(playerid, ""..GetPlayerName(playerid).." has kicked you out of the faction!")
	AddPlayerChat(playerid, "You have kicked "..GetPlayerName(lookupid).." from your faction!")

	local query = mariadb_prepare(sql, "DELETE FROM faction_members WHERE char_id = '?'", PlayerData[lookupid].id)
	mariadb_async_query(sql, query)

	return
end)

AddCommand("fquit", function (playerid)
	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	if factionid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if FactionData[factionid].leadership_rank == PlayerData[playerid].faction_rank then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You can't leave the faction while you are the leader.")
	end

	PlayerData[playerid].faction = 0
	PlayerData[playerid].faction_rank = 0

	AddPlayerChat(playerid, "You have left your faction!")

	local query = mariadb_prepare(sql, "DELETE FROM faction_members WHERE char_id = '?'", PlayerData[playerid].id)
	mariadb_async_query(sql, query)

	return 1
end)

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

	if (GetFactionType(VehicleData[vehicleid].faction) ~= FACTION_POLICE) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This vehicle doesn't have a MDC.</>")
	end

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
	local rankId = PlayerData[playerid].faction_rank
	local x, y, z = GetPlayerLocation(playerid)

	AddPlayerChatRange(x, y, 2000.0, FactionRankData[factionId][rankId].rank_name .." " .. GetPlayerName(playerid) .. " (megaphone): "..msg)
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

	lookupid = tonumber(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	local x, y, z = GetPlayerLocation(playerid)
	local rankId = PlayerData[playerid].faction_rank

	if lookupid == playerid then
		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* " .. GetPlayerName(playerid) .. " looks at their badge.</>")
	else
		if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The specified player is not in your range.</>")
		end

		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* " .. GetPlayerName(playerid) .. " shows " .. GetPlayerName(lookupid) .." their badge.</>")
	end

	AddPlayerChat(lookupid, "______________________________________")
	AddPlayerChat(lookupid, "  Name: "..GetPlayerName(playerid))
	AddPlayerChat(lookupid, "  Rank: "..FactionRankData[factionId][rankId].rank_name.." ("..rankId..")")
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

	if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The specified player is not in your range.</>")
	end

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

AddCommand("d", function(playerid, ...)
	local factiontype = GetPlayerFactionType(playerid)

	if factiontype ~= FACTION_POLICE and factiontype ~= FACTION_GOV and factiontype ~= FACTION_MEDIC then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end

	if #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /d <message>")
	end

	local msg = table.concat({...}, " ")
	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	for _, v in ipairs(GetAllPlayers()) do
		factiontype = GetPlayerFactionType(playerid)

		if factiontype == FACTION_POLICE or factiontype == FACTION_GOV or factiontype == FACTION_MEDIC then
			AddPlayerChat(v, "(( "..FactionData[factionid].shortname.." "..FactionRankData[factionid][faction_rank].rank_name.." "..GetPlayerName(playerid).." ("..playerid.."): "..msg.." ))")
		end
	end
end)

AddCommand("f", function(playerid, ...)
	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	if factionid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /f <message>")
	end

	local msg = table.concat({...}, " ")

	--[[if (#msg == 0 or #msg > 128) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Message has invalid length 128")
	end]]--t

	AddPlayerChatFaction(FactionData[factionid].id, "(( "..FactionRankData[factionid][faction_rank].rank_name.." "..GetPlayerName(playerid).." ("..playerid.."): "..msg.." ))")
end)

AddCommand("bandage", function (playerid)
	if GetPlayerFactionType(playerid) ~= FACTION_MEDIC then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction to use this command!.</>")
	end

	return 1
end)

AddCommand("revive", function (playerid)
	if GetPlayerFactionType(playerid) ~= FACTION_MEDIC then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction to use this command!.</>")
	end

	return 1
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

	if faction == false then
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Faction %s wasn't able to be created!", colour.COLOUR_LIGHTRED(), factionname))
	else
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Faction %s (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), factionname, faction))
	end

end
AddCommand("acreatefaction", cmd_acf)
AddCommand("acf", cmd_acf)

local function cmd_adf(player, faction)
	if (PlayerData[player].admin < 5) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if faction == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ad)estroy(f)action <faction>")
	end

	faction = tonumber(faction)

	if FactionData[faction] == nil or FactionData[faction].id == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: That faction does not exist.</>")
	end

	local factionname = FactionData[faction].shortname

	if Faction_Destroy(faction) then
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Faction %s (ID: %d) deleted successfully!", colour.COLOUR_LIGHTRED(), factionname, faction))
	else
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Faction %s (ID: %d) failed to delete!", colour.COLOUR_LIGHTRED(), factionname, faction))
	end
end
AddCommand("adestroyfaction", cmd_adf)
AddCommand("adf", cmd_adf)

local function cmd_aef(player, faction, prefix, ...)
	if (PlayerData[player].admin < 5) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if faction == nil or prefix == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(f)action <faction> <prefix>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> type, name, shortname, leader, maxrank, bank, locker.")
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
	elseif prefix == "locker" then

		local x, y, z = GetPlayerLocation(player)
		UpdateFactionLocker(faction, x, y, z)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set a new locker position for the "..FactionData[faction].name..".")
	end

end
AddCommand("aeditfaction", cmd_aef)
AddCommand("aef", cmd_aef)

AddCommand("tickets", function (playerid)

	if (not IsPlayerInRangeOfPoint(130.0, 0.0, 0.0, 0.0)) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be at the City Hall.</>")
	end

	local query = mariadb_prepare(sql, "SELECT * FROM tickets WHERE id = ".. PlayerData[playerid].id .." ORDER BY ticket ASC")
	mariadb_async_query(sql, query, OnTicketsViewLoaded, playerid)
end)

AddCommand("ticket", function (playerid, lookupid, price, ...)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end

	if lookupid == nil or price == nil or #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /ticket <playerid> <price> <reason>")
	end

	lookupid = tonumber(lookupid)
	price = tonumber(price)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The specified player is not in your range.</>")
	end

	if price < 1 or price > 1000 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The price can't be below $1 or above $1,000.</>")
	end

	local reason = table.concat({...}, " ")

	if string.len(reason) > 64 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Ticket reason too long.")
	end

	Ticket_Add(lookupid, price, reason)

	AddPlayerChat(playerid, "You have written ".. GetPlayerName(lookupid) .." a ticket for $".. price ..", reason: "..reason..".")
	AddPlayerChat(lookupid, "".. GetPlayerName(playerid) .." has written you a ticket for $".. price ..", reason: "..reason.."")
end)

AddCommand("impound", function (playerid, price)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end

	if price == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /impound <price>")
	end

	price = tonumber(price)

	if price < 1 or price > 10000 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The price can't be below $1 or above $10,000.</>")
	end

	local vehicleid = GetPlayerVehicle(playerid)

	if vehicleid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be in a vehicle to use this command.</>")
	end

	local factionid = PlayerData[playerid].faction

	AddPlayerChatFaction(FactionData[factionid].id, "RADIO: ".. GetPlayerName(playerid) .." has impounded a ".. VEHICLE_NAMES[vehicleid] .." for $".. price ..".")

	ImpoundVehicle(vehicleid, price)
end)

AddCommand("checkproperties", function (playerid, lookupid)

	local factiontype = GetPlayerFactionType(playerid)

	if factiontype ~= FACTION_POLICE and factiontype ~= FACTION_GOV then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end

	if lookupid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /checkproperties <playerid>")
	end

	lookupid = tonumber(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	local count = 0

	AddPlayerChat(playerid, "Properties registered to "..GetPlayerName(lookupid).." ("..lookupid.."):")

	for houseid = 1, MAX_HOUSING, 1 do
		if House_IsOwner(lookupid, houseid) == true then

			AddPlayerChat(playerid, "* House ID: ".. houseid ..".")

			count = count + 1
		end
	end

	for businessid = 1, MAX_BUSINESSES, 1 do

		if Business_IsOwner(lookupid, businessid) == true then

			AddPlayerChat(playerid, "* Business ID: ".. businessid ..".")

			count = count + 1
		end
	end

	if count == 0 then
		AddPlayerChat(playerid, ""..GetPlayerName(lookupid).." does not own any properties.")
	end

	return

end)

--[[
	/$$$$$$                                                       /$$             /$$
	|_  $$_/                                                      | $$            | $$
	  | $$   /$$$$$$$   /$$$$$$$  /$$$$$$  /$$$$$$/$$$$   /$$$$$$ | $$  /$$$$$$  /$$$$$$    /$$$$$$
	  | $$  | $$__  $$ /$$_____/ /$$__  $$| $$_  $$_  $$ /$$__  $$| $$ /$$__  $$|_  $$_/   /$$__  $$
	  | $$  | $$  \ $$| $$      | $$  \ $$| $$ \ $$ \ $$| $$  \ $$| $$| $$$$$$$$  | $$    | $$$$$$$$
	  | $$  | $$  | $$| $$      | $$  | $$| $$ | $$ | $$| $$  | $$| $$| $$_____/  | $$ /$$| $$_____/
	 /$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$/| $$ | $$ | $$| $$$$$$$/| $$|  $$$$$$$  |  $$$$/|  $$$$$$$
	|______/|__/  |__/ \_______/ \______/ |__/ |__/ |__/| $$____/ |__/ \_______/   \___/   \_______/
														| $$
														| $$
														|__/
]]--

AddCommand("drag", function (playerid, lookupid)
end)

AddCommand("detain", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end
end)

AddCommand("arrest", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end
end)

AddCommand("take", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end
end)

AddCommand("spikes", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end
end)

AddCommand("roadblock", function (playerid, lookupid)
end)

AddCommand("fingerprint", function (playerid, lookupid)
end)

AddCommand("revokeweapon", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end
end)

AddCommand("flocker", function (playerid)
	local factionid = PlayerData[playerid].faction

	if factionid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if (not IsPlayerInRangeOfPoint(150.0, FactionData[factionid].locker_x, FactionData[factionid].locker_y, FactionData[factionid].locker_z)) then
		AddPlayerChat(playerid, "You are interacting with the faction locker.")
	end
end)