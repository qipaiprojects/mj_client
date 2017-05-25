-- 创建房间对话框
local M = class("CreateRoomDlg", function (config)
    return cc.LayerColor:create(cc.c4b(0,0,0,180), 1334, 750)
end)

function M:ctor()
	self:init()
    self.curItemIdex=1
end

function M:onEnter()
end

function M:onExit()
end

function M:init()
    local w,h = self:getContentSize().width,self:getContentSize().height
    
    self.pageview=ccui.PageView:create()
    self.pageview:setAnchorPoint(cc.p(0.5,0.5))
    self.pageview:setContentSize(cc.size(w,h))
    self.pageview:setPosition(cc.p(w/2,y/2))
    self.pageview:setTouchEnabled(false)
    bg:addChild(self.pageview)
    self.pageview:addPage(self:creatSetGameItem())
    self.pageview:addPage(self:creatJoinGameItem())

    local btn_table= {{"chuangjianyouxi@2x.png","chuangjianyouxixuanzhong@2x.png"},{"jiaruyouxiweixuanzhong@2x.png","jiaruyouxi@2x.png"},}
    local title_btn=game.ui.button.SwichButton(btn_table,1,"horizontal",340,function(sender)
        self:SwichEvent(sender)
    end)
	title_btn:setPosition(x/2-175,y - 60)
    bg:addChild(title_btn)

end

function M:SwichEvent(sender)
    if sender:getTag()==1 then
        self.pageview:scrollToPage(0)
    end
    if sender:getTag()==2 then
        self.pageview:scrollToPage(1)
    end
end  

function M:BtnClickEvent(sender)
    game.audioManager:playClickSound()
    local tag = sender:getTag()
    local switch = Switch:create()
    for i=0,9 do
        switch[i] = function()
            if string.len(self.text_label:getString())<7 then
                self.text_label:setString(self.text_label:getString()..sender:getTag())
            end
            if string.len(self.text_label:getString())==7 then
                if game.tools.limitClick(2)==true then
                   self:JoinGameEvent()
                end
            end
        end
    end
    switch[10] = function()
        if self.text_label:getString()~="" then
            local s=string.sub(self.text_label:getString(),1,string.len(self.text_label:getString())-1)  
            self.text_label:setString(s)
        end
    end
    switch[11] = function()
        self:JoinGameEvent()
    end
    switch[tag]()
end  

function M:SelectEvent(sender)
    if sender:getTag()>=1 then
        self.curItemIdex=sender:getTag()
        self:updatItemPanel()
    end
end  

function M:JoinGameEvent()
    RoomInfo.GameType=G_GameType.GAME_TYPE_JOIN
    GameInfo.m_privateId=tonumber(self.text_label:getString())
    self:initRoominfo()
end  

function M:CreatGameEvent(sender)
	if self.jushu8 then
	    GameInfo.m_PlayCoutIdex=1
	end
	if self.jushu16 then
	    GameInfo.m_PlayCoutIdex=3
	end
	if self.daibaohu then
	    GameInfo.m_daibaohu = true
	else
		GameInfo.m_daibaohu = false
	end
	if self.qiangganghu then
	    GameInfo.m_qiangganghu = true
	else
		GameInfo.m_qiangganghu = false
	end

    RoomInfo.GameType=G_GameType.GAME_TYPE_CREATE
    GameInfo.m_rule = 0
    
    self:initRoominfo()
end  

function M:setAllItemVisibleFalse()
    for key,velue in pairs(self.item_table) do
        velue:setVisible(false)
    end
end  

function M:initRoominfo()
    RoomInfo.KindID = itemConfig.info[self.curItemIdex].kindid
    RoomInfo.Entrance=itemConfig.info[self.curItemIdex].Entrance
    RoomInfo.ServerPort=itemConfig.info[self.curItemIdex].wServerPort
    RoomInfo.m_versoin=itemConfig.info[self.curItemIdex].VERSION_CLIENT
    RoomInfo.m_RoomType=G_DataType.Data_Room
    
    for i=1,#RoomInfo.m_roomList do
        local t=RoomInfo.m_roomList[i]
        if t.wKindID == RoomInfo.KindID and t.wServerPort==RoomInfo.ServerPort and t.wKindID ~= GAME_GENRE_MATCH then
            RoomInfo.ServerAdress=t.szServerAddr
            RoomInfo.m_curRoom=t
            network:connectRoom(t)
            network:enterRoom()
        end
    end
end  

function M:updatItemPanel()
    self:setAllItemVisibleFalse()
    if self.curItemIdex==nil then
       self.curItemIdex=1
    end
    self.item_table[self.curItemIdex]:setVisible(true)
end 

function M:selectedEvent(sender,select)
    local tag = sender:getTag()
	if tag == 21 then
	    self.jushu8 = select
    elseif tag == 22 then
	    self.jushu16 = select
	elseif tag == 23 then
		self.daibaohu = select
	elseif tag == 24 then
		self.qiangganghu = select
	end
end 

