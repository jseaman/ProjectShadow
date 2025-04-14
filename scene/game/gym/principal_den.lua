-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onStairsTouch()
	if game.events.isTriggered("principal_den.stairs") then
		scene:playSound("stairs_footsteps")
		game.scenes.gotoGameScene("game.gym.principal_attic", "fade", 3000)
	end
end

-----------------------------------------------------------------------------------------

function scene:showStairs()
	self:playSound("stairs_chain")
	self:playSound("stairs_shake")
	scene:newTransition(self.stairs, { y = device.y(0), time = 3000, onComplete = function()
		game.events.trigger("principal_den.stairs")
		game.achievements.unlock("portrait")
	end})
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/principal_den/principal_den.jpg"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(233), device.y(270), 337, 90, i18n._"PrincipalDen.Floor"))
	
	if game.puzzles.hasFinished("principal_den_wall") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/principal_den/wall_open.jpg", device.x(466), device.y(41), 105, 229))
		if not game.events.isTriggered("ritual_room_pre") then
			self:addToScene(game.ui.newTouchAndGo(device.x(478), device.y(95), 56, 93, "game.gym.ritual_room_pre"))
		else
			self:addToScene(game.ui.newTouchAndGo(device.x(478), device.y(95), 56, 93, "game.gym.ritual_room"))
		end
	else
		self:addToScene(game.ui.newTouchAndGo(device.x(478), device.y(95), 56, 93, "game.gym.principal_den_wall"))
	end
	
	self:addToScene(game.ui.newTouchAndGo(device.x(234), device.y(154), 154, 105, "game.gym.principal_den_desk"))
	
	if not game.puzzles.hasFinished("principal_den_portrait") then
		self:addToScene(game.ui.newTouchAndGo(device.x(233), device.y(35), 146, 99, "game.gym.principal_den_portrait"))
	else
		self:addToScene(game.ui.newImage("assets/images/game/gym/principal_den/portrait_solved.jpg", device.x(242), device.y(50), 126, 72))
		self:addToScene(game.ui.newTouchInfo(device.x(155), device.y(180), 51, 59, i18n._"PrincipalDen.Portrait"))
	end
	
	self:addToScene(game.ui.newTouchInfo(device.x(170), device.y(182), 60, 40, i18n._"PrincipalDen.Books"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(45), device.y(209), 130, 109, i18n._"PrincipalDen.Bed"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(8), device.y(59), 62, 95, i18n._"PrincipalDen.Clock"))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/principal_den/pillow.png", 
		device.x(113), device.y(219), 68, 24, "Pillow"))
		
	if game.puzzles.hasFinished("principal_den_portrait") then
		self.stairs = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/principal_den/stairs.png", device.x(381), device.y(-207), 87, 207, onStairsTouch))
		if game.events.isTriggered("principal_den.stairs") then
			self.stairs.y = device.y(0)
		end
	end
			
	self:addToScene(game.ui.newBackButton("game.gym.basketball_court_trophies"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("stairs_chain", "assets/sounds/game/gym/stairs_chains.mp3")
		self:loadSound("stairs_shake", "assets/sounds/game/gym/stairs_shake.mp3")
		self:loadSound("stairs_footsteps", "assets/sounds/game/gym/footsteps2.mp3")
	elseif event.phase == "did" then
		game.hud.show()
		
		if game.puzzles.hasFinished("principal_den_portrait") and not game.events.isTriggered("principal_den.stairs") then
			scene:showStairs()
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