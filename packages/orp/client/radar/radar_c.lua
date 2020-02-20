--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_
* dictateurfou (for the original radar)

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local callBackLoad = {}
local mapUI = 0
local load = false
local uniqId = 0

-- Functions

local function forceUIFocus(ui)
	local allUi = GetAllWebUI()
	for k,v in pairs(allUi) do
		if v ~= ui then
			if GetWebVisibility(v) ~= WEB_HIDDEN then
				SetWebVisibility(v, WEB_HITINVISIBLE)
			end
		end
	end
	SetWebVisibility(ui, WEB_VISIBLE)
end

function createBlip(id, type, pos)
	if id == nil then
		id = uniqId
		uniqId = uniqId + 1;
	end

	local jsonPos = '{"x":'..pos.x..',"y":'..pos.y..'}'
	if load == false then
		table.insert(callBackLoad,"createBlip('"..id.."','"..type.."',"..jsonPos..")")
	else
		ExecuteWebJS(mapUI,"createBlip('"..id.."','"..type.."',"..jsonPos..")")
	end
	return id
end
AddFunctionExport("createBlip", createBlip)

function removeBlip(id)
	ExecuteWebJS(mapUI,"removeBlip('"..id.."')")
end
AddFunctionExport("removeBlip", removeBlip)

-- Events

AddEvent("onsetMap:unfocus",function()
	SetInputMode(INPUT_GAME)
	ShowMouseCursor(false)
	SetWebVisibility(mapUI, WEB_HITINVISIBLE)
end)

AddEvent("onsetMap:focus",function()
	SetInputMode(INPUT_GAMEANDUI)
	forceUIFocus(mapUI)
	ShowMouseCursor(true)
end)

AddEvent("OnKeyPress", function(key)
	if key == 'M' then
		ExecuteWebJS(mapUI,"switchMap()")
	end
end)

AddEvent("OnRenderHUD", function()
	local x, y, _ = GetPlayerLocation()
	local _, heading = GetCameraRotation()
	heading = heading + 90
	if (heading < 0) then
		heading = heading + 360
	end
	ExecuteWebJS(mapUI,"changePlayerPosition("..x..","..y..","..heading..");")
end)

AddEvent("OnPackageStart", function()
	SetWebAlignment(mapUI, 0, 0)
	SetWebAnchors(mapUI, 0, 0, 1, 1)
	SetWebURL(mapUI, "http://asset/"..GetPackageName().."/client/radar/radar.html")
	SetWebVisibility(mapUI, WEB_HIDDEN)
end)

AddEvent("OnWebLoadComplete",function(web)
	if web == mapUI then
		for k,v in pairs(callBackLoad) do
			AddPlayerChat(v);
			ExecuteWebJS(mapUI,v)
		end
	end
end)

AddEvent('charui:spawn', function (slot)

	SetWebVisibility(mapUI, WEB_HITINVISIBLE)
end)