local colour = ImportPackage("colours")

AddCommand("warp", function (playerid, fromid, toid)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (fromid == nil or toid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /warp <player> <target>")
	end

	if (not IsValidPlayer(fromid)) or (not IsValidPlayer(toid)) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
	end

	local x, y, z = GetPlayerLocation(toid)
	SetPlayerLocation(fromid, x, y, z + 10.0)

	return AddPlayerChat(playerid, "Teleported to: "..GetPlayerName(fromid).." ("..fromid..") to "..GetPlayerName(fromid).." ("..fromid..").")
end)

AddCommand("gotoxyz", function (playerid, x, y, z)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (x == nil or y == nil or z == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /goto <x> <y> <z>")
	end

	SetPlayerLocation(playerid, x, y, z)

	return AddPlayerChat(playerid, "Teleported to: "..x..", "..y..", "..z..".")
end)

AddCommand("slap", function (playerid, lookupid)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /slap <playerid>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
	end

	Slap(lookupid)
	return AddPlayerChat(playerid, "You slapped "..GetPlayerName(lookupid).." ("..lookupid..").")
end)

AddCommand("goto", function (playerid, lookupid)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /goto <playerid>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
	end

	local x, y, z = GetPlayerLocation(lookupid)
	SetPlayerLocation(playerid, x, y, z + 10.0)

	return AddPlayerChat(playerid, "Teleported to: "..GetPlayerName(lookupid).." ("..lookupid..").")
end)

AddCommand("get", function (playerid, lookupid)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /get <playerid>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
	end

	local x, y, z = GetPlayerLocation(playerid)
	SetPlayerLocation(lookupid, x, y, z + 10.0)

	return AddPlayerChat(playerid, "You Teleported "..GetPlayerName(lookupid).." ("..lookupid..") to yourself.")
end)

AddCommand("apos", function (player, id)
	if (PlayerData[player].admin < 5) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

    local x, y, z = GetPlayerLocation(player)
    local a = GetPlayerHeading(player)
    
    print("X: "..x.." Y: "..y.." Z: "..z.." A: "..a)
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

	PlayerData[target].admin = level

	AddPlayerChat(player, string.format("<span color=\"%s\">You have set %s (%s, %d)'s admin rank to %s (%d).</>",
		colour.COLOUR_YELLOW(), GetPlayerName(target), PlayerData[target].name, target, GetPlayerAdminRank(level), level))

	AddPlayerChat(target, string.format("<span color=\"%s\">%s %s has set your admin rank to %s (%d).</>",
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
		if PlayerData[i].admin > 0 and player ~= i then
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

	model = tonumber(model)

	if model < 0 or model > 25 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Vehicle model "..model.." does not exist.</>")
	end

	if string.len(plate) < 0 or string.len(plate) > 13 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Plate lengths range from 1 - 13.</>")
	end

	local x, y, z = GetPlayerLocation(player)
	local a = GetPlayerHeading(player)

	local vehicle = Vehicle_Create(model, plate, x, y, z, a)
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

function cmd_aev(player, ...)
    if (PlayerData[player].admin < 2) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
    end

    local args = {...}

    if args[1] == "owner" then
        local vehicle = tonumber(args[2])
        local target = tonumber(args[3])

        if vehicle == nil or target == nil then
            return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle owner <vehicleid> <target>")
        end

        if IsValidPlayer(target) == nil or PlayerData[target] == nil then
            return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
        end

        if PlayerData[target].logged_in == false then
            return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This player is not logged in.</>")
        end

        CallRemoteEvent(player, "askClientActionConfirmation", player, 1, "Would you like to change this vehicle's owner?", target, vehicle)
    else
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /ae(dit)v(ehicle) <argument>")
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> owner")
    end
end
AddCommand('aeditvehicle', cmd_aev)
AddCommand('aev', cmd_aev)

AddRemoteEvent("clientActionConfirmationResult", function (result, player, target, vehicle)
    if result == 1 then
        if VehicleData[vehicle].faction ~= 0 then
            AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server: As this vehicle was owned by a faction, it will now be passed onto the player.</>")
            VehicleData[vehicle].faction = 0
        end

        VehicleData[vehicle].owner = PlayerData[target].id

        AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">"..GetPlayerName(target).." now owns the vehicle "..GetVehicleModel(vehicle).." (ID: "..vehicle..").</>")
        return
    else
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">You've decided to cancel any changes made to the vehicle!</>")
        return
    end
end)

function cmd_acf(player, maxrank, shortname, ...)
    if (PlayerData[player].admin < 5) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
    end

    local args = {...}
    
    if maxrank == nil or shortname == nil or args[1] == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(f)action <> <shortname> <fullname>")
    end

    maxrank = tonumber(maxrank)

	if string.len(maxrank) < 0 or string.len(maxrank) > 10 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Faction max ranks range from 1 - 10.</>")
	end
    
    if string.len(shortname) < 0 or string.len(shortname) > 6 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Faction short name lengths range from 1 - 6.</>")
    end

    local factionname = ''

	for _, v in pairs(args) do
		factionname = factionname.." "..v
    end
    
    local faction = Faction_Create(factionname, shortname, maxrank)

    AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Faction %s (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), factionname, faction))

end
AddCommand("acreatefaction", cmd_acf)
AddCommand("acf", cmd_acf)

AddCommand("ahelp", function (player)
    if (PlayerData[player].admin < 1) then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</sh>")
    end

    if PlayerData[player].admin > 0 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 1: </>/a /get /goto /gotoxyz /aslap /warp")
    end
    if PlayerData[player].admin > 1 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 2: </>/av /astats")
    end
    if PlayerData[player].admin > 2 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 3: </>None")
    end
    if PlayerData[player].admin > 3 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 4: </>/acreatevehicle /aeditvehicle")
    end
    if PlayerData[player].admin > 4 then
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 5: </>/apos /asetadmin /acreatefaction")
    end
end)