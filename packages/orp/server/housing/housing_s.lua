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

	HousingData[house].locked = 1 -- for yes, put 1.

	HousingData[house].type = 0

	HousingData[house].price = 0 -- costs 0 dollasssss
	HousingData[house].message = "This is a default house message."

	HousingData[house].address = ""

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
	HousingData[house].text3d_in = 0 -- The marker for the inside coordinates where you /exit. Pretty useless but always useful for the future.
	HousingData[house].text3d_outside = 0 -- The marker for outside coordinates, where you do /enter and shows house name.

	HousingData[house].doors = {}
end

function DestroyHousingData(house)
	HousingData[house] = nil
end

local function House_Load(i)
	local house = GetFreeHousingId()
	if house == 0 then
		print("A free house id wasn't able to be found? ("..#HousingData.."/"..MAX_BUSINESSES..") house SQL ID "..house..".")
		return
	end

	HousingData[house].id = mariadb_get_value_name_int(i, "id")
	HousingData[house].doorid = mariadb_get_value_name_int(i, "doorid")

	HousingData[house].owner = mariadb_get_value_name_int(i, "owner")
	HousingData[house].ownership_type = mariadb_get_value_name_int(i, "ownership_type")

	HousingData[house].locked = mariadb_get_value_name_int(i, "locked")

	HousingData[house].type = mariadb_get_value_name_int(i, "type")

	HousingData[house].price = mariadb_get_value_name_int(i, "price")
	HousingData[house].message = mariadb_get_value_name(i, "message")

	HousingData[house].address = mariadb_get_value_name(i, "address")

	HousingData[house].dimension = mariadb_get_value_name_int(i, "dimension")

	HousingData[house].ix = mariadb_get_value_name_int(i, "ix")
	HousingData[house].iy = mariadb_get_value_name_int(i, "iy")
	HousingData[house].iz = mariadb_get_value_name_int(i, "iz")
	HousingData[house].ia = mariadb_get_value_name_int(i, "ia")

	HousingData[house].ex = mariadb_get_value_name_int(i, "ex")
	HousingData[house].ey = mariadb_get_value_name_int(i, "ey")
	HousingData[house].ez = mariadb_get_value_name_int(i, "ez")
	HousingData[house].ea = mariadb_get_value_name_int(i, "ea")

	-- CreateDynamicDoor()

	HousingData[house].text3d_in = CreateText3D("House ("..house..")", 10, HousingData[house].ix, HousingData[house].iy, HousingData[house].iz + 10, 0.0, 0.0, 0.0)
	House_RefreshLabel(house)

	LoadHouseFurniture(house)
end

function OnHouseLoad()
	for i = 1, mariadb_get_row_count(), 1 do
		House_Load(i)
	end

	print("** Houses Loaded: "..mariadb_get_row_count()..".")
end

function House_Create(player, htype, price, address)
	htype = tonumber(htype)
	price = tonumber(price)

	if string.len(address) < 0 or string.len(address) > 128 then
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

	local query = mariadb_prepare(sql, "INSERT INTO houses (type, price, address) VALUES ('?', ?, ?, '?');",
		htype, price, address
	)
	mariadb_async_query(sql, query, OnHouseCreated, index, htype, price, address)
end

function OnHouseCreated(i, htype, price, address)
	HousingData[i].id = mariadb_get_insert_id()

	HousingData[i].type = htype

	HousingData[i].price = price
	HousingData[i].address = address
end

function House_Unload(house)
	local query = mariadb_prepare(sql, "UPDATE houses SET owner = ?, address = '?', locked = ?, type = ?, price = ?, message = '?', dimension = ?\
	ix = '?', iy = '?', iz = '?', ia = '?', ex = '?', ey = '?', ez = '?', ea = '?', ownership_type = ? WHERE id = ?;",
		HousingData[house].owner, HousingData[house].address, HousingData[house].locked,
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

	for i = 1, rows, 1 do
		PlayerHouseKeys[playerid][mariadb_get_value_name_int(i, "house")] = true
	end
end

function LoadPlayerHouseKeys(playerid)

	PlayerHouseKeys[playerid] = {}

	local query = mariadb_prepare(sql, "SELECT * housekeys WHERE id = ?", PlayerData[playerid].id)
	mariadb_async_query(sql, query, OnPlayerHouseKeysLoaded, playerid)
end

function PlayerHasHouseKey(playerid, houseid)

	if #PlayerHouseKeys[playerid] == 0 then
		return false
	end

	return PlayerHouseKeys[playerid][houseid]
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

function House_RefreshLabel(house)

	local string = "House ("..house..")\nAddress: "..HousingData[house].address..""

	if HousingData[house].owner == 0 then
		string = string .. "\nPrice: $"..HousingData[house].price
	end

	if IsValidText3D(HousingData[house].text3d_outside) then
		SetText3DText(HousingData[house].text3d_outside, string)
	else
		HousingData[house].text3d_outside = CreateText3D(string, 10, HousingData[house].ex, HousingData[house].ey, HousingData[house].ez + 10, 0.0, 0.0, 0.0)
	end
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