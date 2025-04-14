-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local FaucetHot = 1
local FaucetCold = 2

-----------------------------------------------------------------------------------------

local faucets =  {
	{ x = 36, y = 0, rotation = 165, state = 0 },
	{ x = 215, y = 0, rotation = 195, state = 0 },
}

-----------------------------------------------------------------------------------------

local FaucetMaskX = 156
local FaucetMaskY = 240
local FaucetMaskWidth = 260
local FaucetMaskHeight = 120

-----------------------------------------------------------------------------------------

local MirrorMaskX = 140
local MirrorMaskY = -11
local MirrorMaskWidth = 284
local MirrorMaskHeight = 172

-----------------------------------------------------------------------------------------

local function onHiddenMessageTouch()
	game.hud.showInfoCaption(i18n._"Gym.Sink.HiddenMessage")
end

local function onRevealedMessageTouch()
	game.journal.recordEntry("Gym.Mirror")
end

-----------------------------------------------------------------------------------------

function scene:revealHiddenMessage()
	self:trackTransition(transition.dissolve(self.hiddenMessage, self.revealedMessage, 2000, 2000))
	game.events.trigger("gym.sink.hidden_message")
end

-----------------------------------------------------------------------------------------

function scene:showHotVapor()
	self:addToScene(game.particles.createParticle("bathroom_sink_vapor", "vapor", device.x(250), device.y(300)))
	game.particles.startEmitters({ "vapor" })
	
	if not game.events.isTriggered("gym.sink.hidden_message") then
		self:revealHiddenMessage()
	end
end

function scene:hideHotVapor()
	game.particles.deleteEmitter("vapor")
end

-----------------------------------------------------------------------------------------

function scene:isFaucetOn(faucetId)
	return faucets[faucetId].state == 1
end

function scene:turnFaucetOn(faucetId)
	if not self:isFaucetOn(faucetId) then
		local faucet = faucets[faucetId]
		faucet.state = 1
		faucet.openImage.isVisible = true
		faucet.closedImage.isVisible = false
		
		self:playSound("valve_open")
		
		local emitterName = "water" .. faucetId
		local water = game.ui.insertChild(self.waterContainer, 
			game.particles.createParticle("bathroom_sink_faucet", emitterName, device.x(FaucetMaskX+faucet.x), device.y(FaucetMaskY+faucet.y)))
		water.rotation = faucet.rotation
		
		self:loadAudioStream(emitterName, "assets/sounds/game/gym/water_running.mp3")
		faucet.audioChannel = game.stage.play(self:getSound(emitterName), { loops = -1 })
		
		game.particles.startEmitters({ emitterName })
		game.particles.start()
		
		if faucetId == FaucetHot and game.events.isTriggered("gym.hot_water_enabled") then
			self:showHotVapor()
		else
			game.hud.showInfoCaption(i18n._"Gym.Sink.ColdWater")
		end
	end
end

function scene:turnFaucetOff(faucetId)
	if self:isFaucetOn(faucetId) then
		local faucet = faucets[faucetId]
		faucet.state = 0
		faucet.openImage.isVisible = false
		faucet.closedImage.isVisible = true
		
		self:playSound("valve_close")
		
		local emitterName = "water" .. faucetId
		game.particles.deleteEmitter(emitterName)
		game.stage.stop(faucet.audioChannel)
		
		if faucetId == FaucetHot then
			self:hideHotVapor()
		end
	end
end

function scene:toggleFaucet(faucetId)
	if self:isFaucetOn(faucetId) then
		self:turnFaucetOff(faucetId)
	else
		self:turnFaucetOn(faucetId)
	end
end

-----------------------------------------------------------------------------------------

function scene:startScare()
	self:newTimer(1500, function()
		scene:animateLights()
	end)
end

function scene:animateLights()
	local maxFlickers = 5
	--local count = 0
	self:playSound("static")
	--self:newTimer(1000, function() self:playSound("static") end)
	scene:animateLightsTransition(0, maxFlickers)
	--[[self:newTimer(math.random(150, 350), function()
		self:playSound("flicker")
		self.darkScreen.isVisible = not self.darkScreen.isVisible
		count = count + 1
		if count == (maxFlickers - 1) then
			self.darkScreen.alpha = 1
		end
		if count >= maxFlickers then
			self.faceReflection.isVisible = true
			scene:turnLightsOnAgain()
		end
	end, maxFlickers)]]
