--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Raw
* Blue Mountains GmbH
]]--

AddEvent("OnPlayerSpawn", function(playerid)
	SetPostEffect("MotionBlur", "Amount", 0.2)
	SetPostEffect("ImageEffects", "GrainJitter", 0.0)
	SetPostEffect("ImageEffects", "GrainIntensity", 0.0)

	if IsGameDevMode() then
		CallRemoteEvent("OnPlayerGameDevMode")
	end
end)

AddEvent("OnKeyPress", function (key)
	if key == "V" then
		local bEnable = not IsFirstPersonCamera()
		EnableFirstPersonCamera(bEnable)
		if bEnable then
			SetNearClipPlane(14)
		else
			SetNearClipPlane(0)
		end
	end
end)

function FormatTime(time)
	local minutes = string.format("%02d", math.floor(time / 60.0))
	local seconds = string.format("%02d", math.floor(time - (minutes * 60.0)))
	local milliseconds = string.format("%03d", math.floor((time - (minutes * 60.0) - seconds) * 1000))
	return minutes..':'..seconds..':'..milliseconds
end

AddRemoteEvent("ToggleTaseEffect", function (bToggle)
	if bToggle == true then
		SetPostEffect("MotionBlur", "Amount", 1.0)
		SetCameraShakeRotation(0.0, 0.0, 1.0, 10.0, 0.0, 0.0)
		SetCameraShakeFOV(5.0, 5.0)
		PlayCameraShake(5 * 1000, 2.0, 1.0, 1.1)
	else
		StopCameraShake(false)
		SetPostEffect("MotionBlur", "Amount", 0.2)
	end
end)

AddRemoteEvent('SendSpeedgunMessage', function (vehiclename, vehicle) 
	AddPlayerChat(vehiclename.."'s speed: "..math.tointeger(math.floor(GetVehicleForwardSpeed(vehicle))))
end)

function OnScriptError(message)
	AddPlayerChat('<span color="#ff0000bb" style="bold" size="14">'..message..'</>')
end
AddEvent("OnScriptError", OnScriptError)