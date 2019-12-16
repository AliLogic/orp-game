function cmd_v(player, ...)
    local args = {...}

    if args[1] == "lock" then
        local x, y, z = GetPlayerLocation(player)
        
        for _, v in pairs(GetAllVehicles()) do
            if VehicleData[v] ~= nil then
                if PlayerData[player].accountid == VehicleData[v].owner then
                    if GetDistance3D(x, y, z, VehicleData[v].x, VehicleData[v].y, VehicleData[v].z) < 100.0 then
                        if VehicleData[v].is_locked == true then
                            VehicleData[v].is_locked = false
                            AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle unlocked!</>")
                        else
                            VehicleData[v].is_locked = true
                            AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Vehicle locked!</>")
                        end
                        break
                    end
                end
            end
        end
    elseif args[1] == "park" then
        local vehicle = GetPlayerVehicle(player)

        if (vehicle == 0 or VehicleData[vehicle] == nil) or VehicleData[vehicle].owner ~= PlayerData[player].accountid then
            return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You are not in any vehicle you own!</>")
        end

        if GetPlayerVehicleSeat(player) ~= 0 then
            return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be in the driver's seat of your vehicle!</>")
        end

        local x, y, z = GetVehicleLocation(vehicle)
        local a = GetVehicleHeading(vehicle)

        VehicleData[vehicle].x = x
        VehicleData[vehicle].y = y
        VehicleData[vehicle].z = z
        VehicleData[vehicle].a = a
        
        Vehicle_Unload(vehicle)
        return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle parked!</>")
    elseif args[1] == "spawn" then
        if args[2] == nil or type(args[2]) ~= "integer" then
            local vehicles = ''

            for _, v in pairs(GetAllVehicles()) do
                if VehicleData[v] ~= nil then
                    if PlayerData[player].accountid == VehicleData[v].owner then
                        vehicles = string.format('%s ID:%d, Model:%d', v, VehicleData[v].model)
                    end
                end
            end

            AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /v(ehicle) spawn <ingame id>")
            AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> Owned Vehicles:"..vehicles)
            return
        end

        local vehicle = args[2]

        if VehicleData[vehicle] == nil or PlayerData[player].accountid ~= VehicleData[vehicle].owner then
            return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error:</> Invalid vehicle.")
        end

        Vehicle_Load(VehicleData[vehicle].id)
        return AddPlayerChat("<span color=\""..colour.COLOUR_DARKGREEN().."\">Vehicle "..vehicle.." (Model: "..VehicleData[vehicle].model..") spawned!</>")
    else
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /v(ehicle) <argument>")
        AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> lock, park, spawn")
        return
    end
end

AddCommand('v', cmd_v)
AddCommand('vehicle', cmd_v)