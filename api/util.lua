-----------------------------------------------------------------------------------------

local M = {}

-----------------------------------------------------------------------------------------

M.timerList = {}

-----------------------------------------------------------------------------------------

function M.newTransition(tag, object, options)
	options.tag = tag
	return transition.to(object, options)
end
	
function M.trackTimer(tag, t)
	local list = M.timerList[tag] or {}
	table.insert(list, t)
	M.timerList[tag] = list
	return t
end
	
function M.newTimer(tag, delay, handler, times)
	return M.trackTimer(tag, timer.performWithDelay(delay, handler, times))
end
	
function M.cancelObjects(tag)
	transition.cancel(tag)
		
	local list = M.timerList[tag] or {}
	for t in list_iter(list) do
		game.ui.cancelTimer(t)
	end
	M.timerList[tag] = {}
end	

-----------------------------------------------------------------------------------------

return M

-----------------------------------------------------------------------------------------
