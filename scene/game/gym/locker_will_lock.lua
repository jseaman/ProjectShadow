-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

--------------------------------------------------------------------------------------------------

local colors = { "blue", "green", "orange" }

local startColor = "blue"

local buttons = 
{
	{
		name = "7_1",
		x = 97, y = 62, w = 87, h = 81,
		imageX = 97, imageY = 62, imageW = 87, imageH = 81,
		color = "blue",
		startColor = "green"
	},
	{
		name = "7_2",
		x = 245, y = 199, w = 85, h = 82,
		imageX = 245, imageY = 199, imageW = 85, imageH = 82,
		color = "blue",
		startColor = "blue"
	},
	{
		name = "9_1",
		x = 245, y = 74, w = 84, h = 83,
		imageX = 245, imageY = 74, imageW = 84, imageH = 83,
		color = "green",
		startColor = "orange"
	},
	{
		name = "9_2",
		x = 393, y = 213, w = 84, h = 82,
		imageX = 393, imageY = 213, imageW = 84, imageH = 82,
		color = "green",
		startColor = "blue"
	},
	{
		name = "8_1",
		x = 393, y = 61, w = 86, h = 83,
		imageX = 393, imageY = 61, imageW = 86, imageH = 83,
		color = "orange",
		startColor = "green"
	},
	{
		name = "8_2",
		x = 99, y = 211, w = 81, h = 81,
		imageX = 99, imageY = 211, imageW = 81, imageH = 81,
		color = "orange",
		startColor = "green"
	},
}

--------------------------------------------------------------------------------------------------

local function getButtonColor(button)
	game.data.will_lock_buttons = game.data.will_lock_buttons or {}	
	return game.data.will_lock_buttons[button.name] or button.startColor	
end

local function setButtonColor(button, color)	
	game.data.will_lock_buttons = game.data.will_lock_buttons or {}	
	game.data.will_lock_buttons[button.name] = color
	game.markAsChanged()
end

--------------------------------------------------------------------------------------------------

local function getNextColor(color)
	for i, c in ipairs(colors) do
		if c == color then
			local index = (i + 1) % (#colors + 1)
			if index == 0 then
				index = 1
			end
			return colors[index]
		end		
	end
	return colors[1]
end

--------------------------------------------------------------------------------------------------

local function onButtonTouch(button)
	if game.puzzles.hasFinished("locker_will_lock") then
		return
	end
	
	local color = getButtonColor(button)
	local nextColor = getNextColor(color)
	
	button.images[color].isVisible = false
	button.images[nextColor].isVisible = true
	
	setButtonColor(button, nextColor)
	
	scene:playSound("button")
	
	if scene:checkSolution() then
		scene:hideHUD()
		game.hud.hide()
		game.puzzles.finish("locker_will_lock")
		game.events.trigger("boys_locker_room.will_is_out")
		scene:playSound("locker_unlock")
		scene:newTimer(2000, function()
			scene:playSound("locker_open")			
			game.scenes.gotoGameScene("game.gym.boys_locker_room")
		end)
	end
end

--------------------------------------------------------------------------------------------------

function scene:checkSolution()
	if not game.journal.hasEntry("Gym.WillLock") then
		return false
	end
	
	for button in list_iter(buttons) do
		if getButtonColor(button) ~= button.color then
			return false
		end
	end
	return true
end

--------------------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/will_lock/bg_star_puzzle_zoom.jpg"))
			
	for button in list_iter(buttons) do
		button.images = {}
		local buttonColor = getButtonColor(button)
		for color in list_iter(colors) do
			button.images[color] = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/will_lock/stars/" .. button.name .. "_" .. color .. ".png", 
				device.x(button.imageX), device.y(button.imageY), button.imageW, button.imageH))
			button.images[color].isVisible = (buttonColor == color)
		end
		
		self:addToScene(game.ui.newTouchRegionTap(device.x(button.x), device.y(button.y), button.w, button.h, function()
			onButtonTouch(button)
		end))
	end
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_lockers"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("block", "assets/sounds/game/gym/block_move.mp3")
		self:loadSound("locker_open", "assets/sounds/game/gym/locker_open.mp3")
		self:loadSound("locker_unlock", "assets/sounds/game/gym/locker_unlock.mp3")
		self:loadSound("button", "assets/sounds/game/gym/block_hit.mp3")
	elseif event.phase == "did" then		
		game.hud.show()
		game.hud.showRandomCaption({who = "will", text = i18n._"Will.PleaseHelp2"})
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

