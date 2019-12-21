local EnvTimer
EnvHour = 12
EnvMin = 0
EnvWeather = 1
local EnvTemperature

local function UpdateTime()
	local t = os.date ("*t")

	EnvHour = t.hour
	EnvMin = t.min
	EnvTemperature = 30
	EnvWeather = 1

	AddPlayerChatAll("[DEBUG-S] HOUR: "..EnvHour.." MIN: "..EnvMin.." WEATHER: "..EnvWeather)

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