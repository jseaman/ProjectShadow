-----------------------------------------------------------------------------------------

local game = require("api.game")
local widget = require("widget")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local rows = 4
local cols = 4

local imgParts = {}
local selectedImage 

local isAnimating = false

--------------------------------------------------------------------------------------------------

local function onImageRelease(event)
	if isAnimating == false then		
		local target = event.target
	
		if selectedImage == nil then
			selectedImage = target
			selectedImage:setFillColor(34/255, 140/255, 35/255, 1)	
			scene:playSound("button")
		elseif selectedImage == target then
			selectedImage:setFillColor(1)
			selectedImage = nil
			scene:playSound("button")
		else
			selectedImage:setFillColor(1)
			
			isAnimating = true
			
			scene:playSound("tile")
			scene:switchTilePositions(selectedImage.index, target.index)
			
			local prevPos = {x = target.x, y = target.y}
			
			target:toFront()
			selectedImage:toFront()
			
			scene:newTransition(target, { x=selectedImage.x, y=selectedImage.y, time=500 })
			scene:newTransition(selectedImage, { x=prevPos.x, y=prevPos.y, time=500, onComplete=function()
				isAnimating = false
				scene:checkValues()
			end})	
		
			selectedImage = nil
		end
	end	
end

--------------------------------------------------------------------------------------------------

function scene:checkValues(img)
	for index = 1,(cols*rows) do
		local position = scene:getTilePosition(index)
		local correctPos = scene:getCorrectTilePosition(index)
		
		if position.row ~= correctPos.row or position.col ~= correctPos.col then
			return false
		end
	end
	
	game.puzzles.finish("boys_showers_tiles")
	game.events.trigger("girls_hallway.miranda_left2")
	scene:nextScene()
end

--------------------------------------------------------------------------------------------------

function scene:nextScene()
	self:newTimer(500, function()
		self.shakeEffect = game.effects.newShakeEffect({
			group = self.sceneLayer,
			intensity = 3,
			amount = 10,
			onComplete = function()
				self:newTimer(500, function()
					game.scenes.gotoGameScene("game.gym.locker_gates_opening")
				end)
			end
		})
		self.shakeEffect:start()	
		self:playSound("rumble")
	end)
end

--------------------------------------------------------------------------------------------------

function scene:getCorrectTilePosition(index)
	return { row = math.floor((index - 1) / cols) + 1, col = (index - 1) % cols + 1 }
end

--------------------------------------------------------------------------------------------------

function scene:getTilePosition(index)
	game.data.showers_tiles = game.data.showers_tiles or {}	
	return game.data.showers_tiles[index]
end

--------------------------------------------------------------------------------------------------

function scene:setTilePosition(index, col, row)
	game.data.showers_tiles = game.data.showers_tiles or {}	
	game.data.showers_tiles[index] = { col = col, row = row }
	game.markAsChanged()
end

--------------------------------------------------------------------------------------------------

function scene:setTileDefaultPosition(index, col, row)
	if not scene:getTilePosition(index) then
		scene:setTilePosition(index, col, row)
	end
end

-----------------------------------------------------------------------------------------

function scene:switchTilePositions(index1, index2)
	local position1 = scene:getTilePosition(index1)
	local position2 = scene:getTilePosition(index2)
	
	scene:setTilePosition(index1, position2.col, position2.row)
	scene:setTilePosition(index2, position1.col, position1.row)	
end

-----------------------------------------------------------------------------------------

function scene:initializeTiles()
	scene:setTileDefaultPosition(1, 4, 3)
	scene:setTileDefaultPosition(2, 3, 4)
	scene:setTileDefaultPosition(3, 2, 1)
	scene:setTileDefaultPosition(4, 1, 4)
	scene:setTileDefaultPosition(5, 2, 4)
	scene:setTileDefaultPosition(6, 3, 3)
	scene:setTileDefaultPosition(7, 4, 2)
	scene:setTileDefaultPosition(8, 2, 3)
	scene:setTileDefaultPosition(9, 1, 3)
	scene:setTileDefaultPosition(10, 4, 4)
	scene:setTileDefaultPosition(11, 1, 2)
	scene:setTileDefaultPosition(12, 1, 1)
	scene:setTileDefaultPosition(13, 3, 2)
	scene:setTileDefaultPosition(14, 2, 2)
	scene:setTileDefaultPosition(15, 4, 1)
	scene:setTileDefaultPosition(16, 3, 1)
	
	--[[
	scene:setTileDefaultPosition(1, 2, 1)
	scene:setTileDefaultPosition(2, 1, 1)
	scene:setTileDefaultPosition(3, 3, 1)
	scene:setTileDefaultPosition(4, 4, 1)
	scene:setTileDefaultPosition(5, 1, 2)
	scene:setTileDefaultPosition(6, 2, 2)
	scene:setTileDefaultPosition(7, 3, 2)
	scene:setTileDefaultPosition(8, 4, 2)
	scene:setTileDefaultPosition(9, 1, 3)
	scene:setTileDefaultPosition(10, 2, 3)
	scene:setTileDefaultPosition(11, 3, 3)
	scene:setTileDefaultPosition(12, 4, 3)
	scene:setTileDefaultPosition(13, 1, 4)
	scene:setTileDefaultPosition(14, 2, 4)
	scene:setTileDefaultPosition(15, 3, 4)
	scene:setTileDefaultPosition(16, 4, 4)]]
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/boys_showers/tiles/bg_tiles_zoom.jpg"))
	
	self:initializeTiles()
	
	local buttonSize = { width = 79, height = 76 }
	local center =  { x = 129, y = 27 }
	
	for j = 1,rows do
		for i = 1,cols do
			local index = #imgParts + 1
			
			local position = scene:getTilePosition(index)
			
			local button = self:addToScene(game.ui.newButton(
				device.x(center.x + ((buttonSize.width + 1) * (position.col - 1))), 
				device.y(center.y + ((buttonSize.height + 1) * (position.row - 1))), {
					defaultFile = "assets/images/game/gym/boys_showers/tiles/tiles_puzzle_" .. index .. ".jpg",
					width = buttonSize.width, 
					height = buttonSize.height, 
					onRelease = onImageRelease
			}))
			button.index = index
			imgParts[index] = button
		end	
	end
	
	self:addToHUD(game.ui.newBackButton("game.gym.boys_showers"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		selectedImage = nil
		self:loadSound("rumble", "assets/sounds/game/gym/earth_rumble_small.mp3")
		self:loadSound("tile", "assets/sounds/game/gym/tile_swap.mp3")
		self:loadSound("button", "assets/sounds/game/general/click.mp3")
	elseif event.phase == "did" then
		game.hud.show()
		if game.puzzles.hasFinished("boys_showers_tiles") then
			scene:nextScene()
		end
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then		
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene

