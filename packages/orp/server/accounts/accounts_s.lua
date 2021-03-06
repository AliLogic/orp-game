--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local colour = ImportPackage('colours')
local borkui = ImportPackage('borkui')

PlayerData = {}
CharacterData = {}

CHARACTER_STATE_ALIVE = 1
CHARACTER_STATE_WOUNDED = 2
CHARACTER_STATE_DEAD = 3
CHARACTER_STATE_RECOVER = 4

-- Functions

local function OnAccountLoadId(player)
	if (mariadb_get_row_count() == 0) then
		--There is no account for this player, continue by checking if their IP was banned		
		CheckForIPBan(player)
	else
		--There is an account for this player, continue by checking if it's banned
		PlayerData[player].accountid = mariadb_get_value_name_int(1, "id")

		local query = mariadb_prepare(sql, "SELECT FROM_UNIXTIME(bans.ban_time), bans.reason FROM bans WHERE bans.id = ?;",
			PlayerData[player].accountid)

		mariadb_async_query(sql, query, OnAccountCheckBan, player)
	end
end

function LoadPlayerAccountId(player)
	-- First check if there is an account for this player
	local query = mariadb_prepare(sql, "SELECT id FROM accounts WHERE steamid = '?' LIMIT 1;",
		tostring(GetPlayerSteamId(player))
	)

	mariadb_async_query(sql, query, OnAccountLoadId, player)
end

function OnBanLogLoaded(playerid)
	if mariadb_get_row_count() == 0 then
		return AddPlayerChat(playerid, "No account bans logged")
	end

	local messages = ""

	for i = 1, mariadb_get_row_count() do
		local admin_name = mariadb_get_value_name(i, "admin_name")
		local player_name = mariadb_get_value_name(i, "player_name")
		local time = mariadb_get_value_name(i, "ban_time")
		local reason = mariadb_get_value_name(i, "reason")

		messages = messages.."("..time..") "..admin_name.." banned "..player_name.." for "..reason.."<br>"
	end

	DialogString = messages
	borkui.createUI(playerid, 0, DIALOG_BAN_LOG)
end

function OnAccountCheckBan(player)
	if (mariadb_get_row_count() == 0) then
		--No ban found for this account
		CheckForIPBan(player)
	else
		--There is a ban in the database for this account
		print("Kicking "..GetPlayerName(player).." because their account was banned.")

		KickPlayer(player, "🚨 <span color=\""..colour.COLOR_LIGHTRED()"\">You have been banned from the server. Reason: "..mariadb_get_value_name(1, "reason").."</>")
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
	ShowCharacterSelection(player, false)
	--CallRemoteEvent(player, "askClientCreation")
end

function CreateIPBan(player, ip, admin, expire, reason)

	if expire ~= 0 then
		expire = os.time("!*t") + expire
	end

	local query = mariadb_prepare(sql, "INSERT INTO ipbans VALUES('"..ip.."', "..PlayerData[player].accountid..", "..PlayerData[admin].accountid..", "..expire..", '"..reason.."')")
	mariadb_async_query(sql, query)
end

local function OnAccBanDelete(playerid, account)

	if mariadb_get_affected_rows() == 0 then
		AddPlayerChatError(playerid, "The specified account "..account.." is either not banned or doesn't exist in the database.")
	else
		AddPlayerChat(playerid, "The specified account "..account.." is unbanned.")
	end
end

function DeleteAccBan(playerid, account)

	local query = mariadb_prepare(sql, "DELETE b FROM bans b\
	INNER JOIN accounts a ON a.id = b.id\
	WHERE a.steamname = '"..account.."' LIMIT 1")
	mariadb_async_query(sql, query, OnAccBanDelete, playerid, account)
end

function CreateAccBan(playerid, adminid, expire, reason)

	if expire ~= 0 then
		expire = os.time("!*t") + expire
	end

	local query = mariadb_prepare(sql, "INSERT INTO bans (id, admin_id, ban_time, expire_time) VALUES("..PlayerData[playerid].accountid..", "..PlayerData[adminid].accountid..", UNIX_TIMESTAMP(), "..expire..", '"..reason.."')")
	mariadb_async_query(sql, query)
end

AddRemoteEvent("accounts:characterCreated", function (player, firstname, lastname, gender)
	PlayerData[player].firstname = firstname
	PlayerData[player].lastname = lastname

	if gender == 'Male' then
		PlayerData[player].gender = 0
	elseif gender == 'Female' then
		PlayerData[player].gender = 1
	end

	local query = mariadb_prepare(sql, "INSERT INTO characters (accountid, steamid, firstname, lastname, gender) VALUES (?, '?', '?', '?', ?);",
		PlayerData[player].accountid, tostring(GetPlayerSteamId(player)), PlayerData[player].firstname, PlayerData[player].lastname, PlayerData[player].gender)

	mariadb_query(sql, query, OnCharacterCreated, player)
end)

function OnCharacterCreated(player)
	PlayerData[player].id = mariadb_get_insert_id()

	CreatePlayerClothing(player)

	print("Character ID "..PlayerData[player].id.." created for "..player)

	PlayerData[player].x = 170694.515625
	PlayerData[player].y = 194947.453125
	PlayerData[player].z = 1396.9643554688
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
		PlayerData[player].admin = mariadb_get_value_name_int(1, "admin")
		PlayerData[player].helper = mariadb_get_value_name_int(1, "helper")
		PlayerData[player].ajail = mariadb_get_value_name_int(1, "ajail")

		if PlayerData[player].admin ~= 0 then
			AddPlayerChat(player, "You have logged in successfully as "..GetPlayerAdminRank(player)..".")
		elseif PlayerData[player].helper ~= 0 then
			AddPlayerChat(player, "You have logged in successfully as a Helper.")
		else
			AddPlayerChat(player, "You have logged in successfully.")
		end

		local query = mariadb_prepare(sql, "SELECT id, firstname, lastname, level, cash FROM characters WHERE accountid = ?;",
			PlayerData[player].accountid)

		mariadb_async_query(sql, query, OnCharacterPartLoaded, player)

		query = mariadb_prepare(sql, "SELECT *, unix_timestamp(date) AS time FROM donations WHERE accountid = ?;",
			PlayerData[player].accountid)

		mariadb_async_query(sql, query, OnDonationsLoaded, player)
	end
end

function OnCharacterPartLoaded(player)
	if (mariadb_get_row_count() == 0) then
		--KickPlayer(player, "An error occured while loading your character 😨")
		ShowCharacterSelection(player, false)
		--CallRemoteEvent(player, "askClientCreation")
		print('Remote event called to Client!')
	else
		for i = 1, mariadb_get_row_count(), 1 do

			CreateCharacterData(player, i)

			CharacterData[player][i].id = mariadb_get_value_name_int(i, "id")

			CharacterData[player][i].firstname = mariadb_get_value_name(i, "firstname")
			CharacterData[player][i].lastname = mariadb_get_value_name(i, "lastname")

			CharacterData[player][i].level = mariadb_get_value_name_int(i, "level")
			CharacterData[player][i].cash = mariadb_get_value_name_int(i, "cash")
		end

		ShowCharacterSelection(player, false)
	end
end

function ShowCharacterSelection(player, logout)
	logout = logout or false

	SetPlayerLocation(player, 122191.86, 99569.03, 1676.32)
	CallRemoteEvent(player, 'askClientShowCharSelection', CharacterData[player], logout)
end

AddRemoteEvent("accounts:login", function (player, id)

	if PlayerData[player].id == 0 then
		local query = mariadb_prepare(sql, "SELECT * FROM characters WHERE id = ?;",
			CharacterData[player][id].id)

		mariadb_async_query(sql, query, OnCharacterLoaded, player, id)
	end
end)

function OnCharacterLoaded(player, id)
	if (mariadb_get_row_count() == 0) then
		KickPlayer(player, "An error occured while loading your character 😨")
	else
		local result = mariadb_get_assoc(1)

		PlayerData[player].id = math.tointeger(result['id'])
		PlayerData[player].firstname = result['firstname']
		PlayerData[player].lastname = result['lastname']
		PlayerData[player].gender = math.tointeger(result['gender'])
		PlayerData[player].death_state = math.tointeger(result['death_state'])
		PlayerData[player].char_state = math.tointeger(result['char_state'])

		PlayerData[player].cash = math.tointeger(result['cash'])
		PlayerData[player].bank = math.tointeger(result['bank'])

		PlayerData[player].level = math.tointeger(result['level'])
		PlayerData[player].exp = math.tointeger(result['exp'])
		PlayerData[player].minutes = math.tointeger(result['minutes'])

		PlayerData[player].x = tonumber(result['x'])
		PlayerData[player].y = tonumber(result['y'])
		PlayerData[player].z = tonumber(result['z']) + 100
		PlayerData[player].a = tonumber(result['a'])

		PlayerData[player].radio = tonumber(result['radio'])

		if PlayerData[player].death_state == CHARACTER_STATE_ALIVE then

			SetPlayerHealth(player, tonumber(result['health']))
			SetPlayerArmor(player, tonumber(result['armour']))
		else

			PlayerData[player].death_state = (PlayerData[player].death_state - 1)
			SetPlayerHealth(player, 0)
			SetPlayerArmor(player, 0)
		end

		LoadCharacterFaction(player)
		LoadPlayerClothing(player)
		CallEvent("LoadInventory", player)
		LoadPlayerKeys(player)
		LoadPlayerLicenses(player)

		SetPlayerGender(player)

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_PMOUT().."\" style=\"bold italic\" size=\"15\">Welcome back to Onset Roleplay, "..PlayerData[player].firstname.." "..PlayerData[player].lastname..".</>")

		SetPlayerLoggedIn(player) -- This function deals with the character spawn (teleport)
	end
end

function SetPlayerGender(player)
	local is_male = true

	if (PlayerData[player].gender == 1) then
		is_male = false
	end

	CallRemoteEvent(player, "SetPlayerGenderVoice", is_male)
end

function CreatePlayerData(player)
	PlayerData[player] = {}

	-- Player

	PlayerData[player].accountid = 0

	PlayerData[player].name = GetPlayerName(player)
	PlayerData[player].steamname = GetPlayerName(player)

	PlayerData[player].ajail = 0
	PlayerData[player].steamid = GetPlayerSteamId(player)

	PlayerData[player].admin = 0
	PlayerData[player].helper = 0

	PlayerData[player].is_frozen = false

	-- Character

	PlayerData[player].id = 0

	PlayerData[player].firstname = ""
	PlayerData[player].lastname = ""

	PlayerData[player].gender = 0
	PlayerData[player].death_state = CHARACTER_STATE_ALIVE
	PlayerData[player].char_state = 0

	PlayerData[player].level = 1
	PlayerData[player].exp = 0
	PlayerData[player].minutes = 0

	PlayerData[player].logged_in = false

	PlayerData[player].health = 100.0
	PlayerData[player].armour = 0.0

	PlayerData[player].cash = 100
	PlayerData[player].bank = 1000
	PlayerData[player].paycheck = 0

	PlayerData[player].faction = 0
	PlayerData[player].faction_rank = 0

	PlayerData[player].job = 0
	PlayerData[player].cmd_cooldown = 0.0

	PlayerData[player].x = 0.0
	PlayerData[player].y = 0.0
	PlayerData[player].z = 0.0
	PlayerData[player].a = 0.0

	PlayerData[player].death_x = 0.0
	PlayerData[player].death_y = 0.0
	PlayerData[player].death_z = 0.0
	PlayerData[player].down_state = 0

	PlayerData[player].label = nil -- 3d text label
	PlayerData[player].handcuffed = 0

	PlayerData[player].pd_timer = 0
	PlayerData[player].death_timer = 0

	PlayerData[player].renting = 0 -- Vehicle ID that a player is renting.
	PlayerData[player].driving_test = false
	PlayerData[player].test_vehicle = 0
	PlayerData[player].test_warns = 0
	PlayerData[player].test_stage = 0
	PlayerData[player].assistance = 0
	PlayerData[player].faction_inviter = 0
	PlayerData[player].harvesting = 0
	PlayerData[player].tutorial = 0

	CreatePlayerClothingData(player)

	print("Data created for: " .. player)
end

function CreateCharacterData(player, character)
	if CharacterData[player] == nil then
		CharacterData[player] = {}
	end

	CharacterData[player][character] = {}
	CharacterData[player][character].id = 0

	CharacterData[player][character].firstname = ""
	CharacterData[player][character].lastname = ""

	CharacterData[player][character].level = 0
	CharacterData[player][character].cash = 0
end

function SavePlayerAccount(player)
	if (PlayerData[player] == nil) then
		return
	end

	if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end

	local query = mariadb_prepare(sql, "UPDATE accounts SET steamname = '?', locale = '?' WHERE id = ? LIMIT 1;",
		PlayerData[player].name,
		GetPlayerLocale(player),
		PlayerData[player].accountid
	)
	mariadb_async_query(sql, query)

	if PlayerData[player].id ~= 0 then
		local x, y, z = GetPlayerLocation(player)
		local a = GetPlayerHeading(player)

		query = mariadb_prepare(sql, "UPDATE characters SET gender = '?', health = ?, armour = ?, cash = ?, bank = ?, minutes = ?, x = '?', y = '?', z = '?', a = '?' WHERE id = ?",
			PlayerData[player].gender,
			PlayerData[player].health,
			PlayerData[player].armour,
			PlayerData[player].cash,
			PlayerData[player].bank,
			PlayerData[player].minutes,
			x,
			y,
			(z + 100),
			a,
			PlayerData[player].id
		)

		mariadb_async_query(sql, query)
		CallEvent("SaveInventory", player)
		SavePlayerClothing(player)
	end
end

function DestroyPlayerData(player)
	if (PlayerData[player] == nil) then
		return
	end

	DestroyPlayerClothingData(player)

	DestroyTimer(PlayerData[player].pd_timer)
	DestroyTimer(PlayerData[player].death_timer)

	PlayerData[player] = nil
	CharacterData[player] = nil
	InventoryData[player] = nil

	print("Data destroyed for: "..player)
end

function SetPlayerTutorial(playerid)

	-- Validation checks

	if (not IsValidPlayer(playerid)) then
		return
	end

	if (PlayerData[playerid].tutorial == 0) then
		return
	end

	-- Initialization

	local tutorial_state = PlayerData[playerid].tutorial

	-- Actual function

	if (tutorial_state == 1) then
		CallRemoteEvent(playerid, "SetPlayerCameraLocation", 122371.22, 99170.25, 1668.49, 265, true)
		AddPlayerChat(playerid, "Welcome to Onset Roleplay! Here, we strive to provide you with the best experience possible.")
		AddPlayerChat(playerid, "We can see that it is your first time on the server! To proceed to the tutorial press [ENTER] to continue, otherwise, press [BUTTON] to skip!")
		AddPlayerChat(playerid, "<span style=\"bold\">Please note: We highly recommend you view the tutorial, as it will prepare you for the journey ahead.</>")
	elseif (tutorial_state == 2) then
		CallRemoteEvent(playerid, "SetPlayerCameraLocation", 163143.81, 188802.39, 1329.94, 126, true)
		AddPlayerChat(playerid, "Around the city of [PLACE NAME] you will find various dealerships, here, you can purchase a nice set of wheels to get around.")
		AddPlayerChat(playerid, "Once you have acquired a sufficient amount of money, come on down to any of the dealership icons you see on your mini-map and step into the [ICON?],")
		AddPlayerChat(playerid, "here you will be presented with all of the information required to make your purchase.")
	elseif (tutorial_state == 3) then
		CallRemoteEvent(playerid, "SetPlayerCameraLocation", 195960.25, 178873.54, 1327.15, -127.76, true)
		AddPlayerChat(playerid, "Want your own place to sit and relax? Or perhaps a business to start earning some money whilst giving back to the community?")
		AddPlayerChat(playerid, "Side note: You can also use our advertisement system (/ad) and deal with property owners directly.")
		AddPlayerChat(playerid, "Come on down to the lettings building located on your mini-map, here you will see all of the properties around [PLACE NAME] that are currently for sale!")
	elseif (tutorial_state == 4) then
		CallRemoteEvent(playerid, "SetPlayerCameraLocation", 195883.375, 209910.359375, 1328.90, -106, true)
		AddPlayerChat(playerid, "This is the [DMV NAME], located in [AREA], this building is represented by the [ICON] on the mini-map!")
		AddPlayerChat(playerid, "If you want to remain on the correct side of the law, you'll want to obtain a license to operate your vehicle!")
		AddPlayerChat(playerid, "For a small fee of [$FEE], you can take the practical and theory test, if you pass successfully, you will then be eligible to drive on the road legally.")
		AddPlayerChat(playerid, "<span style=\"bold\">Side note: A license is not mandatory, however you may find yourself in trouble with law enforcement for driving without one!</>")
	elseif (tutorial_state == 5) then
		CallRemoteEvent(playerid, "SetPlayerCameraLocation", 212473.65, 187311.0, 1326.94, 58.43, true)
		AddPlayerChat(playerid, "Upon first stepping into the world, you will begin with a [ITEM] which contains [X] spaces. This can be viewed by pressing the [KEY] key. Your inventory is important, it allows you to interact with the world around you.")
		AddPlayerChat(playerid, "If you wish to increase your inventory spaces, you will need to purchase additional carrier items such as a backpack, or a brief-case, which can be purchased from various stores around the city!")
		AddPlayerChat(playerid, "<span style=\"bold\">Side note: All items shown in your inventory are an accurate representation of what your character is holding, that means that you MUST roleplay appropriately.</>")
	elseif (tutorial_state == 6) then
		CallRemoteEvent(playerid, "SetPlayerCameraLocation", 212473.65, 187311.0, 1326.94, 58.43, true)
		AddPlayerChat(playerid, "Struggling to make income whilst unemployed, not looking to oppose the law to make a pretty penny? Understandable! Come on down to the job centre, located on your mini-map by the [ICON].")
		AddPlayerChat(playerid, "Here, you can find a side-job which will provide you with a generous income to begin building your life.")
		AddPlayerChat(playerid, "Here, you can find employment in the following areas:")
		AddPlayerChat(playerid, "- Delivery Driving")
		AddPlayerChat(playerid, "- Trucking")
		AddPlayerChat(playerid, "- Taxi Cab")
		AddPlayerChat(playerid, "- Fishing")
		AddPlayerChat(playerid, "- Mechanic")
		AddPlayerChat(playerid, "<span style=\"bold\">Side note: When using a side-job, it is expected that you roleplay appropriately whilst conducting these jobs, this is a roleplay server after all.</>")
	elseif (tutorial_state == 7) then
		CallRemoteEvent(playerid, "SetPlayerCameraLocation", 122371.22, 99170.25, 1668.49, 265, true)
		AddPlayerChat(playerid, "You have completed the tutorial.  Thanks for choosing Onset Roleplay...")
		PlayerData[playerid].char_state = 1 -- Tutorial completed
		SetPlayerIntro(playerid)
		return
	end

	Delay(20 * 1000, function (playerid)
		PlayerData[playerid].tutorial = (tutorial_state + 1)
		SetPlayerTutorial(playerid)
	end, playerid)
end

function SetPlayerIntro(player)

	local query = mariadb_prepare(sql, "UPDATE characters SET char_state = ? WHERE id = ? LIMIT 1;",
		PlayerData[player].char_state,
		PlayerData[player].id
	)
	mariadb_async_query(sql, query)

	if (PlayerData[player].char_state == 0) then

		PlayerData[player].tutorial = 1
		SetPlayerTutorial(player)

	elseif (PlayerData[player].char_state == 1) then

		CallRemoteEvent(player, "SetPlayerCameraLocation", 0, 0, 0, 0, false)
		AddPlayerChat(player, "Hey you are proceeding towards the character creation panel...")
		AddPlayerChat(player, "This is just a sample hint message to provide you basic information.")

		Customization_Toggle(player, true)

	elseif (PlayerData[player].char_state == 2) then

		AddPlayerChat(player, "Oh! That's awesome character of yours. We are spawning you in a few seconds.")

		PlayerData[player].char_state = 3 -- Skipping the tutorial code for now

		Delay(10 * 1000, function (player)
			SetPlayerIntro(player)
		end, player)

	elseif (PlayerData[player].char_state == 3) then

		PlayerData[player].char_state = 3 -- Character and tutorial has been completed

		PlayerData[player].x = LOC_DEFAULT_X
		PlayerData[player].y = LOC_DEFAULT_Y
		PlayerData[player].z = LOC_DEFAULT_Z
		PlayerData[player].a = LOC_DEFAULT_A

		SetPlayerLoggedIn(player)
	end

	return
end

function SetPlayerLoggedIn(player)
	PlayerData[player].logged_in = true

	SetPlayerName(player, PlayerData[player].firstname.." "..PlayerData[player].lastname)

	if (PlayerData[player].char_state ~= 3) then
		SetPlayerIntro(player)
		return
	end

	SetGUIHealth(player, PlayerData[player].health)
	SetGUIArmour(player, PlayerData[player].armour)

	SetGUICash(player, PlayerData[player].cash)
	SetGUIBank(player, PlayerData[player].bank)

	FreezePlayer(player, true)
	Delay(5 * 1000, function ()
		FreezePlayer(player, false)
	end)

	SetPlayerLocation(player, PlayerData[player].x, PlayerData[player].y, (PlayerData[player].z + 100))
	SetPlayerHeading(player, PlayerData[player].a)
	SetPlayerDimension(player, 0)

	PlayerData[player].pd_timer = CreateTimer(OnPlayerPayday, 60 * 1000, player)

	Delay(1000, function ()
		SetPlayerClothing(player, player)
	end)
end

function OnPlayerPayday(player)

	if (PlayerData[player].ajail > 0) then

		PlayerData[player].ajail = (PlayerData[player].ajail - 1)

		if (PlayerData[player].ajail == 0) then
			AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Your admin jail has now finished.</>")
		end
	end

	PlayerData[player].minutes = (PlayerData[player].minutes + 1)

	if (PlayerData[player].minutes >= 60) then

		AddPlayerChat(player, "<span color=\""..colour.COLOUR_DARKGREEN().."\">|________ PAYCHECK ________|</>")

		local paycheck = PlayerData[player].paycheck

		AddPlayerChat(player, "Paycheck: $"..paycheck)

		local factionid = PlayerData[player].faction

		if factionid ~= 0 then

			local factionrank = PlayerData[player].faction_rank
			local factionpay = FactionRankData[factionid][factionrank].rank_pay

			AddPlayerChat(player, "Faction pay: $"..factionpay)

			paycheck = paycheck + factionpay
		end

		if PlayerData[player].job ~= 0 then
		else
			AddPlayerChat(player, "Unemployment benefit: $100")

			paycheck = paycheck + 100
		end

		AddPlayerChat(player, "Final Paycheck: $"..paycheck)
		AddPlayerChat(player, "(( Paychecks are still a work in progress. ))")

		AddPlayerBankCash(player, paycheck)

		PlayerData[player].minutes = 0
		PlayerData[player].paycheck = 0

		if Server_IsDoubleXP() == 1 then
			PlayerData[player].exp = (PlayerData[player].exp + 2)
			AddPlayerChat(player, "You got double experience points for this hour.")
		else
			PlayerData[player].exp = (PlayerData[player].exp + 1)
		end

		local exp = PlayerData[player].exp
		local level = PlayerData[player].level
		local required_exp = (level * 4) + 2

		if (required_exp <= exp) then
			AddPlayerChat(player, "You now have enough experience points to level up ("..exp.."/"..required_exp..")")
		end

		local query = mariadb_prepare(sql, "UPDATE characters SET exp = ? WHERE id = ? LIMIT 1",
			PlayerData[player].exp,
			PlayerData[player].id
		)
		mariadb_async_query(sql, query)

		AddPlayerChat(player, "|________________________|")
	end

	return
end

AddRemoteEvent('accounts:kick', function (player)
	KickPlayer(player, "You decided to quit the server!")
end)

AddCommand("logout", function (player)
	SavePlayerAccount(player)
	AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You will be logged out in 5 seconds.")
	SetPlayerChatBubble(player, "(( Player is logging out. ))", 4)

	PlayerData[player].logged_in = false

	Delay(5000, function ()
		AddPlayerChat(player, "<span color=\""..colour.COLOUR_LIGHTRED().."\">Server:</> You are now being logged out.")
		SendAdminMessage("<span color=\""..colour.COLOUR_LIGHTRED().."\">AdmCmd: "..PlayerData[player].name.." is logging out.</>")
		ShowCharacterSelection(player, true)
	end)
end)

function DestroyDrivingTest(playerid)
	PlayerData[playerid].driving_test = false
	PlayerData[playerid].test_vehicle = 0
	PlayerData[playerid].test_warns = 0
	PlayerData[playerid].test_stage = 0
end

function CancelDrivingTest(playerid)
	if PlayerData[playerid].driving_test == true then
		DestroyVehicle(PlayerData[playerid].test_vehicle)
		DestroyVehicleData(PlayerData[playerid].test_vehicle)
		DestroyDrivingTest(playerid)
	end
end

function PutPlayerInAdminJail(playerid)
	SetPlayerLocation(playerid, 0.0, 0.0, 0.0)
	FreezePlayer(playerid, true)
end

function SetPlayerJob(playerid, job)

	if (PlayerData[playerid] ~= nil) then
		PlayerData[playerid].job = job

		local query = mariadb_prepare(sql, "UPDATE characters SET job = ? WHERE id = ?",
			job, PlayerData[playerid].id
		)
		mariadb_async_query(sql, query)
	end
end

function GetPlayerJob(playerid)
	if (PlayerData[playerid] ~= nil) then

		return PlayerData[playerid].job
	end

	return 0
end

function ClearCharacterDeath(playerid)

	DestroyTimer(PlayerData[playerid].death_timer)
	PlayerData[playerid].death_timer = 0
end

local function OnPlayerRecover(player)

	PlayerData[player].death_state = CHARACTER_STATE_ALIVE
	AddPlayerChat(player, "You have now recovered...")

	ClearCharacterDeath(player)

	SetPlayerLocation(player, LOC_RESPAWN_X, LOC_RESPAWN_Y, LOC_RESPAWN_Z)
	SetPlayerHeading(player, 81.82)

	FreezePlayer(player, false)
end

function PutPlayerInHospital(player)
	PlayerData[player].death_state = CHARACTER_STATE_RECOVER
	PlayerData[player].down_state = 0

	AddPlayerChat(player, "You are now being recovered at a nearby hospital...")

	FreezePlayer(player, true)
	SetPlayerLocation(player, 216010, 158517, 3004)
	SetPlayerHeading(player, -90)
	Delay(100, function ()
		SetPlayerAnimation(player, "LAY_3")
	end)

	ClearCharacterDeath(player)
	PlayerData[player].death_timer = CreateTimer(OnPlayerRecover, 10 * 1000, player)

	--Camera: 215498, 158293, 2954
end

function Player_GetFactionRank(playerid)
	if PlayerData[playerid] == nil then
		return 0
	end

	return PlayerData[playerid].faction_rank
end

function Player_GetFactionId(playerid)

	if PlayerData[playerid] == nil then
		return 0
	end

	return PlayerData[playerid].faction
end

function UpdatePlayerDeathLocation(player)

	PlayerData[player].death_x, PlayerData[player].death_y, PlayerData[player].death_z = GetPlayerLocation(player)
end

-- Events

AddEvent("OnPlayerSpawn", function(player)

	if (PlayerData[player] == nil) then
		return
	end

	if (PlayerData[player].accountid == 0 or PlayerData[player].logged_in == false) then
		return
	end

	if PlayerData[player].death_state == CHARACTER_STATE_ALIVE then

		-- Nothing

	elseif PlayerData[player].death_state == CHARACTER_STATE_WOUNDED then

		SetPlayerLocation(player, PlayerData[player].death_x, PlayerData[player].death_y, PlayerData[player].death_z)

		AddPlayerChat(player, "You are now wounded... You can use /acceptdeath.")
		FreezePlayer(player, true)
		PlayerData[player].down_state = 1
		Delay(1000, function ()
			SetPlayerAnimation(player, "LAY_3")
		end)

	elseif PlayerData[player].death_state == CHARACTER_STATE_DEAD then

		SetPlayerLocation(player, PlayerData[player].death_x, PlayerData[player].death_y, PlayerData[player].death_z)

		AddPlayerChat(player, "You are now dead... You can now use /respawnme.")
		FreezePlayer(player, true)
		PlayerData[player].down_state = 2
		Delay(1000, function ()
			SetPlayerAnimation(player, "LAY_3")
		end)

	else

		-- If the player is either dead or in recovering state

		PutPlayerInHospital(player)
	end
end)

AddEvent("OnPlayerDeath", function (player, instigator)

	UpdatePlayerDeathLocation(player)

	if PlayerData[player].death_state == CHARACTER_STATE_ALIVE then

		PlayerData[player].death_state = CHARACTER_STATE_WOUNDED

	elseif PlayerData[player].death_state == CHARACTER_STATE_WOUNDED then

		PlayerData[player].death_state = CHARACTER_STATE_DEAD

	else

		PlayerData[player].down_state = 0
		PutPlayerInHospital(player)
	end
end)
AddEvent("OnPackageStart", function ()
	CreateTimer(function()
		local count = false
		for _, v in pairs(GetAllPlayers()) do
			SavePlayerAccount(v)
			count = true
		end
		if count == true then
			print("All accounts have been saved!")
		end
	end, 1800000)

	CreateText3D("Hospital Respawn Point\nDo not AFK", 12, LOC_RESPAWN_X, LOC_RESPAWN_Y, LOC_RESPAWN_Z, 0.0, 0.0, 0.0)
	CreateText3D("Department of Motor Vehicles\n/drivingtest", 12, LOC_DRIVINGTEST_X, LOC_DRIVINGTEST_Y, LOC_DRIVINGTEST_Z, 0.0, 0.0, 0.0)
	CreateText3D("Pay your tickets here\n/tickets", 12, LOC_TICKETS_X, LOC_TICKETS_Y, LOC_TICKETS_Z, 0.0, 0.0, 0.0)
end)

AddEvent("OnPlayerSteamAuth", function (player)

	CreatePlayerData(player)
end)

AddEvent("OnPlayerQuit", function (player)

	for _, v in pairs(GetAllPlayers()) do
		if PlayerData[v].faction_inviter == player then
			PlayerData[v].faction_inviter = 0
			AddPlayerChat(player, "Your faction invitation was discarded.  Your inviter disconnected.")
		end
	end

	CallEvent("UnrentPlayerVehicle", player)
	DestroyDrivingTest(player)
	SavePlayerAccount(player)

	Delay(1000, function (player)
		DestroyPlayerData(player)
	end, player)
end)

AddRemoteEvent("borkui:clientOnUICreated", function (playerid, dialogid, extraid)

	if extraid == DIALOG_BAN_LOG then

		borkui.addUITitle(playerid, dialogid, "Recent Bans")
		borkui.addUIDivider(playerid, dialogid)
		borkui.addUIInformation(playerid, dialogid, DialogString)
		borkui.addUIDivider(playerid, dialogid)
		borkui.addUIButton(playerid, dialogid, 'Okay', 'is-danger')
		borkui.showUI(playerid, dialogid)

	end

end)

AddRemoteEvent("borkui:clientOnDialogSubmit", function (playerid, dialogid, extraid, button, text, switch)

	if extraid == DIALOG_BAN_LOG then

		borkui.hideUI(playerid)
		borkui.destroyUI(playerid, dialogid)

	end

end)

AddRemoteEvent("OnPlayerGameDevMode", function (playerid)

	local dev = false

	if PlayerData[playerid] ~= nil then
		if PlayerData[playerid].admin >= 5 then
			dev = true
		end
	end

	if dev == false then
		KickPlayer(playerid, "Disable game dev mode")
	end
end)