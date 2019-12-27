AddEvent("OnKeyPress", function(key)

	if key == 'E' then
		local pickupid = tonumber(GetPlayerPropertyValue(GetPlayerId(), "pickupid"))

		if pickupid ~= false then

			local plX, plY, plZ = GetPlayerLocation()
			local pkX, pkY, pkZ = GetPickupLocation(pickupid)
			local distance = GetDistance3D(plX, plY, plZ, pkX, pkY, pkZ)

			if distance < 300 then
				AddPlayerChat("You have pressed the key while in range of pickupid "..pickupid..".") -- nil value, currently problematic.

				CallRemoteEvent("OnPlayerInteractMarker", pickupid)
			else
				SetPlayerPropertyValue(GetPlayerId(), "pickupid", false)
			end
		end
	end
end)

AddEvent("OnPickupStreamIn", function (pickup)

	if (GetPickupPropertyValue(pickup, "markerid") ~= false) then

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