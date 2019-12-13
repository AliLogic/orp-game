--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork

Contributors:
* Blue Mountains GmbH
]]--

AddCommand("help", function (player)
	return AddPlayerChaT(player, "Commands: /pos /v /w")
end)

AddCommand("pos", function (player, id)
	local x, y, z = GetPlayerLocation(player)
	return AddPlayerChat(player, "X: "..x.."Y: "..y.."Z: "..z)
end)

AddCommand("v", function (player, model)
	if (model == nil) then
		return AddPlayerChat(player, "Usage: /v <model>")
	end

	model = tonumber(model)

	if (model < 1 or model > 12) then
		return AddPlayerChat(player, "Vehicle model "..model.." does not exist.")
	end

	local x, y, z = GetPlayerLocation(player)
	local h = GetPlayerHeading(player)

	local vehicle = CreateVehicle(model, x, y, z, h)
	if (vehicle == false) then
		return AddPlayerChat(player, "Failed to spawn your vehicle.")
	end

	SetVehicleLicensePlate(vehicle, "ONSET")
	AttachVehicleNitro(vehicle, true)

	if (model == 8) then
		-- Set Ambulance blue color and license plate text
		SetVehicleColor(vehicle, RGB(0.0, 60.0, 240.0))
		SetVehicleLicensePlate(vehicle, "EMS-02")
	end

    -- Set us in the driver seat
	SetPlayerInVehicle(player, vehicle)
	AddPlayerChat(player, "Vehicle spawned! (New ID: "..vehicle..")")
end)

AddCommand("w", function (player, weapon, slot, ammo)
	if (weapon == nil or slot == nil or ammo == nil) then
		return AddPlayerChat(player, "Usage: /w <weapon> <slot> <ammo>")
	end

	SetPlayerWeapon(player, weapon, ammo, true, slot, true)
end)

AddEvent("OnPlayerChat", function(player, text)
	local x, y, z = GetPlayerLocation(player)

	--AddPlayerChatRange(x, y, 75.0, "<span color=\"#ffffffFF\">"..GetPlayerName(player).." says: "..text.."</>")
	AddPlayerChatAll("<span color=\"#ffffffFF\">"..GetPlayerName(player).." says: "..text.."</>")
	return false
end)

function OnPlayerJoin(player)
	return AddPlayerChat(player, 'Welcome to <span color="#ffff00">Onset</> Roleplay!')
end
AddEvent("OnPlayerJoin", OnPlayerJoin)

function OnPlayerDeath(player, instigator)
	AddPlayerChatAll(GetPlayerName(player).." has died!")
end
AddEvent("OnPlayerDeath", OnPlayerDeath)

function OnPlayerQuit(player)
	AddPlayerChatAll(GetPlayerName(player).." has left the server!")
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function FormatTime(time)
	local minutes = string.format("%02d", math.floor(time / 60.0))
	local seconds = string.format("%02d", math.floor(time - (minutes * 60.0)))
	local milliseconds = string.format("%03d", math.floor((time - (minutes * 60.0) - seconds) * 1000))
	return minutes..':'..seconds..':'..milliseconds
end

function fexist(filename) return file_exists(filename) end
function file_exists(filename)
    local file = io.open(filename, "r")
    if file then
        file:close()
        return true
    end
    return false
end
