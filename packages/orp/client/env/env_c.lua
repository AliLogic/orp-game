local EnvHour = 0
local EnvWeather = 0

AddRemoteEvent("UpdateClientTime", function (hour, weather)

	EnvHour = hour
	EnvWeather = weather

	SetTime(hour)
	SetWeather(weather)
end)

AddEvent("OnPlayerSpawn", function()

	SetTime(EnvHour)
	SetWeather(EnvWeather)
end)