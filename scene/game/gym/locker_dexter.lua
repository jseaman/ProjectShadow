-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/dexter/dexter_locker_zoom.jpg"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(314), device.y(129), 66, 51, i18n._"DexterLocker.Hamburger"))
	self:addToScene(game.ui.newTouchInfo(device.x(86), device.y(51), 65, 175, i18n._"DexterLocker.Nintendo"))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/boys_locker_room/dexter/clover_key.png", 
		device.x(182), device.y(88), 82, 26, "StorageKey"))
	
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