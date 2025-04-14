-----------------------------------------------------------------------------------------

local audio = require("audio")
local game = require("api.game")

-----------------------------------------------------------------------------------------

local stage = {}

-----------------------------------------------------------------------------------------

stage.BackgroundMusicChannel = 1
stage.AmbienceMusicChannel = 3

-----------------------------------------------------------------------------------------

function stage.initialize()
	audio.reserveChannels(3)
	stage.loadCommonSounds()
end

-----------------------------------------------------------------------------------------

local function adjustAudioFileName(fileName)
	if device.isWinPhone then		
		fileName = fileName:gsub(".mp3", "")
		fileName = fileName .. ".ogg"
	else
		fileName = fileName:gsub(".mp3", "")
		fileName = fileName .. ".mp3"
	end
	return fileName
end

function stage.loadSound(fileName)	
	return audio.loadSound(adjustAudioFileName(fileName))
end

-----------------------------------------------------------------------------------------

function stage.loadStream(fileName)
	return audio.loadStream(adjustAudioFileName(fileName))
end

-----------------------------------------------------------------------------------------

function stage.dispose(handle)
	if handle then
		audio.dispose(handle)
	end
	return nil
end

-----------------------------------------------------------------------------------------

function stage.stopBackgroundMusic(fadeTime)
	if audio.isChannelActive(stage.BackgroundMusicChannel) then
		if fadeTime then
			audio.fadeOut({ channel = stage.BackgroundMusicChannel, time = fadeTime })
		else
			audio.stop(stage.BackgroundMusicChannel)
		end
	end
	stage._backgroundMusicFile = nil
	stage._backgroundMusicHandle = nil
end

-----------------------------------------------------------------------------------------

function stage.getDefaultMusicVolume()
	if game.data == nil or game.data.settings == nil or game.data.settings.musicVolume == nil then
		return 0.5
	else
		return game.data.settings.musicVolume
	end
end

function stage.setBackgroundMusic(handle, fadeTime, volume)
	volume = volume or stage.getDefaultMusicVolume()
	
	local musicFile = nil
	if type(handle) == "string" then
		if not stage._backgroundMusicHandle or not stage._backgroundMusicFile or stage._backgroundMusicFile ~= handle then
			musicFile = handle
			handle = stage.loadStream(handle)
		else
			handle = stage._backgroundMusicHandle
		end
	end
	
	if not stage._backgroundMusicHandle or stage._backgroundMusicHandle ~= handle then
		stage.stopBackgroundMusic()
		
		if stage.playMusic(handle, { channel = stage.BackgroundMusicChannel, loops = -1 }) then
      stage.fade({ channel = stage.BackgroundMusicChannel, time = fadeTime or 2000, volume = volume })
      stage._backgroundMusicHandle = handle
      stage._backgroundMusicFile = musicFile
    end
	end
end

-----------------------------------------------------------------------------------------

function stage.setChannelVolume(channel, volume)
	audio.setVolume(volume, { channel = channel })
end

-----------------------------------------------------------------------------------------

function stage.playAmbience(handle)
	stage._ambience = stage._ambience or {}
		
	if not stage._ambience[handle] then
		stage._ambience[handle] = true
		stage.play(handle, { channel = stage.AmbienceMusicChannel, loops = -1 }) 
	end
end

-----------------------------------------------------------------------------------------

function stage.pushAmbience(playFunction, stopFunction)
	playFunction()
	
	stage._ambienceStops = stage._ambienceStops or {}
	table.insert(stage._ambienceStops, stopFunction)
end

-----------------------------------------------------------------------------------------

function stage.clearAmbience()
	audio.stop(stage.AmbienceMusicChannel)
	stage._ambience = {}
	
	if stage._ambienceStops then
		local stopFunction
		for stopFunction in list_iter(stage._ambienceStops) do
			stopFunction()
		end
		stage._ambienceStops = {}
	end
end

-----------------------------------------------------------------------------------------

function stage.stopAll()
	stage.clearAmbience()
	stage.stopBackgroundMusic()
end

-----------------------------------------------------------------------------------------

function stage.playMusic(handle, options)	
	if handle and (game.data == nil or game.data.settings == nil or not game.data.settings.isMusicMuted) then
		return audio.play(handle, options)
	end
	return nil
end

-----------------------------------------------------------------------------------------

function stage.play(handle, options)
	if handle and (game.data == nil or game.data.settings == nil or not game.data.settings.isSoundMuted) then
		return audio.play(handle, options)
	end
	return nil
end

-----------------------------------------------------------------------------------------

function stage.playLooped(handle)
	return stage.play(handle, { loops = -1 })
end

-----------------------------------------------------------------------------------------

function stage.stop(channel)
	if channel then
		audio.stop(channel)
	end
	return nil
end

-----------------------------------------------------------------------------------------

function stage.fade(options)
	if not game.state.isMuted then
		return audio.fade(options)
	end
	return nil
end

-----------------------------------------------------------------------------------------

function stage.loadCommonSounds()
	stage.footstepsSound = stage.loadSound("assets/sounds/game/general/footsteps.mp3")
	--stage.successSound = stage.loadSound("assets/sounds/game/success.mp3")
	stage.doorLockedSound = stage.loadSound("assets/sounds/game/general/door_locked.mp3")
	stage.doorSound = stage.loadSound("assets/sounds/game/general/door_closing2.mp3")
	stage.itemSelectSound = stage.loadSound("assets/sounds/hud/item_select.mp3")
	stage.itemPickupSound = stage.loadSound("assets/sounds/hud/item_pickup2.mp3")
	stage.itemsOpenSound = stage.loadSound("assets/sounds/hud/items_open.mp3")
	stage.itemsNextPageSound = stage.loadSound("assets/sounds/hud/items_page.mp3")
	--stage.suspenseSound = stage.loadSound("assets/sounds/game/scary.mp3")
	stage.errorSound = stage.loadSound("assets/sounds/game/general/fail.mp3")
	stage.newJournalEntrySound = stage.loadSound("assets/sounds/hud/new_journal_entry.mp3")
	stage.backSound = stage.loadSound("assets/sounds/game/general/tick.mp3")
end

-----------------------------------------------------------------------------------------

function stage.loadSuccessSound()
	if not stage.successSound then
		stage.successSound = stage.loadSound("assets/sounds/game/success.mp3")
	end
end

function stage.playSuccessSound(options)
	stage.play(stage.successSound, options)
end

function stage.playFootsteps(options)
	stage.play(stage.footstepsSound, options)
end

-----------------------------------------------------------------------------------------

function stage.playBackSound(options)
	stage.play(stage.backSound, options)
end

-----------------------------------------------------------------------------------------

function stage.playGameMusic(scene, fadeTime)
	local streamFile = "assets/music/oppressive_gloom.mp3"
	--local streamFile  --TEMP: no ambience music
	local changeMusic = true
			
	if scene == "scene.credits" then
		streamFile = "assets/music/night_of_the_owl.mp3"
	elseif scene == "scene.finish" then
		streamFile = "assets/music/night_of_the_owl.mp3"
  elseif string.startsWith(scene, "scene.game.intro") then
    streamFile = "assets/music/horror_ambience.mp3"
	elseif string.startsWith(scene, "scene.game.outro") then
    streamFile = "assets/music/horror_ambience.mp3"
	elseif scene == "scene.menu" or scene == "scene.cover" then
		--streamFile = "assets/music/menu_ambient.mp3" --TODO: find music for menu
	elseif scene == "scene.game.gym.ritual_room" or scene == "scene.game.gym.ritual_room_statue" then
		--streamFile = "assets/music/baba_yaga.mp3"
		streamFile = "assets/music/night_of_the_owl.mp3"
	elseif scene == "scene.game.gym.boys_locker_room" or scene == "scene.game.gym.boys_lockers" 
		or scene == "scene.game.puzzles.gym.boys_locker_room_letter" or scene == "scene.game.gym.locker_lou_hide"
		or scene == "scene.game.gym.locker_lou_baited" then
		if (game.events.isTriggered("boys_locker_room.scare1_start") and not game.events.isTriggered("boys_locker_room.scare1"))
			or (game.events.isTriggered("boys_locker_room.shade_baited") and not game.events.isTriggered("boys_locker_room.shade_baited_done")) then
			streamFile = "assets/music/clash_defiant.mp3"
		end
	end
  
	if changeMusic then
		if streamFile then
			if not stage.gameMusicHandle or stage.gameMusicStreamFile ~= streamFile then
				stage.dispose(stage.gameMusicHandle)
				stage.gameMusicStreamFile = streamFile
				stage.gameMusicHandle = stage.loadStream(streamFile)
			end
			stage.setBackgroundMusic(stage.gameMusicHandle, fadeTime)
		else
			stage.dispose(stage.gameMusicHandle)
			stage.gameMusicHandle = nil
			stage.gameMusicStreamFile = nil
			stage.stopBackgroundMusic(200)
		end
	end
end

-----------------------------------------------------------------------------------------

return stage

-----------------------------------------------------------------------------------------
