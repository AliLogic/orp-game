--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage('colours')
local sound = ImportPackage('soundstreamer')

VEHICLE_NAMES = {
	"Premier", "Taxi", "Police Cruiser", "Luxe", "Regal", "Nascar", "Raptor", "Ambulance", "Garbage Truck", "Maverick",
	"Pinnacle", "Sultan", "Bearcat Police", "Bearcat Camo", "Bearcat Medic", "Bearcat Military", "Barracks Police", "Barracks Camo", "Premier SE", 
	"Maverick SE", "Patriot", "Cargo Lite Desert", "Cargo Lite Army", "Securicar", "Dacia"
}

VehicleData = {}
MAX_VEHICLES = 4096

VEHICLE_TYPE_NORMAL = 1
VEHICLE_TYPE_ADMIN = 2

-- Functions

function FindVehicleIdByIndex(vehicleid)

	for _, v in ipairs(VehicleData) do
		if vehicleid == v.vid then
			return v
		end
	end

	return 0
end

function GetVehicleModelEx(vehicleid)

	if not IsValidVehicle(vehicleid) then
		return false
	end

	return VEHICLE_NAMES[GetVehicleModel(vehicleid)]
end

function GetFreeVehicleId()
	for i = 1, MAX_VEHICLES, 1 do
		if VehicleData[i] == nil then
			CreateVehicleData(i)
			return i
		end
	end
	return 0
end

function CreateVehicleData(vehicle)
	VehicleData[vehicle] = {}

	VehicleData[vehicle].type = VEHICLE_TYPE_NORMAL

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

	VehicleData[vehicle].callsign = 0

	VehicleData[vehicle].is_locked = true
	VehicleData[vehicle].is_spawned = true

	VehicleData[vehicle].rental = 0
	VehicleData[vehicle].renter = 0

	VehicleData[vehicle].alarm = 0

	VehicleData[vehicle].impounded = 0
	VehicleData[vehicle].being_repaired = 0
	VehicleData[vehicle].alarm_id = 0
end

function DestroyVehicleData(vehicle)
	VehicleData[vehicle] = nil
end

function IsHoodVehicle(vehicleid)

	local modelid = GetVehicleModel(vehicleid)
	local array = {1, 2, 3, 4, 5, 6, 7, 8, 19, 24, 25}

	for _, v in ipairs(array) do
		if modelid == v then
			return true
		end
	end
	return false
end

function IsTrunkVehicle(vehicleid)
	local modelid = GetVehicleModel(vehicleid)
	local array = {1, 2, 3, 4, 5, 7, 8, 11, 12, 19, 24, 25}

	for _, v in ipairs(array) do
		if modelid == v then
			return true
		end
	end
	return false
end

function Vehicle_Create(model, plate, x, y, z, a)
	model = tonumber(model)

	if (model < 1 or model > 25) then
		return false
	end

	if string.len(plate) < 1 or string.len(plate) > 13 then
		return false
	end

	local index = GetFreeVehicleId()
	if index == false then
		return false
	end

	local vehicleid = CreateVehicle(model, x, y, z, a)
	if vehicleid == false then
		return false
	end

	SetVehicleRespawnParams(vehicleid, false, 0, false)
	VehicleData[index].vid = vehicleid
	SetVehicleLicensePlate(vehicleid, plate)

	local r, g, b, al = HexToRGBA(GetVehicleColor(vehicleid))

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

	mariadb_async_query(sql, query, OnVehicleCreated, index, model, plate, x, y, z, a, r, g, b)
	return index
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

function Vehicle_Load(i)

	local vehicle = CreateVehicle(mariadb_get_value_name_int(i, "model"), mariadb_get_value_name_int(i, "x"), mariadb_get_value_name_int(i, "y"), mariadb_get_value_name_int(i, "z"), mariadb_get_value_name_int(i, "a"))
	if vehicle == false then
		return print('Unable to successfully create vehicle ID '..vehicle..', DBID: '..mariadb_get_value_name_int(i, "id"))
	end

	SetVehicleRespawnParams(vehicle, false, 0, false)
	CreateVehicleData(vehicle)

	VehicleData[vehicle].type = VEHICLE_TYPE_NORMAL

	VehicleData[vehicle].id = mariadb_get_value_name_int(i, "id")
	VehicleData[vehicle].vid = vehicle
	VehicleData[vehicle].model = mariadb_get_value_name_int(i, "model")
	VehicleData[vehicle].plate = mariadb_get_value_name(i, "plate")

	VehicleData[vehicle].x = mariadb_get_value_name_int(i, "x")
	VehicleData[vehicle].y = mariadb_get_value_name_int(i, "y")
	VehicleData[vehicle].z = mariadb_get_value_name_int(i, "z")
	VehicleData[vehicle].a = mariadb_get_value_name_int(i, "a")

	VehicleData[vehicle].r = mariadb_get_value_name_int(i, "r")
	VehicleData[vehicle].g = mariadb_get_value_name_int(i, "g")
	VehicleData[vehicle].b = mariadb_get_value_name_int(i, "b")

	VehicleData[vehicle].owner = mariadb_get_value_name_int(i, "owner")
	VehicleData[vehicle].faction = mariadb_get_value_name_int(i, "faction")
	VehicleData[vehicle].rental = mariadb_get_value_name_int(i, "rental")
	VehicleData[vehicle].fuel = mariadb_get_value_name_int(i, "litres")
	VehicleData[vehicle].alarm = mariadb_get_value_name_int(i, "alarm")

	VehicleData[vehicle].impounded = mariadb_get_value_name_int(i, "impounded")

	--VehicleData[vehicle].nos = mariadb_get_value_name_int(1, "nos")

	SetVehicleLicensePlate(vehicle, VehicleData[vehicle].plate)
	SetVehicleColor(vehicle, RGB(VehicleData[vehicle].r, VehicleData[vehicle].g, VehicleData[vehicle].b))
	StopVehicleEngine(vehicle)
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
		VehicleData[vehicle].vid = 0
	end
end

function OnLoadVehicles()
	for i = 1, mariadb_get_row_count(), 1 do
		Vehicle_Load(i)
	end

	print("** Vehicles Loaded: " .. #VehicleData .. ".")
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

function SetVehicleFuel(vehicleid, fuel)

	if VehicleData[vehicleid] ~= nil then
		VehicleData[vehicleid].fuel = fuel
		return true
	end

	return false
end

function ImpoundVehicle(vehicleid, price)

	SetVehicleLocation(vehicleid, 94358, 120088, 6431)
	SetVehicleDimension(vehicleid, DIMENSION_IMPOUND)

	VehicleData[vehicleid].impounded = price
end

function ShowVehiclesList(playerid, lookupid)
	local count = 0
	local vehid = 0

	for vehicleid = 1, MAX_VEHICLES, 1 do

		if Vehicle_IsOwner(lookupid, vehicleid) == true then

			vehid = VehicleData[vehicleid].vid

			AddPlayerChat(playerid, "* ID: "..vehid.." | Model: "..GetVehicleModelEx(vehid).." | Location: "..GetLocationName(GetVehicleLocation(vehid)).."")

			count = count + 1

		end
	end

	if count == 0 then
		if playerid == lookupid then
			AddPlayerChat(playerid, "You do not own any vehicles.")
		else
			AddPlayerChat(playerid, ""..GetPlayerName(lookupid).." does not own any vehicles.")
		end
	end
end

function Vehicle_IsOwner(playerid, vehicle)

	if VehicleData[vehicle] == nil then
		return false
	end

	if VehicleData[vehicle].owner == PlayerData[playerid].id then
		return true
	end

	return false
end

function Vehicle_ToggleAlarm(vehicleid, alarm, time)

	if VehicleData[vehicleid] == nil then
		return false
	end

	time = time or (5 * 1000)

	if alarm then
		if VehicleData[vehicleid].alarm_id ~= 0 then
			sound.DestroySound3D(VehicleData[vehicleid].alarm_id)
			VehicleData[vehicleid].alarm_id = 0
		end

		local x, y, z = GetVehicleLocation(VehicleData[vehicleid].vid)
		VehicleData[vehicleid].alarm_id = sound.CreateSound3D("orp/client/sounds/car_alarm.mp3", x, y, z, 1000.0, 1.0, 1.0)

		Delay(time, function ()
			Vehicle_ToggleAlarm(vehicleid, false, 0)
		end)
	else
		sound.DestroySound3D(VehicleData[vehicleid].alarm_id)
		VehicleData[vehicleid].alarm_id = 0
	end

	return
end

-- Events

AddEvent('LoadVehicles', function ()
	local query = mariadb_prepare(sql, "SELECT * FROM vehicles;")
	mariadb_async_query(sql, query, OnLoadVehicles)
end)

AddEvent('UnloadVehicles', function ()
	for i = 1, #VehicleData, 1 do
		if VehicleData[i].type == VEHICLE_TYPE_NORMAL then
			Vehicle_Unload(i)
		end
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
			ShowFooterMessage(player, "This vehicle is locked!", colour.COLOUR_LIGHTRED())
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