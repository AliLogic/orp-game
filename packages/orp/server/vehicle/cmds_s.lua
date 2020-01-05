local colour = ImportPackage('colours')

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

AddCommand("lights", function (playerid)
	if GetPlayerState(playerid) ~= PS_DRIVER then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in the driver seat of the vehicle.</>")
	end

	local vehicleid = GetPlayerVehicle(playerid)
	local x, y, z = GetPlayerLocation(playerid)

	if GetVehicleLightState(vehicleid) then
		--SetVehicleLightState(vehicleid, false) -- This function doesn't exist in the game yet
		AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_LIGHTRED().."\">turned off</> the lights.")
	else
		--SetVehicleLightState(vehicleid, true) -- This function doesn't exist in the game yet
		AddPlayerChat(playerid, "You <span color=\""..colour.COLOUR_DARKGREEN().."\">turned on</> the lights.")
	end
end)

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

		local x, y, z = GetPlayerLocation(player)
		local ownsVehicle = false

		for _, v in pairs(GetAllVehicles()) do
			print(v)
			if VehicleData[v] ~= nil then
				print('not nill '..v)
				--print('Owner is possibly '..VehicleData[v].owner)
				--print(type(VehicleData[v].owner))
				--print(type(PlayerData[player].id))
				if (VehicleData[v].owner == PlayerData[player].id or VehicleData[v].renter == player) then
					--print('player is owner '..v)
					--print('3d distance is '..tonumber(GetDistance3D(x, y, z, VehicleData[v].x, VehicleData[v].y, VehicleData[v].z)))
					if tonumber(GetDistance3D(x, y, z, VehicleData[v].x, VehicleData[v].y, VehicleData[v].z)) < 250.0 then
						--print('player is in distance '..v)
						if VehicleData[v].is_locked == true then
							VehicleData[v].is_locked = false

							if VehicleData[v].rental == 1 and VehicleData[v].renter == player then
								AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Rental vehicle unlocked!</>")
							else
								AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle unlocked!</>")
							end
						else
							VehicleData[v].is_locked = true

							if VehicleData[v].rental == 1 and VehicleData[v].renter == player then
								AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Rental vehicle locked!</>")
							else
								AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Vehicle locked!</>")
							end
						end
						return
					end
					ownsVehicle = true
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
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> lock, park, spawn")
		return
	end
end

AddCommand('v', cmd_v)
AddCommand('vehicle', cmd_v)