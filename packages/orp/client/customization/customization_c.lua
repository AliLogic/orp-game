--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Functions

local function SetPlayerClothing(player, part, piece, r, g, b, a)

	local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing"..part)

	SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(piece))
	-- local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)

	if part == 0 then
		SkeletalMeshComponent:SetColorParameterOnMaterials("Hair Color", FLinearColor(r / 255, g / 255, b / 255, a / 255))
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

-- Events

AddRemoteEvent("SetPlayerClothing", SetPlayerClothing)
AddRemoteEvent("SetPlayerSkinColor", SetPlayerSkinColor)
AddRemoteEvent("SetPlayerBody", SetPlayerBody)
AddRemoteEvent("SetPlayerPupilScale", SetPlayerPupilScale)

AddEvent("OnPlayerStreamIn", function(player, otherplayer)
	CallRemoteEvent("ServerSetPlayerClothing", player, otherplayer)
end)