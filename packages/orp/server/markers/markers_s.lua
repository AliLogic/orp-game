-- Variables

local colour = ImportPackage('colours')

MAX_MARKERS = 100
MarkerData = {}

-- Functions

function GetFreeMarkerId()

	for i = 1, MAX_MARKERS, 1 do
		if MarkerData[i] == nil then
			return i
		end
	end

	return false
end

function CreateMarkerData(marker_id)

	MarkerData[marker_id] = {}

	MarkerData[marker_id].id = 0
	MarkerData[marker_id].model = 0
	MarkerData[marker_id].pickup1 = 0
	MarkerData[marker_id].pickup2 = 0

	MarkerData[marker_id].x1 = 0
	MarkerData[marker_id].y1 = 0
	MarkerData[marker_id].z1 = 0
	MarkerData[marker_id].dimension1 = 0

	MarkerData[marker_id].x2 = 0
	MarkerData[marker_id].y2 = 0
	MarkerData[marker_id].z2 = 0
	MarkerData[marker_id].dimension2 = 0

	MarkerData[marker_id].r = 255
	MarkerData[marker_id].g = 204
	MarkerData[marker_id].b = 0
	MarkerData[marker_id].a = 200

	MarkerData[marker_id].is_locked = true
end

function DestroyMarkerData(marker_id)
	MarkerData[marker_id] = {}
end

function Marker_Create(modelid, x, y, z, dimension)

	local marker_id = GetFreeMarkerId()

	if marker_id == false then
		return false
	end
	CreateMarkerData(marker_id)

	local query = mariadb_prepare(sql, "INSERT INTO markers (model, x1, y1, z1, dimension1) VALUES(?, ?, ?, ?, ?);",
		modelid,
		x,
		y,
		z,
		dimension
	)

	mariadb_async_query(sql, query, OnMarkerCreated, marker_id, modelid, x, y, z, dimension)
	return marker_id
end

function OnMarkerCreated(marker_id, modelid, x, y, z, dimension)

	AddPlayerChatAll("Marker ID: "..marker_id.." has been created.")

	MarkerData[marker_id].id = mariadb_get_insert_id()
	MarkerData[marker_id].model = modelid
	MarkerData[marker_id].pickup1 = CreatePickup(modelid, x, y, z)

	SetPickupPropertyValue(MarkerData[marker_id].pickup1, "r", tostring(MarkerData[marker_id].r), true)
	SetPickupPropertyValue(MarkerData[marker_id].pickup1, "g", tostring(MarkerData[marker_id].g), true)
	SetPickupPropertyValue(MarkerData[marker_id].pickup1, "b", tostring(MarkerData[marker_id].b), true)
	SetPickupPropertyValue(MarkerData[marker_id].pickup1, "a", tostring(MarkerData[marker_id].a), true)
	SetPickupPropertyValue(MarkerData[marker_id].pickup1, "markerid", marker_id, true)

	MarkerData[marker_id].x1 = x
	MarkerData[marker_id].y1 = y
	MarkerData[marker_id].z1 = z

	MarkerData[marker_id].dimension1 = dimension
end

function IsValidMarker(marker_id)
	if MarkerData[marker_id] == nil then
		return false
	end

	return true
end

function Marker_Destroy(marker_id)

	local query = mariadb_prepare(sql, "DELETE FROM markers WHERE id = '?'", MarkerData[marker_id].id)
	mariadb_async_query(sql, query)

	DestroyPickup(MarkerData[marker_id].pickup1)
	DestroyPickup(MarkerData[marker_id].pickup2)

	DestroyMarkerData(marker_id)

	return true
end

function Marker_Load(i, marker_id)
	local query = mariadb_prepare(sql, "SELECT * FROM markers WHERE id = ?", marker_id)
	mariadb_async_query(sql, query, OnMarkerLoaded, i, marker_id)
end

function OnMarkerLoaded(indexid, marker_id)
	if mariadb_get_row_count() == 0 then
		print('Error with loading marker ID'..marker_id)
	else
		MarkerData[indexid].id = mariadb_get_value_name_int(1, "id")
		MarkerData[indexid].model = mariadb_get_value_name_int(1, "model")

		MarkerData[indexid].x1 = mariadb_get_value_name_int(1, "x1")
		MarkerData[indexid].y1 = mariadb_get_value_name_int(1, "y1")
		MarkerData[indexid].z1 = mariadb_get_value_name_int(1, "z1")

		MarkerData[indexid].x2 = mariadb_get_value_name_int(1, "x2")
		MarkerData[indexid].y2 = mariadb_get_value_name_int(1, "y2")
		MarkerData[indexid].z2 = mariadb_get_value_name_int(1, "z2")

		MarkerData[indexid].r = mariadb_get_value_name_int(1, "r")
		MarkerData[indexid].g = mariadb_get_value_name_int(1, "g")
		MarkerData[indexid].b = mariadb_get_value_name_int(1, "b")
		MarkerData[indexid].a = mariadb_get_value_name_int(1, "a")

		MarkerData[indexid].is_locked = mariadb_get_value_name_int(1, "is_locked")

		MarkerData[indexid].pickup1 = CreatePickup(MarkerData[indexid].model, MarkerData[indexid].x1, MarkerData[indexid].y1, MarkerData[indexid].z1)
		SetPickupDimension(MarkerData[indexid].pickup1, MarkerData[indexid].dimension1)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "markerid", indexid, true)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "r", tostring(MarkerData[indexid].r), true)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "g", tostring(MarkerData[indexid].g), true)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "b", tostring(MarkerData[indexid].b), true)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "a", tostring(MarkerData[indexid].a), true)

		if MarkerData[indexid].x2 ~= 0 and MarkerData[indexid].y2 ~= 0 then
			MarkerData[indexid].pickup2 = CreatePickup(MarkerData[indexid].model, MarkerData[indexid].x2, MarkerData[indexid].y2, MarkerData[indexid].z2)
			SetPickupDimension(MarkerData[indexid].pickup2, MarkerData[indexid].dimension2)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "markerid", indexid, true)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "r", tostring(MarkerData[indexid].r), true)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "g", tostring(MarkerData[indexid].g), true)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "b", tostring(MarkerData[indexid].b), true)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "a", tostring(MarkerData[indexid].a), true)
		end
	end
