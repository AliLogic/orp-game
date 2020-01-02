local colour = ImportPackage("colours")

AddCommand("kick", function (playerid, lookupid, ...)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /kick <player> <reason*>")
	end

	lookupid = tonumber(lookupid)

	if lookupid == playerid then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot kick yourself!</>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
	end

	if PlayerData[lookupid].admin > PlayerData[playerid].admin then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You can not kick "..GetPlayerName(lookupid)..".</>")
	end

	local reason
	if #{...} == 0 then
		reason = "no reason specified"
	else
		reason = table.cocat({...}, " ")
	end

	AddPlayerChatAll("AdmCmd: "..GetPlayerName(lookupid).." was kicked by "..GetPlayerName(playerid)..", Reason: "..reason..".")

	KickPlayer(lookupid, reason)
end)

AddCommand("warp", function (playerid, fromid, toid)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (fromid == nil or toid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /warp <player> <target>")
	end

	if (fromid == toid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You can not warp the same player to itself.</>")
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
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /gotoxyz <x> <y> <z>")
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

	if playerid == lookupid then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot TP to yourself!</>")
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

	if playerid == lookupid then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot TP to yourself!</>")
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
		colour.COLOUR_YELLOW(), GetPlayerName(target), PlayerData[target].name, target, GetPlayerAdminRank(target), level))

	AddPlayerChat(target, string.format("<span color=\"%s\">%s %s has set your admin rank to %s (%d).</>",
		colour.COLOUR_YELLOW(), GetPlayerAdminRank(player), PlayerData[player].name, GetPlayerAdminRank(target), level))

	local query = mariadb_prepare(sql, "UPDATE accounts SET admin = ? WHERE id = ? LIMIT 1;",
		level,
		PlayerData[target].accountid
	)
	mariadb_async_query(sql, query)
end)

AddCommand("a", function (player, ...)
	if (PlayerData[player].admin < 1) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if #{...} == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /a [text]")
	end

	local text = table.concat({...}, " ")

	for _, i in pairs(GetAllPlayers()) do
		if PlayerData[i].admin > 0 then
			AddPlayerChat(i, string.format("<span color=\"%s\">** %s %s (%s, %d): %s</>",
				colour.COLOUR_LIGHTRED(), GetPlayerAdminRank(player), GetPlayerName(player), PlayerData[player].name, player, text))
		end
	end
end)

AddCommand("setstats", function (player, target, prefix, ...)
	if (PlayerData[player].admin < 4) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if target == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /setstats <playerid> <prefix> <value>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> cash, bank, level, exp, paycheck, frank")
		return true
	end

	target = tonumber(target)

	if not IsValidPlayer(target) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
	end

	if PlayerData[target].logged_in == false then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This player is not logged in.</>")
	end

	local args = table.concat({...}, " ")

	if prefix == "cash" or prefix == "money" then

		local amount = tonumber(args)

		if amount < 0 or amount > 100000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid amount.</>")
		end

		SetPlayerCash(target, amount)

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s cash to $" .. amount .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. "has set your cash to $" .. amount .. ".")

	elseif prefix == "bank" then

		local amount = tonumber(args)

		if amount < 0 or amount > 100000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid amount.</>")
		end

		PlayerData[target].bank = amount

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s bank cash to $" .. amount .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. "has set your bank cash to $" .. amount .. ".")

	elseif prefix == "level" or prefix == "lvl" then

		local level = tonumber(args)

		if level < 0 or level > 1000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid level.</>")
		end

		PlayerData[target].level = level

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s level to " .. level .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. "has set your level to " .. level .. ".")

	elseif prefix == "exp" or prefix == "xp" then

		local exp = tonumber(args)

		if exp < 0 or exp > 1000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid exp.</>")
		end

		PlayerData[target].exp = exp

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s experience points to " .. exp .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. "has set your experience points to " .. exp .. ".")

	elseif prefix == "paycheck" or prefix == "payday" then

		local amount = tonumber(args)

		if amount < 0 or amount > 10000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid amount.</>")
		end

		--PlayerData[target].payday = amount

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s paycheck to " .. amount .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. "has set your paycheck to " .. amount .. ".")

	elseif prefix == "frank" then

		local rank = tonumber(args)

		if rank < 0 or rank > 10 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid rank.</>")
		end

		PlayerData[target].faction_rank = rank

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s faction rank to " .. rank .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. "has set your faction rank to " .. rank .. ".")

	end
end)

AddCommand("astats", function (player, target)
	if (PlayerData[player].admin < 2) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if target == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /astats <playerid>")
	end

	target = tonumber(target)

	if not IsValidPlayer(target) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
	end

	if PlayerData[target].logged_in == false then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This player is not logged in.</>")
	end

	ViewPlayerStats(player, target)
end)

