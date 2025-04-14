-----------------------------------------------------------------------------------------

local journal = {}

-----------------------------------------------------------------------------------------

local entries = {
	{
		name = "Lou.Page1", 
		text1 = i18n._"Journal.Lou.Page1.A", text2 = i18n._"Journal.Lou.Page1.B"
	},
	{
		name = "Cutouts", 
	},
	{
		name = "Gym.Letter", 
		imageFile = "shelf_lock_solution.png",
		x = 75, y = 40, w = 424, h = 292
	},
	{
		name = "Gym.Mirror", 
		imageFile = "shower_puzzle_solution.png",
		x = 80, y = 39, w = 411, h = 282
	},
	{
		name = "Gym.Shower", 
		imageFile = "gym_shower.jpg"
	},
	{
		name = "Gym.MirandaLock", 
		imageFile = "lock_puzzle_solution.png",
		x = 113, y = 20, w = 344, h = 328
	},
	{
		name = "Gym.WillLock", 
		imageFile = "stars_puzzle_solution.png",
		x = 58, y = 14, w = 454, h = 332
	},
	{
		name = "Gym.DexterLock", 
		imageFile = "dexter_puzzle_solution.png",
		x = 104, y = 53, w = 386, h = 268
	},
	{
		name = "Gym.Adam&Eve", 
		imageFile = "lust_hint.png",
		x = 69, y = 40, w = 417, h = 316
	},
  {
		name = "Gym.BowlPhoto", 
		imageFile = "planks_puzzle_solution.png",
		x = 76, y = 34, w = 410, h = 293
	},
	{
		name = "Gym.Bricks", 
		imageFile = "brick_puzzle_solution.png",
		x = 95, y = 69, w = 364, h = 243
	},
	
	{
		name = "Will.Page1", 
		text1 = i18n._"Journal.Will.Page1.A", text2 = i18n._"Journal.Will.Page1.B"
	},
	
	{
		name = "Miranda.Page1", 
		text1 = i18n._"Journal.Miranda.Page1.A", text2 = i18n._"Journal.Miranda.Page1.B"
	},
	
	{
		name = "Popenoe.Page1", 
		text1 = i18n._"Journal.Popenoe.Page1.A", text2 = i18n._"Journal.Popenoe.Page1.B"
	},
	
	{
		name = "Popenoe.Ritual", 
		imageFile = "principal_notes.png",
		x = 62, y = 40, w = 447, h = 308,
		text1 = i18n._"Journal.Popenoe.Page2.A", text2 = i18n._"Journal.Popenoe.Page2.B"
	},
}

-----------------------------------------------------------------------------------------

local entryMap = {}

for entry in list_iter(entries) do
	entryMap[entry.name] = entry
end

-----------------------------------------------------------------------------------------

local function getJournalKeyName(player)
	local keyName = "journal.entries"
	if player then
		keyName = player .. "." .. keyName
	end
	return keyName
end

function journal.getEntriesFor(player)
	local game = require("api.game")	
	local keyName = getJournalKeyName(player)
	local entries = game.state.get(keyName, {})
	return entries
end

-----------------------------------------------------------------------------------------

function journal.getEntries()
	local game = require("api.game")
	return journal.getEntriesFor(game.data.currentPlayer)
end

-----------------------------------------------------------------------------------------

local function setEntriesFor(player, entries)
	local game = require("api.game")
	local keyName = getJournalKeyName(player)
	game.state.set(keyName, entries)
	return entries
end

local function setEntries(entries)
	setEntriesFor(game.data.currentPlayer, entries)
end

-----------------------------------------------------------------------------------------

local function hasEntry(player, name)
	local entries = journal.getEntriesFor(player)
	for entry in list_iter(entries) do
		if name == entry then
			return true
		end
	end
	return false
end

function journal.hasEntry(name)
	local game = require("api.game")
	return hasEntry(game.data.currentPlayer, name)
end

-----------------------------------------------------------------------------------------

function journal.addEntryFor(player, name)
	if not hasEntry(player, name) then		
		local entries = journal.getEntriesFor(player)
		table.insert(entries, name)
		setEntriesFor(player, entries)
	end	
end

-----------------------------------------------------------------------------------------

function journal.addEntry(name)
	local game = require("api.game")
	journal.addEntryFor(game.data.currentPlayer, name)
end

-----------------------------------------------------------------------------------------

function journal.recordEntry(name)
	local game = require("api.game")
	if game.inventory.hasItem("Journal") then
		if not journal.hasEntry(name) then
			journal.addEntry(name)
			game.inventory.onNewJournalEntry()
		end
	end
end

-----------------------------------------------------------------------------------------

function journal.clearEntries()
	setEntries({})
end

-----------------------------------------------------------------------------------------

function journal.findEntry(name)
	return entryMap[name]
end

-----------------------------------------------------------------------------------------

local cutouts = {
	"title",
	"popenoe",
	"missing_children",
	"miranda_will",
	"lou"
}

function journal.addNextCutout()
	local game = require("api.game")
	local index = game.state.get("newspaper.last", 0) + 1
	if index <= #cutouts then
		if index == #cutouts then
			game.achievements.unlock("all_newspaper")
		end
		game.state.set("newspaper.last", index)		
		journal.addCutout(cutouts[index])
	end
end

function journal.addCutout(name)
	local game = require("api.game")
	game.events.trigger("newspaper." .. name)
	if not journal.hasEntry("Cutouts") then
		journal.addEntry("Cutouts")
	end
	game.scenes.gotoJournal(nil, "Cutouts", name)
	--game.inventory.onNewJournalEntry()
end

-----------------------------------------------------------------------------------------

return journal

-----------------------------------------------------------------------------------------
