-----------------------------------------------------------------------------------------

local game = {}

-----------------------------------------------------------------------------------------

function game.isPaused()
	local currentScene = game.scenes.getCurrentSceneName()
	return currentScene and string.startsWith(currentScene, "scene.menu")
end

-----------------------------------------------------------------------------------------

function game.pause()
	game.save()
	if not game.isPaused() then
		game.scenes.gotoMainMenu()
	end
end

-----------------------------------------------------------------------------------------

function game.pauseSilently()
	game.save()
	if not game.isPaused() then
		game.scenes.gotoMainMenu(true)
	end
end

-----------------------------------------------------------------------------------------

function game.save()
	if game.isActive() then
		if game.hasChanged then
			print("Saving game state")
			io.writeFileAsJson(game.data, "game.dat", system.DocumentsDirectory)
			game.hasChanged = false
		else
			print("Saved game has not changed. Skipping saving file.")
		end
	end
end

-----------------------------------------------------------------------------------------

function game.markAsChanged()
	game.hasChanged = true
end

-----------------------------------------------------------------------------------------

local function loadSavedGameTable()
	print("Loading game state")
	return io.getFileContentsAsJson("game.dat", system.DocumentsDirectory)
end

-----------------------------------------------------------------------------------------

function game.loadContinue()
	local settings = game.data.settings
	local result = game.load()
	game.data.settings = settings
	return result
end

-----------------------------------------------------------------------------------------

function game.load()
	game.data = loadSavedGameTable()
	game.hasChanged = false
	return game.data ~= nil and game.data.isActive
end

-----------------------------------------------------------------------------------------

function game.isActive()
	return game.data and game.data.isActive
end

-----------------------------------------------------------------------------------------

function game.isStarted()
	return game.data and game.data.hasStarted
end

-----------------------------------------------------------------------------------------

function game.hasSavedGame()
	local savedGameState = loadSavedGameTable()
	return savedGameState ~= nil and savedGameState.isActive
end

-----------------------------------------------------------------------------------------

function game.startNew()
	local settings = game.data and game.data.settings
	
	game.data = {}
	game.data.isActive = true
	game.data.hasStarted = false
	game.data.currentScene = "game.intro.01_bell_rings"
	game.data.currentChapter = "chapter1"
	game.data.currentPlayer = "lou"
	game.data.settings = settings or {}
	game.journal.addEntry("Lou.Page1")
	game.journal.addEntryFor("will", "Will.Page1")
	game.journal.addEntryFor("miranda", "Miranda.Page1")
	game.journal.addEntryFor("popenoe", "Popenoe.Page1")
	game.journal.addEntryFor("popenoe", "Popenoe.Ritual")
	game.hasChanged = true
	game.save()
end

-----------------------------------------------------------------------------------------

function game.startNewAndGo()
	game.startNew()
	game.go()
end

-----------------------------------------------------------------------------------------

function game.go()
	game.achievements.initialize()
	game.purchases.restore()
	
	game.data.hasStarted = true
	game.hasChanged = true
	game.scenes.gotoGameScene(game.data.currentScene, "fade", 1000)
end

-----------------------------------------------------------------------------------------

function game.initialize()
	math.randomseed(os.time())
	
	game.effects = require("api.effects")
	game.particles = require("api.particles")
	game.ui = require("api.ui")
	game.achievements = require("api.achievements")
	game.state = require("api.state")
	game.stage = require("api.stage")
	game.puzzles = require("api.puzzles")
	game.hud = require("api.hud")
	game.inventory = require("api.inventory")
	game.items = require("api.items")
	game.events = require("api.events")
	game.scenes = require("api.scenes")
	game.purchases = require("api.purchases")
	game.info = require("api.info")
	game.hints = require("api.hints")
	game.ratings = require("api.ratings")
	game.journal = require("api.journal")
	game.util = require("api.util")
	game.analytics = require("api.analytics")
	
	game.stage.initialize()
	--game.achievements.initialize() --Moved to game.go()
	game.purchases.initialize()
end

-----------------------------------------------------------------------------------------

return game