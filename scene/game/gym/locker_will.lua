-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/will_lock/will_locker.jpg"))
		
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/boys_locker_room/will_lock/skull_medal.png", 
		device.x(258), device.y(71), 63, 42, "ChestSquareCrest"))
		
	self:addToScene(game.ui.newTouchInfo(device.x(225), device.y(148), 147, 39, i18n._"WillLocker.Papers"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(6), device.y(94), 146, 266, i18n._"WillLocker.Stickers"))
	
	self:addToScene(game.ui.newBackButton(function()
		scene:playSound("locker_close")
		game.scenes.gotoGameScene("game.gym.boys_lockers")
	end))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("locker_close", "assets/sounds/game/gym/locker_close.mp3")
	elseif event.phase == "did" then
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene