AddEvent("OnKeyPress", function(key)

	if key == 'E' then
		local markerid = GetPlayerPropertyValue(GetPlayerId(), "marker")

		AddPlayerChat("[DEBUG-C] markerid: "..markerid)

		if markerid ~= false then

			AddPlayerChat("[DEBUG-C] marker not false")
			local x, y, z = GetPlayerLocation()
			local distance = 200 --GetDistance3D(MarkerData[markerid].x, MarkerData[markerid].y, MarkerData[markerid].z, x, y, z)

			AddPlayerChat("[DEBUG-C] distance = 200")

			if distance < 300 then
				AddPlayerChat("You have pressed the key while in range of marker "..markerid..".") -- nil value, currently problematic.

				CallRemoteEvent("OnPlayerInteractMarker", markerid)
			else
				SetPlayerPropertyValue(GetPlayerId(), "marker", false)

				AddPlayerChat("[DEBUG-C] set player property value marker false")
			end
		end
	end
end)

AddEvent("OnPickupStreamIn", function (pickup)

	if (GetPickupPropertyValue(pickup, "type") == "marker") then

		AddPlayerChat("[DEBUG-C] pickup: "..pickup)

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