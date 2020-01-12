--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Raw - creator of this Tesla EVC.
* Blue Mountains GmbH
]]--

AddEvent("OnPackageStart", function ()
	local pakname = "TeslaEVC"

	local res = LoadPak(pakname, "/TeslaEVC/", "../../../OnsetModding/Plugins/TeslaEVC/Content")
	AddPlayerChat("Loading of "..pakname..": "..tostring(res))

	res = ReplaceObjectModelMesh(39, "/TeslaEVC/TeslaEVC") 
	AddPlayerChat("ReplaceObjectModelMesh: "..tostring(res))

	res = SetObjectScale(39, 0.75, 0.75, 0.75)
	AddPlayerChat("SetObjectScale: "..tostring(res))
end)