function M:creatSetGameItem(sender)
    local x,y = Helper.size.width,Helper.size.height
    local layout=ccui.Layout:create()
    
    local createbtn = ccui.Button:create("quedinganniu@2x.png")
    createbtn:addClickEventListener(function(sender) self:CreatGameEvent(sender) end)
    createbtn:setPosition(x/2,80)
    layout:addChild(createbtn)
	
	-- 局数
    local jushu_label = cc.Label:createWithSystemFont("局数选择:",ChineseSysFont, 35)
    jushu_label:setColor(Join_Game_Color)
    jushu_label:setPosition(180,y-180)
	layout:addChild(jushu_label)
	
	local jushu_8=game.ui.button.CheckButton("xuankuang@2x.png","gou@2x.png",false,function(sender,select)
        self:selectedEvent(sender,select)
    end)
	jushu_8:setTag(21)
    jushu_8:setPosition(300,y-180)
    layout:addChild(jushu_8)
	
	local jushu_8_label = cc.Label:createWithSystemFont("8局",ChineseSysFont, 23)
    jushu_8_label:setColor(Join_Game_Color)
    jushu_8_label:setPosition(360,y-180)
    layout:addChild(jushu_8_label)
	
	local jushu_16=game.ui.button.CheckButton("xuankuang@2x.png","gou@2x.png",false,function(sender,select)
        self:selectedEvent(sender,select)
    end)
	jushu_16:setTag(22)
    jushu_16:setPosition(520,y-180)
    layout:addChild(jushu_16)
	
	local jushu_16_label = cc.Label:createWithSystemFont("16局",ChineseSysFont, 23)
    jushu_16_label:setColor(Join_Game_Color)
    jushu_16_label:setPosition(580,y-180)
    layout:addChild(jushu_16_label)

	-- 玩法
    local wanfa_label = cc.Label:createWithSystemFont("玩法选择:",ChineseSysFont, 35)
    wanfa_label:setColor(Join_Game_Color)
    wanfa_label:setPosition(180,y-280)
	layout:addChild(wanfa_label)
	
	local daibaohu=game.ui.button.CheckButton("xuankuang@2x.png","gou@2x.png",false,function(sender,select)
        self:selectedEvent(sender,select)
    end)
	daibaohu:setTag(23)
    daibaohu:setPosition(300,y-280)
    layout:addChild(daibaohu)
	
	local daibaohu_label = cc.Label:createWithSystemFont("带宝胡",ChineseSysFont, 23)
    daibaohu_label:setColor(Join_Game_Color)
    daibaohu_label:setPosition(360,y-280)
    layout:addChild(daibaohu_label)
	
	local qiangganghu=game.ui.button.CheckButton("xuankuang@2x.png","gou@2x.png",false,function(sender,select)
        self:selectedEvent(sender,select)
    end)
	qiangganghu:setTag(24)
    qiangganghu:setPosition(520,y-280)
    layout:addChild(qiangganghu)
	
	local qiangganghu_label = cc.Label:createWithSystemFont("抢杠胡",ChineseSysFont, 23)
    qiangganghu_label:setColor(Join_Game_Color)
    qiangganghu_label:setPosition(580,y-280)
    layout:addChild(qiangganghu_label)
	
    return layout
end  

function M:creatJoinGameItem(sender)

    local x,y = Helper.size.width,Helper.size.height
    local layout=ccui.Layout:create()

    local text_bg=display.newSprite("shuzilan@2x.png")
    text_bg:setPosition(x/2,y/2+110)
    layout:addChild(text_bg)

    local text_label= cc.Label:createWithSystemFont("",ChineseSysFont, 35)
    text_label:setColor(cc.YELLOW)
    text_label:setPosition(text_bg:getContentSize().width/2,text_bg:getContentSize().height/2)
    text_bg:addChild(text_label)
    self.text_label=text_label

	local button_tbl = {
		-- 第一排按钮
		{
			{res="1@2x.png", tag=1}, {res="2@2x.png", tag=2}, {res="3@2x.png", tag=3}, {res="4@2x.png", tag=4}
		},
		-- 第二排按钮
		{
			{res="5@2x.png", tag=5}, {res="6@2x.png", tag=6}, {res="7@2x.png", tag=7}, {res="8@2x.png", tag=8}
		},
		-- 第三排按钮
		{
			{res="9@2x.png", tag=9}, {res="0@2x.png", tag=0}, {res="shanchu@2x.png", tag=10}, {res="queding@2x.png", tag=11}
		}
	}
	
	x,y = Helper.size.width/2-310,Helper.size.height/2+100
	for i=1,3 do
		for j=1,4 do
			local info = button_tbl[i][j]
			local btn = ccui.Button:create(info.res, info.res)
			btn:setTag(info.tag)
			btn:addClickEventListener(function(sender) self:BtnClickEvent(sender) end)
			btn:setPosition(x+120*j, y-90*i)
			layout:addChild(btn)
		end
	end

    return layout
end  

function M:createItem(info)
    local x,y = Helper.size.width,Helper.size.height
    local layout = RoomInfo.getGameItemByName(info.name)
    layout:setContentSize(cc.size(x-460,y-230)) 
    layout:setAnchorPoint(cc.p(0.5,0.5))
    layout:setBounceEnabled(true) 
    layout:setScrollBarWidth(0)
    return layout
end  

return M
