local speedo = CreateWebUI(0, 0, 0, 0, 1, 30)
SetWebAlignment(speedo, 0, 0)
SetWebAnchors(speedo, 0, 0, 1, 1)
SetWebURL(speedo, "http://asset/"..GetPackageName().."/client/speedo/speedo.html")
SetWebVisibility(speedo, WEB_HIDDEN)

local speedoReady = false

AddEvent("OnPackageStop", function()
	DestroyWebUI(speedo)
end)

local timer = 0

local function UpdateSpeedo()
	local speed = GetPlayerVehicleSpeed()

	--[[if speedo == nil then
		speedo = CreateTextBox(0, -250, "<span color=\"#FF0000\" size=\"28\">"..speed.." KMH</>", "right")
		SetTextBoxAnchors(speedo, 0.5, 0.5, 0.5, 0.5)
		SetTextBoxAlignment(speedo, 0.5, 0.5)
	end]]

	if speed ~= false then
		if speed < 0 then
			speed = speed * -1
			SetSpeedoSpeed(speed)
			--SetTextBoxText(speedo, "<span color=\"#FF0000\" size=\"28\">"..speed.." KMH (R)</>")
		else
			SetSpeedoSpeed(speed)
			--SetTextBoxText(speedo, "<span color=\"#FF0000\" size=\"28\">"..speed.." KMH</>")
		end
	end
end

AddRemoteEvent("ToggleSpeedo", function (bToggle)
	if bToggle then
		if not IsValidTimer(timer) then
			timer = CreateTimer(UpdateSpeedo, 250)
			ToggleSpeedometer()
		end
	else
		if IsValidTimer(timer) then
			DestroyTimer(timer)
		end

		if speedo ~= nil then
			ToggleSpeedometer()
		end
	end
end)

AddEvent("OnPlayerLeaveVehicle", function(player, vehicle, seat)
	if speedo ~= nil then
		ToggleSpeedometer()
	end
end)

-- Speedometer Functions

function ToggleSpeedometer() 
	if speedoReady == true then
		ExecuteWebJS(speedo, "toggleSpeedometer();")
		SetWebVisibility(speedo, WEB_HITINVISIBLE)
	end
end

function SetSpeedoSpeed(speed)
	if speedoReady == true then
		speed = math.tointeger(speed) -- Incase a number wasn't passed.
		ExecuteWebJS(speedo, "setSpeedoSpeed("..speed..");")
	end
end

AddEvent("speedo:debug", function (text) 
	AddPlayerChat("SPEEDO: "..text.."")
	speedoReady = true
end)