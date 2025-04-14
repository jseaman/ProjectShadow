-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/girls_locker_room/girls_lockers_zoom.jpg"))
	
	if game.puzzles.hasFinished("locker_miranda_lock") then		
		self:addToScene(game.ui.newTouchRegionTap(device.x(198), device.y(0), 185, 360, function()
			scene:playSound("locker_open")
			game.scenes.gotoGameScene("game.gym.locker_miranda")
		end))
	else
		self:addToScene(game.ui.newTouchAndGo(device.x(198), device.y(0), 185, 360, "game.gym.locker_miranda_lock"))
	end
	
	self:addToScene(game.ui.newBackButton("game.gym.girls_locker_room"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene:loadSound("locker_open", "assets/sounds/game/gym/locker_open.mp3")
	elseif event.phase == "did" then
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then		
	elseif event.phase == "did" then
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene