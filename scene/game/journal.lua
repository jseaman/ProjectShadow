-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local function onBackButtonRelease()
	game.stage.playBackSound()
	game.go()
	return true
end

-----------------------------------------------------------------------------------------

function scene:getHUDFadeIn()
	return 600
end

-----------------------------------------------------------------------------------------

local function onLeftButtonRelease()
	scene:setJournalEntry(scene.journalIndex - 1)
	scene:playSound("page")
end

local function onRightButtonRelease()
	scene:setJournalEntry(scene.journalIndex + 1)
	scene:playSound("page")
end

-----------------------------------------------------------------------------------------

local cutouts =
{
	["title"] = 
	{
		name = "title",
		x = 68, y = 21, w = 431, h = 67,
		caption = "Journal.Lou.Cutout.Title"
	},
	["popenoe"] = 
	{
		name = "popenoe",
		x = 70, y = 78, w = 202, h = 269,
		caption = "Journal.Lou.Cutout.Popenoe"
	},
	["missing_children"] = 
	{
		name = "missing_children",
		x = 230, y = 70, w = 275, h = 97,
		caption = "Journal.Lou.Cutout.MissingChildren"
	},
	["miranda_will"] = 
	{
		name = "miranda_will",
		x = 231, y = 157, w = 268, h = 98,
		caption = "Journal.Lou.Cutout.MirandaWill"
	},
	["lou"] = 
	{
		name = "lou",
		x = 255, y = 230, w = 240, h = 118,
		caption = "Journal.Lou.Cutout.Lou"
	},
}

-----------------------------------------------------------------------------------------

function scene:addNewsCutout(entryObject, cutout)
	return game.ui.insertChild(entryObject, 
					game.ui.newSceneObjectInfo("assets/images/game/journal/entries/newspaper/newspaper_piece_" .. cutout.name .. ".png", 
						device.x(cutout.x), device.y(cutout.y), cutout.w, cutout.h, i18n._(cutout.caption)))
end

function scene:addNewsCutouts(entryObject)
	for name, cutout in pairs(cutouts) do
		if game.events.isTriggered("newspaper." .. name) then
			local cutoutObject = scene:addNewsCutout(entryObject, cutout)

			if scene.params and scene.params.entryName == "Cutouts" and scene.params.cutoutName == name then
				scene.params.cutoutName = nil
				cutoutObject.alpha = 0
				scene:newTimer(1000, function()
					scene:playSound("paste")
					scene:newTransition(cutoutObject, { time = 200, alpha = 1 })
					scene:newTimer(700, function()
						game.hud.showInfoCaption(i18n._(cutout.caption))
					end)
				end)
			end
		end
	end
end

function scene:getTextFont()
	if self.player == "popenoe" then
		return "Cursive"
	else
		return "Standard"
	end
end

function scene:getTextColor()
	if self.player == "miranda" then
		--return {1,0.08,0.6}
		return {0.6,0.17,0.17}
	elseif self.player == "popenoe" then
		return {0.2,0.2,0.2}
	else
		return {0,0,0.43}
	end
end

function scene:setJournalEntry(index)
	if self.navigationEnabled then
		local entryCount = #self.journalEntries

		if index > 0 and index <= entryCount then
			local entryName = self.journalEntries[index]
			local entry = game.journal.findEntry(entryName)
			
			local entryObject = game.ui.insertChild(self.entryGroup, game.ui.newGroup())
			entryObject.alpha = 0
			
			if entryName == "Cutouts" then
				self:addNewsCutouts(entryObject)
			elseif entry.image1 or entry.image2 then
				if entry.image1 then
					game.ui.insertChild(entryObject, 
						game.ui.newImage("assets/images/game/journal/entries/" .. entry.image1.fileName, device.x(entry.image1.x), device.y(entry.image1.y), entry.image1.w, entry.image1.h))
				end
				if entry.image2 then
					game.ui.insertChild(entryObject, 
						game.ui.newImage("assets/images/game/journal/entries/" .. entry.image2.fileName, device.x(entry.image2.x), device.y(entry.image2.y), entry.image2.w, entry.image2.h))
				end
			elseif entry.imageFile then
				game.ui.insertChild(entryObject, 
					game.ui.newImage("assets/images/game/journal/entries/" .. entry.imageFile, device.x(entry.x or 105), device.y(entry.y or 30), entry.w or 350, entry.h or 300))
			end
			
			if entry.text1 then
				game.ui.insertChild(entryObject, game.ui.newTextBox({
						text = entry.text1, set_name = scene:getTextFont(), size = 14, align = "left", color = scene:getTextColor(),
						x = device.x(85), y = device.y(70), width = 190, height = 300}))
			end
			if entry.text2 then
				game.ui.insertChild(entryObject, game.ui.newTextBox({
						text = entry.text2, set_name = scene:getTextFont(), size = 14, align = "left", color = scene:getTextColor(),
						x = device.x(307), y = device.y(75), width = 190, height = 300}))
			end
					
			self.journalIndex = index
			self.navigationEnabled = false			

			if self.currentEntry then
				local oldEntry = self.currentEntry
				self:newTransition(oldEntry, {time = 300, alpha = 0, onComplete=function() 
					game.ui.removeSelf(oldEntry)
					self.navigationEnabled = true
				end})
				self:newTransition(entryObject, {time = 300, alpha = 1})
			else
				entryObject.alpha = 1
				self.navigationEnabled = true
			end
			
			self.currentEntry = entryObject
		else
			self.journalIndex = 0
		end
		
		if #self.journalEntries > 1 then
			self.leftButton.isVisible = index > 1
			self.leftButtonOff.isVisible = not self.leftButton.isVisible
			self.rightButton.isVisible = index < entryCount
			self.rightButtonOff.isVisible = not self.rightButton.isVisible
		end
	end
