-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self:addToHUD(game.ui.newTextBox({
		set_name="Standard", text=i18n._"Outro.ToBeContinued", color={1,1,1}, 
		x = 0, y = display.contentHeight - 210, size = 30, width = display.contentWidth, height = 200, align = "center"
	}))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
	elseif event.phase == "did" then
		game.hud.hide()
		
		scene:newTimer(5000, function()
			game.scenes.gotoGameScene("credits", "fade", 3000)
		end)
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