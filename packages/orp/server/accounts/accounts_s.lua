local colour = ImportPackage('colours')

PlayerData = {}
CharacterData = {}

AddEvent("OnPackageStart", function ()
	CreateTimer(function()
		for k, v in pairs(GetAllPlayers()) do
            SavePlayerAccount(v)
            print("All accounts have been saved!")
		end
    end, 1800000)
end)

function OnPlayerSteamAuth(player)
	CreatePlayerData(player)
	FreezePlayer(player)
        
    -- First check if there is an account for this player
	local query = mariadb_prepare(sql, "SELECT id FROM accounts WHERE steamid = '?' LIMIT 1;",
    tostring(GetPlayerSteamId(player)))

    mariadb_async_query(sql, query, OnAccountLoadId, player)
end
AddEvent("OnPlayerSteamAuth", OnPlayerSteamAuth)

function OnPlayerQuit(player)
    SavePlayerAccount(player)
    DestroyPlayerData(player)
end
AddEvent("OnPlayerQuit", OnPlayerQuit)

function OnAccountLoadId(player)
	if (mariadb_get_row_count() == 0) then
		--There is no account for this player, continue by checking if their IP was banned		
        CheckForIPBan(player)
	else
		--There is an account for this player, continue by checking if it's banned
        PlayerData[player].accountid = mariadb_get_value_index(1, 1)

		local query = mariadb_prepare(sql, "SELECT FROM_UNIXTIME(bans.ban_time), bans.reason FROM bans WHERE bans.id = ?;",
			PlayerData[player].accountid)

		mariadb_async_query(sql, query, OnAccountCheckBan, player)
	end
end

function OnAccountCheckBan(player)
	if (mariadb_get_row_count() == 0) then
		--No ban found for this account
		CheckForIPBan(player)
	else
		--There is a ban in the database for this account
		local result = mariadb_get_assoc(1)

		print("Kicking "..GetPlayerName(player).." because their account was banned")

		KickPlayer(player, "🚨 <span color=\""..colour.COLOR_LIGHTRED()"\">You have been banned from the server. Reason: "..result['reason'].."</>")
	end
end

function CheckForIPBan(player)
	local query = mariadb_prepare(sql, "SELECT ipbans.reason FROM ipbans WHERE ipbans.ip = '?' LIMIT 1;",
		GetPlayerIP(player))

	mariadb_async_query(sql, query, OnAccountCheckIpBan, player)
end

function OnAccountCheckIpBan(player)
	if (mariadb_get_row_count() == 0) then
		--No IP ban found for this account
		if (PlayerData[player].accountid == 0) then
			CreatePlayerAccount(player) -- 
		else
			LoadPlayerAccount(player)
		end
	else
		print("Kicking "..GetPlayerName(player).." because their IP was banned")

		local result = mariadb_get_assoc(1)
        
        KickPlayer(player, "🚨 <span color=\""..colour.COLOR_LIGHTRED()"\">You have been banned from the server.</>")
	end
end

function CreatePlayerAccount(player)
	local query = mariadb_prepare(sql, "INSERT INTO accounts (steamid, registration_ip) VALUES ('?', '?');",
		tostring(GetPlayerSteamId(player)), tostring(GetPlayerIP(player)))

	mariadb_async_query(sql, query, OnAccountCreated, player)
end

function OnAccountCreated(player)
	PlayerData[player].accountid = mariadb_get_insert_id()
	ShowCharacterSelection(player)
	--CallRemoteEvent(player, "askClientCreation")
end

AddRemoteEvent("accounts:characterCreated", function (player, firstname, lastname, gender)
	PlayerData[player].firstname = firstname
	PlayerData[player].lastname = lastname

	if gender == 'Male' then
		PlayerData[player].gender = 0
	elseif gender == 'Female' then
		PlayerData[player].gender = 1
	end

	SetPlayerName(player, firstname.." "..lastname)
	
	local query = mariadb_prepare(sql, "INSERT INTO characters (accountid, steamid, firstname, lastname, gender) VALUES (?, '?', '?', '?', ?);",
		PlayerData[player].accountid, tostring(GetPlayerSteamId(player)), PlayerData[player].firstname, PlayerData[player].lastname, PlayerData[player].gender)

	mariadb_query(sql, query, characterCreated, player)
end)

function characterCreated(player)
	PlayerData[player].id = mariadb_get_insert_id()
	
	print("Character ID "..PlayerData[player].id.." created for "..player)

        PlayerData[player].x = 125773.0
        PlayerData[player].y = 80246.0
        PlayerData[player].z = 1645.0
        PlayerData[player].a = 90.0

	SetPlayerLoggedIn(player)

	AddPlayerChat(player, "<span color=\""..colour.COLOUR_PMOUT().."\" style=\"bold italic\" size=\"15\">Welcome to Onset Roleplay, "..PlayerData[player].name..".</>")
