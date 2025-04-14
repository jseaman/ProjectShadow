-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local function onSystemEvent(event)
	if event.type == "applicationExit" then
		game.hints.suspendTimer()
		game.save()
		game.stage.stopAll()
	elseif event.type == "applicationOpen" then
		game.hints.resumeTimer()
	elseif event.type == "applicationSuspend" then
		if game.hints then
			game.hints.suspendTimer()
		end
		game.save()
	elseif event.type == "applicationResume" then
		game.hints.resumeTimer()
	end
end
--Runtime:addEventListener("system", onSystemEvent)

-----------------------------------------------------------------------------------------
