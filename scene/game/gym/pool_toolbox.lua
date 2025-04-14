-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/pool_control_room/toolbox/bg_toolbox.jpg"))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/pool_control_room/toolbox/crank_handle.png", 
		device.x(299), device.y(153), 97, 75, "CrankHandle"))

  if not game.events.isTriggered("pool_toolbox.photo") then
		self.bowlPhoto = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/pool_control_room/toolbox/bowl_photo.png", device.x(101), device.y(91), 168, 108,
      function()
        scene.bowlPhoto = game.ui.removeSelf(scene.bowlPhoto)
        game.journal.recordEntry("Gym.BowlPhoto")
        game.events.trigger("pool_toolbox.photo")
      end))
	end
	
	self:addToScene(game.ui.newBackButton("game.gym.pool_control_room"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
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