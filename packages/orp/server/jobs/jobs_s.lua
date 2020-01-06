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

CUTTING_TIME = 30
RESPAWN_TIME = 300
LUMBERJACK_TREES = {}
CREATED_TREES = 0
LumberjackData = {}

LumberjackTree = {
	{134, -199991, -38517, 1021},
	{135, -199474, -38753, 1021},
	{136, -199165, -38943, 1021},
	{137, -199349, -39353, 1021},
	{138, -198660, -39604, 1021},
	{139, -198522, -40717, 1021},
	{140, 0.0, 0.0, 0.0},
	{145, 0.0, 0.0, 0.0},
	{146, 0.0, 0.0, 0.0},
	{147, 0.0, 0.0, 0.0},
	{148, 0.0, 0.0, 0.0},
	{149, 0.0, 0.0, 0.0}
}

AddCommand("jobhelp", function (playerid)

	AddPlayerChat(playerid, "Your job is now Lumberjack: /chop")

	PlayerData[playerid].job = 1
end)

local function GetNearestTree(playerid, range)

	range = range or 130.0

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

	local treeid = LumberjackData[playerid].tree_id

	if treeid ~= 0 then

		SetPlayerAnimation(playerid, "PICKAXE_SWING")
		LumberjackData[playerid].seconds = LumberjackData[playerid].seconds + 1

		if LumberjackData[playerid].seconds >= CUTTING_TIME then

			AddPlayerChat(playerid, "CHOPPED")
			SetPlayerAnimation(playerid, "STOP")

			if IsValidObject(LumberjackData[playerid].object) then
				DestroyObject(LumberjackData[playerid].object)
			end

			if IsValidTimer(LUMBERJACK_TREES[treeid].timer) then
				DestroyTimer(LUMBERJACK_TREES[treeid].timer)
			end

			SetObjectRotation(LUMBERJACK_TREES[playerid].obj_id, LUMBERJACK_TREES[playerid].obj_rx, LUMBERJACK_TREES[playerid].obj_ry, LUMBERJACK_TREES[playerid].obj_rz - 800.0)

			LumberjackData[playerid].seconds = 0
			LumberjackData[playerid].tree_id = 0
			LUMBERJACK_TREES[treeid].spawned = false
			LUMBERJACK_TREES[treeid].is_chopped = false

			Delay(RESPAWN_TIME * 1000, function()

				LUMBERJACK_TREES[treeid].spawned = true
				SetObjectRotation(LUMBERJACK_TREES[playerid].obj_id, LUMBERJACK_TREES[playerid].obj_rx, LUMBERJACK_TREES[playerid].obj_ry, LUMBERJACK_TREES[playerid].obj_rz)
			end)
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

	if LUMBERJACK_TREES[treeid].spawned == false then
		return AddPlayerChat(playerid, "Error: This tree has been chopped.")
	end

	if LUMBERJACK_TREES[treeid].is_chopped == true then
		return AddPlayerChat(playerid, "Error: This tree is being chopped.")
	end

	LUMBERJACK_TREES[treeid].timer = CreateTimer(ChopTree, 1000, playerid)

	if IsValidObject(LumberjackData[playerid].object) then
		DestroyObject(LumberjackData[playerid].object)
	end

	LumberjackData[playerid].object = CreateObject(1047, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	SetObjectAttached(LumberjackData[playerid].object, ATTACH_PLAYER, playerid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, "hand_l")
	LumberjackData[playerid].tree_id = treeid
	LUMBERJACK_TREES[treeid].is_chopped = true

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
		text_id = CreateText3D("Tree ["..modelid.."] (".. CREATED_TREES ..")", 10, x, y, z, rx, ry, rz),
		spawned = true,
		is_chopped = false
	}
end

local function RemoveLumberjackTree(treeid)

	CREATED_TREES = CREATED_TREES - 1

	DestroyObject(LUMBERJACK_TREES[treeid].obj_id)
	DestroyTimer(LUMBERJACK_TREES[treeid].timer)
	DestroyText3D(LUMBERJACK_TREES[treeid].text_id)

	LUMBERJACK_TREES[treeid] = {}
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

	AddLumberjackTree(134, 0.0 + 100, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(135, 0.0 + 300, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(136, 0.0 + 500, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(137, 0.0 + 700, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(138, 0.0 + 1000, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(139, 0.0 + 1300, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(140, 0.0 + 1600, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(145, 0.0 + 1900, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(146, 0.0 + 2100, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(147, 0.0 + 2400, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(148, 0.0 + 2700, 0.0, 1545.0, 0.0, 0.0, 0.0)
	AddLumberjackTree(149, 0.0 + 3000, 0.0, 1545.0, 0.0, 0.0, 0.0)
end)

AddEvent("OnPackageStop", function()

	for treeid = 1, #LUMBERJACK_TREES, 1 do
		RemoveLumberjackTree(treeid)
	end
end)

AddEvent("OnPlayerJoin", function(playerid)

	LumberjackData[playerid] = {
		object = 0,
		tree_id = 0,
		seconds = 0
	}
end)

AddEvent("OnPlayerQuit", function(playerid)

	if LumberjackData[playerid].tree_id ~= 0 then

		DestroyTimer(LUMBERJACK_TREES[LumberjackData[playerid].tree_id].timer)
	end

	DestroyObject(LumberjackData[playerid].object)
	LumberjackData[playerid] = nil
end)