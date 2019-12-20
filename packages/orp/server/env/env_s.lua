local EnvTimer
local EnvHour
local EnvMin
local EnvWeather
local EnvTemperature

local function UpdateTime()
	local t = os.date ("*t")

	EnvHour = t.hour
	EnvMin = t.min
	EnvTemperature = 30
	EnvWeather = 1

	for k, v in pairs(GetAllPlayers()) do
		CallRemoteEvent(v, "UpdateClientTime", EnvHour, EnvWeather)
	end
end

AddEvent("OnPackageStart", function()

	UpdateTime()
	EnvTimer = CreateTimer(UpdateTime, 60 * 1000)
end)

AddEvent("OnPackageEnd", function()

	DestroyTimer(EnvTimer)
end)