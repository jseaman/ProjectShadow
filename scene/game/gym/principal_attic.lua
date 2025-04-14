-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onWindowTouch()
	game.journal.recordEntry("Gym.Adam&Eve")
	game.hud.showInfoCaption(i18n._"PrincipalAttic.Sin")
end

-----------------------------------------------------------------------------------------

function scene:startLights()
	self.lights = self:addToScene(game.particles.createStartedParticle("attic_lights", "lights", device.x(9), device.y(0) + 360/2))
	self.lights.alpha = 0.5
	game.particles.start()
end

-----------------------------------------------------------------------------------------

function scene:startItemGlow()
	self.itemGlowTransition = scene:newTransition(self.chestItemGlow, { alpha = math.random(0.1, 0.4), time = math.random(600, 2000), onComplete = function()
		self.itemGlowTransition = scene:newTransition(self.chestItemGlow, { alpha = math.random(0.7, 1), time = math.random(600, 2000), onComplete = function()
			scene:startItemGlow()
		end})
	end})
end

-----------------------------------------------------------------------------------------

function scene:stopItemGlow()
	self.itemGlowTransition = game.ui.cancelTransition(self.itemGlowTransition)
	self.chestItemGlow = game.ui.removeSelf(self.chestItemGlow)
end

-----------------------------------------------------------------------------------------

function scene:getFadeIn()
	return 4000
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/principal_attic/bg_principal_attic.jpg"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(172), device.y(125), 47, 55, i18n._"PrincipalAttic.NothingHere"))
	self:addToScene(game.ui.newTouchInfo(device.x(351), device.y(125), 47, 55, i18n._"PrincipalAttic.NothingHere"))
	
	self.chestOpen = self:addToScene(game.ui.newImage("assets/images/game/gym/principal_attic/chest_opened.png", device.x(241), device.y(213), 97, 88))
	self.chestOpen.isVisible = false
	
	self.chestItem = self:addToScene(game.ui.newSceneItem("assets/images/game/gym/principal_attic/dragon.png", 
		device.x(253), device.y(245), 72, 25, "Treasure", function()
			self:stopItemGlow()
		end))
		
	if self.chestItem then
		self.chestItem.isVisible = false
		self.chestItemGlow = self:addToScene(game.ui.newImage("assets/images/game/gym/principal_attic/dragon_glow.png", device.x(253), device.y(244), 72, 26))
		self.chestItemGlow.isVisible = false
	end
	
	if game.events.isTriggered("principal_attic.chest_open") then
		self.chestOpen.isVisible = true
		if self.chestItem then
			self.chestItem.isVisible = true
			self.chestItemGlow.isVisible = true
			self:startItemGlow()
		end
	else
		self.chestClosed = self:addToScene(game.ui.newImage("assets/images/game/gym/principal_attic/chest_closed.png", device.x(241), device.y(213), 97, 88))
		
		self:addToScene(game.ui.newItemRegion(device.x(241), device.y(213), 97, 88, {
			itemName = "ChestKey",
			onCorrectItem = { text = i18n._"Gym.PrincipalAttic.ChestUnlocked", event = "principal_attic.chest_open", handler = function()
				scene:playSound("unlocked")
				self.chestOpen.isVisible = true
				self.chestItem.isVisible = true
				self.chestItemGlow.isVisible = true
				self.chestClosed.isVisible = false
				self:startItemGlow()				
				game.achievements.unlock("principal_chest")
			end},
			onNoItem = i18n._"Gym.PrincipalAttic.ChestLocked",
		}))
	end
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(241), device.y(14), 100, 154, onWindowTouch))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(356), device.y(274), 78, 39, "game.gym.principal_attic_pages"))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/principal_attic/lion_medal.png", 
		device.x(139), device.y(286), 45, 39, "ChestHexCrest"))
	
	self:addToScene(game.ui.newBackButton("game.gym.principal_den"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("unlocked", "assets/sounds/game/gym/chest_open2.mp3")
		scene:startLights()
	elseif event.phase == "did" then
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		game.particles.cleanUp()
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene