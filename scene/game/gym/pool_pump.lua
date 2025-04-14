-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onCrankHandleTouch()
	if not game.events.isTriggered("gym.pool_pump_pipe") then
		scene:playSound("thud")
		game.hud.showInfoCaption(i18n._"Gym.PoolControlRoom.WontBudge")
	elseif not game.events.isTriggered("gym.pool_pump_activated") and not scene.crankHandleMoving then
		scene:hideHUD()
		scene.crankHandleMoving = true
		scene:playSound("crank")
		scene:newTransition(scene.crankHole, { rotation = -180, time = 2200 })
		scene:newTransition(scene.crankHandle, { rotation = -180, time = 2200, onComplete = function()
			scene.crankHandleMoving = false
			game.events.trigger("gym.pool_pump_activated")
			scene:newTimer(1000, function()
				game.scenes.gotoGameScene("game.gym.pool_empty")
			end)
		end})
	else
		scene:playSound("thud")
		game.hud.showInfoCaption(i18n._"Gym.PoolControlRoom.WontBudge")
	end
end

-----------------------------------------------------------------------------------------

function scene:createCrankHandle()
	self.crankHandle = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/pool_control_room/water_pump/crank_handle.png", 
		device.x(286), device.y(178), 29, 107, onCrankHandleTouch))
	self.crankHandle.anchorX, self.crankHandle.anchorY = 0.5, 0.885
	if game.events.isTriggered("gym.pool_pump_activated") then
		self.crankHandle.rotation = -180
		self.crankHole.rotation = -180
	end
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/pool_control_room/water_pump/bg_water_tank.jpg"))
	
	self.crankHole = self:addToScene(game.ui.newImage("assets/images/game/gym/pool_control_room/water_pump/inner_ring.png", device.x(286), device.y(180), 57, 57))
	self.crankHole.anchorX, self.crankHole.anchorY = 0.5, 0.5
	
	if not game.events.isTriggered("gym.pool_crank_placed") then
		self:addToScene(game.ui.newItemRegion(device.x(257), device.y(151), 57, 57, {
			itemName = "CrankHandle",
			onCorrectItem = { text = i18n._"Gym.PoolControlRoom.CrankHandlePlaced", event = "gym.pool_crank_placed", handler = function()
				scene:playSound("metal")
				scene:createCrankHandle()
			end},
			onNoItem = i18n._"Gym.PoolControlRoom.CrankHandleMissing",
		}))
	else
		self:createCrankHandle()
	end
	
	self:addToHUD(game.ui.newBackButton("game.gym.pool_control_room"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene.crankHandleMoving = false
		self:loadSound("thud", "assets/sounds/game/gym/thud.mp3")
		self:loadSound("metal", "assets/sounds/game/gym/metal3.mp3")
		self:loadSound("crank", "assets/sounds/game/gym/crank.mp3")
	elseif event.phase == "did" then
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then		
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene