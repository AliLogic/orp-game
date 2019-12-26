local colour = ImportPackage('colours')

BusinessData = {}
MAX_BUSINESSES = 256

BUSINESS_TYPE_LOCAL = 1 -- aka 24/7
BUSINESS_TYPE_AMMU = 2
BUSINESS_TYPE_BAR = 3
BUSINESS_TYPE_RESTAURANT = 4
BUSINESS_TYPE_BANK = 5

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

    BusinessData[business].id = 0
    BusinessData[business].owner = 0 -- 0, aka the state..

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
end

function DestroyBusinessData(business)
    BusinessData[business] = nil
end

AddEvent('LoadBusinesses', function () 
    mariadb_async_query(sql, "SELECT * FROM businesses;", OnBusinessLoad)
end)

function OnBusinessLoad()
    for i = 1, mariadb_get_row_count(), 1 do
        Business_Load(mariadb_get_value_name_int(i, "id"))
    end
end

AddEvent('UnloadBusinesses', function () 
    for i = 1, #BusinessData, 1 do
        Business_Unload(i)
    end
end)

function Business_Create(type, enterable, price, ...)
    name = table.concat({...}, " ")
    type = tonumber(type)
    enterable = tonumber(enterable)
    price = tonumber(price)

    if string.len(name) < 0 or string.len(name) > 32 then
        return false
    end

    if type < 1 or type > 5 then
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

    local query = mariadb_prepare(sql, "INSERT INTO businesses (name, type, enterable, price) VALUES ('?', ?, ?, ?);",
        name, type, enterable, price    
    )
    mariadb_async_query(sql, query, OnBusinessCreated, index, type, enterable, price, name)
end

function OnBusinessCreated(i, type, enterable, price, name)
    BusinessData[i].id = mariadb_get_insert_id()

    BusinessData[i].name = name
    BusinessData[i].type = type

    BusinessData[i].enterable = enterable
    BusinessData[i].price = price
end

function Business_Load(businessid)
    local query = mariadb_prepare(sql, "SELECT * FROM businesses WHERE id = ?;", businessid)
    mariadb_async_query(sql, query, OnBusinessLoaded, businessid)
end

function OnBusinessLoaded(businessid)
    if mariadb_get_row_count() == 0 then
        print("Failed to load business SQL ID "..businessid)
    else
        local business = GetFreeBusinessId()
        if business == 0 then
            print("A free business id wasn't able to be found? ("..#BusinessData.."/"..MAX_BUSINESSES..") business SQL ID "..businessid)
        end
    
        -- type, enterable, price, message, dimension, ix iy iz ia, ex ey ez ea, mx my mz

        BusinessData[business].id = businessid
        BusinessData[business].owner = mariadb_get_value_name_int(businessid, "owner")

        BusinessData[business].name = mariadb_get_value_name(businessid, "name")
        BusinessData[business].locked = mariadb_get_value_name_int(businessid, "locked")

        BusinessData[business].type = mariadb_get_value_name_int(businessid, "type")
        BusinessData[business].enterable = mariadb_get_value_name_int(businessid, "enterable")

        BusinessData[business].price = mariadb_get_value_name_int(businessid, "price")
        BusinessData[business].message = mariadb_get_value_name(businessid, "message")

        BusinessData[business].dimension = mariadb_get_value_name_int(businessid, "dimension")

        BusinessData[business].ix = tonumber(mariadb_get_value_name(businessid, "ix"))
        BusinessData[business].iy = tonumber(mariadb_get_value_name(businessid, "iy"))
        BusinessData[business].iz = tonumber(mariadb_get_value_name(businessid, "iz"))
        BusinessData[business].ia = tonumber(mariadb_get_value_name(businessid, "ia"))

        BusinessData[business].ex = tonumber(mariadb_get_value_name(businessid, "ex"))
        BusinessData[business].ey = tonumber(mariadb_get_value_name(businessid, "ey"))
        BusinessData[business].ez = tonumber(mariadb_get_value_name(businessid, "ez"))
        BusinessData[business].ea = tonumber(mariadb_get_value_name(businessid, "ea"))

        BusinessData[business].mx = tonumber(mariadb_get_value_name(businessid, "mx"))
        BusinessData[business].my = tonumber(mariadb_get_value_name(businessid, "my"))
        BusinessData[business].mz = tonumber(mariadb_get_value_name(businessid, "mz"))

        print("Business "..business.." (SQL ID: "..businessid..") successfully loaded!")

    end
end

function Business_Unload(business)
    local query = mariadb_prepare(sql, "UPDATE businesses SET owner = ?, name = '?', locked = ?, type = ?, enterable = ?, price = ?, message = '?', dimension = ?\
    ix = '?', iy = '?', iz = '?', ia = '?', ex = '?', ey = '?', ez = '?', ea = '?', mx = '?', my = '?', mz = '?' WHERE id = ?;",
        BusinessData[business].owner, BusinessData[business].name, BusinessData[business].locked,
        BusinessData[business].type, BusinessData[business].enterable, BusinessData[business].price,
        BusinessData[business].message, BusinessData[business].dimension,
        tostring(BusinessData[business].ix), tostring(BusinessData[business].iy), tostring(BusinessData[business].iz), tostring(BusinessData[business].ia),
        tostring(BusinessData[business].ex), tostring(BusinessData[business].ey), tostring(BusinessData[business].ez), tostring(BusinessData[business].ea),
        tostring(BusinessData[business].mx), tostring(BusinessData[business].my), tostring(BusinessData[business].mz)
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
	if BusinessData[vehicle] == nil then
		return false
	end

	local query = mariadb_prepare(sql, "DELETE FROM businesses WHERE id = ?", BusinessData[business].id)
    mariadb_async_query(sql, query)
    
    --DestroyMarker
    --Destroy3dTextlabel
    DestroyBusinessData(business)
end