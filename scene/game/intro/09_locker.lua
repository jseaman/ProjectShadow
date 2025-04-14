-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_inside_bg.jpg", device.x(131), device.y(0), 570, 360))
		
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_inside_left_wall.jpg", device.x(0), device.y(0), 128, 360))
	
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_inside_right_wall.jpg", device.x(441), device.y(0), 130, 360))
	
	self:addToScene(game.ui.newImage("assets/images/game/gym/boys_locker_room/inside/locker_closed_door.png", device.x(129), device.y(0), 313, 360))
	
	self.continueText = self:addToHUD(game.ui.newTapToContinueText(true))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
  elseif event.phase == "did" then
    scene:newTimer(700, function()
			scene.continueText:show()
      game.hud.showMyCaption(i18n._"Intro.HowDidIGetHere", function()
        game.scenes.gotoGameScene("game.intro.10_important", "fade", 2000)
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