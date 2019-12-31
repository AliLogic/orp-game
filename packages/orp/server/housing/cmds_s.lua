local colour = ImportPackage("colours")

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