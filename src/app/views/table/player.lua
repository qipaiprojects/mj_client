local M = class("Player", function (config)
    return cc.LayerColor:create(cc.c4b(0,0,0,180), 100, 150)
end)

function M:ctor()
	self:init()
end

function M:init()
	local bg = cc.Sprite:create("hall_bg.jpg")
	bg:setAnchorPoint(cc.p(0.5, 0.5))
    bg:setPosition(self.frameSize.width/2, self.frameSize.height/2)
    bgLayer:addChild(bg)
	
	-- Í·Ïñ±³¾°
	--local headBg = cc.Sprite:create("head_bg.png")
    --headBg:setPosition(190, self.frameSize.height-90)
    --bg:addChild(headBg)
	
	-- êÇ³Æ
	local nameLabel = cc.Label:createWithSystemFont("êÇ³Æ£ºÇë½ÐÎÒÀ×·å", "arial", 24)
    nameLabel:setColor(ccc3(255,255,255))
	nameLabel:setAnchorPoint(0,1)
	nameLabel:setPosition(100, self.frameSize.height-15)
	bg:addChild(nameLabel)
	
	-- »ý·Ö
	local scoreLabel = cc.Label:createWithSystemFont("»ý·Ö£º100", "arial", 24)
    scoreLabel:setColor(ccc3(255,255,255))
	scoreLabel:setAnchorPoint(0,1)
	scoreLabel:setPosition(100, self.frameSize.height-45)
	bg:addChild(scoreLabel)
end

return M