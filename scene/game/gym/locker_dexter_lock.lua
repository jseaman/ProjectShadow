-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

--------------------------------------------------------------------------------------------------

local solution = { "fire", "chalice", "peace", "rebirth" }

local pressed = { }
local restarting = false

local buttons = 
{
	{
		name = "water",
		x = 215, y = 37, w = 137, h = 100,
	},
	{
		name = "chalice",
		x = 310, y = 55, w = 119, h = 123,
	},
	{
		name = "rebirth",
		x = 311, y = 180, w = 118, h = 123,
	},
	{
		name = "peace",
		x = 218, y = 223, w = 137, h = 101,
	},
	{
		name = "blessing",
		x = 142, y = 182, w = 118, h = 123,
	},
	{
		name = "fire",
		x = 142, y = 57, w = 117, h = 123,
	},
}

--------------------------------------------------------------------------------------------------

local function onButtonTouch(button)
	if game.puzzles.hasFinished("locker_dexter_lock") or restarting then
		return
	end
	
	table.insert(pressed, button.name)
	button.unpressedImage.isVisible = false
	
	scene:playSound("button")
	
	if scene:checkSolution() then
		scene:hideHUD()
		game.hud.hide()
		game.puzzles.finish("locker_dexter_lock")
		game.events.trigger("dexter_locker_unlocked")
		scene:newTimer(300, function()
			scene:playSound("gear")
			scene:newTransition(scene.gearObject, { time = 600, rotation = 360, onComplete=function()
				scene:playSound("locker_unlock")
				scene:newTimer(800, function()
					scene:playSound("locker_open")	
					game.scenes.gotoGameScene("game.gym.locker_dexter")
				end)
			end})
		end)
	elseif #pressed == 4 then
		scene:restartGame()
	end
end

--------------------------------------------------------------------------------------------------

function scene:restartGame()
	restarting = true
	pressed = {}
	scene:newTimer(800, function()
		for button in list_iter(buttons) do
			button.unpressedImage.isVisible = true
		end
		scene:playSound("button")
		restarting = false
	end)
end

--------------------------------------------------------------------------------------------------

function scene:checkSolution()
	if not game.journal.hasEntry("Gym.DexterLock") then
		return false
	end
	
	if #pressed == #solution then
		for i = 1, #pressed do
			if pressed[i] ~= solution[i] then
				return false
			end
		end
		return true
	end
	return false
end

--------------------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/dexter/dexter_puzzle_zoom.jpg"))
	
	pressed = {}
	
	for button in list_iter(buttons) do
		button.unpressedImage = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/boys_locker_room/dexter/dexter_puzzle_" .. button.name .. ".png", 
			device.x(button.x), device.y(button.y), button.w, button.h, 
			function()
				onButtonTouch(button)
			end
		))
		local mask = graphics.newMask("assets/images/game/gym/boys_locker_room/dexter/" .. button.name .. "_mask.png")
		button.unpressedImage:setMask(mask)
		button.unpressedImage.isHitTestMasked = true
	end	
	
	self.gearObject = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/dexter/dexter_puzzle_center.png", 
		device.x(285), device.y(180), 95, 95))
	self.gearObject.anchorX, self.gearObject.anchorY = 0.5, 0.5
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_lockers"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("block", "assets/sounds/game/gym/block_move.mp3")
		self:loadSound("locker_open", "assets/sounds/game/gym/locker_open.mp3")
		self:loadSound("locker_unlock", "assets/sounds/game/gym/locker_unlock.mp3")
		self:loadSound("button", "assets/sounds/game/gym/block_hit.mp3")
		self:loadSound("gear", "assets/sounds/game/gym/gear.mp3")
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

