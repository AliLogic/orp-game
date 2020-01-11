local colour = ImportPackage('colours')

MAX_DOORS = 4096
DoorData = {}

function GetFreeDoorId()
	for i = 1, MAX_DOORS, 1 do
		if DoorData[i] == nil then
			return i
		end
	end

	return false
end

function CreateDoorData(door_id)

	DoorData[door_id] = {}

	DoorData[door_id].id = 0
	DoorData[door_id].model = 0

	DoorData[door_id].x = 0
	DoorData[door_id].y = 0
	DoorData[door_id].z = 0
	DoorData[door_id].a = 0

	DoorData[door_id].dimension = 0

	DoorData[door_id].is_locked = 1
end

function DestroyDoorData(door_id)
	DoorData[door_id] = {}
end

function Door_Create(modelid, x, y, z, a, dimension)

	local door_id = GetFreeDoorId()

	if door_id == false then
		return false
	end
	CreateDoorData(door_id)

	local query = mariadb_prepare(sql, "INSERT INTO doors (model, x, y, z, a, dimension) VALUES(?, ?, ?, ?, ?, ?);",
		modelid,
		x,
		y,
		z,
		a,
		dimension
	)

	mariadb_async_query(sql, query, OnDoorCreated, door_id, modelid, x, y, z, dimension)
	return door_id
end

function OnDoorCreated(door_id, modelid, x, y, z, a, dimension)

	AddPlayerChatAll("Door ID: "..door_id.." has been created.")

	DoorData[door_id].id = mariadb_get_insert_id()
	DoorData[door_id].model = modelid
	DoorData[door_id].door = CreateDoor(modelid, x, y, z, a, true)
	SetDoorDimension(DoorData[door_id].door, dimension)

	DoorData[door_id].x = x
	DoorData[door_id].y = y
	DoorData[door_id].z = z
	DoorData[door_id].a = a

	DoorData[door_id].dimension = dimension
end

function IsValidDoor(door_id)
	if DoorData[door_id] == nil then
		return false
	end

	return true
end

function Door_Destroy(door_id)

	local query = mariadb_prepare(sql, "DELETE FROM doors WHERE id = '?'", DoorData[door_id].id)
	mariadb_async_query(sql, query)

	DestroyDoor(DoorData[door_id].door)

	DestroyDoorData(door_id)

	return true
end

function Door_Load(i, door_id)
	local query = mariadb_prepare(sql, "SELECT * FROM doors WHERE id = ?", door_id)
	mariadb_async_query(sql, query, OnDoorLoaded, i, door_id)
end

function OnDoorLoaded(indexid, door_id)

	if mariadb_get_row_count() == 0 then
		print('Error with loading door ID'..door_id)
	else
		print("Door id is now being loaded... "..door_id)

		local result = mariadb_get_assoc(1)

		DoorData[indexid].id = tonumber(result['id'])
		DoorData[indexid].model = tonumber(result['model'])

		DoorData[indexid].x = tonumber(result['x'])
		DoorData[indexid].y = tonumber(result['y'])
		DoorData[indexid].z = tonumber(result['z'])
		DoorData[indexid].a = tonumber(result['a'])

		DoorData[indexid].is_locked = tonumber(result['is_locked'])

		DoorData[indexid].door = CreateDoor(DoorData[indexid].model, DoorData[indexid].x, DoorData[indexid].y, DoorData[indexid].z, DoorData[indexid].a, true)
		SetDoorDimension(DoorData[indexid].door, DoorData[indexid].dimension)
	end
end

function Door_Unload(door_id)
	local query = mariadb_prepare(sql, "UPDATE doors SET model = '?', x = '?', y = '?', z = '?', a = '?', dimension = '?', is_locked = '?' WHERE id = ?",
		DoorData[door_id].model,
		DoorData[door_id].x,
		DoorData[door_id].y,
		DoorData[door_id].z,
		DoorData[door_id].a,
		DoorData[door_id].dimension,
		DoorData[door_id].is_locked,
		DoorData[door_id].id
	)

	mariadb_async_query(sql, query, OnDoorUnloaded, door_id)
end

function OnDoorUnloaded(door_id)
	if mariadb_get_affected_rows() == 0 then
		print('Door unload unsuccessful, id: '..door_id)
	else
		print('Door unload successful, id: '..door_id)
		DestroyDoorData(door_id)
	end
end

AddEvent('LoadDoors', function ()
	local query = mariadb_prepare(sql, "SELECT * FROM doors;")
	mariadb_async_query(sql, query, OnLoadDoors)
end)

function OnLoadDoors()
	print("OnLoadDoors has been called.")
	for i = 1, mariadb_get_row_count(), 1 do
		CreateDoorData(i)
		print('Loading Door ID '..i)
		Door_Load(i, mariadb_get_value_name_int(i, "id"))
	end
end

AddEvent('UnloadDoors', function ()
	for i = 1, #DoorData do
		print('Unloading Door ID: '..i)
		Door_Unload(i)
	end
end)

function Door_Nearest(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0

	for _, v in pairs(DoorData) do
		if DoorData[v] ~= nil then
			distance = GetDistance3D(x, y, z, DoorData[v].x, DoorData[v].y, DoorData[v].z)

			if distance <= 200.0 then
				return v
			end
		end
	end

	return 0
end

AddEvent("OnPlayerInteractDoor", function(player, door, bWantsOpen)

	local index = Door_Nearest(player)

	if index ~= 0 and DoorData[index].is_locked == true then
		return AddPlayerChat(player, "This door is locked!")
	end

	-- Let the players open/close the door by default.
	SetDoorOpen(door, not IsDoorOpen(door))
end)