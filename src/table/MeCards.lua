local M = class("player", function() 
	return cc.Layer:create() 
end)

function M:ctor()
	self:init()
end

function M:init()
end

return M