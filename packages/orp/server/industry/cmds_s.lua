local function cmd_aci(player, price, ...)

	if (PlayerData[player].admin < 4) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if price == nil or #{...} == 0 then
		return AddPlayerChatUsage(player, "/(ac)reate(i)ndustry <type> <price> <address>")
	end

	htype = tonumber(htype)
	price = tonumber(price)

	if price < 0 or price > 10000000 then
		return AddPlayerChatError(player, "industry price must range from 0 - 10,000,000.")
	end

	local x, y, z = GetPlayerLocation(player)

	local industry = Industry_Create(x, y, z)

	if industry == false then
		return AddPlayerChatError(player, "Maximum industries ("..MAX_INDUSTRIES..") on the server are created.")
	end

	AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Industry (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), industry))
end
AddCommand("acreateindustry", cmd_aci)
AddCommand("aci", cmd_aci)