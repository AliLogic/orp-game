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

WeedData = {}

local TIME_PER_STAGE = 3000 -- time in ms

WEED_STAGES = {
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

local function CreateWeedData(weedid)

	WeedData[weedid] = {}

	WeedData[weedid].object = 0
	WeedData[weedid].text3d = 0
	WeedData[weedid].stage = 1
	WeedData[weedid].timer = 0
end

local function DestroyWeedData(weedid)

	if IsValidObject(WeedData[weedid].object) then
		DestroyObject(WeedData[weedid].object)
	end

	if IsValidText3D(WeedData[weedid].text3d) then
		DestroyText3D(WeedData[weedid].text3d)
	end

	if IsValidTimer(WeedData[weedid].timer) then
		DestroyTimer(WeedData[weedid].timer)
	end

	WeedData[weedid] = nil
end

function CreateWeed(weedid, x, y, z)

	CreateWeedData(weedid)
	WeedData[weedid].stage = 1
	local scale = WEED_STAGES[WeedData[weedid].stage].scale

	WeedData[weedid].object = CreateObject(WEED_PLANT_MODEL, x, y, z)
	SetObjectScale(WeedData[weedid].object, scale, scale, scale)
	SetObjectRotation(WeedData[weedid].object, 0.0, Random(0.0, 360.0), 0.0)

	local text_z = z + 35 + 100 * scale
	WeedData[weedid].text3d = CreateText3D("Weed (" .. weedid .. ")\nStage 1", 20, x, y, text_z, 0, 0, 0)

	WeedData[weedid].timer = CreateTimer(OnWeedTick, TIME_PER_STAGE, weedid)
end

function OnWeedTick(weedid)

	local stage = WeedData[weedid].stage + 1
	local scale = WEED_STAGES[stage].scale

	SetObjectScale(WeedData[weedid].object, scale, scale, scale)
	SetObjectRotation(WeedData[weedid].object, 0.0, Random(0.0, 360.0), 0.0)

	if not WEED_STAGES[stage + 1] then

		DestroyTimer(WeedData[weedid].timer)
		SetText3DText(WeedData[weedid].text3d, "Weed (" .. weedid .. ")\nReady")
	end
end