-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onLouLockerTouch()
	scene:playSound("locker_open")
	if game.events.isTriggered("boys_locker_room.shade_baited") and not game.events.isTriggered("boys_locker_room.shade_baited_done") then
		game.scenes.gotoGameScene("game.gym.locker_lou_baited")
	else
		game.scenes.gotoGameScene("game.gym.locker_lou_hide")
	end
end

-----------------------------------------------------------------------------------------

local function onWillLockerTouch()
	if game.events.isTriggered("boys_locker_room.scare1_will_left") and not game.events.isTriggered("boys_locker_room.will_is_out") then
		if not game.events.isTriggered("boys_locker_room.scare1_shade_left") then
			game.hud.showCaption({who = "will", text = i18n._"Will.Hide!"})
		else
			game.scenes.gotoGameScene("game.gym.locker_will_lock")
		end
	elseif game.events.isTriggered("boys_locker_room.shade_baited") and not game.events.isTriggered("boys_locker_room.shade_baited_done") then
			game.hud.showMyCaption(i18n._"Lou.Lockers.BetterHide")
	elseif not game.events.isTriggered("boys_locker_room.scare1_will_left") or 
		(game.events.isTriggered("boys_locker_room.will_is_out") and not game.events.isTriggered("will.toilet")) then
		game.hud.showCaption({who = "will", text = i18n._"Will.ThatsMyLocker"})
	elseif game.events.isTriggered("boys_locker_room.will_is_out") then
		game.scenes.gotoGameScene("game.gym.locker_will")
	end
end

-----------------------------------------------------------------------------------------

local function onDexterLockerTouch()
	if game.events.isTriggered("boys_locker_room.shade_baited") and not game.events.isTriggered("boys_locker_room.shade_baited_done") then
		game.hud.showMyCaption(i18n._"Lou.Lockers.BetterHide")	
	elseif game.events.isTriggered("boys_locker_room.scare1_start") and not game.events.isTriggered("boys_locker_room.scare1") then
		game.hud.showMyCaption(i18n._"Lou.Lockers.BetterHide")
	elseif game.events.isTriggered("dexter_locker_unlocked") then
		scene:playSound("locker_open")
		game.scenes.gotoGameScene("game.gym.locker_dexter")
	else
		game.scenes.gotoGameScene("game.gym.locker_dexter_lock")
	end
end

-----------------------------------------------------------------------------------------

local function onGatesLockerTouch()
	if game.events.isTriggered("gates_locker_unlocked") then
		scene:playSound("locker_open")
		game.scenes.gotoGameScene("game.gym.locker_gates")
	else
		game.hud.showInfoCaption(i18n._"Gym.BoysLockers.GatesLocked")
	end
end

-----------------------------------------------------------------------------------------

local function onJasonLockerTouch()
	game.scenes.gotoGameScene("game.gym.locker_jason")
end

-----------------------------------------------------------------------------------------

function scene:playShadeShriek()
	self:newTimer(math.random(400, 5000), function()
		self:playSound("shriek")
		scene:playShadeShriek()
	end)
end

function scene:startRobot()
	if game.events.isTriggered("jason_locker_destroyed") then
		return
	end
	
	if game.events.isTriggered("jason_locker_robot_placed") and self.robot then		
		if not game.events.isTriggered("jason_locker_robot_turned_on") then
			self:playSound("robot_on")
			game.events.trigger("jason_locker_robot_turned_on")
		end
		self.robotPower.isVisible = true
		self:newTimer(800, function()
			self:playSound("robot_noise")
			self.robotEyes.isVisible = not self.robotEyes.isVisible
		end, 0)
		
		self:playShadeShriek()
	end
end

function scene:createRobot(override)
	if game.events.isTriggered("jason_locker_destroyed") then
		return
	end
	
	if (game.events.isTriggered("jason_locker_robot_placed") or override) and not self.robot then
		self.robot = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/robot.png", device.x(476), device.y(162), 42, 80))
		self.robotEyes = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/robot_light_eyes.png", device.x(488), device.y(167), 17, 12))
		self.robotEyes.isVisible = false
		self.robotPower = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/robot_light_on.png", device.x(494), device.y(186), 4, 3))
		self.robotPower.isVisible = false
	end
end

function scene:createBaitedTouchRegion()
	if game.events.isTriggered("jason_locker_destroyed") then
		return
	end
	
	if game.events.isTriggered("boys_locker_room.shade_baited") then
		self:addToScene(game.ui.newTouchInfo(device.x(428), device.y(59), 68, 257, i18n._"Gym.BoysLockers.AfterRobotPlaced"))
	end

	scene:createRobot()
end

function scene:createCrowbarHole()
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/jason_locker_bighole.png", device.x(475), device.y(146), 23, 101))
	
	self:addToScene(game.ui.newItemRegion(device.x(428), device.y(59), 68, 257, {
		itemName = "PoweredRobot",
		onCorrectItem = { text = i18n._"Gym.BoysLockers.RobotPlaced", event = "jason_locker_robot_placed", handler = function()
			scene:createRobot(true)
			game.events.trigger("boys_locker_room.shade_baited")
			scene:createBaitedTouchRegion()
			
			--game.hud.hide()
			--scene:hideHUD()
			
			scene:newTimer(1000, function()
				scene:startRobot()	
				scene:newTimer(1800, function()
					scene:playSound("shriek")
					--game.hud.show()
					--scene:showHUD()
				end)
			end)
		end},
		onNoItem = i18n._"Gym.BoysLockers.LockerHole",
	}))
	
	scene:createBaitedTouchRegion()
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/bg_lockers.jpg"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(97), device.y(59), 68, 257, onLouLockerTouch))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(182), device.y(59), 68, 257, onWillLockerTouch))
		
	self:addToScene(game.ui.newTouchRegionTap(device.x(260), device.y(59), 68, 257, onDexterLockerTouch))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(344), device.y(59), 68, 257, onGatesLockerTouch))
	
	self.robot = nil
			
	if not game.events.isTriggered("jason_locker_pried") then
		self:addToScene(game.ui.newItemRegion(device.x(428), device.y(59), 68, 257, {
			itemName = "Crowbar",
			onCorrectItem = { text = i18n._"Gym.BoysLockers.CrowbarBroke", event = "jason_locker_pried", handler = function()
				scene:createCrowbarHole()
				scene:playSound("locker_crowbar")
				scene:newTimer(200, function()
					scene:playSound("crowbar")
				end)
			end},
			onNoItem = { text = i18n._"Gym.BoysLockers.LockerDent", captionType = "mine" },
		}))
	elseif not game.events.isTriggered("jason_locker_destroyed") then
		self:createCrowbarHole()	
		self:startRobot()	
	else
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/jason_locker_shadehole.png", device.x(425), device.y(55), 73, 262))
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/lockers_debris.jpg", device.x(228), device.y(287), 343, 74))
		self:addToScene(game.ui.newTouchRegionTap(device.x(428), device.y(59), 68, 257, onJasonLockerTouch))
	end
	
	if game.events.isTriggered("dexter_locker_unlocked") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/dexter_locker_opened.jpg", device.x(250), device.y(52), 83, 273))
	end
	
	if game.events.isTriggered("gates_locker_unlocked") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/gates_locker_opened.jpg", device.x(336), device.y(30), 93, 317))
	end
	
	self:addToScene(game.ui.newTouchInfo(device.x(143), device.y(30), 28, 23, i18n._"Lockers.Skull"))
	self:addToScene(game.ui.newTouchInfo(device.x(237), device.y(20), 48, 33, i18n._"Lockers.Shoes"))
	self:addToScene(game.ui.newTouchInfo(device.x(378), device.y(15), 37, 38, i18n._"Lockers.Ball"))
	self:addToScene(game.ui.newTouchMyCaption(device.x(434), device.y(15), 55, 35, i18n._"Lockers.Statue"))
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_locker_room"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene:loadSound("locker_open", "assets/sounds/game/gym/locker_open.mp3")
		scene:loadSound("robot_on", "assets/sounds/game/gym/robot_turn_on.mp3")
		scene:loadSound("robot_noise", "assets/sounds/game/gym/robot_noise.mp3")
		scene:loadSound("locker_crowbar", "assets/sounds/game/gym/locker_crowbar.mp3")
		scene:loadSound("crowbar", "assets/sounds/game/gym/crowbar.mp3")
		scene:loadSound("shriek", "assets/sounds/game/gym/shade_shriek2.mp3")
	elseif event.phase == "did" then
		game.hud.show()
		
		values = {}
		
		if game.events.isTriggered("boys_locker_room.scare1_will_left") and game.events.isTriggered("boys_locker_room.scare1_shade_left")
			and not game.events.isTriggered("boys_locker_room.will_is_out") and not game.events.isTriggered("boys_lockers.will_asks_for_help") then
			game.hud.showCaptionAndTrigger("boys_lockers.will_asks_for_help", {who = "will", text = i18n._"Will.PleaseHelp1", filterTouch = true})
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
	elseif event.phase == "did" then		
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene