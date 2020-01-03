local colour = ImportPackage('colours')

-- For rental vehicles.
AddEvent("UnrentPlayerVehicle", function (player) 
	if PlayerData[player].renting ~= 0 then
		local vehicle = PlayerData[player].renting

		VehicleData[vehicle].is_locked = false
		VehicleData[vehicle].renter = 0

		PlayerData[player].renting = 0
		print("Player "..player.." is leaving, freeing up their rental vehicle!")
	end
end)

AddCommand("rent", function (player)
	if PlayerData[player].renting ~= 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are already renting a vehicle! Please /unrent first before renting another.</>")
	end

	local vehicle = GetPlayerVehicle(player)

	if vehicle == 0 or (VehicleData[vehicle] ~= nil and
		VehicleData[vehicle].renter == 0 and
		VehicleData[vehicle].rental == 1
	) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be in a vehicle you can actually rent.</>")
	end

	-- Check if player has valid license
	-- Check if player has fifty bucks.

	-- Subtract fifty bucks. (JUST TEMP PRICING THEY'LL BE VARIABLE IN THE FUTURE BY VEHICLE MODEL OR SOMETHING.)

	VehicleData[vehicle].renter = player
	PlayerData[player].renting = vehicle

	if GetVehicleEngineState(vehicle) ~= true then
		AddPlayerChat(player, "[DEBUG] Vehicle engine state TRUE.")
		StartVehicleEngine(vehicle)
	end

	return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">You have successfully rented this vehicle! It'll be accessible to you until you disconnect.</>")
end)

AddCommand("unrent", function (player)
	if PlayerData[player].renting == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You aren't renting a vehicle! Please /rent first before unrenting.</>")
	end

	local vehicle = PlayerData[player].renting

	PlayerData[player].renting = 0
	VehicleData[vehicle].renter = 0

	SetVehicleLocation(vehicle, VehicleData[vehicle].x, VehicleData[vehicle].y, VehicleData[vehicle].z)
	SetVehicleHeading(vehicle, VehicleData[vehicle].a)
	SetVehicleHealth(vehicle, 5000) -- Set it to the correct value though.

	return AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">You have successfully returned your rental vehicle!</>")
end)