-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onGrafittiClueTouch()
	game.journal.recordEntry("Gym.DexterLock")
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_bathroom/toilets/bg_middle_toilet.jpg"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(106), device.y(163), 49, 74, i18n._"Gym.Toilet.ToiletPaper"))
	self:addToScene(game.ui.newTouchInfo(device.x(380), device.y(57), 60, 94, i18n._"Gym.Toilet.LeftGraffiti"))
	
	self:addToScene(game.ui.newTouchAndGo(device.x(205), device.y(19), 170, 172, "game.gym.boys_toilet_middle_tank"))
	
	self:addToScene(game.ui.newTouchInfo(device.x(205), device.y(209), 170, 119, i18n._"Gym.Toilet.Bowl"))
	
	self:addToScene(game.ui.newTouchRegionTap(device.x(372), device.y(203), 66, 118, onGrafittiClueTouch))
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_toilets"))
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