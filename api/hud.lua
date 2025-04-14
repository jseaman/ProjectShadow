-----------------------------------------------------------------------------------------

local display = require("display")
local game = require("api.game")

-----------------------------------------------------------------------------------------

local hud = {}

-----------------------------------------------------------------------------------------

function hud.show()
	hud.showHome()
	hud.showInventory()
end

-----------------------------------------------------------------------------------------

function hud.hide()
	hud.hideHome()
	hud.hideInventory()
	hud.hideCaption()
end

-----------------------------------------------------------------------------------------

function hud.hideHomeAndInventory()
	hud.hideHome()
	hud.hideInventory()
end

-----------------------------------------------------------------------------------------

function hud.remove()
end
 
-----------------------------------------------------------------------------------------

local function getNextCaptionId()
	local captionID = hud.captionID
	if not captionID then
		captionID = 1
	else
		captionID = captionID + 1
	end
	return captionID
end

local function onCaptionScreenTouch(event)
	if event.phase == "ended" and hud.caption then
		if hud.caption:isScrollingText() then
			hud.caption:setFullText()
		elseif not hud.caption:isShowing() then
			hud.hideCaption(hud.captionID)
		end
	end
	if (hud.caption and hud.captionIsChain and hud.captionChainIndex <= #hud.captionChain) or hud.filterTouch then
		return true
	else
		return false
	end
end

-----------------------------------------------------------------------------------------

function hud.isCaptionActive()
	return hud.caption ~= nil
end

-----------------------------------------------------------------------------------------

function hud.showInfoCaption(text, callback)
	hud.showCaption({
		text = text,
		callback = callback,
		color = {0.77, 0.83, 0.07}
	})
end

function hud.showMyCaption(text, callback, time)
	hud.showCaption({
		text = text,
		callback = callback, 
    time = time
	})
end

function hud.showMyCaptionIfNotEvent(eventName, text, callback)
	hud.showCaptionIfNotEvent(eventName, {
		text = text,
		callback = callback
	})
end

function hud.showInfoCaptionIfNotEvent(eventName, text, callback)
	hud.showCaptionIfNotEvent(eventName, {
		text = text,
		callback = callback,
		color = {0.77, 0.83, 0.07}
	})
end

function hud.showMyCaptionAndTrigger(eventName, text, callback)
	hud.showCaptionAndTrigger(eventName, {
		text = text,
		callback = callback
	})
end

function hud.showInfoCaptionAndTrigger(eventName, text, callback)
	hud.showCaptionAndTrigger(eventName, {
		text = text,
		callback = callback,
		color = {0.77, 0.83, 0.07}
	})
end

-----------------------------------------------------------------------------------------

function hud.disableCaptions()
	hud.captionDisabled = true
end

function hud.enableCaptions()
	hud.captionDisabled = nil
end

-----------------------------------------------------------------------------------------

function hud.showCaptionIfNotEvent(eventName, options)
	if not game.events.isTriggered(eventName) then
		hud.showCaptionAndTrigger(eventName, options)
	end
end

function hud.showCaptionAndTrigger(eventName, options)
	local userCallback = options.callback
	options.callback = function()
		game.events.trigger(eventName)
		if userCallback then
			userCallback()
		end
	end
	hud.showCaption(options)
end

function hud.showRandomCaption(options)
	if type(options.text) == "table" and #options.text > 0 then
		options.text = options.text[math.random(1, #options.text)]
	end
	hud.showCaption(options)
end

function hud.showCaption(options)
	hud.hideCaption()
	
	if hud.captionDisabled then
		return
	end
	
	if type(options) == "string" then
		options = { text = options }
	end
	
	if type(options.text) == "table" then
		hud.showCaptionChain(options)
		return
	end
	
	options.noScroll = true
	hud.caption = game.ui.newCaption(options)
	hud.captionCallback = options.callback
	hud.captionIsChain = options.isChain
	hud.captionChain = options.chain
	hud.captionChainIndex = options.chainIndex
	hud.filterTouch = options.filterTouch
	hud.captionEvent = options.event
	hud.caption:show()
	
	local captionID = getNextCaptionId()
	hud.captionID = captionID
	
	if not options.noTouchScreen then
		hud.touchScreen = game.ui.newTouchFullScreen(onCaptionScreenTouch)
	end
	
	if options.time then
		hud.captionTimer = game.ui.trackTimer(timer.performWithDelay(hud.caption:getTimeToShow() + options.time, function ()
			hud.captionTimer = nil
			hud.hideCaption(captionID)
		end))
	end
	
	return captionID
end

-----------------------------------------------------------------------------------------

function hud.destroyCaption()
	if hud.caption then
		hud.caption:hideAndDestroy()
		hud.caption = nil
	end
	
	hud.touchScreen = game.ui.removeSelf(hud.touchScreen)
	hud.captionTimer = game.ui.cancelTimer(hud.captionTimer)
end

function hud.hideCaption(captionID)
	if hud.caption and (not captionID or captionID == hud.captionID) then
		hud.destroyCaption()
		
		if (not captionID and not hud.captionIsChain) or captionID then
			if hud.captionCallback then
				hud.captionCallback()
			end
			if hud.captionEvent then
				game.events.trigger(hud.captionEvent)
			end
		end
	end
end

-----------------------------------------------------------------------------------------

function hud.showCaptionChain(options)
	local chain = options.chain
	local callback = options.callback
	local event = options.event
	local filterTouch = options.filterTouch
	local text = options.text
	
	if not chain and text then
		chain = {}
		if type(text) == "string" then
			text = {text}
		end
		for t in list_iter(text) do
			table.insert(chain, { who = options.who, text = t })
		end
	end
	
	if chain and #chain > 0 then
		local currentIndex = 1
		
		local function showNextCaption()
			local currentCaption = chain[currentIndex]
			local currentCallback = currentCaption.callback
			
			local captionCallback = function()
				if currentCallback then
					currentCallback()
				end
				
				if currentIndex < #chain then
					currentIndex = currentIndex + 1
					showNextCaption()
				else
					if callback then
						callback()
					end
					if event then
						game.events.trigger(event)
					end
				end
			end
			
			currentCaption.filterTouch = filterTouch
			currentCaption.isChain = true
			currentCaption.chain = chain
			currentCaption.chainIndex = currentIndex
			currentCaption.callback = captionCallback
			hud.showCaption(currentCaption)
		end
		
		showNextCaption()
	elseif callback then
		callback()
	end
end

-----------------------------------------------------------------------------------------

local ShowNoticeDelay = 500

function hud.showNotice(options)
	if options.delay then
		local delay = options.delay
		options.delay = nil
		ui.trackTimer(timer.performWithDelay(delay, function() hud.showNotice(options) end))
		return
	end
	
	hud.hideNotice()
		
	local group = display.newGroup()
	group.anchorChildren = true
	group.anchorX, group.anchorY = 0,0
	group.x, group.y = 10, display.contentCenterY
	group.alpha = 0
	
	local background = game.ui.newRect(0, 0, 190, 60, {0, 0, 0})
	background.alpha = 0.5
	background.x, background.y = 0, 0
	group:insert(background)
	
	local textX = 8
	
	if options.icon then
		local icon = game.ui.newSceneObject(options.icon.imageFile, textX, 5, options.icon.width, options.icon.height)
		group:insert(icon)
		textX = textX + options.icon.width + 7
	end
	
	local text = display.newText(options.text, 0, 0, native.systemFontBold, 14)
	text.anchorX, text.anchorY = 0, 0
	text.x, text.y = textX, 20
	text:setFillColor(1, 1, 1)
	group:insert(text)
	
	hud.notice = group
	
	transition.to(hud.notice, { time=ShowNoticeDelay, alpha=1 })
		
	game.stage.play(game.stage.loadSound("assets/sounds/game/notice.mp3"))
	
	ui.trackTimer(timer.performWithDelay(ShowNoticeDelay + 2500, function ()
		hud.hideNotice()
	end))
end

-----------------------------------------------------------------------------------------

function hud.hideNotice()
	if hud.notice then
		local notice = hud.notice
		hud.notice = nil
		
		game.ui.trackTransition(transition.to(notice, { 
			time=ShowNoticeDelay, alpha=0, onComplete=function()
				notice:removeSelf()
				return true
			end
		}))
	end
end

-----------------------------------------------------------------------------------------

function hud.showInventory()
	game.inventory.show()
end

-----------------------------------------------------------------------------------------

function hud.hideInventory()
	game.inventory.hide()
end

-----------------------------------------------------------------------------------------

local HomeButtonWidth = 40--52
local HomeButtonHeight = 40--52

-----------------------------------------------------------------------------------------

function hud.showHome()
	if not hud._homeButton then
		local group = display.newGroup()
		group.alpha = 0
		group.anchorX, group.anchorY = 0, 0
		group.anchorChildren = true
		--group.x, group.y = display.contentWidth - HomeButtonWidth - 10, display.contentHeight - HomeButtonHeight - 6
		group.x, group.y = display.contentWidth - HomeButtonWidth - 16, 6
			
		local button = game.ui.insertChild(group, game.ui.newButton(0, 0, {
			defaultFile = "assets/images/hud/buttons/home_button.png",
			overFile = "assets/images/hud/buttons/home_button_over.png",
			width = HomeButtonWidth, height = HomeButtonHeight,
			onRelease = function()
				--game.stage.play(game.stage.homeButtonSound)
				game.stage.playBackSound()
				game.scenes.gotoMainMenu()
			end
		}))
		
		hud._homeButton = group
	end
	
	if hud._homeButton.alpha == 0 then
		hud.homeTransition = transition.to(hud._homeButton, { time=850, alpha = 1 })
	end
end

-----------------------------------------------------------------------------------------

function hud.hideHome()
	hud.homeTransition = game.ui.cancelTransition(hud.homeTransition)
	if hud._homeButton then
		hud._homeButton.alpha = 0
	end	
end

-----------------------------------------------------------------------------------------

return hud