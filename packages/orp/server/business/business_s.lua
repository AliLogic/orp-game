local colour = ImportPackage('colours')

BusinessData = {}
MAX_BUSINESSES = 256

BUSINESS_TYPE_NONE = 0
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
    BusinessData[business].locked = false

    BusinessData[business].type = BUSINESS_TYPE_NONE
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