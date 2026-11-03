local HeroMagicWandStrengthenLayer = class("HeroMagicWandStrengthenLayer", require("src.comp.CCCLayerBase")) 

function HeroMagicWandStrengthenLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 1020)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
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
	sp:setPosition(310, 629.43)
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

	local s = cc.Sprite:create()
	s:setPosition(310, 715.32)
	s:setContentSize(116, 34)
	self:addLoadRes(2, s, "ccbi-res/hero-magic-wand.plist", "ccbi-res/hero-magic-wand.pvr.ccz", "hero-magic-wand/titlebg1.png")
	self:addChild(s)
	self.s = s

	local lbl_equip_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_equip_name:setPosition(310, 713.01)
	lbl_equip_name:setContentSize(27.91, 29.2)
	lbl_equip_name:setTextColor(cc.c3b(255, 227, 183))
	lbl_equip_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_equip_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_equip_name:enableOutline(cc.c4b(87,56,29,255), 2)
	self:addChild(lbl_equip_name)
	self.lbl_equip_name = lbl_equip_name

	local l = cc.Label:createWithTTF(ex.Tools:getLang(57100),FONT_DEFAULT_NAME_BOLD, 20)
	l:setPosition(310, 874.01)
	l:setContentSize(82, 27.2)
	l:setTextColor(cc.c3b(255, 227, 183))
	l:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	l:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	l:enableOutline(cc.c4b(68,32,11,255), 1)
	self:addChild(l)
	self.l = l

	local update_layout = cc.Node:create()
	update_layout:setPosition(310, 678)
	update_layout:setContentSize(226, 35)
	update_layout:setAnchorPoint(cc.p(0.5, 0.5))
	update_layout:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 20, false)
	ly.node = update_layout
	update_layout.layoutex = ly
	self:addLyt(ly)
	self:addChild(update_layout)
	self.update_layout = update_layout

	local rere_layout = cc.Node:create()
	rere_layout:setPosition(52.65, 17.5)
	rere_layout:setContentSize(105.3, 35)
	rere_layout:setAnchorPoint(cc.p(0.5, 0.5))
	rere_layout:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 5, false)
	ly.node = rere_layout
	rere_layout.layoutex = ly
	self:addLyt(ly)
	update_layout:addChild(rere_layout)
	self.rere_layout = rere_layout

	local l = cc.Label:createWithTTF(ex.Tools:getLang(57174),FONT_DEFAULT_NAME_BOLD, 22)
	l:setPosition(70, 14.5)
	l:setContentSize(70, 31.72)
	l:setAnchorPoint(cc.p(1, 0.5))
	l:setTextColor(cc.c3b(253, 252, 224))
	l:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	l:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	l:enableOutline(cc.c4b(87,56,29,255), 2)
	rere_layout:addChild(l)
	self.l = l

	local lbl_rare = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_rare:setPosition(75, 14.5)
	lbl_rare:setContentSize(30.3, 31.72)
	lbl_rare:setAnchorPoint(cc.p(0, 0.5))
	lbl_rare:setTextColor(cc.c3b(253, 252, 224))
	lbl_rare:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rare:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rare:enableOutline(cc.c4b(87,56,29,255), 2)
	rere_layout:addChild(lbl_rare)
	self.lbl_rare = lbl_rare

	local level_layout = cc.Node:create()
	level_layout:setPosition(175.65, 17.5)
	level_layout:setContentSize(100.7, 35)
	level_layout:setAnchorPoint(cc.p(0.5, 0.5))
	level_layout:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 5, false)
	ly.node = level_layout
	level_layout.layoutex = ly
	self:addLyt(ly)
	update_layout:addChild(level_layout)
	self.level_layout = level_layout

	local l = cc.Label:createWithTTF(ex.Tools:getLang(57175),FONT_DEFAULT_NAME_BOLD, 22)
	l:setPosition(70, 14.5)
	l:setContentSize(70, 31.72)
	l:setAnchorPoint(cc.p(1, 0.5))
	l:setTextColor(cc.c3b(253, 252, 224))
	l:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	l:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	l:enableOutline(cc.c4b(87,56,29,255), 2)
	level_layout:addChild(l)
	self.l = l

	local lbl_level = cc.Label:createWithTTF(ex.Tools:getLang(5151),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_level:setPosition(75, 14.5)
	lbl_level:setContentSize(25.7, 27.72)
	lbl_level:setAnchorPoint(cc.p(0, 0.5))
	lbl_level:setTextColor(cc.c3b(255, 0, 0))
	lbl_level:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_level:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	level_layout:addChild(lbl_level)
	self.lbl_level = lbl_level

	local node_title = cc.Node:create()
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

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57184),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -48.18)
	lbl_title:setContentSize(228, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local node_res_need_2 = cc.Node:create()
	node_res_need_2:setPosition(381.52, 158)
	node_res_need_2:setContentSize(120, 40)
	node_res_need_2:setAnchorPoint(cc.p(0.5, 0.5))
	node_res_need_2:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_res_need_2)
	lyt:setLeftMargin(321.52)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(138)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_res_need_2.lyt = lyt
	self:addChild(node_res_need_2)
	self.node_res_need_2 = node_res_need_2

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(0, 20)
	CCSprite:setContentSize(145, 37)
	CCSprite:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, CCSprite, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-res-bg.png")
	node_res_need_2:addChild(CCSprite)

	local spr_res_need_2 = cc.Sprite:create()
	spr_res_need_2:setPosition(9.26, 20)
	spr_res_need_2:setContentSize(62, 84)
	spr_res_need_2:setScale(0.5, 0.5)
	self:addLoadRes(2, spr_res_need_2, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/900002.png")
	node_res_need_2:addChild(spr_res_need_2)
	self.spr_res_need_2 = spr_res_need_2

	local lbl_res_need_2 = cc.Label:createWithTTF("99999",FONT_DEFAULT_NAME_BOLD, 44)
	lbl_res_need_2:setPosition(81.21, 19)
	lbl_res_need_2:setContentSize(125.47, 55.44)
	lbl_res_need_2:setScale(0.5, 0.5)
	lbl_res_need_2:setTextColor(cc.c3b(255, 229, 191))
	lbl_res_need_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_res_need_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_res_need_2:addChild(lbl_res_need_2)
	self.lbl_res_need_2 = lbl_res_need_2

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(60, 20)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	node_res_need_2:addChild(UIMenu)

	local btn_res_info2 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_res_info2:setPosition(-50.61, 0)
	btn_res_info2:setContentSize(40, 40)
	btn_res_info2:registerScriptTapHandler(handler(self, self.onItemInfo))
	UIMenu:addChild(btn_res_info2)
	self.btn_res_info2 = btn_res_info2

	local node_res_need_1 = cc.Node:create()
	node_res_need_1:setPosition(211.52, 157.8)
	node_res_need_1:setContentSize(120, 40)
	node_res_need_1:setAnchorPoint(cc.p(0.5, 0.5))
	node_res_need_1:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_res_need_1)
	lyt:setLeftMargin(151.52)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(137.8)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_res_need_1.lyt = lyt
	self:addChild(node_res_need_1)
	self.node_res_need_1 = node_res_need_1

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(0, 20)
	CCSprite:setContentSize(145, 37)
	CCSprite:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, CCSprite, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-res-bg.png")
	node_res_need_1:addChild(CCSprite)

	local spr_res_need_1 = cc.Sprite:create()
	spr_res_need_1:setPosition(9.26, 20)
	spr_res_need_1:setContentSize(62, 84)
	spr_res_need_1:setScale(0.5, 0.5)
	self:addLoadRes(2, spr_res_need_1, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/900002.png")
	node_res_need_1:addChild(spr_res_need_1)
	self.spr_res_need_1 = spr_res_need_1

	local lbl_res_need_1 = cc.Label:createWithTTF("99999",FONT_DEFAULT_NAME_BOLD, 44)
	lbl_res_need_1:setPosition(81.21, 19)
	lbl_res_need_1:setContentSize(125.47, 55.44)
	lbl_res_need_1:setScale(0.5, 0.5)
	lbl_res_need_1:setTextColor(cc.c3b(255, 229, 191))
	lbl_res_need_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_res_need_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_res_need_1:addChild(lbl_res_need_1)
	self.lbl_res_need_1 = lbl_res_need_1

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(60, 20)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	node_res_need_1:addChild(UIMenu)

	local btn_res_info1 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_res_info1:setPosition(-50.61, 0)
	btn_res_info1:setContentSize(40, 40)
	btn_res_info1:registerScriptTapHandler(handler(self, self.onItemInfo))
	UIMenu:addChild(btn_res_info1)
	self.btn_res_info1 = btn_res_info1

	local menu = cpp.UIMenu:create()
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

	local btn_reset = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_reset:setPosition(-80, 87.98)
	btn_reset:setContentSize(134, 56)
	btn_reset:registerScriptTapHandler(handler(self, self.onClose))
	btn_reset:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_reset:setLabelOffset(cc.p(0, 0))
	btn_reset:setLabelSize(44)
	btn_reset:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_reset:setLabelText(ex.Tools:getLang(74223))
	self:addLoadRes(3, btn_reset, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_reset)
	self.btn_reset = btn_reset

	local btn_enter = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_enter:setPosition(80, 87.98)
	btn_enter:setContentSize(134, 56)
	btn_enter:registerScriptTapHandler(handler(self, self.onUplevel))
	btn_enter:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_enter:setLabelOffset(cc.p(0, 0))
	btn_enter:setLabelSize(44)
	btn_enter:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_enter:setLabelText(ex.Tools:getLang(57165))
	self:addLoadRes(3, btn_enter, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-big-1.png"})
	menu:addChild(btn_enter)
	self.btn_enter = btn_enter

	local btn_max_level = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_max_level:setPosition(80, 87.98)
	btn_max_level:setContentSize(122, 50)
	btn_max_level:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_max_level:setLabelOffset(cc.p(0, 0))
	btn_max_level:setLabelSize(44)
	btn_max_level:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_max_level:setLabelText(ex.Tools:getLang(57176))
	self:addLoadRes(3, btn_max_level, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-yimanji.png"})
	menu:addChild(btn_max_level)
	self.btn_max_level = btn_max_level

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(250, 1020)
	btn_close:setContentSize(53, 56)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(-231.41, 861.08)
	btn_info:setContentSize(58, 59)
	btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png"})
	menu:addChild(btn_info)
	self.btn_info = btn_info

	local btn_equip = require("src.comp.menu.UIMenuItemBag"):createWithData(0, 0)
	btn_equip:setPosition(-1.5, 800)
	menu:addChild(btn_equip)
	self.btn_equip = btn_equip

	local btn_preview = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_preview:setPosition(224.41, 488.75)
	btn_preview:setContentSize(96, 38)
	btn_preview:registerScriptTapHandler(handler(self, self.onPreview))
	btn_preview:getLabel():setTextColor(cc.c4b(241, 211, 139, 255))
	btn_preview:setLabelOffset(cc.p(0, -2))
	btn_preview:setLabelSize(36)
	btn_preview:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_preview:setLabelText(ex.Tools:getLang(57160))
	self:addLoadRes(3, btn_preview, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/spr-red-bg.png"})
	menu:addChild(btn_preview)
	self.btn_preview = btn_preview

	local node_attr = cc.Node:create()
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
	s:setPosition(310, 48)
	s:setContentSize(560, 72)
	s:setAnchorPoint(cc.p(0.5, 0.5))
	s:setIgnoreAnchorPointForPosition(false)
	node_attr:addChild(s)
	self.s = s

	local node_attr1 = cc.Node:create()
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
	n:setPosition(55, 18)
	n:setContentSize(51.33, 30)
	n:setAnchorPoint(cc.p(0, 0.5))
	n:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 0, false)
	ly.node = n
	n.layoutex = ly
	self:addLyt(ly)
	node_attr1:addChild(n)
	self.n = n

	local lbl_attr1 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr1:setPosition(0, 15)
	lbl_attr1:setContentSize(51.33, 27.72)
	lbl_attr1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr1:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_attr1)
	self.lbl_attr1 = lbl_attr1

	local spr_attr_up1 = cc.Sprite:create()
	spr_attr_up1:setPosition(190, 18)
	spr_attr_up1:setContentSize(21, 26)
	self:addLoadRes(2, spr_attr_up1, "ccbi-res/pvp.plist", "ccbi-res/pvp.pvr.ccz", "pvp/spr-up.png")
	node_attr1:addChild(spr_attr_up1)
	self.spr_attr_up1 = spr_attr_up1

	local lbl_attr_up1 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_up1:setPosition(215, 18)
	lbl_attr_up1:setContentSize(11.99, 22.68)
	lbl_attr_up1:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_up1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_up1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr1:addChild(lbl_attr_up1)
	self.lbl_attr_up1 = lbl_attr_up1

	local node_attr2 = cc.Node:create()
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
	n:setPosition(55, 18)
	n:setContentSize(51.33, 30)
	n:setAnchorPoint(cc.p(0, 0.5))
	n:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 0, false)
	ly.node = n
	n.layoutex = ly
	self:addLyt(ly)
	node_attr2:addChild(n)
	self.n = n

	local lbl_attr2 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr2:setPosition(0, 15)
	lbl_attr2:setContentSize(51.33, 27.72)
	lbl_attr2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr2:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_attr2)
	self.lbl_attr2 = lbl_attr2

	local spr_attr_up2 = cc.Sprite:create()
	spr_attr_up2:setPosition(190, 18)
	spr_attr_up2:setContentSize(21, 26)
	self:addLoadRes(2, spr_attr_up2, "ccbi-res/pvp.plist", "ccbi-res/pvp.pvr.ccz", "pvp/spr-up.png")
	node_attr2:addChild(spr_attr_up2)
	self.spr_attr_up2 = spr_attr_up2

	local lbl_attr_up2 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_up2:setPosition(215, 18)
	lbl_attr_up2:setContentSize(11.99, 22.68)
	lbl_attr_up2:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_up2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_up2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr2:addChild(lbl_attr_up2)
	self.lbl_attr_up2 = lbl_attr_up2

	local node_attr_rand = cc.Node:create()
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

	local lbl_attr_rand1 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand1:setPosition(55, 24)
	lbl_attr_rand1:setContentSize(51.33, 27.72)
	lbl_attr_rand1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand1:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand1:addChild(lbl_attr_rand1)
	self.lbl_attr_rand1 = lbl_attr_rand1

	local node_attr_rand2 = cc.Node:create()
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

	local lbl_attr_rand2 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand2:setPosition(55, 24)
	lbl_attr_rand2:setContentSize(51.33, 27.72)
	lbl_attr_rand2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand2:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand2:addChild(lbl_attr_rand2)
	self.lbl_attr_rand2 = lbl_attr_rand2

	local node_attr_rand3 = cc.Node:create()
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

	local lbl_attr_rand3 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand3:setPosition(55, 24)
	lbl_attr_rand3:setContentSize(51.33, 27.72)
	lbl_attr_rand3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand3:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand3:addChild(lbl_attr_rand3)
	self.lbl_attr_rand3 = lbl_attr_rand3

	local node_attr_rand4 = cc.Node:create()
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

	local lbl_attr_rand4 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand4:setPosition(55, 24)
	lbl_attr_rand4:setContentSize(51.33, 27.72)
	lbl_attr_rand4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand4:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand4:addChild(lbl_attr_rand4)
	self.lbl_attr_rand4 = lbl_attr_rand4

	local lbl_cost_tip = cc.Label:createWithTTF(ex.Tools:getLang(5561),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_cost_tip:setPosition(140, 157.8)
	lbl_cost_tip:setContentSize(50, 32.24)
	lbl_cost_tip:setAnchorPoint(cc.p(1, 0.5))
	lbl_cost_tip:setTextColor(cc.c3b(253, 252, 224))
	lbl_cost_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_cost_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_cost_tip:enableOutline(cc.c4b(68,32,11,255), 1)
	self:addChild(lbl_cost_tip)
	self.lbl_cost_tip = lbl_cost_tip

	 self:startLoadRes()
end
return HeroMagicWandStrengthenLayer