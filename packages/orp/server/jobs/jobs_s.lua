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
JOB_TYPE_MECHANIC = 4
JOB_TYPE_MINER = 5

AddCommand("jobhelp", function (playerid)

	local job = GetPlayerJob(playerid)

	if job == JOB_TYPE_NONE then
		AddPlayerChat(playerid, "None: You are unemployed!")
	elseif job == JOB_TYPE_LUMBERJACK then
		AddPlayerChat(playerid, "Lumberjack: /chop")
	elseif job == JOB_TYPE_TAXI then
		AddPlayerChat(playerid, "Taxi: ")
	elseif job == JOB_TYPE_TRUCKER then
		AddPlayerChat(playerid, "Trucker: ")
	elseif job == JOB_TYPE_MECHANIC then
		AddPlayerChat(playerid, "Mechanic: /repair /nitrous /acceptmechanic")
	elseif job == JOB_TYPE_MINER then
		AddPlayerChat(playerid, "Miner: /mine")
	end

	return
end)

AddCommand("job", function (playerid, jobid)

	if (jobid == nil) then
		return AddPlayerChat(playerid, "/job <job id>")
	end

	jobid = tonumber(jobid)
	SetPlayerJob(playerid, jobid)
	AddPlayerChat(playerid, "done")

	return
end)

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

function GetJobName(job)
	return JobData[job].name
end

function IsPlayerNearJobPoint(playerid)

	local x, y, z = GetPlayerLocation(playerid)
	local job = GetPlayerJob(playerid)

	for i = 1, MAX_JOB_COORDS, 1 do
		if tonumber(math.floor(GetDistance3D(JobCoords[job][i].x, JobCoords[job][i].y, JobCoords[job][i].z, x, y, z))) < 130 then
			return i
		end
	end

	return 0
end