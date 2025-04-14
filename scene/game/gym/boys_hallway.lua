-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local doors =
{
	["left"] = {
		filename = "hallway_left.png", x = 86, y = 135, w = 27, h = 160
	},
	["court"] = {
		filename = "hallway_right.png", x = 457, y = 135, w = 27, h = 160
	},
	["bath"] = {
		filename = "hallway_front.jpg", x = 204, y = 130, w = 42, h = 113
	},
	["showers"] = {
		filename = "hallway_front.jpg", x = 330, y = 130, w = 42, h = 113
	},
}

-----------------------------------------------------------------------------------------

local function onNewspaperTouch()
	if scene.newspaper then
		scene.newspaper = game.ui.removeSelf(scene.newspaper)
		game.journal.addNextCutout()
		game.events.trigger("boys_hallway.newspaper")
	end
	return true
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_hallway/boys_hallway.jpg"))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(82), device.y(129), 34, 168, "game.gym.boys_locker_room", "right"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(197), device.y(125), 57, 119, "game.gym.boys_bathroom"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(324), device.y(125), 57, 119, "game.gym.boys_showers"))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(453), device.y(128), 34, 169, "game.gym.basketball_court", "boys"))
	
	if not game.events.isTriggered("boys_hallway.newspaper") then
		self.newspaper = self:addToScene(game.ui.newImage("assets/images/game/gym/boys_hallway/newspaper_cutting1.png", device.x(283), device.y(199), 19, 14))
		self:addToScene(game.ui.newTouchRegionTap(device.x(271), device.y(186), 36, 60, onNewspaperTouch))
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