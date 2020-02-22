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

Body = {}
Body[1]		= nil
Body[2]		= "/Game/CharacterModels/Female/Meshes/SK_Female01"
Body[3]		= "/Game/CharacterModels/Female/Meshes/SK_Female02"

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
Tops[19]	= "/Game/CharacterModels/Clothing/Meshes/SK_TShirt01"
Tops[20]	= "/Game/CharacterModels/Clothing/Meshes/SK_Undershirt01"
Tops[21]	= "/Game/CharacterModels/Clothing/Meshes/SK_ShirtCombo01"

Tops[22]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR"

-- female
Tops[23]	= "/Game/CharacterModels/Female/Meshes/SK_Outfit01"
Tops[24]	= "/Game/CharacterModels/Female/Meshes/SK_Outfit02"
Tops[25]	= "/Game/CharacterModels/Female/Meshes/SK_Outfit03"
Tops[26]	= "/Game/CharacterModels/Female/Meshes/SK_Outfit04"
Tops[27]	= "/Game/CharacterModels/Female/Meshes/SK_Outfit05"
Tops[28]	= "/Game/CharacterModels/Female/Meshes/SK_Outfit06"

Tops[29]	= "/Game/CharacterModels/Female/Meshes/HZN_CH3D_Prison-Guard_LPR"
Tops[30]	= "/Game/CharacterModels/Female/Meshes/HZN_CH3D_Prisoner_LPR"
Tops[31]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_BusinessShoes_LPR"
Tops[32]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_CargoPants_LPR"
Tops[33]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_DenimPants_LPR"
Tops[34]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_FormalJacket_LPR"
Tops[35]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_FormalPants_LPR"
Tops[36]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_FormalShirt_LPR"
Tops[37]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_NormalShoes"
Tops[38]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_Shirt_LPR"
Tops[39]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_Tie_LPR"
Tops[40]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Police_Shirt-Long_LPR"
Tops[41]	= "/Game/CharacterModels/Female/Meshes/HZN_Outfit_Police_Shirt-Short_LPR"
Tops[42]	= "/Game/CharacterModels/Female/Meshes/SK_Armor01"
Tops[43]	= "/Game/CharacterModels/Female/Meshes/SK_Equipment01"
Tops[44]	= "/Game/CharacterModels/Female/Meshes/SK_Jacket01"
Tops[45]	= "/Game/CharacterModels/Female/Meshes/SK_Jacket02"

Pants = {}
Pants[1]	= nil
Pants[2] 	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR"
Pants[3]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_DenimPants_LPR"
Pants[4]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR"
Pants[5]	= "/Game/CharacterModels/Clothing/Meshes/SK_Jeans01"
Pants[6]	= "/Game/CharacterModels/Clothing/Meshes/SK_Shorts01"
-- female
Pants[7]	= "/Game/CharacterModels/Female/Meshes/SK_Pants01"
Pants[8]	= "/Game/CharacterModels/Female/Meshes/SK_Pants02"

Shoes = {}
Shoes[1]	= nil
Shoes[2]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"
Shoes[3]	= "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR"
Shoes[4]	= "/Game/CharacterModels/Clothing/Meshes/SK_Shoes01"
-- female
Shoes[5]	= "/Game/CharacterModels/Female/Meshes/SK_Shoes01"
Shoes[6]	= "/Game/CharacterModels/Female/Meshes/SK_Shoes02"

Hair = {}
Hair[1]		= nil
Hair[2]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP"
Hair[3]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Scientist_LP"
Hair[4]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR"
Hair[5]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Police_Hair_LPR"
Hair[6]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR"
Hair[7]		= "/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_02_LPR"
-- female
Hair[8]		= "/Game/CharacterModels/Female/Meshes/SK_Hair01"
Hair[9]		= "/Game/CharacterModels/Female/Meshes/SK_Hair02"
Hair[10]	= "/Game/CharacterModels/Female/Meshes/SK_Hair03"

-- Functions

function CreatePlayerClothingData(player)
	PlayerClothingData[player] = {}

	PlayerClothingData[player].hair = 0
	PlayerClothingData[player].hair_color = RGB(0, 0, 0)
	PlayerClothingData[player].top = 0
	PlayerClothingData[player].pants = 0
	PlayerClothingData[player].shoes = 0
	PlayerClothingData[player].skin_color = RGB(255, 255, 255)
end

function DestroyPlayerClothingData(player)
	PlayerClothingData[player] = nil
end

function SetPlayerClothing(player, otherplayer)
	if PlayerData[otherplayer] == nil or PlayerClothingData[otherplayer] == nil then
		return
	end

	local r, g, b, a = HexToRGBA(PlayerClothingData[otherplayer].hair_color)

	CallRemoteEvent(player, "SetPlayerBody", otherplayer, 1, Body[PlayerClothingData[otherplayer].body])
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
end

function CreatePlayerClothing(player)
	local query = mariadb_prepare(sql, "INSERT INTO clothing (id) VALUES (?);",
		PlayerData[player].id
	)
	mariadb_async_query(sql, query)
end

function SavePlayerClothing(player)
	if PlayerData[player] == nil or PlayerClothingData[player] == nil then
		return
	end

	if PlayerData[player].id == 0 or PlayerData[player].logged_in == false then
		return
	end

	local query = mariadb_prepare(sql, "UPDATE clothing SET hair_color = '?', hair = ?, top = ?, pants = ?, shoes = ?, skin_color = '?' WHERE id = ? LIMIT 1;",
		PlayerClothingData[player].hair_color,
		PlayerClothingData[player].hair,
		PlayerClothingData[player].top,
		PlayerClothingData[player].pants,
		PlayerClothingData[player].shoes,
		PlayerClothingData[player].skin_color,
		PlayerData[player].id
	)
	mariadb_query(sql, query)

	return
end

local function OnClothingLoad(player)

	if mariadb_get_row_count() ~= 0 then
		PlayerClothingData[player].hair_color = mariadb_get_value_name_int(1, "hair_color")
		PlayerClothingData[player].hair = mariadb_get_value_name_int(1, "hair")
		PlayerClothingData[player].top = mariadb_get_value_name_int(1, "top")
		PlayerClothingData[player].pants = mariadb_get_value_name_int(1, "pants")
		PlayerClothingData[player].shoes = mariadb_get_value_name_int(1, "shoes")
		PlayerClothingData[player].skin_color = mariadb_get_value_name_int(1, "skin_color")
	else
		CreatePlayerClothing(player)
	end
end

function LoadPlayerClothing(player)

	local query = mariadb_prepare(sql, "SELECT * FROM clothing WHERE id = ? LIMIT 1;",
		PlayerData[player].id
	)

	mariadb_async_query(sql, query, OnClothingLoad, player)
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
		return AddPlayerChat(playerid, "/shirt <1 - 22>")
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

AddCommand("female", function (player, body)
	--CallRemoteEvent(player, 'SetPlayerFemale', player)

	if body == nil then
		return AddPlayerChat(player, "/female <1 - 3>")
	end

	body = tonumber(body)

	PlayerClothingData[player].body = body
	SetPlayerClothing(player, player)
end)

-- Events

AddRemoteEvent("ServerSetPlayerClothing", SetPlayerClothing)

AddEvent("OnPlayerSpawn", function(playerid)

	Delay(1000, function()
		SetPlayerClothing(playerid, playerid)
	end)
end)