-- Variables

local scoreboard = 0
local scoreboard_timer = 0

-- Functions

local function UpdateScoreboardData()
	CallRemoteEvent("scorebork:updateScoreboard")
end

function ToggleScoreboard(toggle)
	if toggle == true then
		ExecuteWebJS(scoreboard, "toggleScoreboard(true);")
	else
		ExecuteWebJS(scoreboard, "toggleScoreboard(false);")
	end
end
AddRemoteEvent('scorebork:ToggleScoreboard', ToggleScoreboard)

function InsertPlayer(id, name, level, ping)
	ExecuteWebJS(scoreboard, "insertPlayer({id: "..id..", name: \""..name.."\", level: "..level..", ping: "..ping.."});")
end
AddRemoteEvent('scorebork:InsertPlayer', InsertPlayer)

function RemovePlayer(id)
	ExecuteWebJS(scoreboard, "removePlayer("..id..");")
end
AddRemoteEvent('scorebork:RemovePlayer', RemovePlayer)

function UpdatePlayer(id, value, newvalue)
	ExecuteWebJS(scoreboard, "updateValue("..id..", \""..value.."\", \""..newvalue.."\");")
end
AddRemoteEvent('scorebork:UpdatePlayer', UpdatePlayer)

AddFunctionExport('ToggleScoreboard', ToggleScoreboard)
AddFunctionExport('InsertPlayer', InsertPlayer)
AddFunctionExport('RemovePlayer', RemovePlayer)
AddFunctionExport('UpdatePlayer', UpdatePlayer)

-- Events

AddEvent("OnPackageStart", function ()
	scoreboard = CreateWebUI(0, 0, 0, 0, 1, 16)
	SetWebAlignment(scoreboard, 0, 0)
	SetWebAnchors(scoreboard, 0, 0, 1, 1)
	SetWebURL(scoreboard, "http://asset/"..GetPackageName().."/scoreboard.html")
	SetWebVisibility(scoreboard, WEB_HIDDEN)
end)

AddEvent("OnPackageStop", function ()
	DestroyTimer(scoreboard_timer)
	DestroyWebUI(scoreboard)
end)

AddEvent("OnKeyPress", function (key)
	if key == "Tab" then
		if IsValidTimer(scoreboard_timer) then
			DestroyTimer(scoreboard_timer)
		end

		scoreboard_timer = CreateTimer(UpdateScoreboardData, 3000)
		UpdateScoreboardData()
		SetWebVisibility(scoreboard, WEB_VISIBLE)
	end
end)

AddEvent("OnKeyRelease", function(key)
	if key == "Tab" then
		if IsValidTimer(scoreboard_timer) then
			DestroyTimer(scoreboard_timer)
		end

		SetWebVisibility(scoreboard, WEB_HIDDEN)
	end
end)