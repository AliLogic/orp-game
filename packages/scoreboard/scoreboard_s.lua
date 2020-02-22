function ToggleScoreboard(player, toggle)
	CallRemoteEvent(player, 'scorebork:ToggleScoreboard', toggle)
end

function InsertPlayer(player, other, name, level, ping)
	CallRemoteEvent(player, 'scorebork:InsertPlayer', other, name, level, ping)
end

function UpdatePlayer(player, value, newvalue)
	CallRemoteEvent(player, 'scorebork:UpdatePlayer', player, value, newvalue)
end

AddFunctionExport('ToggleScoreboard', ToggleScoreboard)
AddFunctionExport('InsertPlayer', InsertPlayer)
AddFunctionExport('UpdatePlayer', UpdatePlayer)

AddRemoteEvent("scorebork:updateScoreboard", function (playerid)

	for _, v in pairs(GetAllPlayers()) do
		--[[
		if PlayerData[v] ~= nil then
			InsertPlayer(playerid, v, GetPlayerName(v), PlayerData[v].level, GetPlayerPing(v))
		end
		]]--
		InsertPlayer(playerid, v, GetPlayerName(v), 1, GetPlayerPing(v))
	end
end)