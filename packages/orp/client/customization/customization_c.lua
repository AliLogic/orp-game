--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local charAngle = 0
local customUI = 0
local customizationOpen = false
local TexturesLoaded = {}

-- Functions

local function Rotate(rotation)

	charAngle = charAngle + rotation
	GetPlayerSkeletalMeshComponent(GetPlayerId(), "Body"):SetRelativeRotation(FRotator(0.0, charAngle, 0.0))
end

local function Customization_Toggle(status)

	if status then
		customUI = CreateWebUI(0, 0, 0, 0, 1, 30)
		SetWebAlignment(customUI, 0, 0)
		SetWebAnchors(customUI, 0, 0, 1, 1)
		SetWebURL(customUI, "http://asset/"..GetPackageName().."/client/customization/character.html")
		SetWebVisibility(customUI, WEB_VISIBLE)
		SetInputMode(INPUT_GAMEANDUI)
		customizationOpen = true
	else
		SetInputMode(INPUT_GAME)
		SetWebVisibility(customUI, WEB_HIDDEN)
		DestroyWebUI(customUI)
		customUI = 0
		customizationOpen = false
		charAngle = 0
	end

	Rotate(0)
end

local function Customization_Ready(shirts, pants, shoes, hair, face)

	if customUI == 0 or not customizationOpen then
		return
	end

	ExecuteWebJS(customUI, "setShirts("..json_encode(shirts)..")")
	ExecuteWebJS(customUI, "setPants("..json_encode(pants)..")")
	ExecuteWebJS(customUI, "setShoes("..json_encode(shoes)..")")
	ExecuteWebJS(customUI, "setHairAmount("..hair..")")
	ExecuteWebJS(customUI, "setFaceAmount("..face..")")

	SetWebVisibility(customUI, WEB_VISIBLE)
end

local function SetPlayerClothing(player, part, piece, r, g, b, a)

	local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing"..part)
	SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(piece))

	if part == 0 then
		SkeletalMeshComponent:SetColorParameterOnMaterials("Hair Color", FLinearColor(r, g, b, a))
	end
end

local function SetPlayerSkinColor(player, r, g, b)

	local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")
	SkeletalMeshComponent:SetColorParameterOnMaterials("Skin Color", FLinearColor(r / 255, g / 255, b / 255, 1))
end

local function SetPlayerBody(player, body)

	local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")
	SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(body))
end

local function SetPlayerPupilScale(player, scale)
	local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")
	SkeletalMeshComponent:SetFloatParameterOnMaterials("PupilScale", scale)
end

local function SetPlayerClothingTexture(player, part, texture)

	if texture ~= 1 then -- Since the first index in TexturesLoaded is nill
		local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing"..part)
		SkeletalMeshComponent:SetMaterial(0, UMaterialInterface.LoadFromAsset("/Game/Scripting/Materials/MI_GenericTexture"))
		local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)
		DynamicMaterialInstance:SetTextureParameter("BaseColorTexture", TexturesLoaded[texture])
		-- DynamicMaterialInstance:SetColorParameter("Roughness", FLinearColor(0.75,0.75,0.75,0.0))
	end
end

-- Events

AddRemoteEvent("SetPlayerClothing", SetPlayerClothing)
AddRemoteEvent("SetPlayerSkinColor", SetPlayerSkinColor)
AddRemoteEvent("SetPlayerBody", SetPlayerBody)
AddRemoteEvent("SetPlayerPupilScale", SetPlayerPupilScale)
AddRemoteEvent("SetPlayerClothingTexture", SetPlayerClothingTexture)

AddEvent("OnPackageStart", function()

end)

AddEvent("OnPackageStop", function()

	for i = 2, #TexturesLoaded, 1 do
		TexturesLoaded[i]:ReleaseTexture()
	end
end)

AddRemoteEvent("LoadPlayerClothingTextures", function (textures)

	table.insert(TexturesLoaded, 0) -- this is a workaround as Lua uses nil to empty/ reset tables
	for k, v in pairs(textures) do
		table.insert(TexturesLoaded, UTexture2D.LoadFromFile(v))
	end
end)

AddEvent("OnPlayerStreamIn", function(player, otherplayer)

	CallRemoteEvent("ServerSetPlayerClothing", player, otherplayer)
end)

AddEvent("OnKeyPress", function (key)

	if not customizationOpen then
		return
	end

	if key == "A" then
		Rotate(-3)
	elseif key == "D" then
		Rotate(3)
	end
end)

AddEvent("Customization_DocumentReady", function ()
	SetInputMode(INPUT_GAMEANDUI)
	SetWebVisibility(customUI, WEB_VISIBLE)
	ShowMouseCursor(true)
	SetIgnoreLookInput(true)
	SetIgnoreMoveInput(true)

	CallRemoteEvent("Customization_OnReady")
end)

AddEvent("Customization_OnSubmit", function (shirt, pant, shoe, skin, hair)

	AddPlayerChat("[client] Customization_OnSubmit")

	CallRemoteEvent("Customization_OnSubmit", shirt, pant, shoe, skin, hair)

	Customization_Toggle(false)
end)

-- AddEvent("Customization_OnSubmit", function (shirt, pant, shoe, skin, skin_tone, hair, hair_colour)

-- 	CallRemoteEvent("Customization_OnSubmit", shirt, pant, shoe, skin, skin_tone, hair, hair_colour)
-- end)

AddRemoteEvent("Customization_Toggle", Customization_Toggle)
AddRemoteEvent("Customization_Ready", Customization_Ready)