--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--

CINEMA_LINKS = {
	"https://www.youtube.com/embed/RsjMP8wJEGg?autoplay=1"
}

AddEvent("OnPackageStart", function()
end)

AddCommand("cinema", function (playerid)
	for _, v in pairs(GetAllPlayers()) do
		CallRemoteEvent(v, "StartMovie", CINEMA_LINKS[1])
	end
end)

AddEvent("OnPlayerJoin", function(playerid)

	CallRemoteEvent(playerid, "StartImg")
end)