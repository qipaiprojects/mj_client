local client = require "network.client"

local M = class("LoginScene", cc.load("mvc").ViewBase)

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
	local bgLayer = cc.LayerColor:create(cc.c4b(0xff, 0xff, 0xff, 0xff), self.frameSize.width, self.frameSize.height)

	print(self.frameSize.width/2, self.frameSize.height/2)
	local bg = cc.Sprite:create("login_bg.png")
	bg:setAnchorPoint(cc.p(0.5, 0.5))
    bg:setPosition(self.frameSize.width/2, self.frameSize.height/2 + 120)
    bgLayer:addChild(bg)

	self:addChild(bgLayer)
	
	self.bgLayer = bgLayer
	
	self.client = client.new()
	self.client:connect("222.73.139.48", 8080)
	self:register_msg_callback()
end

function M:initItems()
    local accountLabel = cc.Label:createWithSystemFont("账  号: ", "arial", 28)
    accountLabel:setColor(ccc3(238,130,238))
	accountLabel:setPosition(self.frameSize.width/2 - 110, self.frameSize.height/2-80)
	self.bgLayer:addChild(accountLabel)
	
	local accountEdit= cc.EditBox:create({width = 201, height = 45}, "edit_bg.png")
	accountEdit:setFontSize(24)
	accountEdit:setFontColor(ccc3(238,130,238))
	accountEdit:setMaxLength(16)
	accountEdit:setInputMode(cc.EDITBOX_INPUT_MODE_EMAILADDR)  
	accountEdit:setInputMode(cc.EDITBOX_INPUT_MODE_PHONENUMBER)
	accountEdit:setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD);
    accountEdit:setPosition(self.frameSize.width/2 + 50 , self.frameSize.height/2-80)
    self.bgLayer:addChild(accountEdit)
	self.accountEdit = accountEdit

	local passwdLabel = cc.Label:createWithSystemFont("密  码: ", "arial", 28)
    passwdLabel:setColor(ccc3(238,130,238))
	
	passwdLabel:setPosition(self.frameSize.width/2 - 110, self.frameSize.height/2-140)
	self.bgLayer:addChild(passwdLabel)
	
	local passwdEdit= cc.EditBox:create({width = 201, height = 45}, "edit_bg.png")
    passwdEdit:setFontSize(24)
	passwdEdit:setFontColor(ccc3(238,130,238))
	passwdEdit:setMaxLength(16)
	passwdEdit:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	--passwdEdit:setInputFlag(ccui.kEditBoxInputFlagPassword)
	passwdEdit:setPosition(self.frameSize.width/2 + 50 , self.frameSize.height/2-140)
    self.bgLayer:addChild(passwdEdit)
	self.passwdEdit = passwdEdit

	local loginBtn = ccui.Button:create("btn.png")
    loginBtn:setScale(0.6)
	loginBtn:setAnchorPoint(cc.p(0.5, 0.5))
    loginBtn:setPosition(self.frameSize.width/2 - 105 , self.frameSize.height/2 - 200)
	loginBtn:setTitleText("登    陆")
	loginBtn:setTitleFontSize(35)
	self.bgLayer:addChild(loginBtn)
    loginBtn:addClickEventListener(function(sender)
        self:BtnLogin()
    end)
	
	local registerBtn = ccui.Button:create("btn.png")
    registerBtn:setScale(0.6)
	registerBtn:setAnchorPoint(cc.p(0.5, 0.5))
    registerBtn:setPosition(self.frameSize.width/2 + 105, self.frameSize.height/2 - 200)
	registerBtn:setTitleText("注    册")
	registerBtn:setTitleFontSize(35)
	self.bgLayer:addChild(registerBtn)
    registerBtn:addClickEventListener(function(sender)
        self:BtnRegister()
    end)
end

function M:update(delta)
	print("update")
	self.client:deal_msgs()
end

function M:register_msg_callback()
	self.client:register("login.login", self, self.OnLoginResult)
	self.client:register("login.register", self, self.OnRegisterResult)
end

function M:unregister_msg_callback()
	self.client:unregister("login.login")
	self.client:unregister("login.register")
end

function M:OnLeave()
	if self.client then
		self:unregister_msg_callback()
		self.client:close()
	end
end

function M:BtnLogin()
	local account = self.accountEdit:getText()
	local passwd = self.passwdEdit:getText()
	
	self.client:send("login.login", {account = account, passwd = passwd})
end

function M:OnLoginResult(msg)

end

function M:BtnRegister()
	local account = self.accountEdit:getText()
	local passwd = self.passwdEdit:getText()
	
	self.client:send("login.register", {account = account, passwd = passwd})
end

function M:OnRegisterResult(msg)

end

return M