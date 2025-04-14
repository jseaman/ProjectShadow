-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

--------------------------------------------------------------------------------------------------

local solution = { "brick_3", "brick_5", "brick_1", "brick_4", "brick_2" }

local pressed = { }
local restarting = false

local buttons = 
{
	{
		name = "brick_1",
		x = 163, y = 52, w = 127, h = 76,
	},
	{
		name = "brick_2",
		x = 289, y = 52, w = 98, h = 68,
	},
	{
		name = "brick_3",
		x = 129, y = 137, w = 122, h = 61,
	},
	{
		name = "brick_4",
		x = 331, y = 172, w = 105, h = 76,
	},
	{
		name = "brick_5",
		x = 138, y = 232, w = 140, h = 75,
	},
}

local walls = 
{	
	{
		name = "wall_lbot", dir = "left",
		x = 0, y = 220, w = 369, h = 141,
	},
	{
		name = "wall_rtop", dir = "right",
		x = 240, y = 0, w = 330, h = 212,
	},
	{
		name = "wall_rbot", dir = "right",
		x = 197, y = 123, w = 373, h = 238,
	},
	{
		name = "wall_lmid", dir = "left",
		x = 0, y = 97, w = 303, h = 178,
	},
	{
		name = "wall_ltop", dir = "left",
		x = 0, y = 0, w = 341, h = 152,
	},	
}

--------------------------------------------------------------------------------------------------

local function onButtonTouch(button)
	if game.puzzles.hasFinished("principal_den_wall") or restarting then
		return
	end
	
	table.insert(pressed, button.name)
	button.unpressedImage.isVisible = false
	
	--scene:playSound("button" .. math.random(1,3))
	scene:playSound("button1")
	
	if scene:checkSolution() then
		game.puzzles.finish("principal_den_wall")
		game.achievements.unlock("principal_den_wall")
		
		scene:newTimer(500, function()
			scene:startWallAnimation()
		end)
	elseif #pressed == 5 then
		scene:restartGame()
	end
end

--------------------------------------------------------------------------------------------------

local function onWallTouch()
	if not game.puzzles.hasFinished("principal_den_wall") then
		return
	end
	
	if not game.events.isTriggered("ritual_room_pre") then
		game.scenes.gotoGameScene("game.gym.ritual_room_pre")
	else
		game.scenes.gotoGameScene("game.gym.ritual_room")
	end
end

--------------------------------------------------------------------------------------------------

function scene:startWallAnimation()
	scene:hideHUD()
	game.hud.hide()
	
	scene:startLights()
end

-----------------------------------------------------------------------------------------

function scene:showDust()
	self:addToScene(game.particles.createParticle("principal_den_wall_dust", "dust", device.x(250), device.y(300)))
	game.particles.startEmitters({ "dust" })	
	game.particles.start()
end

function scene:hideDust()
	game.particles.deleteEmitter("dust")
end

--------------------------------------------------------------------------------------------------

function scene:startLights()
	scene:playSound("beam")
	--scene:newTransition(scene.brickGlow, { time = 600, alpha = 1, onComplete = function()
		--scene:newTransition(scene.brickGlow, { time = 600, alpha = 0, onComplete = function()
			scene:newTransition(scene.wallGlow, { time = 1200, alpha = 1, onComplete = function()
				scene:newTransition(scene.wallGlow, { time = 500, alpha = 0, onComplete = function()
					scene:openWall()
				end})
			end})
		--end})
	--end})
end

--------------------------------------------------------------------------------------------------

function scene:openWall()
	self.shakeEffect = game.effects.newShakeEffect({
		group = self.sceneLayer,
		amount = 50,
		intensity = 5
	})
	self.shakeEffect:start()
	self:playSound("rumble")
	system.vibrate()
	
	for wall in list_iter(walls) do
		scene:newTransition(wall.image, { time = 700, delay = math.random(300, 600), x = (wall.dir == "left" and (wall.image.x - 190)) or (wall.image.x + 210) })
	end
	
	--scene:showDust()
	
	scene:newTimer(1000, function()
		--scene:hideDust()
		scene:showHUD()
		game.hud.show()
	end)
end

--------------------------------------------------------------------------------------------------

function scene:restartGame()
	restarting = true
	pressed = {}
	scene:newTimer(800, function()
		for button in list_iter(buttons) do
			button.unpressedImage.isVisible = true
		end
		scene:playSound("button" .. math.random(1,3))
		restarting = false
	end)
end

--------------------------------------------------------------------------------------------------

function scene:checkSolution()
	if not game.journal.hasEntry("Gym.Bricks") then
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
	self:addToScene(game.ui.newBackground("assets/images/game/gym/principal_den/brick_puzzle/bg_brick_puzzle.jpg"))
	
	pressed = {}
	restarting = false
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(100), device.y(0), 200, 360, onWallTouch))
	
	for wall in list_iter(walls) do
		wall.image = self:addToScene(game.ui.newImage("assets/images/game/gym/principal_den/brick_puzzle/" .. wall.name .. ".png", 
			device.x(wall.x), device.y(wall.y), wall.w, wall.h
		))
	end
	
	for button in list_iter(buttons) do
		button.unpressedImage = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/principal_den/brick_puzzle/" .. button.name .. ".png", 
			device.x(button.x), device.y(button.y), button.w, button.h, 
			function()
				onButtonTouch(button)
			end
		))
	end
	
	self.brickGlow = self:addToScene(game.ui.newImage("assets/images/game/gym/principal_den/brick_puzzle/bricks_glow.png", 
		device.x(119), device.y(39), 334, 280
	))
	self.brickGlow.alpha = 0
	
	self.wallGlow = self:addToScene(game.ui.newImage("assets/images/game/gym/principal_den/brick_puzzle/wall_glow.png", 
		device.x(0), device.y(0), 570, 360
	))
	self.wallGlow.alpha = 0
		
	self:addToHUD(game.ui.newBackButton("game.gym.principal_den"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("block", "assets/sounds/game/gym/block_move.mp3")
		self:loadSound("locker_open", "assets/sounds/game/gym/locker_open.mp3")
		self:loadSound("locker_unlock", "assets/sounds/game/gym/locker_unlock.mp3")
		self:loadSound("button1", "assets/sounds/game/gym/brick.mp3")
		self:loadSound("button2", "assets/sounds/game/gym/brick2.mp3")
		self:loadSound("button3", "assets/sounds/game/gym/brick3.mp3")
		self:loadSound("rumble", "assets/sounds/game/gym/earth_rumble.mp3")
		self:loadSound("beam", "assets/sounds/game/gym/beam.mp3")
	elseif event.phase == "did" then		
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		scene:hideDust()
		game.particles.cleanUp()
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene

