-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onNewspaperTouch()
	if not game.events.isTriggered("gym.locker_jason.newspaper") then
		scene.newspaper = game.ui.removeSelf(scene.newspaper)
		game.journal.addNextCutout()
		game.events.trigger("gym.locker_jason.newspaper")
	end
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_locker_room/jason/jason_locker_zoom.jpg"))
		
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/boys_locker_room/jason/robot_head.png", 
		device.x(242), device.y(144), 49, 44, "RobotHead", function()
			game.achievements.unlock("pick_robot_head")
		end))
		
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/boys_locker_room/jason/trophy.png", 
		device.x(305), device.y(259), 68, 101, "Trophy", function()
			game.hud.showMyCaption(i18n._"Lou.ItWasJason")
		end))
	
	if not game.events.isTriggered("gym.locker_jason.newspaper") then
		self.newspaper = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/boys_locker_room/jason/jason_newspaper_piece.png", device.x(337), device.y(84), 51, 33, onNewspaperTouch))
	end
	
	self:addToScene(game.ui.newBackButton("game.gym.boys_lockers"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
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