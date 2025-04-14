-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local CaseMovedX = -260
local DoorOpenY = -280

-----------------------------------------------------------------------------------------

local function onSecretDoorTouch()
	game.scenes.gotoGameScene("game.gym.principal_den")
end

-----------------------------------------------------------------------------------------

function scene:revealDoor()
	self:hideHUD()
	game.hud.hideHomeAndInventory()
	self.shakeEffect = game.effects.newShakeEffect({
		group = self.sceneLayer,
		amount = 50,
		intensity = 5
	})
	self.shakeEffect:start()
	self:playSound("rumble")
	system.vibrate()
	scene:newTransition(self.trophyCaseGroup, { x = device.x(CaseMovedX), time = 1800, onComplete = function()
		scene:newTimer(500, function()
			self:playSound("door")
			scene:newTransition(self.secretDoor, { y = device.y(DoorOpenY), time = 1400, onComplete = function()
				self:showHUD()
				game.hud.show()
				game.achievements.unlock("place_trophy")
			end})
		end)
	end})
end

function scene:createTrophy()
	game.ui.insertChild(self.trophyCaseGroup, game.ui.newSceneObjectInfo("assets/images/game/gym/basketball_court/big_trophy.png", 
		device.x(296), device.y(134), 66, 96, i18n._"Gym.TrophyCase.BigTrophy"))
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/basketball_court/secret_door_interior.jpg", 
		device.x(184), device.y(23), 193, 338, onSecretDoorTouch))
		
	self.secretDoor = self:addToScene(game.ui.newHardImage("assets/images/game/gym/basketball_court/secret_door.png", 
		device.x(190), device.y(36), 184, 349))
	
	self:addToScene(game.ui.newBackground("assets/images/game/gym/basketball_court/trophy_shelf_zoom.png"))
	
	self.trophyCaseGroup = self:addToScene(game.ui.newGroup())
	
	game.ui.insertChild(self.trophyCaseGroup, game.ui.newHardImage("assets/images/game/gym/basketball_court/shelf.png", 
		device.x(70), device.y(18), 359, 343))
	
	game.ui.insertChild(self.trophyCaseGroup, game.ui.newTouchInfo(device.x(184), device.y(65), 89, 51, i18n._"Gym.TrophyCase.GenericTrophy"))
	
	game.ui.insertChild(self.trophyCaseGroup, game.ui.newTouchInfo(device.x(184), device.y(124), 89, 51, i18n._"Gym.TrophyCase.GenericMedal"))
	
	game.ui.insertChild(self.trophyCaseGroup, game.ui.newTouchInfo(device.x(184), device.y(184), 89, 51, i18n._"Gym.TrophyCase.GenericTrophy"))
	
	game.ui.insertChild(self.trophyCaseGroup, game.ui.newTouchInfo(device.x(184), device.y(244), 89, 51, i18n._"Gym.TrophyCase.GenericTrophy"))
	
	game.ui.insertChild(self.trophyCaseGroup, game.ui.newTouchInfo(device.x(184), device.y(303), 89, 51, i18n._"Gym.TrophyCase.GenericTrophy"))
	
	game.ui.insertChild(self.trophyCaseGroup, game.ui.newTouchInfo(device.x(294), device.y(303), 89, 51, i18n._"Gym.TrophyCase.GenericTrophy"))
	
	if not game.puzzles.hasFinished("trophy_lock") then
		game.ui.insertChild(self.trophyCaseGroup, game.ui.newTouchInfo(device.x(294), device.y(184), 89, 51, i18n._"Gym.TrophyCase.MissingTrophy"))
			
		game.ui.insertChild(self.trophyCaseGroup, game.ui.newSceneObjectInfo("assets/images/game/gym/basketball_court/shelf_toilet_handle.png", 
			device.x(306), device.y(282), 33, 16, i18n._"Gym.TrophyCase.ToiletHandleLocked"))
		
		game.ui.insertChild(self.trophyCaseGroup, game.ui.newImage("assets/images/game/gym/basketball_court/shelf_closed.png", 
			device.x(156), device.y(34), 255, 327))
			
		game.ui.insertChild(self.trophyCaseGroup, game.ui.newSceneObjectAndGo("assets/images/game/gym/basketball_court/shelf_lock.png", 
			device.x(266), device.y(240), 36, 40, "game.gym.basketball_court_trophies_lock"))
	else
		game.ui.insertChild(self.trophyCaseGroup, game.ui.newSceneItem("assets/images/game/gym/basketball_court/shelf_toilet_handle.png", 
			device.x(306), device.y(282), 33, 16, "ToiletHandle"))
		
		if not game.events.isTriggered("trophy_placed") then
			self:addToScene(game.ui.newItemRegion(device.x(294), device.y(184), 89, 51, {
				itemName = "Trophy",
				onCorrectItem = { text = i18n._"Gym.TrophyCase.TrophyPlaced", event = "trophy_placed", handler = function()
					scene:createTrophy()
					self:playSound("trophy")
					scene:newTimer(400, function() 
						scene:revealDoor() 
					end)
				end},
				onNoItem = i18n._"Gym.TrophyCase.MissingTrophy",
			}))
		else
			scene:createTrophy()
			self.secretDoor.y = device.y(DoorOpenY)
			self.trophyCaseGroup.x = device.x(CaseMovedX)
		end
		
		game.ui.insertChild(self.trophyCaseGroup, game.ui.newImage("assets/images/game/gym/basketball_court/left_door.png", 
			device.x(124), device.y(46), 51, 315))
		
		game.ui.insertChild(self.trophyCaseGroup, game.ui.newImage("assets/images/game/gym/basketball_court/right_door.png", 
			device.x(394), device.y(46), 51, 315))
	end
	
	self:addToHUD(game.ui.newBackButton("game.gym.basketball_court"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("rumble", "assets/sounds/game/gym/earth_rumble.mp3")
		self:loadSound("door", "assets/sounds/game/gym/trophy_door_open.mp3")
		self:loadSound("trophy", "assets/sounds/game/gym/trophy_placed.mp3")
	elseif event.phase == "did" then
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		if self.shakeEffect then
			self.shakeEffect = self.shakeEffect:dispose()
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene