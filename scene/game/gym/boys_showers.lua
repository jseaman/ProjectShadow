-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local FaucetCircle = 1
local FaucetSquare = 2
local FaucetTriangle = 3
local FaucetDiamond = 4

-----------------------------------------------------------------------------------------

local faucets =  
{
	{ id = FaucetCircle, x = 98, y = 152, w = 16, h = 16, waterX = 106, waterY = 62, imageFile = "circle_handle.png", placed = true, state = 0 },
	{ id = FaucetSquare, x = 212, y = 152, w = 16, h = 16, waterX = 219, waterY = 62, imageFile = "square_handle.png", placed = true, state = 0 },
	{ id = FaucetTriangle, x = 334, y = 150, w = 18, h = 16, waterX = 342, waterY = 62, imageFile = "triangle_handle.png", placed = true, state = 0 },
	{ id = FaucetDiamond, x = 452, y = 152, w = 15, h = 16, waterX = 456, waterY = 62, imageFile = "diamond_handle.png", placed = false, state = 0 },
}

-----------------------------------------------------------------------------------------

local Solution = { FaucetCircle, FaucetTriangle, FaucetDiamond, FaucetSquare }

-----------------------------------------------------------------------------------------

local lastMoves = {}

-----------------------------------------------------------------------------------------

local FaucetMaskX = 5
local FaucetMaskY = 0
local FaucetMaskWidth = 560
local FaucetMaskHeight = 360

-----------------------------------------------------------------------------------------

local function onTilesTouch()
	if game.puzzles.hasFinished("boys_showers") then
		game.scenes.gotoGameScene("game.gym.boys_showers_tiles")
		return true
	end
	return false
end

-----------------------------------------------------------------------------------------

local function onWillMirandaTouch()
	scene.bubble.isVisible = false
	game.hud.showCaptionChain({
		chain = {			
			{ who = "miranda", text = i18n._"Gym.Showers.Miranda.HelpFriend" },
			{ who = "will", text = i18n._"Gym.Showers.Will.OpenGate" }
		},
		filterTouch = true,
		callback = function() scene.bubble.isVisible = true end
	})
end

-----------------------------------------------------------------------------------------

function scene:checkSolution()
	if not game.journal.hasEntry("Gym.Mirror") then
		return false
	end
	
	for i=1,#Solution do
		if Solution[i] ~= lastMoves[i] then
			return false
		end
	end
	return #lastMoves == #Solution
end

-----------------------------------------------------------------------------------------

function scene:isFaucetOn(faucetId)
	return faucets[faucetId].state == 1
end

function scene:turnFaucetOn(faucetId)
	if not self:isFaucetOn(faucetId) then
		local faucet = faucets[faucetId]
		faucet.state = 1
		self:newTransition(faucet.image, {rotation=90, time=300})
		
		self:playSound("valve_open")
		
		table.insert(lastMoves, faucetId)
		
		local waterEmitterName = "water" .. faucetId
		local water = game.ui.insertChild(self.waterContainer, 
			game.particles.createParticle("shower_faucet", waterEmitterName, device.x(faucet.waterX), device.y(faucet.waterY)))
		water.rotation = faucet.rotation
		--local water = game.ui.insertChild(self.waterContainer, display.newEmitter(io.getFileContentsAsJson("assets/particles/shower_water1.json")))
		--water.x, water.y = device.x(faucet.x + 7), device.y(faucet.y - 87)
		--local water = game.ui.insertChild(self.waterContainer, display.newEmitter(io.getFileContentsAsJson("assets/particles/shower_water2.json")))
		--water.x, water.y = device.x(faucet.x + 7), device.y(faucet.y - 87)
		--water.xScale, water.yScale = 0.3, 0.5
				
		faucet.splatTimer = self:newTimer(1500, function()
			local splatEmitterName = "splat" .. faucetId
			game.ui.insertChild(self.waterContainer, 
				game.particles.createParticle("shower_splat", splatEmitterName, device.x(faucet.x - 5), device.y(315)))
			game.particles.startEmitter(splatEmitterName)			
		end)
		
		self:loadAudioStream(waterEmitterName, "assets/sounds/game/gym/water_running.mp3")
		faucet.audioChannel = game.stage.play(self:getSound(waterEmitterName), { loops = -1 })
		
		game.particles.startEmitter(waterEmitterName)
		game.particles.start()
		
		if #lastMoves == scene:getPlacedFaucetCount() then
			if self:checkSolution() then
				game.puzzles.finish("boys_showers")
				self:newTimer(1000, function()
					game.particles.changeParticleProperty("ShowerFaucetWater1", "colorStart", {0,0,1})
					self:newTransition(self.floorStain, {alpha=0, time=1500, delay=2000, onComplete=function()
						scene:turnFaucetsOff()
					end})
				end)
			else
				self:newTimer(2000, function()
					scene:turnFaucetsOff()
				end)
			end
		end
	end
end

function scene:turnFaucetOff(faucetId)	
	if self:isFaucetOn(faucetId) then
		local faucet = faucets[faucetId]
		faucet.state = 0
		self:newTransition(faucet.image, {rotation=0, time=300})
		
		self:playSound("valve_close")
		
		faucet.splatTimer = game.ui.cancelTimer(faucet.splatTimer)
		
		game.particles.deleteEmitter("water" .. faucetId)
		game.particles.deleteEmitter("splat" .. faucetId)
		game.stage.stop(faucet.audioChannel)		
	end
end

function scene:toggleFaucet(faucetId)
	if self:isFaucetOn(faucetId) then
		self:turnFaucetOff(faucetId)
	else
		self:turnFaucetOn(faucetId)
	end
end

function scene:turnFaucetsOff()
	lastMoves = {}
	for i=1,#faucets do
		self:turnFaucetOff(i)
	end
end

-----------------------------------------------------------------------------------------

function scene:getPlacedFaucetCount()
	local count = 0
	for i,f in ipairs(faucets) do
		if f.placed then
			count = count + 1
		end
	end
	return count
end

-----------------------------------------------------------------------------------------

function scene:createFaucet(f)
	f.image = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_showers/" .. f.imageFile, device.x(f.x+f.w/2), device.y(f.y+f.h/2), f.w, f.h))
	f.image.anchorX, f.image.anchorY = 0.5, 0.5
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(f.x - 10), device.y(f.y - 10), f.w + 20, f.h + 20, function()
		if not game.puzzles.hasFinished("boys_showers_tiles") then
			if game.puzzles.hasFinished("boys_showers") or f.state == 1 then
				game.hud.showInfoCaption(i18n._"Gym.Showers.HandlesJammed")
			else
				scene:toggleFaucet(f.id)
			end
		end
	end))
	
	if self.waterContainer then
		self.waterContainer:toFront()
	end
end

function scene:createFaucets()
	for i,f in ipairs(faucets) do
		if f.placed then
			self:createFaucet(f)
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_showers/bg_showers.jpg"))
	
	self:addToScene(game.ui.newTouchRegion(device.x(264), device.y(310), 62, 44, onTilesTouch))
	
	if not game.puzzles.hasFinished("boys_showers") then
		self.floorStain = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/boys_showers/floor_stains.png", device.x(0), device.y(299), 570, 62, function()
			game.hud.showInfoCaption(i18n._"Gym.Showers.FloorDirty")
		end))
	end
	
	local faucet = faucets[FaucetDiamond]
	faucet.placed = game.events.isTriggered("gym.showers.diamond_placed")
	
	if not faucet.placed then
		self:addToScene(game.ui.newItemRegion(device.x(faucet.x - 10), device.y(faucet.y - 10), faucet.w + 20, faucet.h + 20, {
			itemName = "ShowerHandle",
			onCorrectItem = { text = i18n._"Gym.Showers.MissingHandlePlaced", event = "gym.showers.diamond_placed", handler = function()
				scene:playSound("metal")
				scene:createFaucet(faucet)
			end},
			onNoItem = i18n._"Gym.Showers.MissingHandle",
		}))
	end
	
	self:createFaucets()
	
	self.waterContainer = self:addToScene(display.newGroup())
	self.waterContainer:setMask(graphics.newMask("assets/images/game/gym/boys_showers/mask_showers.png"))
	self.waterContainer.maskX, self.waterContainer.maskY = device.x(FaucetMaskX+FaucetMaskWidth/2), device.y(FaucetMaskY+FaucetMaskHeight/2)
	
	if game.puzzles.hasFinished("boys_showers_tiles") then
		local will = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/boys_showers/will.png", device.x(71), device.y(127), 167, 233, onWillMirandaTouch))
		will.alpha = 0.8
		
		local miranda = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/boys_showers/miranda.png", device.x(244), device.y(129), 124, 232, onWillMirandaTouch))
		miranda.alpha = 0.8
		
		self.bubble = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_showers/bubble.png", device.x(140), display.contentHeight - 193 - 178, 208, 178))
		self.bubble.isVisible = game.events.isTriggered("gym.showers.will_miranda_intro")
	end
	
	self:addToScene(game.ui.newBackButton(function()
		game.scenes.gotoGameSceneDoor("game.gym.boys_hallway", "showers")
	end))
end

-----------------------------------------------------------------------------------------

function scene:getFadeIn()
	if game.puzzles.hasFinished("boys_showers_tiles") and not game.events.isTriggered("gym.showers.will_miranda_intro") then		
		return 6000
	end
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then		
		lastMoves = {}
		
		self:loadSound("valve_open", "assets/sounds/game/gym/squeaky_valve.mp3")
		self:loadSound("valve_close", "assets/sounds/game/gym/squeaky_valve_close.mp3")
		self:loadSound("metal", "assets/sounds/game/gym/metal3.mp3")
		
		if game.puzzles.hasFinished("boys_showers_tiles") and not game.events.isTriggered("gym.showers.will_miranda_intro") then		
			self:loadSound("door", "assets/sounds/game/general/door_closed.mp3")
			self:playSound("door")
		end
	elseif event.phase == "did" then
		game.hud.show()
		
		if game.puzzles.hasFinished("boys_showers_tiles") and not game.events.isTriggered("gym.showers.will_miranda_intro") then
			game.hud.showCaptionChain({
				chain = {
					{ who = "will", text = i18n._"Gym.Showers.Will.Intro1" },
					{ who = "miranda", text = i18n._"Gym.Showers.Miranda.Intro1" },
					{ who = "will", text = i18n._"Gym.Showers.Will.Intro2" }
				},
				event = "gym.showers.will_miranda_intro",
				filterTouch = true,
				callback = function() 
					self.bubble.isVisible = true 
					game.achievements.unlock("teens")
				end
			})
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		self:turnFaucetsOff()
		game.particles.cleanUp()
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene