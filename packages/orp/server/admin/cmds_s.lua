local colour = ImportPackage("colours")

AddCommand("apos", function (player, id)
    if (PlayerData[player].admin < 5) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
    end

	local x, y, z = GetPlayerLocation(player)
	return AddPlayerChat(player, "X: "..x.." Y: "..y.." Z: "..z)
end)

AddCommand("av", function (player, model)
    if (PlayerData[player].admin < 2) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
    end

	if (model == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /av <model>")
	end

	model = tonumber(model)

	if (model < 1 or model > 25) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Vehicle model "..model.." does not exist.</>")
	end

	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)

	local vehicle = CreateVehicle(model, x, y, z, h)
	if (vehicle == false) then
		return AddPlayerChat(player, "Failed to spawn your vehicle.")
	end

	SetVehicleLicensePlate(vehicle, "ONSET")
	AttachVehicleNitro(vehicle, true)

	if (model == 8) then
		-- Set Ambulance blue color and license plate text
		SetVehicleColor(vehicle, RGB(0.0, 60.0, 240.0))
		SetVehicleLicensePlate(vehicle, "EMS-02")
	end

    -- Set us in the driver seat
	SetPlayerInVehicle(player, vehicle)
	AddPlayerChat(player, "Vehicle spawned! (New ID: "..vehicle..")")
end)

AddCommand("asetadmin", function (player, target, level)
    if (PlayerData[player].admin < 5) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
    end

    if target == nil or level == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /asetadmin <playerid> <level>")
    end

    if IsValidPlayer(target) == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
    end
    
    target = tonumber(target)

    if PlayerData[target].logged_in == false then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This player is not logged in.</>")
    end

    level = tonumber(level)

    if level > PlayerData[player].admin then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot set a level above yours.</>")
    end

    if level < 0 or level > 5 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Admin levels range from 0 - 5.</>")
    end

    PlayerData[player].admin = level

    AddPlayerChat(player, string.format("<span color=\"%s\">You have set %s (%s, %d)'s admin rank to %s (%d).</>",
        colour.COLOUR_YELLOW(), GetPlayerName(target), PlayerData[player].name, target, GetPlayerAdminRank(level), level))

    AddPlayerChat(player, string.format("<span color=\"%s\">%s %s has set your admin rank to %s (%d).</>",
        colour.COLOUR_YELLOW(), GetPlayerAdminRank(player), PlayerData[player].name, GetPlayerAdminRank(level), level))
end)

AddCommand("a", function (player, ...)
    if (PlayerData[player].admin < 1) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
    end

    local args = {...}

    if args[1] == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /a [text]")
    end

    local text = ''

    for _, v in pairs(args) do
        text = text.." "..v
    end

    for _, i in pairs(GetAllPlayers()) do
        if PlayerData[i].admin > 0 then
            AddPlayerChat(player, string.format("<span color=\"%s\">** %s %s (%s, %d):%s</>",
                colour.COLOUR_LIGHTRED(), GetPlayerAdminRank(player), GetPlayerName(player), PlayerData[player].name, player, text))
        end
	end

end)

AddCommand("astats", function (player, target)
    if (PlayerData[player].admin < 2) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
    end

    if target == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /astats <playerid>")
    end

    if IsValidPlayer(target) == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
    end

    target = tonumber(target)

    if PlayerData[tonumber(target)].logged_in == false then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This player is not logged in.</>")
    end

    ViewPlayerStats(player, target)
end)

function cmd_acv(player, model, plate)
    if (PlayerData[player].admin < 4) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
    end

    if model == nil or plate == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(v)ehicle <model> <plate>")
    end

    if model < 0 or model > 25 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Vehicle model "..model.." does not exist.</>")
    end

    if string.len(plate) < 0 or string.len(plate) > 13 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Plate lengths range from 1 - 13.</>")
    end

    local x, y, z = GetPlayerLocation(player)
    local a = GetPlayerHeading(player)
    
    local vehicle = Vehicle_Create(model, x, y, z, a)
    if vehicle == false then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Vehicle "..model.." wasn't able to be created!</>")
    else
        AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Vehicle %d (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), model, vehicle))
        Slap(player)
    end
    return
end

AddCommand('acreatevehicle', cmd_acv)
AddCommand('acv', cmd_acv)

AddCommand("ahelp", function (player)
    if (PlayerData[player].admin < 1) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</model>")
    end

    if PlayerData[player].admin > 0 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 1: </>/a")
    end
    if PlayerData[player].admin > 1 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 2: </>/av /astats")
    end
    if PlayerData[player].admin > 2 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 3: </>None")
    end
    if PlayerData[player].admin > 3 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 4: </>/acreatevehicle")
    end
    if PlayerData[player].admin > 4 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 5: </>/apos /asetadmin")
    end
end)