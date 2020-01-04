local speedcamFlash = 0
local speedcamTimer = 0

AddRemoteEvent("FlashSpeedcam", function()

	if speedcamFlash ~= 0 then
		speedcamFlash = CreateWebUI(0.0, 0.0, 1920, 1080, 1, 1)
		SetWebURL(speedcamFlash, "https://www.solidbackgrounds.com/images/3600x3600/3600x3600-white-solid-color-background.jpg")
	end

	if speedcamTimer ~= 0 then
		DestroyTimer(speedcamFlash)
	end

	speedcamFlash = CreateTimer(function()
		SetWebVisibility(speedcamFlash, WEB_HIDDEN)
		DestroyTimer(speedcamFlash)
	end, 2000)

	SetWebVisibility(speedcamFlash, WEB_HITINVISIBLE)
end)