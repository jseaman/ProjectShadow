-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/template/background.jpg"))
	
	self:addToScene(game.ui.newTouchAndGo(
		device.x(160), device.y(170), 400, 250, "game.rivals.office_closer"
	))
	
	self:addToHUD(game.ui.newBackButton("game.rivals.door"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		game.hud.show()
	
		if not game.events.isTriggered("rivals.arthur_greet") then
			game.events.trigger("rivals.arthur_greet")
			game.hud.showCaption({
				text = i18n._"TemplateCaption", filterTouch = true
			})
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