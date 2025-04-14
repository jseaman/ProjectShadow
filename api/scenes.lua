-----------------------------------------------------------------------------------------

local composer = require("composer")

-----------------------------------------------------------------------------------------

local scenes = {}

-----------------------------------------------------------------------------------------

composer.effectList["squadSlideUp"] = {
    sceneAbove = true,
    concurrent = true,
    to = {
        xStart     = 0,
        yStart     = device.contentHeight,
        xEnd       = 0,
        yEnd       = 0,
        transition = easing.outQuad
    },
    from = {
        xStart     = 0,
        yStart     = 0,
        xEnd       = 0,
        yEnd       = -device.contentHeight,
        transition = easing.outQuad
    }
}

composer.effectList["squadSlideDown"] = {
    sceneAbove = true,
    concurrent = true,
    to = {
        xStart     = 0,
        yStart     = -device.contentHeight,
        xEnd       = 0,
        yEnd       = 0,
        transition = easing.outQuad
    },
    from = {
        xStart     = 0,
        yStart     = 0,
        xEnd       = 0,
        yEnd       = device.contentHeight,
        transition = easing.outQuad
    }
}

-----------------------------------------------------------------------------------------

function scenes.newScene()
	local game = require("api.game")
	
	local scene = composer.newScene()
	scene.transitionList = {}
	scene.timerList = {}
	scene.soundList = {}
	
	function scene:trackTransition(t)
		table.insert(scene.transitionList, t)
		return t
	end
	
	function scene:newTransition(object, options)
		return self:trackTransition(transition.to(object, options))
	end
	
	function scene:untrackTransition(t)
		for i,v in ipairs(scene.transitionList) do
			if v == t then
				table.remove(scene.transitionList, i)
				break
			end
		end
	end
	
	function scene:trackTimer(t)
		table.insert(scene.timerList, t)
		return t
	end
	
	function scene:newTimer(delay, handler, times)
		return self:trackTimer(timer.performWithDelay(delay, handler, times))
	end
	
	function scene:untrackTimer(t)
		for i,v in ipairs(scene.timerList) do
			if v == t then
				table.remove(scene.timerList, i)
				break
			end
		end
	end
			
	function scene:loadAudioStream(name, fileName)
		scene.soundList[name] = game.stage.loadStream(fileName)
	end
			
	function scene:loadSound(name, fileName)
		scene.soundList[name] = game.stage.loadSound(fileName)
	end
	
	function scene:playSound(name, options)
		local sound = game.stage.play(scene:getSound(name), options)
		if not sound then
			print("Sound not found: ", name)
		end
		return sound
	end
	
	function scene:getSound(name)
		return scene.soundList[name]
	end
	
	function scene:cleanupTransitions()
		for t in list_iter(scene.transitionList) do
			game.ui.cancelTransition(t)
		end
		scene.transitionList = {}
	end
	
	function scene:cleanupTimers()
		for t in list_iter(scene.timerList) do
			game.ui.cancelTimer(t)
		end
		scene.timerList = {}
	end	
	
	function scene:cleanupTrackedObjects()
		scene:cleanupTransitions()		
		scene:cleanupTimers()
	end
	
	function scene:addToScene(object)
		if object then
			self.sceneLayer:insert(object)
		end
		return object
	end
	
	function scene:clearScene()
		for i=self.sceneLayer.numChildren,1,-1 do
			self.sceneLayer[i]:removeSelf()
			self.sceneLayer[i] = nil
		end
	end
	
	function scene:addToHUD(object)
		assert(self.hudLayer)
		self.hudLayer:insert(object)
		return object
	end
	
	function scene:hideHUD()
		assert(self.hudLayer)
		self.hudLayer.isVisible = false
	end
	
	function scene:showHUD()
		assert(self.hudLayer)
		self.hudLayer.isVisible = true
	end
	
	function scene:addToRoot(object)
		self.view:insert(object)
		return object
	end
	
	function scene:create(event)
		scene.rootLayer = display.newGroup()
		scene.view:insert(scene.rootLayer)
		
		scene.sceneLayer = display.newGroup()
		scene.rootLayer:insert(scene.sceneLayer)
		
		scene.hudLayer = display.newGroup()
		scene.rootLayer:insert(scene.hudLayer)
	
    if scene.onCreate then
			scene:onCreate(event)
		end
	end
	
	function scene:show(event)
		if scene.onShow then
			scene:onShow(event)
		end
		
		if event.phase == "did" then
      if scene.shouldRemoveHidden == nil or scene:shouldRemoveHidden() == true then
        composer.removeHidden()
      end
			
			if scene.refreshState then
				scene:refreshState()
			end
		end
		
		if scene.getFadeIn then
			local fadeIn = scene:getFadeIn()
			if fadeIn and fadeIn > 0 then
				if event.phase == "will" then
					scene._fadeFilter = game.ui.newTouchFullScreen(function() return true end)
					scene._fadeLayer = game.ui.insertChild(scene.view, game.ui.newRectFullScreen({0,0,0}, function() return false end))
				elseif event.phase == "did" then
					local delay = 0
					if scene.getFadeInDelay then
						delay = scene:getFadeInDelay()
					end
					scene:newTimer(delay, function()
						if scene.onBeforeFadeIn then
							scene:onBeforeFadeIn()
						end
						scene:newTimer(fadeIn/3, function()
							scene._fadeFilter = game.ui.removeSelf(scene._fadeFilter)
						end)
						scene:newTransition(scene._fadeLayer, { time=fadeIn, alpha = 0, onComplete=function() 
							scene._fadeLayer = game.ui.removeSelf(scene._fadeLayer)
							if scene.onFadeIn then
								scene:onFadeIn()
							end
						end})
					end)
				end
			end
		end
		
		if scene.getHUDFadeIn then
			local hudFadeIn = scene:getHUDFadeIn()
			if hudFadeIn and hudFadeIn > 0 then
				if event.phase == "will" then
					scene.hudLayer.alpha = 0
				elseif event.phase == "did" then
					scene:newTransition(scene.hudLayer, { time=hudFadeIn, alpha = 1 })
				end
			end
		end
	end
	
	function scene:hide(event)
		if scene.onHide then
			scene:onHide(event)
		end
		if event.phase == "did" then
			scene:cleanupTrackedObjects()
		end
	end	
	
	function scene:destroy(event)
		if scene.onDestroy then
			scene:onDestroy(event)
		end
		
		scene:cleanupTrackedObjects()
		
		for k,v in pairs(scene.soundList) do
			game.stage.dispose(v)
		end
		scene.soundList = {}
	end
	
	function scene:showMyCaptionAndTrigger(eventName, text, callback)
		scene:showCaptionAndTrigger(eventName, {
			text = text,
			callback = callback
		})
	end
	
	function scene:showCaptionAndTrigger(eventName, options)
		local userCallback = options.callback
		options.callback = function()
			scene:triggerEvent(eventName)
			if userCallback then
				userCallback()
			end
		end
		game.hud.showCaption(options)
	end
	
	function scene:triggerEvent(eventName)
		game.events.trigger(eventName)
		if scene.refreshState then
			scene:refreshState()
		end
	end
	
	scene:addEventListener("create", scene)
	scene:addEventListener("show", scene)
	scene:addEventListener("hide", scene)
	scene:addEventListener("destroy", scene)
	
	return scene
end

-----------------------------------------------------------------------------------------

function scenes.isInMainMenu()
	local currentScene = composer.getSceneName("current")
	return currentScene == "scene.menu"
end

-----------------------------------------------------------------------------------------

function scenes.getCurrentSceneName()
	return composer.getSceneName("current")
end

-----------------------------------------------------------------------------------------

function scenes.getCurrentScene()
	return composer.getScene(composer.getSceneName("current"))
end

-----------------------------------------------------------------------------------------

function scenes.getCurrentGameScene()
	local game = require("api.game")
	return game.data.currentScene
end

-----------------------------------------------------------------------------------------

function scenes.setCurrentGameScene(sceneName)
	local game = require("api.game")
	game.data.currentScene = sceneName
	game.markAsChanged()
end

-----------------------------------------------------------------------------------------

function scenes.getPreviousGameScene()
	local game = require("api.game")
	return game.data.previousScene
end

-----------------------------------------------------------------------------------------

function scenes.loadScene(scene)
  if not string.startsWith(scene, "scene.") then
		scene = "scene." .. scene
	end
  composer.loadScene(scene, false)
end

-----------------------------------------------------------------------------------------

function scenes.hideOverlay(recycleOnly, effect, time)
  composer.hideOverlay(recycleOnly, effect, time)
end

-----------------------------------------------------------------------------------------

function scenes.showOverlay(scene, options)
  if not string.startsWith(scene, "scene.") then
		scene = "scene." .. scene
	end
  composer.showOverlay(scene, options)
end

-----------------------------------------------------------------------------------------

function scenes.gotoScene(scene, effect, duration)
	if not string.startsWith(scene, "scene.") then
		scene = "scene." .. scene
	end
	
	local game = require("api.game")
	game.save()
	
	game.ui.enableTouch()
	
	game.inventory.close()
	
	game.hud.hideNotice()
	game.hud.hideCaption()
	game.hud.disableCaptions()
	
	effect = effect or "fade"
	if effect == "none" then
		effect = nil
	end
	
	local options = nil
	if type(effect) == "table" then
		options = effect
		effect = options.effect
		duration = duration or options.time
	end
	
	duration = duration or 200
	if not effect or type(effect) == "table" then
		duration = nil
	end
	
	game.stage.playGameMusic(scene)
	
	game.analytics.logScreen(scene)
	
	if effect == "fade" then
		scenes._fadeTransition = game.ui.cancelTransition(scenes._fadeTransition)
		if scenes._fadeScreen then
			scenes._fadeScreen:removeSelf()
			scenes._fadeScreen = nil
		end
		
		scenes._fadeScreen = game.ui.newRectFullScreen({0,0,0})
		scenes._fadeScreen:addEventListener("touch", function() return true end)
		scenes._fadeScreen.isHitTestable = true
		scenes._fadeScreen.alpha = 0
		scenes._fadeTransition = transition.to(scenes._fadeScreen, { time = duration / 2, alpha = 1, onComplete = function()
			game.hud.enableCaptions()
			if options then
				options.effect = nil
				options.time = nil
				composer.gotoScene(scene, options)
			else
				composer.gotoScene(scene)
			end
			game.save()
			scenes._fadeTransition = transition.to(scenes._fadeScreen, { time = duration / 2, alpha = 0, onComplete = function()
				scenes._fadeScreen:removeSelf()
				scenes._fadeScreen = nil
			end})
		end})
	elseif options then
		game.ui.disableTouch()
		game.hud.enableCaptions()
		composer.gotoScene(scene, options)
		game.ui.enableTouch()
	else
		game.ui.disableTouch()
		game.hud.enableCaptions()
		composer.gotoScene(scene, effect, duration)
		game.ui.enableTouch()
	end
	
	game.save()
end

-----------------------------------------------------------------------------------------

function scenes.gotoGameScene(scene, effect, duration)
	if not string.startsWith(scene, "scene.") then
		scene = "scene." .. scene
	end
	
	local game = require("api.game")
	local currentScene = scenes.getCurrentGameScene()
	if currentScene ~= scene then
		game.data.previousScene = currentScene
	end
	
	scenes.setCurrentGameScene(scene)
	scenes.gotoScene(scene, effect, duration)
end

-----------------------------------------------------------------------------------------

function scenes.gotoGameSceneDoor(scene, door)
	game.data.comingFromDoor = door
	game.markAsChanged()
	
	scenes.gotoGameScene(scene)
end

-----------------------------------------------------------------------------------------

function scenes.gotoMainMenu(isQuiet)
	local game = require("api.game")
	game.hud.hide()
	
	if isQuiet then
		scenes.gotoScene("menu", "none")
	else
		scenes.gotoScene("menu", "fade", 300)
	end
end

-----------------------------------------------------------------------------------------

function scenes.gotoJournal(player, entryName, cutoutName)
	local game = require("api.game")
	game.hud.hide()
	game.stage.play(game.stage.openJournalSound)
	
	local options = {
		effect = "fade",
		time = 300,
		params = {
			player = player or game.data.currentPlayer,
			entryName = entryName,
			cutoutName = cutoutName
		}
	}
	scenes.gotoScene("game.journal", options)
end

-----------------------------------------------------------------------------------------

function scenes.gotoHint()
	local game = require("api.game")
	game.hud.hide()
	game.stage.play(game.stage.openHintSound)
	scenes.gotoScene("game.hint", "fade", 300)
end

-----------------------------------------------------------------------------------------

function scenes.gotoTestScene(background)
	local options = {
		effect = "fade",
		time = 200,
		params = {
			background = background
		}
	}
	
	composer.gotoScene("scene.test", options)
end


return scenes