local function cmd_acv(player, model, plate)
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

local function cmd_aev(player, vehicle, prefix, ...)
	if (PlayerData[player].admin < 2) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if vehicle == nil or prefix == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> <prefix>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> owner, color, plate, rental, faction")
	end

	vehicle = tonumber(vehicle)

	if IsValidVehicle(vehicle) == false or VehicleData[vehicle] == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Vehicle "..vehicle.." doesn't exist or isn't valid.</>")
	end

	local args = {...}

	if prefix == "owner" then
		local target = tonumber(args[1])

		if vehicle == nil or target == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> owner <target>")
		end

		if IsValidPlayer(target) == nil or PlayerData[target] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</target>")
		end

		if PlayerData[target].logged_in == false then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This player is not logged in.</vehicle>")
		end

		if VehicleData[vehicle].faction ~= 0 then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server: As this vehicle was owned by a faction, it will now be passed onto the player.</>")
			VehicleData[vehicle].faction = 0
		end

		VehicleData[vehicle].owner = PlayerData[target].id
		print("Player Char SQLID is "..PlayerData[target].id)
		print("Vehicle Owner Is Now Char SQLID: "..VehicleData[vehicle].owner)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">"..GetPlayerName(target).." now owns the vehicle "..GetVehicleModelEx(vehicle).." (ID: "..vehicle..").</>")
		return

		--CallRemoteEvent(player, "askClientActionConfirmation", 1, "Would you like to change this vehicle's owner?", target, vehicle)
	elseif prefix == "color" then
		local r, g, b

		r = tonumber(args[1])
		g = tonumber(args[2])
		b = tonumber(args[3])

		if r == nil or g == nil or b == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> color <red> <green> <blue>")
		end

		if r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The R, G, B values can only be between 0 to 255.")
		end

		VehicleData[vehicle].r = r
		VehicleData[vehicle].g = g
		VehicleData[vehicle].b = b

		SetVehicleColor(vehicle, RGB(r, g, b))

		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Vehicle "..vehicle.." color changed.</>")
	elseif prefix == "plate" then
		local numberPlate = table.concat({...}, " ")

		if numberPlate == nil or #numberPlate == 0 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> plate <plate>")
		end

		VehicleData[vehicle].plate = numberPlate
		SetVehicleLicensePlate(VehicleData[vehicle].vid, numberPlate)

		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Vehicle "..vehicle.." number plate changed to \""..numberPlate.."\".</>")
	elseif prefix == "rental" then
		local rental = tonumber(args[1])

		if rental == nil or (rental ~= 0 and rental ~= 1) then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> rental <value>")
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Values: No (0), Yes (1)")
			return
		end

		if VehicleData[vehicle].owner ~= 0 then
			VehicleData[vehicle].owner = 0
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> As this vehicle was owned by a player, it will now be passwed onto the state.")
		end

		if VehicleData[vehicle].faction ~= 0 then
			VehicleData[vehicle].faction = 0
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> As this vehicle was owned by a faction, it will now be passed onto the state.")
		end

		VehicleData[vehicle].plate = "RENTAL"
		SetVehicleLicensePlate(vehicle, VehicleData[vehicle].plate)

		VehicleData[vehicle].rental = 1
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">You have made vehicle "..GetVehicleModelEx(vehicle).." (ID: "..vehicle..") a rental vehicle!</>")
	elseif prefix == "faction" then
		local faction = tonumber(args[1])

		if vehicle == nil or faction == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> faction <target>")
		end

		if FactionData[faction] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid faction ID entered.</target>")
		end

		if VehicleData[vehicle].owner ~= 0 then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server: As this vehicle was owned by a player, it will now be passed onto the faction.</>")
			VehicleData[vehicle].owner = 0
		end

		VehicleData[vehicle].faction = FactionData[faction].id
		print("Vehicle Owner Is Now FACTION SQLID: "..FactionData[faction].id)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">"..FactionData[faction].name.." now owns the vehicle "..GetVehicleModelEx(vehicle).." (ID: "..vehicle..").</>")
		return
	else
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /ae(dit)v(ehicle) <argument>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> owner, color, plate, rental, faction")
		return
	end
end
AddCommand('aeditvehicle', cmd_aev)
AddCommand('aev', cmd_aev)

AddRemoteEvent("clientActionConfirmationResult", function (result, player, target, vehicle)
	if result == 1 then
		if VehicleData[vehicle].faction ~= 0 then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> As this vehicle was owned by a faction, it will now be passed onto the player.")
			VehicleData[vehicle].faction = 0
		end

		VehicleData[vehicle].owner = PlayerData[target].id
		print("Player Char SQLID is "..PlayerData[target].id)
		print("Vehicle Owner Is Now Char SQLID: "..VehicleData[vehicle].owner)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">"..GetPlayerName(target).." now owns the vehicle "..GetVehicleModelEx(vehicle).." (ID: "..vehicle..").</>")
		return
	else
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">You've decided to cancel any changes made to the vehicle!</>")
		return
	end
end)

AddCommand("ahelp", function (player)
	if (PlayerData[player].admin < 1) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if PlayerData[player].admin > 0 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 1: </>/a /get /goto /gotoxyz /slap /warp /kick")
	end
	if PlayerData[player].admin > 1 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 2: </>/av /astats")
	end
	if PlayerData[player].admin > 2 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 3: </>/avpark")
	end
	if PlayerData[player].admin > 3 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 4: </>/acreatevehicle /aeditvehicle /acreatemarker /aeditmarker /adestroymarker /acreategarage /aeditgarage /adestroygarage")
	end
	if PlayerData[player].admin > 4 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 5: </>/w /apos /asetadmin /acreatefaction /aeditfaction /setstats /acreatehouse /aedithouse /asetweather /asethelper")
	end
end)

function cmd_acb(player, type, enterable, price, ...)
	if (PlayerData[player].admin < 4) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if type == nil or enterable == nil or price == nil or #{...} == 0 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ac)reate(b)usiness <type> <enterable> <price> <name>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Types: Entrance (1), Local (2), Ammunation (3), Bar (4)")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Types: Restaurant (5), Bank (6)")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Enterable: No (0), Yes (1)")
		return 
	end

	type = tonumber(type)
	enterable = tonumber(enterable)
	price = tonumber(price)
	local name = table.concat({...}, " ")

	if type < 1 or type > BUSINESS_TYPE_MAX then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Types range from 1 to "..BUSINESS_TYPE_MAX.."</>")
	end

	if enterable < 0 or enterable > 1 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Enterable ranges from 0 to 1.</>")
	end

	if price < 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The business cannot be cheaper than $0!</>")
	end

	if string.len(name) < 0 or string.len(name) > 32 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Name length ranges from 1 to 32 characters.</>")
	end

	local business = Business_Create(player, type, enterable, price, name)

	if business == false then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Business ID "..business.." wasn't able to be created!</>")
	else
		return AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Business %d created successfully!", colour.COLOUR_LIGHTRED(), business))
	end
end
AddCommand("acreatebusiness", cmd_acb)
AddCommand("acreatebiz", cmd_acb)
AddCommand("acb", cmd_acb)

AddCommand("asethelper", function (player, target, level)
	if (PlayerData[player].admin < 5 or PlayerData[player].helper ~= 2) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if target == nil or level == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /asethelper <playerid> <level>")
	end

	if IsValidPlayer(target) == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
	end

	target = tonumber(target)

	if PlayerData[target].logged_in == false then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This player is not logged in.</>")
	end

	level = tonumber(level)

	if level > PlayerData[player].helper and PlayerData[player].admin ~= 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You cannot set a level above yours.</>")
	end

	if level < 0 or level > 2 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Helper levels range from 0 - 2.</>")
	end

	PlayerData[target].helper = level

	AddPlayerChat(player, string.format("<span color=\"%s\">You have set %s (%s, %d)'s helper rank to %s (%d).</>",
		colour.COLOUR_YELLOW(), GetPlayerName(target), PlayerData[target].name, target, GetPlayerHelperRank(target), level))

	AddPlayerChat(target, string.format("<span color=\"%s\">%s %s has set your helper rank to %s (%d).</>",
		colour.COLOUR_YELLOW(), GetPlayerHelperRank(player), PlayerData[player].name, GetPlayerHelperRank(target), level))

	local query = mariadb_prepare(sql, "UPDATE accounts SET helper = ? WHERE id = ? LIMIT 1;",
		level,
		PlayerData[target].accountid
	)
	mariadb_async_query(sql, query)
end)

AddCommand("avpark", function (player)

	if (PlayerData[player].admin < 3) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	local vehicle = GetPlayerVehicle(player)

	if IsPlayerInVehicle(player) == false or VehicleData[vehicle] == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be in a parkable vehicle.</>")
	end

	local x, y, z = GetVehicleLocation(vehicle)
	local a = GetVehicleHeading(vehicle)

	VehicleData[vehicle].x = x
	VehicleData[vehicle].y = y
	VehicleData[vehicle].z = z
	VehicleData[vehicle].a = a

	return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server: </> Vehicle ID "..vehicle.." successfully parked!")
end)