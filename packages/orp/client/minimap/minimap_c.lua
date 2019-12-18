AddRemoteEvent('CreateMinimap', function ()
    minimap = CreateWebUI(0, 0, 0, 0, 0, 32)
    SetWebVisibility(minimap, WEB_HITINVISIBLE)
    SetWebAnchors(minimap, 0, 0, 1, 1)
    SetWebAlignment(minimap, 0, 0)
    SetWebURL(minimap, "http://asset/"..GetPackageName().."/client/minimap/minimap.html")
end)

AddEvent('OnGameTick', function ()
    --Minimap refresh
    local x, y, z = GetCameraRotation()
    local px,py,pz = GetPlayerLocation()
    
    ExecuteWebJS(minimap, "SetHUDHeading("..tonumber((360-y))..");")
    ExecuteWebJS(minimap, "SetMap("..tonumber(px)..","..tonumber(py)..","..tonumber(y)..");")
end)