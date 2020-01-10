local EnvTimer
EnvHour = 12
EnvMin = 0
EnvWeather = 1
EnvTemperature = 30

local apikey = '4e444684a31d5a4b581548a901e6f0e8'
local url = 'http://api.openweathermap.org/data/2.5/weather?q=Nevada,us&APPID='
-- http://api.openweathermap.org/data/2.5/weather?q=Nevada,us&APPID=4e444684a31d5a4b581548a901e6f0e8

local function UpdateTime()
	local t = os.date ("*t")

	EnvHour = t.hour
	EnvMin = t.min
	EnvTemperature = 30

	if (EnvHour % 6 == 1) then
		UpdateWeather()
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

function UpdateWeather() 
	local res = http_get(url + apikey)
	print("Response: "..res.body)
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
