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

    GarageData[garage].ix = 0
    GarageData[garage].iy = 0
    GarageData[garage].iz = 0
    GarageData[garage].ia = 0

    GarageData[garage].ex = 0
    GarageData[garage].ey = 0
    GarageData[garage].ez = 0
    GarageData[garage].ea = 0
end

function DestroyGarageData(garage)
    GarageData[garage] = nil
end