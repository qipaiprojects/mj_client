local M = class("TableScene",function ()
    return cc.Scene:create()
end)

function M:ctor()
	self.frameSize = cc.Director:getInstance():getWinSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
	self:init()
    print(">>>>>>>>>>>>>1")
end

function M:init()
	self:initBgLayer()
	
	self:initItems()
end

function M:initBgLayer()
	local bgLayer = cc.Layer:create()

	print(self.frameSize.width/2, self.frameSize.height/2)
	local bg = cc.Sprite:create("table.jpg")
	bg:setAnchorPoint(cc.p(0.5, 0.5))
    bg:setPosition(self.frameSize.width/2, self.frameSize.height/2)
    bgLayer:addChild(bg)
	
	self:addChild(bgLayer)
end

function M:initItems()
    
end

return M