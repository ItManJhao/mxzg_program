--[[
* @Description: 惊喜盲盒提示框
* @Author: 周向阳
* @Date: 2020-09-26 20:00:00
* ]]
local PROMChrismasTipsCtr = class("PROMChrismasTipsCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local PROMChrismasTipsLayer = class("PROMChrismasTipsLayer",require("src.comp.EventLayerAdaptiveWidth"))

function PROMChrismasTipsLayer:onCreate()
	self:addBlackBackground()
	self.lbl_content = require("src.comp.RichTextEx"):create()
	:setFontSize(24)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#551E14")
	:setPosition(self.rich_text:getPosition())
	:setAnchorPoint(ex.a.top_center)
	self:addChild(self.lbl_content)
end



-----------------------------------------------------------------------------
function PROMChrismasTipsCtr:onCreate()
	self:setCCBIPath("ccbi/PROMChrismasTipsLayer.ccbi")
	self:setIsSingle(false)
end

function PROMChrismasTipsCtr:getLayerClass()
	return PROMChrismasTipsLayer
end

function PROMChrismasTipsCtr:getAchievementLayer()
	return self.layer
end

function PROMChrismasTipsCtr:openWindow(title, content, confirm_callback, is_open, name)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self:initData(title, content, confirm_callback, is_open, name)
end

function PROMChrismasTipsCtr:initData(title, content, confirm_callback, is_open, name)
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self.layer.lbl_title:setString(title)
	self.layer.lbl_content:setXmlTextLua(content)
	self.layer.lbl_content:formatText()
	ex.Tools:setLimitWidth(self.layer.lbl_content, 500)
	ex.Tools:setLimitWidth(self.layer.lbl_skip, 280)
	
	self.layer.callback_confirm = confirm_callback
	self.name = name

	if is_open ~= true then
		self:onConfirm()
	end
end

function PROMChrismasTipsCtr:onClose()
	self:closeWindow()
end

function PROMChrismasTipsCtr:onConfirm()

	if self.layer.btn_skip:isChecked() then
		if self.name == "break_egg_is_open" then
			cc.UserDefault:getInstance():setBoolForKey(string.format("%s_break_egg_is_open", ex.Player.role_id), false)
			cc.UserDefault:getInstance():setIntegerForKey(string.format("%s_break_egg_time", ex.Player.role_id), ex.Game:getServerTime())
		else
			cc.UserDefault:getInstance():setBoolForKey(string.format("%s_blind_box_is_open", ex.Player.role_id), false)
			cc.UserDefault:getInstance():setIntegerForKey(string.format("%s_blind_box_time", ex.Player.role_id), ex.Game:getServerTime())
		end
	end

	if self.layer.callback_confirm then
		self.layer.callback_confirm()
	end

	self:closeWindow()
end

return PROMChrismasTipsCtr
