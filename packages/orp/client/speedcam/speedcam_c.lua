-- local speedcamFlash = 0
-- local speedcamTimer = 0

AddRemoteEvent("OnSpeedcamFlash", function(speedcam, speed)

	StopCameraFade()

	local player_speed = GetPlayerVehicleSpeed(true)
	if player_speed > speed then
		StartCameraFade(0, 1, 0.1, RGB(255, 255, 255))
		CallRemoteEvent("OnSpeedcamFlashed", GetPlayerId(), speedcam, player_speed)
	end

	-- if speedcamFlash ~= 0 then
	-- 	speedcamFlash = CreateWebUI(0.0, 0.0, 1920, 1080, 1, 1)
	-- 	SetWebURL(speedcamFlash, "https://www.solidbackgrounds.com/images/3600x3600/3600x3600-white-solid-color-background.jpg")
	-- end

	-- if speedcamTimer ~= 0 then
	-- 	DestroyTimer(speedcamFlash)
	-- end

	-- SetWebVisibility(speedcamFlash, WEB_HITINVISIBLE)

	-- speedcamFlash = CreateTimer(function()
	-- 	SetWebVisibility(speedcamFlash, WEB_HIDDEN)
	-- 	DestroyTimer(speedcamFlash)
	-- end, 4000)
end)