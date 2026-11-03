local AliceChangeLineupLayer = class("AliceChangeLineupLayer", require("src.comp.CCCLayerBase")) 

function AliceChangeLineupLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 1030)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(620, 1030)
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

	local spr_title = cc.Sprite:create()
	spr_title:setPosition(310, 996.5)
	spr_title:setContentSize(184, 67)
	self:addLoadRes(2, spr_title, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "win-bg/title-bar-3.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_title.lyt = lyt
	self:addChild(spr_title)
	self.spr_title = spr_title

	local lbl_titlt = cc.Label:createWithTTF(ex.Tools:getLang(47546),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_titlt:setPosition(92, 24.1)
	lbl_titlt:setContentSize(26.3, 27.72)
	lbl_titlt:setTextColor(cc.c3b(122, 71, 45))
	lbl_titlt:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_titlt:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_titlt)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(10.24)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_titlt.lyt = lyt
	spr_title:addChild(lbl_titlt)
	self.lbl_titlt = lbl_titlt

	local spr_box = cc.Scale9Sprite:create()
	spr_box:setPosition(310, 945)
	spr_box:setContentSize(560, 370)
	spr_box:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_box, "ccbi-res/hero-info.plist", "ccbi-res/hero-info.pvr.ccz", {frame = "hero-info/spr-hero-image-3.png", capInsets = cc.rect(20,80,20,50)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_box)
	lyt:setLeftMargin(30)
	lyt:setRightMargin(30)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(85)
	lyt:setBottomMargin(575)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_box.lyt = lyt
	self:addChild(spr_box)
	self.spr_box = spr_box

	local node_elem = cc.Node:create()
	node_elem:setPosition(280, 355)
	node_elem:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_elem)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(15)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_elem.lyt = lyt
	spr_box:addChild(node_elem)
	self.node_elem = node_elem

	local elem_menu = cpp.UIMenu:create()
	elem_menu:setPosition(0, 0)
	elem_menu:setContentSize(100, 1)
	elem_menu:setAnchorPoint(cc.p(0, 0))
	elem_menu:setIgnoreAnchorPointForPosition(false)
	node_elem:addChild(elem_menu)
	self.elem_menu = elem_menu

	local btn_elem0 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem0:setPosition(-210, -34)
	btn_elem0:setContentSize(74, 72)
	btn_elem0:setScale(0.8, 0.8)
	btn_elem0:setTag(0)
	btn_elem0:registerScriptTapHandler(handler(self, self.onElem))
	self:addLoadRes(3, btn_elem0, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-0.png", spr2="hero-icon/elem-0.png"})
	elem_menu:addChild(btn_elem0)
	self.btn_elem0 = btn_elem0

	local btn_elem1 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem1:setPosition(-126, -34)
	btn_elem1:setContentSize(74, 72)
	btn_elem1:setScale(0.8, 0.8)
	btn_elem1:setTag(1)
	btn_elem1:registerScriptTapHandler(handler(self, self.onElem))
	self:addLoadRes(3, btn_elem1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-1.png", spr2="hero-icon/elem-1.png"})
	elem_menu:addChild(btn_elem1)
	self.btn_elem1 = btn_elem1

	local btn_elem2 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem2:setPosition(-42, -34)
	btn_elem2:setContentSize(74, 72)
	btn_elem2:setScale(0.8, 0.8)
	btn_elem2:setAnchorPoint(cc.p(0.5, 0.5))
	btn_elem2:setTag(2)
	btn_elem2:registerScriptTapHandler(handler(self, self.onElem))
	self:addLoadRes(3, btn_elem2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-2.png", spr2="hero-icon/elem-2.png"})
	elem_menu:addChild(btn_elem2)
	self.btn_elem2 = btn_elem2

	local btn_elem3 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem3:setPosition(42, -34)
	btn_elem3:setContentSize(74, 72)
	btn_elem3:setScale(0.8, 0.8)
	btn_elem3:setTag(3)
	btn_elem3:registerScriptTapHandler(handler(self, self.onElem))
	self:addLoadRes(3, btn_elem3, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-3.png", spr2="hero-icon/elem-3.png"})
	elem_menu:addChild(btn_elem3)
	self.btn_elem3 = btn_elem3

	local btn_elem4 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem4:setPosition(126, -34)
	btn_elem4:setContentSize(74, 72)
	btn_elem4:setScale(0.8, 0.8)
	btn_elem4:setTag(4)
	btn_elem4:registerScriptTapHandler(handler(self, self.onElem))
	self:addLoadRes(3, btn_elem4, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-4.png", spr2="hero-icon/elem-4.png"})
	elem_menu:addChild(btn_elem4)
	self.btn_elem4 = btn_elem4

	local btn_elem5 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem5:setPosition(210, -34)
	btn_elem5:setContentSize(74, 72)
	btn_elem5:setScale(0.8, 0.8)
	btn_elem5:setTag(5)
	btn_elem5:registerScriptTapHandler(handler(self, self.onElem))
	self:addLoadRes(3, btn_elem5, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-5.png", spr2="hero-icon/elem-5.png"})
	elem_menu:addChild(btn_elem5)
	self.btn_elem5 = btn_elem5

	local lbl_tips_1 = cc.Label:createWithTTF(ex.Tools:getLang(5387),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_tips_1:setPosition(280, 265)
	lbl_tips_1:setContentSize(26.3, 27.72)
	lbl_tips_1:setTextColor(cc.c3b(122, 71, 45))
	lbl_tips_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tips_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_tips_1)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(91.14)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_tips_1.lyt = lyt
	spr_box:addChild(lbl_tips_1)
	self.lbl_tips_1 = lbl_tips_1

	local spr_bg_2 = cc.Scale9Sprite:create()
	spr_bg_2:setPosition(310, 524.58)
	spr_bg_2:setContentSize(560, 385)
	spr_bg_2:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_bg_2, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", {frame = "hero-select/k1.png", capInsets = cc.rect(10,10,10,10)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg_2)
	lyt:setLeftMargin(30)
	lyt:setRightMargin(30)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(505.42)
	lyt:setBottomMargin(139.58)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg_2.lyt = lyt
	self:addChild(spr_bg_2)
	self.spr_bg_2 = spr_bg_2

	local taem_menu = cpp.UIMenu:create()
	taem_menu:setPosition(-44.86, 376.68)
	taem_menu:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(taem_menu)
	lyt:setLeftMargin(-44.86)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(8.32)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	taem_menu.lyt = lyt
	spr_bg_2:addChild(taem_menu)
	self.taem_menu = taem_menu

	local btn_all_team = cpp.UIMenuItemTab:create("", nil, "英  雄", 1, 1)
	btn_all_team:setPosition(115, 0)
	btn_all_team:setContentSize(111, 43)
	btn_all_team:setAnchorPoint(cc.p(0.5, 0))
	btn_all_team:registerScriptTapHandler(handler(self, self.onHero))
	btn_all_team:getLabel():setTextColor(cc.c4b(122, 71, 45, 255))
	btn_all_team:setLabelOffset(cc.p(0, -4))
	btn_all_team:setLabelText(ex.Tools:getLang(580050))
	local l = btn_all_team:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 48
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_all_team, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-23.png", spr2="button/btn-tab-24.png"})
	taem_menu:addChild(btn_all_team)
	self.btn_all_team = btn_all_team

	local btn_team_1 = cpp.UIMenuItemTab:create("", nil, "图  鉴", 1, 1)
	btn_team_1:setPosition(230, 0)
	btn_team_1:setContentSize(111, 43)
	btn_team_1:setAnchorPoint(cc.p(0.5, 0))
	btn_team_1:registerScriptTapHandler(handler(self, self.onIllustrat))
	btn_team_1:getLabel():setTextColor(cc.c4b(122, 71, 45, 255))
	btn_team_1:setLabelOffset(cc.p(0, -4))
	btn_team_1:setLabelText(ex.Tools:getLang(580051))
	local l = btn_team_1:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 48
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_team_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-23.png", spr2="button/btn-tab-24.png"})
	taem_menu:addChild(btn_team_1)
	self.btn_team_1 = btn_team_1

	local btn_team_2 = cpp.UIMenuItemTab:create("", nil, "圣 龙", 1, 1)
	btn_team_2:setPosition(345, 0)
	btn_team_2:setContentSize(111, 43)
	btn_team_2:setAnchorPoint(cc.p(0.5, 0))
	btn_team_2:registerScriptTapHandler(handler(self, self.onDragon))
	btn_team_2:getLabel():setTextColor(cc.c4b(122, 71, 45, 255))
	btn_team_2:setLabelOffset(cc.p(0, -4))
	btn_team_2:setLabelText(ex.Tools:getLang(580052))
	local l = btn_team_2:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 48
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_team_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-23.png", spr2="button/btn-tab-24.png"})
	taem_menu:addChild(btn_team_2)
	self.btn_team_2 = btn_team_2

	local btn_team_3 = cpp.UIMenuItemTab:create("", nil, "圣 龙", 1, 1)
	btn_team_3:setPosition(460, 0)
	btn_team_3:setContentSize(111, 43)
	btn_team_3:setAnchorPoint(cc.p(0.5, 0))
	btn_team_3:registerScriptTapHandler(handler(self, self.onDragon))
	btn_team_3:getLabel():setTextColor(cc.c4b(122, 71, 45, 255))
	btn_team_3:setLabelOffset(cc.p(0, -4))
	btn_team_3:setLabelText(ex.Tools:getLang(580053))
	local l = btn_team_3:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 48
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_team_3, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-23.png", spr2="button/btn-tab-24.png"})
	taem_menu:addChild(btn_team_3)
	self.btn_team_3 = btn_team_3

	local bottom_menu = cpp.UIMenu:create()
	bottom_menu:setPosition(310, 80)
	bottom_menu:setContentSize(0, 0)
	bottom_menu:setAnchorPoint(cc.p(0.5, 0.5))
	bottom_menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(bottom_menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(80)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	bottom_menu.lyt = lyt
	self:addChild(bottom_menu)
	self.bottom_menu = bottom_menu

	local btn_keep = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_keep:setPosition(0, 0)
	btn_keep:setContentSize(197, 60)
	btn_keep:registerScriptTapHandler(handler(self, self.onConfirm))
	btn_keep:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_keep:setLabelOffset(cc.p(0, -2))
	btn_keep:setLabelSize(44)
	btn_keep:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_keep:setLabelText(ex.Tools:getLang(74224))
	self:addLoadRes(3, btn_keep, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-blue-7.png"})
	bottom_menu:addChild(btn_keep)
	self.btn_keep = btn_keep

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(235, 925)
	btn_close:setContentSize(55, 58)
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png"})
	bottom_menu:addChild(btn_close)
	self.btn_close = btn_close

	 self:startLoadRes()
end
return AliceChangeLineupLayer