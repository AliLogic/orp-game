--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage('colours')

VEHICLE_NAMES = {
	"Premier", "Taxi", "Police Cruiser", "Luxe", "Regal", "Nascar", "Raptor", "Ambulance", "Garbage Truck", "Maverick",
	"Pinnacle", "Sultan", "Bearcat Police", "Bearcat Camo", "Bearcat Medic", "Bearcat Military", "Barracks Police", "Barracks Camo", "Premier SE", 
	"Maverick SE", "Patriot", "Cargo Lite Desert", "Cargo Lite Army", "Securicar", "Dacia"
}

VehicleData = {}
MAX_VEHICLES = 4096

-- Functions

function GetVehicleModelEx(vehicleid)

	if not IsValidVehicle(vehicleid) then
		return false
	end

	return VEHICLE_NAMES[GetVehicleModel(vehicleid)]
end

-- function GetFreeVehicleId()
-- 	for i = 1, MAX_VEHICLES, 1 do
-- 		if VehicleData[i] == nil then
-- 			CreateVehicleData(i)
-- 			return i
-- 		end
-- 	end
-- 	return 0
-- end

function CreateVehicleData(vehicle)
	VehicleData[vehicle] = {}

	VehicleData[vehicle].id = 0
	VehicleData[vehicle].vid = 0
	VehicleData[vehicle].owner = 0

	VehicleData[vehicle].plate = "ONSET"
	VehicleData[vehicle].faction = 0

	VehicleData[vehicle].x = 0
	VehicleData[vehicle].y = 0
	VehicleData[vehicle].z = 0
	VehicleData[vehicle].a = 0

	VehicleData[vehicle].r = 0
	VehicleData[vehicle].g = 0
	VehicleData[vehicle].b = 0

	VehicleData[vehicle].fuel = 0

	VehicleData[vehicle].callsign = nil

	VehicleData[vehicle].is_locked = true
	VehicleData[vehicle].is_spawned = true

	VehicleData[vehicle].rental = 0
	VehicleData[vehicle].renter = 0

	VehicleData[vehicle].impounded = 0

	VehicleData[vehicle].being_repaired = 0
end

function DestroyVehicleData(vehicle)
	VehicleData[vehicle] = nil
end

function Vehicle_Create(model, plate, x, y, z, a)
	model = tonumber(model)

	if (model < 1 or model > 25) then
		return false
	end

	if string.len(plate) < 1 or string.len(plate) > 13 then
		return false
	end

	local vehicle = CreateVehicle(model, x, y, z, a)
	if vehicle == false then
		return false
	end

	CreateVehicleData(vehicle)
	VehicleData[vehicle].vid = vehicle
	SetVehicleLicensePlate(vehicle, plate)

	local r, g, b, al = HexToRGBA(GetVehicleColor(vehicle))

	local query = mariadb_prepare(sql, "INSERT INTO vehicles (model, plate, x, y, z, a, r, g, b) VALUES (?, '?', '?', '?', '?', '?', ?, ?, ?);",
		model,
		plate,
		tostring(x),
		tostring(y),
		tostring(z),
		tostring(a),
		r,
		g,
		b
	)

	mariadb_async_query(sql, query, OnVehicleCreated, vehicle, model, plate, x, y, z, a, r, g, b)
	return vehicle
end

function OnVehicleCreated(vehicle, model, plate, x, y, z, a, r, g, b)
	VehicleData[vehicle].id = mariadb_get_insert_id()
	VehicleData[vehicle].model = model
	VehicleData[vehicle].plate = plate

	VehicleData[vehicle].x = x
	VehicleData[vehicle].y = y
	VehicleData[vehicle].z = z
	VehicleData[vehicle].a = a

	VehicleData[vehicle].r = r
	VehicleData[vehicle].g = g
	VehicleData[vehicle].b = b

	VehicleData[vehicle].fuel = 100
end

