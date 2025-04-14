-----------------------------------------------------------------------------------------

local widget = require("widget")
local native = require("native")
local game = require("api.game")

-----------------------------------------------------------------------------------------

local scene = game.scenes.newScene()

-----------------------------------------------------------------------------------------

local pages =
{
	{ title = "Created By", names = "Squadventure Games" },
	{ title = "Creative Director", names = "Julio Seaman" },
	{ title = "Lead Developer", names = "George Faraj" },
	{ title = "Lead Graphics Designer", names = "Alexis Mael Correa" },
	{ groups = { 
		{ title = "Graphics Designer", names = "Mario Guzman" },
		{ title = "Programmer", names = "Eduardo Irias" }
	}},
	{ title = "Music", names = { "\"Oppressive Gloom\"", "\"Night of the Owl\"", "Kevin MacLeod", "incompetech.com" } },
	{ title = "Special Thanks", names = { "CAVpollo", "Will Serrano", "Luis Angel Tortola", "Linda Stephens" } },
}

-----------------------------------------------------------------------------------------

function scene:startNextPage()
	scene.currentPage = scene.currentPage + 1
	if scene.currentPage > #pages then
		game.scenes.gotoGameScene("scene.finish", "fade", 2000)
		return
	end
	
	local page = pages[scene.currentPage]
	local pageGroup = game.ui.insertChild(scene.rootPageGroup, game.ui.newGroup())
	pageGroup.alpha = 0
	
	game.ui.newBackground("assets/images/credits/credits_" .. scene.currentPage .. ".jpg", pageGroup)
	
	local top = 198
	local left = 285
	local width = 241
	
	local groups = page.groups
	if groups == nil then
		groups = { { title = page.title, names = page.names } }
	end
	
	local pageTextGroup = game.ui.insertChild(pageGroup, game.ui.newGroup())
	
	for i, group in ipairs(groups) do
		game.ui.insertChild(pageTextGroup, game.ui.newTextBox({
			set_name="Standard", text=group.title, color={0.6,0.6,0.6},
			x=device.x(left), y = device.y(top), size = 22, width = width, height = 40, align = "center"
		}))
		top = top + 30
		
		local names = group.names
		if type(names) ~= "table" then
			names = { names }
		end
		for j, name in ipairs(names) do
			game.ui.insertChild(pageTextGroup, game.ui.newTextBox({
				set_name="Standard", text=name, color={1,1,1},
				x=device.x(left), y = device.y(top), size = 16, width = width, height = 40, align = "center"
			}))
			top = top + 20
		end
		
		top = top + 30
	end
	
	pageTextGroup.y = 278 - top
	
	local oldPageGroup = scene.currentPageGroup
	if oldPageGroup then
		scene:newTransition(oldPageGroup, { alpha = 0, time = 1000 })
	end
	
	scene.currentPageGroup = pageGroup
	
	scene:newTransition(scene.currentPageGroup, { alpha = 1, time = 1000, delay = (oldPageGroup and 1000) or 0, onComplete = function()
		scene:newTimer(1500, function()
			scene:startNextPage()
		end)
	end})
end

-----------------------------------------------------------------------------------------

function scene:showSmoke()
	scene:addToScene(game.particles.createStartedParticle("hints_smoke", "smoke", display.contentWidth/2, display.contentHeight/2))
	game.particles.start()
end

-----------------------------------------------------------------------------------------

function scene:onCreate(event)
	scene.currentPageGroup = nil
	scene.currentPage = 0
	
	scene.rootPageGroup = scene:addToScene(game.ui.newGroup())
end

-----------------------------------------------------------------------------------------

function scene:onShow(event)
	if event.phase == "will" then
		scene:showSmoke()
	elseif event.phase == "did" then
		game.hud.hide()
		scene:startNextPage()
	end
end

-----------------------------------------------------------------------------------------

function scene:onHide(event)
	if event.phase == "will" then
		game.particles.cleanUp()
	elseif event.phase == "did" then
		--Do something
	end
end

-----------------------------------------------------------------------------------------

function scene:onDestroy(event)
end

-----------------------------------------------------------------------------------------

return scene