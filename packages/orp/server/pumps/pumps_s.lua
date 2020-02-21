--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic

Contributors:
* Blue Mountains GmbH
]]--

local colour = ImportPackage('colours')

FuelTimer = 0
PumpData = {}
MAX_PUMPS = 128
MAX_LITRES = 34000

local function CreatePumpData(pumpid)

	PumpData[pumpid] = {}

	-- Permanent (saving) values
	PumpData[pumpid].id = 0
	PumpData[pumpid].text3d = 0
	PumpData[pumpid].timer = 0

	PumpData[pumpid].x = 0
	PumpData[pumpid].y = 0
	PumpData[pumpid].z = 0

	PumpData[pumpid].is_occupied = 0
end

local function GetFreePumpId()
	for i = 1, MAX_PUMPS, 1 do
		if PumpData[i] == nil then
			CreatePumpData(i)
			return i
		end
	end
	return 0
end

local function DestroyPumpData(pumpid)
	PumpData[pumpid] = nil
end

local function SetPumpUnoccupied(pumpid)
	DestroyTimer(PumpData[pumpid].timer)
	PumpData[pumpid].is_occupied = 0
end

function OnPumpTick(pumpid, vehicleid)

	local playerid = PumpData[pumpid].is_occupied

	if playerid ~= 0 and IsValidPlayer(playerid) then
		if PumpData[pumpid].litres > 0 then

			SetText3DText(PumpData[pumpid].text3d, "Pump ("..pumpid..")\nLitres: "..PumpData[pumpid].litres)

			PumpData[pumpid].litres = (PumpData[pumpid].litres - 1)

			VehicleData[vehicleid].fuel = (VehicleData[vehicleid].fuel + 1)

			if GetVehicleFuel(vehicleid) >= 100 then

				SetPumpUnoccupied(pumpid)

				AddPlayerChat(playerid, "Your vehicle has been refuelled.")
			end
		else

			SetText3DText(PumpData[pumpid].text3d, "Pump ("..pumpid..")\nLitres: "..PumpData[pumpid].litres)

			SetPumpUnoccupied(pumpid)

			AddPlayerChat(playerid, "The fuel pump has ran out of fuel.")
		end
	else
		SetPumpUnoccupied(pumpid)

		print("The player ID "..playerid.." has disconnected the server while vehicle "..vehicleid.." being refuelled.")
	end
end

local function OnPumpCreated(index, x, y, z, litres)

	PumpData[index].id = mariadb_get_insert_id()

	PumpData[index].x = x
	PumpData[index].y = y
	PumpData[index].z = z

	PumpData[index].litres = litres
	PumpData[index].is_occupied = 0

	PumpData[index].text3d = CreateText3D("Pump ("..index..")\nLiters: "..PumpData[index].litres, 20, x, y, z + 150.0, 0.0, 0.0, 0.0)
end

function Pump_Create(x, y, z, litres)

	local index = GetFreePumpId()
	if index == 0 then
		return false
	end

	local query = mariadb_prepare(sql, "INSERT INTO pumps (x, y, z, litres) VALUES (?, ?, ?, ?);",
		x, y, z, litres
	)
	mariadb_async_query(sql, query, OnPumpCreated, index, x, y, z, litres)

	return index
end

function Pump_Destroy(pump)

	if PumpData[pump] == nil then
		return false
	end

	local query = mariadb_prepare(sql, "DELETE FROM pumps WHERE id = ?;", PumpData[pump].id)
	mariadb_async_query(sql, query)

	if IsValidObject(PumpData[pump].objectid) then
		DestroyObject(PumpData[pump].objectid)
	end

	if IsValidTimer(PumpData[pump].timer) then
		DestroyTimer(PumpData[pump].timer)
	end

	if IsValidText3D(PumpData[pump].text3d) then
		DestroyText3D(PumpData[pump].text3d)
	end

	DestroyPumpData(pump)
end

local function Pump_Load(i)
	local index = GetFreePumpId()

	if index == 0 then
		print("A free pump id wasn't able to be found? ("..#PumpData.."/"..MAX_SPEEDCAMS..") pump SQL ID "..mariadb_get_value_name_int(i, "id")..".")
		return
	end

	PumpData[index].id = mariadb_get_value_name_int(i, "id")

	PumpData[index].x = mariadb_get_value_name_int(i, "x")
	PumpData[index].y = mariadb_get_value_name_int(i, "y")
	PumpData[index].z = mariadb_get_value_name_int(i, "z")
	PumpData[index].litres = mariadb_get_value_name_int(i, "litres")

	PumpData[index].text3d = CreateText3D("Pump ("..index..")\nLitres: "..PumpData[index].litres, 20, PumpData[index].x, PumpData[index].y, PumpData[index].z + 150.0, 0.0, 0.0, 0.0)

	PumpData[index].is_occupied = 0
end

local function OnPumpLoad()
	for i = 1, mariadb_get_row_count(), 1 do
		Pump_Load(i)
	end

	print("** Pumps Loaded: " .. #PumpData .. ".")
end

local function OnPumpUnloaded(pump)
	if mariadb_get_affected_rows() == 0 then
		print("Pump ID "..pump.." unload unsuccessful!")
	else
		print("Pump ID "..pump.." unload successful!")
	end
end

local function Pump_Unload(pump)
	local query = mariadb_prepare(sql, "UPDATE pumps SET x = '?', y = '?', z = '?', litres = '?' WHERE id = ?;",
		PumpData[pump].x, PumpData[pump].y, PumpData[pump].z, PumpData[pump].litres,
		PumpData[pump].id
	)
	mariadb_async_query(sql, query, OnPumpUnloaded, pump)
end

AddEvent("UnloadPumps", function()
	for i = 1, #PumpData, 1 do
		Pump_Unload(i)
	end

	DestroyTimer(FuelTimer)
end)

AddEvent('LoadPumps', function ()
	mariadb_async_query(sql, "SELECT * FROM pumps;", OnPumpLoad)

	FuelTimer = CreateTimer(OnFuelTick, 60 * 1000)
end)

function OnFuelTick()

	for v = 1, #VehicleData, 1 do
		if VehicleData[v] ~= nil then
			if GetVehicleEngineState(v) == true then
				if VehicleData[v].fuel > 0 then
					VehicleData[v].fuel = (VehicleData[v].fuel - 1)

					if VehicleData[v].fuel <= 5 then

						AddPlayerChat(GetVehicleDriver(v), "This vehicle is low on fuel. You must visit a fuel station and refuel it!");
					end
				elseif VehicleData[v].fuel <= 0 then
					VehicleData[v].fuel = 0
					StopVehicleEngine(v)
					AddPlayerChat(GetVehicleDriver(v), "This vehicle has run out of fuel!");
				end
			end
		end
	end
end

function Pump_Nearest(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local distance = 0

	for v = 1, #PumpData, 1 do
		if PumpData[v] ~= nil then
			distance = GetDistance3D(x, y, z, PumpData[v].x, PumpData[v].y, PumpData[v].z)

			if distance <= 200.0 then
				return v
			end
		end
	end

	return 0
end