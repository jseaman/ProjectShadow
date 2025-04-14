-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onWillJournalTouch()
	if not game.events.isTriggered("basketball_court.ladder_placed") then
		game.hud.showInfoCaption(i18n._"Gym.BasketballCourt.TooHigh")
	else
		game.scenes.gotoGameScene("game.gym.basketball_court_book")
	end
end

-----------------------------------------------------------------------------------------

function scene:createLadder()
	self:addToScene(game.ui.newImage("assets/images/game/gym/basketball_court/ladder_zoom.png", device.x(168), device.y(184), 225, 177))
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/basketball_court/basket_zoom.jpg"))
	
	if not game.events.isTriggered("basketball_court.ladder_placed") then
		self:addToScene(game.ui.newItemRegion(device.x(150), device.y(150), 261, 211, {
			itemName = "Ladder",
			onCorrectItem = { text = i18n._"Gym.BasketballCourt.LadderPlaced", event = "basketball_court.ladder_placed", handler = function()
				scene:createLadder()
			end},
			onNoItem = i18n._"Gym.BasketballCourt.NoLadder",
		}))
	else
		self:createLadder()
	end
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(259), device.y(59), 48, 41, onWillJournalTouch))
	
	self:addToHUD(game.ui.newBackButton("game.gym.basketball_court"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		game.hud.show()
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