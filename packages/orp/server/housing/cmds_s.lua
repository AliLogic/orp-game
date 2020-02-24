--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic
* Bork

Contributors:
* Blue Mountains GmbH

To do:
* ability to view people that have keys to your house by using it near your house door
]]--

-- Variables

local colour = ImportPackage("colours")
local borkui = ImportPackage("borkui")

-- Commands

AddCommand("housedoors", function (playerid)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	local house = Housing_Nearest(playerid)

	if house == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any houses.</>")
	end

	if HousingData[house].doors == nil then
		AddPlayerChat(playerid, "House " .. house .. " doors table is nil.")
	end

	if #HousingData[house].doors == 0 then
		AddPlayerChat(playerid, "House " .. house .. " doors table amount is 0.")
	end

	for k, v in pairs(HousingData[house].doors) do
		AddPlayerChat(playerid, "House " .. house .." - Door " .. v .." - Locked: " .. DoorData[v].is_locked .. ".")
	end
end)

local function cmd_house(playerid, prefix, ...)

	if prefix == nil then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(h)ouse <prefix>")
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> un(lock), kickdoor, ring, rent, buy, sell")
	end

	local house = Housing_Nearest(playerid)

	if prefix == "lock" or prefix == "unlock" then

		if house == 0 then -- In this case, the player is not near any house

			local doorid = 0

			for houseid = 1, MAX_HOUSING, 1 do
				if PlayerHasHouseKey(playerid, houseid) or House_IsOwner(playerid, houseid) then
					print("Player has house key/ owns " .. houseid .. ".")
					doorid = House_GetNearestDoor(playerid, houseid)

					if doorid ~= 0 then
						break
					end
				end
			end

			if doorid == 0 then
				return AddPlayerChatError(playerid, "You are not near any door of your owned houses")
			end

			if DoorData[doorid].is_locked == 1 then
				AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">unlocked</> the house door.")
				DoorData[doorid].is_locked = 0
			else
				AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">locked</> the house door.")
				SetDoorOpen(DoorData[doorid].door, false)
				DoorData[doorid].is_locked = 1
			end

		else -- Player is near a house

			if #HousingData[house].doors == 0 then

				if HousingData[house].locked == 1 then
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">unlocked</> the house.")
					HousingData[house].locked = 0
				else
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">locked</> the house.")
					HousingData[house].locked = 1
				end
			else
				local doorid = House_GetNearestDoor(playerid, house)

				if doorid == 0 then
					return AddPlayerChatError(playerid, "You are not near any door of your owned houses.")
				end

				if DoorData[doorid].is_locked == 1 then
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">unlocked</> the house door.")
					DoorData[doorid].is_locked = 0
				else
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">locked</> the house door.")
					SetDoorOpen(DoorData[doorid].door, false)
					DoorData[doorid].is_locked = 1
				end
			end
		end

		SetPlayerAnimation(playerid, "LOCKDOOR")

	elseif prefix == "kickdoor" then

		if house == 0 then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any houses.</>")
		end

		if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">You are not in the appropriate faction to execute this command.</>")
		end

		if #HousingData[house].doors == 0 then
			if HousingData[house].locked == 0 then
				return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This house is already unlocked.</>")
			end

			AddPlayerChatAction(playerid, ""..GetPlayerName(playerid).." attempts to kick the house's door down.")

			Delay(2000, function ()

				if Housing_Nearest(playerid) ~= house then
					return
				end

				SetPlayerAnimation(playerid, "KICKDOOR")

				if Random(0, 6) <= 2 then
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">failed</> to kick the door down.")
					AddPlayerChatAction(playerid, ""..GetPlayerName(playerid).." has failed to kick the door down.")
				else
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">succeeded</> to kick the door down.")
					AddPlayerChatAction(playerid, ""..GetPlayerName(playerid).." has successfully kicked the door down.")

					HousingData[house].locked = 0
				end
			end)
		else
			if house == 0 then
				return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any houses.</>")
			end

			local doorid = HousingData[house].doors[1]

			if DoorData[doorid].is_locked == 0 then
				return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This house is already unlocked.</>")
			end

			local x, y, z = GetPlayerLocation(playerid)
			AddPlayerChatAction(playerid, ""..GetPlayerName(playerid).." attempts to kick the house's door down.")

			Delay(2000, function ()

				if Housing_Nearest(playerid) ~= house then
					return
				end

				SetPlayerAnimation(playerid, "KICKDOOR")

				if Random(0, 6) <= 2 then
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">failed</> to kick the door down.")
					AddPlayerChatAction(playerid, ""..GetPlayerName(playerid).." has failed to kick the door down.")
				else
					AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">succeeded</> to kick the door down.")
					AddPlayerChatAction(playerid, ""..GetPlayerName(playerid).." has successfully kicked the door down.")

					DoorData[doorid].is_locked = 0
					SetDoorOpen(DoorData[doorid].door, true)
				end
			end)
		end

	elseif prefix == "ring" or prefix == "bell" then

		if house == 0 then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any houses.</>")
		end

		if #HousingData[house].doors == 0 then

			AddPlayerChatRange(HousingData[house].ix, HousingData[house].iy, 800.0, "<span color=\""..colour.COLOUR_PURPLE().."\">* "..GetPlayerName(playerid).." rings the doorbell of the house.</>")

			for k, v in pairs(GetPlayersInRange3D(HousingData[house].ix, HousingData[house].iy, HousingData[house].ix, HousingData[house].iz, 800.0)) do
				PlayPlayerSound(v, "https://sndup.net/42s4/doorbell.mp3")
			end
		else
			local doorid = HousingData[house].doors[1]

			if (Door_Nearest(playerid) == doorid) then

				AddPlayerChatAction(playerid, ""..GetPlayerName(playerid).." rings the doorbell of the house.")
			else
				return AddPlayerChatError(playerid, "You are not near the main house door.")
			end
		end

		local x, y, z = GetPlayerLocation(playerid)
		for k, v in pairs(GetPlayersInRange3D(x, y, z, 800.0)) do
			PlayPlayerSound(v, "https://sndup.net/42s4/doorbell.mp3")
		end

		SetPlayerAnimation(playerid, "ENTERCODE")

	elseif prefix == "rent" then

		if house == 0 then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any houses.</>")
		end

		AddPlayerChat(playerid, "Coming soon!")

	elseif prefix == "buy" then

		if house == 0 then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any houses.</>")
		end

		if HousingData[house].owner == 0 and HousingData[house].ownership_type ~= HOUSE_OWNERSHIP_STATE then

			if HousingData[house].price > GetPlayerCash(playerid) then
				AddPlayerChatError(playerid, "You have insufficient funds to purchase this property.")
			end

			RemovePlayerCash(playerid, HousingData[house].price)
			HousingData[house].owner = PlayerData[playerid].id

			AddPlayerChat(playerid, "You have successfully purchased the house ("..house..") for <span color=\""..colour.COLOUR_DARKGREEN().."\">$"..HousingData[house].price.."</>.")

			House_RefreshLabel(house)
		else
			AddPlayerChatError(playerid, "This house can not be purchased.")
		end

	elseif prefix == "sell" then

		if house == 0 then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any houses.</>")
		end

		if HousingData[house].owner == PlayerData[playerid].id then

			local price = math.floor(HousingData[house].price / 2)

			AddPlayerCash(playerid, price)
			HousingData[house].owner = 0

			AddPlayerChat(playerid, "You have successfully sold the house ("..house..") for <span color=\""..colour.COLOUR_DARKGREEN().."\">$"..price.."</>.")

			House_RefreshLabel(house)
		else
			AddPlayerChatError(playerid, "You do not own this house.")
		end

	else
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> un(lock), kickdoor, ring, rent, buy, sell")
	end
