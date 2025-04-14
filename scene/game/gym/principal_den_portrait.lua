-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

--------------------------------------------------------------------------------------------------

local RowCount = 3
local ColumnCount = 3
local StartX = 149
local StartY = 45
local TileWidth = 95
local TileHeight = 95

--------------------------------------------------------------------------------------------------

local TileStateOn = 1
local TileStateOff = 0

--------------------------------------------------------------------------------------------------

local tiles = {}

--------------------------------------------------------------------------------------------------

local animating = false

--------------------------------------------------------------------------------------------------

local function onResetTouch()
	animating = true
	
	for i = 1,RowCount do
		for j = 1,ColumnCount do
			scene:updateTileState(i, j, TileStateOff)
		end
	end
	
	scene:newTimer(300, function()
		animating = false
	end)
end

--------------------------------------------------------------------------------------------------

local function onTileTouch(i, j)
	if game.puzzles.hasFinished("principal_den_portrait") or animating then
		return
	end
	
	animating = true
	
	scene:playSound("button")
	
	scene:invertTileState(i, j)
	
	scene:newTimer(300, function()
		scene:invertTileState(i - 1, j)
		scene:invertTileState(i + 1, j)
		scene:invertTileState(i, j - 1)
		scene:invertTileState(i, j + 1)
		
		scene:newTimer(300, function()
			if scene:checkSolution() then
				game.puzzles.finish("principal_den_portrait")
				
				scene:playSound("thunder")
				
				local overlay = scene:addToScene(game.ui.newBackground("assets/images/game/gym/principal_den/portrait_puzzle/portrait_solved.jpg"))				
				scene:animateThunder(overlay, 1, 6)
				
				scene:newTimer(2100, function()
					game.scenes.gotoGameScene("game.gym.principal_den")
				end)
			end
			
			animating = false
		end)
	end)
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
	
	self:newTransition(overlay, { alpha = alpha, time = math.random(100, 200), onComplete = function()
		scene:animateThunder(overlay, index + 1, maxFlickers)
	end})
end

-----------------------------------------------------------------------------------------

function scene:invertTileState(i, j)
	if i < 1 or i > RowCount or j < 1 or j > ColumnCount then
		return
	end
	
	local newState = TileStateOn
	if scene:isTileOn(i, j) then
		newState = TileStateOff
	end
	
	scene:updateTileState(i, j, newState)
end

-----------------------------------------------------------------------------------------

function scene:updateTileState(i, j, state)
	if i < 1 or i > RowCount or j < 1 or j > ColumnCount then
		return
	end
	
	local alpha = 0
	if state == TileStateOn then
		alpha = 1
	end
	
	scene:setTileState(i, j, state)
	scene:newTransition(tiles[i][j], { alpha = alpha, time = 300 })
end

-----------------------------------------------------------------------------------------

function scene:isTileOn(i, j)
	return scene:getTileState(i, j) == TileStateOn
end

-----------------------------------------------------------------------------------------

function scene:getTileState(i, j)
	game.data.principal_den_portrait_tiles = game.data.principal_den_portrait_tiles or {}	
	return game.data.principal_den_portrait_tiles[i .. "," .. j] or TileStateOff
end

-----------------------------------------------------------------------------------------

function scene:setTileState(i, j, state)
	game.data.principal_den_portrait_tiles = game.data.principal_den_portrait_tiles or {}
	game.data.principal_den_portrait_tiles[i .. "," .. j] = state
	game.markAsChanged()
end

-----------------------------------------------------------------------------------------

function scene:checkSolution()	
	for i = 1,RowCount do
		for j = 1,ColumnCount do
			if not scene:isTileOn(i, j) then
				return false
			end
		end
	end
	return true
end

--------------------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/principal_den/portrait_puzzle/bg_portrait_puzzle.jpg"))
	
	tiles = {}
	animating = false
	
	for i = 1,RowCount do
		local row = {}
		table.insert(tiles, row)
		
		for j = 1,ColumnCount do
			local image = self:addToScene(game.ui.newImage("assets/images/game/gym/principal_den/portrait_puzzle/dead_" .. i .. "_" .. j .. ".jpg",
				device.x(StartX + (j - 1) * TileWidth), device.y(StartY + (i - 1) * TileHeight), TileWidth, TileHeight))
			
			if not scene:isTileOn(i, j) then
				image.alpha = 0
			end
			
			table.insert(row, image)
		end
	end
	
	for i = 1,RowCount do
		for j = 1,ColumnCount do
			self:addToScene(game.ui.newTouchRegionTap(device.x(StartX + (j - 1) * TileWidth), device.y(StartY + (i - 1) * TileHeight), TileWidth, TileHeight, function ()
				onTileTouch(i, j)
			end))
		end
	end
	
	self:addToHUD(game.ui.newButton(display.contentWidth - 45 - 15, 140, {
		defaultFile = "assets/images/hud/buttons/reset_button.png",
		overFile = "assets/images/hud/buttons/reset_button_over.png",
		onRelease = onResetTouch,
		width = 45, height = 45
	}))
		
	self:addToHUD(game.ui.newBackButton("game.gym.principal_den"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("block", "assets/sounds/game/gym/block_move.mp3")
		self:loadSound("locker_open", "assets/sounds/game/gym/locker_open.mp3")
		self:loadSound("locker_unlock", "assets/sounds/game/gym/locker_unlock.mp3")
		self:loadSound("button", "assets/sounds/game/general/click.mp3")
		self:loadSound("thunder", "assets/sounds/game/gym/thunder.mp3")
	elseif event.phase == "did" then		
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene

