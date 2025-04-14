-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self:addToScene(game.ui.newBackground("assets/images/game/intro/inside_locker_dark.jpg"))
	
	self.continueText = self:addToHUD(game.ui.newTapToContinueText(true))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
  elseif event.phase == "did" then
    scene:newTimer(700, function()
			scene.continueText:show()
      game.hud.showMyCaption(i18n._"Intro.TalkingToMyself", function()
        game.scenes.gotoGameScene("game.intro.08_hallway_dark", "fade", 500)
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