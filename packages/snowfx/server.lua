AddEvent("OnPackageStart", function()
    print("SnowFX 1.0.0 loaded, by infin1tyy!")
end)

AddEvent("OnPackageStop", function()
    print("SnowFX 1.0.0 unloaded, by infin1tyy!")
end)

AddEvent("OnPlayerJoin", function(player)
    CallRemoteEvent(player, "SetSnow")
end)


