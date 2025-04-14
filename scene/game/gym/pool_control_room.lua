-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onHeaterValveTouch()
	if game.events.isTriggered("gym.hot_water_enabled") then
		game.hud.showInfoCaption(i18n._"Gym.PoolControlRoom.ValveJammed")
	else
		scene:playSound("valve_open")
		scene:newTransition(scene.heaterValve, {rotation = (scene.heaterValve.rotation + 90)%360, time = 300})
		if game.puzzles.hasFinished("water_heater") then
			game.events.trigger("gym.hot_water_enabled")
			scene:newTimer(300, function()
				scene:playSound("water_hot")
				game.hud.showInfoCaption(i18n._"Gym.PoolControlRoom.ValveEnabledHotWater")
			end)
		else
			game.hud.showInfoCaption(i18n._"Gym.PoolControlRoom.ValveDoesNothing")
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:startWaterDrop()
	if game.events.isTriggered("gym.pool_pump_pipe") then
		return
	end
	scene:newTimer(math.random(2, 9) * 1000, function()
		if game.events.isTriggered("gym.pool_pump_pipe") then
			return
		end
		self.waterLeak.isVisible = true
		scene:newTimer(800, function()
			self.waterLeak.isVisible = false
			if game.events.isTriggered("gym.pool_pump_pipe") then
				return
			end
			self.waterDrop.x, self.waterDrop.y = device.x(104), device.y(97)
			self.waterDrop.isVisible = true
			scene:newTimer(400, function()
				self:playSound("drop")
			end)
			scene:newTransition(self.waterDrop, { time = 500, y = device.y(251), onComplete = function()				
				self.waterDrop.isVisible = false
				scene:startWaterDrop()
			end})
		end)
	end)
end

-----------------------------------------------------------------------------------------

function scene:showSmoke()
	scene:addToScene(game.particles.createStartedParticle("hints_smoke", "smoke", display.contentWidth/2, display.contentHeight/2))
	game.particles.start()
end

-----------------------------------------------------------------------------------------

function scene:createPumpPipe()
	self:addToScene(game.ui.newImage("assets/images/game/gym/pool_control_room/missing_pipe.png", device.x(95), device.y(95), 29, 11))
end

function scene:createHeaterValve()
	self.heaterValve = self:addToScene(game.ui.newSceneObject("assets/images/game/gym/pool_control_room/valve.png", 
		device.x(314) + 13/2, device.y(127) + 13/2, 13, 13))
	self.heaterValve.anchorX, self.heaterValve.anchorY = 0.5,0.5
	
	self:addToScene(game.ui.newTouchRegionTap(
		device.x(310), device.y(123), 21, 21, onHeaterValveTouch))
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/pool_control_room/bg_maintenance_room.jpg"))
	
	if not game.puzzles.hasFinished("water_heater") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/pool_control_room/pipes_puzzle_unsolved.jpg", device.x(387), device.y(78), 58, 56))
		self:addToScene(game.ui.newTouchAndGo(device.x(385), device.y(76), 97, 58, "game.puzzles.gym.water_heater"))
	end	
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(421), device.y(145), 70, 67, function()
		self:playSound("drawer")
		game.scenes.gotoGameScene("game.gym.pool_toolbox")
	end))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(98), device.y(43), 90, 72, function()
		if not game.events.isTriggered("gym.pool_pump_pipe") then
			game.hud.showInfoCaption(i18n._"Gym.PoolControlRoom.MissingPipe")
		else
			game.hud.showInfoCaption(i18n._"Gym.PoolControlRoom.Pump")
		end
	end))	
	
	if game.events.isTriggered("gym.pool_pump_activated") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/pool_control_room/crank_handle_down.png", device.x(211), device.y(159), 20, 19))
	else
		if game.events.isTriggered("gym.pool_crank_placed") then
			self:addToScene(game.ui.newImage("assets/images/game/gym/pool_control_room/crank_handle_up.png", device.x(211), device.y(141), 20, 19))
		end
		self:addToScene(game.ui.newTouchAndGo(device.x(179), device.y(126), 52, 78, "game.gym.pool_pump"))		
	end
	
	if not game.events.isTriggered("gym.pool_pump_pipe") then
		self:addToScene(game.ui.newItemRegion(device.x(83), device.y(46), 101, 73, {
			itemName = "PoolPumpPipe",
			onCorrectItem = { text = i18n._"Gym.PoolControlRoom.MissingPipePlaced", event = "gym.pool_pump_pipe", handler = function()
				scene:playSound("pipe")
				scene:createPumpPipe()
			end},
			onNoItem = i18n._"Gym.PoolControlRoom.MissingPipe",
		}))
		
		self.waterDrop = self:addToScene(game.ui.newImage("assets/images/game/gym/pool_control_room/water_drop.png", device.x(104), device.y(97), 11, 11))
		self.waterDrop.isVisible = false
		self.waterLeak = self:addToScene(game.ui.newImage("assets/images/game/gym/pool_control_room/water_leak.png", device.x(109), device.y(98), 2, 4))
		self.waterLeak.isVisible = false
	else
		self:createPumpPipe()
	end
	
	self:addToScene(game.ui.newTouchInfo(device.x(285), device.y(83), 66, 118, i18n._"PoolControlRoom.Floor"))
	self:addToScene(game.ui.newTouchInfo(device.x(79), device.y(245), 47, 31, i18n._"PoolControlRoom.Leak"))
		
	self:addToScene(game.ui.newTouchRegionTap(device.x(285), device.y(83), 66, 118, function()
		if game.events.isTriggered("gym.hot_water_enabled") then
			game.hud.showInfoCaption(i18n._"PoolControlRoom.HeaterWorking")
		else
			game.hud.showInfoCaption(i18n._"PoolControlRoom.Heater")
		end
	end))
	
	if not game.events.isTriggered("gym.heater_valve") then
		self:addToScene(game.ui.newItemRegion(device.x(295), device.y(110), 40, 70, {
			itemName = "WaterHeaterHandle",
			onCorrectItem = { text = i18n._"Gym.PoolControlRoom.MissingHeaterValvePlaced", event = "gym.heater_valve", handler = function()
				scene:playSound("valve")
				scene:createHeaterValve()
			end},
			onNoItem = i18n._"Gym.PoolControlRoom.MissingValve",
		}))
	else
		self:createHeaterValve()
	end	
	
	self:addToScene(game.ui.newBackButton(function()
		game.scenes.gotoGameSceneDoor("game.gym.pool", "control")
	end))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("valve_open", "assets/sounds/game/gym/squeaky_valve.mp3")
		self:loadSound("drop", "assets/sounds/game/gym/droplet.mp3")
		self:loadSound("drawer", "assets/sounds/game/gym/drawer_open.mp3")
		self:loadSound("pipe", "assets/sounds/game/gym/metal1.mp3")
		self:loadSound("water_hot", "assets/sounds/game/gym/water_hot.mp3")
		self:loadSound("valve", "assets/sounds/game/gym/metal2.mp3")
		
		if game.puzzles.hasFinished("water_heater") then
			scene:showSmoke()
		end
	elseif event.phase == "did" then
		game.hud.show()
		self:startWaterDrop()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		game.particles.cleanUp()
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene