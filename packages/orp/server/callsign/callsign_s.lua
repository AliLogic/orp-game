local colour = ImportPackage('colours')
MAX_CALLSIGNS = 300

AddCommand("callsign", function (player, callsign)
	--[[if GetPlayerFactionType(player) ~= FACTION_POLICE or GetPlayerFactionType(player) ~= FACTION_MEDIC or GetPlayerFactionType(player) ~= FACTION_GOV then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be apart of a government agency to use this command.")
	end]]--

	local vehicle = GetPlayerVehicle(player)

	if vehicle == 0 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be in a vehicle.")
	end

	if VehicleData[vehicle] == nil or (GetFactionType(VehicleData[vehicle].faction) ~= FACTION_GOV and GetFactionType(VehicleData[vehicle].faction) ~= FACTION_POLICE) then -- VehicleData[vehicle].faction ~= GetPlayerFactionType(player)
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be in a government or police owned vehicle.")
	end

	if callsign == nil then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /callsign <text>")
	end

	if string.len(callsign) < 0 or string.len(callsign) > 12 then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Callsign length ranges from 1 - 12.")
	end

	if VehicleData[vehicle].callsign ~= nil and IsValidText3D(VehicleData[vehicle].callsign) then
		DestroyText3D(VehicleData[vehicle].callsign)
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Your previous callsign was destroyed!")
	end

	VehicleData[vehicle].callsign = CreateText3D(callsign, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	SetText3DAttached(VehicleData[vehicle].callsign, ATTACH_VEHICLE, vehicle, 10.0, 0.0, 40.0, 0.0, 0.0, 0.0, 'wheel_frear_l') -- coords need adjustments

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