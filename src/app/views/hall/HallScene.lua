local M = class("HallScene", cc.load("mvc").ViewBase)

function M:ctor()
	self.frameSize = cc.Director:getInstance():getWinSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
	self:init()
end

function M:init()
	self:initBgLayer()
	
	self:initItems()
end

function M:initBgLayer()
	local bgLayer = cc.Layer:create()

	local bg = cc.Sprite:create("hall_bg.jpg")
	bg:setAnchorPoint(cc.p(0.5, 0.5))
    bg:setPosition(self.frameSize.width/2, self.frameSize.height/2)
    bgLayer:addChild(bg)
	
	-- 头像背景
	--local headBg = cc.Sprite:create("head_bg.png")
    --headBg:setPosition(190, self.frameSize.height-90)
    --bg:addChild(headBg)
	
	-- 昵称
	local nameLabel = cc.Label:createWithSystemFont("昵称：请叫我雷峰", "arial", 24)
    nameLabel:setColor(ccc3(255,255,255))
	nameLabel:setAnchorPoint(0,1)
	nameLabel:setPosition(100, self.frameSize.height-15)
	bg:addChild(nameLabel)
	
	-- 积分
	local scoreLabel = cc.Label:createWithSystemFont("积分：100", "arial", 24)
    scoreLabel:setColor(ccc3(255,255,255))
	scoreLabel:setAnchorPoint(0,1)
	scoreLabel:setPosition(100, self.frameSize.height-45)
	bg:addChild(scoreLabel)
	
	-- 房卡数量
	local cardNumLabel = cc.Label:createWithSystemFont("房卡:  10张", "arial", 24)
    cardNumLabel:setColor(ccc3(255,255,255))
	cardNumLabel:setAnchorPoint(0,1)
	cardNumLabel:setPosition(100, self.frameSize.height-75)
	bg:addChild(cardNumLabel)

	-- 女人
	local woman = cc.Sprite:create("girl.png")
	woman:setAnchorPoint(cc.p(0.5, 0.5))
    woman:setPosition(self.frameSize.width/2 - 150, self.frameSize.height/2)
    bg:addChild(woman)
	
	-- 房间按钮
	local room1Btn = ccui.Button:create("matchRoomRankBg.png")
	room1Btn:setAnchorPoint(cc.p(0.5, 0.5))
    room1Btn:setPosition(self.frameSize.width/2 + 280, self.frameSize.height - 150)
    room1Btn:setTitleText("四川麻将")
	room1Btn:setTitleFontSize(35)
	bg:addChild(room1Btn)
	
	-- 广东房间
	local room2Btn = ccui.Button:create("matchRoomRankBg.png")
	room2Btn:setAnchorPoint(cc.p(0.5, 0.5))
    room2Btn:setPosition(self.frameSize.width/2 + 280, self.frameSize.height - 250)
    room2Btn:setTitleText("广东麻将")
	room2Btn:setTitleFontSize(35)
	bg:addChild(room2Btn)
	
	-- 江西房间
	local room3Btn = ccui.Button:create("matchRoomRankBg.png")
	room3Btn:setAnchorPoint(cc.p(0.5, 0.5))
    room3Btn:setPosition(self.frameSize.width/2 + 280, self.frameSize.height - 350)
    room3Btn:setTitleText("江西麻将")
	room3Btn:setTitleFontSize(35)
	bg:addChild(room3Btn)
	
	-- 湖南麻将
	local room4Btn = ccui.Button:create("matchRoomRankBg.png")
	room4Btn:setAnchorPoint(cc.p(0.5, 0.5))
    room4Btn:setPosition(self.frameSize.width/2 + 280, self.frameSize.height - 450)
    room4Btn:setTitleText("湖南麻将")
	room4Btn:setTitleFontSize(35)
	bg:addChild(room4Btn)
	
	
	self:addChild(bgLayer)
end

function M:initItems()
    
end

return M