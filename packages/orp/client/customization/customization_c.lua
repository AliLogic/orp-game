--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Functions

local function SetPlayerClothing(player, part, piece, r, g, b, a)

	local SkeletalMeshComponent
	local pieceName

	SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing"..part)
	pieceName = piece

	SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(pieceName))
	local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)

	if part == 0 then
		SkeletalMeshComponent:SetColorParameterOnMaterials("Hair Color", FLinearColor(r / 255, g / 255, b / 255, a / 255))
	end
end

local function SetPlayerSkinColor(player, r, g, b)

	local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")
	SkeletalMeshComponent:SetColorParameterOnMaterials("Skin Color", FLinearColor(r / 255, g / 255, b / 255, 1))
end

-- Events

AddRemoteEvent("SetPlayerClothing", SetPlayerClothing)
AddRemoteEvent("SetPlayerSkinColor", SetPlayerSkinColor)

AddEvent("OnPlayerStreamIn", function(player, otherplayer)
	CallRemoteEvent("ServerSetPlayerClothing", player, otherplayer)
end)