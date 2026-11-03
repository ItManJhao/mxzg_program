local AliceUnicornUpgradeCtr = class("AliceUnicornUpgradeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local AliceUnicornUpgradeLayer = class("AliceUnicornUpgradeLayer", require("src.layer.ui.UI_AliceUnicornUpgradeLayer"))

------------------------------------------------
function AliceUnicornUpgradeLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceUnicornUpgradeLayer")

	self:addBlackBackground()
end

function AliceUnicornUpgradeLayer:updateLayer()
	if self.unicorn_data == nil then
		return
	end

	ex.Tools:setSpriteFrameAsyn(self.spr_unicorn, "alice/spr-unicorn-icon-"..self.unicorn_data.unicorn_type..".png", "alice")
	self.lbl_unicorn_info:setString(ex.Tools:getLang(580502 + self.unicorn_data.grade)..ex.Tools:getLang(580507 + self.unicorn_data.unicorn_type).."+"..self.unicorn_data.level)

	ex.Tools:setSpriteFrameAsyn(self.spr_attr, string.format("backpack-info/spr-attribute-%d.png", self.unicorn_data.attr_data.attr_type), "backpack-info")
	self.lbl_attr:setString(ex.Tools:getLang(2150000 + self.unicorn_data.attr_data.attr_type))
	self.lbl_attr_extra:setPositionX(self.lbl_attr:getPositionX() + self.lbl_attr:getContentSize().width + 10)
	local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + self.unicorn_data.attr_data.attr_type), "##" , self.unicorn_data.attr_data.attr_value, "<font color='#219A00'>%s</font>")
	if not flag then
		self.lbl_attr_extra:setString(self.unicorn_data.attr_data.attr_value)
	else
		self.lbl_attr_extra:setString(string.format("%.1f", self.unicorn_data.attr_data.attr_value / 100) .. "%")
	end
end

-----------------------------------------------
function AliceUnicornUpgradeCtr:loadLayer()
    local tmp_layer = AliceUnicornUpgradeLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceUnicornUpgradeCtr:onCreate()
	self:setIsSingle(false)
end

--[[
    @desc: 
    time:2021-09-14 22:44:35
    --@unicorn_data: {unicorn_type, grade, level, attr_data}
    @return:
]]
function AliceUnicornUpgradeCtr:openWindow(unicorn_data)
	if self:isOpened() then
		return
	end

	cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/alice.plist")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/battle-end-1.plist")

	self:loadLayer()
	self:open()
    self:initData(unicorn_data)
end

function AliceUnicornUpgradeCtr:initData(unicorn_data)
	self.layer.unicorn_data = unicorn_data

	self.layer:updateLayer()
end

return AliceUnicornUpgradeCtr
