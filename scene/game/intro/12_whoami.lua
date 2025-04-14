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
    self:loadSound("heartbeat_slow", "assets/sounds/game/gym/heartbeat_slow.mp3")
	elseif event.phase == "did" then
    self:newTimer(200, function()
      self:playSound("heartbeat_slow")
    end)
		self:newTimer(3500, function()
			scene.continueText:show()
      game.hud.showMyCaption(i18n._"Intro.WhoAmI", function()
        system.vibrate()
        --TODO: play sound
        game.scenes.gotoGameScene("game.gym.locker_lou", "fade", 2000)
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