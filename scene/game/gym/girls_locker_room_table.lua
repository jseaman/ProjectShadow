-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/girls_locker_room/bench_zoom.jpg"))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/girls_locker_room/mirror.png", 
		device.x(279), device.y(173), 121, 129, "Mirror", function() 
			scene:showHUD()
		end))
	
	self:addToScene(game.ui.newTouchInfo(device.x(16), device.y(128), 173, 157, i18n._"GirlsLockerRoom.MakeUp"))
	
	self:addToHUD(game.ui.newBackButton("game.gym.girls_locker_room"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		if not game.inventory.hasPickedUpItem("Journal") then
			scene:hideHUD()
		end
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