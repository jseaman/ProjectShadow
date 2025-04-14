-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local BackgroundScale = 1.5

-----------------------------------------------------------------------------------------

function scene:startPanning()
  scene:newTransition(scene.sceneLayer, { y = device.y((360*BackgroundScale - 360)/2), time = 4000, onComplete=function()
		scene.continueText:show()
    game.hud.showMyCaption(i18n._"Intro.Questions!", function()
      game.scenes.gotoGameScene("game.intro.03_classroom_board", "fade", 2000)
    end)
  end})
end

-----------------------------------------------------------------------------------------

function scene:getFadeIn()
  return 2000
end

-----------------------------------------------------------------------------------------

function scene:animateCameraDot()
	scene:newTimer(800, function()
		scene.cameraDot.isVisible = not scene.cameraDot.isVisible
	end, 0)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
  self.background = self:addToScene(game.ui.newBackground("assets/images/game/intro/classroom.jpg"))
  self.background.x = -device.x((570*BackgroundScale - 570)/2)
  self.background.y = -device.y((360*BackgroundScale - 360)/2)
  self.background.xScale = BackgroundScale
  self.background.yScale = BackgroundScale
  
  self:addToScene(game.ui.newTextBox({
    text = i18n._"Intro.Questions", set_name = "Chalk", size = 12, align = "left", color = {1,1,1},
    x = device.x(100), y = device.y(40 * BackgroundScale) - device.y((360*BackgroundScale - 360)/2), width = 190, height = 300}))
	
	self.continueText = self:addToHUD(game.ui.newTapToContinueText(true))
	
	self:addToHUD(game.ui.newImage("assets/images/game/intro/rec.png", 0, device.y(19), 85, 26))
	self:addToHUD(game.ui.newImage("assets/images/game/intro/camera_3.png", display.contentWidth - 89, device.y(312), 89, 26))
	self:addToHUD(game.ui.newImage("assets/images/game/intro/hour_11am.png", display.contentWidth - 85, device.y(19), 85, 26))
	self.cameraDot = self:addToHUD(game.ui.newImage("assets/images/game/intro/red_dot.png", 34, device.y(31), 9, 9))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		scene:animateCameraDot()
    self:newTimer(800, function()
      scene:startPanning()
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