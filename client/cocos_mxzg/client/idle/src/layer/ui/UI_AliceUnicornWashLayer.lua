local AliceUnicornWashLayer = class("AliceUnicornWashLayer", require("src.comp.CCCLayerBase")) 

function AliceUnicornWashLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 900)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(620, 900)
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

	local spr_bg_2 = cc.Scale9Sprite:create()
	spr_bg_2:setPosition(310, 825)
	spr_bg_2:setContentSize(540, 42)
	self:addLoadRes(1, spr_bg_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-8.png", capInsets = cc.rect(10,10,10,10)})
	self:addChild(spr_bg_2)
	self.spr_bg_2 = spr_bg_2

	local node_title = cc.Node:create()
	node_title:setPosition(310, 910)
	node_title:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-10)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_title.lyt = lyt
	self:addChild(node_title)
	self.node_title = node_title

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(0, 0)
	spr_title_bg:setContentSize(342, 46)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/title-bar-2.png", capInsets = cc.rect(0,0,0,0)})
	node_title:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580583),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -23)
	lbl_title:setContentSize(116, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setPosition(310, 900)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(-240, -75)
	btn_info:setContentSize(36, 36)
	btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-6.png"})
	menu:addChild(btn_info)
	self.btn_info = btn_info

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(250, 0)
	btn_close:setContentSize(55, 58)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local btn_elem_info = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_elem_info:setPosition(210, -75)
	btn_elem_info:setContentSize(96, 38)
	btn_elem_info:setScale(0.95, 0.95)
	btn_elem_info:registerScriptTapHandler(handler(self, self.onElemInfo))
	btn_elem_info:getLabel():setTextColor(cc.c4b(255, 227, 183, 255))
	btn_elem_info:setLabelOffset(cc.p(0, -2))
	btn_elem_info:setLabelSize(40)
	btn_elem_info:setLabelOutLine(cc.c4b(87,56,29,255), 4)
	btn_elem_info:setLabelText(ex.Tools:getLang(57160))
	self:addLoadRes(3, btn_elem_info, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/spr-red-bg.png"})
	menu:addChild(btn_elem_info)
	self.btn_elem_info = btn_elem_info

	local node_elem = cc.Node:create()
	node_elem:setPosition(310, 799.83)
	node_elem:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_elem)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	node_elem.lyt = lyt
	self:addChild(node_elem)
	self.node_elem = node_elem

	local spr_cell_bg = cc.Sprite:create()
	spr_cell_bg:setPosition(0, -147)
	spr_cell_bg:setContentSize(543, 294)
	self:addLoadRes(2, spr_cell_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-cell-bg-3.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_cell_bg)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_cell_bg.lyt = lyt
	node_elem:addChild(spr_cell_bg)
	self.spr_cell_bg = spr_cell_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580557),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(-260, -22)
	lbl_title:setContentSize(92, 31.72)
	lbl_title:setAnchorPoint(cc.p(0, 0.5))
	lbl_title:setTextColor(cc.c3b(253, 231, 148))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(68,32,11,255), 2)
	node_elem:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	node_elem:addChild(menu)
	self.menu = menu

	local btn_lock_1 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_lock_1:setPosition(240, -80)
	btn_lock_1:setContentSize(36, 36)
	btn_lock_1:setTag(1)
	btn_lock_1:registerScriptTapHandler(handler(self, self.onLock))
	self:addLoadRes(3, btn_lock_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-6.png"})
	menu:addChild(btn_lock_1)
	self.btn_lock_1 = btn_lock_1

	local btn_lock_2 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_lock_2:setPosition(240, -125)
	btn_lock_2:setContentSize(36, 36)
	btn_lock_2:setTag(2)
	btn_lock_2:registerScriptTapHandler(handler(self, self.onLock))
	self:addLoadRes(3, btn_lock_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-6.png"})
	menu:addChild(btn_lock_2)
	self.btn_lock_2 = btn_lock_2

	local btn_lock_3 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_lock_3:setPosition(240, -170)
	btn_lock_3:setContentSize(36, 36)
	btn_lock_3:setTag(3)
	btn_lock_3:registerScriptTapHandler(handler(self, self.onLock))
	self:addLoadRes(3, btn_lock_3, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-6.png"})
	menu:addChild(btn_lock_3)
	self.btn_lock_3 = btn_lock_3

	local btn_lock_4 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_lock_4:setPosition(240, -215)
	btn_lock_4:setContentSize(36, 36)
	btn_lock_4:setTag(4)
	btn_lock_4:registerScriptTapHandler(handler(self, self.onLock))
	self:addLoadRes(3, btn_lock_4, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-6.png"})
	menu:addChild(btn_lock_4)
	self.btn_lock_4 = btn_lock_4

	local btn_lock_5 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_lock_5:setPosition(240, -260)
	btn_lock_5:setContentSize(36, 36)
	btn_lock_5:setTag(5)
	btn_lock_5:registerScriptTapHandler(handler(self, self.onLock))
	self:addLoadRes(3, btn_lock_5, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-6.png"})
	menu:addChild(btn_lock_5)
	self.btn_lock_5 = btn_lock_5

	local node_attr_before_1 = cc.Node:create()
	node_attr_before_1:setPosition(-250, -80)
	node_attr_before_1:setContentSize(0, 0)
	node_elem:addChild(node_attr_before_1)
	self.node_attr_before_1 = node_attr_before_1

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_before_1:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_before = cc.Label:createWithTTF(ex.Tools:getLang(580559),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_before:setPosition(40, 0)
	lbl_title_before:setContentSize(109.7, 29.2)
	lbl_title_before:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_before:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_before:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_before:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_before:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_before_1:addChild(lbl_title_before)
	self.lbl_title_before = lbl_title_before

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_before_1:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_before_1 = cc.Sprite:create()
	spr_attr_before_1:setPosition(180, 0)
	spr_attr_before_1:setContentSize(66, 66)
	spr_attr_before_1:setScale(0.75, 0.75)
	spr_attr_before_1:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_before_1, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_before_1:addChild(spr_attr_before_1)
	self.spr_attr_before_1 = spr_attr_before_1

	local lbl_attr_before_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_before_1:setPosition(240, 0)
	lbl_attr_before_1:setContentSize(84, 29.2)
	lbl_attr_before_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_before_1:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_before_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_before_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_before_1:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_1:addChild(lbl_attr_before_1)
	self.lbl_attr_before_1 = lbl_attr_before_1

	local lbl_attr_extra_before_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_before_1:setPosition(350, 0)
	lbl_attr_extra_before_1:setContentSize(84, 29.2)
	lbl_attr_extra_before_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_before_1:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_before_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_before_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_before_1:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_1:addChild(lbl_attr_extra_before_1)
	self.lbl_attr_extra_before_1 = lbl_attr_extra_before_1

	local node_attr_before_2 = cc.Node:create()
	node_attr_before_2:setPosition(-250, -125)
	node_attr_before_2:setContentSize(0, 0)
	node_elem:addChild(node_attr_before_2)
	self.node_attr_before_2 = node_attr_before_2

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_before_2:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_before = cc.Label:createWithTTF(ex.Tools:getLang(580560),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_before:setPosition(40, 0)
	lbl_title_before:setContentSize(109.7, 29.2)
	lbl_title_before:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_before:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_before:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_before:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_before:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_before_2:addChild(lbl_title_before)
	self.lbl_title_before = lbl_title_before

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_before_2:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_before_2 = cc.Sprite:create()
	spr_attr_before_2:setPosition(180, 0)
	spr_attr_before_2:setContentSize(66, 66)
	spr_attr_before_2:setScale(0.75, 0.75)
	spr_attr_before_2:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_before_2, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_before_2:addChild(spr_attr_before_2)
	self.spr_attr_before_2 = spr_attr_before_2

	local lbl_attr_before_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_before_2:setPosition(240, 0)
	lbl_attr_before_2:setContentSize(84, 29.2)
	lbl_attr_before_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_before_2:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_before_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_before_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_before_2:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_2:addChild(lbl_attr_before_2)
	self.lbl_attr_before_2 = lbl_attr_before_2

	local lbl_attr_extra_before_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_before_2:setPosition(350, 0)
	lbl_attr_extra_before_2:setContentSize(84, 29.2)
	lbl_attr_extra_before_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_before_2:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_before_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_before_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_before_2:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_2:addChild(lbl_attr_extra_before_2)
	self.lbl_attr_extra_before_2 = lbl_attr_extra_before_2

	local node_attr_before_3 = cc.Node:create()
	node_attr_before_3:setPosition(-250, -170)
	node_attr_before_3:setContentSize(0, 0)
	node_elem:addChild(node_attr_before_3)
	self.node_attr_before_3 = node_attr_before_3

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_before_3:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_before = cc.Label:createWithTTF(ex.Tools:getLang(580561),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_before:setPosition(40, 0)
	lbl_title_before:setContentSize(109.7, 29.2)
	lbl_title_before:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_before:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_before:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_before:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_before:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_before_3:addChild(lbl_title_before)
	self.lbl_title_before = lbl_title_before

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_before_3:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_before_3 = cc.Sprite:create()
	spr_attr_before_3:setPosition(180, 0)
	spr_attr_before_3:setContentSize(66, 66)
	spr_attr_before_3:setScale(0.75, 0.75)
	spr_attr_before_3:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_before_3, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_before_3:addChild(spr_attr_before_3)
	self.spr_attr_before_3 = spr_attr_before_3

	local lbl_attr_before_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_before_3:setPosition(240, 0)
	lbl_attr_before_3:setContentSize(84, 29.2)
	lbl_attr_before_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_before_3:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_before_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_before_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_before_3:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_3:addChild(lbl_attr_before_3)
	self.lbl_attr_before_3 = lbl_attr_before_3

	local lbl_attr_extra_before_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_before_3:setPosition(350, 0)
	lbl_attr_extra_before_3:setContentSize(84, 29.2)
	lbl_attr_extra_before_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_before_3:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_before_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_before_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_before_3:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_3:addChild(lbl_attr_extra_before_3)
	self.lbl_attr_extra_before_3 = lbl_attr_extra_before_3

	local node_attr_before_4 = cc.Node:create()
	node_attr_before_4:setPosition(-250, -215)
	node_attr_before_4:setContentSize(0, 0)
	node_elem:addChild(node_attr_before_4)
	self.node_attr_before_4 = node_attr_before_4

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_before_4:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_before = cc.Label:createWithTTF(ex.Tools:getLang(580562),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_before:setPosition(40, 0)
	lbl_title_before:setContentSize(109.7, 29.2)
	lbl_title_before:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_before:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_before:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_before:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_before:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_before_4:addChild(lbl_title_before)
	self.lbl_title_before = lbl_title_before

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_before_4:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_before_4 = cc.Sprite:create()
	spr_attr_before_4:setPosition(180, 0)
	spr_attr_before_4:setContentSize(66, 66)
	spr_attr_before_4:setScale(0.75, 0.75)
	spr_attr_before_4:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_before_4, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_before_4:addChild(spr_attr_before_4)
	self.spr_attr_before_4 = spr_attr_before_4

	local lbl_attr_before_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_before_4:setPosition(240, 0)
	lbl_attr_before_4:setContentSize(84, 29.2)
	lbl_attr_before_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_before_4:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_before_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_before_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_before_4:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_4:addChild(lbl_attr_before_4)
	self.lbl_attr_before_4 = lbl_attr_before_4

	local lbl_attr_extra_before_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_before_4:setPosition(350, 0)
	lbl_attr_extra_before_4:setContentSize(84, 29.2)
	lbl_attr_extra_before_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_before_4:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_before_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_before_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_before_4:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_4:addChild(lbl_attr_extra_before_4)
	self.lbl_attr_extra_before_4 = lbl_attr_extra_before_4

	local node_attr_before_5 = cc.Node:create()
	node_attr_before_5:setPosition(-250, -260)
	node_attr_before_5:setContentSize(0, 0)
	node_elem:addChild(node_attr_before_5)
	self.node_attr_before_5 = node_attr_before_5

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_before_5:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_before = cc.Label:createWithTTF(ex.Tools:getLang(580563),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_before:setPosition(40, 0)
	lbl_title_before:setContentSize(109.7, 29.2)
	lbl_title_before:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_before:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_before:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_before:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_before:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_before_5:addChild(lbl_title_before)
	self.lbl_title_before = lbl_title_before

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_before_5:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_before_5 = cc.Sprite:create()
	spr_attr_before_5:setPosition(180, 0)
	spr_attr_before_5:setContentSize(66, 66)
	spr_attr_before_5:setScale(0.75, 0.75)
	spr_attr_before_5:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_before_5, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_before_5:addChild(spr_attr_before_5)
	self.spr_attr_before_5 = spr_attr_before_5

	local lbl_attr_before_5 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_before_5:setPosition(240, 0)
	lbl_attr_before_5:setContentSize(84, 29.2)
	lbl_attr_before_5:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_before_5:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_before_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_before_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_before_5:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_5:addChild(lbl_attr_before_5)
	self.lbl_attr_before_5 = lbl_attr_before_5

	local lbl_attr_extra_before_5 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_before_5:setPosition(350, 0)
	lbl_attr_extra_before_5:setContentSize(84, 29.2)
	lbl_attr_extra_before_5:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_before_5:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_before_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_before_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_before_5:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_before_5:addChild(lbl_attr_extra_before_5)
	self.lbl_attr_extra_before_5 = lbl_attr_extra_before_5

	local spr_arrow = cc.Scale9Sprite:create()
	spr_arrow:setPosition(310, 500)
	spr_arrow:setContentSize(35, 24)
	spr_arrow:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_arrow, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "other/arrow-3.png", capInsets = cc.rect(0,0,0,0)})
	self:addChild(spr_arrow)
	self.spr_arrow = spr_arrow

	local node_elem = cc.Node:create()
	node_elem:setPosition(310, 463.81)
	node_elem:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_elem)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	node_elem.lyt = lyt
	self:addChild(node_elem)
	self.node_elem = node_elem

	local spr_cell_bg = cc.Sprite:create()
	spr_cell_bg:setPosition(0, -147)
	spr_cell_bg:setContentSize(543, 294)
	self:addLoadRes(2, spr_cell_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-cell-bg-3.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_cell_bg)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_cell_bg.lyt = lyt
	node_elem:addChild(spr_cell_bg)
	self.spr_cell_bg = spr_cell_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580558),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title:setPosition(-260, -22)
	lbl_title:setContentSize(84, 29.2)
	lbl_title:setAnchorPoint(cc.p(0, 0.5))
	lbl_title:setTextColor(cc.c3b(241, 211, 139))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_elem:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	node_elem:addChild(menu)
	self.menu = menu

	local node_attr_after_1 = cc.Node:create()
	node_attr_after_1:setPosition(-250, -80)
	node_attr_after_1:setContentSize(0, 0)
	node_elem:addChild(node_attr_after_1)
	self.node_attr_after_1 = node_attr_after_1

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_after_1:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_after = cc.Label:createWithTTF(ex.Tools:getLang(580559),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_after:setPosition(40, 0)
	lbl_title_after:setContentSize(109.7, 29.2)
	lbl_title_after:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_after:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_after:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_after:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_after:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_after_1:addChild(lbl_title_after)
	self.lbl_title_after = lbl_title_after

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_after_1:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_after_1 = cc.Sprite:create()
	spr_attr_after_1:setPosition(180, 0)
	spr_attr_after_1:setContentSize(66, 66)
	spr_attr_after_1:setScale(0.75, 0.75)
	spr_attr_after_1:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_after_1, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_after_1:addChild(spr_attr_after_1)
	self.spr_attr_after_1 = spr_attr_after_1

	local lbl_attr_after_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_after_1:setPosition(240, 0)
	lbl_attr_after_1:setContentSize(84, 29.2)
	lbl_attr_after_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_after_1:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_after_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_after_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_after_1:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_1:addChild(lbl_attr_after_1)
	self.lbl_attr_after_1 = lbl_attr_after_1

	local lbl_attr_extra_after_1 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_after_1:setPosition(350, 0)
	lbl_attr_extra_after_1:setContentSize(84, 29.2)
	lbl_attr_extra_after_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_after_1:setVisible(false)
	lbl_attr_extra_after_1:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_after_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_after_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_after_1:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_1:addChild(lbl_attr_extra_after_1)
	self.lbl_attr_extra_after_1 = lbl_attr_extra_after_1

	local node_attr_after_2 = cc.Node:create()
	node_attr_after_2:setPosition(-250, -125)
	node_attr_after_2:setContentSize(0, 0)
	node_elem:addChild(node_attr_after_2)
	self.node_attr_after_2 = node_attr_after_2

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_after_2:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_after = cc.Label:createWithTTF(ex.Tools:getLang(580560),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_after:setPosition(40, 0)
	lbl_title_after:setContentSize(109.7, 29.2)
	lbl_title_after:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_after:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_after:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_after:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_after:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_after_2:addChild(lbl_title_after)
	self.lbl_title_after = lbl_title_after

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_after_2:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_after_2 = cc.Sprite:create()
	spr_attr_after_2:setPosition(180, 0)
	spr_attr_after_2:setContentSize(66, 66)
	spr_attr_after_2:setScale(0.75, 0.75)
	spr_attr_after_2:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_after_2, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_after_2:addChild(spr_attr_after_2)
	self.spr_attr_after_2 = spr_attr_after_2

	local lbl_attr_after_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_after_2:setPosition(240, 0)
	lbl_attr_after_2:setContentSize(84, 29.2)
	lbl_attr_after_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_after_2:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_after_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_after_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_after_2:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_2:addChild(lbl_attr_after_2)
	self.lbl_attr_after_2 = lbl_attr_after_2

	local lbl_attr_extra_after_2 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_after_2:setPosition(350, 0)
	lbl_attr_extra_after_2:setContentSize(84, 29.2)
	lbl_attr_extra_after_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_after_2:setVisible(false)
	lbl_attr_extra_after_2:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_after_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_after_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_after_2:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_2:addChild(lbl_attr_extra_after_2)
	self.lbl_attr_extra_after_2 = lbl_attr_extra_after_2

	local node_attr_after_3 = cc.Node:create()
	node_attr_after_3:setPosition(-250, -170)
	node_attr_after_3:setContentSize(0, 0)
	node_elem:addChild(node_attr_after_3)
	self.node_attr_after_3 = node_attr_after_3

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_after_3:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_after = cc.Label:createWithTTF(ex.Tools:getLang(580561),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_after:setPosition(40, 0)
	lbl_title_after:setContentSize(109.7, 29.2)
	lbl_title_after:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_after:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_after:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_after:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_after:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_after_3:addChild(lbl_title_after)
	self.lbl_title_after = lbl_title_after

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_after_3:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_after_3 = cc.Sprite:create()
	spr_attr_after_3:setPosition(180, 0)
	spr_attr_after_3:setContentSize(66, 66)
	spr_attr_after_3:setScale(0.75, 0.75)
	spr_attr_after_3:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_after_3, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_after_3:addChild(spr_attr_after_3)
	self.spr_attr_after_3 = spr_attr_after_3

	local lbl_attr_after_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_after_3:setPosition(240, 0)
	lbl_attr_after_3:setContentSize(84, 29.2)
	lbl_attr_after_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_after_3:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_after_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_after_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_after_3:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_3:addChild(lbl_attr_after_3)
	self.lbl_attr_after_3 = lbl_attr_after_3

	local lbl_attr_extra_after_3 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_after_3:setPosition(350, 0)
	lbl_attr_extra_after_3:setContentSize(84, 29.2)
	lbl_attr_extra_after_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_after_3:setVisible(false)
	lbl_attr_extra_after_3:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_after_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_after_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_after_3:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_3:addChild(lbl_attr_extra_after_3)
	self.lbl_attr_extra_after_3 = lbl_attr_extra_after_3

	local node_attr_after_4 = cc.Node:create()
	node_attr_after_4:setPosition(-250, -215)
	node_attr_after_4:setContentSize(0, 0)
	node_elem:addChild(node_attr_after_4)
	self.node_attr_after_4 = node_attr_after_4

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_after_4:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_after = cc.Label:createWithTTF(ex.Tools:getLang(580562),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_after:setPosition(40, 0)
	lbl_title_after:setContentSize(109.7, 29.2)
	lbl_title_after:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_after:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_after:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_after:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_after:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_after_4:addChild(lbl_title_after)
	self.lbl_title_after = lbl_title_after

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_after_4:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_after_4 = cc.Sprite:create()
	spr_attr_after_4:setPosition(180, 0)
	spr_attr_after_4:setContentSize(66, 66)
	spr_attr_after_4:setScale(0.75, 0.75)
	spr_attr_after_4:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_after_4, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_after_4:addChild(spr_attr_after_4)
	self.spr_attr_after_4 = spr_attr_after_4

	local lbl_attr_after_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_after_4:setPosition(240, 0)
	lbl_attr_after_4:setContentSize(84, 29.2)
	lbl_attr_after_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_after_4:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_after_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_after_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_after_4:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_4:addChild(lbl_attr_after_4)
	self.lbl_attr_after_4 = lbl_attr_after_4

	local lbl_attr_extra_after_4 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_after_4:setPosition(350, 0)
	lbl_attr_extra_after_4:setContentSize(84, 29.2)
	lbl_attr_extra_after_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_after_4:setVisible(false)
	lbl_attr_extra_after_4:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_after_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_after_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_after_4:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_4:addChild(lbl_attr_extra_after_4)
	self.lbl_attr_extra_after_4 = lbl_attr_extra_after_4

	local node_attr_after_5 = cc.Node:create()
	node_attr_after_5:setPosition(-250, -260)
	node_attr_after_5:setContentSize(0, 0)
	node_elem:addChild(node_attr_after_5)
	self.node_attr_after_5 = node_attr_after_5

	local spr_reddot = cc.Sprite:create()
	spr_reddot:setPosition(0, 0)
	spr_reddot:setContentSize(21, 21)
	spr_reddot:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_reddot, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-reddot.png")
	node_attr_after_5:addChild(spr_reddot)
	self.spr_reddot = spr_reddot

	local lbl_title_after = cc.Label:createWithTTF(ex.Tools:getLang(580563),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_title_after:setPosition(40, 0)
	lbl_title_after:setContentSize(109.7, 29.2)
	lbl_title_after:setAnchorPoint(cc.p(0, 0.5))
	lbl_title_after:setTextColor(cc.c3b(255, 231, 148))
	lbl_title_after:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_after:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_after:enableOutline(cc.c4b(68,32,11,255), 2)
	node_attr_after_5:addChild(lbl_title_after)
	self.lbl_title_after = lbl_title_after

	local spr_attribute_bg = cc.Sprite:create()
	spr_attribute_bg:setPosition(200, 0)
	spr_attribute_bg:setContentSize(80, 38)
	spr_attribute_bg:setScale(2.5, 1)
	spr_attribute_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attribute_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_after_5:addChild(spr_attribute_bg)
	self.spr_attribute_bg = spr_attribute_bg

	local spr_attr_after_5 = cc.Sprite:create()
	spr_attr_after_5:setPosition(180, 0)
	spr_attr_after_5:setContentSize(66, 66)
	spr_attr_after_5:setScale(0.75, 0.75)
	spr_attr_after_5:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, spr_attr_after_5, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attribute-100.png")
	node_attr_after_5:addChild(spr_attr_after_5)
	self.spr_attr_after_5 = spr_attr_after_5

	local lbl_attr_after_5 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_after_5:setPosition(240, 0)
	lbl_attr_after_5:setContentSize(84, 29.2)
	lbl_attr_after_5:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_after_5:setTextColor(cc.c3b(253, 254, 192))
	lbl_attr_after_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_after_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_after_5:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_5:addChild(lbl_attr_after_5)
	self.lbl_attr_after_5 = lbl_attr_after_5

	local lbl_attr_extra_after_5 = cc.Label:createWithTTF("阵法名称",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_extra_after_5:setPosition(350, 0)
	lbl_attr_extra_after_5:setContentSize(84, 29.2)
	lbl_attr_extra_after_5:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_extra_after_5:setVisible(false)
	lbl_attr_extra_after_5:setTextColor(cc.c3b(239, 209, 131))
	lbl_attr_extra_after_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_extra_after_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_extra_after_5:enableOutline(cc.c4b(34,23,20,255), 2)
	node_attr_after_5:addChild(lbl_attr_extra_after_5)
	self.lbl_attr_extra_after_5 = lbl_attr_extra_after_5

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

	local node_res_need = cc.Node:create()
	node_res_need:setPosition(0, 135)
	node_res_need:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_res_need)
	lyt:setLeftMargin(0)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(135)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_res_need.lyt = lyt
	node_upgrade:addChild(node_res_need)
	self.node_res_need = node_res_need

	local spr_res_need_bg = cc.Sprite:create()
	spr_res_need_bg:setPosition(0, 0)
	spr_res_need_bg:setContentSize(211, 43)
	self:addLoadRes(2, spr_res_need_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-res-bg.png")
	node_res_need:addChild(spr_res_need_bg)
	self.spr_res_need_bg = spr_res_need_bg

	local lbl_res_need = cc.Label:createWithTTF("99999/9999",FONT_DEFAULT_NAME_BOLD, 48)
	lbl_res_need:setPosition(20, -2)
	lbl_res_need:setContentSize(263.69, 64.48)
	lbl_res_need:setScale(0.5, 0.5)
	lbl_res_need:setTextColor(cc.c3b(255, 255, 255))
	lbl_res_need:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_res_need:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_res_need:enableOutline(cc.c4b(100,100,100,255), 2)
	node_res_need:addChild(lbl_res_need)
	self.lbl_res_need = lbl_res_need

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(0, 0)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	node_res_need:addChild(UIMenu)

	local btn_res_need = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_res_need:setPosition(-75, 0)
	btn_res_need:setContentSize(62, 84)
	btn_res_need:setScale(0.5, 0.5)
	btn_res_need:registerScriptTapHandler(handler(self, self.onItemInfo))
	self:addLoadRes(3, btn_res_need, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", {spr1="backpack/900002.png"})
	UIMenu:addChild(btn_res_need)
	self.btn_res_need = btn_res_need

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

	local btn_wash = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_wash:setPosition(-120, 70)
	btn_wash:setContentSize(197, 60)
	btn_wash:registerScriptTapHandler(handler(self, self.onWash))
	btn_wash:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_wash:setLabelOffset(cc.p(0, -2))
	btn_wash:setLabelSize(44)
	btn_wash:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_wash:setLabelText(ex.Tools:getLang(47618))
	self:addLoadRes(3, btn_wash, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-buy-6.png"})
	menu:addChild(btn_wash)
	self.btn_wash = btn_wash

	local btn_save = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_save:setPosition(120, 70)
	btn_save:setContentSize(197, 60)
	btn_save:registerScriptTapHandler(handler(self, self.onSave))
	btn_save:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_save:setLabelOffset(cc.p(0, -2))
	btn_save:setLabelSize(44)
	btn_save:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_save:setLabelText(ex.Tools:getLang(47396))
	self:addLoadRes(3, btn_save, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-blue-7.png"})
	menu:addChild(btn_save)
	self.btn_save = btn_save

	 self:startLoadRes()
end
return AliceUnicornWashLayer