local EnvHour
local EnvWeather

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