end

function scene:animateLightsTransition(index, maxFlickers)
	if index >= maxFlickers then
		self.faceReflection.isVisible = true
		--self:playSound("violins")
		scene:turnLightsOnAgain()
		return
	end
	
	local alpha = 1
	if self.darkScreen.alpha == 1 then
		alpha = 0
	end
	
	self:newTransition(self.darkScreen, { alpha = alpha, time = 200, onComplete = function()
		scene:animateLightsTransition(index + 1, maxFlickers)
	end})
	--[[self:newTimer(math.random(150, 350), function()
		self:playSound("flicker")
		self.darkScreen.isVisible = not self.darkScreen.isVisible
		count = count + 1
		if count == (maxFlickers - 1) then
			self.darkScreen.alpha = 1
		end
		if count >= maxFlickers then
			self.faceReflection.isVisible = true
			scene:turnLightsOnAgain()
		end
	end, maxFlickers)]]
end

function scene:turnLightsOnAgain()
	game.ui.insertChild(self.faceSmoke, 
		game.particles.createParticle("bathroom_sink_spirit", "spirit1", device.x(190), device.y(160)))
	game.ui.insertChild(self.faceSmoke, 
		game.particles.createParticle("bathroom_sink_spirit", "spirit2", device.x(375), device.y(170)))	
	game.particles.startEmitters({ "spirit1", "spirit2" })
	game.particles.start()
	
	self:playSound("heartbeat_slow")
	
	self:newTimer(3500, function()
		self.darkScreen.isVisible = false
		self:playSound("scare")
		--self:playSound("spirit")
		--self:playSound("static")
		scene:animateReflection()		
	end)
end

