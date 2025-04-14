-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local doors =
{
	["pool"] = {
		filename = "lockers_room_front.jpg", x = 264, y = 132, w = 40, h = 112
	},
	["left"] = {
		filename = "lockers_room_left.png", x = 130, y = 134, w = 27, h = 161
	},
}

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/girls_locker_room/bg_girls_lockers_room.jpg"))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(124), device.y(138), 35, 140, "game.gym.girls_hallway", "right"))
	
	self:addToScene(game.ui.newTouchAndGoDoor(device.x(260), device.y(130), 52, 103, "game.gym.pool", "girls"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(228), device.y(247), 57, 43, i18n._"GirlsLockerRoom.Towels"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(351), device.y(246), 62, 27, "game.gym.girls_locker_room_table"))
	
	if not game.inventory.hasPickedUpItem("Mirror") then
		self:addToScene(game.ui.newImage("assets/images/game/gym/girls_locker_room/mirror_on_bench.jpg", device.x(382), device.y(251), 17, 20))
	end
	
	self:addToScene(game.ui.newTouchAndGo(device.x(459), device.y(119), 111, 202, "game.gym.girls_lockers"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene.doorEffect = game.effects.newDoorClosesEffect(scene, doors, "lockers_room")
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