--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic

Contributors:
* Blue Mountains GmbH
]]--


local cinemaUI = 0
local imgUI = 0

AddRemoteEvent("StartMovie", function(link)
    cinemaUI = CreateRemoteWebUI3D(173465, 198904, 2900, 0, 0, 0, 1920, 1080 , 30)
    LoadWebFile(cinemaUI, link)
    SetWebAlignment(cinemaUI, 0.0, 0.0)
    SetWebAnchors(cinemaUI, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(cinemaUI, WEB_VISIBLE)
end)

AddRemoteEvent("StartImg", function () 
    -- 123652, 96768, 1671
    imgUI = CreateWebUI3D(123660, 96735, 1671, 0, 125, 0, 592, 333, 1)
    LoadWebFile(imgUI, "http://asset/"..GetPackageName().."/client/OnsetLogo.png")
    SetWebAlignment(cinemaUI, 0.0, 0.0)
    SetWebAnchors(cinemaUI, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(cinemaUI, WEB_VISIBLE)
end)

AddRemoteEvent("EndMovie", function()
	DestroyWebUI(cinemaUI)
end)