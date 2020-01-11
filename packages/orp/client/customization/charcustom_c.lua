--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- WebUI
local charcustom = CreateWebUI(0, 0, 0, 0, 1, 30)
SetWebAlignment(charcustom, 0, 0)
SetWebAnchors(charcustom, 0, 0, 1, 1)
SetWebURL(charcustom, "http://asset/"..GetPackageName().."/client/customization/charcustom.html")
SetWebVisibility(charcustom, WEB_HIDDEN)

-- Declarations
local customizationOpen = false
local customizationReady = false

local hairColourOptions = {
    'FF6633', 'FFB399', 'FF33FF', 'FFFF99', '00B3E6',
    'E6B333', '3366E6', '999966', '99FF99', 'B34D4D',
    '80B300', '809900', 'E6B3B3', '6680B3', '66991A',
    'FF99E6', 'CCFF1A', 'FF1A66', 'E6331A', '33FFCC',
    '66994D', 'B366CC', '4D8000', 'B33300', 'CC80CC',
    '66664D', '991AFF', 'E666FF', '4DB3FF', '1AB399',
    'E666B3', '33991A', 'CC9999', 'B3B31A', '00E680',
    '4D8066', '809980', 'E6FF80', '1AFF33', '999933',
    'FF3380', 'CCCC00', '66E64D', '4D80CC', '9900B3',
    'E64D66', '4DB380', 'FF4D4D', '99E6E6', '6666FF'
}

-- Functions
function ToggleCustomization()
	if customizationReady then
		if customizationOpen then
			customizationOpen = false
			SetWebVisibility(charcustom, WEB_HIDDEN)
			ExecuteWebJS(charcustom, 'toggleCustomization();')
		else
			customizationOpen = true
			SetWebVisibility(charcustom, WEB_VISIBLE)
			ExecuteWebJS(charcustom, 'toggleCustomization();')
		end
	end
end

function SetDisplayName(name)
	if customizationReady then
		ExecuteWebJS(charcustom, 'setDisplayName('..name..');')
	end
end

function SetDisplaySliderOptions(id, options)
	if customizationReady then
		ExecuteWebJS(charcustom, "setDisplaySliderOptions("..id..", "..json_encode(options)..");")
	end
end
AddRemoteEvent('SetDisplaySliderOptions', SetDisplaySliderOptions)

-- Events
AddEvent('charcustom:ready', function ()
	customizationReady = true
end)

AddEvent('charcustom:preview', function (id, value)
	-- id = skincolor, hair, haircolor, shirt, pants, shoes
	-- value = the value it should be set to.
end)

AddEvent('charcustom:finish', function (skinColor, ...)
	-- hair, hairColour, shirt, pants, shoes
	if skinColor == 0 then
		-- One of the clothing options were not loaded in the JavaScript.
	else
		local args = {...}
		local hair = args[1]
		local hairColour = args[2]
		local shirt = args[3]
		local pants = args[4]
		local shoes = args[5]

		-- All their options with the corresponding values returned.
	end
end)

AddEvent('charcustom:exit', function ()
	ToggleCustomization()
end)