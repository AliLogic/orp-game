local colour = ImportPackage('colours')

GarageData = {}
MAX_GARAGES = 256

GARAGE_OWNERSHIP_STATE = 1
GARAGE_OWNERSHIP_SOLE = 2
GARAGE_OWNERSHIP_FACTION = 3

function GetFreeGarageId()
    for i = 1, MAX_GARAGES, 1 do
        if GarageData[i] == nil then
            CreateGarageData(i)
            return i
        end
    end
    return 0
end

function CreateGarageData(garage)
    GarageData[garage] = {}

    GarageData[garage].id = 0
    GarageData[garage].name = "" -- Mostly for stuff like NHP garage.

    GarageData[garage].owner = 0 -- The state/no one.
    GarageData[garage].ownership_type = 0

    GarageData[garage].price = 0
    GarageData[garage].dimension = 0

    GarageData[garage].ix = 0
    GarageData[garage].iy = 0
    GarageData[garage].iz = 0
    GarageData[garage].ia = 0

    GarageData[garage].ex = 0
    GarageData[garage].ey = 0
    GarageData[garage].ez = 0
    GarageData[garage].ea = 0

    -- Temporary values
    GarageData[garage].text3d_out = nil
end

function DestroyGarageData(garage)
    GarageData[garage] = nil
end

AddEvent("UnloadGarages", function () 
    for i = 1, #GarageData, 1 do
        Garage_Unload(i)
    end
end)

AddEvent("LoadGarages", function () 
    mysql_async_query(sql, "SELECT * FROM garages;", OnGarageLoad)
end)

function OnGarageLoad()
    for i = 1, mariadb_get_row_count(), 1 do
        Garage_Load(mariadb_get_value_name_int(i, "id"))
    end
end

function Garage_Create(price, x, y, z, a)
    price = tonumber(price)

    if price < 0 then
        return false
    end
    
    local index = GetFreeGarageId()
    if index == 0 then
        return false
    end

    local query = mariadb_prepare(sql, "INSERT INTO garages (price, ex, ey, ez, ea) VALUES (?, '?', '?', '?', '?');",
        price, x, y, z, a
    )
    mariadb_async_query(sql, query, OnGarageCreated, index, price, x, y, z)
    return index
end

function OnGarageCreated(i, price, x, y, z)
    GarageData[i].id = mariadb_get_insert_id()
    GarageData[i].price = price

    GarageData[i].text3d_out = CreateText3D("Garage "..i.."\n/entergarage", 17, x, y, z, 0, 0, 0)
end

function Garage_Load(garageid)
    local query = mariadb_prepare(sql, "SELECT * FROM garages WHERE id = ?;", garageid)
    mariadb_async_query(sql, query, OnGarageLoaded, garageid)
end

function OnGarageLoaded(garageid)
    if mariadb_get_row_count() == 0 then
        print("Failed to load garage SQL ID "..garageid)
    else
        local garage = GetFreeBusinessId()
        if garage == 0 then
            print("A free garage id wasn't able to be found? ("..#GarageData.."/"..MAX_GARAGES..") garage SQL ID "..garageid..".")
        end

        GarageData[garage].id = garageid
        GarageData[garage].name = mariadb_get_value_name(garageid, "name")

        GarageData[garage].owner = mariadb_get_value_name_int(garageid, "owner")
        GarageData[garage].ownership_type = mariadb_get_value_name_int(garageid, "ownership_type")

        GarageData[garage].price = mariadb_get_value_name_int(garageid, "price")
        GarageData[garage].dimension = mariadb_get_value_name_int(garageid, "dimension")

        GarageData[garage].ix = mariadb_get_value_name_float(garageid, "ix")
        GarageData[garage].iy = mariadb_get_value_name_float(garageid, "iy")
        GarageData[garage].iz = mariadb_get_value_name_float(garageid, "iz")
        GarageData[garage].ia = mariadb_get_value_name_float(garageid, "ia")

        GarageData[garage].ex = mariadb_get_value_name_float(garageid, "ex")
        GarageData[garage].ey = mariadb_get_value_name_float(garageid, "ey")
        GarageData[garage].ez = mariadb_get_value_name_float(garageid, "ez")
        GarageData[garage].ea = mariadb_get_value_name_float(garageid, "ea")

    end
end

function Garage_Unload(garage)
    local query = mariadb_prepare(sql, "UPDATE garages SET name = '?', owner = ?, ownership_type = ?, price = ?, dimension = ?, ix = '?', iy = '?', iz = '?', ia = '?', ex = '?', ey = '?', ez = '?', ea = '?' WHERE id = ?;",
        GarageData[garage].name,
        GarageData[garage].owner,
        GarageData[garage].ownership_type,
        GarageData[garage].price,
        GarageData[garage].dimension,
        GarageData[garage].ix,
        GarageData[garage].iy,
        GarageData[garage].iz,
        GarageData[garage].ia,
        GarageData[garage].ex,
        GarageData[garage].ey,
        GarageData[garage].ez,
        GarageData[garage].ea,
        GarageData[garage].id    
    )
    mariadb_async_query(sql, query, OnGarageUnloaded, garage)
end

function OnGarageUnloaded(garage)
    if mariadb_get_affected_rows() == 0 then
        print("Garage ID "..garage.." unload unsuccessful!")
    else
        print("Garage ID "..garage.." unload successful!")
    end 
end

function Garage_Destroy(garage)
    if GarageData[garage] == nil then
        return false
    end

    local query = mariadb_prepare(sql, "DELETE FROM garages WHERE id = ?;", GarageData[garage].id)
    mariadb_async_query(sql, query)

    DestroyGarageData(garage)
end