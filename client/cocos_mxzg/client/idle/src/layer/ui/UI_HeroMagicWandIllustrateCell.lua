local HeroMagicWandIllustrateCell = class("HeroMagicWandIllustrateCell", require("src.comp.CCCLayerBase")) 

function HeroMagicWandIllustrateCell:onCreate() 
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
	item:setPosition(90, 80)
	item:registerScriptTapHandler(handler(self, self.onEquip))
	menu:addChild(item)
	self.item = item

	local lbl_attr1 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr1:setPosition(159.07, 113.94)
	lbl_attr1:setContentSize(60, 25.2)
	lbl_attr1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr1:setTextColor(cc.c3b(102, 54, 34))
	lbl_attr1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr1)
	self.lbl_attr1 = lbl_attr1

	local lbl_attr2 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr2:setPosition(274.07, 113.94)
	lbl_attr2:setContentSize(60, 25.2)
	lbl_attr2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr2:setTextColor(cc.c3b(102, 54, 34))
	lbl_attr2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr2)
	self.lbl_attr2 = lbl_attr2

	local lbl_attr_rand1 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_rand1:setPosition(159.07, 83.94)
	lbl_attr_rand1:setContentSize(60, 25.2)
	lbl_attr_rand1:setAnchorPoint(cc.p(0, 1))
	lbl_attr_rand1:setTextColor(cc.c3b(33, 154, 0))
	lbl_attr_rand1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr_rand1)
	self.lbl_attr_rand1 = lbl_attr_rand1

	local lbl_attr_rand2 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_rand2:setPosition(274.07, 83.94)
	lbl_attr_rand2:setContentSize(60, 25.2)
	lbl_attr_rand2:setAnchorPoint(cc.p(0, 1))
	lbl_attr_rand2:setTextColor(cc.c3b(33, 154, 0))
	lbl_attr_rand2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr_rand2)
	self.lbl_attr_rand2 = lbl_attr_rand2

	local lbl_attr_rand3 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_rand3:setPosition(159.07, 58.94)
	lbl_attr_rand3:setContentSize(60, 25.2)
	lbl_attr_rand3:setAnchorPoint(cc.p(0, 1))
	lbl_attr_rand3:setTextColor(cc.c3b(33, 154, 0))
	lbl_attr_rand3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr_rand3)
	self.lbl_attr_rand3 = lbl_attr_rand3

	local lbl_attr_rand4 = cc.Label:createWithTTF("统御：",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_rand4:setPosition(274.07, 58.94)
	lbl_attr_rand4:setContentSize(60, 25.2)
	lbl_attr_rand4:setAnchorPoint(cc.p(0, 1))
	lbl_attr_rand4:setTextColor(cc.c3b(33, 154, 0))
	lbl_attr_rand4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr_rand4)
	self.lbl_attr_rand4 = lbl_attr_rand4

	local line = cc.Sprite:create()
	line:setPosition(158.83, 95.26)
	line:setContentSize(325, 3)
	line:setScale(1.03, 1)
	line:setAnchorPoint(cc.p(0, 0.5))
	line:setOpacity(175)
	self:addLoadRes(2, line, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "win-bg/line-2.png")
	self:addChild(line)
	self.line = line

	local n = cc.Node:create()
	n:setPosition(520, 116)
	n:setContentSize(112, 25)
	n:setAnchorPoint(cc.p(1, 0.5))
	n:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 10, true)
	ly.node = n
	n.layoutex = ly
	self:addLyt(ly)
	self:addChild(n)
	self.n = n

	local spr_uplevel_tip = cc.Sprite:create()
	spr_uplevel_tip:setPosition(0, 10.44)
	spr_uplevel_tip:setContentSize(42, 22)
	spr_uplevel_tip:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_uplevel_tip, "ccbi-res/hero-up-success.plist", "ccbi-res/hero-up-success.pvr.ccz", "hero-up-success/spr-arrow-2.png")
	n:addChild(spr_uplevel_tip)
	self.spr_uplevel_tip = spr_uplevel_tip

	local lbl_uplevel_tip = cc.Label:createWithTTF(ex.Tools:getLang(57210),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_uplevel_tip:setPosition(52, 10.44)
	lbl_uplevel_tip:setContentSize(60, 25.2)
	lbl_uplevel_tip:setAnchorPoint(cc.p(0, 0.5))
	lbl_uplevel_tip:setTextColor(cc.c3b(102, 54, 34))
	lbl_uplevel_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_uplevel_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_uplevel_tip)
	self.lbl_uplevel_tip = lbl_uplevel_tip

	local n = cc.Node:create()
	n:setPosition(520, 63.5)
	n:setContentSize(112, 25)
	n:setAnchorPoint(cc.p(1, 0.5))
	n:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 10, true)
	ly.node = n
	n.layoutex = ly
	self:addLyt(ly)
	self:addChild(n)
	self.n = n

	local spr_refine_tip = cc.Sprite:create()
	spr_refine_tip:setPosition(0, 10.44)
	spr_refine_tip:setContentSize(42, 22)
	spr_refine_tip:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_refine_tip, "ccbi-res/hero-up-success.plist", "ccbi-res/hero-up-success.pvr.ccz", "hero-up-success/spr-arrow-2.png")
	n:addChild(spr_refine_tip)
	self.spr_refine_tip = spr_refine_tip

	local lbl_refine_tip = cc.Label:createWithTTF(ex.Tools:getLang(57211),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_refine_tip:setPosition(52, 10.44)
	lbl_refine_tip:setContentSize(60, 25.2)
	lbl_refine_tip:setAnchorPoint(cc.p(0, 0.5))
	lbl_refine_tip:setTextColor(cc.c3b(102, 54, 34))
	lbl_refine_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_refine_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_refine_tip)
	self.lbl_refine_tip = lbl_refine_tip

	 self:startLoadRes()
end
return HeroMagicWandIllustrateCell