local colour = ImportPackage('colours')

local function cmd_asw(playerid, weatherid)
	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if weatherid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(as)et(w)eather <weather>")
	end

	weatherid = tonumber(weatherid)

	if weatherid < 1 or weatherid > 10 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Weather ranges are between 1 to 10.")
	end
end

AddCommand("asetwweather", cmd_asw)
AddCommand("asw", cmd_asw)