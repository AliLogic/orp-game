--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage("colours")
local borkui = ImportPackage("borkui")

MAX_FURNITURE = 1000
MAX_HOUSE_FURNITURE = 30
local FurnitureData = {}

local FURNITURE_TYPE_TABLES = 1
local FURNITURE_TYPE_CHAIRS = 2
local FURNITURE_TYPE_BEDS = 3
local FURNITURE_TYPE_CABIN = 4
local FURNITURE_TYPE_TV = 5
local FURNITURE_TYPE_KITCHEN = 6
local FURNITURE_TYPE_BATHROOM = 7
local FURNITURE_TYPE_MISC = 8

local FurnitureTypes = {
	{FURNITURE_TYPE_TABLES,		"Tables"},
	{FURNITURE_TYPE_CHAIRS,		"Chairs"},
	{FURNITURE_TYPE_BEDS,		"Beds"},
	{FURNITURE_TYPE_CABIN,		"Cabinets"},
	{FURNITURE_TYPE_TV,			"Television Sets"},
	{FURNITURE_TYPE_KITCHEN,	"Kitchen Appliances"},
	{FURNITURE_TYPE_BATHROOM,	"Bathroom Appliances"},
	{FURNITURE_TYPE_MISC,		"Misc Furniture"}
}

local FurnitureList = {
	--[[
		Tables
	]]--
	{FURNITURE_TYPE_TABLES,		"Conferance Table",		550},
	{FURNITURE_TYPE_TABLES, 	"Table",				732},
	{FURNITURE_TYPE_TABLES,		"Sleek White Bedside",	1205},

	--[[
		Chairs
	]]--
	{FURNITURE_TYPE_CHAIRS,		"Foldchair",			493},
	{FURNITURE_TYPE_CHAIRS,		"Armchair",				519},

	--[[
		Bed
	]]--
	{FURNITURE_TYPE_BEDS,		"White bed",			1183},
	{FURNITURE_TYPE_BEDS,		"Modern bed",			1200},
	{FURNITURE_TYPE_BEDS,		"Blue bed",				1201},
	{FURNITURE_TYPE_BEDS,		"Sleek bed",			1202},
	{FURNITURE_TYPE_BEDS,		"Gray bed",				1203},
	{FURNITURE_TYPE_BEDS,		"Some bed",				1204},

	--[[
		Cabinets
	]]--
	{FURNITURE_TYPE_CABIN,		"White Closed Cabinet",	939},
	{FURNITURE_TYPE_CABIN,		"White Open Cabinet",	939},

	--[[
		TV
	]]--
	{FURNITURE_TYPE_TV, 		"Widescreen UHD 4k TV",	734},

	--[[
		Kitchen
	]]--
	{FURNITURE_TYPE_KITCHEN,	"Refrigerator",			1192},

	--[[
		Bathroom
	]]--
	{FURNITURE_TYPE_BATHROOM,	"Shower",				768},

	--[[
		Miscellaneous
	]]--
	{FURNITURE_TYPE_MISC,		"Modern Lamp",			735},
	{FURNITURE_TYPE_MISC, 		"Statue Lamp 1",		1167},
	{FURNITURE_TYPE_MISC, 		"Statue Lamp 2",		1168},
	{FURNITURE_TYPE_MISC,		"Money Safe",			621},
	{FURNITURE_TYPE_MISC,		"Ceiling Fan",			1250}
}

-- Functions

local function CreateFurnitureData(furnitureid)

	FurnitureData[furnitureid] = {
		id = 0,
		house = 0,
		exist = false,
		model = 0,
		x = 0,
		y = 0,
		z = 0,
		rx = 0,
		ry = 0,
		rz = 0,
		object = 0
	}
end

local function DestroyFurnitureData(furnitureid)

	FurnitureData[furnitureid] = nil
end

function IsValidFurniture(furnitureid)

	if FurnitureData[furnitureid] == nil then
		return false
	end

	return true
end

function GetFurnitureNameByModel(model)

	for i = 1, #FurnitureList, 1 do

		if FurnitureList[i][3] == model then

			return FurnitureList[i][2]
		end
	end
end

local function  Furniture_GetCount(houseid)

	local count = 0

	for i = 1, MAX_FURNITURE, 1 do
		if (FurnitureData[i].exist and FurnitureData[i].house == houseid) then
			count = count + 1
		end
	end

	return count
