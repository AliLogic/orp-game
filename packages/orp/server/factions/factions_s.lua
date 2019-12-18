local colour = ImportPackage('colours')

FactionData = {}
FactionRankData = {}
DivisionData = {}
DivisionRankData = {}

function CreateFactionData(factionid)
	FactionData[factionid] = {}

	FactionData[factionid].id = 0

	FactionData[factionid].name = ""
	FactionData[factionid].short_name = ""
	FactionData[factionid].motd = "Default MOTD"

	FactionData[factionid].leadership_rank = 0
	FactionData[factionid].radio_dimension = 0
	FactionData[factionid].bank = 0
end

function DestroyFactionData(factionid)
	FactionData[factionid] = {}
end

function Faction_Create(name, short_name, leadership_rank)
	leadership_rank = leadership_rank or 10

	local factionid = 0
	CreateFactionData(factionid)

	local query = mariadb_prepare(sql, "INSERT INTO factions (name, short_name, leadership_rank) VALUES('?', '?', '?')",
		name,
		short_name,
		leadership_rank
	)

	mariadb_async_query(sql, query, OnFactionCreated, factionid, name, short_name, leadership_rank)
	return factionid
end

function OnFactionCreated(factionid, name, short_name, leadership_rank)
	FactionData[factionid].id = mariadb_get_insert_id()
	FactionData[factionid].name = name
	FactionData[factionid].short_name = short_name
	FactionData[factionid].leadership_rank = leadership_rank
end

function Faction_Destroy(factionid)
	if FactionData[factionid] == nil then
		return false
	end

	local query = mariadb_prepare(sql, "DELETE FROM factions WHERE id = ?", FactionData[factionid].id)
	mariadb_async_query(sql, query)

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
		local result = mariadb_get_assoc(1)

		FactionData[factionid].id = id
		FactionData[factionid].name = result['name']
		FactionData[factionid].short_name = result['short_name']
		FactionData[factionid].motd = result['motd']

		FactionData[factionid].leadership_rank = tonumber(result['leadership_rank'])
		FactionData[factionid].radio_dimension = tonumber(result['radio_dimension'])
		FactionData[factionid].bank = tonumber(result['bank'])
	end
end

function Faction_Unload(factionid)
	local query = mariadb_prepare(sql, "UPDATE factions SET name = '?', short_name = '?', motd = '?', leadership_rank = '?', radio_dimension = '?', bank = '?' WHERE id = ?",
		FactionData[factionid].name,
		FactionData[factionid].short_name,
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
		DestroyFaction(factionid)
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
		Factions_Unload(i)
	end
end)