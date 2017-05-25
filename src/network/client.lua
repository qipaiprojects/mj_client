local Socket = require "socket"
local Packer = require "network.packer"

local M = {}

M.__index = M

function M.new(...)
    local o = {}
	setmetatable(o, M)
	M.init(o, ...)
	return o
end

function M:init()
	self.last = ""
	self.pack_list = {}
	self.head = nil
end

function M:connect(ip, port)
   self.ip = ip
   self.port = port
   local sock = socket.tcp()
   local n,e = sock:connect(ip, port)
   sock:settimeout(0)
   self.sock = sock
end

function M:send(proto_name, msg)
   print("send msg", proto_name)
   local packet = Packer.pack(proto_name, msg)
   self.sock:send(packet)
end

function M:deal_one()
	self:recv()
	self:split_pack()
	self:dispatch_one()
end

function M:recv()
	local reads, writes = socket.select({self.sock}, {}, 0)
	if #reads == 0 then
		print("no reads")
		return
	end

	-- 读包头,两字节长度
	if #self.last < 2 then
		local r, s = self.sock:receive(2 - #self.last)
		if s == "closed" then
			self:on_close()
			return
		end
			
		if not r then
			return
		end
		
		self.last = self.last .. r
		if #self.last < 2 then
			return
		end
	end
	
	local len = self.last:byte(1) * 256 + self.last:byte(2)
	
	local r, s = self.sock:receive(len + 2 - #self.last)
	if s == "closed" then
		self:on_close()
		return
	end
	
	if not r then
		return
	end
	
	self.last = self.last .. r
	if #self.last < 2 then
		return
	end
		
    if not r then
		print("socket empty", s)
        return
    end

    print("recv data", #r)
end

function M:split_pack()
	local last = self.last
    local len
    repeat
        if #last < 2 then
            break
        end
        len = last:byte(1) * 256 + last:byte(2)
        if #last < len + 2 then
            break
        end
        table.insert(self.pack_list, last:sub(3, 2 + len))
        last = last:sub(3 + len) or ""
    until(false)
	self.last = last
end

function M:dispatch_one()
	if not next(self.pack_list) then
		return
	end
	local data = table.remove(self.pack_list, 1)
	print("split pack",#data)
	local proto_name, params = Packer.unpack(data)
	print("recv msg", proto_name)
end

function M:close()

end

function M:on_close()

end

return M
