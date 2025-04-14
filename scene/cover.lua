-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

function scene:getHUDFadeIn()
	return 800
end

-----------------------------------------------------------------------------------------

function scene:animateThunder(overlay, index, maxFlickers)
	if index >= maxFlickers then
		return
	end
	
	local alpha = 1
	if overlay.alpha == 1 then
		alpha = 0
	end
	
	local time = math.random(50, 120)

	self:newTransition(overlay, { alpha = alpha, time = time, onComplete = function()
		scene:animateThunder(overlay, index + 1, maxFlickers)
	end})
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/menu/intro.jpg"))  
  
	self.thunderImage = self:addToScene(game.ui.newBackground("assets/images/menu/intro_thunder.jpg"))
  self.thunderImage.alpha = 0
  
  self.rainEffect = self:addToScene(game.effects.newRainEffect({
		rain1 = "assets/images/menu/rain.png",
		rain2 = "assets/images/menu/rain2.png",
	}))
  
	self:addToScene(game.ui.newTouchFullScreen(function(event)
		if event.phase == "ended" then
      if scene.isTransitioning then
        return
      end
      
      scene.isTransitioning = true
      scene:playSound("thunder")
      scene:animateThunder(scene.thunderImage, 1, 7)
      
      scene:newTimer(1000, function()
        scene:newTransition(scene.hudLayer, { alpha = 0, time = 300 })
        scene:newTimer(500, function()
          local options = {
						effect = "slideUp",
						time = 1000,
						params = {
							animate = true
						}
					}
          game.scenes.gotoScene("menu", options)	
        end)
      end)
		end
		return true
	end))
	
	self:addToScene(game.ui.newImage("assets/images/menu/title.png", device.x(112), device.y(81), 381, 175))
	
	--[[self:addToHUD(game.ui.newTextBox({
		set_name="Standard", text="The Mystery of Shadow Hill", color={1,1,1}, 
		x = 0, y = display.contentHeight - 210, size = 23, width = display.contentWidth, height = 200, align = "center"
	}))
	self:addToHUD(game.ui.newTextBox({
		set_name="Standard", text="Episode 1", color={0.8,0.8,0.8}, 
		x = 0, y = display.contentHeight - 180, size = 20, width = display.contentWidth, height = 200, align = "center"
	}))]]
	
	self:addToHUD(game.ui.newTapToContinueText())
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
    self:loadSound("thunder", "assets/sounds/game/gym/thunder.mp3")
    self.isTransitioning = false
    self.rainEffect:show()
	elseif event.phase == "did" then
		game.hud.hide()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
    self.rainEffect = game.ui.removeSelf(self.rainEffect)
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene