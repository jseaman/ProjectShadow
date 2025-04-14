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
local WaterY = 185 + WaterImageHeight/2
local WaterXScale = (WaterWidth + 50) / WaterImageWidth
local WaterYScale = 1

-----------------------------------------------------------------------------------------

local doors =
{
	["girls"] = {
		filename = "pool_left.png", x = 74, y = 108, w = 22, h = 103
	},
	["control"] = {
		filename = "pool_maintenance.jpg", x = 348, y = 129, w = 28, h = 65
	},
	["court"] = {
		filename = "pool_court.png", x = 251, y = 119, w = 64, h = 75
	},
	["boys"] = {
		filename = "pool_right.png", x = 471, y = 107, w = 21, h = 103
	},
}

-----------------------------------------------------------------------------------------

local function onEnterFrameEvent(event)
	local now = system.getTimer()/1000
	scene.water1.x = WaterX + math.sin(now * 2) * 2
	scene.water1.y = WaterY + math.cos(now * 3.1) * 2
	scene.water2.x = WaterX + math.sin(now * 2)
	scene.water2.y = WaterY + math.cos(now * 3.1)
	scene.water1.xScale = WaterXScale + math.sin(now * 2) * 0.04
	scene.water1.yScale = WaterYScale + math.cos(now * 1.2) * 0.04
	scene.water2.xScale = -WaterXScale + math.sin(now * 1) * 0.01
	scene.water2.yScale = WaterYScale + math.cos(now * 2.2) * 0.01
end

-----------------------------------------------------------------------------------------

function scene:animateGlow(glow, times)
	times = times or math.random(2,5)
	if times <= 0 then
		scene:startNextGlow(glow)
		return
	end
	
	glow.alpha = 0
	
	scene:newTransition(glow, { alpha = 1, delay = math.random(20, 60), time = math.random(60, 120), onComplete = function()
		scene:newTransition(glow, { alpha = 0, delay = math.random(20, 60), time = math.random(60, 120), onComplete = function()
			scene:animateGlow(glow, times - 1)
		end})
	end})
end

-----------------------------------------------------------------------------------------

function scene:startNextGlow(glow)
	glow.alpha = 0
	scene:newTimer(math.random(1000, 10000), function()
		scene:animateGlow(glow)
	end)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/pool/bg_pool.jpg"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(176), device.y(88), 29, 14, i18n._"Pool.Vents"))
	self:addToScene(game.ui.newTouchInfo(device.x(271), device.y(88), 29, 14, i18n._"Pool.Vents"))
	self:addToScene(game.ui.newTouchInfo(device.x(365), device.y(88), 29, 14, i18n._"Pool.Vents"))	
	self:addToScene(game.ui.newTouchInfo(device.x(94), device.y(0), 375, 79, i18n._"Pool.Roof"))
	self:addToScene(game.ui.newTouchInfo(device.x(0), device.y(297), 585, 63, i18n._"Pool.Floor"))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(472), device.y(99), 24, 113, "game.gym.boys_locker_room", "pool"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(151), device.y(124), 47, 69, "game.gym.vending_machine"))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(250), device.y(121), 66, 77, "game.gym.basketball_court", "pool"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(345), device.y(131), 33, 67, "game.gym.pool_control_room"))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(74), device.y(99), 24, 113, "game.gym.girls_locker_room", "pool"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(100), device.y(200), 350, 70, "game.gym.pool_edge"))
	
	if not game.events.isTriggered("game.gym.pool_water_drained") then
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
	
	self.signGlow = self:addToScene(game.ui.newImage("assets/images/game/gym/pool/glow.jpg", device.x(147), device.y(123), 51, 26))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene.doorEffect = game.effects.newDoorClosesEffect(scene, doors, "pool")
	elseif event.phase == "did" then
		game.hud.show()
		
		if scene.doorEffect then
			scene.doorEffect:start()
		end
		
		if not game.events.isTriggered("game.gym.pool_water_drained") then
			Runtime:addEventListener("enterFrame", onEnterFrameEvent)
		end		
		scene:startNextGlow(scene.signGlow)
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