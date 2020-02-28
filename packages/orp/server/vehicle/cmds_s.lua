--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage('colours')

-- Functions and Events

AddCommand("listcars", function (playerid)

	AddPlayerChat(playerid, "Vehicles registered to you, "..GetPlayerName(playerid).." ("..playerid.."):")

	ShowVehiclesList(playerid, playerid)
end)

local function cmd_drivingtest(playerid)

	if PlayerData[playerid].driving_test then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have already started the driving test!</>")
	end

	local x, y, z = GetPlayerLocation(playerid)

	if (not IsPlayerInRangeOfPoint(playerid, 200.0, LOC_DRIVINGTEST_X, LOC_DRIVINGTEST_Y, LOC_DRIVINGTEST_Z)) then -- -167501.3, -34790.8, 1036.2
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in range of the pickup.</>")
	end

	if GetPlayerLicense(playerid, LICENSE_TYPE_GDL) ~= 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have your General Driving License (GDL) already!</>")
	end

	if GetPlayerCash(playerid) < 250 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have $250 for the driving test.</>")
	end

	local vehicleid = CreateVehicle(1, 193821, 209478, 1213, -90.0)

	PlayerData[playerid].test_vehicle = vehicleid
	SetVehicleColor(vehicleid, RGB(255, 255, 255, 255))
	SetVehicleLicensePlate(vehicleid, "GDL-TEST-"..playerid.."")
	PlayerData[playerid].test_warns = 0

	if vehicleid ~= 0 then

		CreateVehicleData(vehicleid)
		VehicleData[vehicleid].fuel = 100

		PlayerData[playerid].driving_test = true
		PlayerData[playerid].test_stage = 1
		SetPlayerInVehicle(playerid, PlayerData[playerid].test_vehicle, 1)

		AddPlayerChat(playerid, "You have started the driving test.")
	end

	return
end
AddCommand("drivingtest", cmd_drivingtest)

local function cmd_engine(playerid)

	if GetPlayerState(playerid) ~= PS_DRIVER then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the driver seat of the vehicle.</>")
	end

	local vehicleid = GetPlayerVehicle(playerid)

	if GetVehicleHealth(vehicleid) <= 200.0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This vehicle is totalled and can't be started.</>")
	end

	if VehicleData[vehicleid].fuel <= 1 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The fuel tank is empty.</>")
	end

	local x, y, z = GetPlayerLocation(playerid)

	if VehicleData[vehicleid] ~= nil then
		if VehicleData[vehicleid].renter ~= playerid and VehicleData[vehicleid].rental == 1 then
			return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have the keys to this vehicle.</>")
		end
	end

	if GetVehicleEngineState(vehicleid) then
		StopVehicleEngine(vehicleid)
		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(playerid).." stopped the engine of the "..GetVehicleModelEx(vehicleid)..".</>")
	else
		StartVehicleEngine(vehicleid)
		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(playerid).." started the engine of the "..GetVehicleModelEx(vehicleid)..".</>")
	end

	return
end
AddCommand("engine", cmd_engine)

