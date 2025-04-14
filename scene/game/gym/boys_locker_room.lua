-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local doors =
{
	["pool"] = {
		filename = "lockers_room_front.jpg", x = 264, y = 131, w = 40, h = 112
	},
	["right"] = {
		filename = "lockers_room_right.png", x = 414, y = 136, w = 27, h = 157
	},
}

-----------------------------------------------------------------------------------------

local function onLockersTouch()
	if game.events.isTriggered("boys_locker_room.scare1_start") and not game.events.isTriggered("boys_locker_room.scare1_will_left") then
		return
	end
	
	game.scenes.gotoGameScene("game.gym.boys_lockers")
end

local function onWillTouch()
	if not game.events.isTriggered("boys_locker_room.will_greet") then
		game.hud.showCaptionAndTrigger("boys_locker_room.will_greet", {who = "will", text = i18n._"Will.Greet", filterTouch = true, callback = function()
			game.scenes.gotoGameScene("game.gym.locker_lou_journal")
		end})
	elseif not game.events.isTriggered("boys_locker_room.will_oracle") then
		game.hud.showCaptionAndTrigger("boys_locker_room.will_oracle", {who = "will", text = i18n._"Will.Oracle", filterTouch = true, callback = function()
			game.inventory.openAndPickUp("Oracle")
			scene:showInventoryTutorial()
		end})
	elseif game.events.isTriggered("boys_locker_room.will_is_out") and not game.events.isTriggered("boys_locker_room.will_gives_rose") then
		game.hud.showCaptionAndTrigger("boys_locker_room.will_gives_rose", {who = "will", text = i18n._"Will.ThanksRose", filterTouch = true, callback = function()
			game.inventory.openAndPickUp("Rose")
		end})
	else
		game.hud.showRandomCaption({who = "will", text = i18n._"Will.ChitChat"})
	end
end

local function onPoolDoorTouch()
	if scene:tryLeaveRoom("pool") then
		game.scenes.gotoGameSceneDoor("game.gym.pool", "boys")
	end
end

local function onHallwayTouch()
	if scene:tryLeaveRoom("hallway") then
		game.scenes.gotoGameSceneDoor("game.gym.boys_hallway", "left")
	end
end

local function onLetterTouch()
	if game.events.isTriggered("boys_locker_room.scare1_start") and not game.events.isTriggered("boys_locker_room.scare1_will_left") then
		return
	end
	
	if (game.events.isTriggered("boys_locker_room.scare1_start") and not game.events.isTriggered("boys_locker_room.scare1"))
			or (game.events.isTriggered("boys_locker_room.shade_baited") and not game.events.isTriggered("boys_locker_room.shade_baited_done")) then
		game.hud.showMyCaption(i18n._"Lou.Lockers.BetterHide")
		return
	end
	
	game.scenes.gotoGameScene("game.puzzles.gym.boys_locker_room_letter")
end

-----------------------------------------------------------------------------------------

function scene:showInventoryTutorial()
	scene.inventoryTutorial = scene:addToScene(game.ui.newGroup())
	scene.inventoryTutorial.alpha = 0
	
	game.ui.insertChild(scene.inventoryTutorial, game.ui.newImage("assets/images/game/gym/boys_locker_room/tutorial/arrow_3.png", 
		game.inventory.getFirstItemLeft() + game.inventory.getItemBoxWidth() + 5, game.inventory.getItemBarTop() - 187 + 5, 59, 187))
		
	game.ui.insertChild(scene.inventoryTutorial, game.ui.newTextBox({
		set_name="Standard", text=i18n._"Tutorial.OpenHints", color={0.54,0.79,0.62}, 
		x = game.inventory.getFirstItemLeft() + game.inventory.getItemBoxWidth() - 50, 
		y = game.inventory.getItemBarTop() - 187 - 70, size = 30, width = 220, height = 200, align = "center"
	}))
	
	scene:newTransition(scene.inventoryTutorial, { alpha = 1, delay = 200, time = 800 })
end

-----------------------------------------------------------------------------------------

function scene:hideInventoryTutorial()
	scene:newTransition(scene.inventoryTutorial, { alpha = 0, time = 500 })
end

-----------------------------------------------------------------------------------------

function scene:onInventoryClosing()
	scene:hideInventoryTutorial()
end

-----------------------------------------------------------------------------------------

function scene:tryLeaveRoom(doorName)
	if not game.events.isTriggered("boys_locker_room.scare1") then
		if not game.events.isTriggered("boys_locker_room.scare1_start") then
			game.state.set("boys_locker_room_door", doorName)
			self:triggerEvent("boys_locker_room.scare1_start")
		elseif game.events.isTriggered("boys_locker_room.scare1_will_left") then
			game.hud.showMyCaption(i18n._"Lou.BetterHide")
		end
		return false
	elseif game.events.isTriggered("boys_locker_room.shade_baited") and not game.events.isTriggered("boys_locker_room.shade_baited_done") then
		game.hud.showMyCaption(i18n._"Lou.BetterHide")
		return false
	end
	
	return true
end

-----------------------------------------------------------------------------------------

function scene:willLeaves(eventName)
	game.hud.hide()
	self.fadeScreen.alpha = 0
	self:newTransition(self.fadeScreen, { alpha = 1, time = 600, onComplete = function()
		self.characterWill.isVisible = false
		self:playSound("locker_close")
		self:newTimer(800, function()
			self:newTransition(self.fadeScreen, { alpha = 0, time = 400, onComplete = function()
				game.hud.show()
				self:triggerEvent(eventName)
			end})
		end)
	end})
end

-----------------------------------------------------------------------------------------

function scene:refreshCharacters()
	self.characterWill.isVisible = not game.events.isTriggered("boys_locker_room.scare1_will_left") or 
		(game.events.isTriggered("boys_locker_room.will_is_out") and not game.events.isTriggered("will.toilet"))
end

-----------------------------------------------------------------------------------------

function scene:refreshState()
	self:refreshCharacters()
	
	if not game.events.isTriggered("boys_locker_room.scare1") then
		if game.events.isTriggered("boys_locker_room.scare1_start") then
			if not game.events.isTriggered("boys_locker_room.scare1_shriek1") then
				game.scenes.gotoGameScene("game.gym.boys_locker_room_door")
			elseif not game.events.isTriggered("boys_locker_room.scare1_shriek2") then
				self:playSound("shriek2")
				self:newTimer(4000, function()
					self:showCaptionAndTrigger("boys_locker_room.scare1_shriek2", {who = "will", text = i18n._"Will.Hide!", filterTouch = true})
				end)
			elseif not game.events.isTriggered("boys_locker_room.scare1_will_left") then
				scene:willLeaves("boys_locker_room.scare1_will_left")
			end
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/bg_locker_room.jpg"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(-2), device.y(110), 115, 200, onLockersTouch))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(254), device.y(109), 57, 132, onPoolDoorTouch))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(407), device.y(125), 40, 170, onHallwayTouch))
	
	if game.puzzles.hasFinished("boys_locker_room_letter") then
		self:addToScene(game.ui.newSceneObject("assets/images/game/gym/boys_locker_room/note_solved.png", device.x(219), device.y(253), 19, 10))
	else
		self:addToScene(game.ui.newSceneObject("assets/images/game/gym/boys_locker_room/note_torn.png", device.x(220), device.y(254), 16, 8))
	end
		
	if game.events.isTriggered("jason_locker_pried") and not game.events.isTriggered("jason_locker_destroyed") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/lockeroom_bighole.jpg", device.x(102), device.y(167), 8, 42))
		if game.events.isTriggered("jason_locker_robot_placed") then
			self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/robot_lockers_room.jpg", device.x(101), device.y(167), 14, 38))
		end
	elseif game.events.isTriggered("jason_locker_destroyed") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/lockeroom_shadehole.jpg", device.x(91), device.y(124), 19, 127))
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/lockers_room_debris.jpg", device.x(26), device.y(125), 124, 187))
	end
	
	if game.events.isTriggered("gates_locker_unlocked") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/lockersroom_gates_locker.jpg", device.x(72), device.y(122), 39, 147))
	end
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(214), device.y(247), 29, 22, onLetterTouch))
	
	self.characterWill = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/boys_locker_room/will.png", device.x(65), device.y(136), 152, 224, onWillTouch))
	self.characterWill.alpha = 0.8
	
	self.fadeScreen = self:addToScene(game.ui.newRectFullScreen({0,0,0}))
	self.fadeScreen.alpha = 0
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		if not game.events.isTriggered("boys_locker_room.scare1") then
			self:loadSound("shriek2", "assets/sounds/game/gym/shade_shriek2.mp3")
			self:loadSound("locker_close", "assets/sounds/game/gym/locker_close.mp3")
		end
		self:loadSound("shriek1", "assets/sounds/game/gym/shade_shriek2.mp3")
		self:loadSound("robot_noise", "assets/sounds/game/gym/robot_noise.mp3")
		
		scene.doorEffect = game.effects.newDoorClosesEffect(scene, doors, "lockers_room")
	elseif event.phase == "did" then
		game.hud.show()
		
		if scene.doorEffect then
			scene.doorEffect:start()
		end
		
		if not game.events.isTriggered("boys_locker_room.will_greet") 
			or not game.events.isTriggered("boys_locker_room.will_oracle") 
			or (game.events.isTriggered("boys_locker_room.will_is_out") and not game.events.isTriggered("boys_locker_room.will_gives_rose")) then
			onWillTouch()
		end
		
		if game.events.isTriggered("boys_locker_room.shade_baited") and not game.events.isTriggered("boys_locker_room.shade_baited_done") then
			self:newTimer(800, function()
				self:playSound("robot_noise")
			end, 0)
			self:newTimer(6000, function()
				self:playSound("shriek1")
			end, 0)
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