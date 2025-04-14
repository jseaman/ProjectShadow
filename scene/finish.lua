-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self:addToHUD(game.ui.newTextBox({
		set_name="Standard", text=i18n._"ThanksForPlaying", color={1,1,1}, 
		x = 0, y = display.contentHeight - 190, size = 30, width = display.contentWidth, height = 200, align = "center"
	}))
	
	self.comingSoon = self:addToHUD(game.ui.newTextBox({
		set_name="Standard", text=i18n._"ComingSoon", color={0.93,0.56,0}, 
		x = 0, y = display.contentHeight - 90, size = 24, 
		width = display.contentWidth, height = 200, align = "center"
	}))
	if not game.events.isTriggered("coming_soon") then
		self.comingSoon.alpha = 0
	end
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
	elseif event.phase == "did" then
		game.hud.hide()
		
		game.achievements.unlock("credits")
		
		if not game.events.isTriggered("coming_soon") then
			scene:newTransition(self.comingSoon, { alpha = 1, delay = 4000, time = 800, onComplete = function()
				game.events.trigger("coming_soon")
				scene:newTimer(5000, function()					
					game.scenes.gotoMainMenu()
				end)
			end})
		else
			scene:newTimer(5000, function()					
				game.scenes.gotoMainMenu()
			end)
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