--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--

SpeedCameraData = {}

local function Speedcam_Load(speedcam)
end

local function OnSpeedcamLoad()
	for i = 1, mariadb_get_row_count(), 1 do
		Speedcam_Load(mariadb_get_value_name_int(i, "id"))
	end
end

local function OnSpeedcamUnloaded(speedcam)
end

local function Speedcam_Unload(speedcam)
	local query = mariadb_prepare(sql, "UPDATE speedcam SET x = '?', y = '?', z = '?', a = '?' WHERE id = ?;",
		SpeedCameraData[speedcam].x, SpeedCameraData[speedcam].y, SpeedCameraData[speedcam].z,
		SpeedCameraData[speedcam].id
	)
	mariadb_async_query(sql, query, OnSpeedcamUnloaded, speedcam)
end

AddEvent("LoadSpeedCameras", function()
end)

AddEvent("UnloadSpeedCameras", function()
	for i = 1, #SpeedCameraData, 1 do
		Speedcam_Unload(i)
	end
end)

AddEvent('LoadSpeedcams', function ()
	mariadb_async_query(sql, "SELECT * FROM speedcam;", OnSpeedcamLoad)
end)