-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onInkBottleTap()
	game.scenes.gotoGameScene("game.outro.02_floor")
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self:addToScene(game.ui.newBackground("assets/images/game/outro/outro_1.jpg"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(20), device.y(154), 276, 227, i18n._"Outro.George"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(246), device.y(259), 91, 74, i18n._"Outro.Journal"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(364), device.y(224), 75, 73, onInkBottleTap))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
	elseif event.phase == "did" then
		game.hud.hide()
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