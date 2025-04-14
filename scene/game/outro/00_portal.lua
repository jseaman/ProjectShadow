-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local photos = {
  "assets/images/game/gym/principal_den/portrait_puzzle/bg_portrait_puzzle.jpg",
  "assets/images/game/gym/boys_bathroom/toilets/bg_middle_toilet.jpg",
  "assets/images/game/intro/dream_miranda.jpg",
  "assets/images/game/gym/basketball_court/basket_book_zoom.jpg",
  "assets/images/game/gym/boys_locker_room/dexter/dexter_puzzle_zoom.jpg",
  "assets/images/game/gym/boys_locker_room/bg_lockers.jpg",
  "assets/images/game/intro/dream_will.jpg",
}

-----------------------------------------------------------------------------------------

function scene:showPhoto(index)
  if index > #scene.photos then
		self:playSound("portal_close")
    game.scenes.gotoGameScene("game.outro.01_classroom", "zoomInOut", 2000)
    return
  end
  
  --game.stage.playBackSound()
  --scene.photos[index].isVisible = true
	scene:newTransition(scene.photos[index], { alpha = 0.7, time = 500 })
  
  scene:newTimer(1700, function()
    scene:showPhoto(index + 1)
  end)
end

function scene:startPhotos()
  scene:showPhoto(1)
end

-----------------------------------------------------------------------------------------

function scene:showEffects()
	game.ui.insertChild(self.effectsLayer, game.particles.createStartedParticle("portal", "portal", display.contentWidth/2, display.contentHeight/2))
	local aura = game.ui.insertChild(self.effectsLayer, game.particles.createStartedParticle("portal_aura", "aura", device.x(-110), display.contentHeight/2))
	aura.alpha = 0.7
	game.particles.start()
end

-----------------------------------------------------------------------------------------

function scene:getFadeIn()
	return 4000
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)	
	self.memoryLayer = self:addToScene(game.ui.newGroup())
	
	self.photos = {}
  for photo in list_iter(photos) do
    local image = game.ui.insertChild(self.memoryLayer, game.ui.newBackground(photo))
    image.fill.effect = "filter.exposure"
    image.fill.effect.exposure = 1.5
    image.alpha = 0
    
    table.insert(self.photos, image)
  end
	
	self.effectsLayer = self:addToScene(game.ui.newGroup())
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("portal_open", "assets/sounds/game/general/portal_open.mp3")
		self:loadSound("portal", "assets/sounds/game/general/portal.mp3")
		self:loadSound("portal_close", "assets/sounds/game/general/portal_close.mp3")
		scene:showEffects()
		self:playSound("portal_open")
	elseif event.phase == "did" then
		game.hud.hide()
		scene:newTimer(4000, function()
			self:playSound("portal")
      scene:startPhotos()
    end)
		self.shakeEffect = game.effects.newShakeEffect({
			group = self.sceneLayer,
			amount = 600,
			intensity = 2
		})
		self.shakeEffect:start()	
		system.vibrate()
		
		if not game.events.isTriggered("used_hints") then
			game.achievements.unlock("no_hints")
		end
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