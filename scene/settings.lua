-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local eyes =  {
	{ x = 119, y = 121 },
	{ x = 168, y = 115 },
	{ x = 266, y = 115 },
	{ x = 365, y = 119 },
	{ x = 412, y = 121 },
}

local EyeWidth = 38
local EyeHeight = 13

-----------------------------------------------------------------------------------------

local function onMusicButtonRelease()
	if game.data.settings.isMusicMuted then
		game.data.settings.isMusicMuted = nil
		scene:playMusic()
	else
		game.data.settings.isMusicMuted = true
		scene:stopMusic()
	end
  
	game.markAsChanged()
  game.stage.playBackSound()
  
	scene.musicOnButton.isVisible = not game.data.settings.isMusicMuted
	scene.musicOffButton.isVisible = (game.data.settings.isMusicMuted == true)
	return true
end

-----------------------------------------------------------------------------------------

local function onSoundButtonRelease()  
	if game.data.settings.isSoundMuted then
		game.data.settings.isSoundMuted = nil
	else
		game.data.settings.isSoundMuted = true
	end
	
  game.markAsChanged()
  game.stage.playBackSound()
  
	scene.soundOnButton.isVisible = not game.data.settings.isSoundMuted
	scene.soundOffButton.isVisible = (game.data.settings.isSoundMuted == true)
	return true
end

-----------------------------------------------------------------------------------------

local function onNewGameButtonRelease()
  game.stage.playBackSound()
  game.scenes.showOverlay("new_game", { effect = "fade", time = 500, isModal = true })
	return true
end

-----------------------------------------------------------------------------------------


local function onBackButtonRelease()
  game.stage.playBackSound()
  game.scenes.loadScene("menu")
	game.scenes.gotoScene("menu", "crossFade", 1500)
	return true
end

-----------------------------------------------------------------------------------------

function scene:animateEye(eye)
	scene:newTransition(eye.image, { alpha = 1, delay = math.random(3000, 15000), time = 300, onComplete=function()
		scene:newTransition(eye.image, { alpha = 0, delay = 1000, time = 200, onComplete=function()
			scene:animateEye(eye)
		end})
	end})
end

-----------------------------------------------------------------------------------------

function scene:animateEyes()
	for i,eye in ipairs(eyes) do
		scene:animateEye(eye)
	end
end

-----------------------------------------------------------------------------------------

function scene:playMusic()
	game.stage.playGameMusic("scene.settings")
end

-----------------------------------------------------------------------------------------

function scene:stopMusic()
	game.stage.stopBackgroundMusic(0)
end


-----------------------------------------------------------------------------------------

function scene:getHUDFadeIn()
	return 600
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/menu/settings/settings.jpg"))
	
	for i,eye in ipairs(eyes) do
		eye.image = self:addToScene(game.ui.newImage("assets/images/menu/settings/eye_" .. i .. ".jpg", device.x(eye.x), device.y(eye.y), EyeWidth, EyeHeight))
		eye.image.alpha = 0
	end
	
  self.rainEffect = self:addToScene(game.effects.newRainEffect({
		rain1 = "assets/images/menu/rain.png",
		rain2 = "assets/images/menu/rain2.png",
	}))
	
	self.musicOnButton = self:addToHUD(game.ui.newButton(device.x(180), device.y(136), {
		defaultFile = "assets/images/menu/settings/music_on.png",
		width = 83, height = 59, onRelease = onMusicButtonRelease
	}))
	self.musicOffButton = self:addToHUD(game.ui.newButton(device.x(180), device.y(136), {
		defaultFile = "assets/images/menu/settings/music_off.png",
		width = 83, height = 59, onRelease = onMusicButtonRelease
	}))
	self.musicOnButton.isVisible = not game.data.settings.isMusicMuted
	self.musicOffButton.isVisible = game.data.settings.isMusicMuted == true
	
	self.soundOnButton = self:addToHUD(game.ui.newButton(device.x(302), device.y(136), {
		defaultFile = "assets/images/menu/settings/fx_on.png",
		width = 83, height = 59, onRelease = onSoundButtonRelease
	}))
	self.soundOffButton = self:addToHUD(game.ui.newButton(device.x(302), device.y(136), {
		defaultFile = "assets/images/menu/settings/fx_off.png",
		width = 83, height = 59, onRelease = onSoundButtonRelease
	}))
	self.soundOnButton.isVisible = not game.data.settings.isSoundMuted
	self.soundOffButton.isVisible = game.data.settings.isSoundMuted == true
	
	self:addToHUD(game.ui.newButton(device.x(183), device.y(204), {
		defaultFile = "assets/images/menu/settings/new_game.png", overFile = "assets/images/menu/settings/new_game_on.png",
		width = 200, height = 67, onRelease = onNewGameButtonRelease
	}))
	
	self:addToHUD(game.ui.newButton(display.contentWidth - 58 - 10, display.contentHeight - 43 - 8, {
		defaultFile = "assets/images/menu/settings/back.png", overFile = "assets/images/menu/settings/back_on.png",
		width = 58, height = 43, onRelease = onBackButtonRelease
	}))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self.rainEffect:show()
	elseif event.phase == "did" then
		game.hud.hide()
		scene:animateEyes()
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