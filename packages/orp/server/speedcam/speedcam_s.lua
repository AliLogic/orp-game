--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage('colours')

SpeedcamData = {}
MAX_SPEEDCAMS = 128
SPEEDCAM_RANGE = 1000

-- Functions

local function CreateSpeedcamData(speedcam)

	SpeedcamData[speedcam] = {}

	-- Permanent (saving) values
	SpeedcamData[speedcam].id = 0
	SpeedcamData[speedcam].objectid = 0
	SpeedcamData[speedcam].text3d = 0
	SpeedcamData[speedcam].timer = 0

	SpeedcamData[speedcam].x = 0
	SpeedcamData[speedcam].y = 0
	SpeedcamData[speedcam].z = 0

	SpeedcamData[speedcam].speed = 0
end

local function GetFreeSpeedcamId()
	for i = 1, MAX_SPEEDCAMS, 1 do
		if SpeedcamData[i] == nil then
			CreateSpeedcamData(i)
			return i
		end
	end
	return 0
end

local function DestroySpeedcamData(speedcam)
	SpeedcamData[speedcam] = nil
end

local function OnSpeedcamTick(speedcam)

	for k, v in pairs(GetPlayersInRange3D(SpeedcamData[speedcam].x, SpeedcamData[speedcam].y, SpeedcamData[speedcam].z, SPEEDCAM_RANGE)) do

		local vehicle = GetPlayerVehicle(v)
		if vehicle ~= 0 and GetPlayerState(v) == PS_DRIVER then
			local faction = FACTION_NONE

			if VehicleData[vehicle] ~= nil then
				faction = GetFactionType(VehicleData[vehicle].faction)
			end

			if faction ~= FACTION_GOV and faction ~= FACTION_MEDIC and faction ~= FACTION_POLICE then
				CallRemoteEvent(v, "OnSpeedcamFlash", speedcam, SpeedcamData[speedcam].speed)
			end
		end
	end
end

local function OnSpeedcamCreated(index, x, y, z, speed)

	SpeedcamData[index].id = mariadb_get_insert_id()

	SpeedcamData[index].x = x
	SpeedcamData[index].y = y
	SpeedcamData[index].z = z

	SpeedcamData[index].speed = speed

	SpeedcamData[index].objectid = CreateObject(963, x, y, z)
	SpeedcamData[index].text3d = CreateText3D("Speedcam ("..index..")\nSpeed: "..speed.." KM/H", 20, x, y, z + 180.0, 0.0, 0.0, 0.0)

	SpeedcamData[index].timer = CreateTimer(OnSpeedcamTick, 1000, index)
end

function Speedcam_Create(x, y, z, speed)

	local index = GetFreeSpeedcamId()
	if index == 0 then
		return false
	end

	local query = mariadb_prepare(sql, "INSERT INTO speedcams (x, y, z, speed) VALUES (?, ?, ?, ?);",
		x, y, z, speed
	)
	mariadb_async_query(sql, query, OnSpeedcamCreated, index, x, y, z, speed)

	return index
end

function Speedcam_Destroy(speedcam)

	if SpeedcamData[speedcam] == nil then
		return false
	end

	local query = mariadb_prepare(sql, "DELETE FROM speedcams WHERE id = ?;", SpeedcamData[speedcam].id)
	mariadb_async_query(sql, query)

	if IsValidObject(SpeedcamData[speedcam].objectid) then
		DestroyObject(SpeedcamData[speedcam].objectid)
	end

	if IsValidTimer(SpeedcamData[speedcam].timer) then
		DestroyTimer(SpeedcamData[speedcam].timer)
	end

	if IsValidText3D(SpeedcamData[speedcam].text3d) then
		DestroyText3D(SpeedcamData[speedcam].text3d)
	end

	DestroySpeedcamData(speedcam)
end

local function Speedcam_Load(i)

	local index = GetFreeSpeedcamId()

	if index == 0 then
		print("A free speedcam id wasn't able to be found? ("..#SpeedcamData.."/"..MAX_SPEEDCAMS..") speedcam SQL ID "..mariadb_get_value_name_int(i, "id")..".")
		return
	end

	SpeedcamData[index].id = mariadb_get_value_name_int(i, "id")

	SpeedcamData[index].x = mariadb_get_value_name_int(i, "x")
	SpeedcamData[index].y = mariadb_get_value_name_int(i, "y")
	SpeedcamData[index].z = mariadb_get_value_name_int(i, "z")
	SpeedcamData[index].speed = mariadb_get_value_name_int(i, "speed")

	SpeedcamData[index].objectid = CreateObject(963, SpeedcamData[index].x, SpeedcamData[index].y, SpeedcamData[index].z)
	SpeedcamData[index].text3d = CreateText3D("Speedcam ("..index..")\nSpeed: "..SpeedcamData[index].speed.." KM/H", 20, SpeedcamData[index].x, SpeedcamData[index].y, SpeedcamData[index].z + 180.0, 0.0, 0.0, 0.0)

	SpeedcamData[index].timer = CreateTimer(OnSpeedcamTick, 1000, index)
end

local function OnSpeedcamLoad()
	for i = 1, mariadb_get_row_count(), 1 do
		Speedcam_Load(i)
	end

	print("** Speedcams Loaded: "..mariadb_get_row_count()..".")
end

local function OnSpeedcamUnloaded(speedcam)
	if mariadb_get_affected_rows() == 0 then
		print("Speedcam ID "..speedcam.." unload unsuccessful!")
	else
		print("Speedcam ID "..speedcam.." unload successful!")
	end
end

local function Speedcam_Unload(speedcam)
	local query = mariadb_prepare(sql, "UPDATE speedcams SET x = '?', y = '?', z = '?', speed = '?' WHERE id = ?;",
		SpeedcamData[speedcam].x, SpeedcamData[speedcam].y, SpeedcamData[speedcam].z, SpeedcamData[speedcam].speed,
		SpeedcamData[speedcam].id
	)
	mariadb_async_query(sql, query, OnSpeedcamUnloaded, speedcam)
end

function Speedcam_Nearest(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0

	for v = 1, #SpeedcamData, 1 do
		if SpeedcamData[v] ~= nil then
			distance = GetDistance3D(x, y, z, SpeedcamData[v].x, SpeedcamData[v].y, SpeedcamData[v].z)

			if distance <= 200.0 then
				return v
			end
		end
	end

	return 0
end

-- Events

AddEvent("UnloadSpeedcams", function()
	for i = 1, #SpeedcamData, 1 do
		Speedcam_Unload(i)
	end
end)

AddEvent('LoadSpeedcams', function ()
	mariadb_async_query(sql, "SELECT * FROM speedcams;", OnSpeedcamLoad)
end)

AddRemoteEvent("OnSpeedcamFlashed", function(playerid, speedcam, speed)

	local price = 100 + math.tointeger(math.floor(speed - SpeedcamData[speedcam].speed))

	AddPlayerChat(playerid, "You have received a <span color=\""..colour.COLOUR_LIGHTRED().."\">$"..price.."</> speeding ticket.")
	Ticket_Add(playerid, price, "Speeding (".. speed .."/".. SpeedcamData[speedcam].speed .." KM/H)")
end)