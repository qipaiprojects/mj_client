local spriteFrameCache = cc.SpriteFrameCache:getInstance()

local ResTab=
{
    {"Z_my.plist","Z_my.png"},
    {"Z_bottom.plist","Z_bottom.png"},
    {"Z_right.plist","Z_right.png"},
    {"Z_up.plist","Z_up.png"},
    {"Z_left.plist","Z_left.png"},
    {"mjEmpty.plist","mjEmpty.png"},
}

local function getBackCardTexture(_type)
    if _type==nil then
        return
    end
    
    local card=cc.Sprite:createWithSpriteFrameName(_type..".png")
    return card
end

local function getCardTexture(_type,_num)
    if _num==0 or _type==nil then
        return
    end
    local res = string.format("%02X",_num)
    local test=_type.."_".."0x"..res..".png"
    local card=cc.Sprite:createWithSpriteFrameName(_type.."_".."0x"..res..".png")
    return card
end

local M = class("Card", function ()
    return  cc.Node:create()
end)

function M:ctor()
    self.m_cardId=-1
    self.m_type=nil
    self.GuiCardSp=nil
    self.touchFun=nil
    self.TempPosTab={x=0,y=0}
    self.IsCanTouch=false
    self.Select=false
    self:initPlist()
    self:init()
end

function M:init()
    local bg=cc.Sprite:createWithSpriteFrameName("G_Shu.png")
    self:addChild(bg)
    self.bg=bg
end

function M:createWithId(_type,_id,_callfun)
    local card = M:create()
    card:setCardId(_id)
    card:setType(_type)
    if _callfun~=nil then
        card:setTouchCall(_callfun)
    end
    card:showCard()
    return card
end

function M:showCard()
    local texture=nil 
    if self.m_cardId==-1 then
        texture=getBackCardTexture(self.m_type)
    else
        texture=getCardTexture(self.m_type,self.m_cardId)
    end
    self:addChild(texture)
    self.bg:removeFromParent()
    self.bg=texture
    if self.touchFun~=nil then
        self:SpriteTouch(self.bg,function(sender)self:btnClickEvent(sender)end)
    end
end

function M:SpriteTouch(sprite,callfun)
    if callfun==nil then
        return
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(function (touch, event)
    local locationInNode = sprite:convertToNodeSpace(touch:getLocation())
    local s = sprite:getContentSize()
    local rect = cc.rect(0, 0, s.width, s.height)
    if cc.rectContainsPoint(rect, locationInNode) then
        if self.IsCanTouch then
            callfun(sprite)
            return true
        end
    end
    return false
    end,cc.Handler.EVENT_TOUCH_BEGAN )

    listener:registerScriptHandler(function (touch, event)
        local locationInNode = touch:getLocation()
        sprite:setPosition(locationInNode.x-self.TempPosTab.x,locationInNode.y-self.TempPosTab.y)
    return true
    end, cc.Handler.EVENT_TOUCH_MOVED)
  
    listener:registerScriptHandler(function (touch, event)
        local temp = touch:getLocation()
        if temp.y>200 then
            callfun(sprite)
        else
            self:setSelect(true)
            self:UpCard()
        end        
    end, cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = sprite:getEventDispatcher() 
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, sprite)
    return sprite
end

function M:setGuiCard(b)
end

function M:setCanTouch(b)
    self.IsCanTouch=b
end

function M:setTempPos(x,y)
    self.TempPosTab.x=x
    self.TempPosTab.y=y
end

function M:setSelect(b)
    self.Select=b
end

function M:UpCard()
    self.bg:setPosition(0,20)
    -- self.bg:runAction(cc.MoveTo:create(0.1,cc.p(0,20)))
end

function M:DownCard()
    self.bg:setPosition(0,0)
    -- self.bg:runAction(cc.MoveTo:create(0.1,cc.p(0,0)))
end

function M:setCardId(id)
    self.m_cardId=id
end

function M:getCardId()
    return self.m_cardId
end

function M:setType(type)
    self.m_type=type
end

function M:getType()
    return self.m_type
end

function M:getSize()
    return self.bg:getContentSize()
end

function M:btnClickEvent(sender)
    if  self.touchFun~=nil then
        self.touchFun(self)
    end
end

function M:setTouchCall(_fun)
    self.touchFun=_fun
end

function M:setGray(isgray)

end

function M:initPlist()
    if spriteFrameCache:getSpriteFrame("B_0x43.png") == nil then
        self:addCardCache()
    end
end

function M:addCardCache()
    for k,v in pairs(ResTab) do
        display.addSpriteFrames(v[1],v[2])
    end
end

function M:reSet()
    self.m_cardId=-1
    self.Select=false
    self.GuiCardSp=nil
    self.bg:removeFromParent()
end

return M