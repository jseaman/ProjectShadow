-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_bathroom/toilets/toilet_tank.jpg"))
	
	self:addToScene(game.ui.newTouchCaption(device.x(45), device.y(153), 489, 122, i18n._"Gym.ToiletTank.NothingHere"))
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_toilet_left"))
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