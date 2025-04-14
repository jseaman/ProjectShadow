-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onPopenoeJournalTouch()
	game.scenes.gotoJournal("popenoe")
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/principal_den/desk_zoom.jpg"))
		
	self:addToScene(game.ui.newTouchRegionTap(device.x(342), device.y(197), 130, 125, onPopenoeJournalTouch))
	
	self:addToScene(game.ui.newTouchInfo(device.x(0), device.y(116), 231, 151, i18n._"PrincipalDen.Desk.Books"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(452), device.y(38), 60, 151, i18n._"PrincipalDen.Desk.Bottle"))
	
	self:addToScene(game.ui.newSceneItem("assets/images/game/gym/principal_den/coin.png", 
		device.x(277), device.y(260), 41, 35, "Coin"))
			
	self:addToScene(game.ui.newBackButton("game.gym.principal_den"))
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