local function cmd_v(player, args)

	if args == "lock" then

		local vehicle = GetPlayerVehicle(player)
		if vehicle ~= 0 and VehicleData[vehicle] ~= nil and (VehicleData[vehicle].owner == PlayerData[player].id or VehicleData[vehicle].renter == player) then
			if VehicleData[vehicle].is_locked == true then
				VehicleData[vehicle].is_locked = false
				ShowFooterMessage(player, "Vehicle unlocked!", colour.COLOUR_DARKGREEN())
			else
				VehicleData[vehicle].is_locked = true
				ShowFooterMessage(player, "Vehicle locked!", colour.COLOUR_LIGHTRED())
			end
			return
		end

		local x, y, z = GetPlayerLocation(player) -- Get the player's location

		for _, v in pairs(VehicleData) do
			local vx, vy, vz = GetVehicleLocation(v.vid)

			if GetDistance3D(x, y, z, vx, vy, vz) <= 200.0 then
				if (v.owner == PlayerData[player].id) or
				(v.renter == player) or
				(v.faction == PlayerData[player].faction) or
				(Key_PlayerHasKey(player, KEY_VEHICLE, v.id) ~= 0) then

					if v.is_locked == true then
						v.is_locked = false

						ShowFooterMessage(player, "Vehicle unlocked!", colour.COLOUR_DARKGREEN())
					else
						v.is_locked = true

						ShowFooterMessage(player, "Vehicle locked!", colour.COLOUR_LIGHTRED())
					end

					return
				end
			end
		end

		return AddPlayerChatError(player, "You are not near any vehicles that you may have access!")

	elseif args == "park" then
		local vehicle = GetPlayerVehicle(player)

		if (vehicle == 0 or VehicleData[vehicle] == nil) or VehicleData[vehicle].owner ~= PlayerData[player].id then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any vehicle you own!</>")
		end

		if GetPlayerVehicleSeat(player) ~= 1 then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be in the driver's seat of your vehicle!</>")
		end

		local x, y, z = GetVehicleLocation(vehicle)
		local a = GetVehicleHeading(vehicle)

		VehicleData[vehicle].x = x
		VehicleData[vehicle].y = y
		VehicleData[vehicle].z = z
		VehicleData[vehicle].a = a

		Vehicle_Unload(vehicle)
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle parked!</>")
	elseif args == "lights" then

		local vehicle = GetPlayerVehicle(player)

		if GetVehicleLightState(vehicle) then
			SetVehicleLightEnabled(vehicle, false)
			AddPlayerChat(player, "You turned <span color=\""..colour.COLOUR_LIGHTRED().."\">off</> the lights.")
		else
			SetVehicleLightEnabled(vehicle, true)
			AddPlayerChat(player, "You turned <span color=\""..colour.COLOUR_DARKGREEN().."\">on</> the lights.")
		end

	elseif args == "spawn" then
		local vehicle = tonumber(args[2])

		if vehicle == nil then
			local vehicles = ''

			for i = 1, #VehicleData, 1 do
				if Vehicle_IsOwner(player, i) then
					vehicles = string.format('%s ID:%d, Model: %s |', vehicles, i, GetVehicleModelEx(VehicleData[i].vid))
				end
			end

			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /v(ehicle) spawn <id>")
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Owned Vehicles:" .. vehicles)
			return
		end

		if VehicleData[vehicle] == nil or PlayerData[player].id ~= VehicleData[vehicle].owner then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Invalid vehicle.")
		end

		if VehicleData[vehicle].vid ~= 0 then
			return AddPlayerChatError(player, "This vehicle is already spawned.")
		end

		Vehicle_Load(VehicleData[vehicle].id)
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle "..vehicle.." (Model: "..VehicleData[vehicle].model..") spawned!</>")
	elseif args == "trunk" then
		if GetPlayerState(player) ~= PS_DRIVER then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the driver seat of the vehicle.</>")
		end

		local vehicleid = GetPlayerVehicle(player)
		if not IsTrunkVehicle(vehicleid) then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This vehicle does not have a accessible trunk.")
		end

		local x, y, z = GetPlayerLocation(player)

		if GetVehicleTrunkRatio(vehicleid) > 0 then
			SetVehicleTrunkRatio(vehicleid, 0.0)
			AddPlayerChat(player, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">closed</> your vehicle trunk.")
		else
			SetVehicleTrunkRatio(vehicleid, 60.0)
			AddPlayerChat(player, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">opened</> your vehicle trunk.")
		end
	elseif args == "hood" then
		if GetPlayerState(player) ~= PS_DRIVER then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the driver seat of the vehicle.</>")
		end

		local vehicleid = GetPlayerVehicle(player)
		if not IsHoodVehicle(vehicleid) then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: This vehicle does not have a accessible hood.")
		end

		local x, y, z = GetPlayerLocation(player)

		if GetVehicleHoodRatio(vehicleid) > 0 then
			SetVehicleHoodRatio(vehicleid, 0.0)
			AddPlayerChat(player, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">closed</> your vehicle hood.")
		else
			SetVehicleHoodRatio(vehicleid, 60.0)
			AddPlayerChat(player, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">opened</> your vehicle hood.")
		end
	else
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /v(ehicle) <argument>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> lock, park, spawn, lights, trunk, hood.")
		return
	end
end

AddCommand('v', cmd_v)
AddCommand('vehicle', cmd_v)

AddCommand("gotoveh", function (playerid, vehid)

	if (PlayerData[playerid].admin < 3) then
		return AddPlayerChatError(playerid, "You don't have permission to use this command.")
	end

	if vehid == nil then
		return AddPlayerChatUsage(playerid, "/gotoveh <veh>")
	end

	vehid = tonumber(vehid)

	if VehicleData[vehid] == nil then
		return AddPlayerChatError(playerid, "Vehicle " .. vehid .. " doesn't exist.")
	end

	SetPlayerLocation(playerid, VehicleData[vehid].x, VehicleData[vehid].y, VehicleData[vehid].z + 20.0)

	AddPlayerChat(playerid, "You have been teleported to vehicle ID: " .. vehid ..".")
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
		AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Vehicle %s (ID: %d) created successfully!", colour.COLOUR_LIGHTRED(), GetVehicleModelEx(VehicleData[vehicle].vid), vehicle))
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

	if VehicleData[vehicle] == nil then
		return AddPlayerChatError(player, "Vehicle "..vehicle.." doesn't exist or isn't valid.")
	end

	AddPlayerChat(player, string.format("<span color=\"%s\">Server: </>Vehicle %s (ID: %d) deleted successfully!", colour.COLOUR_LIGHTRED(), GetVehicleModelEx(VehicleData[vehicle].vid), vehicle))

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

	if VehicleData[vehicle] == nil then
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

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">"..GetPlayerName(target).." now owns the vehicle "..GetVehicleModelEx(VehicleData[vehicle].vid).." (ID: "..vehicle..").</>")
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
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">You have made vehicle "..GetVehicleModelEx(VehicleData[vehicle].vid).." (ID: "..vehicle..") a rental vehicle!</>")
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

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">"..FactionData[faction].name.." now owns the vehicle "..GetVehicleModelEx(VehicleData[vehicle].vid).." (ID: "..vehicle..").</>")
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
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\"> Vehicle "..GetVehicleModelEx(VehicleData[vehicle].vid).." (ID: "..vehicle..") fuel is now set to "..fuel..".</>")
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
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\"> Vehicle "..GetVehicleModelEx(VehicleData[vehicle].vid).." (ID: "..vehicle..") health is now set to "..health..".</>")
		return
	else
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /ae(dit)v(ehicle) <argument>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> owner, color, plate, rental, faction, fuel, health")
		return
	end
end
AddCommand('aeditvehicle', cmd_aev)
AddCommand('aev', cmd_aev)