end

-----------------------------------------------------------------------------------------

local NavButtonHeight = 55
local NavButtonWidth = 55
local NavButtonTop = display.contentHeight/2 - NavButtonHeight/2

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	assert(event.params.player)
	
	self.player = event.params.player
	
	self:addToScene(game.ui.newBackground("assets/images/game/journal/journal_" .. self.player .. ".jpg"))
	
	self.entryGroup = self:addToScene(game.ui.newGroup())
	
	self.leftButton = self:addToHUD(game.ui.newButton(10, NavButtonTop, {
		defaultFile = "assets/images/game/journal/left_button.png", --overFile = "assets/images/hud/inventory/items_left_over.png",
		width = NavButtonWidth, height = NavButtonHeight, onRelease = onLeftButtonRelease
	}))
	self.leftButton.isVisible = false
	self.leftButtonOff = self:addToHUD(game.ui.newButton(10, NavButtonTop, {
		defaultFile = "assets/images/game/journal/left_button_off.png", width = NavButtonWidth, height = NavButtonHeight, 
	}))
	self.leftButtonOff.alpha = 0.6

	self.rightButton = self:addToHUD(game.ui.newButton(display.contentWidth - NavButtonWidth - 10, NavButtonTop, {
		defaultFile = "assets/images/game/journal/right_button.png", --overFile = "assets/images/hud/inventory/items_right_over.png",
		width = NavButtonWidth, height = NavButtonHeight, onRelease = onRightButtonRelease
	}))
	self.rightButton.isVisible = false
	self.rightButtonOff = self:addToHUD(game.ui.newButton(display.contentWidth - NavButtonWidth - 10, NavButtonTop, {
		defaultFile = "assets/images/game/journal/right_button_off.png", width = NavButtonWidth, height = NavButtonHeight, 
	}))
	self.rightButtonOff.alpha = 0.6
	
	self:addToHUD(game.ui.newButton(display.contentWidth - 52 - 10, display.contentHeight - 52 - 8, {
		defaultFile = "assets/images/hud/buttons/back_button.png", overFile = "assets/images/hud/buttons/back_button_over.png",
		width = 52, height = 52, onRelease = onBackButtonRelease
	}))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		game.hud.hide()
		
		self:loadSound("book", "assets/sounds/game/journal/paper5.mp3")
		self:loadSound("page", "assets/sounds/game/journal/paper.mp3")	
		self:loadSound("paste", "assets/sounds/game/gym/paste_paper.mp3")
		self:playSound("book")
		
		self.navigationEnabled = true
		self.params = event.params
		self.currentEntry = game.ui.removeSelf(self.currentEntry)
		self.journalEntries = game.journal.getEntriesFor(self.player)
		
		if #self.journalEntries <= 1 then
			self.leftButton.isVisible = false
			self.leftButtonOff.isVisible = false
			self.rightButton.isVisible = false
			self.rightButtonOff.isVisible = false
		end
		
		local entryIndex = #self.journalEntries
		
		if self.player == "popenoe" and not game.events.isTriggered("popenoe_journal_first_time") then
			entryIndex = 1
			game.events.trigger("popenoe_journal_first_time")
		end
		
		if event.params and event.params.entryName then
			for i, entry in ipairs(self.journalEntries) do
				if entry == event.params.entryName then
					entryIndex = i
					break
				end
			end
		end
		self:setJournalEntry(entryIndex)
		
		if self.player == "popenoe" then
			game.achievements.unlock("check_popenoe_journal")
		end
	elseif event.phase == "did" then		
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
	elseif event.phase == "did" then
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene