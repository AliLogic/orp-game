AddEvent("OnKeyPress", function(key)

	-- Cancel out if player is in a vehicle
	if not IsPlayerInVehicle() and key == 'E' then

		local pickupid = GetPlayerPropertyValue(GetPlayerId(), "pickupid")
		if pickupid ~= false and pickupid ~= 0 then

			local plX, plY, plZ = GetPlayerLocation()
			local pkX, pkY, pkZ = GetPickupLocation(pickupid)

			if pkX ~= nil then
				local distance = GetDistance3D(plX, plY, plZ, pkX, pkY, pkZ)

				if distance < 300 then
					AddPlayerChat("You have pressed the key while in range of pickupid "..pickupid..".") -- nil value, currently problematic.

					CallRemoteEvent("OnPlayerInteractMarker", pickupid)
				else
					SetPlayerPropertyValue(GetPlayerId(), "pickupid", 0)
				end
			end
		end
	end
end)

AddEvent("OnPickupStreamIn", function (pickup)

	if (GetPickupPropertyValue(pickup, "markerid") ~= false) then

		local r = tonumber(GetPickupPropertyValue(pickup, "r"))
		local g = tonumber(GetPickupPropertyValue(pickup, "g"))
		local b = tonumber(GetPickupPropertyValue(pickup, "b"))
		local a = tonumber(GetPickupPropertyValue(pickup, "a"))

		SetPickupColor(pickup, r, g, b, a)
	end
end)

AddEvent("OnPickupStreamOut", function (pickup)

	if pickup == GetPlayerPropertyValue(GetPlayerId(), "pickupid") then
		SetPlayerPropertyValue(GetPlayerId(), "pickupid", 0)
	end
end)

function SetPickupColor(pickup, r, g, b, a, materialslot)
	materialslot = materialslot or 0
	local StaticMeshComponent = GetPickupStaticMeshComponent(pickup)
	StaticMeshComponent:SetMaterial(materialslot, UMaterialInterface.LoadFromAsset("/Game/Scripting/Materials/MI_TranslucentLit"))
	local MaterialInstance = StaticMeshComponent:CreateDynamicMaterialInstance(materialslot)

	r = r / 255
	g = g / 255
	b = b / 255
	a = a / 255

	MaterialInstance:SetColorParameter("BaseColor", FLinearColor(r, g, b, a))
end

AddEvent("OnPickupNetworkUpdatePropertyValue", function(pickup, PropertyName, PropertyValue)

	if (GetPickupPropertyValue(pickup, "markerid") ~= false) then

		local r = tonumber(GetPickupPropertyValue(pickup, "r"))
		local g = tonumber(GetPickupPropertyValue(pickup, "g"))
		local b = tonumber(GetPickupPropertyValue(pickup, "b"))
		local a = tonumber(GetPickupPropertyValue(pickup, "a"))

		SetPickupColor(pickup, r, g, b, a)
	end
end)