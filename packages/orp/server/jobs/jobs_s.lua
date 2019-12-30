local colour = ImportPackage('colours')

JobData = {}
JobRanks = {}
JobCoords = {}

MAX_JOB_RANKS = 6
MAX_JOB_COORDS = 32

JOB_TYPE_NONE = 0
JOB_TYPE_LUMBERJACK = 1
JOB_TYPE_TAXI = 2
JOB_TYPE_TRUCKER = 3

CUTTING_TIME = 20
LUMBERJACK_TREES = {}
CREATED_TREES = 0
LumberjackData = {}

local function GetNearestTree(playerid, range)

	range = range or 100.0

	local id = 0
	local distance = range
	local tdistance = 0.0
	local x, y, z = GetPlayerLocation(playerid)

	for treeid = 1, #LUMBERJACK_TREES, 1 do

		tdistance = GetDistance3D(x, y, z, LUMBERJACK_TREES[treeid].obj_x, LUMBERJACK_TREES[treeid].obj_y, LUMBERJACK_TREES[treeid].obj_z)

		if tdistance <= range then
			if tdistance <= distance then
				distance = tdistance
				id = treeid
			end
		end
	end

	return id
end

local function ChopTree(playerid)

	SetPlayerAnimation(playerid, "PICKAXE_SWING")

	if LumberjackData[playerid].tree_id ~= 0 then

		LumberjackData[playerid].seconds = LumberjackData[playerid].seconds + 1

		if LumberjackData[playerid].seconds >= CUTTING_TIME then

			AddPlayerChat(playerid, "CHOPPED")

			if IsValidObject(LumberjackData[playerid].object) then
				DestroyObject(LumberjackData[playerid].object)
			end

			SetObjectRotation(LUMBERJACK_TREES[playerid].obj_id, LUMBERJACK_TREES[playerid].obj_rx, LUMBERJACK_TREES[playerid].obj_ry - 80.0, LUMBERJACK_TREES[playerid].obj_rz)
		end
	end
end

AddCommand("chop", function (playerid)

	if PlayerData[playerid].job == 0 then
		return AddPlayerChat(playerid, "Error: You do not have any job.")
	end

	-- if then
	-- 	return AddPlayerChat(playerid, "Error: You are not permitted to use this command.")
	-- end

	local treeid = GetNearestTree(playerid)

	if treeid == 0 then
		return AddPlayerChat(playerid, "Error: You are not near any trees.")
	end

	LUMBERJACK_TREES[treeid].timer = CreateTimer("ChopTree", 1000, playerid)

	if IsValidObject(LumberjackData[playerid].object) then
		DestroyObject(LumberjackData[playerid].object)
	end

	LumberjackData[playerid].object = CreateObject(1047, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	SetObjectAttached(LumberjackData[playerid], ATTACH_PLAYER, playerid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, "hand_l")

	SetPlayerAnimation(playerid, "PICKAXE_SWING")
end)

local function AddLumberjackTree(modelid, x, y, z, rx, ry, rz)

	CREATED_TREES = CREATED_TREES + 1

	LUMBERJACK_TREES[CREATED_TREES] = {

		obj_id = CreateObject(modelid, x, y, z, rx, ry, rz),
		obj_x = x,
		obj_y = y,
		obj_z = z,
		obj_rx = rx,
		obj_ry = ry,
		obj_rz = rz,
		timer = 0,
		text_id = CreateText3D("Tree ["..modelid.."] (".. CREATED_TREES ..")", 10, x, y, z, rx, ry, rz)
	}
end

local function RemoveLumberjackTree(treeid)

	CREATED_TREES = CREATED_TREES - 1

	DestroyObject(LUMBERJACK_TREES[treeid].obj_id)
	DestroyTimer(LUMBERJACK_TREES[treeid].timer)
	DestroyText3D(LUMBERJACK_TREES[treeid].text_id)
end

function DestroyJobData(job)
	JobData[job] = nil
	JobRanks[job] = nil
	JobCoords[job] = nil
end

function CreateJobData(job)
	JobData[job] = {}

	JobData[job].id = 0
	JobData[job].name = "" -- Only needed for jobs like 'taxi' or something.

	JobData[job].type = 0
	JobData[job].minimum_hours = 0

	CreateJobRanks(job)
	CreateJobCoords(job)
end

function CreateJobRanks(job)
	JobRanks[job] = {}

	for i = 1, MAX_JOB_RANKS, 1 do
		JobRanks[job][i] = {}

		JobRanks[job][i].jobid = 0
		JobRanks[job][i].name = "Rank "..i
	end
end

function CreateJobCoords(job)
	JobCoords[job] = {}

	for i = 1, MAX_JOB_COORDS, 1 do
		JobCoords[job][i] = {}
		JobCoords[job][i].jobid = 0

		JobCoords[job][i].x = 0.0
		JobCoords[job][i].y = 0.0
		JobCoords[job][i].z = 0.0
		JobCoords[job][i].a = 0.0 -- Optional value. NOT REQUIRED!
	end
end

AddEvent("OnPackageStart", function()

	AddLumberjackTree(63, 0.0 + 100, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(64, 0.0 + 300, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(65, 0.0 + 500, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(66, 0.0 + 700, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(67, 0.0 + 1000, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(68, 0.0 + 1300, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(69, 0.0 + 1600, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(127, 0.0 + 1900, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(134, 0.0 + 2200, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(135, 0.0 + 2500, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(136, 0.0 + 2800, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(137, 0.0 + 3100, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(138, 0.0 + 3400, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(139, 0.0 + 3700, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(140, 0.0 + 4000, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(141, 0.0 + 4300, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(142, 0.0 + 4600, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(143, 0.0 + 4900, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(144, 0.0 + 5200, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(145, 0.0 + 5500, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(146, 0.0 + 5800, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(147, 0.0 + 6100, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(148, 0.0 + 6400, 0.0, 2000.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(149, 0.0 + 6700, 0.0, 2000.0, 0.0, 0.0, 0.0)
end)

AddEvent("OnPackageStart", function()

	for treeid = 1, #LUMBERJACK_TREES, 1 do
		RemoveLumberjackTree(treeid)
	end
end)

AddEvent("OnPlayerJoin", function(playerid)

	LumberjackData[playerid] = {
		object = 0,
		tree_id = 0
	}

end)

AddEvent("OnPlayerQuit", function(playerid)

	DestroyObject(LumberjackData[playerid].object)
	LumberjackData[playerid] = {}

end)