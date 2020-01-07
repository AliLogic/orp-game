function GetPlayerVehicleVelocity()

	local vehicle = GetPlayerVehicle()

	if vehicle == 0 then
		return 0
	end

	return math.tointeger(math.floor(GetVehicleVelocity(vehicle)))
end

function GetPlayerVehicleSpeed(kmh)

	local vehicle = GetPlayerVehicle()

	if vehicle == 0 then
		return 0
	end

	if kmh == true then
		return math.tointeger(math.floor(GetVehicleForwardSpeed(vehicle)))
	else
		return math.tointeger(math.floor(GetVehicleForwardSpeed(vehicle) / 1.609))
	end
end

function GetPlayerVehicleRPM()
	local vehicle = GetPlayerVehicle()

	if vehicle == 0 then
		return 0
	end

	return GetVehicleEngineRPM(vehicle)
end