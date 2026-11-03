local PromotionCell = class("PromotionCell", require("src.comp.EventLayer"))

function PromotionCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.is_selected = false

	self.lbl_txt1 = nil
	self.lbl_txt2 = nil
end        

function PromotionCell:isSelected()
	return self.is_selected
end

function PromotionCell:setSelected(selected)
	self.is_selected = selected

	self.spr_icon1:setVisible(not selected)
	self.spr_icon2:setVisible(selected)
	self:setLocalZOrder(selected and 1 or 0)

	if self.lbl_txt1 and self.lbl_txt2 then
		self.lbl_txt1:setVisible(not selected)
		self.lbl_txt2:setVisible(selected)
	end
end

function PromotionCell:addBtnText(text)
	local size = self:getContentSize()
	size.width = size.width / 2

	self.lbl_txt1 = cc.Label:createWithTTF(text, FONT_DEFAULT_NAME_BOLD, 22)
	:enableOutline(cc.c4b(38,55,94,255), 2)
	:setPosition(size.width, 25)
	self:addChild(self.lbl_txt1, 1)

	self.lbl_txt2 = cc.Label:createWithTTF(text, FONT_DEFAULT_NAME_BOLD, 26)
	:enableOutline(cc.c4b(45,186,232,255), 2)
	:setTextColor(FONT_LIGHT_YELLOW)
	:setPosition(size.width, 25)
	self:addChild(self.lbl_txt2, 1)
end

return PromotionCell