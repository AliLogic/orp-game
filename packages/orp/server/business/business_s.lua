local colour = ImportPackage('colours')

BusinessData = {}
MAX_BUSINESSES = 256

BUSINESS_TYPE_ENTRANCE = 1
BUSINESS_TYPE_LOCAL = 2 -- aka 24/7
BUSINESS_TYPE_AMMU = 3
BUSINESS_TYPE_BAR = 4
BUSINESS_TYPE_RESTAURANT = 5
BUSINESS_TYPE_BANK = 6

BusinessTypes = {
	"Entrance",
	"24/7",
	"Ammunition",
	"Bar",
	"Restaurant",
	"Bank"
}

BUSINESS_TYPE_MAX = 6

BUSINESS_OWNERSHIP_STATE = 1
BUSINESS_OWNERSHIP_SOLE = 2
BUSINESS_OWNERSHIP_FACTION = 3

function GetFreeBusinessId()
	for i = 1, MAX_BUSINESSES, 1 do
		if BusinessData[i] == nil then
			CreateBusinessData(i)
			return i
		end
	end
	return 0
end

function CreateBusinessData(business)
	BusinessData[business] = {}

	-- Permanent (saving) values

	BusinessData[business].id = 0
	BusinessData[business].markerid = 0 -- sqlid of the marker!

	BusinessData[business].owner = 0 -- 0, aka the state..
	BusinessData[business].ownership_type = 0 -- aka, the state... if +1'ed.

	BusinessData[business].name = "Business"
	BusinessData[business].locked = 0 -- for yes, put 1.

	BusinessData[business].type = 0
	BusinessData[business].enterable = false -- doesnt have a interior, is a 'outside' business per se.

	BusinessData[business].price = 0 -- costs 0 dollasssss
	BusinessData[business].message = "This is a default business message."

	BusinessData[business].dimension = 0 -- dimension of the interior.

	BusinessData[business].ix = 0.0 -- internal coordinates, as in, interior
	BusinessData[business].iy = 0.0
	BusinessData[business].iz = 0.0
	BusinessData[business].ia = 0.0

	BusinessData[business].ex = 0.0 -- external coordinates, as in, exterior or outside
	BusinessData[business].ey = 0.0
	BusinessData[business].ez = 0.0
	BusinessData[business].ea = 0.0

	BusinessData[business].mx = 0.0 -- marker coordinates, as in, where you go and execute the /buy command.
	BusinessData[business].my = 0.0
	BusinessData[business].mz = 0.0

	-- Temporary values
	BusinessData[business].text3d = nil -- The marker for inside coordinates where you execute /buy.
	BusinessData[business].text3d_in = nil -- The marker for the inside coordinates where you /exit. Pretty useless but always useful for the future.
	BusinessData[business].text3d_outside = nil -- The marker for outside coordinates, where you do /enter and shows business name.

	BusinessData[business].doors = {}
end

function DestroyBusinessData(business)
	BusinessData[business] = nil
end

AddEvent('LoadBusinesses', function ()
	mariadb_async_query(sql, "SELECT * FROM businesses;", OnBusinessLoad)
end)

function OnBusinessLoad()
	for i = 1, mariadb_get_row_count(), 1 do
		Business_Load(i)
	end
	print("** Businesses Loaded: "..mariadb_get_row_count()..".")
end

AddEvent('UnloadBusinesses', function () 
	for i = 1, #BusinessData, 1 do
		Business_Unload(i)
	end
end)

function Business_Create(player, type, enterable, price, name)
	type = tonumber(type)
	enterable = tonumber(enterable)
	price = tonumber(price)

	if string.len(name) < 0 or string.len(name) > 32 then
		return false
	end

	if type < 1 or type > BUSINESS_TYPE_MAX then
		return false
	end

	if enterable < 0 or enterable > 1 then
		return false
	end

	if price < 0 then
		return false
	end

	local index = GetFreeBusinessId()
	if index == 0 then
		return false
	end

	local x, y, z = GetPlayerLocation(player)

	if enterable == 0 then
		BusinessData[index].text3d = CreateText3D(string.format("%s %d\n/buy", BusinessData[index].name, index), 17, x, y, z, 0, 0, 0)

		local query = mariadb_prepare(sql, "INSERT INTO businesses (name, type, enterable, price, mx, my, mz) VALUES ('?', ?, ?, ?, '?', '?', '?');",
			name, type, enterable, price, x, y, z
		)
		mariadb_async_query(sql, query, OnBusinessCreated, index, type, enterable, price, name)
	else
		-- For enterable == 1, set it whenever they set a entrance (ex ey ez) to the business. (done)
		local a = GetPlayerHeading(player)
		BusinessData[index].text3d = CreateText3D(string.format("%s %d", BusinessData[index].name, index), 17, x, y, z, 0, 0, 0)

		local query = mariadb_prepare(sql, "INSERT INTO businesses (name, type, enterable, price, ex, ey, ez, ea) VALUES ('?', ?, ?, ?, '?', '?', '?', '?');",
			name, type, enterable, price, x, y, z, a
		)
		mariadb_async_query(sql, query, OnBusinessCreated, index, type, enterable, price, name)
	end
	return index
end

function OnBusinessCreated(i, type, enterable, price, name, ...)
	BusinessData[i].id = mariadb_get_insert_id()

	BusinessData[i].name = name
	BusinessData[i].type = type

	BusinessData[i].enterable = enterable
	BusinessData[i].price = price

	local args = {...}

	if enterable == 0 then
		BusinessData[i].mx = tonumber(args[1])
		BusinessData[i].my = tonumber(args[2])
		BusinessData[i].mz = tonumber(args[3])
	else
		BusinessData[i].ex = tonumber(args[1])
		BusinessData[i].ey = tonumber(args[2])
		BusinessData[i].ez = tonumber(args[3])
		BusinessData[i].ea = tonumber(args[4])
	end
end

function Business_Load(i)

	local business = GetFreeBusinessId()
	if business == 0 then
		print("A free business id wasn't able to be found? ("..#BusinessData.."/"..MAX_BUSINESSES..") business SQL ID "..mariadb_get_value_name_int(i, "id")..".")
		return 0
	end

	BusinessData[business].id = mariadb_get_value_name_int(i, "id")
	BusinessData[business].markerid = mariadb_get_value_name_int(i, "markerid")

	BusinessData[business].owner = mariadb_get_value_name_int(i, "owner")
	BusinessData[business].ownership_type = mariadb_get_value_name_int(i, "ownership_type")

	BusinessData[business].name = mariadb_get_value_name(i, "name")
	BusinessData[business].locked = mariadb_get_value_name_int(i, "locked")

	BusinessData[business].type = mariadb_get_value_name_int(i, "type")
	BusinessData[business].enterable = mariadb_get_value_name_int(i, "enterable")

	BusinessData[business].price = mariadb_get_value_name_int(i, "price")
	BusinessData[business].message = mariadb_get_value_name(i, "message")

	BusinessData[business].dimension = mariadb_get_value_name_int(i, "dimension")

	BusinessData[business].ix = tonumber(mariadb_get_value_name(i, "ix"))
	BusinessData[business].iy = tonumber(mariadb_get_value_name(i, "iy"))
	BusinessData[business].iz = tonumber(mariadb_get_value_name(i, "iz"))
	BusinessData[business].ia = tonumber(mariadb_get_value_name(i, "ia"))

	BusinessData[business].ex = tonumber(mariadb_get_value_name(i, "ex"))
	BusinessData[business].ey = tonumber(mariadb_get_value_name(i, "ey"))
	BusinessData[business].ez = tonumber(mariadb_get_value_name(i, "ez"))
	BusinessData[business].ea = tonumber(mariadb_get_value_name(i, "ea"))

	BusinessData[business].mx = tonumber(mariadb_get_value_name(i, "mx"))
	BusinessData[business].my = tonumber(mariadb_get_value_name(i, "my"))
	BusinessData[business].mz = tonumber(mariadb_get_value_name(i, "mz"))

	if BusinessData[business].enterable == 0 then
		BusinessData[business].text3d = CreateText3D(string.format("%s\n/buy", BusinessData[business].name), 
		17, BusinessData[business].mx, BusinessData[business].my, BusinessData[business].mz, 0, 0, 0)
	end

	if BusinessData[business].markerid ~= 0 then
		-- CreateMarker
	end

	LoadBusinessDoors(business)

	-- Create3dTextLabel
end

function Business_Unload(business)
	local query = mariadb_prepare(sql, "UPDATE businesses SET owner = ?, name = '?', locked = ?, type = ?, enterable = ?, price = ?, message = '?', dimension = ?\
	ix = '?', iy = '?', iz = '?', ia = '?', ex = '?', ey = '?', ez = '?', ea = '?', mx = '?', my = '?', mz = '?', ownership_type = ? WHERE id = ?;",
		BusinessData[business].owner, BusinessData[business].name, BusinessData[business].locked,
		BusinessData[business].type, BusinessData[business].enterable, BusinessData[business].price,
		BusinessData[business].message, BusinessData[business].dimension,
		tostring(BusinessData[business].ix), tostring(BusinessData[business].iy), tostring(BusinessData[business].iz), tostring(BusinessData[business].ia),
		tostring(BusinessData[business].ex), tostring(BusinessData[business].ey), tostring(BusinessData[business].ez), tostring(BusinessData[business].ea),
		tostring(BusinessData[business].mx), tostring(BusinessData[business].my), tostring(BusinessData[business].mz),
		BusinessData[business].ownership_type, BusinessData[business].id
	)
	mariadb_async_query(sql, query, OnBusinessUnloaded, business)
end

function OnBusinessUnloaded(business)
	if mariadb_get_affected_rows() == 0 then
		print("Business ID "..business.." unload unsuccessful!")
	else
		print("Business ID "..business.." unload successful!")
	end
end

function Business_Destroy(business)
	if BusinessData[business] == nil then
		return false
	end

	local query = mariadb_prepare(sql, "DELETE FROM businesses WHERE id = ?;", BusinessData[business].id)
	mariadb_async_query(sql, query)

	--DestroyMarker

	if IsValidText3D(BusinessData[business].text3d) then
		DestroyText3D(BusinessData[business].text3d)
	end

	if IsValidText3D(BusinessData[business].text3d_out) then
		DestroyText3D(BusinessData[business].text3d_out)
	end

	if IsValidText3D(BusinessData[business].text3d_in) then
		DestroyText3D(BusinessData[business].text3d_in)
	end

	DestroyBusinessData(business)
end

function Business_Nearest(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0

	for v = 1, #BusinessData, 1 do
		if BusinessData[v] ~= nil then
			if BusinessData[v].enterable == 0 then
				distance = GetDistance3D(x, y, z, BusinessData[v].mx, BusinessData[v].my, BusinessData[v].mz)
			else
				distance = GetDistance3D(x, y, z, BusinessData[v].ex, BusinessData[v].ey, BusinessData[v].ez)
			end

			if distance <= 200.0 then
				return v
			end
		end
	end

	return 0
end

function Business_IsOwner(playerid, businessid)

	if BusinessData[businessid] == nil then
		return false
	end

	if BusinessData[businessid].owner == PlayerData[playerid].id then
		return true
	end

	return false
end