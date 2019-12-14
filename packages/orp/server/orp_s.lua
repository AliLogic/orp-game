--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork

Contributors:
* Blue Mountains GmbH
]]--

AddCommand("help", function (player)
	return AddPlayerChat(player, "Commands: /pos /v /w /me /do /g /b /pm")
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

	SetPlayerWeapon(player, weapon, ammo, false, slot, true)
end)

AddCommand("me", function (player, ...)
	local args = {...}
	local text = ''

	if (args == nil) then
		return AddPlayerChat(player, "Usage: /me [action]")
	end

	for k, v in pairs(args) do
		text = text.." "..v
	end

	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(player)..""..text.."</>")
end)

AddCommand("do", function (player, ...)
	local args = {...}
	local text = ''

	if (args == nil) then
		return AddPlayerChat(player, "Usage: /do [action]")
	end

	for k, v in pairs(args) do
		text = text.." "..v
	end

	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..text.." (( "..GetPlayerName(player).." ))</>")
end)

AddCommand("b", function (player, ...)
	local args = {...}
	local text = ''

	if (args == nil) then
		return AddPlayerChat(player, "Usage: /b [text]")
	end

	for k, v in pairs(args) do
		text = text.." "..v
	end

	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#b8bac6\">(( "..GetPlayerName(player).." ("..player.."):"..text.." ))</>")
end)

AddCommand("g", function (player, ...)
	local args = {...}
	local text = ''

	if (args == nil) then
		return AddPlayerChat(player, "Usage: /g [text]")
	end
	-- ./update.sh && ./start_linux.sh
	for k, v in pairs(args) do
		text = text.." "..v
	end

	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatAll(GetPlayerName(player).." ("..player.."):"..text)

end)

AddCommand("pm", function (player, target, ..)
	if (target == nil) then
		return AddPlayerChat(player, "Usage: /pm [playerid] [text]")
	end

	target = tonumber(target)

	if IsValidPlayer(target) == false then
		return AddPlayerChat(player, "Invalid player id.")
	end

	local args = {..}
	local text = ''

	for k, v in pairs(args) do
		text = text.." "..v
	end

	AddPlayerChat(player, "<span color=\"#eee854\">(( PM sent to "..GetPlayerName(target)" (ID: "..target.."):"..text.." ))</a>")
	AddPlayerChat(target, "<span color=\"#eccd2d\">(( PM from "..GetPlayerName(player)" (ID: "..player.."):"..text.." ))</a>")
end)

AddEvent("OnPlayerChat", function(player, text)
	local x, y, z = GetPlayerLocation(player)

	AddPlayerChatRange(x, y, 800.0, "<span color=\"#ffffffFF\">"..GetPlayerName(player).." says: "..text.."</>")
	--AddPlayerChatAll("<span color=\"#ffffffFF\">"..GetPlayerName(player).." says: "..text.."</>")
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