end

function Marker_Unload(marker_id)
	local query = mariadb_prepare(sql, "UPDATE markers SET model = '?', x1 = '?', y1 = '?', z1 = '?', dimension1 = '?', x2 = '?', y2 = '?', z2 = '?', dimension2 = '?', r = '?', g = '?', b = '?', a = '?', is_locked = '?' WHERE id = ?",
		MarkerData[marker_id].model,
		MarkerData[marker_id].x1,
		MarkerData[marker_id].y1,
		MarkerData[marker_id].z1,
		MarkerData[marker_id].dimension1,
		MarkerData[marker_id].x2,
		MarkerData[marker_id].y2,
		MarkerData[marker_id].z2,
		MarkerData[marker_id].dimension2,
		MarkerData[marker_id].r,
		MarkerData[marker_id].g,
		MarkerData[marker_id].b,
		MarkerData[marker_id].a,
		MarkerData[marker_id].is_locked,
		MarkerData[marker_id].id
	)

	mariadb_async_query(sql, query, OnMarkerUnloaded, marker_id)
end

function OnMarkerUnloaded(marker_id)
	if mariadb_get_affected_rows() == 0 then
		print('Marker unload unsuccessful, id: '..marker_id)
	else
		print('Marker unload successful, id: '..marker_id)
		DestroyMarkerData(marker_id)
	end
end

function OnLoadMarkers()
	for i = 1, mariadb_get_row_count(), 1 do
		CreateMarkerData(i)
		Marker_Load(i, mariadb_get_value_name_int(i, "id"))
	end

	print("** Markers Loaded: "..mariadb_get_row_count()..".")
end

function Marker_Nearest(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0

	for v = 1, #MarkerData, 1 do
		if MarkerData[v] ~= nil then
			distance = GetDistance3D(x, y, z, MarkerData[v].x1, MarkerData[v].y1, MarkerData[v].z1)

			if distance <= 200.0 then
				return v
			end

			if MarkerData[v].x2 ~= 0 and MarkerData[v].y2 ~= 0 then
				distance = GetDistance3D(x, y, z, MarkerData[v].x2, MarkerData[v].y2, MarkerData[v].z2)

				if distance <= 200.0 then
					return v
				end
			end
		end
	end

	return 0
end

-- Events

AddEvent('LoadMarkers', function ()
	local query = mariadb_prepare(sql, "SELECT * FROM markers;")
	mariadb_async_query(sql, query, OnLoadMarkers)
end)

AddEvent('UnloadMarkers', function ()
	for i = 1, #MarkerData do
		Marker_Unload(i)
	end
end)

AddEvent("OnPlayerPickupHit", function (playerid, pickupid)

	AddPlayerChat(playerid, "OnPlayerPickupHit - player: "..playerid.." pickup: "..pickupid.."")
	AddPlayerChat(playerid, "OnPlayerPickupHit - "..GetPickupPropertyValue(pickupid, "markerid")..".")

	if (GetPickupPropertyValue(pickupid, "markerid") ~= false) then

		AddPlayerChat(playerid, "pickupid "..pickupid.." has been detected as a marker id")

		SetPlayerPropertyValue(playerid, "pickupid", pickupid, true)
	end
end)

AddEvent("OnPlayerJoin", function (playerid)
	Delay(100, function()
		SetPlayerPropertyValue(playerid, "pickupid", 0, true)
	end)
end)

AddRemoteEvent("OnPlayerInteractMarker", function (playerid, pickupid)

	AddPlayerChat(playerid, "Server knows you interacted with marker "..pickupid..".")

	for i = 1, #MarkerData, 1 do
		if IsValidMarker(i) then
			if MarkerData[i].pickup1 == pickupid then
				if IsValidPickup(MarkerData[i].pickup2) then
					SetPlayerLocation(playerid, MarkerData[i].x2, MarkerData[i].y2, MarkerData[i].z2)
					AddPlayerChat(playerid, "TELEPORTED")
				end
				break
			elseif MarkerData[i].pickup2 == pickupid then
				SetPlayerLocation(playerid, MarkerData[i].x1, MarkerData[i].y1, MarkerData[i].z1)
				AddPlayerChat(playerid, "TELEPORTED")
				break
			end
		end
	end
end)