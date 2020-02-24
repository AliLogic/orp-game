--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic
* Bork

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

IndustryData = {}
MAX_INDUSTRIES = 256

-- Functions

local function CreateIndustryData(industry)
	IndustryData[industry] = {}

	-- Permanent (saving) values

	IndustryData[industry].id = 0
	IndustryData[industry].markerid = 0 -- sqlid of the marker!

	IndustryData[industry].locked = 0 -- can goods be purchased from here or not?
	IndustryData[industry].products = 0 -- What products this industry offers.

	IndustryData[industry].max_goods = 400 -- The maximum amount of goods this industry can have. Default: 400.
	IndustryData[industry].goods = 0 -- Amount of goods this industry currently has.

	IndustryData[industry].priceperunit = 0 -- Price per Unit, default $0.

	IndustryData[industry].x = 0.0
	IndustryData[industry].y = 0.0
	IndustryData[industry].z = 0.0

	-- Temporary values
	IndustryData[industry].text3d = nil -- The marker for inside coordinates where you execute /buy.
end

function GetFreeIndustryId()
	for i = 1, MAX_INDUSTRIES, 1 do
		if IndustryData[i] == nil then
			CreateIndustryData(i)
			return i
		end
	end
	return 0
end

local function DestroyIndustryData(industry)
	IndustryData[industry] = nil
end

local function Industry_Unload(industry)
end

local function Industry_Load(i)
	local industry = GetFreeIndustryId()
	if industry == 0 then
		print("A free industry id wasn't able to be found? ("..#IndustryData.."/"..MAX_INDUSTRIES..") industry SQL ID "..mariadb_get_value_name_int(i, "id")..".")
		return 0
	end

	IndustryData[industry].id = mariadb_get_value_name_int(i, "id")
	IndustryData[industry].markerid = mariadb_get_value_name_int(i, "markerid")

	IndustryData[industry].locked = mariadb_get_value_name_int(i, "locked")
	IndustryData[industry].products = mariadb_get_value_name_int(i, "products")

	IndustryData[industry].max_goods = mariadb_get_value_name_int(i, "max_goods")
	IndustryData[industry].goods = mariadb_get_value_name_int(i, "goods")
	IndustryData[industry].priceperunit = mariadb_get_value_name_int(i, "priceperunit")

	IndustryData[industry].x = tonumber(mariadb_get_value_name_float(i, "x"))
	IndustryData[industry].y = tonumber(mariadb_get_value_name_float(i, "y"))
	IndustryData[industry].z = tonumber(mariadb_get_value_name_float(i, "z"))

	Industry_RefreshLabel(industry)
end

local function OnIndustryLoad()
	for i = 1, mariadb_get_row_count(), 1 do
		Industry_Load(i)
	end

	print("** Industries Loaded: " .. #IndustryData .. ".")
end

function Industry_RefreshLabel(industry)

	if not IsValidText3D(IndustryData[industry].text3d) then

		IndustryData[industry].text3d = CreateText3D(" ", 17, IndustryData[industry].x, IndustryData[industry].y, IndustryData[industry].z, 0, 0, 0)
	end

	SetText3DText(IndustryData[industry].text3d,
		string.format(
			"[%s]\nStorage: %d / %d\nPrice: $%d / Unit", 
			Products[IndustryData[industry].products].name, IndustryData[industry].goods, IndustryData[industry].max_goods, IndustryData[industry].priceperunit
		)
	)
end

-- Events

AddEvent('UnloadIndustries', function () 
	for i = 1, #IndustryData, 1 do
		Industry_Unload(i)
	end
end)

AddEvent('LoadIndustries', function ()
	mariadb_async_query(sql, "SELECT * FROM industries;", OnIndustryLoad)
end)