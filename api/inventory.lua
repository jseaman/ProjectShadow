-----------------------------------------------------------------------------------------

local display = require("display")
local widget = require("widget")
local transition = require("transition")
local game = require("api.game")

-----------------------------------------------------------------------------------------

local inventory = {}

-----------------------------------------------------------------------------------------

local ItemButtonWidth = 52
local ItemButtonHeight = 52
local ItemBoxWidth = 52
local ItemBoxHeight = 48
local ItemNavWidth = 21
local ItemNavHeight = 48
local ItemButtonTop = display.contentHeight - ItemButtonHeight - 6
local ItemBarOpenTop = ItemButtonTop + 11
local ItemBarClosedTop = display.contentHeight + 10
local ItemBarMaxWidth = math.max(display.contentWidth - ItemButtonWidth*2 - 10*2 - 20*2, 5 * ItemBoxWidth + ItemNavWidth*2)
local ItemBarNumItems = math.floor((ItemBarMaxWidth - ItemNavWidth*2) / ItemBoxWidth)
local ItemBarWidth = ItemBarNumItems * ItemBoxWidth + ItemNavWidth*2
local ItemBarHeight = 52
local ItemsStartLeft = ItemNavWidth
local OpenDelay = 200
local CloseDelay = 200

-----------------------------------------------------------------------------------------

local function refreshButtons()
	if inventory._button then
		inventory._button.buttonClosed.isVisible = not inventory.isOpen()
		inventory._button.buttonOpened.isVisible = inventory.isOpen()
	end
	
	local page = inventory.getPage()
	local pages = inventory.getPageCount()
	
	if inventory._leftButton then
		inventory._leftButton.isVisible = page > 1
	end
	if inventory._leftButtonOff then
		inventory._leftButtonOff.isVisible = page <= 1
	end
	
	if inventory._rightButton then
		inventory._rightButton.isVisible = page < pages
	end
	if inventory._rightButtonOff then
		inventory._rightButtonOff.isVisible = page >= pages
	end
end

-----------------------------------------------------------------------------------------

local function onLeftButtonRelease()
	inventory.setPage(inventory.getPage() - 1)
	game.stage.play(game.stage.itemsNextPageSound)
end

local function onRightButtonRelease()
	inventory.setPage(inventory.getPage() + 1)
	game.stage.play(game.stage.itemsNextPageSound)
end

-----------------------------------------------------------------------------------------

function inventory.getFirstItemLeft()
	return display.contentWidth/2 - ItemBarWidth/2 + ItemsStartLeft
end

function inventory.getItemBarTop()
	return ItemBarOpenTop
end

function inventory.getItemBoxWidth()
	return ItemBoxWidth
end

-----------------------------------------------------------------------------------------

function inventory.open()
	if not inventory._group then
		local group = display.newGroup()
		--group.anchorChildren = true
		--group.anchorX, group.anchorY = 0,0
		group.x, group.y = display.contentWidth/2 - ItemBarWidth/2, ItemBarClosedTop
		
		for i = 1,ItemBarNumItems do
			group:insert(game.ui.newHardImage("assets/images/hud/inventory/items_space.jpg", ItemsStartLeft + ItemBoxWidth * (i - 1), 2, ItemBoxWidth, ItemBoxHeight))
		end
		
		local itemGroup = game.ui.insertChild(group, display.newGroup())
		--itemGroup.anchorChildren = true
		--itemGroup.anchorX, itemGroup.anchorY = 0, 0
		itemGroup.x, itemGroup.y = ItemsStartLeft, 2
		
		local leftButton = game.ui.insertChild(group, game.ui.newButton(2, 2, {
			defaultFile = "assets/images/hud/inventory/items_left.png", --overFile = "assets/images/hud/inventory/items_left_over.png",
			width = ItemNavWidth, height = ItemNavHeight, onRelease = onLeftButtonRelease
		}))
		leftButton.isVisible = false
		local leftButtonOff = game.ui.insertChild(group, game.ui.newButton(2, 2, {
			defaultFile = "assets/images/hud/inventory/items_left_off.png", width = ItemNavWidth, height = ItemNavHeight, 
		}))
		
		local rightButton = game.ui.insertChild(group, game.ui.newButton(ItemBarWidth - ItemNavWidth - 2, 2, {
			defaultFile = "assets/images/hud/inventory/items_right.png", --overFile = "assets/images/hud/inventory/items_right_over.png",
			width = ItemNavWidth, height = ItemNavHeight, onRelease = onRightButtonRelease
		}))
		rightButton.isVisible = false
		local rightButtonOff = game.ui.insertChild(group, game.ui.newButton(ItemBarWidth - ItemNavWidth - 2, 2, {
			defaultFile = "assets/images/hud/inventory/items_right_off.png", width = ItemNavWidth, height = ItemNavHeight, 
		}))
				
		inventory._group = group
		inventory._itemGroup = itemGroup
		inventory._leftButton = leftButton
		inventory._leftButtonOff = leftButtonOff
		inventory._rightButton = rightButton
		inventory._rightButtonOff = rightButtonOff
	end
	
	inventory.refreshItems()
	
	inventory._group.isVisible = true
	game.util.newTransition("inventory", inventory._group, { time=OpenDelay, y=ItemBarOpenTop, transition = easing.outSine })
	
	refreshButtons()
end

-----------------------------------------------------------------------------------------

local function onInventoryClosed()
	inventory._group.isVisible = false
	refreshButtons()
	
	local currentScene = game.scenes.getCurrentScene()
	if currentScene and currentScene.onInventoryClosed then
		currentScene:onInventoryClosed()
	end
end

function inventory.close()
	inventory.clearSelection()
	
	game.util.cancelObjects("inventory")
	game.util.cancelObjects("inventory.lastItem")
	game.util.cancelObjects("inventory.oracle")
	inventory._newEntryGroup = game.ui.removeSelf(inventory._newEntryGroup)
		
	if inventory._group then
		game.ui.trackTransition(transition.to(inventory._group, { time=CloseDelay, y=ItemBarClosedTop, transition = easing.outSine, onComplete=onInventoryClosed }))
	end
		
	local currentScene = game.scenes.getCurrentScene()
	if currentScene and currentScene.onInventoryClosing then
		currentScene:onInventoryClosing()
	end
end

-----------------------------------------------------------------------------------------

function inventory.show()
	if not inventory._button then
		local group = display.newGroup()
		group.alpha = 0
		group.anchorX, group.anchorY = 0, 0
		group.anchorChildren = true
		group.x, group.y = 10, ItemButtonTop
			
		local buttonOpened = widget.newButton({
			defaultFile = "assets/images/hud/buttons/item_button_open.png",
			--overFile = "assets/images/hud/items_icon_over.png",
			width = ItemButtonWidth, height = ItemButtonHeight,
			onRelease = function()
				game.stage.play(game.stage.itemsOpenSound)
				inventory.toggle()
			end
		})
		buttonOpened.anchorX, buttonOpened.anchorY = 0,0
		buttonOpened.x, buttonOpened.y = 0, 0
		group:insert(buttonOpened)
		
		local buttonClosed = widget.newButton({
			defaultFile = "assets/images/hud/buttons/item_button.png",
			--overFile = "assets/images/hud/items_icon_over.png",
			width = ItemButtonWidth, height = ItemButtonHeight,
			onRelease = function()
				game.stage.play(game.stage.itemsOpenSound)
				inventory.toggle()
			end
		})
		buttonClosed.anchorX, buttonClosed.anchorY = 0,0
		buttonClosed.x, buttonClosed.y = 0, 0
		group:insert(buttonClosed)
		
		inventory._button = group
		inventory._button.buttonClosed = buttonClosed
		inventory._button.buttonOpened = buttonOpened
	end
	
	refreshButtons()
	
	if inventory._button.alpha == 0 then
		inventory.showTransition = transition.to(inventory._button, { time=850, alpha = 1 })
	end
end

-----------------------------------------------------------------------------------------

function inventory.hide()
	inventory.showTransition = game.ui.cancelTransition(inventory.showTransition)
	inventory.close()
	if inventory._button then
		inventory._button.alpha = 0
	end
end

-----------------------------------------------------------------------------------------

function inventory.isOpen()
	return inventory._group ~= nil and inventory._group.isVisible
end

-----------------------------------------------------------------------------------------

function inventory.toggle()
	if inventory.isOpen() then
		inventory.close()
	else
		inventory.open()
	end
end

-----------------------------------------------------------------------------------------

function inventory.getItems()
	return table.shallow_copy(game.state.inventory or {})
end

-----------------------------------------------------------------------------------------

function inventory.hasItem(itemName)
	if game.data.inventory then
		local existingItem
		for existingItem in list_iter(game.data.inventory) do
			if itemName == existingItem then
				return true
			end
		end
	end
	return false
end

-----------------------------------------------------------------------------------------

function inventory.hasPickedUpItem(name)
	return game.state.isSet("item.pickedUp." .. name)
end

-----------------------------------------------------------------------------------------

function inventory.hasDiscardedItem(name)
	return game.state.isSet("item.discarded." .. name)
end

-----------------------------------------------------------------------------------------

function inventory.openAndPickUp(itemName)
	if not inventory.isOpen() then
		inventory.open()
		timer.performWithDelay(OpenDelay + 150, function() inventory.pickUp(itemName) end)
	else
		inventory.pickUp(itemName)
	end
end

-----------------------------------------------------------------------------------------

local function getPageForItem(item)
	if type(item) == "string" then
		item = inventory.findItemIndex(item)
	end
	if item > 0 then
		return math.ceil(item / ItemBarNumItems)
	else
		return 1
	end
end

-----------------------------------------------------------------------------------------

function inventory.pickUp(itemName)
	local index = inventory.addItem(itemName)
	if index > 0 then
		game.stage.play(game.stage.itemPickupSound)
		
		inventory._lastAddedItem = itemName		
		
		local page = getPageForItem(index)
		if inventory.getPage() ~= page then
			inventory.setPage(page)
		else
			inventory.refreshItems()
		end
		
		inventory.showItemCaption(itemName)
	end
end

function inventory.addItem(itemName)
	game.data.inventory = game.data.inventory or {}
	
	if not inventory.hasItem(itemName) then
		local index = #game.data.inventory + 1
		if itemName == "Journal" then
			index = 1
		elseif itemName == "Oracle" then
			if inventory.hasItem("Journal") then
				index = 2
			else
				index = 1
			end
		end
		table.insert(game.data.inventory, index, itemName)
		game.markAsChanged()
		
		game.state.set("item.pickedUp." .. itemName)		
		return index
	end
	return 0
end

-----------------------------------------------------------------------------------------

function inventory.discard(itemName)
	local index = inventory.findItemIndex(itemName)
	if index > 0 then
		table.remove(game.data.inventory, index)
		game.state.set("item.discarded." .. itemName)
		game.markAsChanged()

		if inventory.hasSelectedItem(itemName) then
			inventory.clearSelection()
		end
		
		inventory.refreshItems()
	end	
end

-----------------------------------------------------------------------------------------

function inventory.findItemIndex(itemName)
	if game.data.inventory then
		for i, item in ipairs(game.data.inventory) do
			if item == itemName then
				return i
			end
		end
	end
	return 0
end

-----------------------------------------------------------------------------------------

local function showNewJournalEntryNotice()
	if not inventory._newEntryGroup then
		inventory.setPage(1)
		inventory.selectItemWithoutName("Journal")

		local group = game.ui.newGroup()
		group.alpha = 0
		inventory._group:insert(group)

		group:insert(game.ui.newHardImage("assets/images/hud/inventory/new_journal_entry.png", ItemsStartLeft, -46, 124, 46))

		group:insert(game.ui.newTextBox({
			text = i18n._"NewJournalEntry", set_name = "Standard", size = 11, align = "center", color = {1,1,1},
			x = ItemsStartLeft + 7, y = -35, width = 110, height = 20}))

		inventory._newEntryGroup = group

		game.stage.play(game.stage.newJournalEntrySound)

		game.util.newTransition("inventory", inventory._newEntryGroup, {time=600, alpha=1, onComplete=function()
			game.util.newTimer("inventory", 3500, function()
				game.util.newTransition("inventory", inventory._newEntryGroup, {time=500, alpha=0, onComplete=function()
					inventory._newEntryGroup = game.ui.removeSelf(inventory._newEntryGroup)
				end})
			end)
		end})
	end
end

function inventory.onNewJournalEntry()
	if not inventory.isOpen() then
		inventory.open()
		timer.performWithDelay(OpenDelay + 150, showNewJournalEntryNotice)
	else
		showNewJournalEntryNotice()
	end
end

-----------------------------------------------------------------------------------------

function inventory.getSelectedItem()
	return inventory._selectedItem
end

-----------------------------------------------------------------------------------------

function inventory.hasSelection()
	return inventory._selectedItem ~= nil
end

-----------------------------------------------------------------------------------------

function inventory.hasSelectedItem(itemName)
	return inventory._selectedItem and inventory._selectedItem.itemName == itemName
end

-----------------------------------------------------------------------------------------

local function setSelectedItem(item, hideName)
	if item and inventory._selectedItem ~= item then
		game.stage.play(game.stage.itemSelectSound)
	end
	inventory._selectedItem = item
	inventory._selectedItemHideName = hideName
	inventory.refreshSelection()
end

-----------------------------------------------------------------------------------------

local touchEnabled = true

local function onItemTouch(event)
	if event.phase == "ended" and touchEnabled then
		local item = event.target
		
		touchEnabled = false
		
		setSelectedItem(item)
		
		if item.itemName == "Journal" then
			timer.performWithDelay(400, function()
				touchEnabled = true
				game.scenes.gotoJournal()
			end)
		elseif item.itemName == "Oracle" then
			timer.performWithDelay(400, function()
				touchEnabled = true
				game.scenes.gotoHint()				
			end)
		else
			setSelectedItem(item)
			touchEnabled = true
		end
	end
	return true
end

-----------------------------------------------------------------------------------------

function inventory.clearSelection()
	setSelectedItem(nil)
end

-----------------------------------------------------------------------------------------

function inventory.findItemImage(itemName)
	if inventory.isOpen() then
		local itemGroup = inventory._itemGroup
		if itemGroup then		
			for i=itemGroup.numChildren,1,-1 do
				if itemGroup[i].itemName == itemName then
					return itemGroup[i]
				end
			end
		end
	end
	return nil
end

-----------------------------------------------------------------------------------------

local function getValidPage(pageNum)
	local pages = inventory.getPageCount()
	
	if pageNum < 1 then
		pageNum = 1
	elseif pageNum > pages then
		pageNum = pages
	end
	
	return pageNum
end

-----------------------------------------------------------------------------------------

function inventory.getPage()
	local result = game.state.get("inventoryPage", 1)
	local page = getValidPage(result)
	if result ~= page then
		game.state.set("inventoryPage", page)
	end
	return page
end

-----------------------------------------------------------------------------------------

function inventory.setPage(pageNum)
	pageNum = getValidPage(pageNum)
	
	if pageNum ~= inventory.getPage() then
		inventory.clearSelection()
		
		game.state.set("inventoryPage", pageNum)
		
		inventory.refreshItems()
	end
end

-----------------------------------------------------------------------------------------

function inventory.getPageCount()
	if game.data.inventory then
		return math.ceil(#game.data.inventory / ItemBarNumItems)
	else
		return 1
	end
end

-----------------------------------------------------------------------------------------

function inventory.selectItem(itemName)
	local itemImage = inventory.findItemImage(itemName)
	setSelectedItem(itemImage)
end

-----------------------------------------------------------------------------------------

function inventory.selectItemWithoutName(itemName)
	local itemImage = inventory.findItemImage(itemName)
	setSelectedItem(itemImage, true)
end

-----------------------------------------------------------------------------------------

local LastItemHoverDelay = 750

local function refreshLastAddedItem()
	if inventory.isOpen() then
		if inventory._lastAddedItem then
			local lastItem = inventory._lastAddedItem
			local item = inventory.findItemImage(lastItem)
			if item then
				game.util.cancelObjects("inventory.lastItem")
				inventory._lastItemHover.alpha = 0
				inventory._lastItemHover.x, inventory._lastItemHover.y = item.x + (ItemBoxWidth - 1)/2, item.y + ItemBoxHeight/2
				inventory._lastItemHover.xScale = 0.5
				inventory._lastItemHover.yScale = 0.5
				game.util.newTransition("inventory.lastItem", inventory._lastItemHover, { alpha = 0.9, xScale = 1, yScale = 1, time = LastItemHoverDelay, transition = easing.outSine, onComplete=function()
					game.util.newTimer("inventory.lastItem", 1000, function()
						game.util.newTransition("inventory.lastItem", inventory._lastItemHover, { alpha = 0, time = LastItemHoverDelay, transition = easing.outSine })
					end)
				end})
			end
			inventory._lastAddedItem = nil
		else
			--if inventory._lastItemHover.alpha > 0 then
				--game.util.newTransition("inventory", inventory._lastItemHover, { alpha = 0, time = LastItemHoverDelay })
			--end
		end		
	end
end

-----------------------------------------------------------------------------------------

function inventory.showItemCaption(itemName)
	if not inventory._selectedItemCaptionGroup then
			local group = display.newGroup()
			group.x, group.y = 0, ItemBarOpenTop - 11
			
			local background = display.newRoundedRect(0, 0, 130, 14, 6)
			background:setFillColor(0, 0, 0)
			background.alpha = 0.6
			background.anchorX, background.anchorY = 0.5, 0
			background.x, background.y = display.contentWidth / 2, 0
			group:insert(background)
			
			local text = game.ui.insertChild(group, game.ui.newTextBox({
				text = "t", set_name = "Standard", size = 11, align = "center", color = {1,1,1},
				x = 0, y = 0, width = display.contentWidth, height = 20}))					
			
			inventory._selectedItemCaptionGroup = group
			inventory._selectedItemCaptionGroup.background = background
			inventory._selectedItemCaptionGroup.captionText = text			
		end
		
		inventory._selectedItemCaptionGroup.captionText:setText(i18n._("Items." .. itemName))
		inventory._selectedItemCaptionGroup.isVisible = true
end

function inventory.hideItemCaption()
	if inventory._selectedItemCaptionGroup then
		inventory._selectedItemCaptionGroup.background = nil
		inventory._selectedItemCaptionGroup.captionText = nil
		inventory._selectedItemCaptionGroup:removeSelf()
		inventory._selectedItemCaptionGroup = nil
	end
end

-----------------------------------------------------------------------------------------

function inventory.refreshSelection()
	if inventory.hasSelection() and inventory.isOpen() then
		local item = inventory._selectedItem.item
		
		inventory.showItemCaption(item.name)		
		inventory._selectedItemCaptionGroup.isVisible = not inventory._selectedItemHideName
		
		inventory._selectedItemHover.x, inventory._selectedItemHover.y = inventory._selectedItem.x, inventory._selectedItem.y
		inventory._selectedItemHover.isVisible = true
		
		if item.description then
			game.hud.showCaption({
				text = item.description,
				time = 4000
			})
		else
			--game.hud.hideCaption()
		end
		
		refreshLastAddedItem()
	else
		inventory.hideItemCaption()
		
		if inventory._selectedItemHover then
			inventory._selectedItemHover.isVisible = false
		end
		
		--game.hud.hideCaption()
	end
end

-----------------------------------------------------------------------------------------

function inventory.refreshItems()
	local itemGroup = inventory._itemGroup
	if itemGroup then
		game.util.cancelObjects("inventory.oracle")
		game.ui.clearChildren(itemGroup)
		
		inventory._selectedItemHover = display.newImageRect("assets/images/hud/inventory/active.png", ItemBoxWidth - 1, ItemBoxHeight)
		inventory._selectedItemHover.anchorX, inventory._selectedItemHover.anchorY = 0, 0
		inventory._selectedItemHover.isVisible = false
		itemGroup:insert(inventory._selectedItemHover)
		
		inventory._lastItemHover = display.newImageRect("assets/images/hud/inventory/added.png", ItemBoxWidth - 1, ItemBoxHeight)
		inventory._lastItemHover.alpha = 0
		itemGroup:insert(inventory._lastItemHover)
		
		if game.data.inventory then
			local page = inventory.getPage()
			local startIndex = (page - 1) * ItemBarNumItems + 1
			local lastIndex = math.min(startIndex + ItemBarNumItems - 1, #game.data.inventory)
			
			local left = 0
			for i = startIndex, lastIndex do
				local itemName = game.data.inventory[i]
				local item = game.items.find(itemName)
				if item then
					local itemImage = display.newImageRect("assets/images/items/" .. item.imageFile, ItemBoxWidth, ItemBoxHeight)
					itemImage.itemName = itemName
					itemImage.item = item
					itemImage.anchorX, itemImage.anchorY = 0, 0
					itemImage.x, itemImage.y = left, 0
					itemImage:addEventListener("touch", onItemTouch)
					itemGroup:insert(itemImage)
					
					if itemName == "Oracle" then
						local overContainer = display.newContainer(ItemBoxWidth, ItemBoxHeight * game.hints.getPercentReady())
						overContainer.anchorChildren = false
						overContainer.anchorX, overContainer.anchorY = 0, 0
						overContainer.x, overContainer.y = left, 0
						itemGroup:insert(overContainer)
						
						local overImage = display.newImageRect("assets/images/items/hints_icon_on.png", ItemBoxWidth, ItemBoxHeight)
						overContainer:insert(overImage)
						overImage.anchorX, overImage.anchorY = 0, 0
						overImage.x, overImage.y = 0, 0
						
						game.util.newTimer("inventory.oracle", 1000, function()
							overContainer.height = ItemBoxHeight * game.hints.getPercentReady()
							if game.hints.isReady() then
								game.util.cancelObjects("inventory.oracle")
							end
						end, 0)
					end
					
					left = left + ItemBoxWidth
				end
			end
		end
	end
	refreshLastAddedItem()
	refreshButtons()
end

-----------------------------------------------------------------------------------------

return inventory

-----------------------------------------------------------------------------------------