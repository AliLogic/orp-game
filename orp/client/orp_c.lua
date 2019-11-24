--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork

Contributors:
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

function FormatTime(time)
	local minutes = string.format("%02d", math.floor(time / 60.0))
	local seconds = string.format("%02d", math.floor(time - (minutes * 60.0)))
	local milliseconds = string.format("%03d", math.floor((time - (minutes * 60.0) - seconds) * 1000))
	return minutes..':'..seconds..':'..milliseconds
end