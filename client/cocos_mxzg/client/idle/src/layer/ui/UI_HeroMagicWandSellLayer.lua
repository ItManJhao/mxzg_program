local HeroMagicWandSellLayer = class("HeroMagicWandSellLayer", require("src.comp.CCCLayerBase")) 

function HeroMagicWandSellLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(585, 385)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(585, 385)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-24.png", capInsets = cc.rect(25,30,25,29)})
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local node_title = cc.Node:create()
	node_title:setPosition(293, 376.58)
	node_title:setContentSize(0, 0)
	self:addChild(node_title)
	self.node_title = node_title

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(0, 0)
	spr_title_bg:setContentSize(225, 72)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/title-bar-4.png", capInsets = cc.rect(0,0,0,0)})
	node_title:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57102),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -48.18)
	lbl_title:setContentSize(116, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	self:addChild(menu)
	self.menu = menu

	local btn_cancel = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_cancel:setPosition(172, 70)
	btn_cancel:setContentSize(134, 56)
	btn_cancel:registerScriptTapHandler(handler(self, self.onClose))
	btn_cancel:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_cancel:setLabelOffset(cc.p(0, 0))
	btn_cancel:setLabelSize(40)
	btn_cancel:setLabelText(ex.Tools:getLang(5363))
	self:addLoadRes(3, btn_cancel, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_cancel)
	self.btn_cancel = btn_cancel

	local btn_confirm = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_confirm:setPosition(414, 70)
	btn_confirm:setContentSize(134, 56)
	btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	btn_confirm:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_confirm:setLabelOffset(cc.p(0, 0))
	btn_confirm:setLabelSize(40)
	btn_confirm:setLabelText(ex.Tools:getLang(5151))
	self:addLoadRes(3, btn_confirm, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-big-1.png"})
	menu:addChild(btn_confirm)
	self.btn_confirm = btn_confirm

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(525.38, 380.09)
	btn_close:setContentSize(53, 56)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local lbl_title_tip = cc.Label:createWithTTF(ex.Tools:getLang(57103),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title_tip:setPosition(32.18, 252)
	lbl_title_tip:setContentSize(202, 31.72)
	lbl_title_tip:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_tip:setTextColor(cc.c3b(255, 227, 183))
	lbl_title_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_tip:enableOutline(cc.c4b(87,56,29,255), 2)
	self:addChild(lbl_title_tip)
	self.lbl_title_tip = lbl_title_tip

	local node_check = cpp.UIMenu:create()
	node_check:setPosition(292.5, 235.63)
	node_check:setContentSize(500, 200)
	node_check:setAnchorPoint(cc.p(0.5, 1))
	node_check:setIgnoreAnchorPointForPosition(false)
	node_check:setAnchorPoint(cc.p(0.5, 1))
	node_check:setIgnoreAnchorPointForPosition(false)
	self:addChild(node_check)
	self.node_check = node_check

	local btn_rare1 = cpp.UIMenuItemCheckBox:create()
	btn_rare1:setPosition(19, 143.03)
	btn_rare1:setContentSize(40, 46)
	btn_rare1:setTag(1)
	self:addLoadRes(3, btn_rare1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-check-1.png", spr2="button/btn-check-2.png"})
	node_check:addChild(btn_rare1)
	self.btn_rare1 = btn_rare1

	local lbl_tip1 = cc.Label:createWithTTF(ex.Tools:getLang(77755),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_tip1:setPosition(46.52, 18.7)
	lbl_tip1:setContentSize(44, 27.72)
	lbl_tip1:setAnchorPoint(cc.p(0, 0.5))
	lbl_tip1:setLocalZOrder(1)
	lbl_tip1:setTextColor(cc.c3b(57, 250, 0))
	lbl_tip1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	btn_rare1:addChild(lbl_tip1)
	self.lbl_tip1 = lbl_tip1

	local btn_rare2 = cpp.UIMenuItemCheckBox:create()
	btn_rare2:setPosition(124, 143.03)
	btn_rare2:setContentSize(40, 46)
	btn_rare2:setTag(2)
	self:addLoadRes(3, btn_rare2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-check-1.png", spr2="button/btn-check-2.png"})
	node_check:addChild(btn_rare2)
	self.btn_rare2 = btn_rare2

	local lbl_tip2 = cc.Label:createWithTTF(ex.Tools:getLang(77756),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_tip2:setPosition(46.52, 18.7)
	lbl_tip2:setContentSize(44, 27.72)
	lbl_tip2:setAnchorPoint(cc.p(0, 0.5))
	lbl_tip2:setLocalZOrder(1)
	lbl_tip2:setTextColor(cc.c3b(55, 194, 240))
	lbl_tip2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	btn_rare2:addChild(lbl_tip2)
	self.lbl_tip2 = lbl_tip2

	local btn_rare3 = cpp.UIMenuItemCheckBox:create()
	btn_rare3:setPosition(229, 143.03)
	btn_rare3:setContentSize(40, 46)
	btn_rare3:setTag(3)
	self:addLoadRes(3, btn_rare3, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-check-1.png", spr2="button/btn-check-2.png"})
	node_check:addChild(btn_rare3)
	self.btn_rare3 = btn_rare3

	local lbl_tip3 = cc.Label:createWithTTF(ex.Tools:getLang(77757),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_tip3:setPosition(46.52, 18.7)
	lbl_tip3:setContentSize(44, 27.72)
	lbl_tip3:setAnchorPoint(cc.p(0, 0.5))
	lbl_tip3:setLocalZOrder(1)
	lbl_tip3:setTextColor(cc.c3b(220, 80, 250))
	lbl_tip3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	btn_rare3:addChild(lbl_tip3)
	self.lbl_tip3 = lbl_tip3

	local btn_rare4 = cpp.UIMenuItemCheckBox:create()
	btn_rare4:setPosition(334, 143.03)
	btn_rare4:setContentSize(40, 46)
	btn_rare4:setTag(4)
	self:addLoadRes(3, btn_rare4, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-check-1.png", spr2="button/btn-check-2.png"})
	node_check:addChild(btn_rare4)
	self.btn_rare4 = btn_rare4

	local lbl_tip4 = cc.Label:createWithTTF(ex.Tools:getLang(77758),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_tip4:setPosition(46.52, 18.7)
	lbl_tip4:setContentSize(44, 27.72)
	lbl_tip4:setAnchorPoint(cc.p(0, 0.5))
	lbl_tip4:setLocalZOrder(1)
	lbl_tip4:setTextColor(cc.c3b(230, 149, 45))
	lbl_tip4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	btn_rare4:addChild(lbl_tip4)
	self.lbl_tip4 = lbl_tip4

	local btn_rare5 = cpp.UIMenuItemCheckBox:create()
	btn_rare5:setPosition(439, 143.03)
	btn_rare5:setContentSize(40, 46)
	btn_rare5:setTag(5)
	self:addLoadRes(3, btn_rare5, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-check-1.png", spr2="button/btn-check-2.png"})
	node_check:addChild(btn_rare5)
	self.btn_rare5 = btn_rare5

	local lbl_tip5 = cc.Label:createWithTTF(ex.Tools:getLang(77759),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_tip5:setPosition(46.52, 18.7)
	lbl_tip5:setContentSize(44, 27.72)
	lbl_tip5:setAnchorPoint(cc.p(0, 0.5))
	lbl_tip5:setLocalZOrder(1)
	lbl_tip5:setTextColor(cc.c3b(255, 0, 0))
	lbl_tip5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	btn_rare5:addChild(lbl_tip5)
	self.lbl_tip5 = lbl_tip5

	 self:startLoadRes()
end
return HeroMagicWandSellLayer