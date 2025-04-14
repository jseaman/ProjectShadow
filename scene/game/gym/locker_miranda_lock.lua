-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

--------------------------------------------------------------------------------------------------

local VertexWidth = 42
local VertexHeight = 43

local vertices = 
{
	V1 = {
		name = "V1", x = 279, y = 155
	},
	V2 = {
		name = "V2", x = 157, y = 127
	},
	V3 = {
		name = "V3", x = 279, y = 39
	},
	V4 = {
		name = "V4", x = 401, y = 128
	},
	V5 = {
		name = "V5", x = 353, y = 270
	},
	V6 = {
		name = "V6", x = 203, y = 270
	},
}

local edges = 
{
	{
		v1 = vertices.V1, v2 = vertices.V2
	},
	{
		v1 = vertices.V1, v2 = vertices.V3
	},
	{
		v1 = vertices.V1, v2 = vertices.V4
	},
	{
		v1 = vertices.V1, v2 = vertices.V5
	},
	{
		v1 = vertices.V1, v2 = vertices.V6
	},
	{
		v1 = vertices.V2, v2 = vertices.V3
	},
	{
		v1 = vertices.V2, v2 = vertices.V6
	},
	{
		v1 = vertices.V1, v2 = vertices.V2
	},
	{
		v1 = vertices.V3, v2 = vertices.V4
	},
	{
		v1 = vertices.V4, v2 = vertices.V5
	},
}

local balls = 
{
	blue = {
		name = "blue", filename = "ball_blue.png",
		defaultVertex = vertices.V5,
	},
	green = {
		name = "green", filename = "ball_green.png",
		defaultVertex = vertices.V6,
	},
	purple = {
		name = "purple", filename = "ball_purple.png",
		defaultVertex = vertices.V2,
	},
	red = {
		name = "red", filename = "ball_red.png",
		defaultVertex = vertices.V3,
	},
	yellow = {
		name = "yellow", filename = "ball_yellow.png",
		defaultVertex = vertices.V4,
	},
}

local solution =
{
	V1 = "none",
	V2 = "blue",
	V3 = "purple",
	V4 = "green",
	V5 = "red",
	V6 = "yellow"
}

--TEMP: easy solution
--[[local solution =
{
	V1 = "none",
	V2 = "yellow",
	V3 = "green",
	V4 = "purple",
	V5 = "red",
	V6 = "blue"
}]]

--------------------------------------------------------------------------------------------------

local function findEdge(v1, v2)
	for edge in list_iter(edges) do
		if (edge.v1 == v1 or edge.v2 == v1) and (edge.v1 == v2 or edge.v2 == v2) then
			return edge
		end
	end
	return nil
end

--------------------------------------------------------------------------------------------------

