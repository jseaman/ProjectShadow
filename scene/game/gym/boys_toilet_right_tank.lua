-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_bathroom/toilets/toilet_tank.jpg"))
	
	if not game.events.isTriggered("boys_bathroom.toilet_flushed") then
		self.pipeFlare = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_bathroom/toilets/pipe_flare.png", device.x(108), device.y(210), 88, 88))
		self:addToScene(game.ui.newSceneObjectCaption(
			"assets/images/game/gym/boys_bathroom/toilets/dirty_water.png", device.x(45), device.y(153), 489, 122,
			i18n._"Gym.ToiletTank.DirtyWater"))
	else
		self:addToScene(game.ui.newSceneItem("assets/images/game/gym/boys_bathroom/toilets/pipe.png", 
			device.x(121), device.y(211), 102, 42, "PoolPumpPipe"))
	end
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_toilet_right"))
end

-----------------------------------------------------------------------------------------

function scene:startFlare()
	self:newTransition(self.pipeFlare, { alpha = 0.5, time = 1000, onComplete = function()
		self:newTransition(self.pipeFlare, { alpha = 1, time = 1000, onComplete = function()
			self:startFlare()
		end})
	end})
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		game.hud.show()
		if not game.events.isTriggered("boys_bathroom.toilet_flushed") then
			self:startFlare()
		end
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