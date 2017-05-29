local M = class("UpCards", function() 
	return cc.Layer:create() 
end)

function M:ctor()
end

function M:setCards(data)
	-- 站立的牌
	self.standCards = {}
	for _,v in ipairs(data.standCards) do
		local card = 
	end
end

return M