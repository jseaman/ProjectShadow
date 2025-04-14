-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local GemstoneWidth = 122
local GemstoneHeight = 161
local GemstoneX = display.contentWidth/2 - GemstoneWidth/2
local GemstoneY = device.y(0)
local TextFontColor = { 0.17, 0.97, 0.85 }

-----------------------------------------------------------------------------------------

local function onBackButtonRelease()
	game.stage.playBackSound()
	game.go()
	return true
end

local function onHintButtonRelease()
	scene:beginCharm()
	return true
end

local function onUnlockButtonRelease()
	game.purchases.unlockHints()
	return true
end

-----------------------------------------------------------------------------------------

function scene:getFadeIn()
	return 500
end

-----------------------------------------------------------------------------------------

function scene:getFadeInDelay()
	return 1000
end

-----------------------------------------------------------------------------------------

function scene:showSmoke()
	game.ui.insertChild(self.smokeLayer, game.particles.createStartedParticle("hints_smoke", "smoke", display.contentWidth/2, display.contentHeight/2))
	game.particles.start()
end

-----------------------------------------------------------------------------------------

function scene:showCharmEffect()
	self:addToScene(game.particles.createStartedParticle("hints_charm_dust", "dust", display.contentWidth/2, GemstoneY + GemstoneHeight/2))
	self:playSound("charm")
	game.particles.start()
end

function scene:hideCharmEffect()
	--TODO: stop charm sound
	game.particles.deleteEmitter("dust")
end

-----------------------------------------------------------------------------------------

function scene:beginCharm()
	self.hintGroup = game.ui.removeSelf(self.hintGroup)
	self:showCharmEffect()	
	
	self:newTimer(3000, function()
		self:showNextHint(true)
		self:hideCharmEffect()
	end)
end

function scene:showNextHint(resetTimer)
	game.events.trigger("used_hints")
	
	local hint = game.hints.getNextHint()
	local hintText = hint.text
	
	if resetTimer then
		game.hints.setLastHint(hint.name)
		game.hints.resetTimer()
	end

	local textBox = self:addToScene(game.ui.newTextBox({
		text = hintText, set_name = "Standard", size = 15, color = TextFontColor, align = "center",
		x = 10, y = device.y(180), width = display.contentWidth - 20, height = 200}))
	textBox.alpha = 0
	self:newTransition(textBox, { time = 400, alpha = 1 })
end

-----------------------------------------------------------------------------------------

function scene:getCurrentTimeLeftText()
	local timeLeft = game.hints.getTimeLeft()
	local minutes = math.floor(timeLeft / 60)
	local seconds = (timeLeft - minutes*60) % 60
		
	if seconds < 10 then
		seconds = "0" .. seconds
	end
	
	return minutes .. ":" .. seconds
end

-----------------------------------------------------------------------------------------

function scene:switchToReadyScreen()
	self:newTransition(self.waitGroup, { time = 400, alpha = 0, onComplete = function()
		self.waitGroup = game.ui.removeSelf(self.waitGroup)
		self:createHintReadyScreen()
	end})
end

-----------------------------------------------------------------------------------------

function scene:createHintWaitScreen()
	self.waitGroup = self:addToScene(game.ui.newGroup())
	
	game.ui.insertChild(self.waitGroup, game.ui.newTextBox({
		text = i18n._"Hints.Disabled", set_name = "Standard", size = 14, color = TextFontColor, align = "center",
		x = 0, y = device.y(165), width = display.contentWidth, height = 200}))
		
	game.ui.insertChild(self.waitGroup, game.ui.newTextBox({
		text = i18n._"Hints.TimeRemaining", set_name = "Standard", size = 14, color = TextFontColor, align = "left",
		x = device.x(180), y = device.y(195), width = 120, height = 200}))
		
	self.timeTextBox = game.ui.insertChild(self.waitGroup, game.ui.newTextBox({
		text = self:getCurrentTimeLeftText(), set_name = "Standard", size = 14, color = {0.95,0.16,0.10}, align = "left",
		x = device.x(300), y = device.y(195), width = 80, height = 200}))
		
	self.hintTimer = self:newTimer(1000, function()
		if game.hints.isReady() then
			self:switchToReadyScreen()
			self.hintTimer = game.ui.cancelTimer(self.hintTimer)
		else
			self.timeTextBox:setText(self:getCurrentTimeLeftText())
		end
	end, 0)
		
	game.ui.insertChild(self.waitGroup, game.ui.newTextBox({
		text = i18n._"Hints.UseHintsResponsibly", set_name = "Standard", size = 12, color = TextFontColor, align = "center",
		x = device.x(40), y = device.y(250), width = 500, height = 200}))
	
	if game.purchases.isSupported() then
		game.ui.insertChild(self.waitGroup, game.ui.newTextBox({
			text = i18n._"Hints.DontWannaWait?", set_name = "Standard", size = 12, color = TextFontColor, align = "center",
			x = device.x(40), y = device.y(280), width = 500, height = 200}))

		game.ui.insertChild(self.waitGroup, game.ui.newButton(display.contentWidth/2 - 100/2, device.y(300), {
			label = i18n._"Hints.UnlockButton", labelColor = { default={1,1,1} }, font = fonts.getFontBySetName("Standard"),
			defaultFile = "assets/images/game/hints/button_solution.png",
			width = 100, height = 32, onRelease = onUnlockButtonRelease
		}))
	end
end

function scene:createHintReadyScreen()
	self.hintGroup = self:addToScene(game.ui.newGroup())
	
	game.ui.insertChild(self.hintGroup, game.ui.newTextBox({
		text = i18n._"Hints.Description", set_name = "Standard", size = 14, color = TextFontColor, align = "center",
		x = 0, y = device.y(170), width = display.contentWidth, height = 200}))
	
	game.ui.insertChild(self.hintGroup, game.ui.newButton(display.contentWidth/2 - 80/2, device.y(215), {
		label = i18n._"Hints.ActivateButton", labelColor = { default={1,1,1} }, font = fonts.getFontBySetName("Standard"),
		defaultFile = "assets/images/game/hints/button_solution.png",
		width = 80, height = 37, onRelease = onHintButtonRelease
	}))
	
	game.ui.insertChild(self.hintGroup, game.ui.newTextBox({
		text = i18n._"Hints.UseHintsResponsibly", set_name = "Standard", size = 12, color = TextFontColor, align = "center",
		x = device.x(0), y = device.y(280), width = 570, height = 200}))
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/hints/hints_bg.jpg"))
	
	self.smokeLayer = self:addToScene(game.ui.newGroup())
	
	self:addToScene(game.ui.newSceneObject("assets/images/game/hints/gemstone.png", GemstoneX, GemstoneY, GemstoneWidth, GemstoneHeight))		
	
	if game.hints.isSameNextHint() then
		self:showNextHint()
	elseif game.hints.isReady() then
		self:createHintReadyScreen()
	else
		self:createHintWaitScreen()
	end
	
	self:addToHUD(game.ui.newButton(display.contentWidth - 52 - 10, display.contentHeight - 52 - 8, {
		defaultFile = "assets/images/hud/buttons/back_button.png", overFile = "assets/images/hud/buttons/back_button_over.png",
		width = 52, height = 52, onRelease = onBackButtonRelease
	}))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		game.hud.hide()
		self:showSmoke()
		self:loadSound("charm", "assets/sounds/game/hints/angelic.mp3")
	elseif event.phase == "did" then		
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		scene:hideCharmEffect()
		game.particles.cleanUp()
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene