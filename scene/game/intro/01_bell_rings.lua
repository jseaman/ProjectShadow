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
    self:loadSound("sigh", "assets/sounds/game/intro/sigh.mp3")
	elseif event.phase == "did" then
		self:newTimer(400, function()
        self:playSound("bell")
        self:newTimer(3400, function()
            self:playSound("sigh")
						self.continueText:show()
            game.hud.showMyCaption(i18n._"Intro.Sigh", function()
              game.scenes.gotoGameScene("game.intro.02_classroom")
            end)
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