local web = 0

AddEvent("OnPackageStop", function ()
	DestroyWebUI(web)
end)

AddRemoteEvent("DestroyGUI", function ()
	DestroyWebUI(web)
end)

AddEvent("OnPackageStart", function()
	-- ShowHealthHUD(false)
	web = CreateWebUI(0, 0, 0, 0, 1, 1)
	SetWebAlignment(web, 0, 0)
	SetWebAnchors(web, 0, 0, 1, 1)
	SetWebURL(web, "http://asset/"..GetPackageName().."/client/gui/gui.html")
	SetWebVisibility(web, WEB_HITINVISIBLE)
end)

-- function SetGUIHealth(health)
-- 	if health < 0 then health = 0
-- 	elseif health > 100 then health = 100 end

-- 	ExecuteWebJS(web, "setHealth("..math.floor(health)..");")
-- end
-- AddRemoteEvent("SetGUIHealth", SetGUIHealth)

-- function SetGUIArmour(armour)
-- 	if armour < 0 then armour = 0
-- 	elseif armour > 100 then armour = 100 end

-- 	ExecuteWebJS(web, "setArmour("..math.floor(armour)..");")
-- end
-- AddRemoteEvent("SetGUIArmour", SetGUIArmour)

function SetGUICash(money)
	if money < 0 then return false end
	ExecuteWebJS(web, "setCash("..money..");")
end
AddRemoteEvent("SetGUICash", SetGUICash)

function SetGUIBank(money)
	if money < 0 then return false end
	ExecuteWebJS(web, "setBank("..money..");")
end
AddRemoteEvent("SetGUIBank", SetGUIBank)