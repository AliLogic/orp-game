--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage("colours")

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

	print("CreateDrugData["..plantid.."] (1)")

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

	print("CreateDrugData["..plantid.."] (2)")
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

	if DRUG_STAGES[stage + 1] ~= nil then
		string = "Plant (" .. plantid .. ") [" .. DRUG_NAMES[type] .. "]\nStage "..stage..""
	else
		string = "Plant (" .. plantid .. ") [" .. DRUG_NAMES[type] .. "]\nReady"
	end

	DrugData[plantid].text3d = CreateText3D(string, 20, DrugData[plantid].x, DrugData[plantid].y, text_z, 0, 0, 0)
end

function CreatePlant(plantid, type, x, y, z)

	CreateDrugData(plantid)
	DrugData[plantid].stage = 1
	DrugData[plantid].type = type

	local scale = DRUG_STAGES[DrugData[plantid].stage].scale

	DrugData[plantid].object = CreateObject(DRUG_PLANT_MODELS[type], x, y, z)
	SetObjectScale(DrugData[plantid].object, scale, scale, scale)
	SetObjectRotation(DrugData[plantid].object, 0.0, Random(0.0, 360.0), 0.0)

	RefreshPlantTextLabel(plantid)

	DrugData[plantid].timer = CreateTimer(OnPlantTick, TIME_PER_STAGE, plantid)
end

function OnPlantTick(plantid)

	local stage = DrugData[plantid].stage + 1

	if DRUG_STAGES[stage] == nil then

		DestroyTimer(DrugData[plantid].timer)
	end

	local scale = DRUG_STAGES[stage].scale

	SetObjectScale(DrugData[plantid].object, scale, scale, scale)
	SetObjectRotation(DrugData[plantid].object, 0.0, Random(0.0, 360.0), 0.0)
	DrugData[plantid].stage = stage

	RefreshPlantTextLabel(plantid)
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
		DrugData[i].id = plantid
		DrugData[i].stage = mariadb_get_value_name_int(1, "stage")
		DrugData[i].type = mariadb_get_value_name_int(1, "type")
		DrugData[i].x = mariadb_get_value_name_int(1, "x")
		DrugData[i].y = mariadb_get_value_name_int(1, "y")
		DrugData[i].z = mariadb_get_value_name_int(1, "z")

		local scale = DRUG_STAGES[DrugData[i].stage].scale
		DrugData[i].object = CreateObject(DRUG_PLANT_MODELS[DrugData[i].type], DrugData[i].x, DrugData[i].y, DrugData[i].z)
		SetObjectScale(DrugData[i].object, scale, scale, scale)
		SetObjectRotation(DrugData[i].object, 0.0, Random(0.0, 360.0), 0.0)

		DrugData[i].timer = CreateTimer(OnPlantTick, TIME_PER_STAGE, i)

		RefreshPlantTextLabel(plantid)
	end
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

local function Plant_Load(i, plantid)
	local query = mariadb_prepare(sql, "SELECT * FROM plants WHERE id = ?", plantid)
	mariadb_async_query(sql, query, OnPlantLoaded, i, plantid)
end

local function OnLoadPlants()
	for i = 1, mariadb_get_row_count(), 1 do
		CreateDrugData(i)
		Plant_Load(i, mariadb_get_value_name_int(i, "id"))
	end

	print("** Plants Loaded: "..mariadb_get_row_count()..".")
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