-----------------------------------------------------------------------------------------

local widget = require("widget")
local display = require("display")

-----------------------------------------------------------------------------------------

local ui = {}

-----------------------------------------------------------------------------------------

function ui.trackTimer(t)
	ui.timerList = ui.timerList or {}
	table.insert(ui.timerList, t)
	return t
end

function ui.trackTransition(t)
	ui.transitionList = ui.transitionList or {}
	table.insert(ui.transitionList, t)
	return t
end

function ui.cleanupTrackedObjects()
	if ui.transitionList then
		for t in list_iter(ui.transitionList) do
			ui.cancelTransition(t)
		end
		ui.transitionList = {}
	end
	if ui.timerList then
		for t in list_iter(ui.timerList) do
			ui.cancelTimer(t)
		end
		ui.timerList = {}
	end
	ui.enableTouch()
end

-----------------------------------------------------------------------------------------

function ui.disableTouch()
	ui.enableTouch()
	
	local screen = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	screen.anchorX, screen.anchorY = 0, 0
	screen.x, screen.y = 0, 0
	screen.alpha = 0
	screen.isHitTestable = true
	screen:addEventListener("touch", function ()
		return true
	end)
	
	ui._touchScreen = screen
end

-----------------------------------------------------------------------------------------

function ui.enableTouch()
	if ui._touchScreen then
		ui._touchScreen:removeSelf()
		ui._touchScreen = nil
	end
end

-----------------------------------------------------------------------------------------

function ui.newBackButton(options)
	options = options or {}
	
	if type(options) == "string" then
		options = { scene = options }
	end
	
	if type(options) == "function" then
		local release = options
		options = { onRelease = function()
				game.stage.playBackSound()
				release()
			end
		}
	end
	
	local game = require("api.game")
	if not options.scene and not options.onRelease then
		options.scene = game.scenes.getPreviousGameScene()
	end
	
	if options.scene then
		local sceneName = options.scene
		local effect = options.effect or "fade"
		local duration = options.duration or 400
		
		options.onRelease = function (event)
			game.stage.playBackSound()
			game.scenes.gotoGameScene(sceneName, effect, duration)
			return true
		end
	end
	
	local button = ui.newButton(display.contentWidth - 52 - 10, display.contentHeight - 52 - 6, {
		defaultFile = "assets/images/hud/buttons/back_button.png",
		overFile = "assets/images/hud/buttons/back_button_over.png",
		onRelease = options.onRelease,
		width = 52, height = 52
	})
	
	return button
end

-----------------------------------------------------------------------------------------

function ui.newBackground(imageFile, group, touch)
	local background
	if group then
		background = display.newImageRect(group, imageFile, device.contentWidth, device.contentHeight)
	else
		background = display.newImageRect(imageFile, device.contentWidth, device.contentHeight)
	end
	background.anchorX, background.anchorY = 0, 0
	background.x, background.y = device.x(0), device.y(0)
	if touch then
		background:addEventListener("touch", touch)
	end
	return background
end

-----------------------------------------------------------------------------------------

function ui.newScreenBackground(imageFile, group, touch)
	local background
	if group then
		background = display.newImageRect(group, imageFile, display.contentWidth, display.ContentHeight)
	else
		background = display.newImageRect(imageFile, display.contentWidth, display.contentHeight)
	end
	background.anchorX, background.anchorY = 0, 0
	background.x, background.y = 0, 0
	if touch then
		background:addEventListener("touch", touch)
	end
	return background
end

-----------------------------------------------------------------------------------------

function ui.newButton(x, y, options)
	local button = widget.newButton(options)
	button.anchorX, button.anchorY = 0,0
	button.x, button.y = x, y
	return button
end

-----------------------------------------------------------------------------------------

function ui.newGroup()
	local group = display.newGroup()
	group.anchorX, group.anchorY = 0,0
	group.x, group.y = 0,0
	--group.anchorChildren = true
	return group
end

-----------------------------------------------------------------------------------------

function ui.newContainer(x, y, w, h)
	local container = display.newContainer(w, h)
	container.anchorX, container.anchorY = 0, 0
	container.x, container.y = x, y
	return container
end


-----------------------------------------------------------------------------------------

local ObjectMinWidth = 25
local ObjectMinHeight = 20

-----------------------------------------------------------------------------------------

function ui.newTouchRegion(x, y, w, h, touch)
	if w < ObjectMinWidth then
		x = x - (ObjectMinWidth - w)/2
		w = ObjectMinWidth
	end

	if h < ObjectMinHeight then
		y = y - (ObjectMinHeight - h)/2
		h = ObjectMinHeight
	end
	
	local region = display.newRect(x, y, w, h)
	region.anchorX, region.anchorY = 0, 0
	region.x, region.y = x, y
	region.alpha = 0
	region.isHitTestable = true
	region.initialX, region.initialY = x, y
	region:addEventListener("touch", touch)
	return region
end

-----------------------------------------------------------------------------------------

function ui.newTouchRegionTap(x, y, w, h, touch)
	return ui.newTouchRegion(x, y, w, h, function(event)
		if event.phase == "ended" then
			touch()
		end
		return true
	end)	
end

-----------------------------------------------------------------------------------------

function ui.newItemRegion(x, y, w, h, options)
	local game = require("api.game")
	
	local function getItemFunction(event)
		if type(event) == "function" then
			return event
		elseif event then
			local caption = event
			local captionType = "info"
			local handler = nil
			local eventName = nil
			if type(event) == "table" then
				caption = event.text
				captionType = event.captionType or "info"
				eventName = event.event
				handler = event.handler
			end
			return function()
				if captionType == "info" then
					game.hud.showInfoCaption(caption)
				else
					game.hud.showMyCaption(caption)
				end
				if handler then
					handler()
				end
				if eventName then
					game.events.trigger(eventName)
				end
			end
		else
			return function() end
		end
	end
	
	local region = nil
	
	local function onTouchRegion()		
		local itemName = options.itemName
		local onCorrectItem = getItemFunction(options.onCorrectItem or nil)
		local onWrongItem = getItemFunction(options.onWrongItem or i18n._"Item.WrongItem")
		local onNoItem = getItemFunction(options.onNoItem or i18n._"Item.NoItem")
				
		if game.inventory.hasSelectedItem(itemName) then
			game.inventory.discard(itemName)
			game.inventory.close()
			onCorrectItem()
			region:removeSelf()
		elseif game.inventory.hasSelection() then
			onWrongItem()
		else
			onNoItem()
		end
	end
	
	region = ui.newTouchRegionTap(x, y, w, h, onTouchRegion)
	return region
end

-----------------------------------------------------------------------------------------

function ui.newTouchCaption(x, y, w, h, caption)
	if type(caption) == "string" then
		caption = { text = caption }
	end
	return ui.newTouchRegion(x, y, w, h, function(event)
		if event.phase == "ended" then
			local game = require("api.game")
			game.hud.showCaption(caption)
		end
		return true
	end)
end

-----------------------------------------------------------------------------------------

function ui.newTouchInfo(x, y, w, h, caption)
	return ui.newTouchRegion(x, y, w, h, function(event)
		if event.phase == "ended" then
			local game = require("api.game")
			game.hud.showInfoCaption(caption)
		end
		return true
	end)
end

-----------------------------------------------------------------------------------------

function ui.newTouchMyCaption(x, y, w, h, caption)
	return ui.newTouchRegion(x, y, w, h, function(event)
		if event.phase == "ended" then
			local game = require("api.game")
			game.hud.showMyCaption(caption)
		end
		return true
	end)
end

-----------------------------------------------------------------------------------------

function ui.newTouchAndGo(x, y, w, h, scene, effect, duration)
	return ui.newTouchRegionTap(x, y, w, h, function(event)
		local game = require("api.game")
		game.scenes.gotoGameScene(scene, effect, duration)
	end)
