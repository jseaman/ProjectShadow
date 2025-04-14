-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/principal_attic/papers_zoom.jpg"))
	
	self.text = self:addToScene(game.ui.newTextBox({
		text = i18n._"PrincipalAttic.Pages", 
		set_name = "Cursive", size = 14, align = "left", color = {0,0,0.43},
		x = device.x(185), y = device.y(60), width = 210, height = 360}))
	self.text.rotation = -4
	
	self:addToScene(game.ui.newBackButton("game.gym.principal_attic"))
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
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene