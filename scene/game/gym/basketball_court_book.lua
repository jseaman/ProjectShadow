-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onWillJournalTouch()
	game.scenes.gotoJournal("will")
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/basketball_court/basket_book_zoom.jpg"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(168), device.y(12), 271, 339, onWillJournalTouch))
	
	self:addToHUD(game.ui.newBackButton("game.gym.basketball_court_hoop"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
	elseif event.phase == "did" then
		game.hud.show()
		scene:newTimer(500, function()
			game.journal.recordEntry("Gym.WillLock")
			game.hud.showMyCaptionIfNotEvent("will_journal_seen", i18n._"WillJournal.FirstNotice")
			
			game.achievements.unlock("will_journal")
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