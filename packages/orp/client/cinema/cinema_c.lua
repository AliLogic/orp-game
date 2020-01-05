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
	AddPlayerChat("cinemaUI should no longer equal to 0.")
	cinemaUI = CreateRemoteWebUI3D(173465, 198904, 2900, 0, 0, 0, 1920, 1080 , 30)
	LoadWebFile(cinemaUI, link)
	SetWebAlignment(cinemaUI, 0.0, 0.0)
	SetWebAnchors(cinemaUI, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(cinemaUI, WEB_VISIBLE)
end)

AddRemoteEvent("StartImg", function ()
	if imgUI ~= 0 then
		DestroyWebUI(imgUI)
	end

	imgUI = CreateWebUI3D(123669, 96744, 1686, 0, 125, 0, 595, 310, 1)
	LoadWebFile(imgUI, "http://asset/"..GetPackageName().."/client/charui/img/OnsetLogo.png")
	SetWebAlignment(cinemaUI, 0.0, 0.0)
	SetWebAnchors(cinemaUI, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(cinemaUI, WEB_VISIBLE)
end)

AddRemoteEvent("EndMovie", function()
	DestroyWebUI(cinemaUI)
end)