end

function LoadPlayerAccount(player)
	local query = mariadb_prepare(sql, "SELECT * FROM accounts WHERE id = ?;",
		PlayerData[player].accountid)

	mariadb_async_query(sql, query, OnAccountLoaded, player)
end

function OnAccountLoaded(player)
	if (mariadb_get_row_count() == 0) then
		--This case should not happen but still handle it
		KickPlayer(player, "An error occured while loading your account 😨")
	else
		local result = mariadb_get_assoc(1)

		PlayerData[player].admin = math.tointeger(result['admin'])
		PlayerData[player].helper = math.tointeger(result['helper'])
		--PlayerData[player].cash = math.tointeger(result['cash'])
		--PlayerData[player].bank_balance = math.tointeger(result['bank_balance'])
		--PlayerData[player].name = tostring(result['name'])
		--PlayerData[player].clothing = json_decode(result['clothing'])
		--PlayerData[player].inventory = json_decode(result['inventory'])
		--PlayerData[player].created = math.tointeger(result['created'])

		--SetPlayerHealth(player, tonumber(result['health']))
		--SetPlayerArmor(player, tonumber(result['armor']))
        --setPlayerThirst(player, tonumber(result['thirst']))
        --setPlayerHunger(player, tonumber(result['hunger']))

		local query = mariadb_prepare(sql, "SELECT * FROM characters WHERE accountid = ?;",
			PlayerData[player].accountid)

		mariadb_async_query(sql, query, OnCharacterPartLoaded, player)
	end
end

function OnCharacterPartLoaded(player)
	if (mariadb_get_row_count() == 0) then
		--KickPlayer(player, "An error occured while loading your character 😨")
		ShowCharacterSelection(player)
		--CallRemoteEvent(player, "askClientCreation")
		print('Remote event called to Client!')
	else
		for i = 1, mariadb_get_row_count(), 1 do
			local result = mariadb_get_assoc(i)

			CreateCharacterData(player, i)

			CharacterData[player][i].id = math.tointeger(result['id'])
			CharacterData[player][i].firstname = result['firstname']
			CharacterData[player][i].lastname = result['lastname']
		end

		ShowCharacterSelection(player)

		--[[local result = mariadb_get_assoc(1)

		PlayerData[player].id = math.tointeger(result['id'])
		PlayerData[player].firstname = result['firstname']

		PlayerData[player].lastname = result['lastname']
		PlayerData[player].gender = math.tointeger(result['gender'])

		PlayerData[player].cash = math.tointeger(result['cash'])
		PlayerData[player].bank = math.tointeger(result['bank'])

		SetPlayerHealth(player, tonumber(result['health']))
		SetPlayerArmor(player, tonumber(result['armour']))
		
		SetPlayerLoggedIn(player)
		
		AddPlayerChat(player, '<span color=\""..colour.COLOUR_PMOUT().."\" style="bold italic" size="15">Welcome back to Onset Roleplay '..GetPlayerName(player)..'.</>')
		SetPlayerName(player, PlayerData[player].firstname.." "..PlayerData[player].lastname)]]--
	end
end

function ShowCharacterSelection (player)
	CallRemoteEvent(player, 'askClientShowCharSelection', CharacterData[player])
end

AddRemoteEvent("accounts:login", function (player, id)
	local query = mariadb_prepare(sql, "SELECT * FROM characters WHERE id = ?;",
		CharacterData[player][id].id)

	mariadb_async_query(sql, query, OnCharacterLoaded, player, id)
end)

function OnCharacterLoaded(player, id)
	if (mariadb_get_row_count() == 0) then
		KickPlayer(player, "An error occured while loading your character 😨")
		--CallRemoteEvent(player, "askClientCreation")
		--print('Remote event called to Client!')
	else
		local result = mariadb_get_assoc(1)

		PlayerData[player].id = math.tointeger(result['id'])
		PlayerData[player].firstname = result['firstname']

		PlayerData[player].lastname = result['lastname']
		PlayerData[player].gender = math.tointeger(result['gender'])

		PlayerData[player].cash = math.tointeger(result['cash'])
		PlayerData[player].bank = math.tointeger(result['bank'])

		PlayerData[player].x = tonumber(result['x'])
		PlayerData[player].y = tonumber(result['y'])
		PlayerData[player].z = tonumber(result['z'])
		PlayerData[player].a = tonumber(result['a'])

		SetPlayerHealth(player, tonumber(result['health']))
		SetPlayerArmor(player, tonumber(result['armour']))
		
		SetPlayerLoggedIn(player)
		
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_PMOUT().."\" style=\"bold italic\" size=\"15\">Welcome back to Onset Roleplay "..GetPlayerName(player)..".</>")
		SetPlayerName(player, PlayerData[player].firstname.." "..PlayerData[player].lastname)
	end
end

function CreatePlayerData(player)
	PlayerData[player] = {}

	PlayerData[player].id = 0
	PlayerData[player].accountid = 0

	PlayerData[player].name = GetPlayerName(player)
	PlayerData[player].steamname = GetPlayerName(player)

	PlayerData[player].firstname = ""
	PlayerData[player].lastname = ""
	PlayerData[player].gender = 0

	PlayerData[player].clothing = {}
	PlayerData[player].inventory = {}

	PlayerData[player].logged_in = false
	
    PlayerData[player].admin = 0
	PlayerData[player].helper = 0
	
	PlayerData[player].health = 100.0
	PlayerData[player].armour = 0.0

	PlayerData[player].cash = 100
	PlayerData[player].bank = 1000

    PlayerData[player].steamid = GetPlayerSteamId(player)
	PlayerData[player].job_vehicle = nil

	PlayerData[player].job = ""
	PlayerData[player].onAction = false
	PlayerData[player].cmd_cooldown = 0.0

	PlayerData[player].x = 0.0
	PlayerData[player].y = 0.0
	PlayerData[player].z = 0.0
	PlayerData[player].a = 0.0

	PlayerData[player].is_frozen = false
	PlayerData[player].label = nil -- 3d text label

    print("Data created for: "..player)
end

function CreateCharacterData(player, character)
	if CharacterData[player] == nil then
		CharacterData[player] = {}
	end

	CharacterData[player][character] = {}
	CharacterData[player][character].id = 0

	CharacterData[player][character].firstname = ""
	CharacterData[player][character].lastname = ""
end

function SavePlayerAccount(player)
	if (PlayerData[player] == nil) then
		return
	end

	if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end

	--[[local query = mariadb_prepare(sql, "UPDATE accounts SET admin = ?, cash = ?, bank_balance = ?, health = ?, armor = ?, hunger = ?, thirst = ?, name = '?', clothing = '?', inventory = '?', created = '?' WHERE id = ? LIMIT 1;",
		PlayerData[player].admin,
		PlayerData[player].cash,
		PlayerData[player].bank_balance,
		GetPlayerHealth(player),
        GetPlayerArmor(player),
        PlayerData[player].hunger,
		PlayerData[player].thirst,
		PlayerData[player].name,
		json_encode(PlayerData[player].clothing),
		json_encode(PlayerData[player].inventory),
		PlayerData[player].created,
		PlayerData[player].accountid
		)]]--

	local query = mariadb_prepare(sql, "UPDATE accounts SET steamname = '?', admin = ?, helper = '?', locale = '?' WHERE id = ? LIMIT 1;",
		PlayerData[player].steamname,
		PlayerData[player].admin,
		PlayerData[player].helper,
		GetPlayerLocale(player),
		PlayerData[player].id
		)
        
	mariadb_query(sql, query)

	PlayerData[player].x, PlayerData[player].y, PlayerData[player].z = GetPlayerLocation(player)
	PlayerData[player].a = GetPlayerHeading(player)
	
	local query = mariadb_prepare(sql, "UPDATE characters SET firstname = '?', lastname = '?', gender = '?', health = ?, armour = ?, cash = ?, bank = ?, x = '?', y = '?', z = '?', a = '?' WHERE id = ?",
		PlayerData[player].firstname,
		PlayerData[player].lastname,
		PlayerData[player].gender,
		PlayerData[player].health,
		PlayerData[player].armour,
		PlayerData[player].cash,
		PlayerData[player].bank,
		tostring(PlayerData[player].x),
		tostring(PlayerData[player].y),
		tostring(PlayerData[player].z),
		tostring(PlayerData[player].a),
		PlayerData[player].id
		)

	print(PlayerData[player].id)

	mariadb_query(sql, query)
end

function DestroyPlayerData(player)
	if (PlayerData[player] == nil) then
		return
    end

	PlayerData[player] = nil
	CharacterData[player] = nil
	print("Data destroyed for: "..player)
end

function SetPlayerLoggedIn(player)
	PlayerData[player].logged_in = true
	SetPlayerLocation(player, PlayerData[player].x, PlayerData[player].y, PlayerData[player].z)
	SetPlayerHeading(player, PlayerData[player].a)
    SetPlayerDimension(player, 0)
	--SetPlayerSpawnLocation(player, 125773.000000, 80246.000000, 1645.000000, 90.0)
    --CallEvent("OnPlayerJoined", player)
end

function FreezePlayer(player) return CallRemoteEvent(player, 'FreezePlayer', player) end

AddRemoteEvent('accounts:kick', function (player)
	KickPlayer(player, "You decided to quit the server!")
end)
