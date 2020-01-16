local web = CreateWebUI(0, 0, 0, 0, 1, 16)
SetWebAlignment(web, 0, 0)
SetWebAnchors(web, 0, 0, 1, 1)
SetWebURL(web, "http://asset/"..GetPackageName().."/scoreboard.html")
SetWebVisibility(web, WEB_HIDDEN)

AddEvent("OnPackageStop", function()
	DestroyWebUI(web)
end)

function ToggleScoreboard(toggle)
	if toggle == true then
		ExecuteWebJS(web, "toggleScoreboard(true);")
	else
		ExecuteWebJS(web, "toggleScoreboard(false);")
	end
end
AddRemoteEvent('scorebork:ToggleScoreboard', ToggleScoreboard)

function InsertPlayer(id, name, level, ping)
	ExecuteWebJS("insertPlayer({id: "..id..", name: \""..name.."\", level: "..level..", ping: "..ping.."});")
end
AddRemoteEvent('scorebork:InsertPlayer', InsertPlayer)