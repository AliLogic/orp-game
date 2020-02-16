local colour = ImportPackage('colours')

AddCommand("q", function (playerid)
	return KickPlayer(playerid, "Goodbye!")
end)

AddCommand("levelup", function (playerid)

	local level = PlayerData[playerid].level
	local exp = PlayerData[playerid].exp
	local required_exp = (level * 4) + 2

	if (required_exp > exp) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You do not have enough experience points to level up ("..exp.."/"..required_exp..")</>")
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

AddCommand("help", function (player, section)

	if section == nil then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /help <section>")
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Sections:</> General, Property, Donator.")
	end

	section = string.lower(section)

	if section == "general" then
		AddPlayerChat(player, "General: /me /do /s /l /ame /ado /g /b /pm /ahelp /stats /q /fhelp")
		AddPlayerChat(player, "General: /(inv)entory /r(adio) /r(adio)t(une) /factions /levelup")
		AddPlayerChat(player, "General: /anims /engine /dimension /dice /time /frisk /v")
		AddPlayerChat(player, "General: /whisper /showlicenses")
	elseif section == "property" then
		AddPlayerChat(player, "Property: /h(ouse) /biz /myhousekeys /properties /listcars")
	elseif section == "donator" then
		AddPlayerChat(player, "Donator: /dc")
	end
	return
end)

AddCommand("dc", function (playerid, ...)

	if DonationData[playerid].level == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: You must be a donator to use this command.</>")
	end

	local args = table.concat({...}, " ")

	if #{...} == 0 then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /d <message>")
	end

	AddPlayerChatDonator("[DONATION] " .. GetPlayerName(playerid) .. ": " .. args)
end)

AddCommand("properties", function (playerid)

	AddPlayerChat(playerid, "Properties registered to you, "..GetPlayerName(playerid).." ("..playerid.."):")

	ShowPropertiesList(playerid, playerid)

	return

end)

AddCommand("time", function (playerid)

	local time = os.date ("%A, %d %B %Y")

	AddPlayerChat(playerid, "Today is " .. time .. ".")
	AddPlayerChat(playerid, "" .. PlayerData[playerid].minutes .. " minute(s) left until paycheck.")
end)

AddCommand("dice", function (playerid)

	local x, y, z = GetPlayerLocation(playerid)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(playerid) .. " rolls a dice landing on the number " .. Random(1, 6) .."</>")
end)

local function cmd_vw(playerid)

	AddPlayerChat(playerid, "Your dimension: "..GetPlayerDimension(playerid)..".")
	return
end
AddCommand("vw", cmd_vw)
AddCommand("dimension", cmd_vw)

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

	if OOCStatus == false then
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: The global OOC chat has been disabled.</>")
	end

	if (#{...} == 0) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /g [text]")
	end

	local text = table.concat({...}, " ")

	AddPlayerChatAll("(( [GLOBAL]" .. GetPlayerName(player).." ("..player.."): "..text .. " ))")
end)

AddCommand("whisper", function (playerid, lookupid, ...)

	if lookupid == nil or #{...} == 0 then
		return
	end

	local text = table.concat({...}, " ")

	lookupid = tonumber(lookupid)

	if not IsValidPlayer(lookupid) or not IsPlayerInRangeOfPlayer(playerid, lookupid) then
		return AddPlayerChat(playerid, "That player is disconnected or not near you.");
	end

	if (lookupid == playerid) then
		return AddPlayerChat(playerid, "You can't whisper yourself.")
	end

	AddPlayerChat(lookupid, "<span color=\""..colour.COLOUR_PMOUT().."\">* Whisper from "..GetPlayerName(playerid)..": "..text.."")
	AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_PMOUT().."\">* Whisper to "..GetPlayerName(lookupid)..": "..text.."")

	local x, y, z = GetPlayerLocation(playerid)
	AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(playerid).." mutters something in "..GetPlayerName(lookupid)"'s ear.")

	return
end)

AddCommand("pm", function (player, target, ...)

	if (target == nil or #{...} == 0) then
		return AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /pm [playerid] [text]")
	end

	target = tonumber(target)

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

AddCommand("acceptdeath", function (playerid)

	if PlayerData[playerid].death_state ~= 1 then
		return AddPlayerChat(playerid, "You can't use this command right now.")
	end

	PlayerData[playerid].state = CHARACTER_STATE_DEAD
	AddPlayerChat(playerid, "You are now dead. You need to wait before you can now use /respawnme.")

	ClearCharacterDeath(playerid)
	PlayerData[playerid].death_timer = CreateTimer(function ()
		PlayerData[playerid].death_state = 2
		AddPlayerChat(playerid, "You can now use /respawnme.")
		ClearCharacterDeath(playerid)
	end, 10 * 1000, playerid)
end)

AddCommand("respawnme", function (playerid)

	if PlayerData[playerid].death_state ~= 2 then
		return AddPlayerChat(playerid, "You can't use this command right now.")
	end

	AddPlayerChat(playerid, "You are now being respawned...")

	ClearCharacterDeath(playerid)
	PutPlayerInHospital(playerid)
end)

AddCommand("showlicenses", function (playerid, lookupid)

	if (lookupid == nil) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Usage:</> /showlicenses <playerid>")
	end

	lookupid = tonumber(lookupid)

	if not IsValidPlayer(lookupid) then
		return AddPlayerChat(playerid, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Error: Invalid player ID entered.</>")
	end

	AddPlayerChat(lookupid, "Licenses registered to " .. GetPlayerName(playerid) .. " (ID: " .. playerid .. "):")

	local status = ""
	for i = 1, 6, 1 do
		if GetPlayerLicense(playerid, i) == 0 then
			status = "No"
		else
			status = "Yes"
		end
		AddPlayerChat(lookupid, "".. LicensesNames[i] .." status: ".. status ..".")
	end

	local x, y, z = GetPlayerLocation(playerid)

	if playerid == lookupid then
		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(playerid).." takes out their licenses and checks it.</>")
	else
		AddPlayerChatRange(x, y, 800.0, "<span color=\"#c2a2da\">* "..GetPlayerName(playerid).." takes out their licenses and shows them to "..GetPlayerName(lookupid)..".</>")
	end

	return
end)

-- Events

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