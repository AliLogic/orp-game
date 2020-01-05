--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

AddEvent("OnPlayerStartEnterVehicle", function(vehicleid, seatid)
	AddPlayerChat("Sending a remote event to the server")
	CallRemoteEvent("OnPlayerStartEnterVehicle", vehicleid, seatid)
	return false
end)

AddRemoteEvent("SetVehicleTrunk", function (bToggle)

	if bToggle then
		SetVehicleTrunkRatio(GetPlayerVehicle(), 60)
	else
		SetVehicleTrunkRatio(GetPlayerVehicle(), 0)
	end
end)

AddRemoteEvent("SetVehicleHood", function (bToggle)

	if bToggle then
		SetVehicleHoodRatio(GetPlayerVehicle(), 60)
	else
		SetVehicleHoodRatio(GetPlayerVehicle(), 0)
	end
end)