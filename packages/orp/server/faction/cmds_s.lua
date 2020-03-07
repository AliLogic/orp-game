--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage('colours')
local borkui = ImportPackage('borkui')

-- Commands

AddCommand("fhelp", function (playerid)
	local faction_type = GetPlayerFactionType(playerid)

	if faction_type == FACTION_NONE then
		return AddPlayerChatError(playerid, "You are not in any faction!")
	end

	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /online, /f, /fquit, /flocker, /finvite, /fremove, /frank, /accept, /radio</>")

	if faction_type == FACTION_CIVILIAN then
	elseif faction_type == FACTION_POLICE then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /hcuff, /drag, /detain, /mdc, /arrest, /d, /callsign, /take</>")
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /ticket, /spike, /roadblock, /impound, /revokeweapon, /checkproperties</>")
	elseif faction_type == FACTION_MEDIC then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /d, /bandage, /revive</>")
	elseif faction_type == FACTION_GOV then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">FACTION: /d, /checkproperties</>")
	end

	return 1
end)

AddCommand("frank", function (playerid, lookupid, rank)

	local factionid = PlayerData[playerid].faction

	if factionid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

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
			faction_rank = PlayerData[v].faction_rank

			message = message .. FactionRankData[factionid][faction_rank].rank_name.." "..GetPlayerName(v).." ("..v..")"
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
		return AddPlayerChatUsage(playerid, "/finvite <playerid>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

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

	if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChatError(playerid, "The specified player is not in your range.")
	end

	PlayerData[lookupid].faction_inviter = playerid

	AddPlayerChat(playerid, "You invited " .. GetPlayerName(lookupid) .. " to join the " .. Faction_GetName(factionid) .. ".")
	AddPlayerChat(lookupid, "" .. GetPlayerName(playerid) .. " has invited you to join the " .. Faction_GetName(factionid) .. ", type <span style=\"bold\">/accept</> to join.")

	return
end)

AddCommand("accept", function (playerid)

	if (GetPlayerFactionType(playerid) ~= FACTION_NONE) then
		return AddPlayerChatError(playerid, "You are already in a faction!")
	end

	local inviterid = PlayerData[playerid].faction_inviter

	if (inviterid == 0) then
		return AddPlayerChatError(playerid, "You weren't invited to join any faction!")
	end

	local factionid = GetPlayerFactionId(inviterid)

	PlayerData[playerid].faction = factionid
	PlayerData[playerid].faction_rank = 1

	AddPlayerChat(inviterid, "" .. GetPlayerName(playerid) .. " has accepted your faction invite .")
	AddPlayerChat(playerid, "You joined the faction: " .. Faction_GetName(factionid) .. " from the invitation of " .. GetPlayerName(inviterid) .. ".")

	PlayerData[playerid].faction_inviter = 0

	local query = mariadb_prepare(sql, "INSERT INTO faction_members VALUES(?, ?, 1)", PlayerData[playerid].id, factionid)
	mariadb_async_query(sql, query)
end)

AddCommand("fremove", function (playerid, lookupid)

	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	if factionid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any faction.</>")
	end

	if lookupid == nil then
		return AddPlayerChatUsage(playerid, "/fremove <playerid>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

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
		return AddPlayerChatUsage(playerid, "/megaphone <message>")
	end

	local msg = table.concat({...}, " ")
	local rankId = PlayerData[playerid].faction_rank
	local x, y, z = GetPlayerLocation(playerid)

	AddPlayerChatRange(x, y, 2000.0, "<span color=\""..colour.COLOUR_YELLOW().."\">" .. GetPlayerName(playerid) .. " (megaphone): " .. msg .. "</>")
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
		return AddPlayerChatUsage(playerid, "/badge <playerid>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	local rankId = PlayerData[playerid].faction_rank

	if lookupid == playerid then
		AddPlayerChatAction(playerid, "" .. GetPlayerName(playerid) .. " looks at their badge.")
	else
		if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
			return AddPlayerChatError(playerid, "The specified player is not in your range.")
		end

		AddPlayerChatAction(playerid, "" .. GetPlayerName(playerid) .. " shows " .. GetPlayerName(lookupid) .." their badge.")
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

	lookupid = GetPlayerIdFromData(lookupid)

	if lookupid == nil then
		return AddPlayerChatUsage(playerid, "/h(and)cuff <playerid>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChatError(playerid, "The specified player is not in your range.")
	end

	if IsPlayerHandcuffed(lookupid) == 1 then
		AddPlayerChat(playerid, "You unhandcuffed "..GetPlayerName(lookupid)..".")
		SetPlayerHandcuff(lookupid, 0)
	else
		AddPlayerChat(playerid, "You handcuffed "..GetPlayerName(lookupid)..".")
		AddPlayerChat(lookupid, GetPlayerName(playerid).." handcuffed you.")
		SetPlayerHandcuff(lookupid, 1)
	end
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
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	AddPlayerChat(playerid, "Coming soon...")
end)

AddCommand("d", function(playerid, ...)
	local factiontype = GetPlayerFactionType(playerid)

	if factiontype ~= FACTION_POLICE and factiontype ~= FACTION_GOV and factiontype ~= FACTION_MEDIC then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end

	if #{...} == 0 then
		return AddPlayerChatUsage(playerid, "/d <message>")
	end

	local msg = table.concat({...}, " ")
	local factionid = PlayerData[playerid].faction
	local faction_rank = PlayerData[playerid].faction_rank

	for _, v in ipairs(GetAllPlayers()) do
		factiontype = GetPlayerFactionType(playerid)

		if factiontype == FACTION_POLICE or factiontype == FACTION_GOV or factiontype == FACTION_MEDIC then
			AddPlayerChat(v, "(( "..FactionData[factionid].short_name.." "..FactionRankData[factionid][faction_rank].rank_name.." "..GetPlayerName(playerid).." ("..playerid.."): "..msg.." ))")
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
		return AddPlayerChatUsage(playerid, "/f <message>")
	end

	local msg = table.concat({...}, " ")

	--[[if (#msg == 0 or #msg > 128) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Message has invalid length 128")
	end]]--t

	AddPlayerChatFaction(FactionData[factionid].id, "<span color=\""..colour.COLOUR_LIGHTBLUE().."\">(( "..FactionRankData[factionid][faction_rank].rank_name.." "..GetPlayerName(playerid).." ("..playerid.."): "..msg.." ))</>")
end)

local function cmd_acf(player, maxrank, shortname, ...)
	if (PlayerData[player].admin < 5) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
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
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if faction == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ad)estroy(f)action <faction>")
	end

	faction = tonumber(faction)

	if FactionData[faction] == nil or FactionData[faction].id == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: That faction does not exist.</>")
	end

	local factionname = FactionData[faction].short_name

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
		return AddPlayerChatError(player, "You don't have permission to use this command.")
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

		FactionData[faction].short_name = shortname
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
			return AddPlayerChatError(player, "Invalid player ID entered")
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

	if (not IsPlayerInRangeOfPoint(playerid, 130.0, LOC_TICKETS_X, LOC_TICKETS_Y, LOC_TICKETS_Z)) then
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
		return AddPlayerChatUsage(playerid, "/ticket <playerid> <price> <reason>")
	end

	lookupid = GetPlayerIdFromData(lookupid)
	price = tonumber(price)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChatError(playerid, "The specified player is not in your range.")
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
		return AddPlayerChatUsage(playerid, "/impound <price>")
	end

	price = tonumber(price)

	if price < 1 or price > 10000 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The price can't be below $1 or above $10,000.</>")
	end

	local vehicleid = GetNearestVehicle(playerid)

	if vehicleid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be near a vehicle to use this command.</>")
	end

	local factionid = PlayerData[playerid].faction

	AddPlayerChatFaction(factionid, "RADIO: ".. GetPlayerName(playerid) .." has impounded a ".. VEHICLE_NAMES[vehicleid] .." for $".. price ..".")

	ImpoundVehicle(vehicleid, price)
end)

AddCommand("checkproperties", function (playerid, lookupid)

	local factiontype = GetPlayerFactionType(playerid)

	if factiontype ~= FACTION_POLICE and factiontype ~= FACTION_GOV then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end

	if lookupid == nil then
		return AddPlayerChatUsage(playerid, "/checkproperties <playerid>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid playerid specified.</>")
	end

	AddPlayerChat(playerid, "Properties registered to "..GetPlayerName(lookupid).." ("..lookupid.."):")

	ShowPropertiesList(playerid, lookupid)

	return

end)

AddCommand("detain", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the appropriate faction.</>")
	end

	local vehicleid = GetNearestVehicle(playerid)

	if lookupid == nil then
		return AddPlayerChatUsage(playerid, "/detain <playerid>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if (not IsValidPlayer(lookupid)) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have specified an invalid player ID.</>")
	end

	if lookupid == playerid then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot change your own rank, request an admin or a colleague!</>")
	end

	if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChatError(playerid, "The specified player is not in your range.")
	end

	if IsPlayerHandcuffed(lookupid) == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The player is not cuffed at the moment.</>")
	end

	if vehicleid == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any vehicle.</>")
	end

	if (GetVehicleNumberOfSeats(vehicleid) < 2) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You can't detain that player in this vehicle.</>")
	end

	local x, y, z = GetPlayerLocation(playerid)

	if GetPlayerVehicle(lookupid) == vehicleid then

		FreezePlayer(lookupid, true)

		RemovePlayerFromVehicle(lookupid)

		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* " .. GetPlayerName(playerid) .. " opens the door and pulls " .. GetPlayerName(lookupid) .. " out the vehicle.</>")
	else

		local seatid = GetAvailableSeat(vehicleid, 2)

		if seatid == 0 then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: There are no more seats remaining.</>")
		end

		AddPlayerChat(lookupid, "You have been detained by " .. GetPlayerName(playerid) ..".")
		FreezePlayer(lookupid, false)

		SetPlayerInVehicle(lookupid, vehicleid, seatid)

		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* " .. GetPlayerName(playerid) .. " opens the door and places " .. GetPlayerName(lookupid) .. " into the vehicle.</>")
	end
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

AddCommand("arrest", function (playerid, lookupid, minutes)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChatError(playerid, "You are not in the appropriate faction.")
	end

	if lookupid == nil or minutes == nil then
		return AddPlayerChatUsage(playerid, "/arrest <player> <minutes>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid playerid specified.")
	end

	if lookupid == playerid then
		return AddPlayerChatError(playerid, "You cannot invite yourself!")
	end

	if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChatError(playerid, "The specified player is not in your range.")
	end

	minutes = tonumber(minutes)

	if minutes < 1 or minutes > 120 then
		return AddPlayerChatError(playerid, "The specified player is not in your range.")
	end

	if IsPlayerHandcuffed(lookupid) == 0 then
		return AddPlayerChatError(playerid, "The player is not cuffed at the moment.")
	end
end)

AddCommand("take", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChatError(playerid, "You are not in the appropriate faction.")
	end
end)

AddCommand("spikes", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChatError(playerid, "You are not in the appropriate faction.")
	end
end)

AddCommand("roadblock", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChatError(playerid, "You are not in the appropriate faction.")
	end
end)

AddCommand("revokeweapon", function (playerid, lookupid)

	if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
		return AddPlayerChatError(playerid, "You are not in the appropriate faction.")
	end
end)

AddCommand("flocker", function (playerid)
	local factionid = PlayerData[playerid].faction

	if factionid == 0 then
		return AddPlayerChatError(playerid, "You are not in any faction.")
	end

	if (not IsPlayerInRangeOfPoint(playerid, 150.0, FactionData[factionid].locker_x, FactionData[factionid].locker_y, FactionData[factionid].locker_z)) then
		return AddPlayerChatError(playerid, "You are not near your faction locker.")
	end

	AddPlayerChat(playerid, "Add a faction locker dialog here.")
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

	SetPlayerAnimation(playerid, "REVIVE")

	return 1
end)