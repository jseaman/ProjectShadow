-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local WaterMaskX = 5
local WaterMaskY = 167
local WaterMaskWidth = 560
local WaterMaskHeight = 120

local WaterImageWidth = 570
local WaterImageHeight = 85
local WaterWidth = 548
local WaterHeight = 300
local WaterX = 0 + WaterImageWidth/2
local WaterY = 207 + WaterImageHeight/2
--local WaterXScale = (WaterWidth + 50) / WaterImageWidth
local WaterXScale = 1
local WaterYScale = 1

-----------------------------------------------------------------------------------------

local function onEnterFrameEvent(event)
	local now = system.getTimer()/1000
	scene.water1.x = WaterX + math.sin(now * 2) * 2
	--scene.water1.y = WaterY + math.cos(now * 3.1) * 2
	scene.water1.xScale = WaterXScale + math.sin(now * 2) * 0.05
	scene.water1.yScale = WaterYScale + math.cos(now * 1.2) * 0.05
	scene.water2.xScale = -WaterXScale + math.sin(now * 1) * 0.01
	scene.water2.yScale = WaterYScale + math.cos(now * 2.2) * 0.01
end

-----------------------------------------------------------------------------------------

local function startDraining()
	game.events.trigger("game.gym.pool_water_drained")
	scene:newTimer(500, function()
		scene.drainSound = scene:playSound("drain", { loops = -1 })
		local targetY = device.y(WaterY + WaterImageHeight/2 + 10)
		scene:newTransition(scene.water2, { y = targetY, time = 8000 })
		scene:newTransition(scene.water1, { y = targetY, time = 8000, onComplete = function()
			scene.drainSound = game.stage.stop(scene.drainSound)
			game.scenes.gotoGameScene("game.gym.pool_pump")
		end})
	end)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/pool/bg_pool.jpg"))
		
	self.waterContainer = self:addToScene(display.newGroup())
	self.waterContainer:setMask(graphics.newMask("assets/images/game/gym/pool/mask_pool.png"))
	self.waterContainer.maskX, self.waterContainer.maskY = device.x(WaterMaskX+WaterMaskWidth/2), device.y(WaterMaskY+WaterMaskHeight/2)

	self.water1 = game.ui.insertChild(self.waterContainer, game.ui.newImage("assets/images/game/gym/pool/pool_water.png", device.x(WaterX), device.y(WaterY), WaterImageWidth, WaterImageHeight))
	self.water1.anchorX, self.water1.anchorY = 0.5,0.5
	self.water1.xScale = WaterXScale
	self.water1.yScale = WaterYScale
	self.water1.alpha = 0.9
	self.water2 = game.ui.insertChild(self.waterContainer, game.ui.newImage("assets/images/game/gym/pool/pool_water.png", device.x(WaterX), device.y(WaterY), WaterImageWidth, WaterImageHeight))
	self.water2.anchorX, self.water2.anchorY = 0.5,0.5
	self.water2.xScale = WaterXScale
	self.water2.yScale = WaterYScale
	self.water2.alpha = 0.8
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("drain", "assets/sounds/game/gym/pool_drain.mp3")
	elseif event.phase == "did" then
		game.hud.hide()
		Runtime:addEventListener("enterFrame", onEnterFrameEvent)
		startDraining()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		Runtime:removeEventListener("enterFrame", onEnterFrameEvent)
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene