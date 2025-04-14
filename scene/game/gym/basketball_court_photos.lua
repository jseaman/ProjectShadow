-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onNewspaperTouch()
	scene.newspaper = game.ui.removeSelf(scene.newspaper)
	game.journal.addNextCutout()
	game.events.trigger("basketball_court.newspaper")
	return true
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/basketball_court/pinboard.jpg"))
	
	if not game.events.isTriggered("basketball_court.newspaper") then
		self.newspaper = self:addToScene(game.ui.newSceneObjectAndDo("assets/images/game/gym/basketball_court/missing_children_pinboard_zoom.png", 
			device.x(383), device.y(48), 123, 265, onNewspaperTouch))
	end
	
	self:addToScene(game.ui.newTouchInfo(device.x(66), device.y(38), 172, 124, i18n._"Gym.Pinboard.Photos"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(271), device.y(34), 97, 146, i18n._"Gym.Pinboard.Signatures"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(115), device.y(175), 170, 170, function()
		game.journal.recordEntry("Gym.Bricks")
	end))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/basketball_court/mirandas_photo.png", 
		device.x(111), device.y(168), 174, 180, "VandalizedPhoto", function()
			game.hud.showInfoCaption(i18n._"Gym.Pinboard.VandalizedPhoto")
		end))
	
	self:addToHUD(game.ui.newBackButton("game.gym.basketball_court"))
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