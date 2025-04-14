-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local buttonX = -19	
local buttonSize = 38
local buttonMargin = 4
local groupHeight = 5 * (buttonSize + buttonMargin) + buttonMargin
local buttonY = -groupHeight / 2 + buttonMargin
local moreGamesWidth = 207 + 30
local moreGamesHeight = 88 + 25

if not game.achievements.isSupported() then
	groupHeight = 4 * (buttonSize + buttonMargin) + buttonMargin
end

-----------------------------------------------------------------------------------------

local function onPlayButtonRelease()
	game.stage.playBackSound()
	game.go()
	return true
end

-----------------------------------------------------------------------------------------

local function onContinueButtonRelease()
	game.stage.playBackSound()
	
	if not game.isActive() then
		game.loadContinue()
	end
	
	game.go()
	return true
end

-----------------------------------------------------------------------------------------

local function onSettingsButtonRelease()
	game.stage.playBackSound()
  
  game.scenes.loadScene("settings")
	game.scenes.gotoScene("settings", "crossFade", 1000)
	return true
end

-----------------------------------------------------------------------------------------

local function onFacebookButtonRelease()
	game.stage.playBackSound()
	system.openURL("https://www.facebook.com/Squadventure")
	return true
end

-----------------------------------------------------------------------------------------

local function onAchievementButtonRelease()
	game.stage.playBackSound()
	game.achievements.show()
	return true
end

-----------------------------------------------------------------------------------------

local function onTwitterButtonRelease()
	game.stage.playBackSound()
	system.openURL("https://twitter.com/Squadventure")
	return true
end

-----------------------------------------------------------------------------------------

local function onRatingButtonRelease()
	game.stage.playBackSound()
	game.ratings.rate()
	return true
end

-----------------------------------------------------------------------------------------

local function onGroupButtonRelease()
	game.stage.playBackSound()
	
	if scene.groupButtonOn.isVisible then
		scene:closeButtonGroup()
	else
		scene.groupButtonOn.isVisible = true
		scene.groupButtonOff.isVisible = false
		scene:newTransition(scene.buttonGroup, { time = 400, y = 0, transition = easing.outQuad})	
	end
	return true
end

local function onMoreGamesButtonRelease()
	game.stage.playBackSound()
	
	if scene.moreGamesGroup.x == 0 then
		scene:newTransition(scene.moreGamesGroup, { time = 400, x = -moreGamesWidth, transition = easing.outSine})
	else
		scene:closeMoreGames()
	end
end

-----------------------------------------------------------------------------------------

function scene:closeMoreGames(animate)
	animate = optionalParam(animate, true)
	if self.moreGamesGroup then
		if animate then
			self:newTransition(self.moreGamesGroup, { time = 500, x = 0, transition = easing.outSine})
		else
			self.moreGamesGroup.x = 0
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:closeButtonGroup(animate)
	animate = optionalParam(animate, true)
	
	self.groupButtonOn.isVisible = false
	self.groupButtonOff.isVisible = true

	if animate then
		self:newTransition(self.buttonGroup, { time = 400, y = groupHeight, transition = easing.outQuad})
	else
		self.buttonGroup.y = groupHeight
	end
end

-----------------------------------------------------------------------------------------

function scene:isAnySubGroupOpen()
	return scene.groupButtonOn.isVisible or scene.moreGamesGroup.x ~= 0
end

-----------------------------------------------------------------------------------------

function scene:getHUDFadeIn()
	return 600
end

-----------------------------------------------------------------------------------------

function scene:addMoreGamesGroup()
	self.moreGamesGroup = self:addToHUD(game.ui.newGroup())
	
	local buttonWidth = 58
	local buttonHeight = 43
	local buttonTop = 40
	game.ui.insertChild(self.moreGamesGroup, game.ui.newButton(display.contentWidth - buttonWidth + 10, buttonTop, {
		defaultFile = "assets/images/menu/buttons/more_games.png", overFile = "assets/images/menu/buttons/more_games_on.png",
		width = buttonWidth, height = buttonHeight, onRelease = onMoreGamesButtonRelease
	}))
	
	game.ui.insertChild(self.moreGamesGroup, game.ui.newSceneObject(
	"assets/images/menu/new_game/background.png", display.contentWidth, buttonTop - 20, moreGamesWidth, moreGamesHeight
	))
	
	game.ui.insertChild(self.moreGamesGroup, game.ui.newTextBox({
		set_name="Standard", text="Check out our other games!", color={1,1,1}, 
		x = display.contentWidth + 10, y = buttonTop - 15, size = 12, width = 332, height = 200, align = "left"
	}))
	
	game.ui.insertChild(self.moreGamesGroup, game.ui.newSceneObjectAndDo(
	"assets/images/menu/more_games_lost_chapter.jpg", display.contentWidth + 10, buttonTop + 10, moreGamesWidth - 20, moreGamesHeight - 35, function()
		system.openURL(game.info.getGameUrl("tlc"))
	end))
end

-----------------------------------------------------------------------------------------

function scene:addButtonGroup()
	self.groupButtonOff = self:addToHUD(game.ui.newButton(10, display.contentHeight - 43 - 8, {
		defaultFile = "assets/images/menu/buttons/options_down.png", overFile = "assets/images/menu/buttons/options_down_on.png",
		width = 58, height = 43, onRelease = onGroupButtonRelease
	}))
	
	self.groupButtonOn = self:addToHUD(game.ui.newButton(10, display.contentHeight - 43 - 8, {
		defaultFile = "assets/images/menu/buttons/options_on.png", overFile = "assets/images/menu/buttons/options.png",
		width = 58, height = 43, onRelease = onGroupButtonRelease
	}))
	self.groupButtonOn.isVisible = false
  
	local groupContainer = self:addToHUD(game.ui.newContainer(10, self.groupButtonOff.y - groupHeight + 5, 58, groupHeight))
	self.buttonGroup = game.ui.insertChild(groupContainer, game.ui.newGroup())
	--game.ui.insertChild(self.buttonGroup, game.ui.newSceneObject("assets/images/menu/new_game/background.png", -15, -groupHeight/2, 30, groupHeight))
	
	--[[game.ui.insertChild(self.buttonGroup, game.ui.newButton(buttonX, buttonY, {
		defaultFile = "assets/images/menu/connect_icon.png", overFile = "assets/images/menu/connect_icon_over.png",
		width = buttonSize, height = buttonSize, onRelease = onConnectButtonRelease
	}))]]
	if game.achievements.isSupported() then
		buttonY = buttonY + buttonSize + buttonMargin
		game.ui.insertChild(self.buttonGroup, game.ui.newButton(buttonX, buttonY, {
			defaultFile = "assets/images/menu/buttons/achievements.png", overFile = "assets/images/menu/buttons/achievements_on.png",
			width = buttonSize, height = buttonSize, onRelease = onAchievementButtonRelease
		}))
	end
	buttonY = buttonY + buttonSize + buttonMargin
	game.ui.insertChild(self.buttonGroup, game.ui.newButton(buttonX, buttonY, {
		defaultFile = "assets/images/menu/buttons/rate_us.png", overFile = "assets/images/menu/buttons/rate_us_on.png",
		width = buttonSize, height = buttonSize, onRelease = onRatingButtonRelease
	}))
	buttonY = buttonY + buttonSize + buttonMargin
	game.ui.insertChild(self.buttonGroup, game.ui.newButton(buttonX, buttonY, {
		defaultFile = "assets/images/menu/buttons/twitter.png", overFile = "assets/images/menu/buttons/twitter.png",
		width = buttonSize, height = buttonSize, onRelease = onTwitterButtonRelease
	}))
	buttonY = buttonY + buttonSize + buttonMargin
	game.ui.insertChild(self.buttonGroup, game.ui.newButton(buttonX, buttonY, {
		defaultFile = "assets/images/menu/buttons/fb.png", overFile = "assets/images/menu/buttons/fb_on.png",
		width = buttonSize, height = buttonSize, onRelease = onFacebookButtonRelease
	}))
	self.buttonGroup.y = groupHeight
end

-----------------------------------------------------------------------------------------

function scene:createThunderEffect()
	self.thunders = {
		self:addToScene(game.ui.newBackground("assets/images/menu/menu_main_thunder1.jpg")),
		self:addToScene(game.ui.newBackground("assets/images/menu/menu_main_thunder2.jpg"))
	}
	for thunder in list_iter(self.thunders) do
		thunder.alpha = 0
	end
	
	self.shadows = {
		self:addToScene(game.ui.newImage("assets/images/menu/shadow_1.png", device.x(88), device.y(217), 30, 29)),
		self:addToScene(game.ui.newImage("assets/images/menu/shadow_2.png", device.x(163), device.y(217), 30, 29)),
		self:addToScene(game.ui.newImage("assets/images/menu/shadow_3.png", device.x(374), device.y(216), 30, 29)),
		self:addToScene(game.ui.newImage("assets/images/menu/shadow_4.png", device.x(450), device.y(215), 30, 29)),
	}
	for shadow in list_iter(self.shadows) do
		shadow.alpha = 0
	end
end

-----------------------------------------------------------------------------------------

function scene:animateThunder(overlay, shadows, index, maxFlickers)
	if index >= maxFlickers then
		for shadow in list_iter(shadows) do
			self:newTransition(shadow, { alpha = 0, time = 60 })
		end
		return
	end
	
	local alpha = 1
	if overlay.alpha == 1 then
		alpha = 0
	end
	
	local time = math.random(50, 120)

	self:newTransition(overlay, { alpha = alpha, time = time, onComplete = function()
		scene:animateThunder(overlay, shadows, index + 1, maxFlickers)
	end})
end

-----------------------------------------------------------------------------------------

function scene:startThunderEffect()
	self:newTimer(math.random(5000, 15000), function()
		local shadows = {}
		
		local numShadows = math.random(0, #self.shadows)
		if numShadows > 0 then
			local pickedShadowInd = lotto(numShadows, #self.shadows)
			for index in list_iter(pickedShadowInd) do
				shadows[#shadows + 1] = self.shadows[index]
			end
		end
		
		for shadow in list_iter(shadows) do
			self:newTransition(shadow, { alpha = 1, time = 60 })
		end
		
		scene:playSound("thunder")
		scene:animateThunder(self.thunders[math.random(1, #self.thunders)], shadows, 1, 7)
		
		scene:startThunderEffect()
	end)
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self.animate = event.params ~= nil and event.params.animate == true
	self:addToScene(game.ui.newBackground("assets/images/menu/menu_main.jpg"))
	
	self:createThunderEffect()
	
	self.rainEffect = self:addToScene(game.effects.newRainEffect({
		rain1 = "assets/images/menu/rain.png",
		rain2 = "assets/images/menu/rain2.png",
	}))
	
	self:addToScene(game.ui.newTouchFullScreen(function(event)
		if event.phase == "ended" then
			if self:isAnySubGroupOpen() then
				game.stage.playBackSound()
			end
			self:closeButtonGroup()
			self:closeMoreGames()
		end
		return true
	end))
	
	if game.isStarted() then
		self:addToHUD(game.ui.newButton(display.contentCenterX - 121/2, display.contentCenterY, {
			defaultFile = "assets/images/menu/buttons/continue.png", overFile = "assets/images/menu/buttons/continue_on.png",
			width = 121, height = 41, onRelease = onContinueButtonRelease
		}))
	else
		self:addToHUD(game.ui.newButton(display.contentCenterX - 121/2, display.contentCenterY, {
			defaultFile = "assets/images/menu/buttons/play.png", overFile = "assets/images/menu/buttons/play_on.png",
			width = 121, height = 41, onRelease = onPlayButtonRelease
		}))
	end
	
	self:addToHUD(game.ui.newButton(display.contentWidth - 58 - 10, display.contentHeight - 43 - 8, {
		defaultFile = "assets/images/menu/buttons/settings.png", overFile = "assets/images/menu/buttons/settings_on.png",
		width = 58, height = 43, onRelease = onSettingsButtonRelease
	}))
	
	self:addButtonGroup()
	
	self:addMoreGamesGroup()
	
	if self.animate then
		self.rainEffect2 = game.ui.insertChild(self.view, game.effects.newRainEffect({
			rain1 = "assets/images/menu/rain.png",
			rain2 = "assets/images/menu/rain2.png",
		}))
		self.cloudLayer1 = self:addToScene(game.ui.newGroup())
		game.ui.insertChild(self.cloudLayer1, game.ui.newImage("assets/images/menu/cloud_1.png", device.x(-80), device.y(0), 537, 221))
		
		self.cloudLayer2 = self:addToScene(game.ui.newGroup())
		game.ui.insertChild(self.cloudLayer2, game.ui.newImage("assets/images/menu/cloud_2.png", device.x(240), device.y(50), 537, 221))
		
		self.rootLayer.y = device.y(device.contentHeight)
	end
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("thunder", "assets/sounds/game/gym/thunder.mp3")
		self:closeMoreGames(false)
		self:closeButtonGroup(false)
		self.rainEffect:show()
		if self.animate then
			self.rainEffect2:show()
		end
		game.hud.hide()
	elseif event.phase == "did" then
		game.hud.hide()
		game.ratings.tryAskRate()
		
		if self.animate then
			self:newTransition(self.rootLayer, { y = 0, time = 2000, onComplete = function() 
				scene:startThunderEffect()	
			end})
			self:newTransition(self.cloudLayer1, { y = -221, time = 2000 })			
			self:newTransition(self.cloudLayer2, { y = -270, time = 1700 })
		else
			scene:startThunderEffect()
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		self.rainEffect = game.ui.removeSelf(self.rainEffect)
		self.rainEffect2 = game.ui.removeSelf(self.rainEffect2)
		self:closeMoreGames(false)
		self:closeButtonGroup(false)
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene