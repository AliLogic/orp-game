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

-- Functions
local function Customization_Toggle(status)

	if status then
		customUI = CreateWebUI(0, 0, 0, 0, 1, 30)
		SetWebAlignment(customUI, 0, 0)
		SetWebAnchors(customUI, 0, 0, 1, 1)
		SetWebURL(customUI, "http://asset/"..GetPackageName().."/client/customization/character.html")
		SetWebVisibility(customUI, WEB_VISIBLE)
		customizationOpen = true
	else
		SetWebVisibility(customUI, WEB_HIDDEN)
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

AddEvent("Customization_OnSubmit", function (shirt, pant, shoe, skin, skin_tone, hair, hair_colour)

	CallRemoteEvent("Customization_OnSubmit", shirt, pant, shoe, skin, skin_tone, hair, hair_colour)
end)

AddRemoteEvent("Customization_Toggle", Customization_Toggle)
AddRemoteEvent("Customization_Ready", Customization_Ready)