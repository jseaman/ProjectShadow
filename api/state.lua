-----------------------------------------------------------------------------------------

local state = {}

-----------------------------------------------------------------------------------------

function state.getData()
	local game = require("api.game")
	return game.data
end

-----------------------------------------------------------------------------------------

function state.set(name, value)
	local game = require("api.game")
	value = value or true
	game.data.values = game.data.values or {}
	game.data.values[name] = value
	game.markAsChanged()
end

-----------------------------------------------------------------------------------------

function state.unset(name)
	local game = require("api.game")
	game.data.values = game.data.values or {}
	game.data.values[name] = nil
	game.markAsChanged()
end

-----------------------------------------------------------------------------------------

function state.isSet(name)
	local game = require("api.game")
	game.data.values = game.data.values or {}
	return game.data.values[name] ~= nil
end

-----------------------------------------------------------------------------------------

function state.get(name, default)
	local game = require("api.game")
	game.data.values = game.data.values or {}
	if state.isSet(name) then
		return game.data.values[name]
	else
		if default ~= nil then
			state.set(name, default)
		end
		return default
	end
end

-----------------------------------------------------------------------------------------

return state

-----------------------------------------------------------------------------------------
