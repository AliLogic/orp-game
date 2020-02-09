--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage("colours")

local WEED_PLANT_MODEL = 64
-- local POT_MODEL = 554

DRUG_NAMES = {
	"Marijuana",
	"Cocaine"
}

local DRUG_TYPE_WEED = 1
local DRUG_TYPE_COKE = 2

DrugData = {}

local TIME_PER_STAGE = 3000 -- time in ms

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

function CreatePlant(plantid, type, x, y, z)

	CreateDrugData(plantid)
	DrugData[plantid].stage = 1
	DrugData[plantid].type = type

	local scale = DRUG_STAGES[DrugData[plantid].stage].scale

	DrugData[plantid].object = CreateObject(WEED_PLANT_MODEL, x, y, z)
	SetObjectScale(DrugData[plantid].object, scale, scale, scale)
	SetObjectRotation(DrugData[plantid].object, 0.0, Random(0.0, 360.0), 0.0)

	local text_z = z + 35 + 100 * scale
	DrugData[plantid].text3d = CreateText3D("Plant (" .. plantid .. ") [" .. DRUG_NAMES[type] .. "]\nStage 1", 20, x, y, text_z, 0, 0, 0)

	DrugData[plantid].timer = CreateTimer(OnPlantTick, TIME_PER_STAGE, plantid)
end

function OnPlantTick(plantid)

	local stage = DrugData[plantid].stage + 1
	local scale = DRUG_STAGES[stage].scale
	local type = DrugData[plantid].type

	SetObjectScale(DrugData[plantid].object, scale, scale, scale)
	SetObjectRotation(DrugData[plantid].object, 0.0, Random(0.0, 360.0), 0.0)

	if not DRUG_STAGES[stage + 1] then

		DestroyTimer(DrugData[plantid].timer)
		SetText3DText(DrugData[plantid].text3d, "Plant (" .. plantid .. ") [" .. DRUG_NAMES[type] .. "]\nReady")
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

local function OnPlantLoaded(i, plantid)
	if mariadb_get_row_count() == 0 then
		print("Error with loading plant ID" .. plantid)
	else
		DrugData[plantid].id = plantid
		DrugData[plantid].stage = mariadb_get_value_name_int(1, "stage")
		DrugData[plantid].type = mariadb_get_value_name_int(1, "type")
		DrugData[plantid].x = mariadb_get_value_name_int(1, "x")
		DrugData[plantid].y = mariadb_get_value_name_int(1, "y")
		DrugData[plantid].z = mariadb_get_value_name_int(1, "z")

		local scale = DRUG_STAGES[DrugData[plantid].stage].scale
		DrugData[plantid].object = CreateObject(WEED_PLANT_MODEL, DrugData[plantid].x, DrugData[plantid].y, DrugData[plantid].z)
		SetObjectScale(DrugData[plantid].object, scale, scale, scale)
		SetObjectRotation(DrugData[plantid].object, 0.0, Random(0.0, 360.0), 0.0)

		local text_z = DrugData[plantid].z + 35 + 100 * scale
		DrugData[plantid].object = 0
		DrugData[plantid].text3d = CreateText3D("Plant (" .. plantid .. ") [" .. DRUG_NAMES[type] .. "]\nStage 1", 20, DrugData[plantid].x, DrugData[plantid].y, text_z, 0, 0, 0)
		DrugData[plantid].timer = CreateTimer(OnPlantTick, TIME_PER_STAGE, plantid)
	end
end

local function Plant_Load(i, plantid)
	local query = mariadb_prepare(sql, "SELECT * FROM plants WHERE id = ?", plantid)
	mariadb_async_query(sql, query, OnPlantLoaded, i, plantid)
end

local function OnLoadPlants()

	for i = 1, mariadb_get_row_count(), 1 do
		CreateDrugData(i)
		Plant_Load(i, mariadb_get_value_index_int(i, "id"))
	end

	print("** Plants Loaded: "..mariadb_get_row_count()..".")
end

-- Events

AddEvent('LoadPlants', function ()
	local query = mariadb_prepare(sql, "SELECT * FROM plants;")
	mariadb_async_query(sql, query, OnLoadPlants)
end)