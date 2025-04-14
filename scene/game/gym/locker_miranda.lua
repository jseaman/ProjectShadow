-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onNewspaperTouch()
	scene.newspaper = game.ui.removeSelf(scene.newspaper)
	game.journal.addNextCutout()
	game.events.trigger("gym.locker_miranda.newspaper")
	return true
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/girls_locker_room/mirandas_locker.jpg"))
	
	if not game.events.isTriggered("gym.locker_miranda.newspaper") then
		self.newspaper = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/girls_locker_room/newspaper_piece_locker.png", device.x(341), device.y(122), 56, 59, onNewspaperTouch))
	end
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/girls_locker_room/battery.png", 
		device.x(184), device.y(78), 65, 34, "PoweredRobot", function() 
			game.inventory.discard("Robot")
			game.achievements.unlock("power_robot")
			
			self:playSound("robot_on")
			
			local noiseCount = 0
			
			self:newTimer(800, function()
				self:playSound("robot_noise")
				
				noiseCount = noiseCount + 1
				if noiseCount >= 6 then
					self:newTimer(500, function()
						self:playSound("robot_on")
						game.hud.showInfoCaption(i18n._"MirandaLocker.Attention")
					end)							
				end
			end, 6)
		end))
		
	self:addToScene(game.ui.newTouchRegionTap(device.x(251), device.y(49), 87, 66, function()
		game.scenes.gotoJournal("miranda")
	end))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/girls_locker_room/apple.png", 
		device.x(192), device.y(134), 63, 42, "Apple"))	
	
	self:addToScene(game.ui.newBackButton(function()
		scene:playSound("locker_close")
		game.scenes.gotoGameScene("game.gym.girls_lockers")
	end))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene:loadSound("locker_close", "assets/sounds/game/gym/locker_close.mp3")
		scene:loadSound("robot_on", "assets/sounds/game/gym/robot_turn_on.mp3")
		scene:loadSound("robot_noise", "assets/sounds/game/gym/robot_noise.mp3")
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