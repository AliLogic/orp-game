local colour = ImportPackage('colours')

AddCommand("acreateatm", function (player)
    if (PlayerData[player].admin < 5) then
        return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)

	local atm = ATM_Create(player, x, y, z, h)

	if atm == false then
		return AddPlayerChatError(player, "Maximum ATMs ("..MAX_ATM..") on the server are created.")
	end

	AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>ATM (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), atm))
end)