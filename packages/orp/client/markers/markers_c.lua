AddEvent("OnKeyPress", function(key)

	if key == 'E' then
		local markerid = GetPlayerPropertyValue(GetPlayerId(), "marker")

		if markerid ~= false then
			-- local x, y, z = GetPlayerLocation()
			-- local distance = 200 --GetDistance3D(MarkerData[markerid].x, MarkerData[markerid].y, MarkerData[markerid].z, x, y, z)

			-- if distance < 300 then
			-- 	AddPlayerChat("You have pressed the key while in range of marker "..markerid..".") -- nil value, currently problematic.

			-- 	CallRemoteEvent("OnPlayerInteractMarker", markerid)
			-- else
			-- 	SetPlayerPropertyValue(GetPlayerId(), "marker", false)
			-- end
		end
	end
end)

AddEvent("OnPickupStreamIn", function (pickup)

	if (GetPickupPropertyValue(pickup, "type") == "marker") then

		AddPlayerChat("pickup: "..pickup)

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