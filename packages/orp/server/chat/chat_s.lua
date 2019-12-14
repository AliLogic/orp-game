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
	--AddPlayerChatRange(x, y, 800.0, string.format("<span color=\"#c2a2da\">* %s%s</>", GetPlayerName(player), text))
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
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">*"..text.." (( "..GetPlayerName(player).." ))</>")
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

AddCommand("pm", function (player, target, ...)
	if (target == nil) then
		return AddPlayerChat(player, "Usage: /pm [playerid] [text]")
	end

	if target == player then
		return AddPlayerChat(player, "You cannot PM yourself.")
	end

	if IsValidPlayer(target) == false then
		return AddPlayerChat(player, "Invalid player id.")
	end

	local args = {...}
	local text = ''

	for k, v in pairs(args) do
		text = text.." "..v
	end

	AddPlayerChat(player, "<span color=\"#eee854\">(( PM sent to "..GetPlayerName(target).." (ID: "..target.."):"..text.." ))</>")
	AddPlayerChat(target, "<span color=\"#eccd2d\">(( PM from "..GetPlayerName(player).." (ID: "..player.."):"..text.." ))</>")
end)

AddEvent("OnPlayerChatCommand", function (player, cmd, exists)	
	--[[if (GetTimeSeconds() - PlayerData[player].cmd_cooldown < 0.5) then
		AddPlayerChat(player, "Slow down with your commands.")
		return false
	end

	PlayerData[player].cmd_cooldown = GetTimeSeconds()--]]

	if not exists then
		AddPlayerChat(player, "Command '/"..cmd.."' not found!")
	end
	return true
end)

AddEvent("OnPlayerChat", function(player, text)
	local x, y, z = GetPlayerLocation(player)

	AddPlayerChatRange(x, y, 800.0, "<span color=\"#ffffffFF\">"..GetPlayerName(player).." says: "..text.."</>")
	--AddPlayerChatAll("<span color=\"#ffffffFF\">"..GetPlayerName(player).." says: "..text.."</>")
	return false
end)