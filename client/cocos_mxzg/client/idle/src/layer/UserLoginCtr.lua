local UserLoginCtr = class("UserLoginCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local UserLoginLayer = class("UserLoginLayer", require("src.comp.LuaLayerBase"))
local logo_ctr = require("src.scene.LogoSceneCtr"):instance()


-- 设置默认值
local user_key = string.format("user-login-%s", "user")
local platform_key = string.format("user-login-%s", "platform")
local channel_key = string.format("user-login-%s", "channel_id")
local pf_key = string.format("user-login-%s", "pf_id")
local server_key = string.format("user-login-%s", "server")

function UserLoginLayer:onCreate()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);

	local content_size = self:getContentSize()
	self.viewSize = cc.size(content_size.width - 80, content_size.height - 120)

	self.edit_user = ccui.EditBox:create(cc.size(self.spr_user_bg:getContentSize().width, self.spr_user_bg:getContentSize().height), "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_user:setPosition(cc.p(self.spr_user_bg:getPositionX() + self.spr_user_bg:getContentSize().width * 0.5, self.spr_user_bg:getPositionY()))
    self.edit_user:setAnchorPoint(cc.p(0.5,0.5))
    self.edit_user:setFontSize(26)
    self.edit_user:setFontColor(cc.WHITE)
    self.edit_user:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND )
    self.edit_user:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    -- self.edit_user:setText(tostring())
	self:addChild(self.edit_user, 9999)


	self.edit_platform = ccui.EditBox:create(cc.size(self.spr_platform_bg:getContentSize().width, self.spr_platform_bg:getContentSize().height), "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_platform:setPosition(cc.p(self.spr_platform_bg:getPositionX() + self.spr_platform_bg:getContentSize().width * 0.5, self.spr_platform_bg:getPositionY()))
    self.edit_platform:setAnchorPoint(cc.p(0.5,0.5))
    self.edit_platform:setFontSize(26)
    self.edit_platform:setFontColor(cc.WHITE)
    self.edit_platform:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND )
    self.edit_platform:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    -- self.edit_user:setText(tostring())
	self:addChild(self.edit_platform, 9999)


	self.edit_channel = ccui.EditBox:create(cc.size(self.spr_channel_bg:getContentSize().width, self.spr_channel_bg:getContentSize().height), "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_channel:setPosition(cc.p(self.spr_channel_bg:getPositionX() + self.spr_channel_bg:getContentSize().width * 0.5, self.spr_channel_bg:getPositionY()))
    self.edit_channel:setAnchorPoint(cc.p(0.5,0.5))
    self.edit_channel:setFontSize(26)
    self.edit_channel:setFontColor(cc.WHITE)
    self.edit_channel:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND )
    self.edit_channel:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    -- self.edit_user:setText(tostring())
	self:addChild(self.edit_channel, 9999)

	self.edit_pf = ccui.EditBox:create(cc.size(self.spr_pf_bg:getContentSize().width, self.spr_pf_bg:getContentSize().height), "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_pf:setPosition(cc.p(self.spr_pf_bg:getPositionX() + self.spr_pf_bg:getContentSize().width * 0.5, self.spr_pf_bg:getPositionY()))
    self.edit_pf:setAnchorPoint(cc.p(0.5,0.5))
    self.edit_pf:setFontSize(26)
    self.edit_pf:setFontColor(cc.WHITE)
    self.edit_pf:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND )
    self.edit_pf:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    -- self.edit_user:setText(tostring())
	self:addChild(self.edit_pf, 9999)


	self.edit_server = ccui.EditBox:create(cc.size(self.spr_server_bg:getContentSize().width, self.spr_server_bg:getContentSize().height), "other/spr-null.png", 1)  --输入框尺寸，背景图片
    self.edit_server:setPosition(cc.p(self.spr_server_bg:getPositionX() + self.spr_server_bg:getContentSize().width * 0.5, self.spr_server_bg:getPositionY()))
    self.edit_server:setAnchorPoint(cc.p(0.5,0.5))
    self.edit_server:setFontSize(26)
    self.edit_server:setFontColor(cc.WHITE)
    self.edit_server:setReturnType(cc.KEYBOARD_RETURNTYPE_SEND )
    self.edit_server:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
    -- self.edit_user:setText(tostring())
	self:addChild(self.edit_server, 9999)
end

-----------------------------------------------------------------------------
function UserLoginCtr:onCreate()
	self:setCCBIPath("ccbi/UserLoginLayer.ccbi")
	self:setIsSingle(false)
end

function UserLoginCtr:getLayerClass()
	return UserLoginLayer
end

function UserLoginCtr:getUserLoginLayer()
	return self.layer
end

function UserLoginCtr:openWindow()
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData()
end

function UserLoginCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	self.layer.btn_login:registerScriptTapHandler(handler(self, self.onLogin))

	self:updateLayer()
end

function UserLoginCtr:updateLayer()
	local user_id = cc.UserDefault:getInstance():getStringForKey(user_key, "")
	if user_id == "" then
		user_id = require("src.model.Game"):instance().user_id
	end

	local platform_id = cc.UserDefault:getInstance():getStringForKey(platform_key, "")
	if platform_id == "" then
		platform_id = cpp.SocialPlatform:instance():getPlatformStr()
	end

	local channel_id = cc.UserDefault:getInstance():getStringForKey(channel_key, "")
	if channel_id == "" then
		channel_id = cpp.SocialPlatform:instance():getChannelId()
	end

	local pf_id = cc.UserDefault:getInstance():getStringForKey(pf_key, "")
	if pf_id == "" then
		pf_id = cpp.SocialPlatform:instance():getPfId()
	end

	local server_ip = cc.UserDefault:getInstance():getStringForKey(server_key, "")
	if server_ip == "" then
		local logo_ctr = require("src.scene.LogoSceneCtr"):instance()
		server_ip = logo_ctr.selected_server.server_url..":"..logo_ctr.selected_server.server_port
	end

	self.layer.edit_user:setText(user_id)
	self.layer.edit_platform:setText(platform_id)
	self.layer.edit_channel:setText(channel_id)
	self.layer.edit_pf:setText(pf_id)
	self.layer.edit_server:setText(server_ip)
end

function UserLoginCtr:onLogin()
	local user_id = self.layer.edit_user:getText()
	local platform_id = self.layer.edit_platform:getText()
	local channel_id = self.layer.edit_channel:getText()
	local pf_id = self.layer.edit_pf:getText()
	local server_ip = self.layer.edit_server:getText()

	if user_id == "" then
		ex.MessageView:add(ex.Tools:getLang(47065))
		return
	end

	if platform_id == "" then
		ex.MessageView:add(ex.Tools:getLang(47571))
		return
	end

	if channel_id == "" then
		ex.MessageView:add(ex.Tools:getLang(47581))
		return
	end

	if pf_id == "" then
		ex.MessageView:add(ex.Tools:getLang(47570))
		return
	end

	if server_ip == "" then
		ex.MessageView:add(ex.Tools:getLang(47368))
		return
	end

	cc.UserDefault:getInstance():setStringForKey(user_key, user_id)
	cc.UserDefault:getInstance():setStringForKey(platform_key, platform_id)
	cc.UserDefault:getInstance():setStringForKey(channel_key, channel_id)
	cc.UserDefault:getInstance():setStringForKey(pf_key, pf_id)
	cc.UserDefault:getInstance():setStringForKey(server_key, server_ip)


	cpp.SocialPlatform:instance():setPlatformUrl(0, server_ip)
	cpp.SocialPlatform:instance():setChannelId(channel_id)
	cpp.SocialPlatform:instance():setPfId(pf_id)
	cpp.SocialPlatform:instance():setPlatform(platform_id)
	-- cpp.SocialPlatform:instance():setPlatformUrl(0, server_ip)

	local logo_ctr = require("src.scene.LogoSceneCtr"):instance()
	require("src.model.Game"):instance().user_id = user_id

	-- ex.PlatformHttpRequest:getDefaultServerInfo(handler(logo_ctr, logo_ctr.receiveDefaultServerInfo))
	-- require("src.scene.LoadingSceneCtr"):instance():enterWithAnimation()
	local vec_ip = ex.StringUtil.splist(server_ip, ":")
	logo_ctr.selected_server.server_url = vec_ip[1]
	logo_ctr.selected_server.server_port = vec_ip[2]

	ex.PlatformHttpRequest:loginPlatform(handler(logo_ctr, logo_ctr.loginDone), tostring(logo_ctr.selected_server.server_id))
	UserLoginCtr:instance():closeWindow()
end

return UserLoginCtr