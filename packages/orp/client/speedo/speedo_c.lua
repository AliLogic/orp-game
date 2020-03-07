local speedo = 0
local speedoReady = false
local speedoToggleStatus = false -- Its not visible.

AddEvent("OnPackageStart", function()
	speedo = CreateWebUI(0, 0, 0, 0, 1, 60)
	SetWebAlignment(speedo, 0, 0)
	SetWebAnchors(speedo, 0, 0, 1, 1)
	SetWebURL(speedo, "http://asset/"..GetPackageName().."/client/speedo/speedo.html")
	SetWebVisibility(speedo, WEB_HIDDEN)
end)

AddEvent("OnPackageStop", function()
	DestroyWebUI(speedo)
end)

local timer = 0

local function UpdateSpeedo()
	local speed = GetPlayerVehicleSpeed(false)
	local rpm = GetPlayerVehicleRPM()

	if speed ~= false then
		SetSpeedoRPM(rpm)
		SetSpeedoSpeed(speed)
	end
end

AddRemoteEvent("ToggleSpeedo", function (bToggle)
	if bToggle then
		if not IsValidTimer(timer) then
			timer = CreateTimer(UpdateSpeedo, 100)
			ToggleSpeedometer()
		end
	else
		if IsValidTimer(timer) then
			DestroyTimer(timer)
		end

		if speedo ~= nil and speedoToggleStatus == true then
			ToggleSpeedometer()
		end
	end
end)

-- Speedometer Wrapper Functions

function ToggleSpeedometer()
	if speedoReady == true then
		if speedoToggleStatus == true then
			ExecuteWebJS(speedo, "toggleSpeedometer(false);")
			SetWebVisibility(speedo, WEB_HIDDEN)
			speedoToggleStatus = false
		else
			ExecuteWebJS(speedo, "toggleSpeedometer(true);")
			SetWebVisibility(speedo, WEB_HITINVISIBLE)
			speedoToggleStatus = true
		end
	end
end

function SetSpeedoSpeed(speed)
	if speedoReady == true then
		speed = math.tointeger(speed) -- Incase a number wasn't passed.
		ExecuteWebJS(speedo, "setSpeedoSpeed("..speed..");")
	end
end

function SetSpeedoRPM(rpm)
	if speedoReady == true then
		rpm = math.tointeger(rpm) -- Incase a number wasn't passed.
		ExecuteWebJS(speedo, "setSpeedoRPM("..rpm..");")
	end
end

AddEvent("speedo:debug", function (text) 
	if speedoReady == false then speedoReady = true end
	AddPlayerChat("SPEEDO: "..text.."")
end)