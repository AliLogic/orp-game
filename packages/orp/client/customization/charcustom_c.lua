--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Declarations
local charAngle = 0
local customUI = 0
local customizationOpen = false

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
local function Customization_Toggle(status)

	SetWebVisibility(customUI, WEB_HIDDEN)

	if status then
		customUI = CreateWebUI(0, 0, 0, 0, 1, 30)
		SetWebAlignment(customUI, 0, 0)
		SetWebAnchors(customUI, 0, 0, 1, 1)
		SetWebURL(customUI, "http://asset/"..GetPackageName().."/client/customization/character.html")
		customizationOpen = true
	else
		DestroyWebUI(customUI)
		customUI = 0
		customizationOpen = false
	end
end

local function Customization_Ready(shirts, pants, shoes, hair, face)

	if customUI == 0 or not customizationOpen then
		return
	end

	ExecuteWebJS(customUI, "setShirts("..json_encode(shirts).."")
	ExecuteWebJS(customUI, "setPants("..json_encode(pants).."")
	ExecuteWebJS(customUI, "setShoes("..json_encode(shoes).."")
	ExecuteWebJS(customUI, "setHairAmount("..hair.."")
	ExecuteWebJS(customUI, "setFaceAmount("..face..")")

	SetWebVisibility(customUI, WEB_VISIBLE)
end

local function Rotate(rotation)

	charAngle = charAngle + rotation
	GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body"):SetRelativeRotation(FRotator(0.0, rotation, 0.0))
end

-- Events

AddEvent("OnKeyPress", function (key)

	if key == "A" then
		Rotate(-3)
	elseif key == "D" then
		Rotate(3)
	end
end)

AddEvent("OnWebLoadComplete", function (web)

	if web == customUI then
		SetWebVisibility(WEB_VISIBLE)
		ShowMouseCursor(true)
		SetIgnoreLookInput(true)
		SetIgnoreMoveInput(true)

		CallRemoteEvent("Customization_OnReady")
	end
end)

AddEvent("Customization_OnSubmit", function ()

	CallRemoteEvent("Customization_OnSubmit")
end)

AddRemoteEvent("Customization_Toggle", Customization_Toggle)
AddRemoteEvent("Customization_Ready", Customization_Ready)