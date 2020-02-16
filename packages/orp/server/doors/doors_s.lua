local colour = ImportPackage('colours')

MAX_DOORS = 4096
DoorData = {}

function GetFreeDoorId()
	for i = 1, MAX_DOORS, 1 do
		if DoorData[i] == nil then
			CreateDoorData(i)
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

	DoorData[door_id].property = 0
	DoorData[door_id].property_id = 0
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

local function Door_Load(i)
	local indexid = GetFreeDoorId()

	if indexid == 0 then
		print("A free door id wasn't able to be found? ("..#DoorData.."/"..MAX_DOORS..") door SQL ID "..mariadb_get_value_name_int(i, "id")..".")
		return 0
	end

	DoorData[indexid].id = mariadb_get_value_name_int(i, "id")
	DoorData[indexid].model = mariadb_get_value_name_int(i, "model")

	DoorData[indexid].x = mariadb_get_value_name_int(i, "x")
	DoorData[indexid].y = mariadb_get_value_name_int(i, "y")
	DoorData[indexid].z = mariadb_get_value_name_int(i, "z")
	DoorData[indexid].a = mariadb_get_value_name_int(i, "a")

	DoorData[indexid].is_locked = mariadb_get_value_name_int(i, "is_locked")

	DoorData[indexid].door = CreateDoor(DoorData[indexid].model, DoorData[indexid].x, DoorData[indexid].y, DoorData[indexid].z, DoorData[indexid].a, true)
	SetDoorDimension(DoorData[indexid].door, DoorData[indexid].dimension)

	DoorData[indexid].property = mariadb_get_value_name_int(i, "property")
	DoorData[indexid].property_id = mariadb_get_value_name_int(i, "property_id")

	return indexid
end

local function OnLoadHouseDoors(house)
	for i = 1, mariadb_get_row_count(), 1 do
		table.insert(HousingData[house].doors, Door_Load(i))
	end
end

function LoadHouseDoors(house)
	local query = mariadb_prepare(sql, "SELECT * FROM doors WHERE property = 1 AND property_id = ?", HousingData[house].id)
	mariadb_async_query(sql, query, OnLoadHouseDoors, house)
end

local function OnLoadBusinessDoors(business)
	for i = 1, mariadb_get_row_count(), 1 do
		table.insert(BusinessData[business].doors, Door_Load(i))
	end
end

function LoadBusinessDoors(business)
	local query = mariadb_prepare(sql, "SELECT * FROM doors WHERE property = 2 AND property_id = ?", BusinessData[business].id)
	mariadb_async_query(sql, query, OnLoadBusinessDoors, business)
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
	else
		DestroyDoorData(door_id)
	end
end

AddEvent('LoadDoors', function ()
	local query = mariadb_prepare(sql, "SELECT * FROM doors WHERE property = 0;")
	mariadb_async_query(sql, query, OnLoadDoors)
end)

function OnLoadDoors()
	for i = 1, mariadb_get_row_count(), 1 do
		Door_Load(i)
	end

	print("** Doors Loaded: " .. #DoorData .. ".")
end

AddEvent('UnloadDoors', function ()
	for i = 1, #DoorData, 1 do
		Door_Unload(i)
	end
end)

function Door_Nearest(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0

	for v = 1, #DoorData, 1 do
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

	if DoorData[door].is_locked == 1 then
		return AddPlayerChat(player, "This door is locked!")
	end

	-- Let the players open/close the door by default.
	SetDoorOpen(door, not IsDoorOpen(door))
end)