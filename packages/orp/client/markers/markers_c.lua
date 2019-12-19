AddEvent("OnPickupStreamIn", function (pickup)

	if (GetPickupPropertyValue(pickup, "type") == "marker") then

		local r = tonumber(GetPickupPropertyValue(pickup, "r"))
		local g = tonumber(GetPickupPropertyValue(pickup, "g"))
		local b = tonumber(GetPickupPropertyValue(pickup, "b"))
		local a = tonumber(GetPickupPropertyValue(pickup, "a"))

		SetPickupColor(pickup, r, g, b, a)
	end
end)

function SetPickupColor(pickup, r, g, b, a, materialslot)
	materialslot = materialslot or 0
	local StaticMeshComponent = GetPickupStaticMeshComponent(pickup)
	StaticMeshComponent:SetMaterial(materialslot, UMaterialInterface.LoadFromAsset("/Game/Scripting/Materials/MI_TranslucentLit"))
	local MaterialInstance = StaticMeshComponent:CreateDynamicMaterialInstance(materialslot)
	MaterialInstance:SetColorParameter("BaseColor", FLinearColor(r, g, b, a))
end