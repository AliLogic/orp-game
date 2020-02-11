local colour = ImportPackage('colours')

local function cmd_asw(playerid, weatherid)
	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if weatherid == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(as)et(w)eather <weather>")
	end

	weatherid = tonumber(weatherid)

	if weatherid < 1 or weatherid > 12 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Weather ranges are between 1 to 12.")
	end

	EnvWeather = weatherid

	AddPlayerChat(playerid, "You have set the new game weather to "..weatherid..".")
end

AddCommand("asetweather", cmd_asw)
AddCommand("asw", cmd_asw)

local function cmd_asf(playerid, fog)
	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if fog == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(as)et(f)og <fog>")
	end

	fog = tonumber(fog)

	if fog < 0.0 or fog > 5.0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Fog density ranges are between 0.0 to 5.0.")
	end

	EnvFog = fog

	AddPlayerChat(playerid, "You have set the new game fog density to "..fog..".")
end

AddCommand("asetfog", cmd_asf)
AddCommand("asf", cmd_asf)