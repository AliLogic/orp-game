--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--

CINEMA_LINKS = {
	"https://www.youtube.com/embed/4LfJnj66HVQ?controls=0&autoplay=1"
}

AddEvent("OnPackageStart", function()
end)

AddCommand("cinema", function (playerid)
	for _, v in pairs(GetAllPlayers()) do
		CallRemoteEvent(v, "StartMovie", CINEMA_LINKS[1])
	end
end)

AddCommand("board", function (player)
	for _, v in pairs(GetAllPlayers()) do
		CallRemoteEvent(v, "StartImg")
	end
end)