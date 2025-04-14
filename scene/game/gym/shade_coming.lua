-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:showSmoke()
	game.ui.insertChild(self.smokeLayer, game.particles.createStartedParticle("shade_coming_smoke", "smoke", display.contentWidth/2, display.contentHeight/2))
	game.particles.start()
end

-----------------------------------------------------------------------------------------

function scene:startFloatingShade()
	self.floatTransition = game.ui.cancelTransition(self.floatTransition)
	self.floatTransition = self:newTransition(self.shade, { y = self.shade.y-8, time = 700, onComplete = function()
		self.floatTransition = self:newTransition(self.shade, { y = self.shade.y+8, time = 700, onComplete = function()
			scene:startFloatingShade()
		end})
	end})
end

-----------------------------------------------------------------------------------------

function scene:startMoving()
	self:newTransition(self.bgGroup, { x = -570, time=4000 })
	self:newTransition(self.fgGroup, { x = device.x(585), time=4000 })
	self:startFloatingShade()
	self:newTimer(4000, function()
		game.scenes.gotoGameScene("game.gym.boys_locker_room")
	end)
	self:playSound("shade")
end

-----------------------------------------------------------------------------------------

function scene:getFadeIn()
	return 800
end

-----------------------------------------------------------------------------------------

function scene:getFadeInDelay()
	return 1000
end

-----------------------------------------------------------------------------------------

function scene:onBeforeFadeIn()
	self:startMoving()
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self.bgGroup = self:addToScene(game.ui.newGroup())	
	game.ui.insertChild(self.bgGroup, game.ui.newImage("assets/images/game/gym/shade/coming/bg1.jpg", device.x(0), device.y(55), 570, 251))
	game.ui.insertChild(self.bgGroup, game.ui.newImage("assets/images/game/gym/shade/coming/bg2.jpg", device.x(570), device.y(55), 570, 251))
	
	self.smokeLayer = self:addToScene(game.ui.newGroup())
	
	self.fgGroup = self:addToScene(game.ui.newGroup())	
	self.shade = game.ui.insertChild(self.fgGroup, game.ui.newImage("assets/images/game/gym/shade/coming/the_shade.png", device.x(-30), device.y(78), 142, 240))
	self.shade.alpha = 0.6
	
	self:addToScene(game.ui.newRect(device.x(0), device.y(0), 570, 55, {0,0,0}))
	self:addToScene(game.ui.newRect(device.x(0), device.y(305), 570, 55, {0,0,0}))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		game.hud.hide()
		self:loadSound("shade", "assets/sounds/game/gym/shade_breath.mp3")
		self:showSmoke()
	elseif event.phase == "did" then
		game.hud.hide()
		game.events.trigger("boys_locker_room.scare1_coming")
		--self:startMoving()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		game.particles.cleanUp()
	elseif event.phase == "did" then		
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene