--[[
    func:通用活动窗口标签栏Cell
    author:徐东浩
    time:2019-10-12 22:42:31
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local Common1ActivityCell = class("Common1ActivityCell", require("src.comp.EventLayer"))

function Common1ActivityCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.is_selected = false

	self.lbl_txt1 = nil
	self.lbl_txt2 = nil
end        

function Common1ActivityCell:isSelected()
	return self.is_selected
end

function Common1ActivityCell:setSelected(selected)
	self.is_selected = selected

	self.spr_icon1:setVisible(not selected)
	self.spr_icon2:setVisible(selected)
	self:setLocalZOrder(selected and 1 or 0)

	if self.lbl_txt1 and self.lbl_txt2 then
		self.lbl_txt1:setVisible(not selected)
		self.lbl_txt2:setVisible(selected)
	end
end

function Common1ActivityCell:addBtnText(text)
	local size = self:getContentSize()
	size.width = size.width / 2

	self.lbl_txt1 = cc.Label:createWithTTF(text, FONT_DEFAULT_NAME_BOLD, 20)
	:enableOutline(ex.c3b.BLACK, 1)
	:setPosition(size.width, 25)
	self:addChild(self.lbl_txt1, 1)

	self.lbl_txt2 = cc.Label:createWithTTF(text, FONT_DEFAULT_NAME_BOLD, 20)
	:setTextColor(FONT_LIGHT_YELLOW)
	:setPosition(size.width, 25)
	self:addChild(self.lbl_txt2, 1)
end

return Common1ActivityCell