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
		--background:toBack()
	end

	return result
end

--------------------------------------------------------------------------------------------------

function scene:checkValues(img)
	local solution = solutions[img.idp]
	if solution and img.angle % 360 == 0 and img.x < (solution.x + 30) and img.x > (solution.x - 30) and img.y < (solution.y + 30) and img.y > (solution.y - 30) then
		self:placePartInSolution(img)

		if self:isEveryPartSolved() then
			--stage.play(stage.loadSound("assets/sounds/game/success.mp3"))

			--puzzles.finish("ray_office.letter")

			--instructions.close()
			--instructions.remove()

			local letter = display.newImageRect("assets/images/game/puzzles/demo/letter/legal_department_note.png", 288, 323)
			letter.anchorX, letter.anchorY = 0.5, 0.5
			letter.x, letter.y = display.contentWidth	/ 2, display.contentHeight / 2
			letter.alpha = 0
			self:addToScene(letter)

			self.letterTransition = transition.dissolve(outline, letter, 2000, 500)
		end
	end
end

--------------------------------------------------------------------------------------------------

function scene:placePartInSolution(img)
	local solution = solutions[img.idp]
	if solution then
		game.state.ray_office_letter = game.state.ray_office_letter or {}
		game.state.ray_office_letter[img.idp] = true
		game.markAsChanged()

		img.x, img.y = solution.x , solution.y
		img.isEnabled = false
		img.isonplace = true
		img:toBack();
		img:setFillColor(0.5, 0.5, 0.5, 1)
		--background:toBack()
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
	game.state.ray_office_letter = game.state.ray_office_letter or {}
	return game.state.ray_office_letter[id] ~= nil
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	--ui.setupScene(self)

	--self:addToScene(self:createBackground())

	self:createImageParts()

	self:initializeSolutions()

	self:initializeParts()

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

			local mask = graphics.newMask("assets/images/game/puzzles/demo/letter/mask_" .. i .. ".png")
			img:setMask(mask)

			img.maskX = 0 --img.contentWidth
			img.maskY = 0 --img.contentHeight
			img.isHitTestMasked = true

			img.angle = math.random(1, 4) * 90
			scene.imageTransition = transition.to(img,{ time=100,rotation=imgParts[i].img.angle })

			img.anchorX, img.anchorY = 0.5, 0.5
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
			x = device.x(imgPart.x),
			y = device.y(imgPart.y)
		}

		solutions[i] = solution
	end
end

function scene:createBackground()
	background = display.newGroup()

	background:insert(ui.newBackground("assets/images/game/puzzles/demo/letter/background.jpg"))

	outline = display.newImageRect("assets/images/game/puzzles/demo/letter/outline.png", 288, 323)
	outline.anchorX, outline.anchorY = 0.5, 0.5
	outline.x, outline.y = display.contentWidth	/ 2, display.contentHeight / 2
	background:insert(outline)

	return background
end

-----------------------------------------------------------------------------------------

function scene:createImageParts()
	imgParts =
	{
		{
			img= widget.newButton {
				id = "1",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_1.png",
				width = 92,
				height = 100,
				onEvent = onImageTap
			},
			x=176+10,y=56+14
		},
		{
			img=widget.newButton
			{
				id = "2",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_2.png",
				width = 108,
				height = 100,
				onEvent = onImageTap
			},
			x=247+2,y=56+14
		},
		{
			img=widget.newButton
			{
				id = "3",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_3.png",
				width = 108,
				height = 100,
				onEvent = onImageTap
			},
			x=327-6,y=56+14
		},
		{
			img=widget.newButton
			{
				id = "4",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_4.png",
				width = 108,
				height = 100,
				onEvent = onImageTap
			},
			x=407-14,y=56+14
		},
		{
			img=widget.newButton
			{
				id = "5",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_5.png",
				width = 92,
				height = 120,
				onEvent = onImageTap
			},
			x=176+10,y=134+5
		},
		{
			img=widget.newButton
			{
				id = "6",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_6.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x=247+2,y=134+5
		},
		{
			img=widget.newButton
			{
				id = "7",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_7.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x=327-6,y=134+5
		},
		{
			img=widget.newButton
			{
				id = "8",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_8.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x=407-14,y=134+5
		},
		{
			img=widget.newButton
			{
				id = "9",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_9.png",
				width = 92,
				height = 120,
				onEvent = onImageTap
			},
			x=176+10,y=224-5
		},
		{
			img=widget.newButton
			{
				id = "10",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_10.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x=247+2,y=224-5
		},
		{
			img=widget.newButton
			{
				id = "11",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_11.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x=327-6,y=224-5
		},
		{
			img=widget.newButton
			{
				id = "12",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_12.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x=407-14,y=224-5
		},
		{
			img=widget.newButton
			{
				id = "13",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_13.png",
				width = 90,
				height = 120,
				onEvent = onImageTap
			},
			x=176+10,y=314-14
		},
		{
			img=widget.newButton
			{
				id = "14",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_14.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x=247+2,y=314-14
		},
		{
			img=widget.newButton
			{
				id = "15",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_15.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x=327-6,y=314-14
		},
		{
			img=widget.newButton
			{
				id = "16",
				defaultFile = "assets/images/game/puzzles/demo/letter/part_16.png",
				width = 108,
				height = 120,
				onEvent = onImageTap
			},
			x=407-14,y=314-14
		}
	}
end

-----------------------------------------------------------------------------------------


function scene:onShow(event)
	if event.phase == "will" then
		--Do something

		--[[
		if not state.isSceneVisitedAgain("game.office.ray_office_letter") then
			hud.showCaption({
				text = i18n._"Office.Ray.Letter", time = 3000
			})
		end

		instructions.show(scene , {"Drag the paper pieces with your finger. Tap to rotate them. When the paper piece is in the correct position it will no longer move." })

		if puzzles.hasFinished("ray_office.letter") then

			instructions.close()
			instructions.remove()

		end
		]]--

	elseif event.phase == "did" then
		game.hud.show()
	end




end

-----------------------------------------------------------------------------------------

function scene:exitScene(event)
	self.imageTransition = ui.cancelTransition(self.imageTransition)
	self.letterTransition = ui.cancelTransition(self.letterTransition)
end
scene:addEventListener("exitScene", scene)

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene
