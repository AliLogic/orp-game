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