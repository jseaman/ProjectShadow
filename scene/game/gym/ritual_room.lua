-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local CandleFrames =
{
	{ filename = "candle_light_1.png", w = 36, h = 35 },
	{ filename = "candle_light_2.png", w = 96, h = 96 },
}

local candles = 
{
	{
		statue = "anger",
		center = { x = 263, y = 66 },
		--center = { x = 264, y = 69 },
		frames = { { x = 246, y = 48 }, { x = 216, y = 21 } }
	},
	{
		statue = "pride",
		center = { x = 333, y = 36 },
		frames = { { x = 316, y = 18 }, { x = 286, y = -9 } }
	},
	{
		statue = "greed",
		center = { x = 401, y = 73 },
		frames = { { x = 382, y = 55 }, { x = 352, y = 28 } }
	},
	{
		statue = "gluttony",
		center = { x = 414, y = 144 },
		frames = { { x = 396, y = 125 }, { x = 366, y = 98 } }
	},
	{
		statue = "lust",
		center = { x = 366, y = 201 },
		frames = { { x = 348, y = 182 }, { x = 318, y = 155 } }
	},
	{
		statue = "envy",
		center = { x = 291, y = 201 },
		frames = { { x = 275, y = 183 }, { x = 245, y = 156 } }
	},
	{
		statue = "sloth",
		center = { x = 247, y = 141 },
		frames = { { x = 230, y = 123 }, { x = 200, y = 96 } }
	},
}

-----------------------------------------------------------------------------------------

function scene:isCandleOn(candle)
	return game.events.isTriggered("ritual_room." .. candle.statue)
end

-----------------------------------------------------------------------------------------

function scene:isAnyCandleOn()
	for candle in list_iter(candles) do
		if scene:isCandleOn(candle) then
			return true
		end
	end
	return false
end

-----------------------------------------------------------------------------------------

function scene:animateCandleFrame(frame)
	scene:newTransition(frame.image, { alpha = math.random(25, 50)/100, time = math.random(600, 2000), onComplete = function()
		scene:newTransition(frame.image, { alpha = math.random(60, 90)/100, time = math.random(600, 2000), onComplete = function()
			scene:animateCandleFrame(frame)
		end})
	end})
end

-----------------------------------------------------------------------------------------

function scene:animateCandles()
	for candle in list_iter(candles) do
		if scene:isCandleOn(candle) then
			for i = 1,#CandleFrames do
				local frame = candle.frames[i]
				scene:animateCandleFrame(frame)
			end
		end
	end
end

-----------------------------------------------------------------------------------------

local StarCenterX = 332
local StarCenterY = 123
local CandleDistance = 10

-----------------------------------------------------------------------------------------

function scene:animateCandleReveal(candle)
	local candleCenter = candle.center
	local dx, dy = (StarCenterX - candleCenter.x), (StarCenterY - candleCenter.y)
	local mag = math.sqrt(dx * dx + dy * dy)
	local dx_n = dx/mag
	local dy_n = dy/mag
	
	local newX = dx_n * (mag - CandleDistance)
	local newY = dy_n * (mag - CandleDistance)
	
	scene:newTransition(candle.candleGroup, { time = 6000, x = newX, y = newY, onComplete = function()
		if not game.events.isTriggered("ritual_room_item_revealed") then
			game.events.trigger("ritual_room_item_revealed")
			scene:playSound("appears")
			scene.ritualItem.isVisible = true
		end
		scene:newTimer(1000, function()
			scene:newTransition(candle.candleGroup, { time = 6000, x = 0, y = 0, onComplete = function()
			end})
		end)
	end})
end

-----------------------------------------------------------------------------------------

function scene:revealRitualItem()
	for candle in list_iter(candles) do
		candle.candleGroup:toFront()	
		scene:animateCandleReveal(candle)
	end
end

-----------------------------------------------------------------------------------------

function scene:createRitualItem()
	self.ritualItem = self:addToScene(game.ui.newSceneItem("assets/images/game/gym/ritual_room/diamond_handle.png", 
		device.x(283), device.y(77), 96, 99, "ShowerHandle"))
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	if scene:isAnyCandleOn() then
		self:addToScene(game.ui.newBackground("assets/images/game/gym/ritual_room/ritual_room.jpg"))
	else
		self:addToScene(game.ui.newBackground("assets/images/game/gym/ritual_room/ritual_room_dark.jpg"))
	end
	
	for candle in list_iter(candles) do
		if scene:isCandleOn(candle) then
			candle.candleGroup = self:addToScene(game.ui.newGroup())
			for i = 1,#CandleFrames do
				local candleFrame = CandleFrames[i]
				local frame = candle.frames[i]

				frame.image = game.ui.insertChild(candle.candleGroup, game.ui.newImage("assets/images/game/gym/ritual_room/" .. candleFrame.filename, 
					device.x(frame.x), device.y(frame.y), candleFrame.w, candleFrame.h))
			end
		end
	end
	
	if game.puzzles.hasFinished("ritual_room") then
		scene:createRitualItem()
		if not game.events.isTriggered("ritual_room_item_revealed") then
			self.ritualItem.isVisible = false
		end
	else
		self:addToScene(game.ui.newTouchAndGo(device.x(230), device.y(18), 176, 140, "game.gym.ritual_room_statue"))
	end
				
	self:addToHUD(game.ui.newBackButton("game.gym.principal_den"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("appears", "assets/sounds/game/gym/clang.mp3")
	elseif event.phase == "did" then
		game.hud.show()		
		scene:animateCandles()
		
		if not game.events.isTriggered("ritual_room.surprise") then
			scene:newTimer(600, function()			
				game.hud.showMyCaptionAndTrigger("ritual_room.surprise", i18n._"Gym.RitualRoom.Surprise")
			end)
		end
		
		if game.puzzles.hasFinished("ritual_room") and not game.events.isTriggered("ritual_room_item_revealed") then
			scene:revealRitualItem()
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