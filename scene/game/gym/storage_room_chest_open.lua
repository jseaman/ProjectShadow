-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onNewspaperTouch()
	scene.newspaper = game.ui.removeSelf(scene.newspaper)
	game.journal.addNextCutout()
	game.events.trigger("gym.storage_room.newspaper")
	return true
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/storage_room/chest/chest_open_zoom.jpg"))
	
	if not game.events.isTriggered("gym.storage_room.newspaper") then
		self.newspaper = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/storage_room/chest/newspaper_piece_chest.png", device.x(275), device.y(169), 129, 47, onNewspaperTouch))
	end
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/storage_room/chest/silver_key.png", 
		device.x(163), device.y(166), 49, 41, "ChestKey"))
	
	self:addToScene(game.ui.newBackButton("game.gym.storage_room"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
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