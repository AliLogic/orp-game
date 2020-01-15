local colour = ImportPackage('colours')
MAX_CALLSIGNS = 300

AddCommand("callsign", function (player, callsign, x, y, z)
	--[[if GetPlayerFactionType(player) ~= FACTION_POLICE or GetPlayerFactionType(player) ~= FACTION_MEDIC or GetPlayerFactionType(player) ~= FACTION_GOV then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be apart of a government agency to use this command.")
	end]]--

	local vehicle = GetPlayerVehicle(player)

	if vehicle == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be in a vehicle.")
	end

	local faction = GetFactionType(VehicleData[vehicle].faction)

	if VehicleData[vehicle] == nil or (faction == FACTION_CIVILIAN or faction == FACTION_NONE) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be in a faction owned vehicle.")
	end

	if callsign == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /callsign <text>")
	end

	x = tonumber(x)
	y = tonumber(y)
	z = tonumber(z)

	if string.len(callsign) < 0 or string.len(callsign) > 12 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Callsign length ranges from 1 - 12.")
	end

	if VehicleData[vehicle].callsign ~= nil and IsValidText3D(VehicleData[vehicle].callsign) then
		DestroyText3D(VehicleData[vehicle].callsign)
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Your previous callsign was destroyed!")
	end

	VehicleData[vehicle].callsign = CreateText3D(callsign, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	SetText3DAttached(VehicleData[vehicle].callsign, ATTACH_VEHICLE, vehicle, x, y, z, 0.0, 0.0, 0.0) -- coords need adjustments

	AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Callsign "..callsign.." attached!")
end)

AddEvent("UnloadCallsigns", function ()
	for i = 1, #VehicleData, 1 do
		if VehicleData[i].callsign ~= nil and IsValidText3D(VehicleData[i].callsign) then
			DestroyText3D(VehicleData[i].callsign)
		end
	end
	return
end)