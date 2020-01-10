--[[
Copyright (C) 2019 Onset Roleplay

Developers:
* Bork
* Logic_

Contributors:
* Blue Mountains GmbH
]]--

-- Variables

PlayerClothingData = {}

Tops = {}
Tops[1]		= nil
Tops[2]		= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Knitted_Shirt_LPR"
Tops[3]		= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR"
Tops[4]		= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt2_LPR"
Tops[5]		= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR"
Tops[6]		= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted2_LPR"
Tops[7]		= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted_LPR"
Tops[8]		= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_LPR"
Tops[9]		= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_CH3D_Prisoner_LPR"
Tops[10]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Shirt-Long_LPR"
Tops[11]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Shirt-Short_LPR"


Tops[12]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_SpecialAgent_LPR"
Tops[13]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Pimp_LPR"
Tops[14]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Pimp_Open_LPR"
Tops[15]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Police_LPR"
Tops[16]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Scientist_LPR"
Tops[17]	= "/Game/CharacterModels/Mafia/Meshes/SK_Mafia"

Tops[18]	= "/Game/CharacterModels/Clothing/Meshes/SK_Pullover"
Tops[19]	= "/Game/CharacterModels/Clothing/Meshes/SK_Pullover"
Tops[20]	= "/Game/CharacterModels/Clothing/Meshes/SK_TShirt01"
Tops[21]	= "/Game/CharacterModels/Clothing/Meshes/SK_Undershirt01"
Tops[22]	= "/Game/CharacterModels/Clothing/Meshes/SK_Undershirt01"
Tops[23]	= "/Game/CharacterModels/Clothing/Meshes/SK_ShirtCombo01"

Tops[24]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR"
Tops[25]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR"
Tops[26]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR"
Tops[27]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR"
Tops[28]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR"
Tops[29]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR"
Tops[30]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR"

Pants = {}
Pants[1]	= nil
Pants[2] 	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR"
Pants[3]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_DenimPants_LPR"
Pants[4]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"
Pants[5]	= "/Game/CharacterModels/Clothing/Meshes/SK_Jeans01"
Pants[6]	= "/Game/CharacterModels/Clothing/Meshes/SK_Shorts01"

Shoes = {}
Shoes[1]	= nil
Shoes[2]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"
Shoes[3]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR"
Shoes[4]	= "/Game/CharacterModels/Clothing/Meshes/SK_Shoes01"

Hair = {}
Hair[1]		= nil
Hair[2]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP"
Hair[3]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Scientist_LP"
Hair[4]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR"
Hair[5]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Police_Hair_LPR"
Hair[6]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR"
Hair[7]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_02_LPR"

-- Functions

function CreatePlayerClothingData(player)
	PlayerClothingData[player] = {}

	PlayerClothingData[player].hair = 0
	PlayerClothingData[player].hair_color = RGB(0, 0, 0)
	PlayerClothingData[player].top = 0
	PlayerClothingData[player].pants = 0
	PlayerClothingData[player].shoes = 0
	PlayerClothingData[player].skin_color = 0
end

function DestroyPlayerClothingData(player)
	PlayerClothingData[player] = nil
end

function SetPlayerClothing(player, otherplayer)
	if PlayerData[otherplayer] == nil or PlayerClothingData[otherplayer] == nil then
		return
	end

	AddPlayerChat(player, "calling SetPlayerClothing on server side ("..player..", "..otherplayer..")")

	local r, g, b, a = HexToRGBA(PlayerClothingData[otherplayer].hair_color)

	CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 0, Hair[PlayerClothingData[otherplayer].hair], r, g, b, 255)
	CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 1, Tops[PlayerClothingData[otherplayer].top], 0, 0, 0, 0)
	CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 4, Pants[PlayerClothingData[otherplayer].pants], 0, 0, 0, 0)
	CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 5, Shoes[PlayerClothingData[otherplayer].shoes], 0, 0, 0, 0)

	r, g, b, a = HexToRGBA(PlayerClothingData[otherplayer].skin_color)

	CallRemoteEvent(player, "SetPlayerSkinColor", otherplayer, r, g, b)

	if player == otherplayer then
		for k, v in pairs(GetStreamedPlayersForPlayer(player)) do
			if v ~= player then
				SetPlayerClothing(v, player)
			end
		end
	end

	AddPlayerChat(player, "end calling SetPlayerClothing on server side ("..player..", "..otherplayer..")")
end

-- Commands

AddCommand("haircolor", function (playerid, r, g, b)

	if r == nil or g == nil or b == nil then
		return AddPlayerChat(playerid, "/haircolor <r> <g> <b>")
	end

	r = tonumber(r)
	g = tonumber(g)
	b = tonumber(b)

	PlayerClothingData[playerid].hair_color = RGB(r, g, b)
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("hair", function (playerid, hairid)

	if hairid == nil then
		return AddPlayerChat(playerid, "/hair <1 - 7>")
	end

	hairid = tonumber(hairid)
	PlayerClothingData[playerid].hair = hairid
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("pants", function (playerid, pantid)

	if pantid == nil then
		return AddPlayerChat(playerid, "/pants <1 - 6>")
	end

	pantid = tonumber(pantid)
	PlayerClothingData[playerid].pants = pantid
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("shirt", function (playerid, shirtid)

	if shirtid == nil then
		return AddPlayerChat(playerid, "/shirt <1 - 30>")
	end

	shirtid = tonumber(shirtid)
	PlayerClothingData[playerid].top = shirtid
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("shoe", function (playerid, shoeid)

	if shoeid == nil then
		return AddPlayerChat(playerid, "/shoe <1 - 4>")
	end
	shoeid = tonumber(shoeid)

	PlayerClothingData[playerid].shoes = shoeid
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("skin", function (playerid, r, g, b)

	if r == nil or g == nil or b == nil then
		return AddPlayerChat(playerid, "/skin <r> <g> <b>")
	end

	r = tonumber(r)
	g = tonumber(g)
	b = tonumber(b)

	PlayerClothingData[playerid].skin_color = RGB(r, g, b)
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("pupil", function (playerid, pupil)

	if pupil == nil then
		return AddPlayerChat(playerid, "/pupil <size>")
	end

	AddPlayerChat(playerid, "PUPIL SYNC NOT IN YET.")

	pupil = tonumber(pupil)

	--PlayerClothingData[playerid].pupil = pupil
	SetPlayerClothing(playerid, playerid)
end)

-- Events

AddRemoteEvent("ServerSetPlayerClothing", SetPlayerClothing)

AddEvent("OnPlayerSpawn", function(playerid)

	SetPlayerClothing(playerid, playerid)
end)