end
AddCommand("house", cmd_house)
AddCommand("h", cmd_house)

local function cmd_ach(player, htype, price, ...)

	if (PlayerData[player].admin < 4) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if htype == nil or price == nil or #{...} == 0 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(h)ouse <type> <price> <address>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Type:</> (1) house (2) apt. room (3) apt. complex")
	end

	htype = tonumber(htype)
	price = tonumber(price)

	if htype < 0 or htype > HOUSING_TYPE_MAX then
		return AddPlayerChatError(player, "Specified house type invalid.")
	end

	if price < 0 or price > 10000000 then
		return AddPlayerChatError(player, "House price must range from 0 - 10,000,000.")
	end

	local address = table.concat({...}, " ")

	if string.len(address) < 0 or string.len(address) > 32 then
		return AddPlayerChatError(player, "House addresses lengths range from 1 - 32.")
	end

	local x, y, z = GetPlayerLocation(player)
	address = address .. ", " .. GetLocationName(x, y, z)

	local house = House_Create(htype, price, address, x, y, z)

	if house == false then
		return AddPlayerChatError(player, "Maximum houses ("..MAX_HOUSING..") on the server are created.")
	end

	AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>House %s (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), address, house))
end
AddCommand("acreatehouse", cmd_ach)
AddCommand("ach", cmd_ach)

local function cmd_aeh(player, house, prefix, ...)

	if (PlayerData[player].admin < 5) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if house == nil or prefix == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(h)ouse <house> <prefix>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> type, address, price.")
	end

	house = tonumber(house)

	if HousingData[house] == nil or HousingData[house].id == 0 then
		return AddPlayerChatError(player, "That house does not exist.")
	end

	local args = {...}

	if prefix == "type" then
		local htype = args[1]

		if htype == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(h)ouse <house> type <type>")
		end

		if htype < 1 or htype > HOUSING_TYPE_MAX then
			return AddPlayerChatError(player, "Faction types range from 1 - 3.")
		end

		htype = tonumber(htype)
		HousingData[house].type = htype

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..HousingData[house].address.." ("..house..")'s type to "..HousingType[htype]..".")

		return

	elseif prefix == "address" then
		if args[1] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(h)ouse <house> name <name>")
		end

		local address = table.concat({...}, " ")

		if string.len(address) < 0 or string.len(address) > 32 then
			return AddPlayerChatError(player, "House addresses lengths range from 1 - 32.")
		end

		address = address .. ", " .. GetLocationName(HousingData[house].ex, HousingData[house].ey, HousingData[house].ez)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..HousingData[house].address.." ("..house..")'s house name to "..address..".")
		HousingData[house].address = address
		House_RefreshLabel(house)

		return

	elseif prefix == "price" then

		if args[1] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(h)ouse <house> price <amount>")
		end

		local amount = tonumber(args[1])

		if amount < 0 or amount > 10000000 then
			return AddPlayerChatError(player, "House price must range from 0 - 10,000,000.")
		end

		HousingData[house].price = amount
		House_RefreshLabel(house)

		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..HousingData[house].address.." ("..house..")'s house price to "..amount..".")
	end

end
AddCommand("aedithouse", cmd_aeh)
AddCommand("aeh", cmd_aeh)

AddCommand("gotohouse", function (playerid, houseid)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if houseid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /gotohouse <house>")
	end

	houseid = tonumber(houseid)

	if HousingData[houseid] == nil then
		return AddPlayerChatError(playerid, "House " .. houseid .. " doesn't exist.")
	end

	SetPlayerLocation(playerid, HousingData[houseid].ex, HousingData[houseid].ey, HousingData[houseid].ez)

	AddPlayerChat(playerid, "You have been teleported to house ID: " .. houseid ..".")
end)

AddCommand("givehousekey", function (playerid, lookupid, houseid)

	if (lookupid == nil or houseid == nil) then
		return AddPlayerChat(playerid, "Usage: /givehousekey <playerid> <houseid>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if lookupid == playerid then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot give your own house keys to yourself!</>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChatError(playerid, "The specified player is not in your range.")
	end

	if not House_IsOwner(playerid, houseid) then
		return AddPlayerChatError(playerid, "You do not own the specified house.")
	end

	if PlayerHasHouseKey(lookupid, houseid) == true then
		return AddPlayerChatError(playerid, "The specified player already have the specified house's key.")
	end

	PlayerAddHouseKey(lookupid, houseid)

	AddPlayerChat(playerid, "You have gave the keys for house (ID: " .. houseid .. ") to " .. GetPlayerName(lookupid) .. ".")
	AddPlayerChat(lookupid, "You have receieved keys for house (ID: " .. houseid .. ") from " .. GetPlayerName(playerid) .. ".")
end)

AddCommand("takehousekey", function (playerid, lookupid, houseid)

	if (lookupid == nil or houseid == nil) then
		return AddPlayerChat(playerid, "Usage: /takehousekey <playerid> <houseid>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if lookupid == playerid then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot take your own house keys from yourself!</>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	if not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChatError(playerid, "The specified player is not in your range.")
	end

	if not House_IsOwner(playerid, houseid) then
		return AddPlayerChatError(playerid, "You do not own the specified house.")
	end

	if PlayerHasHouseKey(lookupid, houseid) ~= true then
		return AddPlayerChatError(playerid, "The specified player doesn't have the specified house's key.")
	end

	PlayerRemoveHouseKey(lookupid, houseid)

	AddPlayerChat(playerid, "You have taken house (ID: " .. houseid .. ") keys from " .. GetPlayerName(lookupid) .. ".")
	AddPlayerChat(lookupid, "Your keys for house (ID: " .. houseid .. ") has been taken away by " .. GetPlayerName(playerid) .. ".")
end)

AddCommand("myhousekeys", function (playerid)

	AddPlayerChat(playerid, "My house keys:")

	local count = false

	for houseid = 1, MAX_HOUSING, 1 do
		if PlayerHasHouseKey(playerid, houseid) then
			AddPlayerChat(playerid, "* House ID: ".. houseid .." | Address: ".. HousingData[houseid].address .. ".")
			count = true
		end
	end

	if not count then
		AddPlayerChat(playerid, "You do not have any house keys.")
	end
end)