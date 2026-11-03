local AliceChangeLineupCell = class("AliceChangeLineupCell", require("src.comp.CCCLayerBase")) 

function AliceChangeLineupCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 1030)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
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

	local btn_contract = cc.Sprite:create()
	btn_contract:setPosition(136.52, 474.39)
	btn_contract:setContentSize(176, 71)
	self:addLoadRes(2, btn_contract, "ccbi-res/hero-select-lang.plist", "ccbi-res/hero-select-lang.pvr.ccz", "hero-select-lang/zxtj.png")
	self:addChild(btn_contract)
	self.btn_contract = btn_contract

	local New Node = cc.Node:create()
	New Node:setPosition(0, 0)
	New Node:setContentSize(0, 0)
	self:addChild(New Node)

	local spr_battle_count_bg = cc.Sprite:create()
	spr_battle_count_bg:setPosition(404.06, 474.39)
	spr_battle_count_bg:setContentSize(380, 86)
	self:addLoadRes(2, spr_battle_count_bg, "ccbi-res/hero-info.plist", "ccbi-res/hero-info.pvr.ccz", "hero-info/zhanbei.png")
	New Node:addChild(spr_battle_count_bg)
	self.spr_battle_count_bg = spr_battle_count_bg

	local New Sprite = cc.Sprite:create()
	New Sprite:setPosition(297.87, 489.56)
	New Sprite:setContentSize(78, 44)
	self:addLoadRes(2, New Sprite, "ccbi-res/hero-select-lang.plist", "ccbi-res/hero-select-lang.pvr.ccz", "hero-select-lang/zhanli.png")
	New Node:addChild(New Sprite)
	self.New Sprite = New Sprite

	local lbl_battle_count = cc.Label:createWithBMFont("font/red-26.fnt", "2499y")
	lbl_battle_count:setPosition(419.25, 476.85)
	lbl_battle_count:setContentSize(87.73, 40)
	lbl_battle_count:setTextColor(cc.c3b(255, 255, 255))
	New Node:addChild(lbl_battle_count)
	self.lbl_battle_count = lbl_battle_count

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(550, 465)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(UIMenu)
	lyt:setRightMargin(70)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(565)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	UIMenu.lyt = lyt
	self:addChild(UIMenu)

	local btn_halo = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_halo:setPosition(0, 0)
	btn_halo:setContentSize(74, 72)
	self:addLoadRes(3, btn_halo, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-10000.png"})
	UIMenu:addChild(btn_halo)
	self.btn_halo = btn_halo

	local btn_matrix = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_matrix:setPosition(0, -110)
	btn_matrix:setContentSize(72, 72)
	self:addLoadRes(3, btn_matrix, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", {spr1="hero-select/spr-matrix-2-1.png"})
	UIMenu:addChild(btn_matrix)
	self.btn_matrix = btn_matrix

	local spr_front_row = cc.Sprite:create()
	spr_front_row:setPosition(75, 355)
	spr_front_row:setContentSize(34, 74)
	self:addLoadRes(2, spr_front_row, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-bg-1.png")
	self:addChild(spr_front_row)
	self.spr_front_row = spr_front_row

	local UILabelTTF = cc.Label:createWithTTF(ex.Tools:getLang(74705),FONT_DEFAULT_NAME_BOLD, 22)
	UILabelTTF:setPosition(17, 37)
	UILabelTTF:setContentSize(26.3, 27.72)
	UILabelTTF:setTextColor(cc.c3b(141, 89, 58))
	UILabelTTF:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	UILabelTTF:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_front_row:addChild(UILabelTTF)

	local spr_back_row = cc.Sprite:create()
	spr_back_row:setPosition(75, 225)
	spr_back_row:setContentSize(34, 74)
	self:addLoadRes(2, spr_back_row, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-bg-1.png")
	self:addChild(spr_back_row)
	self.spr_back_row = spr_back_row

	local UILabelTTF = cc.Label:createWithTTF(ex.Tools:getLang(74705),FONT_DEFAULT_NAME_BOLD, 22)
	UILabelTTF:setPosition(17, 37)
	UILabelTTF:setContentSize(26.3, 27.72)
	UILabelTTF:setTextColor(cc.c3b(141, 89, 58))
	UILabelTTF:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	UILabelTTF:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_back_row:addChild(UILabelTTF)

	local node_icon_4 = cc.Node:create()
	node_icon_4:setPosition(150, 355)
	node_icon_4:setContentSize(0, 0)
	self:addChild(node_icon_4)
	self.node_icon_4 = node_icon_4

	local spr_4_1 = cc.Sprite:create()
	spr_4_1:setPosition(0, 0)
	spr_4_1:setContentSize(76, 76)
	self:addLoadRes(2, spr_4_1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-bg-2.png")
	node_icon_4:addChild(spr_4_1)
	self.spr_4_1 = spr_4_1

	local spr_4_2 = cc.Sprite:create()
	spr_4_2:setPosition(0, 0)
	spr_4_2:setContentSize(74, 74)
	self:addLoadRes(2, spr_4_2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-frame-1.png")
	node_icon_4:addChild(spr_4_2)
	self.spr_4_2 = spr_4_2

	local spr_lock_4 = cc.Sprite:create()
	spr_lock_4:setPosition(0, 0)
	spr_lock_4:setContentSize(76, 76)
	self:addLoadRes(2, spr_lock_4, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-lock.png")
	node_icon_4:addChild(spr_lock_4)
	self.spr_lock_4 = spr_lock_4

	local lbl_attr_add_4 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_add_4:setPosition(0, -50)
	lbl_attr_add_4:setContentSize(26.3, 27.72)
	lbl_attr_add_4:setTextColor(cc.c3b(159, 108, 74))
	lbl_attr_add_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_add_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_attr_add_4)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-63.86)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_attr_add_4.lyt = lyt
	node_icon_4:addChild(lbl_attr_add_4)
	self.lbl_attr_add_4 = lbl_attr_add_4

	local node_icon_3 = cc.Node:create()
	node_icon_3:setPosition(250, 355)
	node_icon_3:setContentSize(0, 0)
	self:addChild(node_icon_3)
	self.node_icon_3 = node_icon_3

	local spr_3_1 = cc.Sprite:create()
	spr_3_1:setPosition(0, 0)
	spr_3_1:setContentSize(76, 76)
	self:addLoadRes(2, spr_3_1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-bg-2.png")
	node_icon_3:addChild(spr_3_1)
	self.spr_3_1 = spr_3_1

	local spr_3_2 = cc.Sprite:create()
	spr_3_2:setPosition(0, 0)
	spr_3_2:setContentSize(74, 74)
	self:addLoadRes(2, spr_3_2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-frame-1.png")
	node_icon_3:addChild(spr_3_2)
	self.spr_3_2 = spr_3_2

	local spr_lock_3 = cc.Sprite:create()
	spr_lock_3:setPosition(0, 0)
	spr_lock_3:setContentSize(76, 76)
	self:addLoadRes(2, spr_lock_3, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-lock.png")
	node_icon_3:addChild(spr_lock_3)
	self.spr_lock_3 = spr_lock_3

	local lbl_attr_add_3 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_add_3:setPosition(0, -50)
	lbl_attr_add_3:setContentSize(26.3, 27.72)
	lbl_attr_add_3:setTextColor(cc.c3b(159, 108, 74))
	lbl_attr_add_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_add_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_attr_add_3)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-63.86)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_attr_add_3.lyt = lyt
	node_icon_3:addChild(lbl_attr_add_3)
	self.lbl_attr_add_3 = lbl_attr_add_3

	local node_icon_2 = cc.Node:create()
	node_icon_2:setPosition(350, 355)
	node_icon_2:setContentSize(0, 0)
	self:addChild(node_icon_2)
	self.node_icon_2 = node_icon_2

	local spr_2_1 = cc.Sprite:create()
	spr_2_1:setPosition(0, 0)
	spr_2_1:setContentSize(76, 76)
	self:addLoadRes(2, spr_2_1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-bg-2.png")
	node_icon_2:addChild(spr_2_1)
	self.spr_2_1 = spr_2_1

	local spr_2_2 = cc.Sprite:create()
	spr_2_2:setPosition(0, 0)
	spr_2_2:setContentSize(74, 74)
	self:addLoadRes(2, spr_2_2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-frame-1.png")
	node_icon_2:addChild(spr_2_2)
	self.spr_2_2 = spr_2_2

	local spr_lock_2 = cc.Sprite:create()
	spr_lock_2:setPosition(0, 0)
	spr_lock_2:setContentSize(76, 76)
	self:addLoadRes(2, spr_lock_2, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-lock.png")
	node_icon_2:addChild(spr_lock_2)
	self.spr_lock_2 = spr_lock_2

	local lbl_attr_add_2 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_add_2:setPosition(0, -50)
	lbl_attr_add_2:setContentSize(26.3, 27.72)
	lbl_attr_add_2:setTextColor(cc.c3b(159, 108, 74))
	lbl_attr_add_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_add_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_attr_add_2)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-63.86)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_attr_add_2.lyt = lyt
	node_icon_2:addChild(lbl_attr_add_2)
	self.lbl_attr_add_2 = lbl_attr_add_2

	local node_icon_1 = cc.Node:create()
	node_icon_1:setPosition(450, 355)
	node_icon_1:setContentSize(0, 0)
	self:addChild(node_icon_1)
	self.node_icon_1 = node_icon_1

	local spr_1_1 = cc.Sprite:create()
	spr_1_1:setPosition(0, 0)
	spr_1_1:setContentSize(76, 76)
	self:addLoadRes(2, spr_1_1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-bg-2.png")
	node_icon_1:addChild(spr_1_1)
	self.spr_1_1 = spr_1_1

	local spr_1_2 = cc.Sprite:create()
	spr_1_2:setPosition(0, 0)
	spr_1_2:setContentSize(74, 74)
	self:addLoadRes(2, spr_1_2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-frame-1.png")
	node_icon_1:addChild(spr_1_2)
	self.spr_1_2 = spr_1_2

	local spr_lock_1 = cc.Sprite:create()
	spr_lock_1:setPosition(0, 0)
	spr_lock_1:setContentSize(76, 76)
	self:addLoadRes(2, spr_lock_1, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-lock.png")
	node_icon_1:addChild(spr_lock_1)
	self.spr_lock_1 = spr_lock_1

	local lbl_attr_add_1 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_add_1:setPosition(0, -50)
	lbl_attr_add_1:setContentSize(26.3, 27.72)
	lbl_attr_add_1:setTextColor(cc.c3b(159, 108, 74))
	lbl_attr_add_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_add_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_attr_add_1)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-63.86)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_attr_add_1.lyt = lyt
	node_icon_1:addChild(lbl_attr_add_1)
	self.lbl_attr_add_1 = lbl_attr_add_1

	local node_icon_8 = cc.Node:create()
	node_icon_8:setPosition(150, 225)
	node_icon_8:setContentSize(0, 0)
	self:addChild(node_icon_8)
	self.node_icon_8 = node_icon_8

	local spr_8_1 = cc.Sprite:create()
	spr_8_1:setPosition(0, 0)
	spr_8_1:setContentSize(76, 76)
	self:addLoadRes(2, spr_8_1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-bg-2.png")
	node_icon_8:addChild(spr_8_1)
	self.spr_8_1 = spr_8_1

	local spr_8_2 = cc.Sprite:create()
	spr_8_2:setPosition(0, 0)
	spr_8_2:setContentSize(74, 74)
	self:addLoadRes(2, spr_8_2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-frame-1.png")
	node_icon_8:addChild(spr_8_2)
	self.spr_8_2 = spr_8_2

	local spr_lock_8 = cc.Sprite:create()
	spr_lock_8:setPosition(0, 0)
	spr_lock_8:setContentSize(76, 76)
	self:addLoadRes(2, spr_lock_8, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-lock.png")
	node_icon_8:addChild(spr_lock_8)
	self.spr_lock_8 = spr_lock_8

	local lbl_attr_add_8 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_add_8:setPosition(0, -50)
	lbl_attr_add_8:setContentSize(26.3, 27.72)
	lbl_attr_add_8:setTextColor(cc.c3b(159, 108, 74))
	lbl_attr_add_8:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_add_8:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_attr_add_8)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-63.86)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_attr_add_8.lyt = lyt
	node_icon_8:addChild(lbl_attr_add_8)
	self.lbl_attr_add_8 = lbl_attr_add_8

	local node_icon_7 = cc.Node:create()
	node_icon_7:setPosition(250, 225)
	node_icon_7:setContentSize(0, 0)
	self:addChild(node_icon_7)
	self.node_icon_7 = node_icon_7

	local spr_7_1 = cc.Sprite:create()
	spr_7_1:setPosition(0, 0)
	spr_7_1:setContentSize(76, 76)
	self:addLoadRes(2, spr_7_1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-bg-2.png")
	node_icon_7:addChild(spr_7_1)
	self.spr_7_1 = spr_7_1

	local spr_7_2 = cc.Sprite:create()
	spr_7_2:setPosition(0, 0)
	spr_7_2:setContentSize(74, 74)
	self:addLoadRes(2, spr_7_2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-frame-1.png")
	node_icon_7:addChild(spr_7_2)
	self.spr_7_2 = spr_7_2

	local spr_lock_7 = cc.Sprite:create()
	spr_lock_7:setPosition(0, 0)
	spr_lock_7:setContentSize(76, 76)
	self:addLoadRes(2, spr_lock_7, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-lock.png")
	node_icon_7:addChild(spr_lock_7)
	self.spr_lock_7 = spr_lock_7

	local lbl_attr_add_7 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_add_7:setPosition(0, -50)
	lbl_attr_add_7:setContentSize(26.3, 27.72)
	lbl_attr_add_7:setTextColor(cc.c3b(159, 108, 74))
	lbl_attr_add_7:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_add_7:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_attr_add_7)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-63.86)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_attr_add_7.lyt = lyt
	node_icon_7:addChild(lbl_attr_add_7)
	self.lbl_attr_add_7 = lbl_attr_add_7

	local node_icon_6 = cc.Node:create()
	node_icon_6:setPosition(350, 225)
	node_icon_6:setContentSize(0, 0)
	self:addChild(node_icon_6)
	self.node_icon_6 = node_icon_6

	local spr_61 = cc.Sprite:create()
	spr_61:setPosition(0, 0)
	spr_61:setContentSize(76, 76)
	self:addLoadRes(2, spr_61, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-bg-2.png")
	node_icon_6:addChild(spr_61)
	self.spr_61 = spr_61

	local spr_6_2 = cc.Sprite:create()
	spr_6_2:setPosition(0, 0)
	spr_6_2:setContentSize(74, 74)
	self:addLoadRes(2, spr_6_2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-frame-1.png")
	node_icon_6:addChild(spr_6_2)
	self.spr_6_2 = spr_6_2

	local spr_lock_6 = cc.Sprite:create()
	spr_lock_6:setPosition(0, 0)
	spr_lock_6:setContentSize(76, 76)
	self:addLoadRes(2, spr_lock_6, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-lock.png")
	node_icon_6:addChild(spr_lock_6)
	self.spr_lock_6 = spr_lock_6

	local lbl_attr_add_6 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_add_6:setPosition(0, -50)
	lbl_attr_add_6:setContentSize(26.3, 27.72)
	lbl_attr_add_6:setTextColor(cc.c3b(159, 108, 74))
	lbl_attr_add_6:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_add_6:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_attr_add_6)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-63.86)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_attr_add_6.lyt = lyt
	node_icon_6:addChild(lbl_attr_add_6)
	self.lbl_attr_add_6 = lbl_attr_add_6

	local node_icon_5 = cc.Node:create()
	node_icon_5:setPosition(450, 225)
	node_icon_5:setContentSize(0, 0)
	self:addChild(node_icon_5)
	self.node_icon_5 = node_icon_5

	local spr_5_1 = cc.Sprite:create()
	spr_5_1:setPosition(0, 0)
	spr_5_1:setContentSize(76, 76)
	self:addLoadRes(2, spr_5_1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-bg-2.png")
	node_icon_5:addChild(spr_5_1)
	self.spr_5_1 = spr_5_1

	local spr_5_2 = cc.Sprite:create()
	spr_5_2:setPosition(0, 0)
	spr_5_2:setContentSize(74, 74)
	self:addLoadRes(2, spr_5_2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-frame-1.png")
	node_icon_5:addChild(spr_5_2)
	self.spr_5_2 = spr_5_2

	local spr_lock_5 = cc.Sprite:create()
	spr_lock_5:setPosition(0, 0)
	spr_lock_5:setContentSize(76, 76)
	self:addLoadRes(2, spr_lock_5, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-lock.png")
	node_icon_5:addChild(spr_lock_5)
	self.spr_lock_5 = spr_lock_5

	local lbl_attr_add_5 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_add_5:setPosition(0, -50)
	lbl_attr_add_5:setContentSize(26.3, 27.72)
	lbl_attr_add_5:setTextColor(cc.c3b(159, 108, 74))
	lbl_attr_add_5:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_add_5:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_attr_add_5)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-63.86)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_attr_add_5.lyt = lyt
	node_icon_5:addChild(lbl_attr_add_5)
	self.lbl_attr_add_5 = lbl_attr_add_5

	local node_icon_9 = cc.Node:create()
	node_icon_9:setPosition(540, 225)
	node_icon_9:setContentSize(0, 0)
	self:addChild(node_icon_9)
	self.node_icon_9 = node_icon_9

	local spr_9_1 = cc.Sprite:create()
	spr_9_1:setPosition(0, 0)
	spr_9_1:setContentSize(76, 76)
	self:addLoadRes(2, spr_9_1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-bg-2.png")
	node_icon_9:addChild(spr_9_1)
	self.spr_9_1 = spr_9_1

	local spr_9_2 = cc.Sprite:create()
	spr_9_2:setPosition(0, 0)
	spr_9_2:setContentSize(74, 74)
	self:addLoadRes(2, spr_9_2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", "hero-icon/icon-frame-1.png")
	node_icon_9:addChild(spr_9_2)
	self.spr_9_2 = spr_9_2

	local spr_lock_9 = cc.Sprite:create()
	spr_lock_9:setPosition(0, 0)
	spr_lock_9:setContentSize(76, 76)
	self:addLoadRes(2, spr_lock_9, "ccbi-res/hero-select.plist", "ccbi-res/hero-select.pvr.ccz", "hero-select/spr-lock.png")
	node_icon_9:addChild(spr_lock_9)
	self.spr_lock_9 = spr_lock_9

	local lbl_attr_add_9 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_add_9:setPosition(0, -50)
	lbl_attr_add_9:setContentSize(26.3, 27.72)
	lbl_attr_add_9:setTextColor(cc.c3b(159, 108, 74))
	lbl_attr_add_9:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_add_9:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_attr_add_9)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-63.86)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	lbl_attr_add_9.lyt = lyt
	node_icon_9:addChild(lbl_attr_add_9)
	self.lbl_attr_add_9 = lbl_attr_add_9

	 self:startLoadRes()
end
return AliceChangeLineupCell