local colour = ImportPackage('colours')

AddCommand("q", function (playerid)
	return KickPlayer(playerid, "Goodbye!")
end)

AddCommand("levelup", function (playerid)

    local level = PlayerData[playerid].level
    local exp = PlayerData[playerid].exp
    local required_exp = (level * 4) + 2

    if (required_exp > exp) then
        return AddPlayerChat(playerid, "You do not have enough experience points to level up ("..exp.."/"..required_exp..")")
    end

    PlayerData[playerid].level = level + 1
    PlayerData[playerid].exp = exp - required_exp

    AddPlayerChat(playerid, "You have leveled up to "..PlayerData[playerid].level..".")

    local query = mariadb_prepare(sql, "UPDATE characters SET level = ?, exp = ? WHERE id = ? LIMIT 1",
        PlayerData[playerid].level,
        PlayerData[playerid].exp,
        PlayerData[playerid].id
    )
    mariadb_async_query(sql, query)

    return
end)

AddCommand("help", function (player)
	AddPlayerChat(player, "Commands: /me /do /s /l /ame /ado /g /b /pm /ahelp /stats /q")
	AddPlayerChat(player, "Commands: /(inv)entory /r(adio) /r(adio)t(une) /factions /levelup")
	AddPlayerChat(player, "Commands: /anims")
	return
end)

AddCommand("anims", function (player)
	AddPlayerChat(player, "Animations: /sit /lay /wave /stretch")
	return
end)

AddCommand("w", function (player, weapon, slot, ammo)
	if (PlayerData[player].admin < 5) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You don't have permission to use this command.</>")
	end

	if (weapon == nil or slot == nil or ammo == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /w <weapon> <slot> <ammo>")
	end

    SetPlayerWeapon(player, weapon, ammo, true, slot, true)
    AddPlayerChat(player, 'Given you a '..weapon..' with '..ammo..' ammo.')
end)

local function cmd_shout(playerid, ...)

	local args = table.concat({...}, " ")

	if #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /shout [message]")
	end

	local x, y, z = GetPlayerLocation(playerid)

	AddPlayerChatRange(x, y, 1200.0, "<span color=\"#ffffffFF\">"..GetPlayerName(playerid).." shouts: "..args.."</>")
end
AddCommand("shout", cmd_shout)
AddCommand("s", cmd_shout)

local function cmd_low(playerid, ...)

	local args = table.concat({...}, " ")

	if #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /low [message]")
	end

	local x, y, z = GetPlayerLocation(playerid)

	AddPlayerChatRange(x, y, 400.0, "<span color=\"#ffffffFF\">"..GetPlayerName(playerid).." whispers: "..args.."</>")
end
AddCommand("low", cmd_low)
AddCommand("l", cmd_low)

AddCommand("me", function (player, ...)

	if (#{...} == 0) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /me [action]")
	end

	local text = table.concat({...}, " ")

	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(player).." "..text.."</>")
	--AddPlayerChatRange(x, y, 800.0, string.format("<span color=\"#c2a2da\">* %s%s</>", GetPlayerName(player), text))
end)

AddCommand("do", function (player, ...)

	if (#{...} == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /do [action]")
	end

	local text = table.concat({...}, " ")

	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..text.." (( "..GetPlayerName(player).." ))</>")
end)

AddCommand("ame", function(player, ...)
    local message = table.concat({...}, " ")
    local x, y, z = GetPlayerLocation(player)

    if message == nil or #{...} == 0 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /ame [action]")
    end

	--SetPlayerChatBubble(player, "<span color=\""..colour.COLOUR_PURPLE().."\"> *"..message.."</>", 4)
	SetPlayerChatBubble(player, "* "..message.."", 4)
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_PURPLE().."\"> Annotated /me: "..message.."</>")
end)

AddCommand("ado", function(player, ...)
    local message = table.concat({...}, " ")
    local x, y, z = GetPlayerLocation(player)

    if message == nil or #{...} == 0 then
        return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /ado [action]")
    end

	--SetPlayerChatBubble(player, "<span color=\""..colour.COLOUR_PURPLE().."\"> *"..message.." (( "..GetPlayerName(player).." ))</>", 4)
	SetPlayerChatBubble(player, "* "..message.." (( "..GetPlayerName(player).." ))", 4)
    AddPlayerChat(player, "<span color=\""..colour.COLOUR_PURPLE().."\"> Annotated /do: "..message.."</>")
end)

AddCommand("b", function (player, ...)

	if (#{...} == nil) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /b [text]")
	end

	local text = table.concat({...}, " ")
	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#b8bac6\">(( "..GetPlayerName(player).." ("..player.."): "..text.." ))</>")
end)

AddCommand("g", function (player, ...)

	if (#{...} == 0) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /g [text]")
	end
	-- ./update.sh && ./start_linux.sh

	local text = table.concat({...}, " ")
	local x, y, z = GetPlayerLocation(player)
	AddPlayerChatAll(GetPlayerName(player).." ("..player.."):"..text)

end)

AddCommand("pm", function (player, target, ...)

	if (target == nil or #{...} == 0) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /pm [playerid] [text]")
	end

	if target == player then
		return AddPlayerChat(player, "You cannot PM yourself.")
	end

	if IsValidPlayer(target) == false then
		return AddPlayerChat(player, "Invalid player id.")
    end

	local text = table.concat({...}, " ")

	AddPlayerChat(player, "<span color=\""..colour.COLOUR_PMOUT().."\">(( PM sent to "..GetPlayerName(target).." (ID: "..target.."): "..text.." ))</>")
	AddPlayerChat(target, "<span color=\""..colour.COLOUR_PMIN().."\">(( PM from "..GetPlayerName(player).." (ID: "..player.."): "..text.." ))</>")
end)

AddCommand('players', function (player)
	for _, v in pairs(GetAllPlayers()) do
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

AddCommand("sit", function (playerid, sitid)

	if sitid == nil then
		return AddPlayerChat(playerid, "Usage: /sit <1-7>")
	end

	sitid = tonumber(sitid)

	if sitid < 1 or sitid > 7 then
		return AddPlayerChat(playerid, "Usage: /sit <1-7>")
	end

	SetPlayerAnimation(playerid, "SIT0"..sitid)
end)

AddCommand("lay", function (playerid, layid)

	if layid == nil then
		return AddPlayerChat(playerid, "Usage: /lay <1-18>")
	end

	layid = tonumber(layid)

	if layid < 1 or layid > 18 then
		return AddPlayerChat(playerid, "Usage: /lay <1-18>")
	end

	if layid < 10 then
		SetPlayerAnimation(playerid, "LAY0"..layid)
	else
		SetPlayerAnimation(playerid, "LAY1"..layid)
	end
end)

AddCommand("wave", function (playerid, waveid)

	if waveid == nil then
		return AddPlayerChat(playerid, "Usage: /wave <1-2>")
	end

	waveid = tonumber(waveid)

	if waveid < 1 or waveid > 2 then
		return AddPlayerChat(playerid, "Usage: /wave <1-2>")
	end

	SetPlayerAnimation(playerid, "WAVE"..waveid)
end)

AddCommand("stretch", function (playerid)

	SetPlayerAnimation(playerid, "STRETCH")
end)

AddCommand("bow", function (playerid)

	SetPlayerAnimation(playerid, "BOW")
end)