-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local WaterMaskX = -10
local WaterMaskY = -4
local WaterMaskWidth = 592
local WaterMaskHeight = 252

local WaterImageWidth = 570
local WaterImageHeight = 270
local WaterWidth = 548
local WaterHeight = 300
local WaterX = 0 + WaterImageWidth/2
local WaterY = -7 + WaterImageHeight/2
local WaterXScale = (WaterWidth + 50) / WaterImageWidth
local WaterYScale = 1

-----------------------------------------------------------------------------------------

local function onEnterFrameEvent(event)
	local now = system.getTimer()/1000
	scene.water1.x = WaterX + math.sin(now * 2) * 2
	scene.water1.y = WaterY + math.cos(now * 3.1) * 2
	scene.water1.xScale = WaterXScale + math.sin(now * 2) * 0.05
	scene.water1.yScale = WaterYScale + math.cos(now * 1.2) * 0.05
	scene.water2.xScale = -WaterXScale + math.sin(now * 1) * 0.01
	scene.water2.yScale = WaterYScale + math.cos(now * 2.2) * 0.01
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/pool/bg_pool_zoom.jpg"))
	
	if game.events.isTriggered("game.gym.pool_water_drained") then
		self:addToScene(game.ui.newSceneItem("assets/images/game/gym/pool/crowbar.png", 
			device.x(244), device.y(147), 83, 26, "Crowbar"))
	else
		self:addToScene(game.ui.newSceneObjectCaption("assets/images/game/gym/pool/crowbar_submerged.png", device.x(244), device.y(147), 83, 26, i18n._"Gym.Pool.CrowbarSwim"))
		
		self.waterContainer = self:addToScene(display.newGroup())
		self.waterContainer:setMask(graphics.newMask("assets/images/game/gym/pool/water_zoom_mask.png"))
		self.waterContainer.maskX, self.waterContainer.maskY = device.x(WaterMaskX+WaterMaskWidth/2), device.y(WaterMaskY+WaterMaskHeight/2)

		self.water1 = game.ui.insertChild(self.waterContainer, game.ui.newImage("assets/images/game/gym/pool/water_pool_zoom.png", device.x(WaterX), device.y(WaterY), WaterImageWidth, WaterImageHeight))
		self.water1.anchorX, self.water1.anchorY = 0.5,0.5
		self.water1.xScale = WaterXScale
		self.water1.yScale = WaterYScale
		self.water1.alpha = 0.7
		self.water2 = game.ui.insertChild(self.waterContainer, game.ui.newImage("assets/images/game/gym/pool/water_pool_zoom.png", device.x(WaterX), device.y(WaterY), WaterImageWidth, WaterImageHeight))
		self.water2.anchorX, self.water2.anchorY = 0.5,0.5
		self.water2.xScale = WaterXScale
		self.water2.yScale = WaterYScale
		self.water2.alpha = 0.5
	end
	
	self:addToHUD(game.ui.newBackButton("game.gym.pool"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		game.hud.show()
		if not game.events.isTriggered("game.gym.pool_water_drained") then
			Runtime:addEventListener("enterFrame", onEnterFrameEvent)
		end
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