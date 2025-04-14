-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local doors =
{
	["right"] = {
		filename = "hallway_right.png", x = 457, y = 135, w = 27, h = 160
	},
	["court"] = {
		filename = "hallway_left.png", x = 86, y = 135, w = 27, h = 160
	},
	["bath"] = {
		filename = "hallway_front.jpg", x = 205, y = 131, w = 42, h = 113
	}
}

-----------------------------------------------------------------------------------------

local function onMirandaTouch()
	if not game.events.isTriggered("girls_hallway.miranda_greet") then
		game.hud.showCaptionAndTrigger("girls_hallway.miranda_greet", {who = "miranda", text = i18n._"Gym.GirlsHallway.MirandaGreet", filterTouch = true, callback = function()
			scene:refreshCharacters()
		end})
	elseif game.inventory.hasSelectedItem("Rose") then
		game.inventory.discard("Rose")
		game.inventory.close()
		game.hud.showCaptionAndTrigger("will.toilet", { who = "miranda", text = i18n._"Gym.GirlsHallway.Miranda.Rose", filterTouch = true, callback = function()
			game.inventory.openAndPickUp("Robot")
			game.achievements.unlock("rose")
		end})
	elseif game.inventory.hasSelection() then
		game.hud.showInfoCaption(i18n._"Gym.GirlsHallway.Miranda.WrongItem")
	else
		game.hud.showRandomCaption({who = "miranda", text = i18n._"Gym.GirlsHallway.MirandaChat"})
	end
end

-----------------------------------------------------------------------------------------

local function onLockerRoomTouch()
	if scene:isMirandaHere() then
		game.hud.showCaption({who = "miranda", text = i18n._"Gym.GirlsHallway.MirandaLockers", filterTouch = true})
	else
		game.scenes.gotoGameSceneDoor("game.gym.girls_locker_room", "left")
	end
end

-----------------------------------------------------------------------------------------

local function onBathroomTouch()
	if scene:isMirandaHere() then
		game.hud.showCaption({who = "miranda", text = i18n._"Gym.GirlsHallway.MirandaBathroom", filterTouch = true})
	else
		game.scenes.gotoGameScene("game.gym.girls_bathroom")
	end
end

-----------------------------------------------------------------------------------------

function scene:isMirandaHere()
	return (not game.events.isTriggered("girls_hallway.miranda_left1"))
		or (game.events.isTriggered("girls_hallway.miranda_returned") and (not game.events.isTriggered("girls_hallway.miranda_left2")))
end

-----------------------------------------------------------------------------------------

function scene:refreshCharacters()
	if scene:isMirandaHere() then
		self.mirandaSit.isVisible = not game.events.isTriggered("girls_hallway.miranda_greet")
		self.mirandaStand.isVisible = game.events.isTriggered("girls_hallway.miranda_greet")
	end
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/girls_hallway/girls_hallway.jpg"))
		
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(82), device.y(129), 34, 168, "game.gym.basketball_court", "girls"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(197), device.y(125), 57, 119, onBathroomTouch))
	
	self:addToScene(game.ui.newTouchInfo(device.x(324), device.y(125), 57, 119, i18n._"Gym.GirlsHallway.Showers"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(453), device.y(128), 34, 169, onLockerRoomTouch))
	
	if scene:isMirandaHere() then
		self.mirandaSit = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/girls_hallway/miranda_sit.png", device.x(241), device.y(233), 99, 90, onMirandaTouch))	
		self.mirandaSit.alpha = 0.8
		self.mirandaStand = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/girls_hallway/miranda_stand.png", device.x(241), device.y(154), 97, 162, onMirandaTouch))
		self.mirandaStand.alpha = 0.8
	end
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene.doorEffect = game.effects.newDoorClosesEffect(scene, doors, "hallway")
	elseif event.phase == "did" then
		game.hud.show()
		
		if scene.doorEffect then
			scene.doorEffect:start()
		end
		
		scene:refreshCharacters()
		
		if not game.events.isTriggered("girls_hallway.miranda_greet") then
			onMirandaTouch()
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