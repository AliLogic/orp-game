function ToggleScoreboard(player, toggle)
	CallRemoteEvent(player, 'scorebork:ToggleScoreboard', toggle)
end

function InsertPlayer(player, name, level, ping)
	CallRemoteEvent(player, 'scorebork:InsertPlayer', player, name, level, ping)
end

function RemovePlayer(player)
	CallRemoteEvent(player, 'scorebork:RemovePlayer', player)
end

function UpdatePlayer(player, value, newvalue)
	CallRemoteEvent(player, 'scorebork:UpdatePlayer', player, value, newvalue)
end

AddFunctionExport('ToggleScoreboard', ToggleScoreboard)
AddFunctionExport('InsertPlayer', InsertPlayer)
AddFunctionExport('RemovePlayer', RemovePlayer)
AddFunctionExport('UpdatePlayer', UpdatePlayer)