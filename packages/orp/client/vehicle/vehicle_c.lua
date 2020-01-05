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