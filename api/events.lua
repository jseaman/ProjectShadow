-----------------------------------------------------------------------------------------

local game = require("api.game")

-----------------------------------------------------------------------------------------

local events = {}

-----------------------------------------------------------------------------------------

function events.isTriggered(event)
	local game = require("api.game")
	if game.data.events then
		local existingEvent
		for existingEvent in list_iter(game.data.events) do
			if event == existingEvent then
				return true
			end
		end
	end
	return false
end

-----------------------------------------------------------------------------------------

function events.trigger(event)
	local game = require("api.game")
	if not game.data.events then
		game.data.events = {}
	end
	if not events.isTriggered(event) then
		table.insert(game.data.events, event)
		game.markAsChanged()
	end
end

-----------------------------------------------------------------------------------------

return events

-----------------------------------------------------------------------------------------