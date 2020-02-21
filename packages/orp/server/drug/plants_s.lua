--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage("colours")

MAX_PLANTS = 100

DRUG_PLANT_MODELS = {
	64,
	554
}

DRUG_NAMES = {
	"Marijuana",
	"Cocaine"
}

DRUG_TYPE_ITEM = {
	INV_ITEM_WEED,
	INV_ITEM_COCAINE
}

DRUG_TYPE_AMOUNT = {
	{
		8,
		12
	},
	{
		10,
		20
	}
}

DRUG_TYPE_WEED = 1
DRUG_TYPE_COKE = 2

DrugData = {}

local TIME_PER_STAGE = 10 * 000 -- time in ms

DRUG_STAGES = {
	{scale = 0.10},
	{scale = 0.15},
	{scale = 0.20},
	{scale = 0.25},
	{scale = 0.35},
	{scale = 0.50},
	{scale = 0.65},
	{scale = 0.80},
	{scale = 1.00},
	{scale = 1.20}
}

-- Functions

local function CreateDrugData(plantid)

	DrugData[plantid] = {}

	DrugData[plantid].id = 0
	DrugData[plantid].object = 0
	DrugData[plantid].text3d = 0
	DrugData[plantid].stage = 1
	DrugData[plantid].timer = 0
	DrugData[plantid].type = 0
	DrugData[plantid].x = 0
	DrugData[plantid].y = 0
	DrugData[plantid].z = 0
end

local function DestroyDrugData(plantid)

	if IsValidObject(DrugData[plantid].object) then
		DestroyObject(DrugData[plantid].object)
	end

	if IsValidText3D(DrugData[plantid].text3d) then
		DestroyText3D(DrugData[plantid].text3d)
	end

	if IsValidTimer(DrugData[plantid].timer) then
		DestroyTimer(DrugData[plantid].timer)
	end

	DrugData[plantid] = nil
end

local function RefreshPlantTextLabel(plantid)
	local stage = DrugData[plantid].stage
	local text_z = DrugData[plantid].z + 35 + 100 * DRUG_STAGES[stage].scale
	local string = ""

	if IsValidText3D(DrugData[plantid].text3d) then
		DestroyText3D(DrugData[plantid].text3d)
	end

	if stage ~= 10 then
		string = "Plant (" .. plantid .. ") [" .. GetPlantTypeName(plantid) .. "]\nStage "..stage..""
	else
		string = "Plant (" .. plantid .. ") [" .. GetPlantTypeName(plantid) .. "]\nReady"
	end

	DrugData[plantid].text3d = CreateText3D(string, 20, DrugData[plantid].x, DrugData[plantid].y, text_z, 0, 0, 0)
end

local function GetFreePlantId()
	for i = 1, MAX_PLANTS, 1 do
		if DrugData[i] == nil then
			CreateDrugData(i)
			return i
		end
	end
	return 0
end

local function OnPlantCreated(index, type, x, y, z)

	DrugData[index].stage = 1
	DrugData[index].type = type

	local scale = DRUG_STAGES[1].scale

	DrugData[index].object = CreateObject(DRUG_PLANT_MODELS[type], x, y, z)
	SetObjectScale(DrugData[index].object, scale, scale, scale)
	SetObjectRotation(DrugData[index].object, 0.0, Random(0.0, 360.0), 0.0)

	RefreshPlantTextLabel(index)

	DrugData[index].timer = CreateTimer(OnPlantTick, TIME_PER_STAGE, index)
end

function CreatePlant(type, x, y, z)

	local index = GetFreePlantId()
	if index == 0 then
		return false
	end

	local query = mariadb_prepare(sql, "INSERT INTO plants (type, x, y, z) VALUES ('?', '?', ?, ?);",
		type, x, y, z
	)
	mariadb_async_query(sql, query, OnPlantCreated, index, type, x, y, z)
end

function OnPlantTick(plantid)

	local plant_stage = DrugData[plantid].stage
	if plant_stage == 10 then
		DestroyTimer(DrugData[plantid].timer)
		return
	end

	plant_stage = plant_stage + 1

	local scale = DRUG_STAGES[plant_stage].scale

	SetObjectScale(DrugData[plantid].object, scale, scale, scale)
	SetObjectRotation(DrugData[plantid].object, 0.0, Random(0.0, 360.0), 0.0)
	DrugData[plantid].stage = plant_stage

	RefreshPlantTextLabel(plantid)

	if plant_stage == 10 then

		DestroyTimer(DrugData[plantid].timer)
	end
end

function IsValidPlant(plantid)
	if DrugData[plantid] == nil then
		return false
	end

	return true
end

function Plant_Destroy(plantid)

	local query = mariadb_prepare(sql, "DELETE FROM plants WHERE id = ?", DrugData[plantid].id)
	mariadb_async_query(sql, query)

	DestroyDrugData(plantid)

	return true
end

local function Plant_Load(i)
	local indexid = GetFreePlantId()
	if indexid == 0 then
		print("A free plant id wasn't able to be found? ("..#DrugData.."/"..MAX_PLANTS..") plant SQL ID "..mariadb_get_value_name_int(i, "id")..".")
		return
	end

	CreateDrugData(indexid)

	DrugData[indexid].id = mariadb_get_value_name_int(i, "id")
	DrugData[indexid].stage = mariadb_get_value_name_int(i, "stage")
	DrugData[indexid].type = mariadb_get_value_name_int(i, "type")
	DrugData[indexid].x = mariadb_get_value_name_int(i, "x")
	DrugData[indexid].y = mariadb_get_value_name_int(i, "y")
	DrugData[indexid].z = mariadb_get_value_name_int(i, "z")

	local scale = DRUG_STAGES[DrugData[indexid].stage].scale
	DrugData[indexid].object = CreateObject(DRUG_PLANT_MODELS[DrugData[indexid].type], DrugData[indexid].x, DrugData[indexid].y, DrugData[indexid].z)
	SetObjectScale(DrugData[indexid].object, scale, scale, scale)
	SetObjectRotation(DrugData[indexid].object, 0.0, Random(0.0, 360.0), 0.0)

	DrugData[indexid].timer = CreateTimer(OnPlantTick, TIME_PER_STAGE, indexid)

	RefreshPlantTextLabel(indexid)
end

local function OnPlantUnloaded(plantid)
	if mariadb_get_affected_rows() == 0 then
		print('Plant unload unsuccessful, id: '..plantid)
	else
		print('Plant unload successful, id: '..plantid)
		DestroyDrugData(plantid)
	end
end

local function Plant_Unload(plantid)
	local query = mariadb_prepare(sql, "UPDATE plants SET stage = ?, type = ?, x = ?, y = ?, z = ? WHERE id = ?",
		DrugData[plantid].id,
		DrugData[plantid].stage,
		DrugData[plantid].type,
		DrugData[plantid].x,
		DrugData[plantid].y,
		DrugData[plantid].z
	)

	mariadb_async_query(sql, query, OnPlantUnloaded, plantid)
end

local function OnLoadPlants()
	for i = 1, mariadb_get_row_count(), 1 do
		Plant_Load(i)
	end

	print("** Plants Loaded: " .. #DrugData .. ".")
end

function GetPlantTypeName(plantid)

	if not IsValidPlant(plantid) then
		return false
	end

	return DRUG_NAMES[DrugData[plantid].type]
end

function GetPlantTypeId(plantid)

	if not IsValidPlant(plantid) then
		return 0
	end

	return DrugData[plantid].type
end

function Plant_Nearest(playerid)
	local x, y, z = GetPlayerLocation(playerid)
	local ox, oy, oz = 0.0, 0.0, 0.0
	local distance = 0

	for v = 1, #DrugData, 1 do
		if DrugData[v] ~= nil then
			ox, oy, oz = GetObjectLocation(DrugData[v].object)
			distance = GetDistance3D(x, y, z, ox, oy, oz)

			if distance <= 200.0 then
				return v
			end
		end
	end

	return 0
end

-- Events

AddEvent('LoadPlants', function ()
	mariadb_async_query(sql, "SELECT * FROM plants;", OnLoadPlants)
end)

AddEvent('UnloadPlants', function ()

	for i = 1, #DrugData, 1 do
		Plant_Unload(i)
	end
end)