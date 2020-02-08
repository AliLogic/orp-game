--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic
* Bork

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage("colours")

HousingData = {}
MAX_HOUSING = 256

HOUSING_TYPE_HOUSE = 1 -- aka 24/7
HOUSING_TYPE_APTROOM = 2
HOUSING_TYPE_APTCOMPLEX = 3
HOUSING_TYPE_MAX = 3

HousingType = {
	"House",
	"Apartment Room",
	"Apartment Complex"
}

HOUSE_OWNERSHIP_STATE = 1
HOUSE_OWNERSHIP_SOLE = 2
HOUSE_OWNERSHIP_FACTION = 3

local PlayerHouseKeys = {}

-- Functions

function GetFreeHousingId()
	for i = 1, MAX_HOUSING, 1 do
		if HousingData[i] == nil then
			CreateHousingData(i)
			return i
		end
	end
	return 0
end

function CreateHousingData(house)
	HousingData[house] = {}

	-- Permanent (saving) values

	HousingData[house].id = 0
	HousingData[house].doorid = 0 -- sqlid of the marker

	HousingData[house].owner = 0 -- 0, aka the state..
	HousingData[house].ownership_type = 0 -- aka, the state... if +1'ed.

	HousingData[house].name = "House"
	HousingData[house].locked = 1 -- for yes, put 1.

	HousingData[house].type = 0

	HousingData[house].price = 0 -- costs 0 dollasssss
	HousingData[house].message = "This is a default house message."

	HousingData[house].dimension = 0 -- dimension of the interior.

	HousingData[house].ix = 0.0 -- internal coordinates, as in, interior
	HousingData[house].iy = 0.0
	HousingData[house].iz = 0.0
	HousingData[house].ia = 0.0

	HousingData[house].ex = 0.0 -- external coordinates, as in, exterior or outside
	HousingData[house].ey = 0.0
	HousingData[house].ez = 0.0
	HousingData[house].ea = 0.0

	-- Temporary values
	HousingData[house].text3d_in = nil -- The marker for the inside coordinates where you /exit. Pretty useless but always useful for the future.
	HousingData[house].text3d_outside = nil -- The marker for outside coordinates, where you do /enter and shows house name.
end

function DestroyHousingData(house)
	HousingData[house] = nil
end

function OnHouseLoad()
	for i = 1, mariadb_get_row_count(), 1 do
		House_Load(mariadb_get_value_name_int(i, "id"))
	end
end

function House_Create(player, htype, price, ...)
	local name = table.concat({...}, " ")
	htype = tonumber(htype)
	price = tonumber(price)

	if string.len(name) < 0 or string.len(name) > 32 then
		return false
	end

	if htype < 1 or htype > HOUSING_TYPE_MAX then
		return false
	end

	if price < 0 then
		return false
	end

	local index = GetFreeHousingId()
	if index == 0 then
		return false
	end

	local query = mariadb_prepare(sql, "INSERT INTO houses (name, type, price) VALUES ('?', ?, ?);",
		name, htype, price
	)
	mariadb_async_query(sql, query, OnHouseCreated, index, htype, price, name)
end

function OnHouseCreated(i, htype, price, name)
	HousingData[i].id = mariadb_get_insert_id()

	HousingData[i].name = name
	HousingData[i].type = htype

	HousingData[i].price = price
end

function House_Load(houseid)
	local query = mariadb_prepare(sql, "SELECT * FROM houses WHERE id = ?;", houseid)
	mariadb_async_query(sql, query, OnHouseLoaded, houseid)
end

