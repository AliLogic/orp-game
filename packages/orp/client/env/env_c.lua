AddRemoteEvent("UpdateClientTime", function (hour, weather)

	SetTime(hour)
	SetWeather(weather)
end)