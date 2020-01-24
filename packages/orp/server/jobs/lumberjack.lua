CUTTING_TIME = 30
RESPAWN_TIME = 300

LumberjackTrees = {}
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

local function GetNearestTree(playerid, range)

	range = range or 130.0

	local id = 0
	local distance = range
	local tdistance = 0.0
	local x, y, z = GetPlayerLocation(playerid)

	for treeid = 1, #LumberjackTrees, 1 do

		tdistance = GetDistance3D(x, y, z, LumberjackTrees[treeid].obj_x, LumberjackTrees[treeid].obj_y, LumberjackTrees[treeid].obj_z)

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

			if IsValidTimer(LumberjackTrees[treeid].timer) then
				DestroyTimer(LumberjackTrees[treeid].timer)
			end

			SetObjectRotation(LumberjackTrees[playerid].obj_id, LumberjackTrees[playerid].obj_rx, LumberjackTrees[playerid].obj_ry, LumberjackTrees[playerid].obj_rz - 800.0)

			LumberjackData[playerid].seconds = 0
			LumberjackData[playerid].tree_id = 0
			LumberjackTrees[treeid].spawned = false
			LumberjackTrees[treeid].is_chopped = false

			Delay(RESPAWN_TIME * 1000, function()

				LumberjackTrees[treeid].spawned = true
				SetObjectRotation(LumberjackTrees[playerid].obj_id, LumberjackTrees[playerid].obj_rx, LumberjackTrees[playerid].obj_ry, LumberjackTrees[playerid].obj_rz)
			end)
		end
	end
end

AddCommand("chop", function (playerid)

	if GetPlayerJob(playerid) ~= JOB_TYPE_LUMBERJACK then
		return AddPlayerChat(playerid, "You are not a Lumberjack.")
	end

	local treeid = GetNearestTree(playerid)

	if treeid == 0 then
		return AddPlayerChat(playerid, "Error: You are not near any trees.")
	end

	if LumberjackTrees[treeid].spawned == false then
		return AddPlayerChat(playerid, "Error: This tree has been chopped.")
	end

	if LumberjackTrees[treeid].is_chopped == true then
		return AddPlayerChat(playerid, "Error: This tree is being chopped.")
	end

	LumberjackTrees[treeid].timer = CreateTimer(ChopTree, 1000, playerid)

	if IsValidObject(LumberjackData[playerid].object) then
		DestroyObject(LumberjackData[playerid].object)
	end

	LumberjackData[playerid].object = CreateObject(1047, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	SetObjectAttached(LumberjackData[playerid].object, ATTACH_PLAYER, playerid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, "hand_l")
	LumberjackData[playerid].tree_id = treeid
	LumberjackTrees[treeid].is_chopped = true

	SetPlayerAnimation(playerid, "PICKAXE_SWING")
end)

local function AddLumberjackTree(modelid, x, y, z, rx, ry, rz)

	CREATED_TREES = CREATED_TREES + 1

	LumberjackTrees[CREATED_TREES] = {

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

	DestroyObject(LumberjackTrees[treeid].obj_id)
	DestroyTimer(LumberjackTrees[treeid].timer)
	DestroyText3D(LumberjackTrees[treeid].text_id)

	LumberjackTrees[treeid] = {}
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

	for treeid = 1, #LumberjackTrees, 1 do
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

		DestroyTimer(LumberjackTrees[LumberjackData[playerid].tree_id].timer)
	end

	DestroyObject(LumberjackData[playerid].object)
	LumberjackData[playerid] = nil
end)