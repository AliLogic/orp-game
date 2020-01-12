--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Events

AddRemoteEvent("OnSpeedcamFlash", function(speedcam, speed)

	StopCameraFade()

	local player_speed = GetPlayerVehicleSpeed(true)
	if player_speed > speed then
		StartCameraFade(0, 1, 0.1, RGB(255, 255, 255))
		CallRemoteEvent("OnSpeedcamFlashed", GetPlayerId(), speedcam, player_speed)
	end
end)