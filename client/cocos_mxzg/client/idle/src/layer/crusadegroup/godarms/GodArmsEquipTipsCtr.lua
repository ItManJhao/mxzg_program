--[[
* @Description: 神兵装备提示框
* @Author: 周向阳
* @Date: 2020-09-26 20:00:00
* ]]
local GodArmsEquipTipsCtr = class("GodArmsEquipTipsCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodArmsEquipTipsLayer = class("GodArmsEquipTipsLayer",require("src.comp.EventLayerAdaptiveWidth"))

function GodArmsEquipTipsLayer:onCreate()
    self:addBlackBackground()
end



-----------------------------------------------------------------------------
function GodArmsEquipTipsCtr:onCreate()
	self:setCCBIPath("ccbi/GodArmsEquipTipsLayer.ccbi")
	self:setIsSingle(false)
end

function GodArmsEquipTipsCtr:getLayerClass()
	return GodArmsEquipTipsLayer
end

function GodArmsEquipTipsCtr:getAchievementLayer()
	return self.layer
end

function GodArmsEquipTipsCtr:openWindow(title, content, confirm_callback, is_not_skip)
	if self:isOpened() then
		return
	end
	self:loadLayer()
	self:open()
	self:initData(title, content, confirm_callback, is_not_skip)
end

function GodArmsEquipTipsCtr:initData(title, content, confirm_callback, is_not_skip)
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	self.layer.btn_skip:registerScriptTapHandler(handler(self, self.onSkip))
	self.layer.lbl_title:setString(title)
	self.layer.lbl_content:setString(content)
	ex.Tools:setLimitWidth(self.layer.lbl_content, 500)
	ex.Tools:setLimitWidth(self.layer.lbl_skip, 280)
	
	self.layer.callback_confirm = confirm_callback

	if is_not_skip then
		self:onConfirm()
	end
end

function GodArmsEquipTipsCtr:onSkip(  )

	cc.UserDefault:getInstance():setBoolForKey("is_not_skip", true)

end

function GodArmsEquipTipsCtr:onConfirm(tag, pSender)
	if self:getLayer() == nil then
		return
	end

	if self.layer.callback_confirm then
		self.layer.callback_confirm(tag, pSender)
	end

	self:closeWindow(tag, pSender)
end

return GodArmsEquipTipsCtr
