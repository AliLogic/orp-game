--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local ENTER_DISTANCE = 300.0

-- Functions

function GetNearestVehicleAndDoor(passenger)

	passenger = passenger or false
	local x, y, z = GetPlayerLocation()
	local vx, vy, vz = 0.0, 0.0, 0.0

	if passenger == false then

		for _, vehicle in pairs(GetStreamedVehicles()) do

			vx, vy, vz = GetVehicleLocation(vehicle)

			if GetDistance3D(x, y, z, vx, vy, vz) <= ENTER_DISTANCE then
				return vehicle, 1
			end
		end

	else

		for _, vehicle in pairs(GetStreamedVehicles()) do

			for seat = 2, #GetVehicleNumberOfSeats(vehicle), 1 do
				vx, vy, vz = GetVehicleDoorLocation(vehicle, seat)

				if GetDistance3D(x, y, z, vx, vy, vz) <= ENTER_DISTANCE then
					return vehicle, seat
				end
			end
		end

	end

	return nil, nil
end

-- Events

AddEvent("OnPlayerStartEnterVehicle", function(vehicleid, seatid)
	return false
end)

AddEvent("OnKeyPress", function(key)
	if key == "F" then

		local vehicleid, seatid = GetNearestVehicleAndDoor(false)

		if vehicleid ~= nil and seatid ~= nil then
			AddPlayerChat("Sending a remote event to the server")
			CallRemoteEvent("OnPlayerStartEnterVehicle", vehicleid, seatid)
		end

	elseif key == "G" then

		local vehicleid, seatid = GetNearestVehicleAndDoor(true)

		if vehicleid ~= nil and seatid ~= nil then
			AddPlayerChat("Sending a remote event to the server")
			CallRemoteEvent("OnPlayerStartEnterVehicle", vehicleid, seatid)
		end
	end
end)