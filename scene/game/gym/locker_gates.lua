-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onPortalTouch()
	game.events.trigger("gameover")
	game.scenes.gotoGameScene("game.outro.00_portal")
end

-----------------------------------------------------------------------------------------

function scene:showEffects()
	game.ui.insertChild(self.effectsLayer, game.particles.createStartedParticle("locker_portal", "portal", display.contentWidth/2, display.contentHeight/2))
	game.ui.insertChild(self.effectsLayer, game.particles.createStartedParticle("locker_portal_aura", "aura", device.x(140) + 0, device.y(0) + 360/2))
	game.particles.start()
end

-----------------------------------------------------------------------------------------

function scene:getFadeIn()
	return 4000
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/gates/gates_locker_noportal.jpg"))
	
	self.effectsLayer = self:addToScene(game.ui.newGroup())
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(178), device.y(0), 223, 379, onPortalTouch))
	
	self:addToScene(game.ui.newBackButton(function()
		scene:playSound("locker_close")
		game.scenes.gotoGameScene("game.gym.boys_lockers")
	end))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("locker_close", "assets/sounds/game/gym/locker_close.mp3")
		scene:showEffects()
	elseif event.phase == "did" then
		game.hud.show()
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