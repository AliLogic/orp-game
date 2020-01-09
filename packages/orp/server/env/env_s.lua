local EnvTimer
EnvHour = 12
EnvMin = 0
EnvWeather = 1
EnvTemperature = 30

local function UpdateTime()
	local t = os.date ("*t")

	EnvHour = t.hour
	EnvMin = t.min
	EnvTemperature = 30

	if (EnvHour % 6 == 0) then
		EnvWeather = EnvWeather + 1

		if EnvWeather > 12 then
			EnvWeather = 1
		end
	end

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

AddEvent("OnPlayerJoin", function(playerid)
    CallRemoteEvent(playerid, "UpdateClientTime", EnvHour, EnvWeather)
end)
