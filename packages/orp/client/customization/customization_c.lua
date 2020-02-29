--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

local TexturesLoaded = {}

-- Functions

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

	for i = 1, #TexturesLoaded, 1 do
		TexturesLoaded[i]:Release()
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