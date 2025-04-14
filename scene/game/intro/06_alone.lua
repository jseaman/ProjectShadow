-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self.continueText = self:addToHUD(game.ui.newTapToContinueText(true))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("bell", "assets/sounds/game/intro/school_bell.mp3")
	elseif event.phase == "did" then
		self:newTimer(400, function()
			scene.continueText:show()
      game.hud.showMyCaption(i18n._"Intro.Alone", function()
        system.vibrate()
        --TODO: play sound
        game.scenes.gotoGameScene("game.intro.07_locker_dark", "fade", 1000)
      end)
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