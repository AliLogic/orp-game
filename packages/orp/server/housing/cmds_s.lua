local colour = ImportPackage("colours")

local function cmd_house(playerid, prefix, ...)

	if prefix == nil then
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(h)ouse <prefix>")
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> un(lock), kickdoor, ring, rent, buy, sell")
	end

	local house = Housing_Nearest(playerid)

	if house == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any houses.</>")
	end

	if prefix == "lock" or prefix == "unlock" then

		if HousingData[house].locked then
			AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">unlocked</> the house.")
		else
			AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">locked</> the house.")
		end
		SetPlayerAnimation(playerid, "LOCKDOOR")

		HousingData[house].locked = (not HousingData[house].locked)

	elseif prefix == "kickdoor" then

		if GetPlayerFactionType(playerid) ~= FACTION_POLICE then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">You are not in the appropriate faction to execute this command.</>")
		end

		if not HousingData[house].locked then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This house is already unlocked.</>")
		end

		local x, y, z = GetPlayerLocation(playerid)
		AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." attempts to kick the house's door down.")

		Delay(2000, function ()

			if Housing_Nearest(playerid) ~= house then
				return
			end

			SetPlayerAnimation(playerid, "KICKDOOR")

			if Random(0, 6) <= 2 then
				AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">failed</> to kick the door down.")
				AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." has failed to kick the door down.")
			else
				AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">succeeded</> to kick the door down.")
				AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." has successfully kicked the door down.")

				HousingData[house].locked = 0
			end
		end)

	elseif prefix == "ring" or prefix == "bell" then

		local x, y, z = GetPlayerLocation(playerid)
		AddPlayerChatRange(x, y, 800.0, "* "..GetPlayerName(playerid).." rings the doorbell of the house.")

		-- add door bell sound for those fuckers near the playerid and those inside the house

	elseif prefix == "rent" then

		AddPlayerChat(playerid, "Coming soon!")

	elseif prefix == "buy" then

		if HousingData[house].owner == 0 and HousingData[house].ownership_type == HOUSE_OWNERSHIP_SOLE then

			if HousingData[house].price > GetPlayerCash(playerid) then
				AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You have insufficient funds to purchase this property.")
			end

			RemovePlayerCash(playerid, HousingData[house].price)
			HousingData[house].owner = PlayerData[playerid].id

			AddPlayerChat(playerid, "You have successfully purchased the house ("..house..") for <span color=\""..colour.COLOUR_DARKGREEN().."\">$"..HousingData[house].price.."</>.")
		else
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This house can not be purchased.</>")
		end

	elseif prefix == "sell" then

		if HousingData[house].owner == PlayerData[playerid].id then

			local price = math.floor(HousingData[house].price / 2)

			AddPlayerCash(playerid, price)
			HousingData[house].owner = 0

			AddPlayerChat(playerid, "You have successfully sold the house ("..house..") for <span color=\""..colour.COLOUR_DARKGREEN().."\">$"..price.."</>.")
		else
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You do not own this house.")
		end

	else
		AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> un(lock), kickdoor, ring, rent, buy, sell")
	end
end
AddCommand("house", cmd_house)
AddCommand("h", cmd_house)

local function cmd_ach(player, htype, price, ...)

	if (PlayerData[player].admin < 4) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if htype == nil or price == nil or #{...} == 0 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(h)ouse <type> <price> <name>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Type:</> (1) house (2) apt. room (3) apt. complex")
	end

	htype = tonumber(htype)
	price = tonumber(price)

	if htype < 0 or htype > HOUSING_TYPE_MAX then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Specified house type invalid.</>")
	end

	if price < 0 or price > 10000000 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: House price must range from 0 - 10,000,000.</>")
	end

	local house_name = table.contact({...}, " ")

	if string.len(house_name) < 0 or string.len(house_name) > 24 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: House name lengths range from 1 - 24.</>")
	end

	local house = House_Create(player, htype, price, ...)

	if house == false then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Maximum houses ("..MAX_HOUSING..") on the server are created.</>")
	end

	AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>House %s (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), house_name, house))
end
AddCommand("acreatehouse", cmd_ach)
AddCommand("ach", cmd_ach)

local function cmd_aeh(player, house, prefix, ...)

	if (PlayerData[player].admin < 5) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if house == nil or prefix == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(h)ouse <house> <prefix>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> type, name, price.")
	end

	house = tonumber(house)

	if HousingData[house] == nil or HousingData[house].id == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: That house does not exist.</>")
	end

	local args = {...}

	if prefix == "type" then
		local htype = args[1]

		if htype == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(h)ouse <house> type <type>")
		end

		if htype < 1 or htype > HOUSING_TYPE_MAX then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Faction types range from 1 - 3.</>")
		end

		htype = tonumber(htype)
		HousingData[house].type = htype

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..HousingData[house].name.." ("..house..")'s type to "..HousingType[htype]..".")

		return

	elseif prefix == "name" then
		if args[1] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(h)ouse <house> name <name>")
		end

		local name = table.concat({...}, " ")

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..HousingData[house].name.." ("..house..")'s house name to "..name..".")
		FactionData[house].name = name

		return

	elseif prefix == "price" then

		if args[1] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(h)ouse <house> price <amount>")
		end

		local amount = tonumber(args[1])

		if amount < 0 or amount > 10000000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: House price must range from 0 - 10,000,000.</>")
		end

		HousingData[house].price = amount

		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You've set "..HousingData[house].name.." ("..house..")'s house price to "..amount..".")
	end

end
AddCommand("aedithouse", cmd_aeh)
AddCommand("aeh", cmd_aeh)