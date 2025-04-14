-----------------------------------------------------------------------------------------

local json = require("json")

-----------------------------------------------------------------------------------------

function unrequire(m)
	package.loaded[m] = nil
	_G[m] = nil
 	
	local registry = debug.getregistry()
	local nMatches, mKey, mt = 0, nil, registry['_LOADLIB']
	
	for key, ud in pairs(registry) do
		if type(key) == 'string' and type(ud) == 'userdata' and getmetatable(ud) == mt and string.find(key, "LOADLIB: .*" .. m) then
			nMatches = nMatches + 1
			if nMatches > 1 then
				return false, "More than one possible key for module '" .. m .. "'. Can't decide which one to erase."
			end
			mKey = key
		end
	end
	
	if mKey then
		registry[mKey] = nil
	end
	
	return true
end

-----------------------------------------------------------------------------------------

function isModuleAvailable(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == 'function' then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

-----------------------------------------------------------------------------------------

function optionalParam(param, defaultValue)
	if param == nil then
		return defaultValue
	else
		return param
	end
end

-----------------------------------------------------------------------------------------

function string.startsWith(s, sub)
	return string.sub(s, 1, string.len(sub)) == sub
end

-----------------------------------------------------------------------------------------

function string.wordCount(s)
	local count = 0
	for k, v in string.gmatch(s, "%s+") do
		count = count + 1
	end
	return count
end

-----------------------------------------------------------------------------------------

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function table.keys_length(t)
	local count = 0
  for k,v in pairs(t) do
    count = count + 1
  end
  return count
end

function table.asJson(t)
  local json = require("json")
	return json.encode(t)
end

-----------------------------------------------------------------------------------------

function io.getFileContents(filename, base)
	if not base then base = system.ResourceDirectory; end
	
	local path = system.pathForFile(filename, base)
	local contents
	
	local file = io.open(path, "r")
	if file then
		contents = file:read("*a")
		io.close(file)
	else
		print("I/O: Couldn't open file for reading.")
	end
	
	return contents
end

-----------------------------------------------------------------------------------------

function io.getFileContentsAsJson(filename, base)
	local contents = io.getFileContents(filename, base)
	if contents then
		return json.decode(contents)
	else
		return nil
	end
end

-----------------------------------------------------------------------------------------

function io.writeFileAsJson(data, filename, base)
	if not base then base = system.ResourceDirectory; end
	
	local json = require("json")
	local jsonString = json.encode(data)
	local path = system.pathForFile(filename, base)
	
	local file = io.open(path, "w")
	if file then
		file:write(jsonString)
		io.close(file)
		file = nil
	else
		print("I/O: Couldn't open file for writing.")
	end
end

-----------------------------------------------------------------------------------------

function list_iter(t)
	local i = 0
	local n = table.getn(t)
	return function ()
		i = i + 1
		if i <= n then return t[i] end
	end
end

-----------------------------------------------------------------------------------------

function encodeTable(t)
	local result = ""
	for k,v in pairs(t) do
		if string.len(result) > 0 then
			result = result .. ","
		end
		result = result .. "[\"" .. k .. "\"]=" .. v
	end
	return result
end

-----------------------------------------------------------------------------------------

function urlencode(str)
   if (str) then
      str = string.gsub(str, "\n", "\r\n")
      str = string.gsub(str, "([^%w ])",
         function (c) return string.format("%%%02X", string.byte(c)) end)
      --str = string.gsub(str, " ", "+")
   end
   return str    
end

-----------------------------------------------------------------------------------------

local meta = {}
function meta:__index(k) return k end
function PositiveIntegers() return setmetatable({}, meta) end

-----------------------------------------------------------------------------------------

function permute(tab, n, count)
  n = n or #tab
  for i = 1, count or n do
    local j = math.random(i, n)
    tab[i], tab[j] = tab[j], tab[i]
  end
  return tab
end

-----------------------------------------------------------------------------------------
 
function lotto(count, range)
	return {unpack(
               permute(PositiveIntegers(), range, count),
               1, count)
            }
end


-----------------------------------------------------------------------------------------
