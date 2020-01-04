AddRemoteEvent("speedo:IsPlayerInDriverSeat", function (player) 
	if GetPlayerVehicleSeat(player) == 1 then
		CallRemoteEvent(player, "speedo:ServerResponse", true)
	else
		CallRemoteEvent(player, "speedo:ServerResponse", false)
	end
end)