local function getConnectedVertices(vertex)
	local verts = {}
	for edge in list_iter(edges) do
		if edge.v1 == vertex then
			verts[#verts + 1] = edge.v2
		elseif edge.v2 == vertex then
			verts[#verts + 1] = edge.v1
		end
	end
	return verts
end

--------------------------------------------------------------------------------------------------

local function getDefaultBall(vertex)
	for key, ball in pairs(balls) do
		if ball.defaultVertex == vertex then
			return ball
		end
	end
	return nil
end

--------------------------------------------------------------------------------------------------

local function putBallOnVertex(ball, vertex)
	game.data.miranda_lock_vertices = game.data.miranda_lock_vertices or {}
	if ball then
		game.data.miranda_lock_vertices[vertex.name] = ball.name
	else
		game.data.miranda_lock_vertices[vertex.name] = "none"
	end
	game.markAsChanged()
end

local function getBallNameOnVertex(vertex)
	if type(vertex) == "string" then
		vertex = vertices[vertex]
	end
	game.data.miranda_lock_vertices = game.data.miranda_lock_vertices or {}
	if not game.data.miranda_lock_vertices[vertex.name] then
		putBallOnVertex(getDefaultBall(vertex), vertex)		
	end
	
	return game.data.miranda_lock_vertices[vertex.name]
end

local function getBallOnVertex(vertex)	
	local ballName = getBallNameOnVertex(vertex)
	if ballName ~= "none" then
		return balls[ballName]
	end
	return nil
end

--------------------------------------------------------------------------------------------------

local function isVertexOccupied(vertex)
	return getBallOnVertex(vertex) ~= nil
end

--------------------------------------------------------------------------------------------------

local function getEmptyConnectedVertex(vertex)
	for v2 in list_iter(getConnectedVertices(vertex)) do
		if not isVertexOccupied(v2) then
			return v2
		end
	end
	return nil
end

--------------------------------------------------------------------------------------------------

local function onVertexTouch(vertex)
	if not scene.isMoving then
		if isVertexOccupied(vertex) then			
			local emptyVertex = getEmptyConnectedVertex(vertex)
			if emptyVertex then
				local ball = getBallOnVertex(vertex)
				scene:moveBall(ball, vertex, emptyVertex)
			else
				--TODO: play sound or say something
			end
		else
			--TODO: play sound or something
		end
	end
end

--------------------------------------------------------------------------------------------------

function scene:moveBall(ball, vertexFrom, vertexTo)
	self.isMoving = true
	putBallOnVertex(nil, vertexFrom)
	putBallOnVertex(ball, vertexTo)
	
	if scene:checkSolution() then
		scene:hideHUD()
		game.hud.hide()
		game.puzzles.finish("locker_miranda_lock")
	end
	
	self:playSound("block")
	self:newTransition(ball.image, { x = device.x(vertexTo.x), y = device.y(vertexTo.y), time = 1300, onComplete = function()
		self.isMoving = false
		
		if scene:checkSolution() then
			for key, ball in pairs(balls) do
				ball.glowImage.x, ball.glowImage.y = ball.image.x, ball.image.y
			end
			self:newTransition(scene.glowBalls, { alpha = 1, time = 700 })
			self:newTransition(scene.glow, { alpha = 1, time = 700, onComplete = function()
				self:playSound("locker_unlock")
				self:newTimer(2000, function()
					scene:playSound("locker_open")			
					game.scenes.gotoGameScene("game.gym.locker_miranda")
				end)
			end})
		end
	end})
end

--------------------------------------------------------------------------------------------------

function scene:checkSolution()
	if not game.journal.hasEntry("Gym.MirandaLock") then
		return false
	end
	
	for key, value in pairs(solution) do
		if getBallNameOnVertex(key) ~= value then
			return false
		end
	end
	return true
end

--------------------------------------------------------------------------------------------------

function scene:onCreate(event)
	self:addToScene(game.ui.newBackground("assets/images/game/gym/girls_locker_room/lock/mirandas_lock_zoom.jpg"))
	
	self.glow = self:addToScene(game.ui.newImage("assets/images/game/gym/girls_locker_room/lock/lock_glow.png", 
		device.x(142), device.y(23), 317, 306))
	self.glow.alpha = 0
		
	for key, vertex in pairs(vertices) do
		local ball = getBallOnVertex(vertex)
		if ball then
			ball.image = self:addToScene(game.ui.newImage("assets/images/game/gym/girls_locker_room/lock/" .. ball.filename, 
				device.x(vertex.x), device.y(vertex.y), VertexWidth, VertexHeight))
		end
	end
	
	self.glowBalls = self:addToScene(game.ui.newGroup())
	self.glowBalls.alpha = 0
	
	for key, ball in pairs(balls) do
		ball.glowImage = game.ui.insertChild(self.glowBalls, game.ui.newImage("assets/images/game/gym/girls_locker_room/lock/" .. ball.name .. "_glow.png", 
			device.x(0), device.y(0), VertexWidth, VertexHeight))
	end
	
	for key, vertex in pairs(vertices) do
		self:addToScene(game.ui.newTouchRegionTap(device.x(vertex.x), device.y(vertex.y), VertexWidth, VertexHeight, function()
			onVertexTouch(vertex)
		end))
	end	
	
	self:addToHUD(game.ui.newBackButton("game.gym.girls_lockers"))
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		self:loadSound("block", "assets/sounds/game/gym/block_move.mp3")
		self:loadSound("locker_open", "assets/sounds/game/gym/locker_open.mp3")
		self:loadSound("locker_unlock", "assets/sounds/game/gym/locker_unlock.mp3")
		self.isMoving = false
	elseif event.phase == "did" then
		game.hud.show()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		--Do something
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene

