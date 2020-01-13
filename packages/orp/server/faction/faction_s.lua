local colour = ImportPackage('colours')

FactionData = {}
FactionRankData = {}

DivisionData = {}
DivisionRankData = {}

FACTION_NONE = 0
FACTION_CIVILIAN = 1
FACTION_POLICE = 2
FACTION_MEDIC = 3
FACTION_GOV = 4

function CreateFactionData(factionid)
	FactionData[factionid] = {}

	FactionData[factionid].id = 0

	FactionData[factionid].name = ""
	FactionData[factionid].short_name = ""
	FactionData[factionid].type = 0
	FactionData[factionid].motd = "Default MOTD"

	FactionData[factionid].leadership_rank = 0
	FactionData[factionid].radio_dimension = 0
	FactionData[factionid].bank = 0

	FactionRankData[factionid] = {}
end

function DestroyFactionData(factionid)
	FactionData[factionid] = nil
	FactionRankData[factionid] = nil
end

function Faction_Create(name, short_name, leadership_rank, fac_type)
	leadership_rank = leadership_rank or 10

	local faction = 1

	while FactionData[faction] ~= nil do
		faction = faction + 1
	end

	if fac_type == nil then
		fac_type = FACTION_CIVILIAN
	end

	CreateFactionData(faction)

	local query = mariadb_prepare(sql, "INSERT INTO factions (name, short_name, leadership_rank, type) VALUES('?', '?', '?', '?')",
		name,
		short_name,
		leadership_rank,
		fac_type
	)

	mariadb_async_query(sql, query, OnFactionCreated, faction, name, short_name, leadership_rank, fac_type)
	return faction
end

function OnFactionCreated(faction, name, short_name, leadership_rank, fac_type)
	FactionData[faction].id = mariadb_get_insert_id()
	FactionData[faction].name = name
	FactionData[faction].short_name = short_name
	FactionData[faction].leadership_rank = leadership_rank
	FactionData[faction].type = fac_type
end

function Faction_Destroy(factionid)
	if FactionData[factionid] == nil then
		return false
	end

	local query = mariadb_prepare(sql, "DELETE FROM factions WHERE id = ?", FactionData[factionid].id)
	mariadb_async_query(sql, query)

	query = mariadb_prepare(sql, "DELETE FROM faction_members WHERE faction_id = '?'", FactionData[factionid].id)
	mariadb_async_query(sql, query)

	for k, v in pairs(GetAllPlayers()) do

		if PlayerData[v].faction == factionid then
			PlayerData[v].faction = 0
			PlayerData[v].faction_rank = 0


			AddPlayerChat(v, "You have been kicked out of your faction because it's deleted.")
		end
	end

	DestroyFactionData(factionid)

	return true
end

function Faction_Load(factionid)
    local query = mariadb_prepare(sql, "SELECT * FROM factions WHERE id = ?", factionid)
    mariadb_async_query(sql, query, OnFactionLoaded, factionid)
end

function OnFactionLoaded(factionid)
	if mariadb_get_row_count() == 0 then
		print('Error with loading faction ID'..factionid)
	else
		CreateFactionData(factionid)

		FactionData[factionid].id = mariadb_get_value_name_int('id')
		FactionData[factionid].name = mariadb_get_value_name('name')
		FactionData[factionid].short_name = mariadb_get_value_name('short_name')
		FactionData[factionid].motd = mariadb_get_value_name('motd')
		FactionData[factionid].type = mariadb_get_value_name_int('type')

		FactionData[factionid].leadership_rank = mariadb_get_value_name_int('leadership_rank')
		FactionData[factionid].radio_dimension = mariadb_get_value_name_int('radio_dimension')
		FactionData[factionid].bank = mariadb_get_value_name_int('bank')

		local query = mariadb_prepare(sql, "SELECT * FROM faction_ranks WHERE id = ?",
			FactionData[factionid].id)

		mariadb_async_query(sql, query, OnFactionRankLoaded, FactionData[factionid].id)
	end
end

function OnFactionRankLoaded(factionid)
	local row_count = mariadb_get_row_count()

	if row_count then
		for i = 1, row_count do
			local rank_id = mariadb_get_value_name_int(i, "rank_id")

			FactionRankData[factionid] = {}
			FactionRankData[factionid][rank_id] = {}

			FactionRankData[factionid][rank_id].rank_name = mariadb_get_value_name(i, "rank_name")
			FactionRankData[factionid][rank_id].rank_pay = mariadb_get_value_name_int(i, "rank_pay")
		end
	end
end

function Faction_Unload(factionid)
	local query = mariadb_prepare(sql, "UPDATE factions SET name = '?', short_name = '?', type = '?', motd = '?', leadership_rank = '?', radio_dimension = '?', bank = '?' WHERE id = ?",
		FactionData[factionid].name,
		FactionData[factionid].short_name,
		FactionData[factionid].type,
		FactionData[factionid].motd,
		FactionData[factionid].leadership_rank,
		FactionData[factionid].radio_dimension,
		FactionData[factionid].bank,
		FactionData[factionid].id
	)

	mariadb_async_query(sql, query, OnFactionUnloaded, factionid)
end

function OnFactionUnloaded(factionid)
	if mariadb_get_affected_rows() == 0 then
		print('Faction unload unsuccessful, id: '..factionid)
	else
		print('Faction unload successful, id: '..factionid)
		DestroyFactionData(factionid)
	end
end

AddEvent('LoadFactions', function ()
	local query = mariadb_prepare(sql, "SELECT * FROM factions;")
	mariadb_async_query(sql, query, OnLoadFactions)
end)

function OnLoadFactions()
	for i = 1, mariadb_get_row_count(), 1 do
		print('Loading Faction ID '..i)
		Faction_Load(i)
	end
end

AddEvent('UnloadFactions', function ()
	for i = 1, #FactionData, 1 do
		print('Unloading Factions ID: '..i)
		Faction_Unload(i)
	end
end)

function LoadCharacterFaction(player)
	local query = mariadb_prepare(sql, "SELECT * FROM faction_members WHERE char_id = '?' LIMIT 1",
		PlayerData[player].id
	)
	mariadb_async_query(sql, query, OnLoadCharacterFaction, player)
end

function OnLoadCharacterFaction(playerid)
	if mariadb_get_row_count() == 0 then
		PlayerData[playerid].faction = 0
		PlayerData[playerid].faction_rank = 0
	else
		local result = mariadb_get_assoc(1)

		PlayerData[playerid].faction = result['faction_id']
		PlayerData[playerid].faction_rank = result['rank_id']

		AddPlayerChat(playerid, "Faction Id: "..PlayerData[playerid].faction.." Faction Rank: "..PlayerData[playerid].faction_rank..".")
	end
end

function GetPlayerFactionType(player)
	if PlayerData[player].faction == 0 then
		return FACTION_NONE
	end
	return FactionData[PlayerData[player].faction].type
end

function GetFactionType(factionid)
	if FactionData[factionid] ~= nil then
		return FactionData[factionid].type
	end

	return FACTION_NONE
end