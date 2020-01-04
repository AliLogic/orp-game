local speedo = nil
local timer = 0

local function UpdateSpeedo()
	local speed = GetPlayerVehicleSpeed()

	if speedo == nil then
		speedo = CreateTextBox(0, -50, "<span color=\"#FF0000\" size=\"28\">"..speed.." KMH</>", "right")
		SetTextBoxAnchors(speedo, 0.5, 0.5, 0.5, 0.5)
		SetTextBoxAlignment(speedo, 0.5, 0.5)
	end

	if speed ~= false then
		if speed < 0 then
			speed = speed * -1
			SetTextBoxText(speedo, "<span color=\"#FF0000\" size=\"28\">"..speed.." KMH (R)")
		else
			SetTextBoxText(speedo, "<span color=\"#FF0000\" size=\"28\">"..speed.." KMH")
		end
	end
end

AddRemoteEvent("ToggleSpeedo", function (bToggle)

	if bToggle then

		if not IsValidTimer(timer) then
			timer = CreateTimer(UpdateSpeedo, 500)
		end
	else
		if IsValidTimer(timer) then
			DestroyTimer(timer)
		end

		if speedo ~= nil then
			DestroyTextBox(speedo)
			speedo = nil
		end
	end
end)

AddEvent("OnPlayerLeaveVehicle", function(player, vehicle, seat)

	if speedo ~= nil then
		DestroyTextBox(speedo)
		speedo = nil
	end
end)