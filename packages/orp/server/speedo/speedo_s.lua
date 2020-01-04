AddEvent("OnPlayerStateChange", function(player, newstate, oldstate)
	if newstate == PS_DRIVER then
		CallRemoteEvent(player, "ToggleSpeedo", true)
	elseif newstate ~= PS_DRIVER then
		CallRemoteEvent(player, "ToggleSpeedo", false)
	end
end)