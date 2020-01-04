local speedo = nil
local timer = 0

local function UpdateSpeedo()
	local speed = GetPlayerVehicleSpeed()

	if speedo == nil then
		speedo = CreateTextBox(0, 0, "<span style=\"font-size: 24px;\">"..speed.." KMH</>", "right")
		SetTextBoxAnchors(speedo, 0.5, 0.5, 0.5, 0.5)
		SetTextBoxAlignment(speedo, 0.5, 0.5)
	end

	if speed < 0 then
		speed = speed * -1
		SetTextBoxText(speedo, speed.." KMH (R)")
	else
		SetTextBoxText(speedo, speed.." KMH")
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

		DestroyTextBox(speedo) -- speedo is equalling nil here.
	end
end)

AddEvent("OnPlayerLeaveVehicle", function(player, vehicle, seat)
	DestroyTextBox(speedo)
	speedo = nil
end)