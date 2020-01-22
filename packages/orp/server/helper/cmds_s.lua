local colour = ImportPackage("colours")

local function cmd_hhelp(player)
	if (PlayerData[player].helper < 1) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if PlayerData[player].helper > 0 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_BLUE().."\">Helper:</> /hc /assist")
	end

	if PlayerData[player].helper > 1 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_BLUE().."\">Head of Helper:</> None")
	end
end
AddCommand("hhelp", cmd_hhelp)
AddCommand("helperhelp", cmd_hhelp)

AddCommand("hc", function (player, ...)
	if (PlayerData[player].helper < 1) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if #{...} == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /hc [text]")
	end

	local text = table.concat({...}, " ")

	for _, i in pairs(GetAllPlayers()) do
		if PlayerData[i].helper > 0 then
			AddPlayerChat(i, string.format("<span color=\"%s\">** %s %s (%s, %d): %s</>",
				colour.COLOUR_BLUE(), GetPlayerHelperRank(player), GetPlayerName(player), PlayerData[player].name, player, text))
		end
	end
end)