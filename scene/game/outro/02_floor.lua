-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:getFadeIn()
	return 2000
end

-----------------------------------------------------------------------------------------

function scene:onBeforeFadeIn()
	--TODO: play breaking sound
end

function scene:onCreate(event)
  self:addToScene(game.ui.newBackground("assets/images/game/outro/outro_2.jpg"))
	
	local textBox = self:addToHUD(game.ui.newTextBox({
		set_name="Standard", text=i18n._"Outro.ICanHelpYou", color={0,0,0}, 
		x = device.x(100), y = device.y(270), size = 30, width = display.contentWidth, height = 200, align = "center"
	}))
	textBox.rotation = -10
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene:loadSound("glass", "assets/sounds/game/general/glass.mp3")
		scene:playSound("glass")
	elseif event.phase == "did" then
		game.hud.hide()
		
		game.achievements.unlock("ink_bottle")
		
		scene:newTimer(7000, function()
			game.scenes.gotoGameScene("game.outro.03_to_be_continued", "fade", 3000)
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