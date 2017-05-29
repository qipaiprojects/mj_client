
local M = {}

local function serialize (obj)
	local lua = ""  
    local t = type(obj)  
    if t == "number" then  
        lua = lua .. obj  
    elseif t == "boolean" then  
        lua = lua .. tostring(obj)  
    elseif t == "string" then  
        lua = lua .. string.format("%q", obj)  
    elseif t == "table" then  
        lua = lua .. "{"
    	for k, v in pairs(obj) do  
        	lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","  
    	end  
    	local metatable = getmetatable(obj)  
        if metatable ~= nil and type(metatable.__index) == "table" then  
        	for k, v in pairs(metatable.__index) do  
            	lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","  
        	end
		end
        lua = lua .. "}"  
    elseif t == "nil" then  
        return "nil"  
    elseif t == "userdata" then
		return "userdata"
	elseif t == "function" then
		return "function"
	else  
        error("can not serialize a " .. t .. " type.")
    end  
    return lua
end

M.table_2_str = serialize

function M.str_2_table(str)
	local func_str = "return "..str
    local func = load(func_str)
	return func()
end

function M.int16_2_bytes(num)
	local high = math.floor(num/256)
	local low = num % 256
	return string.char(high) .. string.char(low)
end

function M.bytes_2_int16(bytes)
	local high = math.byte(bytes,1)
	local low = math.byte(bytes,2)
	return high*256 + low
end

return M