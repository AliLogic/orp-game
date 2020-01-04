local speedo = nil

CreateTimer(function () 
	if IsPlayerInVehicle() then
		CallRemoteEvent("speedo:IsPlayerInDriverSeat")
	end
end, 500)

AddRemoteEvent("speedo:ServerResponse", function (status) 
	if status then
		local speed = GetVehicleForwardSpeed(GetPlayerVehicle())
		if speedo == nil then
			if speed < 0 then
				speed = speed * -1
			end

			speedo = CreateTextBox(0, 0, speed.." KMH", "right")
			SetTextBoxAnchors(speedo, 0.5, 0.5, 0.5, 0.5)
			SetTextBoxAlignment(speedo, 0.5, 0.5)
		else
			if speed < 0 then
				speed = speed * -1
			end

			SetTextBoxText(speedo, speed.." KMH")
		end
	end
end)

AddEvent("OnPlayerLeaveVehicle", function(player, vehicle, seat)
	DestroyTextBox(speedo)
	speedo = nil
end)