end

-----------------------------------------------------------------------------------------

function ui.newTouchAndGoDoor(x, y, w, h, scene, door)
	return ui.newTouchRegionTap(x, y, w, h, function(event)
		local game = require("api.game")
		game.data.comingFromDoor = door
		game.markAsChanged()
		
		game.scenes.gotoGameScene(scene)
	end)
end

-----------------------------------------------------------------------------------------

function ui.newBackTouch(height, scene, effect, duration)
	return ui.newTouchRegionTap(0, display.contentHeight - height, display.contentWidth, height, function(event)		
		local game = require("api.game")
		game.stage.playBackSound()
		game.scenes.gotoGameScene(scene, effect, duration)
	end)
end

-----------------------------------------------------------------------------------------

function ui.newSimpleBackTouch(scene, effect, duration)
	return ui.newBackTouch(40, scene, effect, duration)
end

-----------------------------------------------------------------------------------------

function ui.newBackTouchAndDo(height, touch)
	return ui.newTouchRegionTap(0, display.contentHeight - height, display.contentWidth, height, touch)
end

-----------------------------------------------------------------------------------------

function ui.newTouchFullScreen(touch)
	local screen = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	screen.anchorX, screen.anchorY = 0, 0
	screen.x, screen.y = 0, 0
	screen.alpha = 0
	screen.isHitTestable = true
	screen:addEventListener("touch", touch)
	return screen
end

-----------------------------------------------------------------------------------------

function ui.newImage(imageFile, x, y, w, h)
	local object = display.newImageRect(imageFile, w, h)
	object.anchorX, object.anchorY = 0, 0
	object.x, object.y = x, y
	
	return object
end

-----------------------------------------------------------------------------------------

function ui.newHardImage(imageFile, x, y, w, h)
	local object = ui.newImage(imageFile, x, y, w, h)
	object:addEventListener("touch", function() return true end)
	return object
end

-----------------------------------------------------------------------------------------

function ui.newSceneObject(imageFile, x, y, w, h, touch)
	local object = ui.newImage(imageFile, x, y, w, h)
	
	if touch then
		--[[if w < ObjectMinWidth or h < ObjectMinHeight then
			local image = object
			object = ui.newGroup()
			object:insert(image)
			
			local diffX = 0
			local diffY = 0
			
			if w < ObjectMinWidth then
				diffX = ObjectMinWidth - w
			end
			
			if h < ObjectMinHeight then
				diffY = ObjectMinHeight - h
			end
			
			object:insert(ui.newTouchRegion(x - diffX/2, y - diffY/2, w + diffX, h + diffY, touch))
		else
			object:addEventListener("touch", touch)
		end]]
		object:addEventListener("touch", touch)
	end
	return object
end

-----------------------------------------------------------------------------------------

function ui.newSceneObjectAndDo(imageFile, x, y, w, h, func)
	return ui.newSceneObject(
		imageFile, x, y, w, h, function(event)
		if event.phase == "ended" then
			func()
		end
		return true
	end
	)
end

-----------------------------------------------------------------------------------------

function ui.newSceneObjectCaption(imageFile, x, y, w, h, caption)
	if type(caption) == "string" then
		caption = { text = caption }
	end
	return ui.newSceneObjectAndDo(
		imageFile, x, y, w, h, function()
			local game = require("api.game")
			game.hud.showCaption(caption)
		end
	)
end

-----------------------------------------------------------------------------------------

function ui.newSceneObjectInfo(imageFile, x, y, w, h, caption)
	return ui.newSceneObjectAndDo(
		imageFile, x, y, w, h, function()
			local game = require("api.game")
			game.hud.showInfoCaption(caption)
		end
	)
end

-----------------------------------------------------------------------------------------

function ui.newSceneObjectAndGo(imageFile, x, y, w, h, scene, effect)
	return ui.newSceneObject(
		imageFile, x, y, w, h, function(event)
		if event.phase == "ended" then
			local game = require("api.game")
			game.scenes.gotoGameScene(scene, effect)
		end
		return true
	end
	)
end

-----------------------------------------------------------------------------------------

function ui.newSceneItem(imageFile, x, y, w, h, itemName, callback)
	local game = require("api.game")
	if not game.inventory.hasPickedUpItem(itemName) then
		local object
		
		local function onObjectTouch()
			object:removeSelf()
			game.inventory.openAndPickUp(itemName)
			
			if callback then
				callback()
			end
		end
		
		object = ui.newSceneObjectAndDo(
			imageFile, x, y, w, h, onObjectTouch
		)
		return object
	end
end

-----------------------------------------------------------------------------------------

function ui.newRect(x, y, w, h, color, touch)
	local rect = display.newRect(x, y, w, h)
	rect.alpha = 1
	if color then
		rect:setFillColor(color[1], color[2], color[3])
		if #color == 4 then
			rect.alpha = color[4]
		end
	end
	rect.anchorX, rect.anchorY = 0, 0
	rect.x, rect.y = x, y
	if touch then
		rect.isHitTestable = true
		rect:addEventListener("touch", touch)
	end
	return rect
end

-----------------------------------------------------------------------------------------

local function deg2rad(v)
	return v * math.pi / 180.0
end

local function rad2deg(v) 
	return v * 180.0 / math.pi
end

local MAX_ARC_STEPS = math.floor((720 / 360) * 2 * math.pi)

local function getPointOnCircle(centerX, centerY, radius, angle)
	return {
		x = centerX + math.cos(angle) * radius,
		y = centerY + math.sin(angle) * radius
	}
end

function ui.newArc(centerX, centerY, radius, startAngle, arcAngle)
	startAngle = deg2rad(startAngle)
	arcAngle = deg2rad(arcAngle)
	
	local segment = nil
	local startPoint = getPointOnCircle(centerX, centerY, radius, startAngle)
	local steps = math.floor(MAX_ARC_STEPS * arcAngle)
	local angleStep = arcAngle / steps
	
	for i = 1, steps, 1 do
		local angle = startAngle + i * angleStep
		local point = getPointOnCircle(centerX, centerY, radius, angle)
		
		if segment then
			segment:append(point.x, point.y)
		else
			segment = display.newLine(startPoint.x, startPoint.y, point.x, point.y)
		end
	end
	
	if not segment then
		segment = display.newLine(startPoint.x, startPoint.y, startPoint.x, startPoint.y)
	end
	
	return segment
end

-----------------------------------------------------------------------------------------

function ui.newRectFullScreen(color, touch)
	return ui.newRect(0, 0, display.contentWidth, display.contentHeight, color, touch)
end

-----------------------------------------------------------------------------------------

function ui.removeSelf(object)
	if object then
		object:removeSelf()
	end
	return nil
end

-----------------------------------------------------------------------------------------

function ui.cancelTransition(t)
	if t then
		transition.cancel(t)
	end
	return nil
end

-----------------------------------------------------------------------------------------

function ui.cancelTimer(t)
	if t then
		timer.cancel(t)
	end
	return nil
end

-----------------------------------------------------------------------------------------

function ui.insertChild(group, child)
	if child then
		group:insert(child)
	end
	return child
end

function ui.clearChildren(group)
	if group then
		for i=group.numChildren,1,-1 do
			group[i]:removeSelf()
			group[i] = nil
		end
	end
end

-----------------------------------------------------------------------------------------

function ui.newAnimation(images, x, y, w, h)
	local movieclip = require("lib.movieclip")
	local animation = movieclip.newAnimation(images, w, h)
	animation.x, animation.y = x, y
	return animation
end

-----------------------------------------------------------------------------------------

function ui.newFadeOutIn(options)
	options = options or {}
	local fadeOutTime = options.fadeOutTime or options.time or 500
	local fadeInTime = options.fadeInTime or options.time or 500
	local fadeInDelay = options.fadeInDelay or 0
	local onFadeOut = options.onFadeOut
	local onComplete = options.onComplete
	
	local object = ui.newRectFullScreen({0,0,0}, function() return true end)
	object.alpha = 0
	
	object._base_removeSelf = object.removeSelf
	
	function object:removeSelf()
		if self.fadeInTransition then
			transition.cancel(self.fadeInTransition)
			self.fadeInTransition = nil
		end
		
		if self.fadeOutTransition then
			transition.cancel(self.fadeOutTransition)
			self.fadeOutTransition = nil
		end
		
		self.fadeInDelayTimer = ui.cancelTimer(self.fadeInDelayTimer)
		
		self:_base_removeSelf()
	end
	
	object.fadeOutTransition = transition.to(object, { alpha = 1, time = fadeOutTime, onComplete = function()
		object.fadeOutTransition = nil
		if onFadeOut then
			onFadeOut()
		end
		object.fadeInDelayTimer = timer.performWithDelay(fadeInDelay, function()
			object.fadeInDelayTimer = nil
			object.fadeInTransition = transition.to(object, { alpha = 0, time = fadeInTime, onComplete = function()
				object.fadeInTransition = nil
				object:removeSelf()
				if onComplete then
					onComplete()
				end
			end})
		end)
	end})
	
	return object
end

-----------------------------------------------------------------------------------------

function ui.newTextBox(options)
	local fontbox = require("lib.fontbox")
	local textBox = fontbox.newTextBox(options)
	
	function textBox:setText(text)
		textBox:changeProperty({text = text})
	end
	
	return textBox
end

-----------------------------------------------------------------------------------------

function ui.newTapToContinueText(startHidden, size)
	local object = game.ui.newTextBox({
		set_name="Standard", text=i18n._"TapToContinue", color={1,0,0}, 
		x = 0, y = display.contentHeight - 60, size = size or 18, width = display.contentWidth, height = 200, align = "center"
	})
	if startHidden then
		object.alpha = 0
	end
	
	function object:show()
		ui.trackTransition(transition.to(object, { alpha = 1, time = 600 }))
	end
	return object
end

-----------------------------------------------------------------------------------------

local CaptionFadeTime = 200
local CaptionTextScrollLetterTime = 60
local CaptionTextScrollWordTime = 150

-----------------------------------------------------------------------------------------

function ui.newCaption(options)
	if type(options) == "string" then
		options = { text = options }
	end
	
	local who = options.who
	local text = options.text
	local delay = options.delay or 0
	local scroll = ((options.scrollType ~= nil) or (options.who ~= nil)) and (not device.isWinPhone) and (not options.noScroll)
	local scrollType = options.scrollType or "word"
	local onFullText = options.onFullText
	local color = options.color or {1,1,1}
	
	local caption = display.newGroup()
	caption.anchorChildren = true
	caption.anchorX, caption.anchorY = 0,0
	caption.x, caption.y = options.x or 0, options.y or 0
	caption.alpha = 0
	
	--[[local background = display.newImageRect("assets/images/hud/dialog_bar.png", display.contentWidth, 50)
	background.anchorX, background.anchorY = 0,0
	background.x, background.y = 0, 15]]
  local background = ui.newRect(0, 0, device.contentWidth, 80, { 0, 0, 0, 0.85 })
	caption:insert(background)
	
	local textLeft = 10
	local textWidth = display.contentWidth - 20
	local textAlign = "center"
	
	if who then
		local whoImage = display.newImageRect("assets/images/hud/caption/" .. who .. ".jpg", 54, 58)
		whoImage.anchorX, whoImage.anchorY = 0,0
		whoImage.x, whoImage.y = 10, 11
		caption:insert(whoImage)
		
		textLeft = 10 + 54 + 5
		textWidth = display.contentWidth - 20 - 54 - 5
		textAlign = "left"
	end
	
	local initialText = (scroll and "") or text

	local textBox = ui.newTextBox({
		set_name="Standard", text = text, color=color, 
		x=textLeft, y = 18, size = 16, width = textWidth, height = 80, 
		align=textAlign--, line_height=1.2
	})
	
	local lines = textBox.lines
	local lineCount = #lines
	
	if lineCount <= 1 then
		textBox.y = 31
	elseif lineCount == 2 then
		textBox.y = 25
	end
	
	textBox:changeProperty({ text = initialText })
	caption:insert(textBox)
	
	local function getScrollDelay()
		if scrollType == "word" then
			return CaptionTextScrollWordTime
		else
			return CaptionTextScrollLetterTime
		end
	end
	
	local function stopTextScroll()
		if caption.textScrollTimer then
			timer.cancel(caption.textScrollTimer)
			caption.textScrollTimer = nil
		end
	end
	
	local function startTextScroll()
		local currentPos = 1
		caption.textScrollTimer = timer.performWithDelay(getScrollDelay(), function()
			if caption.textScrollTimer and textBox then
				if scrollType == "letter" then
					textBox:changeProperty({ text = string.sub(text, 1, currentPos) })
					currentPos = currentPos + 1
				else
					local s, e = string.find(text, "%s+", currentPos)
					if s == nil then
						e = string.len(text)
					end
					textBox:changeProperty({ text = string.sub(text, 1, e) })
					currentPos = e + 1
				end
				
				if currentPos > string.len(text) then
					timer.cancel(caption.textScrollTimer)
					caption.textScrollTimer = nil
					
					if type(onFullText) == 'function' then
						onFullText()
					end
				end
			end
		end, 0)
	end
	
	function caption:getTimeToShow()
		local result = CaptionFadeTime
		if scroll then
			if scrollType == "letter" then
				result = result + (CaptionTextScrollLetterTime + 20) * string.len(text)
			else
				result = result + (CaptionTextScrollWordTime + 40) * string.wordCount(text)
			end
		end		
		result = result + delay
		return result
	end
	
	function caption:show()
		self.delayTimer = timer.performWithDelay(delay, function ()
			self.delayTimer = nil
				self.showTransition = transition.to(self, { time=CaptionFadeTime, alpha=1, onComplete=function()
					self.showTransition = nil
					if scroll then
						startTextScroll()
					end
			end})
		end)
	end
	
	function caption:hideAndDestroy()
		stopTextScroll()
		self.hideTransition = transition.to(self, { 
			time=CaptionFadeTime, alpha=0, onComplete=function()
				self.hideTransition = nil
				caption:removeSelf()
			end
		})
	end
	
	function caption:isShowing()
		return self.delayTimer ~= nil or self.showTransition ~= nil
	end
	
	function caption:isScrollingText()
		return self.textScrollTimer ~= nil
	end
	
	function caption:setFullText()
		stopTextScroll()
		textBox:changeProperty({ text = text })
		
		if type(onFullText) == 'function' then
			onFullText()
		end
	end
	
	caption._base_removeSelf = caption.removeSelf
	
	function caption:removeSelf()
		stopTextScroll()
		textBox:delete()
		textBox = nil
		
		self.delayTimer = ui.cancelTimer(self.delayTimer)
		self.showTransition = ui.cancelTransition(self.showTransition)
		self.hideTransition = ui.cancelTransition(self.hideTransition)
		
		self:_base_removeSelf()
	end
	
	return caption
end

-----------------------------------------------------------------------------------------

function ui.newFullSnapshot()
	local snapshot = display.newSnapshot(device.contentWidth, device.contentHeight)
	snapshot.anchorX, snapshot.anchorY = 0, 0
	snapshot.x, snapshot.y = device.x(0), device.y(0)
	
	function snapshot:addChild(c)
		snapshot.group:insert(c)
		snapshot:invalidate()
		return c
	end
	
	function snapshot:correctX(x)
		return x - snapshot.width / 2
	end
	
	function snapshot:correctY(y)
		return y - snapshot.height / 2
	end
	
	return snapshot
end

-----------------------------------------------------------------------------------------

return ui