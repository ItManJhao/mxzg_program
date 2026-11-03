local SettingSuperCtr = class("SettingSuperCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SettingSuperLayer = class("SettingSuperLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UICheckBox = require("src.comp.UICheckBox")

function SettingSuperLayer:onCreate()
	self:addBlackBackground()
	
	self.btn_user:setLabelSize(45)
	self.btn_service:setLabelSize(45)

	self.btn_user:setLabelOffset(cc.p(20, 0))
	self.btn_service:setLabelOffset(cc.p(20, 0))
	
	self.btn_user:setLabelText(ex.Tools:getLang(85))
	self.btn_service:setLabelText(ex.Tools:getLang(86))

	self.btn_exchange:setLabelText(ex.Tools:getLang(41009)) -- 切换账号
	self.btn_language:setLabelText(ex.Tools:getLang(81))

	if require("src.model.Game"):instance().server_id >= SERVER_SHEN_HE_ID and device.platform == "ios" then
		self.btn_cdk:setVisible(false)
	end
end

-----------------------------------------------------------------------------
function SettingSuperCtr:onCreate()
	self:setCCBIPath("ccbi/SettingSuperLayer.ccbi")
	self:setIsSingle(false)
end

function SettingSuperCtr:getLayerClass()
	return SettingSuperLayer
end

function SettingSuperCtr:getSettingSuperLayer()
	return self.layer
end

function SettingSuperCtr:openWindow()
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/setting.plist")
	
	self:loadLayer()
	self:open()
	self:initData()
end

function SettingSuperCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	self.layer.btn_music:registerScriptTapHandler(handler(self, self.onMusic))
	self.layer.btn_effect:registerScriptTapHandler(handler(self, self.onEffect))
	self.layer.btn_exchange:registerScriptTapHandler(handler(self, self.onExchange))
	self.layer.btn_notice:registerScriptTapHandler(handler(self, self.onNotice))
	self.layer.btn_cdk:registerScriptTapHandler(handler(self, self.onCDK))
	self.layer.btn_language:registerScriptTapHandler(handler(self, self.onLanguage))
	self.layer.btn_user:registerScriptTapHandler(handler(self, self.onUser))
	self.layer.btn_service:registerScriptTapHandler(handler(self, self.onService))

	self.layer.btn_music:setChecked(require("src.model.AudioManager"):instance():isPlayMusic())
	self.layer.btn_effect:setChecked(require("src.model.AudioManager"):instance():isPlayEffect())

	self.layer.lbl_server_name:setString(ex.StringUtil.getServerName(cc.UserDefault:getInstance():getIntegerForKey("server_id")))

	local is_language_select = cfg.socialplatform.isOpen("language_select")
	self.layer.btn_language:setVisible(is_language_select == true)
	
	local is_user_center = cfg.socialplatform.isOpen("user_center")
	self.layer.btn_user:setVisible(is_user_center == true)
	self.layer.btn_service:setVisible(is_user_center == true)
end

function SettingSuperCtr:onMusic()
	require("src.model.AudioManager"):instance():setPlayMusic(self.layer.btn_music:isChecked())
end

function SettingSuperCtr:onEffect()
	require("src.model.AudioManager"):instance():setPlayEffect(self.layer.btn_effect:isChecked())
end

function SettingSuperCtr:onExchange(tag, pSender)
	-- 切换账号
	cpp.SocialPlatform:instance():logout()
	cc.UserDefault:getInstance():setStringForKey("last_login_account", "")
end

function SettingSuperCtr:onCDK(tag, pSender)
	-- 礼包兑换
	require("src.layer.InputCodeCtr"):instance():openWindow()
end

function SettingSuperCtr:onLanguage()
	require("src.layer.LanguageSelectCtr"):instance():openWindow()
end

function SettingSuperCtr:onUser()
	cpp.SocialPlatform:instance():showUserCenter()
end

function SettingSuperCtr:onService()
	cpp.SocialPlatform:instance():showCustomerService()
end

function SettingSuperCtr:onNotice(tag, pSender)
	-- 公告
	ex.PlatformHttpRequest:getNotice(function(json)
        local str_content = ""
        local str_title = ""
        if json ~= nil and json.data ~= nil and json.data.content ~= nil then
            str_content = json.data.content
            str_title = json.data.label
        end
    
        require("src.layer.NoticeCtr"):instance():closeWindow(0, nil)
        require("src.layer.NoticeCtr"):instance():openWindow(str_content, str_title)
    end)
end

return SettingSuperCtr
