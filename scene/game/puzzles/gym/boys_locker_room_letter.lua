-----------------------------------------------------------------------------------------

local game = require("api.game")
local widget = require("widget")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local background
local outline
local imgParts
local selectedImage = -1
local cardismoving = false
local objPosX = 100 --display.contentWidth/2
local objPosY = 100 --display.contentHeight/2
local partIndex = 1
local solutions

--------------------------------------------------------------------------------------------------

local function ensureImagePositionLimits(image)
	if image.x < 5 then
		image.x = 5
	elseif image.x > (display.contentWidth - 5) then
		image.x = display.contentWidth - 5
	end

	if image.y < 5 then
		image.y = 5
	elseif image.y > (display.contentHeight - 5) then
		image.y = display.contentHeight - 5
	end
end

--------------------------------------------------------------------------------------------------

local function onImageTap(event)
	local target = event.target
	local targetId = target.idp
	local result = false

	if target.isonplace == false and (selectedImage == -1 or targetId == selectedImage or event.phase == "began") then
		if event.phase == "began" then

			selectedImage = targetId
			target.markX = target.x
			target.markY = target.y
			target:toFront()
			result = true
		elseif event.phase == "moved" and selectedImage ~= -1 then
			if target.markX ~= nil and target.markY ~= nil then

				target.x = (event.x - event.xStart) + target.markX
				target.y = (event.y - event.yStart) + target.markY
				ensureImagePositionLimits(target)
			end
			result = true
		elseif event.phase == "ended" then

			if selectedImage ~= -1 then
				if math.abs(target.x - target.markX) < 2 and math.abs(target.y - target.markY) < 2 then
					target.x = target.markX
					target.y = target.markY
					target.angle = target.angle + 90
					scene.imageTransition = transition.to(target, { time = 100, rotation = target.angle })
				else
					scene:checkValues(target)
				end

				target.markX = target.x
				target.markY = target.y
			end
			result = true
		end
		background:toBack()
	end

	return result
end

--------------------------------------------------------------------------------------------------

function scene:checkValues(img)
	local solution = solutions[img.idp]
	if solution and img.angle % 360 == 0 and img.x < (solution.x + 30) and img.x > (solution.x - 30) and img.y < (solution.y + 30) and img.y > (solution.y - 30) then
		self:placePartInSolution(img)

		if self:isEveryPartSolved() then
			game.stage.playSuccessSound()
			game.puzzles.finish("boys_locker_room_letter")
			
			game.achievements.unlock("torn_letter")

			local letter = display.newImageRect("assets/images/game/puzzles/gym/boys_locker_room_letter/note.jpg", 288, 323)
			letter.anchorX, letter.anchorY = 0.5, 0.0
			letter.x, letter.y = display.contentWidth	/ 2, 0
			letter.alpha = 0
			self:addToScene(letter)

			self.letterTransition = transition.dissolve(outline, letter, 2000, 500)
			self:newTimer(2500, function()
				game.journal.recordEntry("Gym.Letter")
			end)
		end
	end
end

--------------------------------------------------------------------------------------------------

function scene:placePartInSolution(img)
	local solution = solutions[img.idp]
	if solution then
		game.data.ray_office_letter = game.data.ray_office_letter or {}
		game.data.ray_office_letter[img.idp] = true
		game.markAsChanged()

		img.x, img.y = solution.x , solution.y
		img.isEnabled = false
		img.isonplace = true
		img:toBack();
		img:setFillColor(0.5, 0.5, 0.5, 1)
		background:toBack()
	end
end

-----------------------------------------------------------------------------------------

function scene:isEveryPartSolved(id)
	for i, imgPart in ipairs(imgParts) do
		if not self:isPartSolved(i) then
			return false
		end
	end
	return true
end

-----------------------------------------------------------------------------------------

function scene:isPartSolved(id)
	game.data.ray_office_letter = game.data.ray_office_letter or {}
	return game.data.ray_office_letter[id] ~= nil
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(self:createBackground())
	outline = display.newImageRect("assets/images/game/puzzles/gym/boys_locker_room_letter/outline.png", 288, 323)
	outline.anchorX, outline.anchorY = 0.5, 0.0
	outline.x, outline.y = display.contentWidth	/ 2, 0
	outline.alpha = 0.8
	self:addToScene(outline)

	if game.puzzles.hasFinished("boys_locker_room_letter") then
		local letter = display.newImageRect("assets/images/game/puzzles/gym/boys_locker_room_letter/note.jpg", 288, 323)
		letter.anchorX, letter.anchorY = 0.5, 0.5
		letter.x, letter.y = display.contentWidth	/ 2, display.contentHeight / 2
		self:addToScene(letter)
	else
		self:createImageParts()

		self:initializeSolutions()

		self:initializeParts()
	end

	self:addToHUD(game.ui.newBackButton("game.gym.boys_locker_room"))
end

-----------------------------------------------------------------------------------------

function scene:initializeParts()
	for i=1,#imgParts do
		local imgPart = imgParts[i]
		local img = imgPart.img

		self:addToScene(img)

		img.id = "part" .. i
		img.idp = i
		img.markX = 0
		img.markY = 0

		if self:isPartSolved(i) then
			self:placePartInSolution(img)
		else
			img.isonplace = false
			img:toFront()

			local mask = graphics.newMask("assets/images/game/puzzles/gym/boys_locker_room_letter/mask_" .. i .. ".png")
			img:setMask(mask)

			img.maskX = img.contentWidth
			img.maskY = img.contentHeight
			img.isHitTestMasked = true

			img.angle = math.random(1, 4) * 90
			img.rotation = img.angle

			img.anchorX, img.anchorY = 0.5, 0.5

			local solution = solutions[img.idp]
			--img.x = solution.x
			--img.y = solution.y
			img.x = math.random(30, display.contentWidth - 30)
			img.y = math.random(30, display.contentHeight - 30)
		end
	end

end

function scene:initializeSolutions()
	solutions = {}

	for i=1,#imgParts do
		local imgPart = imgParts[i]

		local solution = {
			id = "part"..i,
			x = imgPart.x,
			y = imgPart.y
		}

		solutions[i] = solution
	end
end

function scene:createBackground()
	background = display.newGroup()

	background:insert(game.ui.newBackground("assets/images/game/puzzles/gym/boys_locker_room_letter/bg_note.jpg"))


	return background
end

-----------------------------------------------------------------------------------------

function scene:createImageParts()
	imgParts =
	{
		{
			img=widget.newButton
			{
				id = "1",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_1.png",
				width = 90,
				height = 100,
				onEvent = onImageTap
			},
			x= device.x(183) ,y= 49
		},
		{
			img=widget.newButton
			{
				id = "2",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_2.png",
				width = 108,
				height = 100,
				onEvent = onImageTap
			},
			x= device.x(248) ,y= 48
		},
		{
			img=widget.newButton
			{
				id = "3",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_3.png",
				width = 108,
				height = 100,
				onEvent = onImageTap
			},
			x= device.x(321) ,y= 47
		},
		{
			img=widget.newButton
			{
				id = "4",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_4.png",
				width = 108,
				height = 100,
				onEvent = onImageTap
			},
			x= device.x(392) ,y=48

		},
		{
			img=widget.newButton
			{
				id = "5",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_5.png",
				width = 90,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(183) ,y= 119
		},
		{
			img=widget.newButton
			{
				id = "6",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_6.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(247) ,y= 118
		},
		{
			img=widget.newButton
			{
				id = "7",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_7.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(320 ) ,y= 118
		},
		{
			img=widget.newButton
			{
				id = "8",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_8.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(392), y= 118
		},
		{
			img=widget.newButton
			{
				id = "9",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_9.png",
				width = 90,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(183), y= 200
		},
		{
			img=widget.newButton
			{
				id = "10",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_10.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(248), y= 199
		},
		{
			img=widget.newButton
			{
				id = "11",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_11.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(321), y= 199
		},
		{
			img=widget.newButton
			{
				id = "12",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_12.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(392), y= 199
		},
		{
			img=widget.newButton
			{
				id = "13",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_13.png",
				width = 90,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(184) ,y= 281
		},
		{
			img=widget.newButton
			{
				id = "14",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_14.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(248), y= 281
		},
		{
			img=widget.newButton
			{
				id = "15",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_15.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(320) , y= 281
		},
		{
			img=widget.newButton
			{
				id = "16",
				defaultFile = "assets/images/game/puzzles/gym/boys_locker_room_letter/part_16.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x= device.x(392), y= 280
		}
	}
end

-----------------------------------------------------------------------------------------


function scene:onShow(event)
	if event.phase == "will" then
		--Do something
		if game.puzzles.hasFinished("boys_locker_room_letter") then

		end
	elseif event.phase == "did" then
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene
