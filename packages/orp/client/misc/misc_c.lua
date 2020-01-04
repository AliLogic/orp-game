function GetPlayerVehicleVelocity()

	local vehicle = GetPlayerVehicle()

	if vehicle == 0 then
		return 0
	end

	return math.tointeger(math.floor(GetVehicleVelocity(vehicle)))
end

function GetPlayerVehicleSpeed(kmh)

	if kmh == true then
		return math.tointeger(math.floor(GetVehicleForwardSpeed(GetPlayerVehicle())))
	else
		return math.tointeger(math.floor(GetVehicleForwardSpeed(GetPlayerVehicle()) / 1.609))
	end
end