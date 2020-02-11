--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_
* Bork

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local EnvHour = 0
local EnvWeather = 0
local EnvFog = 0.0

-- Functions

local function UpdateWeather()

	SetTime(EnvHour)
	SetWeather(EnvWeather)
	SetFogDensity(EnvFog)
end

-- Events

AddRemoteEvent("UpdateClientTime", function (hour, weather, fog)

	EnvHour = hour
	EnvWeather = weather
	EnvFog = fog

	UpdateWeather()
end)

AddEvent("OnPlayerSpawn", function()

	UpdateWeather()
end)