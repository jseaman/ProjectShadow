-----------------------------------------------------------------------------------------

local hints = {}

-----------------------------------------------------------------------------------------

local HintIntervalMin = 7
local HintInterval = HintIntervalMin * 60.0

-----------------------------------------------------------------------------------------

function hints.getNextHint()
	local game = require("api.game")
	
	if game.data.currentChapter == "chapter1" then
		if not game.events.isTriggered("boys_locker_room.scare1_start") then
			return { name="scare1_start", text=i18n._"Hint.Gym.TryToLeaveLockers" }
		
		elseif not game.events.isTriggered("boys_locker_room.scare1") then
			return { name="scare1", text=i18n._"Hint.Gym.HideFromShade" }
			
		elseif not game.puzzles.hasFinished("boys_locker_room_letter") then
			return { name="boys_locker_room_letter", text=i18n._"Hint.Gym.Letter" }
		
		elseif not game.events.isTriggered("boys_hallway.newspaper") then
			return { name="boys_hallway_newspaper", text=i18n._"Hint.Gym.BoysHallwayNewspaper" }
			
		elseif not game.events.isTriggered("basketball_court.newspaper") then
			return { name="basketball_court_newspaper", text=i18n._"Hint.Gym.BasketballNewspaper" }
			
		elseif not game.inventory.hasPickedUpItem("VandalizedPhoto") then
			return { name="vandalized_photo", text=i18n._"Hint.Gym.PickUpVandalizedPhoto" }
		
		elseif not game.journal.hasEntry("Gym.DexterLock") then
			return { name="dexter_lock_hint", text=i18n._"Hint.Gym.DexterLockHint" }
		
		elseif not game.puzzles.hasFinished("locker_dexter_lock") then
			return { name="locker_dexter_lock", text=i18n._"Hint.Gym.OpenDexterLocker" }
			
		elseif not game.inventory.hasPickedUpItem("StorageKey") then
			return { name="storage_key", text=i18n._"Hint.Gym.PickUpStorageKey" }
			
		elseif not game.events.isTriggered("basketball_court.storage_door_unlocked") then
			return { name="storage_room_door", text=i18n._"Hint.Gym.OpenStorageRoomDoor" }		
			
		elseif not game.inventory.hasPickedUpItem("Ladder") then
			return { name="ladder", text=i18n._"Hint.Gym.PickUpLadder" }
			
		elseif not game.events.isTriggered("basketball_court.ladder_placed") then
			return { name="ladder_placed", text=i18n._"Hint.Gym.PlaceLadderUnderHoop" }
			
		elseif not game.journal.hasEntry("Gym.WillLock") then
			return { name="will_journal_inspect", text=i18n._"Hint.Gym.InspectWillJournal" }
			
		elseif not game.puzzles.hasFinished("locker_will_lock") then
			return { name="locker_will_lock", text=i18n._"Hint.Gym.LockerWillLock" }
		
		elseif not game.inventory.hasPickedUpItem("Rose") then
			return { name="rose", text=i18n._"Hint.Gym.PickUpRose" }
			
		elseif not game.events.isTriggered("will.toilet") then
			return { name="rose_delivered", text=i18n._"Hint.Gym.DeliverRose" }
			
		elseif game.events.isTriggered("will.toilet") and not game.events.isTriggered("will.toilet.out") and not game.events.isTriggered("will.toilet.ask_help") then
			return { name="will.toilet.ask_help", text=i18n._"Hint.Gym.VisitWillInToilets" }
					
		elseif not game.inventory.hasPickedUpItem("ToiletPaper") then
			return { name="toilet_paper", text=i18n._"Hint.Gym.PickUpToiletPaper" }
			
		elseif not game.inventory.hasDiscardedItem("ToiletPaper") then
			return { name="toilet_paper", text=i18n._"Hint.Gym.DeliverToiletPaper" }
			
		elseif not game.events.isTriggered("gave_robot_back_to_will") then
			return { name="gave_robot_back_to_will", text=i18n._"Hint.Gym.DeliverRobot" }
			
		elseif not game.puzzles.hasFinished("locker_miranda_lock") then
			return { name="locker_miranda_lock", text=i18n._"Hint.Gym.LockerMirandaLock" }
		
		elseif not game.inventory.hasPickedUpItem("PoweredRobot") then
			return { name="battery", text=i18n._"Hint.Gym.PickUpBattery" }
			
		elseif not game.inventory.hasPickedUpItem("Apple") then
			return { name="apple", text=i18n._"Hint.Gym.PickUpApple" }
			
		elseif not game.inventory.hasPickedUpItem("Mirror") then
			return { name="mirror", text=i18n._"Hint.Gym.PickUpMirror" }
			
		elseif not game.events.isTriggered("gym.locker_miranda.newspaper") then
			return { name="gym.locker_miranda.newspaper", text=i18n._"Hint.Gym.MirandaNewspaper" }
		
		elseif not game.inventory.hasPickedUpItem("ChestSquareCrest") then
			return { name="square_crest", text=i18n._"Hint.Gym.PickUpSquareCrest" }
		
		elseif not game.journal.hasEntry("Gym.BowlPhoto") then
			return { name="bowl_photo", text=i18n._"Hint.Gym.BowlPhoto" }
		
		elseif not game.puzzles.hasFinished("boys_toilet_left") then
			return { name="boys_toilet_left", text=i18n._"Hint.Gym.BoysToiletLeft" }
		
		elseif not game.inventory.hasPickedUpItem("ChestRoundCrest") then
			return { name="round_crest", text=i18n._"Hint.Gym.PickUpRoundCrest" }
		
		elseif not game.inventory.hasPickedUpItem("CrankHandle") then
			return { name="crank_handle", text=i18n._"Hint.Gym.PickUpCrankHandle" }
		
		elseif not game.puzzles.hasFinished("trophy_lock") then
			return { name="trophy_lock", text=i18n._"Hint.Gym.TrophyLock" }				
		
		elseif not game.inventory.hasPickedUpItem("ToiletHandle") then
			return { name="toilet_handle", text=i18n._"Hint.Gym.PickUpToiletHandle" }
			
		elseif not game.events.isTriggered("gym.toilet_handle") then
			return { name="toilet_handle_placed", text=i18n._"Hint.Gym.PlaceToiletHandle" }
			
		elseif not game.events.isTriggered("boys_bathroom.toilet_flushed") then
			return { name="toilet_flushed", text=i18n._"Hint.Gym.FlushToilet" }
			
		elseif not game.inventory.hasPickedUpItem("PoolPumpPipe") then
			return { name="pool_pump_pipe", text=i18n._"Hint.Gym.PickUpPoolPumpPipe" }
			
		elseif not game.events.isTriggered("gym.pool_pump_pipe") then
			return { name="pool_pump_pipe_placed", text=i18n._"Hint.Gym.PlacePoolPumpPipe" }
			
		elseif not game.events.isTriggered("gym.pool_pump_activated") then
			return { name="pool_pump_activated", text=i18n._"Hint.Gym.ActivatePoolPump" }
			
		elseif not game.inventory.hasPickedUpItem("Crowbar") then
			return { name="crowbar", text=i18n._"Hint.Gym.PickUpCrowbar" }
			
		elseif not game.events.isTriggered("jason_locker_pried") then
			return { name="jason_locker_pried", text=i18n._"Hint.Gym.UseCrowbar" }
			
		elseif not game.events.isTriggered("jason_locker_robot_placed") then
			return { name="jason_locker_robot_placed", text=i18n._"Hint.Gym.UseRobot" }
			
		elseif game.events.isTriggered("boys_locker_room.shade_baited") and not game.events.isTriggered("boys_locker_room.shade_baited_done") then
			return { name="shade_baited", text=i18n._"Hint.Gym.HideFromShade" }
			
		elseif not game.inventory.hasPickedUpItem("Trophy") then
			return { name="trophy", text=i18n._"Hint.Gym.PickUpTrophy" }
		
		elseif not game.inventory.hasPickedUpItem("RobotHead") then
			return { name="robot_head", text=i18n._"Hint.Gym.PickUpRobotHead" }
			
		elseif not game.events.isTriggered("gym.locker_jason.newspaper") then
			return { name="gym.locker_jason.newspaper", text=i18n._"Hint.Gym.JasonNewspaper" }
			
		elseif not game.events.isTriggered("trophy_placed") then
			return { name="trophy_placed", text=i18n._"Hint.Gym.PlaceTrophy" }
			
		elseif not game.inventory.hasPickedUpItem("Coin") then
			return { name="coin", text=i18n._"Hint.Gym.PickUpCoin" }
		
		elseif not game.inventory.hasPickedUpItem("Pillow") then
			return { name="pillow", text=i18n._"Hint.Gym.PickUpPillow" }
		
		elseif not game.journal.hasEntry("Gym.Bricks") then
			return { name="bricks", text=i18n._"Hint.Gym.BricksJournal" }
		
		elseif not game.puzzles.hasFinished("principal_den_portrait") then
			return { name="principal_den_portrait", text=i18n._"Hint.Gym.PrincipalDenPortrait" }
			
		elseif not game.inventory.hasDiscardedItem("Coin") then
			return { name="vending_machine", text=i18n._"Hint.Gym.VendingMachine" }
		
		elseif not game.inventory.hasPickedUpItem("Chips") then
			return { name="coin", text=i18n._"Hint.Gym.PickUpChips" }
			
		elseif not game.inventory.hasPickedUpItem("ChestHexCrest") then
			return { name="hex_crest", text=i18n._"Hint.Gym.PickUpHexCrest" }
		
		elseif not game.events.isTriggered("gym.storage_room.chest_open") then
			return { name="storage_chest", text=i18n._"Hint.Gym.StorageChest" }
		
		elseif not game.inventory.hasPickedUpItem("ChestKey") then
			return { name="hex_crest", text=i18n._"Hint.Gym.PickUpChestKey" }
			
		elseif not game.events.isTriggered("principal_attic.chest_open") then
			return { name="attic_chest", text=i18n._"Hint.Gym.AtticChest" }
			
		elseif not game.inventory.hasPickedUpItem("Treasure") then
			return { name="hex_crest", text=i18n._"Hint.Gym.PickUpTreasure" }
		
		elseif not game.puzzles.hasFinished("principal_den_wall") then
			return { name="principal_den_wall", text=i18n._"Hint.Gym.PrincipalDenWall" }
		
		elseif not game.puzzles.hasFinished("water_heater") then
			return { name="water_heater", text=i18n._"Hint.Gym.WaterHeater" }
		
		elseif not game.events.isTriggered("gym.hot_water_enabled") then
			return { name="hot_water_pipes", text=i18n._"Hint.Gym.HotWaterPipes" }
			
		elseif not game.events.isTriggered("ritual_room.anger") then
			return { name="statue_anger", text=i18n._"Hint.Gym.PlaceStatueAnger" }
		
		elseif not game.events.isTriggered("ritual_room.envy") then
			return { name="statue_envy", text=i18n._"Hint.Gym.PlaceStatueEnvy" }
			
		elseif not game.events.isTriggered("ritual_room.pride") then
			return { name="statue_pride", text=i18n._"Hint.Gym.PlaceStatuePride" }
			
		elseif not game.events.isTriggered("ritual_room.greed") then
			return { name="statue_greed", text=i18n._"Hint.Gym.PlaceStatueGreed" }
			
		elseif not game.events.isTriggered("ritual_room.gluttony") then
			return { name="statue_gluttony", text=i18n._"Hint.Gym.PlaceStatueGluttony" }
			
		elseif not game.events.isTriggered("ritual_room.lust") then
			return { name="statue_lust", text=i18n._"Hint.Gym.PlaceStatueLust" }
			
		elseif not game.events.isTriggered("ritual_room.sloth") then
			return { name="statue_sloth", text=i18n._"Hint.Gym.PlaceStatueSloth" }
			
		elseif not game.inventory.hasPickedUpItem("ShowerHandle") then
			return { name="get_shower_handle", text=i18n._"Hint.Gym.PickUpShowerHandle" }
			
		elseif not game.events.isTriggered("gym.sink.hidden_message") then
			return { name="sink_message", text=i18n._"Hint.Gym.SinkMessage" }
		
		elseif not game.journal.hasEntry("Gym.Mirror") then
			return { name="mirror", text=i18n._"Hint.Gym.Mirror" }
			
		elseif not game.events.isTriggered("gym.showers.diamond_placed") then
			return { name="place_shower_handle", text=i18n._"Hint.Gym.PlaceShowerHandle" }
			
		elseif not game.puzzles.hasFinished("boys_showers") then
			return { name="gym_showers", text=i18n._"Hint.Gym.Showers" }
			
		elseif not game.puzzles.hasFinished("boys_showers_tiles") then
			return { name="gym_showers_tiles", text=i18n._"Hint.Gym.ShowersTiles" }
		
		elseif not game.events.isTriggered("gameover") then
			return { name="gameover", text=i18n._"Hint.Gym.EnterGate" }
		end
	end
	
	return { name="none", text="The future is cloudy, I cannot see anything." }
end

-----------------------------------------------------------------------------------------

function hints.getLastHint()
	local game = require("api.game")
	return game.state.get("hints.last", nil)
end

-----------------------------------------------------------------------------------------

function hints.setLastHint(hint)
	if type(hint) == "table" then
		hint = hint.name
	end
	
	local game = require("api.game")
	return game.state.set("hints.last", hint)
end

-----------------------------------------------------------------------------------------

function hints.isSameNextHint()
	local lastHint = hints.getLastHint()
	if lastHint then
		local nextHint = hints.getNextHint()
		if nextHint then
			return nextHint.name == lastHint
		end
	end
	
	return false
end

-----------------------------------------------------------------------------------------

function hints.getPercentReady()
	return (HintInterval - hints.getTimeLeft()) / HintInterval
end

-----------------------------------------------------------------------------------------

function hints.resumeTimer()
	hints.suspendTimer()
	hints.startTime = os.time()
end

-----------------------------------------------------------------------------------------

function hints.suspendTimer()
	if hints.startTime then
		local game = require("api.game")
		game.state.set("hints.timer", hints.getTimeLeft())
		
		hints.startTime = nil
	end
end

-----------------------------------------------------------------------------------------

function hints.resetTimer()
	hints.suspendTimer()
	local game = require("api.game")
	game.state.set("hints.timer", HintInterval)
	hints.resumeTimer()
end

-----------------------------------------------------------------------------------------

function hints.getTimeLeft()
	if game.purchases.isHintsUnlocked() then
		return 0
	elseif hints.startTime then
		local endTime = os.time()
		local span = endTime - hints.startTime

		local game = require("api.game")
		local currentTime = game.state.get("hints.timer", 0)
		local newTime = currentTime - span
		if newTime < 0 then
			newTime = 0
		end
		return newTime
	else
		return 0
	end
end

-----------------------------------------------------------------------------------------

function hints.isReady()
	return hints.getTimeLeft() == 0
end

-----------------------------------------------------------------------------------------

return hints

-----------------------------------------------------------------------------------------
