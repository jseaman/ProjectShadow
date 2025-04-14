-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local statues = 
{
	{ 
		name = "anger", 
		glow = { x = 118, y = 95, w = 322, h = 266 },
		item = { name = "RobotHead", filename = "robot_head_placed.png", x = 260, y = 256, w = 64, h = 62 }
	},
	
	{ 
		name = "pride", 
		glow = { x = 124, y = 41, w = 322, h = 320 },
		item = { name = "Mirror", filename = "mirror_placed.png", x = 205, y = 266, w = 152, h = 46 }
	},
	
	{ 
		name = "greed", 
		glow = { x = 124, y = 41, w = 322, h = 320 },
		item = { name = "Treasure", filename = "dragon_placed.png", x = 190, y = 227, w = 165, h = 75 }
	},
	
	{ 
		name = "gluttony", 
		glow = { x = 124, y = 41, w = 322, h = 320 },
		item = { name = "Chips", filename = "porkitos_placed.png", x = 230, y = 267, w = 96, h = 53 }
	},
	
	{ 
		name = "lust", 
		glow = { x = 124, y = 41, w = 322, h = 320 },
		item = { name = "Apple", filename = "apple_placed.png", x = 237, y = 292, w = 53, h = 44 }
	},	
	
	{ 
		name = "envy", 
		glow = { x = 124, y = 41, w = 322, h = 320 },
		item = { name = "VandalizedPhoto", filename = "mirandas_photo_placed.png", x = 246, y = 275, w = 64, h = 34 }
	},
	
	{ 
		name = "sloth", 
		glow = { x = 124, y = 41, w = 322, h = 320 },
		item = { name = "Pillow", filename = "pillow_placed.png", x = 156, y = 191, w = 243, h = 132 }
	},	
}

-----------------------------------------------------------------------------------------

local NavButtonHeight = 45
local NavButtonWidth = 45
local NavButtonTop = display.contentHeight/2 - NavButtonHeight/2 - 20

-----------------------------------------------------------------------------------------

local function onLeftButtonRelease(event)
	game.hud.hideCaption()
	scene:setCurrentStatue(game.data.ritual_room_statue - 1)
end

-----------------------------------------------------------------------------------------

local function onRightButtonRelease(event)
	game.hud.hideCaption()
	scene:setCurrentStatue(game.data.ritual_room_statue + 1)
end

-----------------------------------------------------------------------------------------

local function findStatue(statueName)
	for i,statue in ipairs(statues) do
		if statue.name == statueName then
			return i, statue
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:animateCandle()
	self.candleTransition = scene:newTransition(self.statueGroup.candleGlow, { alpha = math.random(0.1, 0.4), time = math.random(600, 2000), onComplete = function()
		self.candleTransition = scene:newTransition(self.statueGroup.candleGlow, { alpha = math.random(0.7, 1), time = math.random(600, 2000), onComplete = function()
			scene:animateCandle()
		end})
	end})
end

function scene:stopCandle()
	self.candleTransition = game.ui.cancelTransition(self.candleTransition)
end

-----------------------------------------------------------------------------------------

function scene:hasMadeAllOfferings()
	for statue in list_iter(statues) do
		if not game.inventory.hasDiscardedItem(statue.item.name) then
			return false
		end
	end
	return true
end

-----------------------------------------------------------------------------------------

function scene:isCandleOn(statue)
	return game.events.isTriggered("ritual_room." .. statue.name)
end

-----------------------------------------------------------------------------------------

function scene:isAnyCandleOn()
	for statue in list_iter(statues) do
		if scene:isCandleOn(statue) then
			return true
		end
	end
	return false
end

-----------------------------------------------------------------------------------------

function scene:setupStatue(statue)
	local group = game.ui.newGroup()
	group.statue = statue
	
	group:insert(game.ui.newBackground("assets/images/game/gym/ritual_room/statues/" .. statue.name .. "_zoom.jpg"))
	
	group.candleGlow = game.ui.insertChild(group,
		--game.ui.newImage("assets/images/game/gym/ritual_room/statues/" .. statue.name .. "_glow.png", statue.glow.x, statue.glow.y, statue.glow.w, statue.glow.h))
		game.ui.newBackground("assets/images/game/gym/ritual_room/statues/" .. statue.name .. "_glow.jpg"))
	group.candleGlow.alpha = 0
	
	local function createPlacedItem()
		game.ui.insertChild(group, 
			game.ui.newImage("assets/images/game/gym/ritual_room/statues/items/" .. statue.item.filename, device.x(statue.item.x), device.y(statue.item.y), statue.item.w, statue.item.h))
	end	
	
	local eventName = "ritual_room." .. statue.name	
	if not game.events.isTriggered(eventName) then
		game.ui.insertChild(group, game.ui.newItemRegion(device.x(126), device.y(0), 315, 360, {
			itemName = statue.item.name,
			onCorrectItem = { text = i18n._"Gym.RitualRoom.OfferingPlaced", event = eventName, handler = function()
				scene:playSound("metal")
				createPlacedItem()
				
				scene:stopCandle()
				scene:animateCandle()
				
				if scene:hasMadeAllOfferings() then
					game.puzzles.finish("ritual_room")
					game.hud.hide()
					scene:hideHUD()
					game.achievements.unlock("statues")
					
					scene:newTimer(500, function()
						self.shakeEffect = game.effects.newShakeEffect({
							group = self.sceneLayer,
							amount = 30,
							intensity = 5
						})
						self.shakeEffect:start()
						system.vibrate()
					end)
					
					scene:newTimer(2500, function()
						game.scenes.gotoGameScene("game.gym.ritual_room")
					end)
				end
			end},
			onNoItem = i18n._("Gym.RitualRoom.StatueInfo." .. statue.name),
		}))
	else
		createPlacedItem()
	end
	
	return group
end

-----------------------------------------------------------------------------------------

function scene:setCurrentStatue(statueIndex)
	if self.changingStatue then
		return
	end
	
	self.changingStatue = true
	
	local statueDirection = (statueIndex > scene:getCurrentStatue() and 1) or -1
	
	if statueIndex <= 0 then
		statueIndex = #statues
	end
	if statueIndex > #statues then
		statueIndex = 1
	end
	
	game.data.ritual_room_statue = statueIndex
	game.markAsChanged()
	
	local oldStatueGroup = self.statueGroup
	local statue = statues[statueIndex]
	self.statueGroup = scene:addToScene(scene:setupStatue(statue))
	
	self:cleanupTransitions()
	
	if scene:isAnyCandleOn() then
		scene:animateCandle()
	end
	
	if oldStatueGroup ~= nil then
		self.statueGroup.x = statueDirection * 570
		scene:newTransition(oldStatueGroup, { x = statueDirection * -1 * 570, time = 1000 })
		scene:newTransition(self.statueGroup, { x = 0, time = 1000, onComplete = function()
			self.changingStatue = false
		end})
	else
		self.changingStatue = false
	end
end

-----------------------------------------------------------------------------------------

function scene:getCurrentStatue()
	return game.data.ritual_room_statue or 1
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self.statueGroup = nil
	self.changingStatue = false
	
	scene:setCurrentStatue(scene:getCurrentStatue())
	
	self.leftButton = self:addToHUD(game.ui.newButton(10 + 5, NavButtonTop, {
		defaultFile = "assets/images/game/gym/ritual_room/statues/left_button.png", overFile = "assets/images/game/gym/ritual_room/statues/left_button_over.png",
		width = NavButtonWidth, height = NavButtonHeight, onRelease = onLeftButtonRelease
	}))

	self.rightButton = self:addToHUD(game.ui.newButton(display.contentWidth - NavButtonWidth - 10 - 5, NavButtonTop, {
		defaultFile = "assets/images/game/gym/ritual_room/statues/right_button.png", overFile = "assets/images/game/gym/ritual_room/statues/right_button_over.png",
		width = NavButtonWidth, height = NavButtonHeight, onRelease = onRightButtonRelease
	}))	
	
	self:addToHUD(game.ui.newBackButton("game.gym.ritual_room"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("metal", "assets/sounds/game/gym/metal2.mp3")
	elseif event.phase == "did" then
		game.hud.show()
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