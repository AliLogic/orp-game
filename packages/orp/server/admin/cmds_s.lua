local colour = ImportPackage("colours")

AddCommand("banlog", function(playerid, otherplayer)
	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	local query = ""

	if (otherplayer == nil) then
		query = "SELECT admin.steamname as admin_name, player.steamname as admin_name, FROM_UNIXTIME(bans.ban_time) AS ban_time, bans.reason\
		FROM bans\
		INNER JOIN accounts admin ON bans.admin_id = admin.id\
		INNER JOIN accounts player ON bans.id = player.id\
		ORDER BY bans.ban_time DESC LIMIT 10;"
	else
		otherplayer = math.tointeger(otherplayer)

		if (not IsValidPlayer(otherplayer)) then
			return AddPlayerChat(playerid, "Selected player does not exist")
		end

		query = mariadb_prepare(sql, "SELECT admin.steamname as admin_name, player.steamname as admin_name, FROM_UNIXTIME(bans.ban_time) AS ban_time, bans.reason\
		FROM bans\
		INNER JOIN accounts admin ON bans.admin_id = admin.id\
		INNER JOIN accounts player ON bans.id = player.id\
		WHERE bans.id = ?\
		ORDER BY bans.ban_time DESC LIMIT 10;",
			PlayerData[otherplayer].accountid
		)
	end

	mariadb_async_query(sql, query, OnBanLogLoaded, playerid)
end)

AddCommand("ban", function (playerid, lookupid, ...)
	if (PlayerData[playerid].admin < 2) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "Usage: /ban <playerid> <reason*>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if lookupid == playerid then
		return AddPlayerChatError(playerid, "You cannot ban yourself!")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	local reason = ""

	if #{...} == 0 then
		reason = "No reason specified"
	else
		reason = table.concat({...}, " ")

		if string.len(reason) < 3 or string.len(reason) > 128 then
			return AddPlayerChatError(playerid, "Invalid reason length.")
		end
	end

	CreateAccBan(lookupid, playerid, 0, reason)

	KickPlayer(lookupid, "You were banned by "..PlayerData[playerid].steamname.." for "..reason..".")
	return
end)

AddCommand("unban", function (playerid, ...)

	if (PlayerData[playerid].admin < 2) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (#{...} == 0) then
		return AddPlayerChat(playerid, "Usage: /unban <account>")
	end

	local account = table.concat(..., " ")
	local length = string.leng(account)

	if length < 1 or length > 32 then
		return AddPlayerChatError(playerid, "Invalid account specified.")
	end

	DeleteAccBan(playerid, account)
	return
end)

AddCommand("whitelist", function(playerid, steam_id)
	if (PlayerData[playerid].admin < 2) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (steam_id == nil or steam_id == 0) then
		return AddPlayerChatUsage(playerid, "/whitelist <steam id>")
	end

	if (string.len(steam_id) ~= 17) then
		return AddPlayerChatError(playerid, "Parameter \"steam id\".")
	end

	AddWhitelist(playerid, steam_id)
	AddPlayerChat(playerid, "You have added whitelist to for account "..steam_id..".")
end)

AddCommand("whitelistlog", function(playerid, otherplayer)
	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	local query = ""

	if (otherplayer == nil) then
		query = "SELECT player.steamname AS player_name, admin.steamname AS admin_name, timestamp\
		FROM log_whitelists\
		INNER JOIN whitelists\
		ON whitelists.id = log_whitelists.id\
		INNER JOIN accounts player\
		ON player.steamid = whitelists.steam_id\
		INNER JOIN accounts admin\
		ON log_whitelists.admin_id = admin.id\
		ORDER BY log_whitelists.timestamp DESC LIMIT 10;"
	else
		otherplayer = math.tointeger(otherplayer)

		if (not IsValidPlayer(otherplayer)) then
			return AddPlayerChatError(playerid, "Invalid player ID entered.")
		end

		query = mariadb_prepare(sql, "SELECT player.steamname AS player_name, admin.steamname AS admin_name, timestamp\
		FROM log_whitelists\
		INNER JOIN whitelists\
		ON whitelists.id = log_whitelists.id\
		INNER JOIN accounts player\
		ON player.steamid = whitelists.steam_id\
		INNER JOIN accounts admin\
		ON log_whitelists.admin_id = admin.id\
		WHERE log_whitelists.admin_id = ?\
		ORDER BY log_whitelists.timestamp DESC LIMIT 10;",
			PlayerData[otherplayer].accountid
		)
	end

	mariadb_async_query(sql, query, OnWhitelistLogLoaded, playerid)
end)

AddCommand("spec", function (playerid, lookupid)
	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	--[[if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /spec <player>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if lookupid == playerid then
		return AddPlayerChatError(playerid, "You cannot kick yourself!")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	if PlayerData[lookupid].admin > PlayerData[playerid].admin then
		return AddPlayerChatError(playerid, "You can not spectate "..GetPlayerName(lookupid)..".")
	end]]--

	SetPlayerSpectate(playerid, true)
end)

AddCommand("specoff", function (playerid)
	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	SetPlayerSpectate(playerid, false)
end)

AddCommand("clearchat", function (playerid)

	if (PlayerData[playerid].admin < 2) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	for i = 1, 10, 1 do
		AddPlayerChatAll(" ")
	end
end)

AddCommand("kick", function (playerid, lookupid, ...)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /kick <player> <reason*>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if lookupid == playerid then
		return AddPlayerChatError(playerid, "You cannot kick yourself!")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	if PlayerData[lookupid].admin > PlayerData[playerid].admin then
		return AddPlayerChatError(playerid, "You can not kick "..GetPlayerName(lookupid)..".")
	end

	local reason
	if #{...} == 0 then
		reason = "no reason specified"
	else
		reason = table.concat({...}, " ")
	end

	AddPlayerChatAll("AdmCmd: "..GetPlayerName(lookupid).." was kicked by "..GetPlayerName(playerid)..", Reason: "..reason..".")

	KickPlayer(lookupid, reason)
end)

AddCommand("warp", function (playerid, fromid, toid)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (fromid == nil or toid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /warp <player> <target>")
	end

	if (fromid == toid) then
		return AddPlayerChatError(playerid, "You can not warp the same player to itself.")
	end

	if (not IsValidPlayer(fromid)) or (not IsValidPlayer(toid)) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	local x, y, z = GetPlayerLocation(toid)
	SetPlayerLocation(fromid, x, y, z + 10.0)

	return AddPlayerChat(playerid, "Teleported to: "..GetPlayerName(fromid).." ("..fromid..") to "..GetPlayerName(fromid).." ("..fromid..").")
end)

AddCommand("gotoxyz", function (playerid, x, y, z)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (x == nil or y == nil or z == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /gotoxyz <x> <y> <z>")
	end

	SetPlayerLocation(playerid, x, y, z)

	return AddPlayerChat(playerid, "Teleported to: "..x..", "..y..", "..z..".")
end)

AddCommand("slap", function (playerid, lookupid)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /slap <playerid>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	Slap(lookupid)
	return AddPlayerChat(playerid, "You slapped "..GetPlayerName(lookupid).." ("..lookupid..").")
end)

AddCommand("goto", function (playerid, lookupid)
	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /goto <playerid>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if playerid == lookupid then
		return AddPlayerChatError(playerid, "You cannot TP to yourself!")
	end

	local x, y, z = GetPlayerLocation(lookupid)
	SetPlayerLocation(playerid, x, y, z + 10.0)

	return AddPlayerChat(playerid, "Teleported to: "..GetPlayerName(lookupid).." ("..lookupid..").")
end)

AddCommand("get", function (playerid, lookupid)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /get <playerid>")
	end

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if playerid == lookupid then
		return AddPlayerChatError(playerid, "You cannot TP to yourself!")
	end

	local x, y, z = GetPlayerLocation(playerid)
	SetPlayerLocation(lookupid, x, y, z + 10.0)

	return AddPlayerChat(playerid, "You Teleported "..GetPlayerName(lookupid).." ("..lookupid..") to yourself.")
end)

AddCommand("apos", function (player, id)
	if (PlayerData[player].admin < 5) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if GetPlayerVehicle(player) == 0 then
		local x, y, z = GetPlayerLocation(player)
		local a = GetPlayerHeading(player)

		print("[PED] X: "..x.." Y: "..y.." Z: "..z.." A: "..a)
		AddPlayerChat(player, "X: "..x.." Y: "..y.." Z: "..z)
	else
		local vehicle = GetPlayerVehicle(player)
		local x, y, z = GetVehicleLocation(vehicle)
		local a = GetVehicleHeading(vehicle)

		print("[VEH] X: "..x.." Y: "..y.." Z: "..z.." A: "..a)
		AddPlayerChat(player, "X: "..x.." Y: "..y.." Z: "..z)
	end
end)

AddCommand("av", function (player, model)
	if (PlayerData[player].admin < 2) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
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
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if target == nil or level == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /asetadmin <playerid> <level>")
	end

	target = GetPlayerIdFromData(target)

	if not IsValidPlayer(target) then
		return AddPlayerChatError(player, "Invalid player ID entered.")
	end

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
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if #{...} == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /a [text]")
	end

	local text = table.concat({...}, " ")

	SendAdminMessage(string.format("<span color=\"%s\" style=\"bold\">** %s %s (%s, %d): %s</>",
		colour.COLOUR_LIGHTRED(), GetPlayerAdminRank(player), GetPlayerName(player), PlayerData[player].name, player, text)
	)
end)

AddCommand("setstats", function (player, target, prefix, ...)
	if (PlayerData[player].admin < 4) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if target == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /setstats <playerid> <prefix> <value>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> cash, bank, level, exp, paycheck, frank")
		return true
	end

	target = GetPlayerIdFromData(target)

	if not IsValidPlayer(target) then
		return AddPlayerChatError(player, "Invalid player ID entered")
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
		AddPlayerChat(target, GetPlayerName(player) .. " has set your cash to $" .. amount .. ".")

	elseif prefix == "bank" then

		local amount = tonumber(args)

		if amount < 0 or amount > 100000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid amount.</>")
		end

		SetPlayerBankCash(target, amount)

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s bank cash to $" .. amount .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. " has set your bank cash to $" .. amount .. ".")

	elseif prefix == "level" or prefix == "lvl" then

		local level = tonumber(args)

		if level < 0 or level > 1000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid level.</>")
		end

		PlayerData[target].level = level

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s level to " .. level .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. " has set your level to " .. level .. ".")

	elseif prefix == "exp" or prefix == "xp" then

		local exp = tonumber(args)

		if exp < 0 or exp > 1000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid exp.</>")
		end

		PlayerData[target].exp = exp

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s experience points to " .. exp .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. " has set your experience points to " .. exp .. ".")

	elseif prefix == "paycheck" or prefix == "payday" then

		local amount = tonumber(args)

		if amount < 0 or amount > 10000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid amount.</>")
		end

		--PlayerData[target].payday = amount

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s paycheck to " .. amount .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. " has set your paycheck to " .. amount .. ".")

	elseif prefix == "frank" then

		local rank = tonumber(args)

		if rank < 0 or rank > 10 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have inputted an invalid rank.</>")
		end

		PlayerData[target].faction_rank = rank

		AddPlayerChat(player, "You have successfully set " .. GetPlayerName(target) .. "'s faction rank to " .. rank .. ".")
		AddPlayerChat(target, GetPlayerName(player) .. " has set your faction rank to " .. rank .. ".")

	end
end)

AddCommand("astats", function (player, target)
	if (PlayerData[player].admin < 2) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if target == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /astats <playerid>")
	end

	target = GetPlayerIdFromData(target)

	if not IsValidPlayer(target) then
		return AddPlayerChatError(player, "Invalid player ID entered")
	end

	if PlayerData[target].logged_in == false then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This player is not logged in.</>")
	end

	ViewPlayerStats(player, target)
end)

local function cmd_acv(player, model, plate)
	if (PlayerData[player].admin < 4) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
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
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Vehicle %s (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), GetVehicleModelEx(vehicle), vehicle))
		Slap(player)
	end
	return
end
AddCommand('acreatevehicle', cmd_acv)
AddCommand('acv', cmd_acv)

local function cmd_adv(player, vehicle)
	if (PlayerData[player].admin < 2) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if vehicle == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ad)estroy(v)ehicle <vehicle>")
	end

	vehicle = tonumber(vehicle)

	if IsValidVehicle(vehicle) == false or VehicleData[vehicle] == nil then
		return AddPlayerChatError(player, "Vehicle "..vehicle.." doesn't exist or isn't valid.")
	end

	AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Vehicle %s (ID: %d) deleted successfully!", colour.COLOUR_LIGHTRED(), GetVehicleModelEx(vehicle), vehicle))

	Vehicle_Destroy(vehicle)
	return
end
AddCommand('adestroyvehicle', cmd_adv)
AddCommand('adv', cmd_adv)

local function cmd_aev(player, vehicle, prefix, ...)
	if (PlayerData[player].admin < 2) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if vehicle == nil or prefix == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> <prefix>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Prefix:</> owner, color, plate, rental, faction, fuel, health")
	end

	vehicle = tonumber(vehicle)

	if IsValidVehicle(vehicle) == false or VehicleData[vehicle] == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Vehicle "..vehicle.." doesn't exist or isn't valid.</>")
	end

	local args = {...}

	if prefix == "owner" then
		local target = args[1]

		if target == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> owner <target>")
		end

		target = GetPlayerIdFromData(target)

		if not IsValidPlayer(target) or PlayerData[target] == nil then
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

		SetVehicleColor(VehicleData[vehicle].vid, RGB(r, g, b))

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

		VehicleData[vehicle].rental = rental
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">You have made vehicle "..GetVehicleModelEx(vehicle).." (ID: "..vehicle..") a rental vehicle!</>")
	elseif prefix == "faction" then
		local faction = tonumber(args[1])

		if faction == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> faction <target>")
		end

		if FactionData[faction] == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid faction ID entered.</>")
		end

		if VehicleData[vehicle].owner ~= 0 then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server: As this vehicle was owned by a player, it will now be passed onto the faction.</>")
			VehicleData[vehicle].owner = 0
		end

		VehicleData[vehicle].faction = FactionData[faction].id
		print("Vehicle Owner Is Now FACTION SQLID: "..FactionData[faction].id)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">"..FactionData[faction].name.." now owns the vehicle "..GetVehicleModelEx(vehicle).." (ID: "..vehicle..").</>")
		return
	elseif prefix == "fuel" then

		local fuel = args[1]
		if fuel == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> fuel <litres>")
		end

		fuel = tonumber(fuel)
		if fuel < 0 or fuel > 1000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Fuel must be between 0 to 1000 litres.</>")
		end

		VehicleData[vehicle].fuel = fuel
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\"> Vehicle "..GetVehicleModelEx(vehicle).." (ID: "..vehicle..") fuel is now set to "..fuel..".</>")
		return
	elseif prefix == "health" then

		local health = args[1]
		if health == nil then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /(ae)dit(v)ehicle <vehicle> health <0-5000>")
		end

		health = tonumber(health)
		if health < 0 or health > 5000 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Health must be between 0 to 5000.</>")
		end

		SetVehicleHealth(VehicleData[vehicle].vid, health)
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\"> Vehicle "..GetVehicleModelEx(vehicle).." (ID: "..vehicle..") health is now set to "..health..".</>")
		return
	else
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /ae(dit)v(ehicle) <argument>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> owner, color, plate, rental, faction, fuel, health")
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
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 1: </>/a /get /goto /gotoxyz /slap /warp /kick /(spec)off /(whitelist)log /banlog /(assist)s /ajail")

	if PlayerData[player].admin > 1 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 2: </>/av /astats /clearinventory")
	end

	if PlayerData[player].admin > 2 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 3: </>/avpark /near /clearchat /un(ban) /setlicense /revokelicense /flipveh")
	end

	if PlayerData[player].admin > 3 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 4: </>/acreatevehicle /aeditvehicle /adestroyvehicle /acreatemarker /aeditmarker /adestroymarker /acreategarage /aeditgarage /adestroygarage")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 4: </>/setarmour /sethealth /toggleg /gotohouse /housedoors /gotopump /gotodoor /gotoveh /gotoplant /gotospeedcam /gotobiz")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 4: </>/gotofurniture")
	end

	if PlayerData[player].admin > 4 then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 5: </>/w /apos /asetadmin /acreatefaction /aeditfaction /setstats /acreatehouse /aedithouse /asetweather /asetfog")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Level 5: </>/asethelper /acreatespeedcam /aeditspeedcam /adestroyplant")
	end
end)

AddCommand("asethelper", function (player, target, level)
	if (PlayerData[player].admin < 5 or PlayerData[player].helper ~= 2) then
		return AddPlayerChatError(player, "You don't have permission to use this command.")
	end

	if target == nil or level == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /asethelper <playerid> <level>")
	end

	if not IsValidPlayer(target) then
		return AddPlayerChatError(player, "Invalid player ID entered")
	end

	target = GetPlayerIdFromData(target)

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
		return AddPlayerChatError(player, "You don't have permission to use this command.")
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

AddCommand("toggleg", function (playerid)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if OOCStatus == false then
		AddPlayerChat(playerid, "The global OOC chat has been <span color=\""..colour.COLOUR_LIGHTRED().."\">disabled</>.")
	else
		AddPlayerChat(playerid, "The global OOC chat has been <span color=\""..colour.COLOUR_DARKGREEN().."\">enabled</>.")
	end

	OOCStatus = not OOCStatus
end)

AddCommand("setarmour", function (playerid, lookupid, armour)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if lookupid == nil or armour == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /setarmour <playerid> <armour>")
	end

	lookupid = GetPlayerIdFromData(lookupid)
	armour = tonumber(armour)

	if IsValidPlayer(lookupid) == nil then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	if armour < 0 or armour > 100 then
		return AddPlayerChatError(playerid, "Invalid health specified.")
	end

	if PlayerData[lookupid].logged_in == false then
		return AddPlayerChatError(playerid, "This player is not logged in.")
	end

	SetPlayerArmor(lookupid, armour)

	AddPlayerChat(playerid, "You have set "..GetPlayerName(lookupid).."'s health to "..armour..".")
	AddPlayerChat(lookupid, GetPlayerName(lookupid).." has set your health to "..armour..".")
end)

AddCommand("sethealth", function (playerid, lookupid, health)

	if (PlayerData[playerid].admin < 4) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if lookupid == nil or health == nil then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /sethealth <playerid> <health>")
	end

	lookupid = GetPlayerIdFromData(lookupid)
	health = tonumber(health)

	if IsValidPlayer(lookupid) == nil then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	if health < 0 or health > 100 then
		return AddPlayerChatError(playerid, "Invalid health specified.")
	end

	if PlayerData[lookupid].logged_in == false then
		return AddPlayerChatError(playerid, "This player is not logged in.")
	end

	SetPlayerHealth(lookupid, health)

	AddPlayerChat(playerid, "You have set "..GetPlayerName(lookupid).."'s health to "..health..".")
	AddPlayerChat(lookupid, GetPlayerName(lookupid).." has set your health to "..health..".")
end)

AddCommand("near", function(playerid)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	local id = 0

	id = GetNearestVehicle(playerid)
	if (id ~= 0) then
		AddPlayerChat(playerid, "You are standing near vehicle ID: "..id.." (Model: "..GetVehicleModelEx(id)..".")
	end

	id = Speedcam_Nearest(playerid)
	if (id ~= 0) then
		AddPlayerChat(playerid, "You are standing near speedcam ID: "..id..".")
	end

	id = Business_Nearest(playerid)
	if (id ~= 0) then
		AddPlayerChat(playerid, "You are standing near business ID: "..id..".")
	end

	id = Housing_Nearest(playerid)
	if (id ~= 0) then
		AddPlayerChat(playerid, "You are standing near house ID: "..id..".")
	end

	id = Marker_Nearest(playerid)
	if (id ~= 0) then
		AddPlayerChat(playerid, "You are standing near marker ID: "..id..".")
	end

	id = Door_Nearest(playerid)
	if (id ~= 0) then
		AddPlayerChat(playerid, "You are standing near door ID: "..id..".")
	end

	id = Pump_Nearest(playerid)
	if (id ~= 0) then
		AddPlayerChat(playerid, "You are standing near pump ID: "..id..".")
	end
end)

AddCommand("assists", function (playerid)

	if PlayerData[playerid].admin == 0 and PlayerData[playerid].helper == 0 then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	local count = false

	for _, i in pairs(GetAllPlayers()) do
		if PlayerData[i].assistance ~= 0 then
			AddPlayerChat(playerid, "Assistances required by: ".. GetPlayerName(i) .." (".. i ..") ")

			count = true
		end
	end

	if count == false then
		return AddPlayerChat(playerid, "No one has requested an assistance!")
	end
end)

AddCommand("assistance", function (playerid, ...)
	local message = table.concat({...}, " ")
	local length = string.len(message)

	if #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage: </>/assistance <message>")
	end

	if length < 5 or length > 50 then
		return AddPlayerChatError(playerid, "Invalid request message length.")
	end

	if PlayerData[playerid].assistance ~= 0 then
		return AddPlayerChatError(playerid, "You have already requested an assistance. Please use /cancelassist if you no longer need help.")
	end

	SendAssistance(playerid, message)

	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_YELLOW().."\">Your help request has been sent to our online staff members... Please wait!</>")
	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_YELLOW().."\">Please use /cancelassist if you no longer need help.</>")
end)

function SendAssistance(playerid, message)

	SendStaffMessage("<span color=\""..colour.COLOUR_BLUE().."\">[HELPER]: </>"..PlayerData[playerid].name.." is requiring assistance. Use /assist "..playerid.." to assist them.")
	SendStaffMessage("<span color=\""..colour.COLOUR_BLUE().."\">[ASSIST]: </>"..PlayerData[playerid].name.." ("..playerid.."): "..message)

	PlayerData[playerid].assistance = 1
end

AddCommand("cancelassist", function (playerid)
	if PlayerData[playerid].assistance == 0 then
		return AddPlayerChatError(playerid, "You have not requested any assistance.")
	end

	PlayerData[playerid].assistance = 0
	SendStaffMessage("<span color=\""..colour.COLOUR_BLUE().."\">[ASSIST]: </>"..PlayerData[playerid].name.." has canceled their assist request.")
end)

AddCommand("assist", function (playerid, lookupid, ...)

	if PlayerData[playerid].admin == 0 and PlayerData[playerid].helper == 0 then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if lookupid == nil or #{...} == 0 then
		return AddPlayerChat(playerid, "Usage: /assist <playerid> <message>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if (not IsValidPlayer(lookupid)) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	local message = table.concat({...}, " ")
	local length = string.len(message)

	if length < 5 or length > 50 then
		return AddPlayerChatError(playerid, "Invalid request message length.")
	end

	if PlayerData[lookupid].assistance == 0 then
		return AddPlayerChatError(playerid, "Player has not requested any assistance.")
	end

	AddPlayerChat(lookupid, "<span color=\""..colour.COLOUR_YELLOW().."\">[ASSIST]</> "..PlayerData[playerid].steamname..": "..message)
	AddPlayerChat(playerid, "Your assist message has been sent: ".. message ..".")

	PlayerData[lookupid].assistance = 0

	return
end)

AddCommand("revokelicense", function (playerid, lookupid, license)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if lookupid == nil or license == nil then
		AddPlayerChat(playerid, "Usage: /revokelicense <playerid> <license>")

		local string = ""
		for i = 1, #LicensesColumns, 1 do
			string = string .. LicensesColumns[i] .. ", "
		end

		string = string:sub(1, -3)
		return AddPlayerChat(playerid, "Licenses: "..string..".")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if (not IsValidPlayer(lookupid)) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	for i = 1, #LicensesColumns, 1 do
		if license == LicensesColumns[i] then

			AddPlayerChat(playerid, "You have revoked " .. GetPlayerName(lookupid) .. "'s " .. LicensesColumns[i] .. " .")
			AddPlayerChat(lookupid, GetPlayerName(playerid) .. " has revoked your " .. LicensesColumns[i] .. " .")

			SetPlayerLicense(lookupid, i, 0)
			return
		end
	end

	AddPlayerChatError(playerid, "Invalid license name specified.")

	return
end)

AddCommand("grantlicense", function (playerid, lookupid, license)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if lookupid == nil or license == nil then
		AddPlayerChat(playerid, "Usage: /grantlicense <playerid> <license>")

		local string = ""
		for i = 1, #LicensesColumns, 1 do
			string = string .. LicensesColumns[i] .. ", "
		end

		string = string:sub(1, -3)
		return AddPlayerChat(playerid, "Licenses: "..string..".")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if (not IsValidPlayer(lookupid)) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	for i = 1, #LicensesColumns, 1 do
		if license == LicensesColumns[i] then

			AddPlayerChat(playerid, "You have granted " .. GetPlayerName(lookupid) .. "'s " .. LicensesColumns[i] .. " .")
			AddPlayerChat(lookupid, GetPlayerName(playerid) .. " has granted your " .. LicensesColumns[i] .. " .")

			SetPlayerLicense(lookupid, i, 1)
			return
		end
	end

	AddPlayerChatError(playerid, "Invalid license name specified.")

	return
end)

AddCommand("ajail", function (playerid, lookupid, minutes)

	if (PlayerData[playerid].admin < 1) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if lookupid == nil or minutes == nil then
		return AddPlayerChat(playerid, "Usage: /ajail <playerid> <minutes>")
	end

	lookupid = GetPlayerIdFromData(lookupid)
	minutes = tonumber(minutes)

	if (not IsValidPlayer(lookupid)) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	if playerid == lookupid then
		return AddPlayerChatError(playerid, "You cannot admin jail yourself!")
	end

	if (minutes < 0 or minutes > 1440) then
		return AddPlayerChatError(playerid, "Minutes can be between 0 to 1440 (24 hours).")
	end

	if (PlayerData[lookupid].ajail == 0 and minutes == 0) then
		return AddPlayerChatError(playerid, "The specified player is not admin jailed.")
	end

	if minutes ~= 0 then

		if PlayerData[lookupid].ajail ~= 0 then
			PutPlayerInAdminJail(lookupid)
		end
		PlayerData[lookupid].ajail = (PlayerData[lookupid].ajail + minutes)

		AddPlayerChat(lookupid, ""..GetPlayerName(playerid).." has admin jailed you for "..minutes.." minutes.")
		AddPlayerChat(playerid, ""..GetPlayerName(lookupid).." has been admin jailed by you for "..minutes..".")

		FreezePlayer(lookupid, true)
	else
		PlayerData[lookupid].ajail = 0

		AddPlayerChat(lookupid, ""..GetPlayerName(playerid).." has admin un-jailed you.")
		AddPlayerChat(playerid, ""..GetPlayerName(lookupid).." has been admin un-jailed by you.")

		FreezePlayer(lookupid, false)
	end

	return
end)

AddCommand("arevive", function (playerid, lookupid)

	if (PlayerData[playerid].admin < 2) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "Usage: /arevive <playerid>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	if PlayerData[lookupid].state == CHARACTER_STATE_ALIVE then
		return
	end

	ClearCharacterDeath(lookupid)
	PlayerData[lookupid].state = CHARACTER_STATE_ALIVE
	SetPlayerHealth(lookupid, 10.0)

	AddPlayerChat(playerid, "You have revived "..GetPlayerName(lookupid)..".")
	AddPlayerChat(lookupid, ""..GetPlayerName(playerid).." has revived you.")

	return
end)

AddCommand("clearinventory", function (playerid, lookupid)

	if (PlayerData[playerid].admin < 2) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "Usage: /clearinventory <playerid>")
	end

	lookupid = GetPlayerIdFromData(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChatError(playerid, "Invalid player ID entered.")
	end

	Inventory_Clear(lookupid)

	AddPlayerChat(playerid, "You have cleared "..GetPlayerName(lookupid).."'s inventory from all items.")
	AddPlayerChat(lookupid, ""..GetPlayerName(playerid).." has cleared your inventory from all items.")

	return
end)

AddCommand("flipveh", function (playerid, vehicleid)

	if (PlayerData[playerid].admin < 2) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	local player_vehicle = GetPlayerVehicle(playerid)

	if (player_vehicle > 0 and vehicleid == nil) then

		local x, y, z = GetVehicleRotation(player_vehicle)
		SetVehicleRotation(player_vehicle, 0.0, y, 0.0)
		AddPlayerChat(playerid, "You have flipped your current vehicle.")

	else

		if vehicleid == nil then
			return AddPlayerChat(playerid, "Usage: /flipveh <vehicleid>")
		end

		vehicleid = tonumber(vehicleid)

		if not IsValidVehicle(vehicleid) then
			return AddPlayerChatError(playerid, "Invalid vehicle ID entered.")
		end

		local x, y, z = GetVehicleRotation(vehicleid)
		SetVehicleRotation(vehicleid, 0.0, y, 0.0)
		AddPlayerChat(playerid, "You have flipped vehicle ID: " .. vehicleid .. ".")
	end
end)