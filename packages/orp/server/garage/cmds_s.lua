local colour = ImportPackage('colours')

-- /acreategarage /aeditgarage /adestroygarage

function cmd_acg(player, price)
	if (PlayerData[player].admin < 4) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if price == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(g)arage <price>")
	end

	price = tonumber(price)

	if price < 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Garage price cannot be below $0.</>")
	end

	local x, y, z = GetPlayerLocation(player)
	local a = GetPlayerHeading(player)

	local garage = Garage_Create(price, x, y, z, a)
	if garage > 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Success:</> Garage ID "..garage.." created successfully!")
	end
end

function cmd_aeg(player, prefix, ...)
	if (PlayerData[player].admin < 4) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	local args = {...}

	if prefix == "name" then
		if args[1] == nil then
			return AddPlayerChat()
		end
	end
end
AddCommand("aeditgarage", cmd_aeg)
AddCommand("aeg", cmd_aeg)