function OnHouseLoaded(houseid)
	if mariadb_get_row_count() == 0 then
		print("Failed to load house SQL ID "..houseid)
	else
		local house = GetFreeHousingId()
		if house == 0 then
			print("A free house id wasn't able to be found? ("..#HousingData.."/"..MAX_BUSINESSES..") house SQL ID "..houseid..".")
			return
		end

		-- type, price, message, dimension, ix iy iz ia, ex ey ez ea, mx my mz

		HousingData[house].id = houseid
		HousingData[house].doorid = mariadb_get_value_name_int(1, "doorid")

		HousingData[house].owner = mariadb_get_value_name_int(1, "owner")
		HousingData[house].ownership_type = mariadb_get_value_name_int(1, "ownership_type")

		HousingData[house].name = mariadb_get_value_name(1, "name")
		HousingData[house].locked = mariadb_get_value_name_int(1, "locked")

		HousingData[house].type = mariadb_get_value_name_int(1, "type")

		HousingData[house].price = mariadb_get_value_name_int(1, "price")
		HousingData[house].message = mariadb_get_value_name(1, "message")

		HousingData[house].dimension = mariadb_get_value_name_int(1, "dimension")

		HousingData[house].ix = mariadb_get_value_name_int(1, "ix")
		HousingData[house].iy = mariadb_get_value_name_int(1, "iy")
		HousingData[house].iz = mariadb_get_value_name_int(1, "iz")
		HousingData[house].ia = mariadb_get_value_name_int(1, "ia")

		HousingData[house].ex = mariadb_get_value_name_int(1, "ex")
		HousingData[house].ey = mariadb_get_value_name_int(1, "ey")
		HousingData[house].ez = mariadb_get_value_name_int(1, "ez")
		HousingData[house].ea = mariadb_get_value_name_int(1, "ea")

		-- CreateDynamicDoor()

		HousingData[house].text3d_in = CreateText3D("House ("..house..")", 10, HousingData[house].ix, HousingData[house].iy, HousingData[house].iz + 10, 0.0, 0.0, 0.0)
		HousingData[house].text3d_outside = CreateText3D("House ("..house..")\nType: "..HousingType[HousingData[house].type].."", 10, HousingData[house].ex, HousingData[house].ey, HousingData[house].ez + 10, 0.0, 0.0, 0.0)

		LoadHouseFurniture(houseid)

		print("House "..house.." (SQL ID: "..houseid..") successfully loaded!")

	end
end

function House_Unload(house)
	local query = mariadb_prepare(sql, "UPDATE houses SET owner = ?, name = '?', locked = ?, type = ?, price = ?, message = '?', dimension = ?\
	ix = '?', iy = '?', iz = '?', ia = '?', ex = '?', ey = '?', ez = '?', ea = '?', ownership_type = ? WHERE id = ?;",
		HousingData[house].owner, HousingData[house].name, HousingData[house].locked,
		HousingData[house].type, HousingData[house].price,
		HousingData[house].message, HousingData[house].dimension,
		tostring(HousingData[house].ix), tostring(HousingData[house].iy), tostring(HousingData[house].iz), tostring(HousingData[house].ia),
		tostring(HousingData[house].ex), tostring(HousingData[house].ey), tostring(HousingData[house].ez), tostring(HousingData[house].ea),
		HousingData[house].ownership_type, HousingData[house].id
	)
	mariadb_async_query(sql, query, OnHouseUnloaded, house)
end

function OnHouseUnloaded(house)
	if mariadb_get_affected_rows() == 0 then
		print("House ID "..house.." unload unsuccessful!")
	else
		print("House ID "..house.." unload successful!")
	end
end

function House_Destroy(house)
	if HousingData[house] == nil then
		return false
	end

	local query = mariadb_prepare(sql, "DELETE FROM houses WHERE id = ?;", HousingData[house].id)
	mariadb_async_query(sql, query)

	-- DestroyDynamicDoor()

	if IsValidText3D(HousingData[house].text3d_outside) then
		DestroyText3D(HousingData[house].text3d_outside)
	end

	if IsValidText3D(HousingData[house].text3d_in) then
		DestroyText3D(HousingData[house].text3d_in)
	end

	DestroyHousingData(house)

	DestroyHouseFurniture(house)
end

function Housing_Nearest(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0

	for v = 1, #HousingData, 1 do
		if HousingData[v] ~= nil then
			distance = GetDistance3D(x, y, z, HousingData[v].ex, HousingData[v].ey, HousingData[v].ez)

			if distance <= 200.0 then
				return v
			end
		end
	end

	return 0
end

local function OnPlayerHouseKeysLoaded(playerid)

	local rows = mariadb_get_row_count()

	PlayerHouseKeys[playerid] = {}
	for i = 1, #rows, 1 do
		PlayerHouseKeys[playerid][mariadb_get_value_name_int(i, "house")] = true
	end
end

function LoadPlayerHouseKeys(playerid)

	local query = mariadb_prepare(sql, "SELECT * housekeys WHERE id = ?", PlayerData[playerid].id)
	mariadb_async_query(sql, query, OnPlayerHouseKeysLoaded, playerid)
end

function PlayerHasHouseKey(playerid, houseid)

	if houseid ~= nil then
		return false
	end

	return PlayerHouseKeys[playerid][houseid] ~= nil
end

function PlayerAddHouseKey(playerid, houseid)

	PlayerHouseKeys[playerid][houseid] = true

	local query = mariadb_prepare(sql, "INSERT INTO housekeys (id, house) VALUES(?, ?)", PlayerData[playerid].id, houseid)
	mariadb_async_query(sql, query)
end

function PlayerRemoveHouseKey(playerid, houseid)

	PlayerHouseKeys[playerid][houseid] = nil

	local query = mariadb_prepare(sql, "DELETE FROM housekeys WHERE id = ? AND house = ?", PlayerData[playerid].id, houseid)
	mariadb_async_query(sql, query)
end

function House_IsOwner(playerid, houseid)

	if HousingData[houseid] == nil then
		return false
	end

	if HousingData[houseid].owner == PlayerData[playerid].id then
		return true
	end

	return false
end

-- Events

AddEvent('LoadHouses', function ()
	mariadb_async_query(sql, "SELECT * FROM houses;", OnHouseLoad)
end)

AddEvent('UnloadHouses', function ()
	for i = 1, #HousingData, 1 do
		House_Unload(i)
	end
end)