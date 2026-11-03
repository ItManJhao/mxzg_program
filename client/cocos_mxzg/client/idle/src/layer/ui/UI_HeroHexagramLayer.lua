local HeroHexagramLayer = class("HeroHexagramLayer", require("src.comp.CCCLayerBase")) 

function HeroHexagramLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 1020)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(620, 1020)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-11.png", capInsets = cc.rect(58,64,56,71)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg.lyt = lyt
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local spr_bg_2 = cc.Sprite:create()
	spr_bg_2:setPosition(310, 575)
	spr_bg_2:setContentSize(569, 732)
	self:addLoadRes(2, spr_bg_2, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-bg.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg_2)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(79)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_bg_2.lyt = lyt
	self:addChild(spr_bg_2)
	self.spr_bg_2 = spr_bg_2

	local spr_rock_1 = cc.Sprite:create()
	spr_rock_1:setPosition(122, 810)
	spr_rock_1:setContentSize(45, 49)
	self:addLoadRes(2, spr_rock_1, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-rock-1.png")
	self:addChild(spr_rock_1)
	self.spr_rock_1 = spr_rock_1

	local spr_rock_2 = cc.Sprite:create()
	spr_rock_2:setPosition(125, 638)
	spr_rock_2:setContentSize(50, 70)
	self:addLoadRes(2, spr_rock_2, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-rock-2.png")
	self:addChild(spr_rock_2)
	self.spr_rock_2 = spr_rock_2

	local spr_rock_3 = cc.Sprite:create()
	spr_rock_3:setPosition(500, 712)
	spr_rock_3:setContentSize(48, 76)
	self:addLoadRes(2, spr_rock_3, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-rock-3.png")
	self:addChild(spr_rock_3)
	self.spr_rock_3 = spr_rock_3

	local node_title = cc.Node:create()
	node_title:setPosition(310, 1020)
	node_title:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_title.lyt = lyt
	self:addChild(node_title)
	self.node_title = node_title

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(0, 0)
	spr_title_bg:setContentSize(184, 67)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/title-bar-3.png", capInsets = cc.rect(0,0,0,0)})
	node_title:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57000),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -42.4)
	lbl_title:setContentSize(116, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

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

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(250, 1020)
	btn_close:setContentSize(53, 56)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local btn_left = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_left:setPosition(-250, 660)
	btn_left:setContentSize(46, 68)
	self:addLoadRes(3, btn_left, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-left.png"})
	menu:addChild(btn_left)
	self.btn_left = btn_left

	local btn_right = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_right:setPosition(250, 660)
	btn_right:setContentSize(46, 68)
	self:addLoadRes(3, btn_right, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-right.png"})
	menu:addChild(btn_right)
	self.btn_right = btn_right

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(250, 800)
	btn_info:setContentSize(58, 59)
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png"})
	menu:addChild(btn_info)
	self.btn_info = btn_info

	local spr_circle = cc.Sprite:create()
	spr_circle:setPosition(310, 715.2)
	spr_circle:setContentSize(514, 518)
	spr_circle:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_circle, "ccbi-res/hero-info.plist", "ccbi-res/hero-info.pvr.ccz", "hero-info/spr-circle.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_circle)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	spr_circle.lyt = lyt
	self:addChild(spr_circle)
	self.spr_circle = spr_circle

	local node_effect = cc.Sprite:create()
	node_effect:setPosition(262, 264)
	node_effect:setContentSize(0, 0)
	spr_circle:addChild(node_effect)
	self.node_effect = node_effect

	local node_tab = cc.Node:create()
	node_tab:setPosition(310, 895)
	node_tab:setContentSize(0, 0)
	self:addChild(node_tab)
	self.node_tab = node_tab

	local menu_type = cpp.UIMenu:create()
	menu_type:setPosition(0, 0)
	menu_type:setContentSize(486, 50)
	menu_type:setAnchorPoint(cc.p(0.5, 0.5))
	menu_type:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_type)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	menu_type.lyt = lyt
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 30, true)
	ly.node = menu_type
	menu_type.layoutex = ly
	self:addLyt(ly)
	node_tab:addChild(menu_type)
	self.menu_type = menu_type

	local btn_tab_1 = cpp.UIMenuItemTab:create("", nil, "", 1, 1)
	btn_tab_1:setPosition(28, 25)
	btn_tab_1:setContentSize(56, 56)
	btn_tab_1:setTag(1)
	btn_tab_1:setLabelOffset(cc.p(0, 0))
	self:addLoadRes(3, btn_tab_1, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/btn-tab-1.png"})
	menu_type:addChild(btn_tab_1)
	self.btn_tab_1 = btn_tab_1

	local btn_tab_2 = cpp.UIMenuItemTab:create("", nil, "", 1, 1)
	btn_tab_2:setPosition(114, 25)
	btn_tab_2:setContentSize(56, 56)
	btn_tab_2:setTag(2)
	btn_tab_2:setLabelOffset(cc.p(0, 0))
	self:addLoadRes(3, btn_tab_2, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/btn-tab-2.png"})
	menu_type:addChild(btn_tab_2)
	self.btn_tab_2 = btn_tab_2

	local btn_tab_3 = cpp.UIMenuItemTab:create("", nil, "", 1, 1)
	btn_tab_3:setPosition(200, 25)
	btn_tab_3:setContentSize(56, 56)
	btn_tab_3:setTag(3)
	btn_tab_3:setLabelOffset(cc.p(0, 0))
	self:addLoadRes(3, btn_tab_3, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/btn-tab-3.png"})
	menu_type:addChild(btn_tab_3)
	self.btn_tab_3 = btn_tab_3

	local btn_tab_4 = cpp.UIMenuItemTab:create("", nil, "", 1, 1)
	btn_tab_4:setPosition(286, 25)
	btn_tab_4:setContentSize(56, 56)
	btn_tab_4:setTag(4)
	btn_tab_4:setLabelOffset(cc.p(0, 0))
	self:addLoadRes(3, btn_tab_4, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/btn-tab-4.png"})
	menu_type:addChild(btn_tab_4)
	self.btn_tab_4 = btn_tab_4

	local btn_tab_5 = cpp.UIMenuItemTab:create("", nil, "", 1, 1)
	btn_tab_5:setPosition(372, 25)
	btn_tab_5:setContentSize(56, 56)
	btn_tab_5:setTag(5)
	btn_tab_5:setLabelOffset(cc.p(0, 0))
	self:addLoadRes(3, btn_tab_5, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/btn-tab-5.png"})
	menu_type:addChild(btn_tab_5)
	self.btn_tab_5 = btn_tab_5

	local btn_tab_6 = cpp.UIMenuItemTab:create("", nil, "", 1, 1)
	btn_tab_6:setPosition(458, 25)
	btn_tab_6:setContentSize(56, 56)
	btn_tab_6:setTag(6)
	btn_tab_6:setLabelOffset(cc.p(0, 0))
	self:addLoadRes(3, btn_tab_6, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/btn-tab-6.png"})
	menu_type:addChild(btn_tab_6)
	self.btn_tab_6 = btn_tab_6

	local spr_select = cc.Sprite:create()
	spr_select:setPosition(-215, 0)
	spr_select:setContentSize(90, 90)
	spr_select:setScale(0.75, 0.75)
	spr_select:setLocalZOrder(2)
	self:addLoadRes(2, spr_select, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "other/spr-btn-select.png")
	node_tab:addChild(spr_select)
	self.spr_select = spr_select

	local lbl_name = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_name:setPosition(310, 607.34)
	lbl_name:setContentSize(84, 29.2)
	lbl_name:setTextColor(cc.c3b(253, 252, 224))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name:enableOutline(cc.c4b(87,56,29,255), 2)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_name)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	lbl_name.lyt = lyt
	self:addChild(lbl_name)
	self.lbl_name = lbl_name

	local node_elem = cc.Node:create()
	node_elem:setPosition(310, 560)
	node_elem:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_elem)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	node_elem.lyt = lyt
	self:addChild(node_elem)
	self.node_elem = node_elem

	local s = cc.Sprite:create()
	s:setPosition(0, 0)
	s:setContentSize(497, 16)
	self:addLoadRes(2, s, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-parttern.png")
	node_elem:addChild(s)
	self.s = s

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(5123),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title:setPosition(0, -1.63)
	lbl_title:setContentSize(84, 29.2)
	lbl_title:setTextColor(cc.c3b(241, 211, 139))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_elem:addChild(lbl_title)
	self.lbl_title = lbl_title

	local spr_red_bg = cc.Sprite:create()
	spr_red_bg:setPosition(225, 0)
	spr_red_bg:setContentSize(96, 38)
	self:addLoadRes(2, spr_red_bg, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-red-bg.png")
	node_elem:addChild(spr_red_bg)
	self.spr_red_bg = spr_red_bg

	local lbl_tip = cc.Label:createWithTTF(ex.Tools:getLang(57011),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_tip:setPosition(225, 0)
	lbl_tip:setContentSize(84, 29.2)
	lbl_tip:setTextColor(cc.c3b(255, 227, 183))
	lbl_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_tip:enableOutline(cc.c4b(87,56,29,255), 2)
	node_elem:addChild(lbl_tip)
	self.lbl_tip = lbl_tip

	local spr_cell_bg = cc.Scale9Sprite:create()
	spr_cell_bg:setPosition(0, -75)
	spr_cell_bg:setContentSize(540, 110)
	self:addLoadRes(1, spr_cell_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/cell-bg-12.png", capInsets = cc.rect(16,17,12,16)})
	node_elem:addChild(spr_cell_bg)
	self.spr_cell_bg = spr_cell_bg

	local node_attr_1 = cc.Node:create()
	node_attr_1:setPosition(-250, -50)
	node_attr_1:setContentSize(0, 0)
	node_elem:addChild(node_attr_1)
	self.node_attr_1 = node_attr_1

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_1:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_1 = cc.Sprite:create()
	spr_attr_1:setPosition(0, 0)
	spr_attr_1:setContentSize(48, 48)
	spr_attr_1:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_1, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-100.png")
	node_attr_1:addChild(spr_attr_1)
	self.spr_attr_1 = spr_attr_1

	local lbl_attr_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_1:setPosition(60, 0)
	lbl_attr_1:setContentSize(80, 25.2)
	lbl_attr_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_1:setTextColor(cc.c3b(87, 56, 29))
	lbl_attr_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_1:addChild(lbl_attr_1)
	self.lbl_attr_1 = lbl_attr_1

	local lbl_attr_extra_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_1:setPosition(60, 0)
	lbl_attr_extra_1:setContentSize(80, 25.2)
	lbl_attr_extra_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_1:setVisible(false)
	lbl_attr_extra_1:setTextColor(cc.c3b(115, 222, 64))
	lbl_attr_extra_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_1:addChild(lbl_attr_extra_1)
	self.lbl_attr_extra_1 = lbl_attr_extra_1

	local node_attr_2 = cc.Node:create()
	node_attr_2:setPosition(40, -50)
	node_attr_2:setContentSize(0, 0)
	node_elem:addChild(node_attr_2)
	self.node_attr_2 = node_attr_2

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_2:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_2 = cc.Sprite:create()
	spr_attr_2:setPosition(0, 0)
	spr_attr_2:setContentSize(48, 48)
	spr_attr_2:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_2, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-100.png")
	node_attr_2:addChild(spr_attr_2)
	self.spr_attr_2 = spr_attr_2

	local lbl_attr_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_2:setPosition(60, 0)
	lbl_attr_2:setContentSize(80, 25.2)
	lbl_attr_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_2:setTextColor(cc.c3b(87, 56, 29))
	lbl_attr_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_2:addChild(lbl_attr_2)
	self.lbl_attr_2 = lbl_attr_2

	local lbl_attr_extra_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_2:setPosition(60, 0)
	lbl_attr_extra_2:setContentSize(80, 25.2)
	lbl_attr_extra_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_2:setVisible(false)
	lbl_attr_extra_2:setTextColor(cc.c3b(115, 222, 64))
	lbl_attr_extra_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_2:addChild(lbl_attr_extra_2)
	self.lbl_attr_extra_2 = lbl_attr_extra_2

	local node_attr_3 = cc.Node:create()
	node_attr_3:setPosition(-250, -100)
	node_attr_3:setContentSize(0, 0)
	node_elem:addChild(node_attr_3)
	self.node_attr_3 = node_attr_3

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_3:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_3 = cc.Sprite:create()
	spr_attr_3:setPosition(0, 0)
	spr_attr_3:setContentSize(48, 48)
	spr_attr_3:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_3, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-100.png")
	node_attr_3:addChild(spr_attr_3)
	self.spr_attr_3 = spr_attr_3

	local lbl_attr_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_3:setPosition(60, 0)
	lbl_attr_3:setContentSize(80, 25.2)
	lbl_attr_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_3:setTextColor(cc.c3b(87, 56, 29))
	lbl_attr_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_3:addChild(lbl_attr_3)
	self.lbl_attr_3 = lbl_attr_3

	local lbl_attr_extra_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_3:setPosition(60, 0)
	lbl_attr_extra_3:setContentSize(80, 25.2)
	lbl_attr_extra_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_3:setVisible(false)
	lbl_attr_extra_3:setTextColor(cc.c3b(115, 222, 64))
	lbl_attr_extra_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_3:addChild(lbl_attr_extra_3)
	self.lbl_attr_extra_3 = lbl_attr_extra_3

	local node_attr_4 = cc.Node:create()
	node_attr_4:setPosition(40, -100)
	node_attr_4:setContentSize(0, 0)
	node_elem:addChild(node_attr_4)
	self.node_attr_4 = node_attr_4

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(20, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_4:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_4 = cc.Sprite:create()
	spr_attr_4:setPosition(0, 0)
	spr_attr_4:setContentSize(48, 48)
	spr_attr_4:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_4, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-100.png")
	node_attr_4:addChild(spr_attr_4)
	self.spr_attr_4 = spr_attr_4

	local lbl_attr_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_4:setPosition(60, 0)
	lbl_attr_4:setContentSize(80, 25.2)
	lbl_attr_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_4:setTextColor(cc.c3b(87, 56, 29))
	lbl_attr_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_4:addChild(lbl_attr_4)
	self.lbl_attr_4 = lbl_attr_4

	local lbl_attr_extra_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_4:setPosition(60, 0)
	lbl_attr_extra_4:setContentSize(80, 25.2)
	lbl_attr_extra_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_4:setVisible(false)
	lbl_attr_extra_4:setTextColor(cc.c3b(115, 222, 64))
	lbl_attr_extra_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_4:addChild(lbl_attr_extra_4)
	self.lbl_attr_extra_4 = lbl_attr_extra_4

	local node_skill = cc.Node:create()
	node_skill:setPosition(310, 404.34)
	node_skill:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_skill)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	node_skill.lyt = lyt
	self:addChild(node_skill)
	self.node_skill = node_skill

	local s = cc.Sprite:create()
	s:setPosition(0, 0)
	s:setContentSize(497, 16)
	self:addLoadRes(2, s, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-parttern.png")
	node_skill:addChild(s)
	self.s = s

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57010),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title:setPosition(-3.18, 0)
	lbl_title:setContentSize(84, 29.2)
	lbl_title:setTextColor(cc.c3b(241, 211, 139))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_skill:addChild(lbl_title)
	self.lbl_title = lbl_title

	local scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	scroll_view:setPosition(0, -10)
	scroll_view:setContentSize(540, 160)
	scroll_view:setAnchorPoint(cc.p(0.5, 1))
	scroll_view:setIgnoreAnchorPointForPosition(false)
	scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_view:setItemType(1)
	scroll_view:setItemSize(cc.size(535, 105))
	node_skill:addChild(scroll_view)
	self.scroll_view = scroll_view

	local lbl_tip = cc.Label:createWithTTF(ex.Tools:getLang(57023),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_tip:setPosition(310, 115.12)
	lbl_tip:setContentSize(28.69, 30.24)
	lbl_tip:setTextColor(cc.c3b(222, 0, 0))
	lbl_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_tip)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(100)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_tip.lyt = lyt
	self:addChild(lbl_tip)
	self.lbl_tip = lbl_tip

	local node_upgrade = cc.Node:create()
	node_upgrade:setPosition(310, 0)
	node_upgrade:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_upgrade)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_upgrade.lyt = lyt
	self:addChild(node_upgrade)
	self.node_upgrade = node_upgrade

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(5561),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_title:setPosition(-160, 160)
	lbl_title:setContentSize(50, 32.24)
	lbl_title:setTextColor(cc.c3b(253, 252, 224))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(68,32,11,255), 1)
	node_upgrade:addChild(lbl_title)
	self.lbl_title = lbl_title

	local node_res_need_1 = cc.Node:create()
	node_res_need_1:setPosition(-60, 160)
	node_res_need_1:setContentSize(120, 40)
	node_res_need_1:setAnchorPoint(cc.p(0.5, 0.5))
	node_res_need_1:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_res_need_1)
	lyt:setLeftMargin(-120)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(140)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_res_need_1.lyt = lyt
	node_upgrade:addChild(node_res_need_1)
	self.node_res_need_1 = node_res_need_1

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(0, 20)
	CCSprite:setContentSize(145, 37)
	CCSprite:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, CCSprite, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-res-bg.png")
	node_res_need_1:addChild(CCSprite)

	local lbl_res_need_1 = cc.Label:createWithTTF("99999",FONT_DEFAULT_NAME_BOLD, 44)
	lbl_res_need_1:setPosition(50, 20)
	lbl_res_need_1:setContentSize(125.47, 55.44)
	lbl_res_need_1:setScale(0.5, 0.5)
	lbl_res_need_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_res_need_1:setTextColor(cc.c3b(253, 252, 224))
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

	local btn_res_need_1 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_res_need_1:setPosition(-50.61, 0)
	btn_res_need_1:setContentSize(62, 84)
	btn_res_need_1:setScale(0.5, 0.5)
	btn_res_need_1:registerScriptTapHandler(handler(self, self.onItemInfo))
	self:addLoadRes(3, btn_res_need_1, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", {spr1="backpack/900002.png"})
	UIMenu:addChild(btn_res_need_1)
	self.btn_res_need_1 = btn_res_need_1

	local node_res_need_2 = cc.Node:create()
	node_res_need_2:setPosition(110, 160.2)
	node_res_need_2:setContentSize(120, 40)
	node_res_need_2:setAnchorPoint(cc.p(0.5, 0.5))
	node_res_need_2:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_res_need_2)
	lyt:setLeftMargin(50)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(140.2)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_res_need_2.lyt = lyt
	node_upgrade:addChild(node_res_need_2)
	self.node_res_need_2 = node_res_need_2

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(0, 20)
	CCSprite:setContentSize(145, 37)
	CCSprite:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, CCSprite, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-res-bg.png")
	node_res_need_2:addChild(CCSprite)

	local lbl_res_need_2 = cc.Label:createWithTTF("99999",FONT_DEFAULT_NAME_BOLD, 44)
	lbl_res_need_2:setPosition(50, 20)
	lbl_res_need_2:setContentSize(125.47, 55.44)
	lbl_res_need_2:setScale(0.5, 0.5)
	lbl_res_need_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_res_need_2:setTextColor(cc.c3b(253, 252, 224))
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

	local btn_res_need_2 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_res_need_2:setPosition(-50.61, 0)
	btn_res_need_2:setContentSize(62, 84)
	btn_res_need_2:setScale(0.5, 0.5)
	btn_res_need_2:registerScriptTapHandler(handler(self, self.onItemInfo))
	self:addLoadRes(3, btn_res_need_2, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", {spr1="backpack/900002.png"})
	UIMenu:addChild(btn_res_need_2)
	self.btn_res_need_2 = btn_res_need_2

	local menu = cpp.UIMenu:create()
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	menu.lyt = lyt
	node_upgrade:addChild(menu)
	self.menu = menu

	local btn_reset = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_reset:setPosition(-80, 85)
	btn_reset:setContentSize(134, 56)
	btn_reset:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_reset:setLabelOffset(cc.p(0, -2))
	btn_reset:setLabelSize(44)
	btn_reset:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_reset:setLabelText(ex.Tools:getLang(76816))
	self:addLoadRes(3, btn_reset, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_reset)
	self.btn_reset = btn_reset

	local btn_upgrade = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_upgrade:setPosition(80, 85)
	btn_upgrade:setContentSize(134, 56)
	btn_upgrade:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_upgrade:setLabelOffset(cc.p(0, -2))
	btn_upgrade:setLabelSize(44)
	btn_upgrade:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_upgrade:setLabelText(ex.Tools:getLang(74508))
	self:addLoadRes(3, btn_upgrade, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_upgrade)
	self.btn_upgrade = btn_upgrade

	 self:startLoadRes()
end
return HeroHexagramLayer