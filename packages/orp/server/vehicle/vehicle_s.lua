local colour = ImportPackage('colours')
VehicleData = {}

function CreateVehicleData(vehicle)
	VehicleData[vehicle] = {}

	VehicleData[vehicle].id = 0
	VehicleData[vehicle].owner = 0

	VehicleData[vehicle].plate = "ONSET"
	VehicleData[vehicle].faction = 0

	VehicleData[vehicle].x = ""
	VehicleData[vehicle].y = ""
	VehicleData[vehicle].z = ""
	VehicleData[vehicle].a = ""

	VehicleData[vehicle].r = 0
	VehicleData[vehicle].g = 0
	VehicleData[vehicle].b = 0

	VehicleData[vehicle].is_locked = true
end

function DestroyVehicleData(vehicle)
	VehicleData[vehicle] = {}
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
		VehicleData[vehicle].model = result['model']
		VehicleData[vehicle].plate = result['plate']

		VehicleData[vehicle].x = tonumber(result['x'])
		VehicleData[vehicle].y = tonumber(result['y'])
		VehicleData[vehicle].z = tonumber(result['z'])
		VehicleData[vehicle].a = tonumber(result['a'])
	
		VehicleData[vehicle].r = result['r']
		VehicleData[vehicle].g = result['g']
		VehicleData[vehicle].b = result['b']

		VehicleData[vehicle].owner = tonumber(result['owner'])
		VehicleData[vehicle].faction = result['faction']

		print(id.."'s owner: "..VehicleData[vehicle].owner)

		SetVehicleLicensePlate(vehicle, VehicleData[vehicle].plate)
		SetVehicleColor(vehicle, RGB(VehicleData[vehicle].r, VehicleData[vehicle].g, VehicleData[vehicle].b))
	end
end

function Vehicle_Unload(vehicle)
	local query = mariadb_prepare(sql, "UPDATE vehicles SET owner = ?, model = ?, plate = '?', faction = ?, x = '?', y = '?', z = '?', a = '?', r = ?, g = ?, b = ? WHERE id = ?",
		VehicleData[vehicle].owner,
		VehicleData[vehicle].model,
		VehicleData[vehicle].plate,
		VehicleData[vehicle].faction,
		tostring(VehicleData[vehicle].x),
		tostring(VehicleData[vehicle].y),
		tostring(VehicleData[vehicle].z),
		tostring(VehicleData[vehicle].a),
		VehicleData[vehicle].r,
		VehicleData[vehicle].g,
		VehicleData[vehicle].b,
		VehicleData[vehicle].id
	)

	mariadb_async_query(sql, query, OnVehicleUnloaded, vehicle)
end

function OnVehicleUnloaded(vehicle)
	if mariadb_get_affected_rows() == 0 then
		print('Vehicle unload unsuccessful, id: '..vehicle)
	else
		print('Vehicle unload successful, id: '..vehicle)
		DestroyVehicle(vehicle)
	end
end

function Slap(player)
	local x, y, z = GetPlayerLocation(player)
	SetPlayerLocation(player, x, y, z)
end

AddEvent('LoadVehicles', function ()
	local query = mariadb_prepare(sql, "SELECT * FROM vehicles;")
	mariadb_async_query(sql, query, OnLoadVehicles)
end)

function OnLoadVehicles()
	for i = 1, mariadb_get_row_count(), 1 do
		print('Loading Vehicle ID '..i)
		Vehicle_Load(mariadb_get_value_name_int(i, "id"))
	end
end

AddEvent('UnloadVehicles', function ()
	for i = 1, #VehicleData, 1 do
		print('Unloading Vehicle ID: '..i)
		Vehicle_Unload(i)
	end
end)

-- AddEvent("OnPlayerEnterVehicle", function(player, vehicle, seat)
AddRemoteEvent("OnPlayerStartEnterVehicle", function (player, vehicle, seat)
	AddPlayerChat(player, "GOT OnPlayerStartEnterVehicle response for player: "..player..", vehicle: "..vehicle..", seat :"..seat.."")
	if VehicleData[vehicle] ~= nil then
		if VehicleData[vehicle].is_locked == true then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">This vehicle is locked, you cannot enter it!</>")

			Slap(player)
			--return false
		else
			AddPlayerChat(player, "GOT OnPlayerStartEnterVehicle response ENTERING")
			SetPlayerInVehicle(player, vehicle, seat)
		end
	end
end)