function Vehicle_Destroy(vehicle)
	if VehicleData[vehicle] == nil or IsValidVehicle(vehicle) == false then
		return false
	end

	local query = mariadb_prepare(sql, "DELETE FROM vehicles WHERE id = ?", VehicleData[vehicle].id)
	mariadb_async_query(sql, query)

	DestroyVehicle(vehicle)
	DestroyVehicleData(vehicle)

	return true
end

function Vehicle_Load(id)
	local query = mariadb_prepare(sql, "SELECT * FROM vehicles WHERE id = ?", id)
	mariadb_async_query(sql, query, OnVehicleLoaded, id)
end

function OnVehicleLoaded(id)
	if mariadb_get_row_count() == 0 then
		print('Error with loading vehicle ID '..id)
	else
		local result = mariadb_get_assoc(1)

		local vehicle = CreateVehicle(result['model'], tonumber(result['x']), tonumber(result['y']), tonumber(result['z']), tonumber(result['a']))
		if vehicle == false then
			return print('Unable to successfully create vehicle ID '..vehicle..', DBID: '..result['id'])
		end

		CreateVehicleData(vehicle)

		VehicleData[vehicle].id = id
		VehicleData[vehicle].vid = vehicle
		VehicleData[vehicle].model = tonumber(result['model'])
		VehicleData[vehicle].plate = result['plate']

		VehicleData[vehicle].x = tonumber(result['x'])
		VehicleData[vehicle].y = tonumber(result['y'])
		VehicleData[vehicle].z = tonumber(result['z'])
		VehicleData[vehicle].a = tonumber(result['a'])

		VehicleData[vehicle].r = tonumber(result['r'])
		VehicleData[vehicle].g = tonumber(result['g'])
		VehicleData[vehicle].b = tonumber(result['b'])

		VehicleData[vehicle].owner = tonumber(result['owner'])
		VehicleData[vehicle].faction = tonumber(result['faction'])
		VehicleData[vehicle].rental = tonumber(result['rental'])
		VehicleData[vehicle].fuel = tonumber(result['litres'])

		VehicleData[vehicle].impounded = tonumber(result['impounded'])

		--VehicleData[vehicle].nos = mariadb_get_value_name_int(1, "nos")

		SetVehicleLicensePlate(vehicle, VehicleData[vehicle].plate)
		SetVehicleColor(vehicle, RGB(VehicleData[vehicle].r, VehicleData[vehicle].g, VehicleData[vehicle].b))
		StopVehicleEngine(vehicle)
	end
end

function Vehicle_Unload(vehicle)
	local query = mariadb_prepare(sql, "UPDATE vehicles SET owner = ?, model = ?, plate = '?', faction = ?, rental = ?, litres = '?', x = '?', y = '?', z = '?', a = '?', r = ?, g = ?, b = ? WHERE id = ?",
		VehicleData[vehicle].owner,
		VehicleData[vehicle].model,
		tostring(VehicleData[vehicle].plate),
		VehicleData[vehicle].faction,
		VehicleData[vehicle].rental,
		VehicleData[vehicle].fuel,
		tostring(VehicleData[vehicle].x),
		tostring(VehicleData[vehicle].y),
		tostring(VehicleData[vehicle].z),
		tostring(VehicleData[vehicle].a),
		tostring(VehicleData[vehicle].r),
		tostring(VehicleData[vehicle].g),
		tostring(VehicleData[vehicle].b),
		VehicleData[vehicle].id
	)

	mariadb_async_query(sql, query, OnVehicleUnloaded, vehicle)
end

function OnVehicleUnloaded(vehicle)
	if mariadb_get_affected_rows() == 0 then
		print('Vehicle unload unsuccessful, id: '..vehicle)
	else
		print('Vehicle unload successful, id: '..vehicle)
		DestroyVehicle(VehicleData[vehicle].vid)
	end
end

function OnLoadVehicles()
	for i = 1, mariadb_get_row_count(), 1 do
		Vehicle_Load(mariadb_get_value_name_int(i, "id"))
	end

	print("** Vehicles Loaded: "..mariadb_get_row_count()..".")
