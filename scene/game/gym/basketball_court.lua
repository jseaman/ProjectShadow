-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local doors =
{
	["boys"] = {
		filename = "blackdoor_boys.png", x = 74, y = 177, w = 12, h = 95
	},
	["utility"] = {
		filename = "blackdoor_utility.png", x = 146, y = 180, w = 20, h = 89
	},
	["pool"] = {
		filename = "blackdoor_pool.jpg", x = 393, y = 180, w = 42, h = 48
	},
	["girls"] = {
		filename = "blackdoor_girls.png", x = 502, y = 178, w = 12, h = 83
	},
}

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/basketball_court/bg_basketball_court.jpg"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(0), device.y(45), 87, 81, i18n._"Basketball.Windows"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(0), device.y(257), 573, 103, i18n._"Basketball.Floor"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(103), device.y(88), 386, 25, i18n._"Basketball.Pipes"))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(493), device.y(172), 32, 59, "game.gym.girls_hallway", "court"))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(392), device.y(176), 45, 55, "game.gym.pool", "court"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(125), device.y(165), 45, 65, function()
		if not game.events.isTriggered("basketball_court.storage_door_unlocked") then
			game.scenes.gotoGameScene("game.gym.storage_room_door")
		else
			game.scenes.gotoGameScene("game.gym.storage_room")
		end
	end))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(64), device.y(172), 32, 59, "game.gym.boys_hallway", "court"))
	
	if game.events.isTriggered("trophy_placed") then
		self:addToScene(game.ui.newSceneObjectAndGo("assets/images/game/gym/basketball_court/basketball_court_secretdoor.jpg", 
			device.x(319), device.y(176), 69, 57, "game.gym.basketball_court_trophies"))
	else
		if game.puzzles.hasFinished("trophy_lock") then
			self:addToScene(game.ui.newImage("assets/images/game/gym/basketball_court/shelf_open.jpg", 
				device.x(346), device.y(175), 41, 58, "game.gym.basketball_court_trophies"))
		end
		self:addToScene(game.ui.newTouchAndGo(device.x(349), device.y(176), 35, 55, "game.gym.basketball_court_trophies"))
	end
	
	if not game.events.isTriggered("basketball_court.newspaper") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/basketball_court/missing_children_pinboard.png", device.x(201), device.y(182), 9, 18))
	end
	
	if not game.inventory.hasPickedUpItem("VandalizedPhoto") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/basketball_court/mirandas_photo_pinboard.png", device.x(185), device.y(192), 10, 11))
	end
	
	self:addToScene(game.ui.newTouchAndGo(device.x(175), device.y(176), 60, 50, "game.gym.basketball_court_photos"))
	
	if game.events.isTriggered("basketball_court.ladder_placed") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/basketball_court/ladder.png", device.x(242), device.y(172), 91, 70))
	end
	
	self:addToScene(game.ui.newTouchAndGo(device.x(260), device.y(119), 61, 110, "game.gym.basketball_court_hoop"))	
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene.doorEffect = game.effects.newDoorClosesEffect(scene, doors, "basketball_court")
	elseif event.phase == "did" then
		game.hud.show()
		if scene.doorEffect then
			scene.doorEffect:start()
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