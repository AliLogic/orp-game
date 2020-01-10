local EnvTimer
EnvHour = 12
EnvMin = 0
EnvWeather = 1
EnvTemperature = 30

local apikey = '4e444684a31d5a4b581548a901e6f0e8'
local url = 'http://api.openweathermap.org/data/2.5/weather?q=Nevada,us&APPID='

http_set_user_agent("myCustomPlugin/1.0")

-- http://api.openweathermap.org/data/2.5/weather?q=Nevada,us&APPID=4e444684a31d5a4b581548a901e6f0e8

local function UpdateTime()
	local t = os.date ("*t")

	EnvHour = t.hour
	EnvMin = t.min
	EnvTemperature = 30

	if (EnvHour % 6 == 1) then
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
	local res = http_get("http://api.openweathermap.org/data/2.5/weather?q=Nevada,us&APPID="..apikey)

	local f = io.open('HTTP_LOG.txt', "a+")
	if f then
		print('File being written to...')
		f:write(''..res..'\n\n')
		f:close()
	end
end

AddEvent("OnPackageStart", function()
	UpdateWeather()
	UpdateTime()
	EnvTimer = CreateTimer(UpdateTime, 60 * 1000)
end)

AddEvent("OnPackageEnd", function()
	DestroyTimer(EnvTimer)
end)

AddEvent("OnPlayerJoin", function(playerid)
    CallRemoteEvent(playerid, "UpdateClientTime", EnvHour, EnvWeather)
end)
