local HeroMagicWandSelectCell = class("HeroMagicWandSelectCell", require("src.comp.CCCLayerBase")) 

function HeroMagicWandSelectCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(550, 160)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(550, 160)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/cell-bg-6.png", capInsets = cc.rect(35,43,36,46)})
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local menu = require('src.comp.menu.UIMenuEx'):create()
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	self:addChild(menu)
	self.menu = menu

	local item = require("src.comp.menu.UIMenuItemBag"):createWithData(0, 0)
	item:setPosition(78.29, 80)
	item:setScale(0.8, 0.8)
	item:registerScriptTapHandler(handler(self, self.onEquip))
	menu:addChild(item)
	self.item = item

	local btn_select = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_select:setPosition(461, 80)
	btn_select:setContentSize(136, 58)
	btn_select:registerScriptTapHandler(handler(self, self.onWear))
	btn_select:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_select:setLabelOffset(cc.p(0, 0))
	btn_select:setLabelSize(48)
	btn_select:setLabelOutLine(cc.c4b(83,45,29,255), 2)
	btn_select:setLabelText(ex.Tools:getLang(47343))
	self:addLoadRes(3, btn_select, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-old-1.png"})
	menu:addChild(btn_select)
	self.btn_select = btn_select

	local lbl_attr1 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr1:setPosition(155, 109.68)
	lbl_attr1:setContentSize(54, 22.68)
	lbl_attr1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr1:setTextColor(cc.c3b(102, 54, 34))
	lbl_attr1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr1)
	self.lbl_attr1 = lbl_attr1

	local lbl_attr2 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr2:setPosition(270, 109.68)
	lbl_attr2:setContentSize(54, 22.68)
	lbl_attr2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr2:setTextColor(cc.c3b(102, 54, 34))
	lbl_attr2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr2)
	self.lbl_attr2 = lbl_attr2

	local lbl_attr_rand1 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_rand1:setPosition(155, 90)
	lbl_attr_rand1:setContentSize(54, 22.68)
	lbl_attr_rand1:setAnchorPoint(cc.p(0, 1))
	lbl_attr_rand1:setTextColor(cc.c3b(33, 154, 0))
	lbl_attr_rand1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr_rand1)
	self.lbl_attr_rand1 = lbl_attr_rand1

	local lbl_attr_rand2 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_rand2:setPosition(270, 90)
	lbl_attr_rand2:setContentSize(54, 22.68)
	lbl_attr_rand2:setAnchorPoint(cc.p(0, 1))
	lbl_attr_rand2:setTextColor(cc.c3b(33, 154, 0))
	lbl_attr_rand2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr_rand2)
	self.lbl_attr_rand2 = lbl_attr_rand2

	local lbl_attr_rand3 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_rand3:setPosition(155, 65)
	lbl_attr_rand3:setContentSize(54, 22.68)
	lbl_attr_rand3:setAnchorPoint(cc.p(0, 1))
	lbl_attr_rand3:setTextColor(cc.c3b(33, 154, 0))
	lbl_attr_rand3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr_rand3)
	self.lbl_attr_rand3 = lbl_attr_rand3

	local lbl_attr_rand4 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_rand4:setPosition(270, 65)
	lbl_attr_rand4:setContentSize(54, 22.68)
	lbl_attr_rand4:setAnchorPoint(cc.p(0, 1))
	lbl_attr_rand4:setTextColor(cc.c3b(33, 154, 0))
	lbl_attr_rand4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr_rand4)
	self.lbl_attr_rand4 = lbl_attr_rand4

	 self:startLoadRes()
end
return HeroMagicWandSelectCell