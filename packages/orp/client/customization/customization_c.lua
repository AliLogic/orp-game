--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Functions

local function SetPlayerClothing(player, part, piece, r, g, b, a)

	AddPlayerChat("calling SetPlayerClothing on client side ("..player..")")

	local SkeletalMeshComponent
	local pieceName

	SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing"..part)
	pieceName = piece

	SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(pieceName))
	local DynamicMaterialInstance = SkeletalMeshComponent:CreateDynamicMaterialInstance(0)

	if part == 0 then
		SkeletalMeshComponent:SetColorParameterOnMaterials("Hair Color", FLinearColor(r / 255, g / 255, b / 255, a / 255))
	end

	AddPlayerChat("end calling SetPlayerClothing on client side ("..player..")")
end

-- Events

AddRemoteEvent("SetPlayerClothing", SetPlayerClothing)

AddEvent("OnPlayerStreamIn", function(player, otherplayer)
	CallRemoteEvent("ServerSetPlayerClothing", player, otherplayer)
end)