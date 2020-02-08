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

local function cmd_drivingtest(playerid)

	if PlayerData[playerid].driving_test then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have already started the driving test!</>")
	end

	local x, y, z = GetPlayerLocation(playerid)

	if GetDistance3D(195320, 207826, 1215, 0.0, 0.0, 0.0) > 120.0 then -- -167501.3, -34790.8, 1036.2
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in range of the pickup.</>")
	end

	if GetPlayerLicense(playerid, LICENSE_TYPE_GDL) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You have your General Driving License (GDL) already!</>")
	end

	if GetPlayerCash(playerid) < 250 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have $250 for the driving test.</>")
	end

	local vehicleid = CreateVehicle(1, 195320, 207826, 1215, 90.0)

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

	if GetVehicleHealth(vehicleid) <= 100.0 then
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

AddCommand("hood", function (playerid)
	if GetPlayerState(playerid) ~= PS_DRIVER then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the driver seat of the vehicle.</>")
	end

	local vehicleid = GetPlayerVehicle(playerid)
	local x, y, z = GetPlayerLocation(playerid)

	if GetVehicleHoodRatio(vehicleid) > 0 then
		SetVehicleHoodRatio(vehicleid, 0.0)
		AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">closed</> your vehicle hood.")
	else
		SetVehicleHoodRatio(vehicleid, 60.0)
		AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">opened</> your vehicle hood.")
	end
end)

AddCommand("trunk", function (playerid)
	if GetPlayerState(playerid) ~= PS_DRIVER then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the driver seat of the vehicle.</>")
	end

	local vehicleid = GetPlayerVehicle(playerid)
	local x, y, z = GetPlayerLocation(playerid)

	if GetVehicleTrunkRatio(vehicleid) > 0 then
		SetVehicleTrunkRatio(vehicleid, 0.0)
		AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">closed</> your vehicle trunk.")
	else
		SetVehicleTrunkRatio(vehicleid, 60.0)
		AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">opened</> your vehicle trunk.")
	end
end)

local function cmd_v(player, ...)
	local args = {...}

	if args[1] == "lock" then
		local vehicle = GetPlayerVehicle(player)
		if vehicle ~= 0 and VehicleData[vehicle] ~= nil and (VehicleData[vehicle].owner == PlayerData[player].id or VehicleData[vehicle].renter == player) then
			if VehicleData[vehicle].is_locked == true then
				VehicleData[vehicle].is_locked = false
				AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle unlocked!</>")
			else
				VehicleData[vehicle].is_locked = true
				AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Vehicle locked!</>")
			end
			return
		end

		local x, y, z = GetPlayerLocation(player) -- Get the player's location
		local ownsVehicle = false -- Player owns the vehicle bool

		for _, v in pairs(GetAllVehicles()) do
			if IsValidVehicle(v) then
				if VehicleData[v] ~= nil then
					local vx, vy, vz = GetVehicleLocation(v)

					if GetDistance3D(x, y, z, vx, vy, vz) <= 200.0 then
						if (VehicleData[v].owner == PlayerData[player].id) or
						(VehicleData[v].renter == player) or
						(VehicleData[v].faction == PlayerData[player].faction) then

							if VehicleData[v].is_locked == true then
								VehicleData[v].is_locked = false

								AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle unlocked!</>")
							else
								VehicleData[v].is_locked = true

								AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Vehicle locked!</>")
							end
							ownsVehicle = true
							return
						end
					end
				end
			end
		end

		if ownsVehicle == false then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You do not own any vehicles!</>")
		else
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not near any of your owned vehicles!</>")
		end

	elseif args[1] == "park" then
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

		VehicleData[vehicle].is_spawned = false

		Vehicle_Unload(vehicle)
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle parked!</>")
	elseif args[1] == "lights" then

		local vehicle = GetPlayerVehicle(player)

		if GetVehicleLightState(vehicle) then
			SetVehicleLightEnabled(vehicle, false)
			AddPlayerChat(player, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">turned off</> the lights.")
		else
			SetVehicleLightEnabled(vehicle, true)
			AddPlayerChat(player, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">turned on</> the lights.")
		end

	elseif args[1] == "spawn" then
		local vehicle = tonumber(args[2])

		if vehicle == nil then
			local vehicles = ''

			for i = 1, #VehicleData, 1 do
				if VehicleData[i] ~= nil then
					print('IS NOT NILL')
					print(type(VehicleData[i].owner))
					print(type(PlayerData[player].id))
					if VehicleData[i].owner == PlayerData[player].id then
						vehicles = string.format('%s ID:%d, Model:%d |', vehicles, i, VehicleData[i].model)
					end
				end
			end

			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /v(ehicle) spawn <ingame id>")
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Owned Vehicles:"..vehicles)
			return
		end

		--print('next codeblock')

		if VehicleData[vehicle] == nil or PlayerData[player].id ~= VehicleData[vehicle].owner then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Invalid vehicle.")
		end

		if VehicleData[vehicle].is_spawned == true then
			return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> This vehicle is already spawned.")
		end

		Vehicle_Load(VehicleData[vehicle].id)
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle "..vehicle.." (Model: "..VehicleData[vehicle].model..") spawned!</>")
	else
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /v(ehicle) <argument>")
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> lock, park, spawn, lights")
		return
	end
end

AddCommand('v', cmd_v)
AddCommand('vehicle', cmd_v)