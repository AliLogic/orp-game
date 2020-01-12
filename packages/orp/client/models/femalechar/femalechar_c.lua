AddEvent("OnPackageStart", function ()
	local pakname = "FemaleChar"
	local res = LoadPak(pakname, "/TeslaEVC/", "../../../OnsetModding/Plugins/TeslaEVC/Content")
	AddPlayerChat("Loading of "..pakname..": "..tostring(res))
end)

function SetPlayerFemale(player)
    local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")
	SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset('/TeslaEVC/TeslaEVC'))
	AddPlayerChat('Set to female')

	for _, v in pairs(GetAllFilesInPak("FemaleChar")) do
		AddPlayerChat(v)
	end
end
AddRemoteEvent('SetPlayerFemale', SetPlayerFemale)