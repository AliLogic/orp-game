local colour = ImportPackage('colours')
MAX_CALLSIGNS = 300

AddCommand("callsign", function (player, callsign)
    --[[if GetPlayerFactionType(player) ~= FACTION_POLICE or GetPlayerFactionType(player) ~= FACTION_MEDIC or GetPlayerFactionType(player) ~= FACTION_GOV then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be apart of a government agency to use this command.")
    end]]
    
    if IsPlayerInVehicle(player) == false then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be in a vehicle.")
    end

    local vehicle = GetPlayerVehicle(player)
    
    if VehicleData[vehicle] == nil --[[or VehicleData[vehicle].faction ~= GetPlayerFactionType(player)]] then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> You must be in a government owned vehicle.")
    end

    if callsign == nil then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /callsign <text>")
    end

    if string.len(callsign) < 0 or string.len(callsign) > 12 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Callsign length ranges from 1 - 12.")
    end

    if (IsValidText3D(VehicleData[vehicle].callsign)) then
        DestroyText3D(VehicleData[vehicle].callsign)
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Your previous callsign was destroyed!")
    end

    VehicleData[vehicle].callsign = CreateText3D(callsign, 10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    SetText3DAttached(VehicleData[vehicle].callsign, ATTACH_VEHICLE, vehicle, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, wheel_frear_l)
    
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Callsign "..callsign.." attached!")
end)

AddEvent("UnloadCallsigns", function ()
    for i = 1, #VehicleData, 1 do
        if IsValidText3D(VehicleData[i].callsign) then
            DestroyText3D(VehicleData[i].callsign)
        end           
    end
    return 
end)