end

function IsEngineVehicle(vehicleid)

	local model = GetVehicleModel(vehicleid)

	if 1 <= model <= 25 then
		return 1
	end

	return 0
end

function IsVehicleCar(vehicleid)

	local model = GetVehicleModel(vehicleid)

	if 1 <= model <= 9 or 11 <= model <= 19 or 21 <= model <= 25 then
		return 1
	end

	return 0
end

function GetNearestVehicle(playerid)

	local px, py, pz = GetPlayerLocation(playerid)
	local x, y, z = nil

	for _, vehicle in pairs(GetAllVehicles()) do

		x, y, z = GetVehicleLocation(vehicle)

		if tonumber(GetDistance3D(px, py, pz, x, y, z)) <= 200.0 then
			return vehicle
		end
	end

	return 0
end

function IsVehicleImpounded(vehicleid)

	if VehicleData[vehicleid] == nil then
		return false
	end

	return VehicleData[vehicleid].impounded
end

function GetVehicleFuel(vehicleid)

	if VehicleData[vehicleid] == nil then
		return 100
	end

	return VehicleData[vehicleid].fuel
end

function ImpoundVehicle(vehicleid, price)

	SetVehicleLocation(vehicleid, 94358, 120088, 6431)
	SetVehicleDimension(vehicleid, DIMENSION_IMPOUND)

	VehicleData[vehicleid].impounded = price
end

-- Events

AddEvent('LoadVehicles', function ()
	local query = mariadb_prepare(sql, "SELECT * FROM vehicles;")
	mariadb_async_query(sql, query, OnLoadVehicles)
end)

AddEvent('UnloadVehicles', function ()
	for i = 1, #VehicleData, 1 do
		Vehicle_Unload(i)
	end
end)

AddEvent("OnPlayerEnterVehicle", function(playerid, vehicleid, seatid)

	if seatid == 1 then
		if GetVehicleEngineState(vehicleid) == false then
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_DARKGREEN().."\">The engine is off. (/engine)</>")
		end

		if GetPlayerLicense(playerid, LICENSE_TYPE_GDL) == 0 then
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">You are operating a vehicle without the valid license. You might get in trouble.</>")
		end

		if GetVehicleHealth(vehicleid) <= 200.0 then
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This vehicle is totalled and can't be started.</>")
		end

		if GetVehicleFuel(vehicleid) <= 1 then
			AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">The fuel tank is empty.</>")
		end
	end
end)

-- AddEvent("OnPlayerEnterVehicle", function(player, vehicle, seat)
AddRemoteEvent("OnPlayerStartEnterVehicle", function (player, vehicle, seat)
	AddPlayerChat(player, "[DEBUG-S] OnPlayerStartEnterVehicle player: "..player..", vehicle: "..vehicle..", seat :"..seat.."")
	if VehicleData[vehicle] ~= nil then

		if VehicleData[vehicle].rental == 1 then
			if VehicleData[vehicle].renter == 0 and PlayerData[player].renting == 0 then
				SetPlayerInVehicle(player, vehicle, seat)
				AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">This is a rentable "..GetVehicleModelEx(vehicle).." for $50! Enter /rent to rent it.</>")
				AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Note: You will require a valid drivers license.</>")
				return
			end
		end

		if VehicleData[vehicle].is_locked == true then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This vehicle is locked, you cannot enter it!</>")
			Slap(player)
			--return false
		else
			if VehicleData[vehicle].renter ~= 0 and VehicleData[vehicle].renter == player then
				AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Welcome back to your rental vehicle, "..GetPlayerName(player)..".</>")
			end

			AddPlayerChat(player, "[DEBUG-S] The vehicle is unlocked so putting them in!")
			SetPlayerInVehicle(player, vehicle, seat)
		end
	else
		AddPlayerChat(player, "[DEBUG-S] The vehicle is probably an admin vehicle so putting them in!")
		SetPlayerInVehicle(player, vehicle, seat)
	end
end)