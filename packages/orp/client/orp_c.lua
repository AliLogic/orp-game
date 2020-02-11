--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Raw
* Blue Mountains GmbH
]]--

--[[function OnRaceStart(TimeForRaceSeconds)
	AddPlayerChat('<span color="#88eb00" size="18">The race starts now!</>')

	-- Enable player controls
	SetIgnoreMoveInput(false)
	SetIgnoreLookInput(false)

	TextRaceInfo = CreateTextBox(50.0, 100.0, "-")
	SetTextBoxAnchors(TextRaceInfo, 0.0, 0.5, 0.0, 0.5)
	SetTextBoxAlignment(TextRaceInfo, 0.0, 0.5)
	RaceTime = TimeForRaceSeconds
	RaceStartTime = GetTimeSeconds()

	UpdateTimer = CreateTimer(function()
		SetRaceTextInfo(CurrentCheckpoint, MaxCheckpoints, CurrentPosition, MaxRacers)
	end, 50)
end
AddRemoteEvent("OnRaceStart", OnRaceStart)]]--

--[[function SetRaceTextInfo(check, max_checks, pos, max_racers)
	if TextRaceInfo ~= 0 and IsPlayerInVehicle() then
		local speed = math.tointeger(math.floor(GetVehicleForwardSpeed(GetPlayerVehicle())))
		local gear = GetVehicleGear(GetPlayerVehicle())
		local rpm = math.floor(GetVehicleEngineRPM(GetPlayerVehicle()))
		local health = math.floor(GetVehicleHealth(GetPlayerVehicle()))

		local time_left = RaceTime - (GetTimeSeconds() - RaceStartTime)

		SetTextBoxText(TextRaceInfo, '<span size="30" style="bold" color="#fc4300">Checkpoint: '..check..'/'..max_checks..'</>\
<span size="30" style="bold" color="#fc4300">Time: '..FormatTime(time_left)..'</> \
<span size="30" style="bold" color="#fc4300">Position: '..pos..'/'..max_racers..'</>\
<span size="30" style="bold" color="#fc4300">Speed: '..speed..' km/h</>\
<span size="30" style="bold" color="#fc4300">Gear: '..gear..'</>\
<span size="30" style="bold" color="#fc4300">RPM: '..rpm..'</>\
<span size="30" style="bold" color="#fc4300">Health: '..health..'</>')
	end
end]]--

--[[function createUI (name)
	if not ui == nil then
		CallEvent("closeUI")
	end

    width, height = GetScreenSize()

    uiName = name
    ui = CreateWebUI(0, 0, 0, 0, 5, 32)
    LoadWebFile(ui, "http://asset/".. GetPackageName() .."/ui/main.html")
    SetWebAlignment(ui, 0.0, 0.0)
    SetWebAnchors(ui, 0.0, 0.0, 1.0, 1.0)
    SetWebVisibility(ui, WEB_HITINVISIBLE)
    SetIgnoreLookInput(true)
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)

    AddPlayerChat("Creating UI: ".. name)
end

-- Usage: CallEvent("createUI", "NAME_GOES_HERE")
AddEvent("createUI", createUI)

-- Destroy / Remove current GUI
function destroyUI ()
    DestroyWebUI(ui)
    ui = 0
    uiName = nil

    SetIgnoreLookInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)

    AddPlayerChat("Destorying UI")
end

-- Event to close UI
AddEvent("closeUI", destroyUI)

function onUIReady ()
    AddPlayerChat("UI Ready")
end

AddEvent("onUIReady", onUIReady)

-- Load Spawn Menu
AddRemoteEvent("LoadSpawnMenu", function ()
    CallEvent("createUI", "spawnMenu")
end)]]--

AddEvent("OnPlayerSpawn", function(playerid)
	SetPostEffect("MotionBlur", "Amount", 0.2)
end)

AddEvent("OnKeyPress", function (key)
	if key == "V" then
		local bEnable = not IsFirstPersonCamera()
		EnableFirstPersonCamera(bEnable)
		SetNearClipPlane(14)
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
	AddPlayerChat('<span color="#ff0000bb" style="bold" size="10">'..message..'</>')
end
AddEvent("OnScriptError", OnScriptError)