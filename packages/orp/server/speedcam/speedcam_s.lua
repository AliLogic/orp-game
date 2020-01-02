--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--

local colour = ImportPackage('colours')

SpeedcamData = {}
MAX_SPEEDCAMS = 128

local function CreateSpeedcamData(speedcam)

	SpeedcamData[speedcam] = {}

	-- Permanent (saving) values
	SpeedcamData[speedcam].id = 0
	SpeedcamData[speedcam].objectid = 0
	SpeedcamData[speedcam].text3d = 0

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

local function OnSpeedcamCreated(index, x, y, z, speed)

	SpeedcamData[index].id = mariadb_get_insert_id()

	SpeedcamData[index].x = x
	SpeedcamData[index].y = y
	SpeedcamData[index].z = z

	SpeedcamData[index].speed = speed
end

function Speedcam_Create(x, y, z, speed)

	local index = GetFreeSpeedcamId()
	if index == 0 then
		return false
	end

	SpeedcamData[index].objectid = CreateObject(963, x, y, z)
	SpeedcamData[index].text3d = CreateText3D("Speedcam ("..index..")\nSpeed: "..speed.." KM/H", 20, x, y, z, 0.0, 0.0, 0.0)

	local query = mariadb_prepare(sql, "INSERT INTO speedcams (x, y, z, speedcam) VALUES (?, ?, ?, ?);",
		x, y, z, speed
	)
	mariadb_async_query(sql, query, OnSpeedcamCreated, index, x, y, z, speed)

	return true
end

function Speedcam_Destroy(speedcam)

	if SpeedcamData[speedcam] == nil then
		return false
	end

	local query = mariadb_prepare(sql, "DELETE FROM speedcam WHERE id = ?;", SpeedcamData[speedcam].id)
	mariadb_async_query(sql, query)

	if IsValidObject(SpeedcamData[speedcam].objectid) then
		DestroyObject(SpeedcamData[speedcam].objectid)
	end

	if IsValidText3D(SpeedcamData[speedcam].text3d) then
		DestroyText3D(SpeedcamData[speedcam].text3d)
	end

	DestroySpeedcamData(speedcam)
end

local function OnSpeedcamLoaded(speedcamid)

	if mariadb_get_row_count() == 0 then
		print("Failed to load speedcam SQL ID "..speedcamid)
	else
		local index = GetFreeSpeedcamId()

		if index == 0 then
			print("A free speedcam id wasn't able to be found? ("..#SpeedcamData.."/"..MAX_SPEEDCAMS..") business SQL ID "..speedcamid..".")
			return
		end

		SpeedcamData[index].id = speedcamid

		SpeedcamData[index].x = mariadb_get_value_name_int(speedcamid, "x")
		SpeedcamData[index].y = mariadb_get_value_name_int(speedcamid, "y")
		SpeedcamData[index].z = mariadb_get_value_name_int(speedcamid, "z")
		SpeedcamData[index].speed = mariadb_get_value_name_int(speedcamid, "speed")

		SpeedcamData[index].objectid = CreateObject(963, SpeedcamData[index].x, SpeedcamData[index].y, SpeedcamData[index].z)
		SpeedcamData[index].text3d = CreateText3D("Speedcam ("..index..")\nSpeed: "..SpeedcamData[index].speed.." KM/H", 20, SpeedcamData[index].x, SpeedcamData[index].y, SpeedcamData[index].z, 0.0, 0.0, 0.0)
	end
end

local function Speedcam_Load(speedcam)
	local query = mariadb_prepare(sql, "SELECT * FROM speedcams WHERE id = '?';", speedcam)
	mariadb_async_query(sql, query, OnSpeedcamLoaded, speedcam)
end

local function OnSpeedcamLoad()
	for i = 1, mariadb_get_row_count(), 1 do
		Speedcam_Load(mariadb_get_value_name_int(i, "id"))
	end
end

local function OnSpeedcamUnloaded(speedcam)
	if mariadb_get_affected_rows() == 0 then
		print("Speedcam ID "..speedcam.." unload unsuccessful!")
	else
		print("Speedcam ID "..speedcam.." unload successful!")
	end
end

local function Speedcam_Unload(speedcam)
	local query = mariadb_prepare(sql, "UPDATE speedcam SET x = '?', y = '?', z = '?', a = '?', speed = '?' WHERE id = ?;",
		SpeedcamData[speedcam].x, SpeedcamData[speedcam].y, SpeedcamData[speedcam].z,
		SpeedcamData[speedcam].id
	)
	mariadb_async_query(sql, query, OnSpeedcamUnloaded, speedcam)
end

AddEvent("UnloadSpeedCameras", function()
	for i = 1, #SpeedcamData, 1 do
		Speedcam_Unload(i)
	end
end)

AddEvent('LoadSpeedcams', function ()
	mariadb_async_query(sql, "SELECT * FROM speedcam;", OnSpeedcamLoad)
end)