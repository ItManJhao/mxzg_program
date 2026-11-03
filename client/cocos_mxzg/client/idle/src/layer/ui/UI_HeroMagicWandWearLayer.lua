local HeroMagicWandWearLayer = class("HeroMagicWandWearLayer", require("src.comp.CCCLayerBase")) 

function HeroMagicWandWearLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 1020)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
	local s = cc.Scale9Sprite:create()
	s:setPosition(0, 0)
	s:setContentSize(620, 1020)
	s:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, s, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-11.png", capInsets = cc.rect(58,64,56,71)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(s)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	s.lyt = lyt
	self:addChild(s)
	self.s = s

	local s = cc.Scale9Sprite:create()
	s:setPosition(310, 556.02)
	s:setContentSize(570, 726)
	self:addLoadRes(1, s, "ccbi-res/hero-magic-wand.plist", "ccbi-res/hero-magic-wand.pvr.ccz", {frame = "hero-magic-wand/bg1.png", capInsets = cc.rect(54,267,57,37)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(s)
	lyt:setLeftMargin(25)
	lyt:setRightMargin(25)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(100.98)
	lyt:setBottomMargin(193.02)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	s.lyt = lyt
	self:addChild(s)
	self.s = s

	local sp = cc.Sprite:create()
	sp:setPosition(310, 630)
	sp:setContentSize(497, 16)
	self:addLoadRes(2, sp, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-parttern.png")
	self:addChild(sp)
	self.sp = sp

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57161),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(310, 629.98)
	lbl_title:setContentSize(92, 31.72)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	self:addChild(lbl_title)
	self.lbl_title = lbl_title

	local sp = cc.Sprite:create()
	sp:setPosition(310, 487.78)
	sp:setContentSize(497, 16)
	self:addLoadRes(2, sp, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-parttern.png")
	self:addChild(sp)
	self.sp = sp

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57162),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(310, 488.33)
	lbl_title:setContentSize(92, 31.72)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	self:addChild(lbl_title)
	self.lbl_title = lbl_title

	local node_title = cc.Node:create()
	node_title:setCascadeOpacityEnabled(true)
	node_title:setPosition(310, 1008.57)
	node_title:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(11.43)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_title.lyt = lyt
	self:addChild(node_title)
	self.node_title = node_title

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(0, 0)
	spr_title_bg:setContentSize(225, 72)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/title-bar-4.png", capInsets = cc.rect(0,0,0,0)})
	node_title:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57101),FONT_DEFAULT_NAME_BOLD, 56)
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
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(310, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(250, 1020)
	btn_close:setContentSize(53, 56)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local btn_list = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_list:setPosition(-231.41, 861.08)
	btn_list:setContentSize(73, 75)
	btn_list:registerScriptTapHandler(handler(self, self.onIllustrate))
	btn_list:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_list:setLabelOffset(cc.p(0, -28))
	btn_list:setLabelSize(36)
	btn_list:setLabelOutLine(cc.c4b(127,235,255,255), 2)
	btn_list:setLabelText(ex.Tools:getLang(57172))
	self:addLoadRes(3, btn_list, "ccbi-res/hero-magic-wand.plist", "ccbi-res/hero-magic-wand.pvr.ccz", {spr1="hero-magic-wand/btn-mzlb.png"})
	menu:addChild(btn_list)
	self.btn_list = btn_list

	local btn_equip = require("src.comp.menu.UIMenuItemBag"):createWithData(0, 0)
	btn_equip:setPosition(-1.5, 800)
	btn_equip:registerScriptTapHandler(handler(self, self.onEquip))
	menu:addChild(btn_equip)
	self.btn_equip = btn_equip

	local btn_preview = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_preview:setPosition(224.41, 488.75)
	btn_preview:setContentSize(96, 38)
	btn_preview:registerScriptTapHandler(handler(self, self.onAttrPreview))
	btn_preview:getLabel():setTextColor(cc.c4b(241, 211, 139, 255))
	btn_preview:setLabelOffset(cc.p(0, -2))
	btn_preview:setLabelSize(36)
	btn_preview:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_preview:setLabelText(ex.Tools:getLang(57160))
	self:addLoadRes(3, btn_preview, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/spr-red-bg.png"})
	menu:addChild(btn_preview)
	self.btn_preview = btn_preview

	local btn_up_level = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_up_level:setPosition(-130, 136)
	btn_up_level:setContentSize(134, 56)
	btn_up_level:registerScriptTapHandler(handler(self, self.onUpLevel))
	btn_up_level:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_up_level:setLabelOffset(cc.p(0, -2))
	btn_up_level:setLabelSize(44)
	btn_up_level:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_up_level:setLabelText(ex.Tools:getLang(57165))
	self:addLoadRes(3, btn_up_level, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_up_level)
	self.btn_up_level = btn_up_level

	local btn_refine = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_refine:setPosition(100, 136)
	btn_refine:setContentSize(134, 56)
	btn_refine:registerScriptTapHandler(handler(self, self.onRefine))
	btn_refine:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_refine:setLabelOffset(cc.p(0, -2))
	btn_refine:setLabelSize(44)
	btn_refine:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_refine:setLabelText(ex.Tools:getLang(5070))
	self:addLoadRes(3, btn_refine, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_refine)
	self.btn_refine = btn_refine

	local btn_take_off = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_take_off:setPosition(-129, 75)
	btn_take_off:setContentSize(134, 56)
	btn_take_off:registerScriptTapHandler(handler(self, self.onTakeOff))
	btn_take_off:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_take_off:setLabelOffset(cc.p(0, -2))
	btn_take_off:setLabelSize(44)
	btn_take_off:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_take_off:setLabelText(ex.Tools:getLang(5509))
	self:addLoadRes(3, btn_take_off, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_take_off)
	self.btn_take_off = btn_take_off

	local btn_wear = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_wear:setPosition(100, 75)
	btn_wear:setContentSize(134, 56)
	btn_wear:registerScriptTapHandler(handler(self, self.onWear))
	btn_wear:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_wear:setLabelOffset(cc.p(0, -2))
	btn_wear:setLabelSize(44)
	btn_wear:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_wear:setLabelText(ex.Tools:getLang(41148))
	self:addLoadRes(3, btn_wear, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_wear)
	self.btn_wear = btn_wear

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(253.11, 630)
	btn_info:setContentSize(58, 59)
	btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png"})
	menu:addChild(btn_info)
	self.btn_info = btn_info

	local btn_select = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_select:setPosition(-1.5, 800)
	btn_select:setContentSize(100, 100)
	btn_select:registerScriptTapHandler(handler(self, self.onSelectEquip))
	menu:addChild(btn_select)
	self.btn_select = btn_select

	local node_attr = cc.Node:create()
	node_attr:setCascadeOpacityEnabled(true)
	node_attr:setPosition(310, 559.64)
	node_attr:setContentSize(620, 96)
	node_attr:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr:setIgnoreAnchorPointForPosition(false)
	self:addChild(node_attr)
	self.node_attr = node_attr

	local CCScale9Sprite = cc.Scale9Sprite:create()
	CCScale9Sprite:setPosition(310, 48)
	CCScale9Sprite:setContentSize(550, 96)
	self:addLoadRes(1, CCScale9Sprite, "ccbi-res/fantasyland.plist", "ccbi-res/fantasyland.pvr.ccz", {frame = "fantasy-land/spr-cell-bg.png", capInsets = cc.rect(9,11,11,10)})
	node_attr:addChild(CCScale9Sprite)

	local s = cc.Node:create()
	s:setCascadeOpacityEnabled(true)
	s:setPosition(310, 48)
	s:setContentSize(560, 72)
	s:setAnchorPoint(cc.p(0.5, 0.5))
	s:setIgnoreAnchorPointForPosition(false)
	node_attr:addChild(s)
	self.s = s

	local node_attr1 = cc.Node:create()
	node_attr1:setCascadeOpacityEnabled(true)
	node_attr1:setPosition(30, 36)
	node_attr1:setContentSize(0, 36)
	node_attr1:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr1:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr1)
	self.node_attr1 = node_attr1

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 18)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr1:addChild(ss)
	self.ss = ss

	local spr_icon1 = cc.Sprite:create()
	spr_icon1:setPosition(0, 18)
	spr_icon1:setContentSize(48, 48)
	spr_icon1:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_icon1, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-201.png")
	node_attr1:addChild(spr_icon1)
	self.spr_icon1 = spr_icon1

	local n = cc.Node:create()
	n:setCascadeOpacityEnabled(true)
	n:setPosition(55, 18)
	n:setContentSize(44, 30)
	n:setAnchorPoint(cc.p(0, 0.5))
	n:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 0, false)
	ly.node = n
	n.layoutex = ly
	self:addLyt(ly)
	node_attr1:addChild(n)
	self.n = n

	local lbl_attr1 = cc.Label:createWithTTF("统御",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr1:setPosition(0, 15)
	lbl_attr1:setContentSize(44, 27.72)
	lbl_attr1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr1:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_attr1)
	self.lbl_attr1 = lbl_attr1

	local node_attr2 = cc.Node:create()
	node_attr2:setCascadeOpacityEnabled(true)
	node_attr2:setPosition(280, 36)
	node_attr2:setContentSize(0, 36)
	node_attr2:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr2:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr2)
	self.node_attr2 = node_attr2

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 18)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr2:addChild(ss)
	self.ss = ss

	local spr_icon2 = cc.Sprite:create()
	spr_icon2:setPosition(0, 18)
	spr_icon2:setContentSize(48, 48)
	spr_icon2:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_icon2, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-201.png")
	node_attr2:addChild(spr_icon2)
	self.spr_icon2 = spr_icon2

	local n = cc.Node:create()
	n:setCascadeOpacityEnabled(true)
	n:setPosition(55, 18)
	n:setContentSize(44, 30)
	n:setAnchorPoint(cc.p(0, 0.5))
	n:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 0, false)
	ly.node = n
	n.layoutex = ly
	self:addLyt(ly)
	node_attr2:addChild(n)
	self.n = n

	local lbl_attr2 = cc.Label:createWithTTF("统御",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr2:setPosition(0, 15)
	lbl_attr2:setContentSize(44, 27.72)
	lbl_attr2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr2:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_attr2)
	self.lbl_attr2 = lbl_attr2

	local lbl_tip_null = cc.Label:createWithTTF(ex.Tools:getLang(57183),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_tip_null:setPosition(310, 48)
	lbl_tip_null:setContentSize(132, 27.72)
	lbl_tip_null:setTextColor(cc.c3b(102, 54, 34))
	lbl_tip_null:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip_null:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr:addChild(lbl_tip_null)
	self.lbl_tip_null = lbl_tip_null

	local node_attr_rand = cc.Node:create()
	node_attr_rand:setCascadeOpacityEnabled(true)
	node_attr_rand:setPosition(310, 347.8)
	node_attr_rand:setContentSize(620, 234)
	node_attr_rand:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand:setIgnoreAnchorPointForPosition(false)
	self:addChild(node_attr_rand)
	self.node_attr_rand = node_attr_rand

	local ss = cc.Scale9Sprite:create()
	ss:setPosition(310, 117)
	ss:setContentSize(550, 234)
	self:addLoadRes(1, ss, "ccbi-res/fantasyland.plist", "ccbi-res/fantasyland.pvr.ccz", {frame = "fantasy-land/spr-cell-bg.png", capInsets = cc.rect(9,11,11,10)})
	node_attr_rand:addChild(ss)
	self.ss = ss

	local s = cc.Node:create()
	s:setCascadeOpacityEnabled(true)
	s:setPosition(310, 214.21)
	s:setContentSize(560, 192)
	s:setAnchorPoint(cc.p(0.5, 1))
	s:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 0, 0, 0, false)
	ly.node = s
	s.layoutex = ly
	self:addLyt(ly)
	node_attr_rand:addChild(s)
	self.s = s

	local node_attr_rand1 = cc.Node:create()
	node_attr_rand1:setCascadeOpacityEnabled(true)
	node_attr_rand1:setPosition(17.83, 168)
	node_attr_rand1:setContentSize(0, 48)
	node_attr_rand1:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand1:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr_rand1)
	self.node_attr_rand1 = node_attr_rand1

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_rand1:addChild(ss)
	self.ss = ss

	local spr_icon_rand1 = cc.Sprite:create()
	spr_icon_rand1:setPosition(22.76, 24)
	spr_icon_rand1:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon_rand1, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr_rand1:addChild(spr_icon_rand1)
	self.spr_icon_rand1 = spr_icon_rand1

	local lbl_attr_rand1 = cc.Label:createWithTTF("统御",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand1:setPosition(55, 24)
	lbl_attr_rand1:setContentSize(44, 27.72)
	lbl_attr_rand1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand1:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand1:addChild(lbl_attr_rand1)
	self.lbl_attr_rand1 = lbl_attr_rand1

	local node_attr_rand2 = cc.Node:create()
	node_attr_rand2:setCascadeOpacityEnabled(true)
	node_attr_rand2:setPosition(17.83, 120)
	node_attr_rand2:setContentSize(0, 48)
	node_attr_rand2:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand2:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr_rand2)
	self.node_attr_rand2 = node_attr_rand2

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_rand2:addChild(ss)
	self.ss = ss

	local spr_icon_rand2 = cc.Sprite:create()
	spr_icon_rand2:setPosition(22.76, 24)
	spr_icon_rand2:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon_rand2, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr_rand2:addChild(spr_icon_rand2)
	self.spr_icon_rand2 = spr_icon_rand2

	local lbl_attr_rand2 = cc.Label:createWithTTF("统御",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand2:setPosition(55, 24)
	lbl_attr_rand2:setContentSize(44, 27.72)
	lbl_attr_rand2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand2:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand2:addChild(lbl_attr_rand2)
	self.lbl_attr_rand2 = lbl_attr_rand2

	local node_attr_rand3 = cc.Node:create()
	node_attr_rand3:setCascadeOpacityEnabled(true)
	node_attr_rand3:setPosition(17.83, 72)
	node_attr_rand3:setContentSize(0, 48)
	node_attr_rand3:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand3:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr_rand3)
	self.node_attr_rand3 = node_attr_rand3

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_rand3:addChild(ss)
	self.ss = ss

	local spr_icon_rand3 = cc.Sprite:create()
	spr_icon_rand3:setPosition(22.76, 24)
	spr_icon_rand3:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon_rand3, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr_rand3:addChild(spr_icon_rand3)
	self.spr_icon_rand3 = spr_icon_rand3

	local lbl_attr_rand3 = cc.Label:createWithTTF("统御",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand3:setPosition(55, 24)
	lbl_attr_rand3:setContentSize(44, 27.72)
	lbl_attr_rand3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand3:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand3:addChild(lbl_attr_rand3)
	self.lbl_attr_rand3 = lbl_attr_rand3

	local node_attr_rand4 = cc.Node:create()
	node_attr_rand4:setCascadeOpacityEnabled(true)
	node_attr_rand4:setPosition(17.83, 24)
	node_attr_rand4:setContentSize(0, 48)
	node_attr_rand4:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand4:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr_rand4)
	self.node_attr_rand4 = node_attr_rand4

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_rand4:addChild(ss)
	self.ss = ss

	local spr_icon_rand4 = cc.Sprite:create()
	spr_icon_rand4:setPosition(22.76, 24)
	spr_icon_rand4:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon_rand4, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr_rand4:addChild(spr_icon_rand4)
	self.spr_icon_rand4 = spr_icon_rand4

	local lbl_attr_rand4 = cc.Label:createWithTTF("统御",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand4:setPosition(55, 24)
	lbl_attr_rand4:setContentSize(44, 27.72)
	lbl_attr_rand4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand4:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand4:addChild(lbl_attr_rand4)
	self.lbl_attr_rand4 = lbl_attr_rand4

	 self:startLoadRes()
end
return HeroMagicWandWearLayer