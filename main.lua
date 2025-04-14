-----------------------------------------------------------------------------------------

require("helpers")
require("events")

-----------------------------------------------------------------------------------------

game = require("api.game")
i18n = require("api.i18n")
fonts = require("fonts")

-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

-----------------------------------------------------------------------------------------

local startMenu
local startCover
local quickJump
local testBackground
local onSystemEvent

-----------------------------------------------------------------------------------------

local function startGame()
	--game.isDemo = true

	game.initialize()

	if game.hasSavedGame() then
		game.load()
	else
		game.startNew()
	end

	Runtime:addEventListener("system", onSystemEvent)

	startCover()
	--startMenu()
	--quickJump("chapter1", "intro")
	--quickJump("chapter1", "intro-hallway")
	--quickJump("chapter1", "intro-papers")
	--quickJump("chapter1", "intro-hallway_dark")
	--quickJump("chapter1", "start")
	--quickJump("puzzles", "locker_lou_lock")
	--quickJump("chapter1", "lockers-start")
	--quickJump("chapter1", "lockers-scare1")
	--quickJump("chapter1", "lockers-scare1-done")
	--quickJump("chapter1", "lockers-letter-done")
	--quickJump("chapter1", "lockers-jason")
	--quickJump("chapter1", "lockers-jason-done")
	--quickJump("chapter1", "lockers-gate-done")
	--quickJump("chapter1", "boys_bathroom")
	--quickJump("chapter1", "boys_sink")
	--quickJump("chapter1", "boys_sink-hot")
	--quickJump("chapter1", "boys_showers")
	--quickJump("chapter1", "boys_showers-handle")
	--quickJump("chapter1", "boys_showers-done")
	--quickJump("chapter1", "boys_showers-tiles-done")
	--quickJump("chapter1", "boys_toilets")
	--quickJump("chapter1", "boys_toilets-handle")
	--quickJump("chapter1", "boys_toilets-flushed")
	--quickJump("chapter1", "boys_toilets-will")
	--quickJump("chapter1", "boys_toilets-will-out")
	--quickJump("chapter1", "basketball_court")
	--quickJump("chapter1", "basketball_court-ladder")
	--quickJump("chapter1", "basketball_court-trophy")
	--quickJump("chapter1", "storage_room")
	--quickJump("chapter1", "storage_room-items")
	--quickJump("chapter1", "pool")
	--quickJump("chapter1", "pool-coin")
	--quickJump("chapter1", "pool_control_room")
	--quickJump("chapter1", "pool_control_room-pipe")
	--quickJump("chapter1", "pool_control_room-all_items")
	--quickJump("chapter1", "pool_empty")
	--quickJump("puzzles", "water_heater")
	--quickJump("chapter1", "girls_hallway")
	--quickJump("chapter1", "girls_hallway-rose")
	--quickJump("chapter1", "girls_lockers")
	--quickJump("chapter1", "girls_lockers-ready")
	--quickJump("chapter1", "girls_lockers-open")
	--quickJump("chapter1", "principal_den")
	--quickJump("chapter1", "principal_attic")
	--quickJump("chapter1", "ritual_room")
	--quickJump("chapter1", "ritual_room-items")
	--quickJump("chapter1", "ritual_room-done")
	--quickJump("chapter1", "credits")
	--quickJump("puzzles","physics")
end

-----------------------------------------------------------------------------------------

onSystemEvent = function(event)
	if event.type == "applicationExit" then
		game.hints.suspendTimer()
		game.save()
		game.stage.stopAll()
	elseif event.type == "applicationOpen" then
		game.hints.resumeTimer()
	elseif event.type == "applicationSuspend" then
		if game.hints then
			game.hints.suspendTimer()
		end
		game.save()
	elseif event.type == "applicationResume" then
		game.hints.resumeTimer()
	end
end

-----------------------------------------------------------------------------------------

startMenu = function()
	game.scenes.gotoScene("scene.menu", "fade", 500)
end

-----------------------------------------------------------------------------------------

startCover = function()
	game.scenes.gotoScene("scene.cover", "fade", 500)
end

-----------------------------------------------------------------------------------------

local function setupJump(chapter, scene)
	if chapter == "chapter1" then
		if scene == "intro" then
      --do nothing
    elseif scene == "intro-hallway" then
      game.data.currentScene = "game.intro.04_hallway"
    elseif scene == "intro-papers" then
      game.data.currentScene = "game.intro.05_papers"
    elseif scene == "intro-hallway_dark" then
      game.data.currentScene = "game.intro.08_hallway_dark"
    elseif scene == "start" then
			game.data.currentScene = "game.gym.locker_lou"
		elseif scene == "lockers-start" then
			game.data.currentScene = "game.gym.boys_locker_room"
		elseif scene == "lockers-scare1" then
			game.data.currentScene = "game.gym.boys_locker_room"
			game.inventory.addItem("Journal")
			game.inventory.addItem("Oracle")
			game.events.trigger("boys_locker_room.will_greet")
			game.events.trigger("boys_locker_room.scare1_start")
			game.events.trigger("boys_locker_room.scare1_will_left")
			game.events.trigger("boys_locker_room.scare1_shriek1")
			game.events.trigger("boys_locker_room.scare1_shriek2")
		elseif scene == "lockers-scare1-done" then
			setupJump("chapter1", "lockers-scare1")
			game.events.trigger("boys_locker_room.scare1_shade_left")
			game.events.trigger("boys_locker_room.scare1")
			game.events.trigger("boys_lockers.will_asks_for_help")
		elseif scene == "lockers-letter-done" then
			setupJump("chapter1", "lockers-scare1-done")
			game.puzzles.finish("boys_locker_room_letter")
		elseif scene == "lockers-jason" then
			setupJump("chapter1", "boys_showers")
			game.events.trigger("dexter_locker_unlocked")
			game.inventory.addItem("Crowbar")
			game.inventory.addItem("PoweredRobot")
			game.events.trigger("will_locker_unlocked")
			game.events.trigger("boys_locker_room.will_is_out")
			game.events.trigger("will.toilet")
			game.events.trigger("dexter_locker_unlocked")
			game.data.currentScene = "game.gym.boys_lockers"
		elseif scene == "lockers-jason-done" then
			setupJump("chapter1", "lockers-jason")
			game.events.trigger("jason_locker_pried")
			game.events.trigger("jason_locker_destroyed")
			game.data.currentScene = "game.gym.boys_lockers"
		elseif scene == "lockers-gate-done" then
			setupJump("chapter1", "boys_showers-done")
			game.events.trigger("will_locker_unlocked")
			game.events.trigger("boys_locker_room.will_is_out")
			game.events.trigger("will.toilet")
			game.events.trigger("dexter_locker_unlocked")
			game.events.trigger("gates_locker_unlocked")
			game.data.currentScene = "game.gym.boys_lockers"
		elseif scene == "boys_bathroom" then
			setupJump("chapter1", "lockers-letter-done")
			game.data.currentScene = "game.gym.boys_bathroom"
		elseif scene == "boys_sink" then
			setupJump("chapter1", "boys_bathroom")
			game.data.currentScene = "game.gym.boys_sink"
		elseif scene == "boys_sink-hot" then
			setupJump("chapter1", "boys_sink")
			game.events.trigger("gym.hot_water_enabled")
		elseif scene == "boys_showers" then
			setupJump("chapter1", "boys_sink")
			game.data.currentScene = "game.gym.boys_showers"
		elseif scene == "boys_showers-handle" then
			setupJump("chapter1", "boys_showers")
			game.inventory.addItem("ShowerHandle")
		elseif scene == "boys_showers-done" then
			setupJump("chapter1", "boys_showers")
			game.puzzles.finish("boys_showers")
			game.events.trigger("gym.showers.diamond_placed")
			game.events.trigger("jason_locker_pried")
			game.events.trigger("jason_locker_destroyed")
		elseif scene == "boys_showers-tiles-done" then
			setupJump("chapter1", "boys_showers-done")
			game.puzzles.finish("boys_showers_tiles")
		elseif scene == "boys_toilets" then
			setupJump("chapter1", "boys_sink")
			game.data.currentScene = "game.gym.boys_toilets"
		elseif scene == "boys_toilets-handle" then
			setupJump("chapter1", "boys_toilets")
			game.inventory.addItem("ToiletHandle")
		elseif scene == "boys_toilets-flushed" then
			setupJump("chapter1", "boys_toilets")
			game.events.trigger("boys_bathroom.toilet_flushed")
		elseif scene == "boys_toilets-will" then
			setupJump("chapter1", "boys_toilets")
			game.events.trigger("will.toilet")
			game.inventory.addItem("ToiletPaper")
			game.inventory.addItem("Robot")
			game.data.currentScene = "game.gym.boys_bathroom"
		elseif scene == "boys_toilets-will-out" then
			setupJump("chapter1", "boys_toilets-will")
			game.events.trigger("will.toilet.out")
			game.data.currentScene = "game.gym.boys_toilets"
		elseif scene == "basketball_court" then
			setupJump("chapter1", "boys_sink")
			game.journal.addEntry("Gym.Letter")
			game.data.currentScene = "game.gym.basketball_court"
		elseif scene == "basketball_court-ladder" then
			setupJump("chapter1", "basketball_court")
			game.inventory.addItem("Ladder")
		elseif scene == "basketball_court-trophy" then
			setupJump("chapter1", "basketball_court")
			game.puzzles.finish("trophy_lock")
			game.inventory.addItem("Trophy")
		elseif scene == "storage_room" then
			setupJump("chapter1", "basketball_court")
			game.data.currentScene = "game.gym.storage_room"
		elseif scene == "storage_room-items" then
			setupJump("chapter1", "storage_room")
			game.inventory.addItem("ChestRoundCrest")
			game.inventory.addItem("ChestHexCrest")
			game.inventory.addItem("ChestSquareCrest")
		elseif scene == "pool" then
			setupJump("chapter1", "lockers-scare1-done")
			game.data.currentScene = "game.gym.pool"
		elseif scene == "pool-coin" then
			setupJump("chapter1", "pool")
			game.inventory.addItem("Coin")
		elseif scene == "pool_control_room" then
			setupJump("chapter1", "pool")
			game.data.currentScene = "game.gym.pool_control_room"
		elseif scene == "pool_control_room-pipe" then
			setupJump("chapter1", "pool_control_room")
			game.inventory.addItem("PoolPumpPipe")
		elseif scene == "pool_control_room-all_items" then
			setupJump("chapter1", "pool_control_room")
			game.inventory.addItem("PoolPumpPipe")
			game.inventory.addItem("WaterHeaterHandle")
			game.inventory.addItem("CrankHandle")
		elseif scene == "pool_empty" then
			setupJump("chapter1", "pool")
			game.data.currentScene = "game.gym.pool_empty"
		elseif scene == "girls_hallway" then
			setupJump("chapter1", "boys_sink")
			game.data.currentScene = "game.gym.girls_hallway"
		elseif scene == "girls_hallway-rose" then
			setupJump("chapter1", "girls_hallway")
			game.inventory.addItem("Rose")
		elseif scene == "girls_lockers" then
			setupJump("chapter1", "girls_hallway")
			game.data.currentScene = "game.gym.girls_lockers"
		elseif scene == "girls_lockers-ready" then
			setupJump("chapter1", "girls_lockers")
			game.journal.addEntry("Gym.MirandaLock")
		elseif scene == "girls_lockers-open" then
			setupJump("chapter1", "girls_lockers-ready")
			game.puzzles.finish("locker_miranda_lock")
		elseif scene == "principal_den" then
			setupJump("chapter1", "basketball_court-trophy")
			game.events.trigger("trophy_placed")
			game.inventory.discard("Trophy")
			game.data.currentScene = "game.gym.principal_den"
		elseif scene == "principal_attic" then
			setupJump("chapter1", "principal_den")
			game.puzzles.finish("principal_den_portrait")
			game.inventory.addItem("ChestKey")
			game.data.currentScene = "game.gym.principal_attic"
		elseif scene == "ritual_room" then
			setupJump("chapter1", "principal_den")
			game.puzzles.finish("principal_den_wall")
		elseif scene == "ritual_room-items" then
			setupJump("chapter1", "ritual_room")
			game.inventory.addItem("Apple")
			game.inventory.addItem("Pillow")
			game.inventory.addItem("RobotHead")
			game.inventory.addItem("Chips")
			game.inventory.addItem("Mirror")
			game.inventory.addItem("VandalizedPhoto")
			game.inventory.addItem("Treasure")
		elseif scene == "ritual_room-done" then
			setupJump("chapter1", "ritual_room")
			game.data.currentScene = "game.gym.ritual_room_statue"
			game.events.trigger("ritual_room.surprise")
			game.puzzles.finish("ritual_room")
			game.events.trigger("ritual_room.anger")
			game.events.trigger("ritual_room.envy")
			game.events.trigger("ritual_room.pride")
			game.events.trigger("ritual_room.lust")
			game.events.trigger("ritual_room.gluttony")
			game.events.trigger("ritual_room.sloth")
			game.events.trigger("ritual_room.greed")
		elseif scene == "credits" then
			game.data.currentScene = "scene.credits"
		end
	elseif chapter == "puzzles" then
		if scene == "worldpuzzle" then
			game.data.currentScene = "scene.game.puzzles.demopuzzle"
		elseif scene == "puzzle1" then
			game.data.currentScene = "scene.game.puzzles.puzzle2"
		elseif scene == "physics" then
			game.data.currentScene = "scene.game.puzzles.demo.physics"
		elseif scene == "locker_lou_lock" then
			game.data.currentScene = "scene.game.puzzles.gym.locker_lou_lock"
		elseif scene == "boys_locker_room_letter" then
			game.data.currentScene = "scene.game.puzzles.gym.boys_locker_room_letter"
		elseif scene == "water_heater" then
			game.data.currentScene = "scene.game.puzzles.gym.water_heater"
		end
	elseif chapter == "template" then
		game.data.currentScene = "scene.template"
	end

	game.markAsChanged()
end

quickJump = function(chapter, scene)
	game.startNew()

	setupJump(chapter, scene)

	game.go()
end

testBackground = function(background)
	game.scenes.gotoTestScene(background)
end

-----------------------------------------------------------------------------------------

startGame()

-----------------------------------------------------------------------------------------
