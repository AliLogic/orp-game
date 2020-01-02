--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--


local cinemaUI = 0

AddRemoteEvent("StartMovie", function(link)
    cinemaUI = CreateRemoteWebUI3D(173465, 198904, 2900, 0, 0, 0, 1920, 1080 , 30)
    LoadWebFile(cinemaUI, link);
    SetWebAlignment(cinemaUI, 0.0, 0.0);
    SetWebAnchors(cinemaUI, 0.0, 0.0, 1.0, 1.0);
	SetWebVisibility(cinemaUI, WEB_VISIBLE)
end)

AddRemoteEvent("EndMovie", function()

	DestroyWebUI(cinemaUI)
end)