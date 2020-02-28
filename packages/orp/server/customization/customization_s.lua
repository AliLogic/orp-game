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

Textures = {
	nil,
	GetPackageName().."/client/customization/textures/lv.jpg",
	GetPackageName().."/client/customization/textures/supreme_fondosdepantalla.jpg",
	GetPackageName().."/client/customization/textures/supreme_floral.jpg"
}

Outfit = {
	"/Game/CharacterModels/Female/Meshes/SK_Outfit01", -- Female
	"/Game/CharacterModels/Female/Meshes/SK_Outfit02",
	"/Game/CharacterModels/Female/Meshes/SK_Outfit03",
	"/Game/CharacterModels/Female/Meshes/SK_Outfit04",
	"/Game/CharacterModels/Female/Meshes/SK_Outfit05",
	"/Game/CharacterModels/Female/Meshes/SK_Outfit06",

	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_SpecialAgent_LPR", -- Male
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Pimp_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Pimp_Open_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Police_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Set_Scientist_LPR",
	"/Game/CharacterModels/Mafia/Meshes/SK_Mafia"
}

Body = {
	nil,
	"/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal01_LPR", -- Male
	"/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal02_LPR",
	"/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal03_LPR",
	"/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal04_LPR",

	"/Game/CharacterModels/Female/Meshes/SK_Female01", -- Female
	"/Game/CharacterModels/Female/Meshes/SK_Female02",
	"/Game/CharacterModels/Female/Meshes/SK_Female03",
}

Tops = {
	nil,
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Knitted_Shirt_LPR", -- Male
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalShirt2_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted2_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_Knitted_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_TShirt_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_CH3D_Prisoner_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Shirt-Long_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Shirt-Short_LPR",
	"/Game/CharacterModels/Clothing/Meshes/SK_Pullover",
	"/Game/CharacterModels/Clothing/Meshes/SK_TShirt01",
	"/Game/CharacterModels/Clothing/Meshes/SK_Undershirt01",
	"/Game/CharacterModels/Clothing/Meshes/SK_ShirtCombo01",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_Shirt_LPR",

	"/Game/CharacterModels/Female/Meshes/HZN_CH3D_Prison-Guard_LPR", -- Female
	"/Game/CharacterModels/Female/Meshes/HZN_CH3D_Prisoner_LPR",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Police_Shirt-Long_LPR",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Police_Shirt-Short_LPR",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_FormalJacket_LPR",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_FormalShirt_LPR",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_Shirt_LPR",
	"/Game/CharacterModels/Female/Meshes/SK_Jacket01",
	"/Game/CharacterModels/Female/Meshes/SK_Jacket02"
}

Equipment = {
	nil,
	"/Game/CharacterModels/Female/Meshes/SK_Armor01", -- Female
	"/Game/CharacterModels/Female/Meshes/SK_Equipment01",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_Tie_LPR"
}

Pants = {
	nil,
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_CargoPants_LPR", -- Male
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_DenimPants_LPR",
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR",
	"/Game/CharacterModels/Clothing/Meshes/SK_Jeans01",
	"/Game/CharacterModels/Clothing/Meshes/SK_Shorts01",

	"/Game/CharacterModels/Female/Meshes/SK_Pants01", -- Female
	"/Game/CharacterModels/Female/Meshes/SK_Pants02",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_CargoPants_LPR",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_DenimPants_LPR",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_FormalPants_LPR"
}

Shoes = {
	nil,
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR", -- Male
	"/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_NormalShoes_LPR",
	"/Game/CharacterModels/Clothing/Meshes/SK_Shoes01",

	"/Game/CharacterModels/Female/Meshes/SK_Shoes01", -- Female
	"/Game/CharacterModels/Female/Meshes/SK_Shoes02",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_BusinessShoes_LPR",
	"/Game/CharacterModels/Female/Meshes/HZN_Outfit_Piece_NormalShoes"
}

Hair = {
	nil,
	"/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Business_LP",
	"/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Hair_Scientist_LP",
	"/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_01_LPR",
	"/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Police_Hair_LPR",
	"/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_03_LPR",
	"/Game/CharacterModels/SkeletalMesh/HZN_CH3D_Normal_Hair_02_LPR",

	"/Game/CharacterModels/Female/Meshes/SK_Hair01", -- female
	"/Game/CharacterModels/Female/Meshes/SK_Hair02",
	"/Game/CharacterModels/Female/Meshes/SK_Hair03"
}

-- Functions

function CreatePlayerClothingData(player)
	PlayerClothingData[player] = {}

	PlayerClothingData[player].hair = 1
	PlayerClothingData[player].hair_color = RGB(0, 0, 0)
	PlayerClothingData[player].top = 1
	PlayerClothingData[player].pants = 1
	PlayerClothingData[player].shoes = 1
	PlayerClothingData[player].skin_color = RGB(255, 255, 255)
	PlayerClothingData[player].body = 1
	PlayerClothingData[player].pupil = 1.0
	PlayerClothingData[player].equipment = 1
	PlayerClothingData[player].texture = 1
	PlayerClothingData[player].outfit = 1
end

function DestroyPlayerClothingData(player)
	PlayerClothingData[player] = nil
end

function SetPlayerClothing(player, otherplayer)
	if PlayerData[otherplayer] == nil or PlayerClothingData[otherplayer] == nil then
		return
	end

	local r, g, b, a = HexToRGBA(PlayerClothingData[otherplayer].hair_color)

	CallRemoteEvent(player, "SetPlayerPupilScale", otherplayer, PlayerClothingData[otherplayer].pupil)
	CallRemoteEvent(player, "SetPlayerBody", otherplayer, Body[PlayerClothingData[otherplayer].body])
	CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 0, Hair[PlayerClothingData[otherplayer].hair], r, g, b, 255)

	if (PlayerClothingData[otherplayer].outfit == 1) then
		CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 1, Tops[PlayerClothingData[otherplayer].top], 0, 0, 0, 0)
		CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 2, Equipment[PlayerClothingData[otherplayer].equipment], 0, 0, 0, 0)
		CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 4, Pants[PlayerClothingData[otherplayer].pants], 0, 0, 0, 0)
		CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 5, Shoes[PlayerClothingData[otherplayer].shoes], 0, 0, 0, 0)

		CallRemoteEvent(player, "SetPlayerClothingTexture", otherplayer, 1, PlayerClothingData[otherplayer].texture)
	else
		CallRemoteEvent(player, "SetPlayerClothing", otherplayer, 1, Outfit[PlayerClothingData[otherplayer].outfit], 0, 0, 0, 0)
	end

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

	local query = mariadb_prepare(sql, "UPDATE clothing SET hair_color = '?', hair = ?, top = ?, pants = ?, shoes = ?, skin_color = '?', body = '?', equipment = '?' WHERE id = ? LIMIT 1;",
		PlayerClothingData[player].hair_color,
		PlayerClothingData[player].hair,
		PlayerClothingData[player].top,
		PlayerClothingData[player].pants,
		PlayerClothingData[player].shoes,
		PlayerClothingData[player].skin_color,
		PlayerClothingData[player].body,
		PlayerClothingData[player].equipment,
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
		PlayerClothingData[player].body = mariadb_get_value_name_int(1, "body")
		PlayerClothingData[player].equipment = mariadb_get_value_name_int(1, "equipment")
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
		return AddPlayerChat(playerid, "/hair <1 - "..#Hair..">")
	end

	hairid = tonumber(hairid)
	PlayerClothingData[playerid].hair = hairid
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("pants", function (playerid, pantid)

	if pantid == nil then
		return AddPlayerChat(playerid, "/pants <1 - "..#Pants..">")
	end

	pantid = tonumber(pantid)
	PlayerClothingData[playerid].pants = pantid
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("shirt", function (playerid, shirtid)

	if shirtid == nil then
		return AddPlayerChat(playerid, "/shirt <1 - "..#Tops..">")
	end

	shirtid = tonumber(shirtid)
	PlayerClothingData[playerid].top = shirtid
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("shoe", function (playerid, shoeid)

	if shoeid == nil then
		return AddPlayerChat(playerid, "/shoe <1 - "..#Shoes..">")
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

	pupil = tonumber(pupil)

	PlayerClothingData[playerid].pupil = pupil
	SetPlayerClothing(playerid, playerid)
end)

AddCommand("body", function (player, body)

	if body == nil then
		return AddPlayerChat(player, "/body <1 - "..#Body..">")
	end

	body = tonumber(body)

	PlayerClothingData[player].body = body
	SetPlayerClothing(player, player)
end)

AddCommand("equip", function (player, equip)

	if equip == nil then
		return AddPlayerChat(player, "/equip <1 - "..#Equipment..">")
	end

	equip = tonumber(equip)

	PlayerClothingData[player].equipment = equip
	SetPlayerClothing(player, player)
end)

AddCommand("texture", function (player, texture)

	if texture == nil then
		return AddPlayerChat(player, "/texture <1 - "..#Textures..">")
	end

	texture = tonumber(texture)

	PlayerClothingData[player].texture = texture
	SetPlayerClothing(player, player)
end)

AddCommand("outfit", function (player, outfit)

	if outfit == nil then
		return AddPlayerChat(player, "/outfit <1 - "..#Outfit..">")
	end

	outfit = tonumber(outfit)

	PlayerClothingData[player].outfit = outfit
	SetPlayerClothing(player, player)
end)

-- Events

AddRemoteEvent("ServerSetPlayerClothing", SetPlayerClothing)

AddEvent("OnPlayerSpawn", function(playerid)

	Delay(1000, function()
		SetPlayerClothing(playerid, playerid)
	end)
end)

AddEvent("OnPlayerJoin", function(player)

	CallRemoteEvent(player, "LoadPlayerClothingTextures", Textures)
end)