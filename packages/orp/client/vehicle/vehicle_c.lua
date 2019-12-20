--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

AddEvent("OnPlayerStartEnterVehicle", function(vehicleid, seatid)
	CallRemoteEvent("OnPlayerStartEnterVehicle", vehicleid, seatid)
	return false
end)