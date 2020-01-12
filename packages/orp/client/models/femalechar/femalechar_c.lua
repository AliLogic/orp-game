AddEvent("OnPackageStart", function ()
	local pakname = "FemaleChar"
	local res = LoadPak(pakname, "/FemaleChar/", "../../../OnsetModding/Plugins/FemaleChar/Content")
	AddPlayerChat("Loading of "..pakname..": "..tostring(res))
end)

function SetPlayerFemale(player)
    local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")
	SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset('/FemaleChar/FemaleChar'))
	AddPlayerChat('Set to female')
end
AddRemoteEvent('SetPlayerFemale', SetPlayerFemale)
