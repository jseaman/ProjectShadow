-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

--------------------------------------------------------------------------------------------------

local solution = { 180, 90, 315 }

local buttons = 
{
	{
		name = "button1",
		x = 73, y = 112,
	},
	{
		name = "button2",
		x = 219, y = 112,
	},
	{
		name = "button3",
		x = 363, y = 112,
	},
}

--------------------------------------------------------------------------------------------------

local function getButtonState(button)
	game.data.trophy_lock_buttons = game.data.trophy_lock_buttons or {}	
	return game.data.trophy_lock_buttons[button.name] or 0
end

local function setButtonState(button, state)
	game.data.trophy_lock_buttons = game.data.trophy_lock_buttons or {}	
	game.data.trophy_lock_buttons[button.name] = state
	game.markAsChanged()
end

--------------------------------------------------------------------------------------------------

local function onButtonTouch(button)
	if game.puzzles.hasFinished("trophy_lock") or scene.rotateAnimation then
		return
	end
	
	local newRotation = button.image.rotation + 45
	local actualNewRotation = newRotation % 360
	
	scene.rotateAnimation = scene:newTransition(button.image, { rotation = newRotation, time = 300, onComplete=function()
		scene.rotateAnimation = nil
		button.image.rotation = actualNewRotation
	end})
	
	scene:playSound("button")
	
	setButtonState(button, actualNewRotation)
	
	if scene:checkSolution() then
		game.puzzles.finish("trophy_lock")
		scene:playSound("locker_unlock")
		scene:newTimer(900, function()
			game.scenes.gotoGameScene("game.gym.basketball_court_trophies")
		end)
	end
end

--------------------------------------------------------------------------------------------------

function scene:checkSolution()
	if not game.journal.hasEntry("Gym.Letter") then
		return false
	end
	
	for i = 1, #buttons do
		if getButtonState(buttons[i]) ~= solution[i] then
			return false
		end
	end
	
	return true
end

--------------------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/basketball_court/trophy_lock/trophy_shelf_puzzle.jpg"))
	
	self.rotateAnimation = nil
	
	for button in list_iter(buttons) do
		button.image = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/basketball_court/trophy_lock/trophy_shelf_puzzle_rotor.png", 
			device.x(button.x + 133/2), device.y(button.y + 133/2), 133, 133, 
			function()
				onButtonTouch(button)
			end
		))
		button.image.anchorX, button.image.anchorY = 0.5,0.5
		button.image.rotation = getButtonState(button)
		--local mask = graphics.newMask("assets/images/game/gym/basketball_court/trophy_lock/rotor_mask.png")
		--button.image:setMask(mask)
		--button.image.isHitTestMasked = true
	end	
	
	self:addToHUD(game.ui.newBackButton("game.gym.basketball_court_trophies"))
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

