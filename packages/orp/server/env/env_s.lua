--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_
* Bork

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local EnvTimer
EnvHour = 12
EnvMin = 0
EnvWeather = 1
EnvTemperature = 30
EnvFog = 0

local apikey = '4e444684a31d5a4b581548a901e6f0e8'
local url = 'http://api.openweathermap.org/data/2.5/weather?q=Nevada,us&APPID='

-- http_set_user_agent("myCustomPlugin/1.0")

-- http://api.openweathermap.org/data/2.5/weather?q=Nevada,us&APPID=4e444684a31d5a4b581548a901e6f0e8

-- Functions

local function UpdateTime()
	local t = os.date ("*t")

	-- EnvHour = t.hour
	EnvMin = t.min
	EnvTemperature = 30

	if ((EnvHour % 6) == 0 and EnvMin == 0) then
		EnvWeather = EnvWeather + 1

		if EnvWeather > 12 then
			EnvWeather = 1
		end
	end

	--[[
		fog density weather ids
		701 - mist
		711 - smoke
		721 - haze
		741 - fog
		600 ~ 622 - snow
		200 ~ 232 - thunderstorm
	]]--

	AddPlayerChatAll("[DEBUG-S] HOUR: "..EnvHour.." MIN: "..EnvMin.." WEATHER: "..EnvWeather.." FOG: "..EnvFog)

	for k, v in pairs(GetAllPlayers()) do
		CallRemoteEvent(v, "UpdateClientTime", EnvHour, EnvWeather, EnvFog)
	end
end

function UpdateWeather()
	local res = http_get("http://api.openweathermap.org/data/2.5/weather?q=Nevada,us&APPID="..apikey)
	res = json_decode(res.body)

	print('Weather ID: '..json_decode(res))
end

AddEvent("OnPackageStart", function()
	-- UpdateWeather()
	UpdateTime()
	EnvTimer = CreateTimer(UpdateTime, 60 * 1000)
end)

AddEvent("OnPackageEnd", function()
	DestroyTimer(EnvTimer)
end)

AddEvent("OnPlayerJoin", function(playerid)
	Delay(1000, function () -- A small delay to compensate for less intrusive behavior for the player
		CallRemoteEvent(playerid, "UpdateClientTime", EnvHour, EnvWeather, EnvFog)
	end)
end)