function scene:animateReflection()
	self:newTimer(400, function()
		self.faceImage2.isVisible = true
		self:newTimer(300, function() 
			self.faceImage2.isVisible = false
			self.faceImage2.x = device.x(191)
			self:newTimer(200, function()
				self.faceImage2.isVisible = true
				self:newTimer(100, function()
					self.faceImage2.isVisible = false
				end)
			end)
		end)
	end)
	self:newTimer(1000, function() 
		self:playSound("spirit")
	end)
	self:newTimer(2800, function()
		self.faceSmoke.isVisible = false
		self:newTransition(self.faceReflection, { y = -300, x = 10, xScale = 0.3, rotation = -45, alpha = 0.2, time = 1500, onComplete = function()
			game.events.trigger("boys_sink.reflection")
			self.darkScreen = game.ui.removeSelf(self.darkScreen)
			scene:showHUD()
			game.hud.show()			
		end})
	end)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_bathroom/sink/sink_bg.jpg"))
	
	local faucet = faucets[FaucetHot]
	faucet.openImage = self:addToScene(
		game.ui.newSceneObject("assets/images/game/gym/boys_bathroom/sink/open_left_tap.png", device.x(99), device.y(209), 59, 31))
	faucet.openImage.isVisible = false
	faucet.closedImage = self:addToScene(
		game.ui.newSceneObject("assets/images/game/gym/boys_bathroom/sink/closed_left_tap.png", device.x(99), device.y(209), 59, 31))
		
	faucet = faucets[FaucetCold]
	faucet.openImage = self:addToScene(
		game.ui.newSceneObject("assets/images/game/gym/boys_bathroom/sink/open_right_tap.png", device.x(407), device.y(210), 59, 31))
	faucet.openImage.isVisible = false
	faucet.closedImage = self:addToScene(
		game.ui.newSceneObject("assets/images/game/gym/boys_bathroom/sink/closed_right_tap.png", device.x(407), device.y(210), 59, 31))
	
	self.waterContainer = self:addToScene(display.newGroup())
	self.waterContainer:setMask(graphics.newMask("assets/images/game/gym/boys_bathroom/sink/mask_sink.png"))
	self.waterContainer.maskX, self.waterContainer.maskY = device.x(FaucetMaskX+FaucetMaskWidth/2), device.y(FaucetMaskY+FaucetMaskHeight/2)
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(99), device.y(210), 58, 33, function()
		self:toggleFaucet(FaucetHot)
	end))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(407), device.y(210), 58, 33, function()
		self:toggleFaucet(FaucetCold)
	end))
	
	self.hiddenMessage = self:addToScene(
		game.ui.newSceneObject("assets/images/game/gym/boys_bathroom/sink/hidden_message.png", device.x(197), device.y(103), 164, 36, onHiddenMessageTouch))
		
	self.revealedMessage = self:addToScene(
		game.ui.newSceneObject("assets/images/game/gym/boys_bathroom/sink/steam_message.png", device.x(151), device.y(0), 267, 155, onRevealedMessageTouch))
	
	self.hiddenMessage.alpha = (game.events.isTriggered("gym.sink.hidden_message") and 0) or 1
	self.revealedMessage.alpha = (game.events.isTriggered("gym.sink.hidden_message") and 1) or 0
	
	if not game.events.isTriggered("boys_sink.reflection") then
		self.mirrorContainer = self:addToScene(display.newGroup())
		self.mirrorContainer:setMask(graphics.newMask("assets/images/game/gym/boys_bathroom/sink/mirror_mask.png"))
		self.mirrorContainer.maskX, self.mirrorContainer.maskY = device.x(MirrorMaskX+MirrorMaskWidth/2), device.y(MirrorMaskY+MirrorMaskHeight/2)
		
		self.faceReflection = game.ui.insertChild(self.mirrorContainer, game.ui.newGroup())
		self.faceReflection.isVisible = false
		
		self.faceSmoke = game.ui.insertChild(self.faceReflection, game.ui.newGroup())
		self.faceSmoke.alpha = 0.3
		
		self.faceImage = game.ui.insertChild(self.faceReflection,
			game.ui.newImage("assets/images/game/gym/boys_bathroom/sink/lou_spirit.png", device.x(178), device.y(-18), 205, 350))
		self.faceImage.alpha = 0.7
		
		self.faceImage2 = game.ui.insertChild(self.faceReflection,
			game.ui.newImage("assets/images/game/gym/boys_bathroom/sink/lou_spirit.png", device.x(168), device.y(-18), 205, 350))
		self.faceImage2.alpha = 0.7
		self.faceImage2.isVisible = false
	end
	
	self:addToScene(
		game.ui.newImage("assets/images/game/gym/boys_bathroom/sink/mirror_shine.png", device.x(161), device.y(0), 245, 155))
		
	if not game.events.isTriggered("boys_sink.reflection") then
		self.darkScreen = self:addToScene(game.ui.newRectFullScreen({0,0,0}, function() return true end))
		self.darkScreen.alpha = 0
		--self.darkScreen.isVisible = false
	end
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_bathroom"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("valve_open", "assets/sounds/game/gym/squeaky_valve.mp3")
		self:loadSound("valve_close", "assets/sounds/game/gym/squeaky_valve_close.mp3")
		
		if not game.events.isTriggered("boys_sink.reflection") then
			self:loadSound("flicker", "assets/sounds/game/gym/light_flicker.mp3")
			self:loadSound("scare", "assets/sounds/game/gym/scare1.mp3")
			self:loadSound("static", "assets/sounds/game/gym/static.mp3")
			self:loadSound("violins", "assets/sounds/game/gym/scary_violins.mp3")
			self:loadSound("spirit", "assets/sounds/game/gym/lou_spirit.mp3")
			self:loadSound("heartbeat_slow", "assets/sounds/game/gym/heartbeat_slow.mp3")
		end
	elseif event.phase == "did" then				
		if not game.events.isTriggered("boys_sink.reflection") then
			game.hud.hide()
			scene:hideHUD()
			scene:startScare()
		else
			game.hud.show()
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		self:turnFaucetOff(FaucetHot)
		self:turnFaucetOff(FaucetCold)
		game.particles.cleanUp()
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene