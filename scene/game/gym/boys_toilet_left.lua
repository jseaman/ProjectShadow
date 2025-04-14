--------------------------------------------------------------------------------------------------

local game = require("api.game")

--------------------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

--------------------------------------------------------------------------------------------------

local states = { "up", "mid", "down" }

--------------------------------------------------------------------------------------------------

local buttons = 
{
	{
		name = "blue",
		x = 146, y = 58, w = 46, h = 59,
		imageX = 146, imageY = 58, imageW = 46, imageH = 59,
		state = "mid", goodState = "up"
	},
	{
		name = "yellow",
		x = 146, y = 142, w = 46, h = 59,
		imageX = 146, imageY = 142, imageW = 46, imageH = 59,
		state = "up", goodState = "down"
	},
	{
		name = "green",
		x = 391, y = 54, w = 46, h = 59,
		imageX = 391, imageY = 54, imageW = 46, imageH = 59,
		state = "down", goodState = "mid"
	},	
	{
		name = "red",
		x = 391, y = 139, w = 46, h = 59,
		imageX = 391, imageY = 139, imageW = 46, imageH = 59,
		state = "mid", goodState = "up"
	}
}

--------------------------------------------------------------------------------------------------

local ToiletSolvedY = 140

--------------------------------------------------------------------------------------------------

local function getButtonState(button)
	game.data.toilet_buttons = game.data.toilet_buttons or {}	
	return game.data.toilet_buttons[button.name] or button.state	
end

local function setButtonState(button, state)	
	game.data.toilet_buttons = game.data.toilet_buttons or {}	
	game.data.toilet_buttons[button.name] = state
	game.markAsChanged()
end

--------------------------------------------------------------------------------------------------

local function getNextState(state)
	for i, c in ipairs(states) do
		if c == state then
			local index = (i + 1) % (#states + 1)
			if index == 0 then
				index = 1
			end
			return states[index]
		end		
	end
	return states[1]
end

--------------------------------------------------------------------------------------------------

local function onButtonTouch(button)
	if game.puzzles.hasFinished("boys_toilet_left") then
		return
	end
	
	local state = getButtonState(button)
	local nextState = getNextState(state)
	
	button.images[state].isVisible = false
	button.images[nextState].isVisible = true
	
	setButtonState(button, nextState)
	
	scene:playSound("button")
	
	if scene:checkSolution() then
		scene:hideHUD()
		game.hud.hide()
		game.puzzles.finish("boys_toilet_left")
		scene:startToiletAnimation()
	end
end

--------------------------------------------------------------------------------------------------

function scene:checkSolution()
	if not game.journal.hasEntry("Gym.BowlPhoto") then
		return false
	end
	
	for button in list_iter(buttons) do
		if getButtonState(button) ~= button.goodState then
			return false
		end
	end
	return true
end

--------------------------------------------------------------------------------------------------

function scene:startToiletAnimation()
	self.shakeEffect = game.effects.newShakeEffect({
		group = self.toilet,
		amount = 40,
		intensity = 2
	})
	self.shakeEffect:start()
	self:playSound("rumble")
	system.vibrate()
	
	self:newTransition(self.toiletGroup, { y = ToiletSolvedY, time = 1400, onComplete = function()
		game.hud.show()
		scene:showHUD()
	end})
end

--------------------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_bathroom/toilets/bg_left_toilet.jpg"))
		
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/boys_bathroom/toilets/man_medal.png", 
		device.x(278), device.y(142), 34, 22, "ChestRoundCrest"))
		
	self.toiletGroup = self:addToScene(game.ui.newGroup())	
	self.toilet = game.ui.insertChild(self.toiletGroup, game.ui.newHardImage("assets/images/game/gym/boys_bathroom/toilets/toilet.png", device.x(193), device.y(39), 223, 322))
	game.ui.insertChild(self.toiletGroup, game.ui.newTouchAndGo(device.x(205), device.y(19), 170, 172, "game.gym.boys_toilet_left_tank"))
	game.ui.insertChild(self.toiletGroup, game.ui.newTouchInfo(device.x(205), device.y(209), 170, 119, i18n._"Gym.Toilet.Bowl"))
	
	if game.puzzles.hasFinished("boys_toilet_left") then
		self.toiletGroup.y = ToiletSolvedY
	end
	
	for button in list_iter(buttons) do
		button.images = {}
		local buttonState = getButtonState(button)
		for state in list_iter(states) do
			if button.images[state] == nil then
				button.images[state] = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_bathroom/toilets/planks/plank_" .. button.name .. "_" .. state .. ".jpg", 
					device.x(button.imageX), device.y(button.imageY), button.imageW, button.imageH))
				button.images[state].isVisible = (buttonState == state)
			end
		end
		
		self:addToScene(game.ui.newTouchRegionTap(device.x(button.x), device.y(button.y), button.w, button.h, function()
			onButtonTouch(button)
		end))
	end
	
	self:addToScene(game.ui.newTouchInfo(device.x(100), device.y(218), 35, 59, i18n._"Gym.Toilet.ToiletPaper"))
	self:addToScene(game.ui.newTouchInfo(device.x(377), device.y(223), 67, 104, i18n._"Gym.Toilet.LeftGraffiti"))
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_toilets"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("button", "assets/sounds/game/gym/switch.mp3")
		self:loadSound("rumble", "assets/sounds/game/gym/earth_rumble.mp3")
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