end

local function Furniture_GetFreeID()

	for i = 1, MAX_FURNITURE, 1 do
		if (FurnitureData[i] == nil) then
			return i
		end
	end

	return 0
end

function GetFurnitureHouseID(furnitureid)
	if FurnitureData[furnitureid] == nil then
		return 0
	end

	return FurnitureData[furnitureid].house
end

function GetFurnitureLocation(furnitureid)
	if FurnitureData[furnitureid] == nil then
		return 0, 0, 0
	end

	return FurnitureData[furnitureid].x, FurnitureData[furnitureid].y, FurnitureData[furnitureid].z
end

function LoadHouseFurniture(houseid)

	local query = mariadb_prepare(sql, "SELECT * FROM furnitures WHERE house = ?;", houseid)
	mariadb_async_query(sql, query, OnHouseFurnitureLoaded, houseid)
end

function OnHouseFurnitureLoaded(houseid)

	local row_count = mariadb_get_row_count()

	if row_count ~= 0 then
		local furnitureid = 0

		for i = 1, row_count, 1 do
			furnitureid = Furniture_GetFreeID()

			if furnitureid ~= 0 then
				CreateFurnitureData(furnitureid)

				FurnitureData[furnitureid].id = mariadb_get_value_name_int(i, "id")
				FurnitureData[furnitureid].house = houseid
				FurnitureData[furnitureid].exist = true
				FurnitureData[furnitureid].model = mariadb_get_value_name_int(i, "model")
				FurnitureData[furnitureid].x = mariadb_get_value_name_int(i, "x")
				FurnitureData[furnitureid].y = mariadb_get_value_name_int(i, "y")
				FurnitureData[furnitureid].z = mariadb_get_value_name_int(i, "z")
				FurnitureData[furnitureid].rx = mariadb_get_value_name_int(i, "rx")
				FurnitureData[furnitureid].ry = mariadb_get_value_name_int(i, "ry")
				FurnitureData[furnitureid].rz = mariadb_get_value_name_int(i, "rz")
				FurnitureData[furnitureid].object = CreateObject(FurnitureData[furnitureid].model, FurnitureData[furnitureid].x, FurnitureData[furnitureid].y, FurnitureData[furnitureid].z, FurnitureData[furnitureid].rx, FurnitureData[furnitureid].ry, FurnitureData[furnitureid].rz)

				print("The furniture object ID is "..FurnitureData[furnitureid].object..".")
			end
		end
	end

	print("[OnHouseFurnitureLoaded] Loaded house furniture (houseid: "..houseid..")")
end

local function Furniture_Destroy(furnitureid)

	local query = mariadb_prepare(sql, "DELETE FROM furnitures WHERE id = ?;", FurnitureData[furnitureid].id)
	mariadb_async_query(sql, query)

	if IsValidObject(FurnitureData[furnitureid].object) then
		DestroyObject(FurnitureData[furnitureid].object)
	end

	DestroyFurnitureData(furnitureid)
end

function DestroyHouseFurniture(houseid)

	for i = 1, MAX_FURNITURE, 1 do
		if FurnitureData[i] ~= nil then
			if FurnitureData[i].house == houseid then
				Furniture_Destroy(i)
			end
		end
	end
end

-- Events

AddRemoteEvent("borkui:clientOnUICreated", function (playerid, dialogid, extraid)

	if extraid == DIALOG_HOME_FURNITURE then
		borkui.addUITitle(playerid, dialogid, 'Home Furniture')
		borkui.addUIDivider(playerid, dialogid)
		--borkui.AddUIDropdown(playerid, dialogid, options, size, 1, label) --borkui.addUIInformation(playerid, dialogid, DialogString)
		borkui.addUIDivider(playerid, dialogid)
		borkui.addUIButton(playerid, dialogid, 'Select', 'is-primary')
		borkui.addUIButton(playerid, dialogid, 'Cancel', 'is-danger')
		borkui.showUI(playerid, dialogid)
	end
end)

AddRemoteEvent("borkui:clientOnDialogSubmit", function (playerid, dialogid, extraid, button, ...)

	if extraid == DIALOG_HOME_FURNITURE then
		borkui.HideUI(playerid, dialogid)
		borkui.DestroyUI(playerid, dialogid)
	end
end)