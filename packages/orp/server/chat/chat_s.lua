local colour = ImportPackage('colours')



AddCommand("q", function (playerid)
	return KickPlayer(playerid, "Goodbye!")
end)

AddCommand("help", function (player)
	AddPlayerChat(player, "Commands: /me /do /s /l /ame /ado /g /b /pm /ahelp /stats /q")
	AddPlayerChat(player, "Commands: /(inv)entory /r(adio) /r(adio)t(une) /factions")
	return 
end)

AddCommand("w", function (player, weapon, slot, ammo)
	if (PlayerData[player].admin < 5) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (weapon == nil or slot == nil or ammo == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /w <weapon> <slot> <ammo>")
	end

    SetPlayerWeapon(player, weapon, ammo, true, slot, true)
    AddPlayerChat(player, 'Given you a '..weapon..' with '..ammo..' ammo.')
end)

function cmd_shout(playerid, ...)

	local args = table.concat({...}, " ")

	if #{...} then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /shout [message]")
	end

	local x, y, z = GetPlayerLocation(playerid)

	AddPlayerChatRange(x, y, 1200.0, "<span color=\"#ffffffFF\">"..GetPlayerName(playerid).." shouts: "..args.."</>")
end
AddCommand("shout", cmd_shout)
AddCommand("s", cmd_shout)

function cmd_low(playerid, ...)

	local args = table.concat({...}, " ")

	if #{...} then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /low [message]")
	end

	local x, y, z = GetPlayerLocation(playerid)

	AddPlayerChatRange(x, y, 400.0, "<span color=\"#ffffffFF\">"..GetPlayerName(playerid).." whispers: "..args.."</>")
end
AddCommand("low", cmd_low)
AddCommand("l", cmd_low)

AddCommand("me", function (player, ...)
	local args = {...}
	local text = ''

	if (args[1] == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /me [action]")
	end

	for _, v in pairs(args) do
		text = text.." "..v
	end

	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(player)..""..text.."</>")
	--AddPlayerChatRange(x, y, 800.0, string.format("<span color=\"#c2a2da\">* %s%s</>", GetPlayerName(player), text))
end)

AddCommand("do", function (player, ...)
	local args = {...}
	local text = ''

	if (args[1] == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /do [action]")
	end

	for k, v in pairs(args) do
		text = text.." "..v
	end

	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">*"..text.." (( "..GetPlayerName(player).." ))</>")
end)

AddCommand("ame", function(player, ...)
    local message = table.concat({...}, " ")
    local x, y, z = GetPlayerLocation(player)

    if message == nil or #{...} == 0 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /ame [action]")
    end

    SetPlayerChatBubble(player, "<span color=\""..colour.COLOUR_PURPLE().."\"> *"..message.."</>", 4)
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_PURPLE().."\"> Annotated /me: "..message.."</>")
end)

AddCommand("ado", function(player, ...)
    local message = table.concat({...}, " ")
    local x, y, z = GetPlayerLocation(player)

    if message == nil or #{...} == 0 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /ado [action]")
    end

    SetPlayerChatBubble(player, "<span color=\""..colour.COLOUR_PURPLE().."\"> *"..message.." (( "..GetPlayerName(player).." ))</>", 4)
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_PURPLE().."\"> Annotated /do: "..message.."</>")
end)

AddCommand("b", function (player, ...)
	local args = {...}
	local text = ''

	if (args[1] == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /b [text]")
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

	if (args[1] == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /g [text]")
	end
	-- ./update.sh && ./start_linux.sh
	for k, v in pairs(args) do
		text = text.." "..v
	end

	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatAll(GetPlayerName(player).." ("..player.."):"..text)

end)

AddCommand("pm", function (player, target, ...)
    local args = {...}

	if (target == nil or args[1] == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /pm [playerid] [text]")
	end

	if target == player then
		return AddPlayerChat(player, "You cannot PM yourself.")
	end

	if IsValidPlayer(target) == false then
		return AddPlayerChat(player, "Invalid player id.")
    end
    
	local text = ''

	for k, v in pairs(args) do
		text = text.." "..v
	end

	AddPlayerChat(player, "<span color=\""..colour.COLOUR_PMOUT().."\">(( PM sent to "..GetPlayerName(target).." (ID: "..target.."):"..text.." ))</>")
	AddPlayerChat(target, "<span color=\""..colour.COLOUR_PMIN().."\">(( PM from "..GetPlayerName(player).." (ID: "..player.."):"..text.." ))</>")
end)

AddCommand('players', function (player)
	for k, v in pairs(GetAllPlayers()) do
		AddPlayerChat(player, "ID: "..v.." Name: "..GetPlayerName(v))
	end
end)

AddCommand('stats', function (player)
	ViewPlayerStats(player, player)
end)

AddEvent("OnPlayerChatCommand", function (player, cmd, exists)	
	if (GetTimeSeconds() - PlayerData[player].cmd_cooldown < 0.5) then
		AddPlayerChat(player, "Slow down with your commands.")
		return false
	end

	PlayerData[player].cmd_cooldown = GetTimeSeconds()

	if not exists then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: </>The command '/"..cmd.."' doesnt exist! Type in /help or consult a helper.")
	else
		if PlayerData[player].logged_in == false then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be logged in to use any commands.</>")
			return false
		end
	end
	return true
end)

AddEvent("OnPlayerChat", function(player, text)
	local x, y, z = GetPlayerLocation(player)

	AddPlayerChatRange(x, y, 800.0, "<span color=\"#ffffffFF\">"..GetPlayerName(player).." says: "..text.."</>")
	--AddPlayerChatAll("<span color=\"#ffffffFF\">"..GetPlayerName(player).." says: "..text.."</>")
	return false
end)

AddCommand("anim", function (playerid, anim)
	SetPlayerAnimation(playerid, anim)
end)