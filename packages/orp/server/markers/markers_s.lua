local colour = ImportPackage('colours')

MarkerData = {}

function CreateMarkerData(marker_id)

	MarkerData[marker_id] = {}

	MarkerData[marker_id].id = 0
	MarkerData[marker_id].model = 0
	MarkerData[marker_id].pickup1 = 0
	MarkerData[marker_id].pickup2 = 0

	MarkerData[marker_id].x1 = 0
	MarkerData[marker_id].y1 = 0
	MarkerData[marker_id].z1 = 0

	MarkerData[marker_id].x2 = 0
	MarkerData[marker_id].y2 = 0
	MarkerData[marker_id].z2 = 0

	MarkerData[marker_id].r = 100
	MarkerData[marker_id].g = 100
	MarkerData[marker_id].b = 0
	MarkerData[marker_id].a = 100

	MarkerData[marker_id].is_locked = true
end

function DestroyMarkerData(marker_id)
	MarkerData[marker_id] = {}
end

function Marker_Create(modelid, x, y, z)

	modelid = tonumber(modelid)
	local marker_id = CreatePickup(modelid, x, y, z)

	if marker_id == false then
		return false
	end
	CreateMarkerData(marker_id)

	local query = mariadb_prepare(sql, "INSERT INTO markers (model, x1, y1, z1) VALUES('?', '?', '?', '?')",
		modelid,
		x,
		y,
		z
	)

	mariadb_async_query(sql, query, OnMarkerCreated, marker_id, modelid, x, y, z)
	return marker_id
end

function OnMarkerCreated(marker_id, modelid, x, y, z)

	AddPlayerChatAll("Marker ID: "..marker_id.." has been created.")

	MarkerData[marker_id].id = mariadb_get_insert_id()
	MarkerData[marker_id].model = modelid

	MarkerData[marker_id].x1 = x
	MarkerData[marker_id].y1 = y
	MarkerData[marker_id].z1 = z
end

function IsValidMarker(marker_id)
	if MarkerData[marker_id] == nil then
		return false
	end

	return true
end

function Marker_Destroy(marker_id)

	local query = mariadb_prepare(sql, "DELETE FROM markers WHERE id = ?", MarkerData[marker_id].id)
	mariadb_async_query(sql, query)

	DestroyPickup(MarkerData[marker_id].pickup1)
	DestroyPickup(MarkerData[marker_id].pickup2)

	DestroyMarkerData(marker_id)

	return true
end

function Marker_Load(i, marker_id)
	local query = mariadb_prepare(sql, "SELECT * FROM markers WHERE id = ?", marker_id)
	mariadb_async_query(sql, query, OnMarkerLoaded, i, marker_id)
	print(i.." "..marker_id.." is now being loaded.")
end

function OnMarkerLoaded(indexid, marker_id)
	print("Code now transported to OnMarkerLoaded.")

	if mariadb_get_row_count() == 0 then
		print('Error with loading marker ID'..marker_id)
	else
		print("Marker id is now being loaded... "..marker_id)

		local result = mariadb_get_assoc(1)

        MarkerData[indexid].id = tonumber(result['id'])
        MarkerData[indexid].model = tonumber(result['model'])

        MarkerData[indexid].x1 = tonumber(result['x1'])
        MarkerData[indexid].y1 = tonumber(result['y1'])
        MarkerData[indexid].z1 = tonumber(result['z1'])

        MarkerData[indexid].x2 = tonumber(result['x1'])
        MarkerData[indexid].y2 = tonumber(result['y2'])
		MarkerData[indexid].z2 = tonumber(result['z2'])
		
		print(string.format("Type of x1: %s", type(result['x1'])))

        MarkerData[indexid].r = tonumber(result['r'])
        MarkerData[indexid].g = tonumber(result['g'])
        MarkerData[indexid].b = tonumber(result['b'])
        MarkerData[indexid].a = tonumber(result['a'])

		MarkerData[indexid].is_locked = result['is_locked']

		MarkerData[indexid].pickup1 = CreatePickup(MarkerData[indexid].model, MarkerData[indexid].x1, MarkerData[indexid].y1, MarkerData[indexid].z1)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "type", "marker", true)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "r", tostring(MarkerData[indexid].r), true)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "g", tostring(MarkerData[indexid].g), true)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "b", tostring(MarkerData[indexid].b), true)
		SetPickupPropertyValue(MarkerData[indexid].pickup1, "a", tostring(MarkerData[indexid].a), true)

		if MarkerData[indexid].x ~= 0 and MarkerData[indexid].y ~= 0 then
			MarkerData[indexid].pickup2 = CreatePickup(MarkerData[indexid].modelid, MarkerData[indexid].x2, MarkerData[indexid].y2, MarkerData[indexid].z2)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "type", "marker", true)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "r", tostring(MarkerData[indexid].r), true)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "g", tostring(MarkerData[indexid].g), true)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "b", tostring(MarkerData[indexid].b), true)
			SetPickupPropertyValue(MarkerData[indexid].pickup2, "a", tostring(MarkerData[indexid].a), true)
		end
	end
end

function Marker_Unload(marker_id)
	local query = mariadb_prepare(sql, "UPDATE markers SET 'model' = '?', 'x1' = '?', 'y1' = '?', 'z1' = '?', 'x2' = '?', 'y2' = '?', 'z2' = '?', 'r' = '?', 'g' = '?', 'b' = '?', 'a' = '?', 'is_locked' = '?' WHERE 'id' = ?",
		MarkerData[marker_id].model,
		MarkerData[marker_id].x1,
		MarkerData[marker_id].y1,
		MarkerData[marker_id].z1,
		MarkerData[marker_id].x2,
		MarkerData[marker_id].y2,
		MarkerData[marker_id].z2,
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

AddEvent('LoadMarkers', function ()
	local query = mariadb_prepare(sql, "SELECT * FROM markers;")
	mariadb_async_query(sql, query, OnLoadMarkers)
end)

function OnLoadMarkers()
	print("OnLoadMarkers has been called.")
	for i = 1, mariadb_get_row_count(), 1 do
		CreateMarkerData(i)
		print('Loading Marker ID '..i)
		Marker_Load(i, mariadb_get_value_name_int(i, "id"))
	end
end

AddEvent('UnloadMarkers', function ()
	for i = 1, #MarkerData do
		print('Unloading Marker ID: '..i)
		Marker_Unload(i)
	end
end)

AddEvent("OnPlayerPickupHit", function (playerid, pickupid)

	AddPlayerChat(playerid, "OnPlayerPickupHit - player: "..playerid.." pickup: "..pickupid.."")
	AddPlayerChat(playerid, "OnPlayerPickupHit - "..GetPickupPropertyValue(pickupid, "type")..".")

	if (GetPickupPropertyValue(pickupid, "type") == "marker") then

		AddPlayerChat(playerid, "marker")

		SetPlayerPropertyValue(playerid, "marker", pickupid, true)
	end
end)

AddRemoteEvent("OnPlayerInteractMarker", function (playerid, markerid)

	AddPlayerChat(playerid, "Server knows you interacted with marker "..markerid..".")
end)