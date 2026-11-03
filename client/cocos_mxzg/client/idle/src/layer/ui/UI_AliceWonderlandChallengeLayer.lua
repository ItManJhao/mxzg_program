local AliceWonderlandChallengeLayer = class("AliceWonderlandChallengeLayer", require("src.comp.CCCLayerBase")) 

function AliceWonderlandChallengeLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(622, 990)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
	local spr_bg_1 = cc.Scale9Sprite:create()
	spr_bg_1:setPosition(0, 0)
	spr_bg_1:setContentSize(622, 990)
	spr_bg_1:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-11.png", capInsets = cc.rect(58,64,56,71)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg_1)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg_1.lyt = lyt
	self:addChild(spr_bg_1)
	self.spr_bg_1 = spr_bg_1

	local spr_banner_bg = cc.Sprite:create()
	spr_banner_bg:setPosition(311, 821.2)
	spr_banner_bg:setContentSize(554, 190)
	self:addLoadRes(2, spr_banner_bg, "ccbi-res/alice-2.plist", "ccbi-res/alice-2.pvr.ccz", "alice/banner-bg-1.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_banner_bg)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(73.8)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_banner_bg.lyt = lyt
	self:addChild(spr_banner_bg)
	self.spr_banner_bg = spr_banner_bg

	local node_top = cc.Node:create()
	node_top:setCascadeOpacityEnabled(true)
	node_top:setPosition(311, 980.87)
	node_top:setContentSize(622, 0)
	node_top:setAnchorPoint(cc.p(0.5, 0.5))
	node_top:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_top)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(9.13)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_top.lyt = lyt
	self:addChild(node_top)
	self.node_top = node_top

	local spr_little_bg = cc.Sprite:create()
	spr_little_bg:setPosition(311, -5)
	spr_little_bg:setContentSize(344, 48)
	self:addLoadRes(2, spr_little_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "win-bg/title-bar-2.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_little_bg)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-19)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_little_bg.lyt = lyt
	node_top:addChild(spr_little_bg)
	self.spr_little_bg = spr_little_bg

	local lbl_name = cc.Label:createWithTTF("爱丽丝仙境.13星",FONT_DEFAULT_NAME_BOLD, 28)
	lbl_name:setPosition(172, 24)
	lbl_name:setContentSize(211.92, 39.28)
	lbl_name:setTextColor(cc.c3b(255, 229, 148))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name:enableOutline(cc.c4b(117,39,8,255), 2)
	spr_little_bg:addChild(lbl_name)
	self.lbl_name = lbl_name

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(581, -12)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setRightMargin(41)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(12)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	node_top:addChild(menu)
	self.menu = menu

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(0, 0)
	btn_close:setContentSize(55, 58)
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(-25.22, -86.11)
	btn_close:setContentSize(60, 61)
	btn_close:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local team_bg = cc.Scale9Sprite:create()
	team_bg:setPosition(311, 685)
	team_bg:setContentSize(560, 200)
	team_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, team_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-5.png", capInsets = cc.rect(9,10,9,10)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(team_bg)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(305)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	team_bg.lyt = lyt
	self:addChild(team_bg)
	self.team_bg = team_bg

	local team_node = cc.Node:create()
	team_node:setPosition(311, 680)
	team_node:setContentSize(546, 0)
	team_node:setAnchorPoint(cc.p(0.5, 0.5))
	team_node:setIgnoreAnchorPointForPosition(false)
	self:addChild(team_node)
	self.team_node = team_node

	local lbl_attr_node = cc.Node:create()
	lbl_attr_node:setCascadeOpacityEnabled(true)
	lbl_attr_node:setPosition(314.42, 389.65)
	lbl_attr_node:setContentSize(622, 0)
	lbl_attr_node:setAnchorPoint(cc.p(0.5, 1))
	lbl_attr_node:setIgnoreAnchorPointForPosition(false)
	self:addChild(lbl_attr_node)
	self.lbl_attr_node = lbl_attr_node

	local UILabelTTF = cc.Label:createWithTTF(ex.Tools:getLang(580029),FONT_DEFAULT_NAME_BOLD, 20)
	UILabelTTF:setPosition(311, 0)
	UILabelTTF:setContentSize(23.91, 25.2)
	UILabelTTF:setTextColor(cc.c3b(76, 54, 32))
	UILabelTTF:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	UILabelTTF:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(UILabelTTF)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-12.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	UILabelTTF.lyt = lyt
	lbl_attr_node:addChild(UILabelTTF)

	local fixed_attr_node = cc.Node:create()
	fixed_attr_node:setCascadeOpacityEnabled(true)
	fixed_attr_node:setPosition(61, -30)
	fixed_attr_node:setContentSize(0, 0)
	lbl_attr_node:addChild(fixed_attr_node)
	self.fixed_attr_node = fixed_attr_node

	local spr_fixed = cc.Sprite:create()
	spr_fixed:setPosition(0, 0)
	spr_fixed:setContentSize(57, 24)
	self:addLoadRes(2, spr_fixed, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-red.png")
	fixed_attr_node:addChild(spr_fixed)
	self.spr_fixed = spr_fixed

	local lbl_fixed = cc.Label:createWithTTF(ex.Tools:getLang(580054),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_fixed:setPosition(28.5, 12)
	lbl_fixed:setContentSize(25.91, 27.2)
	lbl_fixed:setTextColor(cc.c3b(242, 223, 214))
	lbl_fixed:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_fixed:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_fixed:enableOutline(cc.c4b(166,52,51,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_fixed)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-1.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_fixed.lyt = lyt
	spr_fixed:addChild(lbl_fixed)
	self.lbl_fixed = lbl_fixed

	local lbl_fixed_attr_show = cc.Label:createWithTTF(ex.Tools:getLang(580058),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_fixed_attr_show:setPosition(50, 0)
	lbl_fixed_attr_show:setContentSize(23.91, 25.2)
	lbl_fixed_attr_show:setAnchorPoint(cc.p(0, 0.5))
	lbl_fixed_attr_show:setTextColor(cc.c3b(200, 112, 34))
	lbl_fixed_attr_show:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_fixed_attr_show:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	fixed_attr_node:addChild(lbl_fixed_attr_show)
	self.lbl_fixed_attr_show = lbl_fixed_attr_show

	local random_attr_node_1 = cc.Node:create()
	random_attr_node_1:setCascadeOpacityEnabled(true)
	random_attr_node_1:setPosition(61, -60)
	random_attr_node_1:setContentSize(0, 0)
	lbl_attr_node:addChild(random_attr_node_1)
	self.random_attr_node_1 = random_attr_node_1

	local spr_add_1 = cc.Sprite:create()
	spr_add_1:setPosition(0, 0)
	spr_add_1:setContentSize(57, 24)
	spr_add_1:setVisible(false)
	self:addLoadRes(2, spr_add_1, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-orange.png")
	random_attr_node_1:addChild(spr_add_1)
	self.spr_add_1 = spr_add_1

	local lbl_add_1 = cc.Label:createWithTTF(ex.Tools:getLang(580055),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_add_1:setPosition(28.5, 12)
	lbl_add_1:setContentSize(25.91, 27.2)
	lbl_add_1:setTextColor(cc.c3b(243, 224, 215))
	lbl_add_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_add_1:enableOutline(cc.c4b(177,105,47,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_add_1)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-1.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_add_1.lyt = lyt
	spr_add_1:addChild(lbl_add_1)
	self.lbl_add_1 = lbl_add_1

	local lbl_add_attr_show_1 = cc.Label:createWithTTF(ex.Tools:getLang(580059),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_add_attr_show_1:setPosition(78.5, 12)
	lbl_add_attr_show_1:setContentSize(23.91, 25.2)
	lbl_add_attr_show_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_add_attr_show_1:setTextColor(cc.c3b(200, 112, 34))
	lbl_add_attr_show_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add_attr_show_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_add_1:addChild(lbl_add_attr_show_1)
	self.lbl_add_attr_show_1 = lbl_add_attr_show_1

	local spr_random_1 = cc.Sprite:create()
	spr_random_1:setPosition(0, 0)
	spr_random_1:setContentSize(57, 24)
	self:addLoadRes(2, spr_random_1, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-purple.png")
	random_attr_node_1:addChild(spr_random_1)
	self.spr_random_1 = spr_random_1

	local lbl_random_1 = cc.Label:createWithTTF(ex.Tools:getLang(580056),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_random_1:setPosition(28.5, 12)
	lbl_random_1:setContentSize(25.91, 27.2)
	lbl_random_1:setTextColor(cc.c3b(245, 225, 249))
	lbl_random_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_random_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_random_1:enableOutline(cc.c4b(158,59,158,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_random_1)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-1.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_random_1.lyt = lyt
	spr_random_1:addChild(lbl_random_1)
	self.lbl_random_1 = lbl_random_1

	local lbl_random_attr_show_1 = cc.Label:createWithTTF(ex.Tools:getLang(580059),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_random_attr_show_1:setPosition(78.5, 12)
	lbl_random_attr_show_1:setContentSize(23.91, 25.2)
	lbl_random_attr_show_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_random_attr_show_1:setTextColor(cc.c3b(200, 112, 34))
	lbl_random_attr_show_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_random_attr_show_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_random_1:addChild(lbl_random_attr_show_1)
	self.lbl_random_attr_show_1 = lbl_random_attr_show_1

	local random_attr_node_2 = cc.Node:create()
	random_attr_node_2:setCascadeOpacityEnabled(true)
	random_attr_node_2:setPosition(61, -90)
	random_attr_node_2:setContentSize(0, 0)
	lbl_attr_node:addChild(random_attr_node_2)
	self.random_attr_node_2 = random_attr_node_2

	local spr_add_2 = cc.Sprite:create()
	spr_add_2:setPosition(0, 0)
	spr_add_2:setContentSize(57, 24)
	spr_add_2:setVisible(false)
	self:addLoadRes(2, spr_add_2, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-orange.png")
	random_attr_node_2:addChild(spr_add_2)
	self.spr_add_2 = spr_add_2

	local lbl_add_2 = cc.Label:createWithTTF(ex.Tools:getLang(580055),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_add_2:setPosition(28.5, 12)
	lbl_add_2:setContentSize(25.91, 27.2)
	lbl_add_2:setTextColor(cc.c3b(243, 224, 215))
	lbl_add_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_add_2:enableOutline(cc.c4b(177,105,47,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_add_2)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-1.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_add_2.lyt = lyt
	spr_add_2:addChild(lbl_add_2)
	self.lbl_add_2 = lbl_add_2

	local lbl_add_attr_show_2 = cc.Label:createWithTTF(ex.Tools:getLang(580060),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_add_attr_show_2:setPosition(78.5, 12)
	lbl_add_attr_show_2:setContentSize(23.91, 25.2)
	lbl_add_attr_show_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_add_attr_show_2:setTextColor(cc.c3b(200, 112, 34))
	lbl_add_attr_show_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add_attr_show_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_add_2:addChild(lbl_add_attr_show_2)
	self.lbl_add_attr_show_2 = lbl_add_attr_show_2

	local spr_random_2 = cc.Sprite:create()
	spr_random_2:setPosition(0, 0)
	spr_random_2:setContentSize(57, 24)
	self:addLoadRes(2, spr_random_2, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-purple.png")
	random_attr_node_2:addChild(spr_random_2)
	self.spr_random_2 = spr_random_2

	local lbl_random_2 = cc.Label:createWithTTF(ex.Tools:getLang(580056),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_random_2:setPosition(28.5, 12)
	lbl_random_2:setContentSize(25.91, 27.2)
	lbl_random_2:setTextColor(cc.c3b(245, 225, 249))
	lbl_random_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_random_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_random_2:enableOutline(cc.c4b(158,59,158,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_random_2)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-1.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_random_2.lyt = lyt
	spr_random_2:addChild(lbl_random_2)
	self.lbl_random_2 = lbl_random_2

	local lbl_random_attr_show_2 = cc.Label:createWithTTF(ex.Tools:getLang(580060),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_random_attr_show_2:setPosition(78.5, 12)
	lbl_random_attr_show_2:setContentSize(23.91, 25.2)
	lbl_random_attr_show_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_random_attr_show_2:setTextColor(cc.c3b(200, 112, 34))
	lbl_random_attr_show_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_random_attr_show_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_random_2:addChild(lbl_random_attr_show_2)
	self.lbl_random_attr_show_2 = lbl_random_attr_show_2

	local random_attr_node_3 = cc.Node:create()
	random_attr_node_3:setCascadeOpacityEnabled(true)
	random_attr_node_3:setPosition(61, -120)
	random_attr_node_3:setContentSize(0, 0)
	lbl_attr_node:addChild(random_attr_node_3)
	self.random_attr_node_3 = random_attr_node_3

	local spr_add_3 = cc.Sprite:create()
	spr_add_3:setPosition(0, 0)
	spr_add_3:setContentSize(57, 24)
	spr_add_3:setVisible(false)
	self:addLoadRes(2, spr_add_3, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-orange.png")
	random_attr_node_3:addChild(spr_add_3)
	self.spr_add_3 = spr_add_3

	local lbl_add_3 = cc.Label:createWithTTF(ex.Tools:getLang(580055),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_add_3:setPosition(28.5, 12)
	lbl_add_3:setContentSize(25.91, 27.2)
	lbl_add_3:setTextColor(cc.c3b(243, 224, 215))
	lbl_add_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_add_3:enableOutline(cc.c4b(177,105,47,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_add_3)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-1.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_add_3.lyt = lyt
	spr_add_3:addChild(lbl_add_3)
	self.lbl_add_3 = lbl_add_3

	local lbl_add_attr_show_3 = cc.Label:createWithTTF(ex.Tools:getLang(580061),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_add_attr_show_3:setPosition(78.5, 12)
	lbl_add_attr_show_3:setContentSize(23.91, 25.2)
	lbl_add_attr_show_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_add_attr_show_3:setTextColor(cc.c3b(200, 112, 34))
	lbl_add_attr_show_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add_attr_show_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_add_3:addChild(lbl_add_attr_show_3)
	self.lbl_add_attr_show_3 = lbl_add_attr_show_3

	local spr_random_3 = cc.Sprite:create()
	spr_random_3:setPosition(0, 0)
	spr_random_3:setContentSize(57, 24)
	self:addLoadRes(2, spr_random_3, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-purple.png")
	random_attr_node_3:addChild(spr_random_3)
	self.spr_random_3 = spr_random_3

	local lbl_random_3 = cc.Label:createWithTTF(ex.Tools:getLang(580056),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_random_3:setPosition(28.5, 12)
	lbl_random_3:setContentSize(25.91, 27.2)
	lbl_random_3:setTextColor(cc.c3b(245, 225, 249))
	lbl_random_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_random_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_random_3:enableOutline(cc.c4b(158,59,158,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_random_3)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-1.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_random_3.lyt = lyt
	spr_random_3:addChild(lbl_random_3)
	self.lbl_random_3 = lbl_random_3

	local lbl_random_attr_show_3 = cc.Label:createWithTTF(ex.Tools:getLang(580061),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_random_attr_show_3:setPosition(78.5, 12)
	lbl_random_attr_show_3:setContentSize(23.91, 25.2)
	lbl_random_attr_show_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_random_attr_show_3:setTextColor(cc.c3b(200, 112, 34))
	lbl_random_attr_show_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_random_attr_show_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_random_3:addChild(lbl_random_attr_show_3)
	self.lbl_random_attr_show_3 = lbl_random_attr_show_3

	local random_attr_node_4 = cc.Node:create()
	random_attr_node_4:setCascadeOpacityEnabled(true)
	random_attr_node_4:setPosition(61, -150)
	random_attr_node_4:setContentSize(0, 0)
	lbl_attr_node:addChild(random_attr_node_4)
	self.random_attr_node_4 = random_attr_node_4

	local spr_add_4 = cc.Sprite:create()
	spr_add_4:setPosition(0, 0)
	spr_add_4:setContentSize(57, 24)
	spr_add_4:setVisible(false)
	self:addLoadRes(2, spr_add_4, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-orange.png")
	random_attr_node_4:addChild(spr_add_4)
	self.spr_add_4 = spr_add_4

	local lbl_add_4 = cc.Label:createWithTTF(ex.Tools:getLang(580055),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_add_4:setPosition(28.5, 12)
	lbl_add_4:setContentSize(25.91, 27.2)
	lbl_add_4:setTextColor(cc.c3b(243, 224, 215))
	lbl_add_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_add_4:enableOutline(cc.c4b(177,105,47,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_add_4)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-1.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_add_4.lyt = lyt
	spr_add_4:addChild(lbl_add_4)
	self.lbl_add_4 = lbl_add_4

	local lbl_add_attr_show_4 = cc.Label:createWithTTF(ex.Tools:getLang(580062),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_add_attr_show_4:setPosition(78.5, 12)
	lbl_add_attr_show_4:setContentSize(23.91, 25.2)
	lbl_add_attr_show_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_add_attr_show_4:setTextColor(cc.c3b(200, 112, 34))
	lbl_add_attr_show_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add_attr_show_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_add_4:addChild(lbl_add_attr_show_4)
	self.lbl_add_attr_show_4 = lbl_add_attr_show_4

	local spr_random_4 = cc.Sprite:create()
	spr_random_4:setPosition(0, 0)
	spr_random_4:setContentSize(57, 24)
	self:addLoadRes(2, spr_random_4, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr-purple.png")
	random_attr_node_4:addChild(spr_random_4)
	self.spr_random_4 = spr_random_4

	local lbl_random_4 = cc.Label:createWithTTF(ex.Tools:getLang(580056),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_random_4:setPosition(28.5, 12)
	lbl_random_4:setContentSize(25.91, 27.2)
	lbl_random_4:setTextColor(cc.c3b(245, 225, 249))
	lbl_random_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_random_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_random_4:enableOutline(cc.c4b(158,59,158,255), 1)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_random_4)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-1.6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_random_4.lyt = lyt
	spr_random_4:addChild(lbl_random_4)
	self.lbl_random_4 = lbl_random_4

	local lbl_random_attr_show_4 = cc.Label:createWithTTF(ex.Tools:getLang(580062),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_random_attr_show_4:setPosition(78.5, 12)
	lbl_random_attr_show_4:setContentSize(23.91, 25.2)
	lbl_random_attr_show_4:setAnchorPoint(cc.p(0, 0.5))
	lbl_random_attr_show_4:setTextColor(cc.c3b(200, 112, 34))
	lbl_random_attr_show_4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_random_attr_show_4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_random_4:addChild(lbl_random_attr_show_4)
	self.lbl_random_attr_show_4 = lbl_random_attr_show_4

	local node_bottom = cc.Node:create()
	node_bottom:setCascadeOpacityEnabled(true)
	node_bottom:setPosition(311, 155)
	node_bottom:setContentSize(622, 0)
	node_bottom:setAnchorPoint(cc.p(0.5, 0.5))
	node_bottom:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_bottom)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setBottomMargin(155)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_bottom.lyt = lyt
	self:addChild(node_bottom)
	self.node_bottom = node_bottom

	local spr_line = cc.Sprite:create()
	spr_line:setPosition(311, 0)
	spr_line:setContentSize(546, 2)
	node_bottom:addChild(spr_line)
	self.spr_line = spr_line

	local menu_bottom = cpp.UIMenu:create()
	menu_bottom:setCascadeOpacityEnabled(true)
	menu_bottom:setPosition(311, -60)
	menu_bottom:setContentSize(622, 0)
	menu_bottom:setAnchorPoint(cc.p(0.5, 0.5))
	menu_bottom:setIgnoreAnchorPointForPosition(false)
	menu_bottom:setAnchorPoint(cc.p(0.5, 0.5))
	menu_bottom:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_bottom)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setBottomMargin(-60)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	menu_bottom.lyt = lyt
	node_bottom:addChild(menu_bottom)
	self.menu_bottom = menu_bottom

	local btn_change_lineup = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_change_lineup:setPosition(121, 0)
	btn_change_lineup:setContentSize(197, 60)
	btn_change_lineup:setScale(0.9, 0.9)
	btn_change_lineup:registerScriptTapHandler(handler(self, self.onChangeLineup))
	btn_change_lineup:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_change_lineup:setLabelOffset(cc.p(0, 0))
	btn_change_lineup:setLabelSize(48)
	btn_change_lineup:setLabelOutLine(cc.c4b(26,86,171,255), 4)
	btn_change_lineup:setLabelText(ex.Tools:getLang(580026))
	self:addLoadRes(3, btn_change_lineup, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-blue-7.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_change_lineup)
	lyt:setLeftMargin(32.35)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(-27)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_change_lineup.lyt = lyt
	menu_bottom:addChild(btn_change_lineup)
	self.btn_change_lineup = btn_change_lineup

	local btn_start_battle = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_start_battle:setPosition(311, 0)
	btn_start_battle:setContentSize(197, 60)
	btn_start_battle:setScale(0.9, 0.9)
	btn_start_battle:registerScriptTapHandler(handler(self, self.onBattle))
	btn_start_battle:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_start_battle:setLabelOffset(cc.p(0, 0))
	btn_start_battle:setLabelSize(48)
	btn_start_battle:setLabelOutLine(cc.c4b(89,27,215,255), 4)
	btn_start_battle:setLabelText(ex.Tools:getLang(580027))
	self:addLoadRes(3, btn_start_battle, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-buy-5.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_start_battle)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	btn_start_battle.lyt = lyt
	menu_bottom:addChild(btn_start_battle)
	self.btn_start_battle = btn_start_battle

	local btn_select_gain = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_select_gain:setPosition(501, 0)
	btn_select_gain:setContentSize(197, 60)
	btn_select_gain:setScale(0.9, 0.9)
	btn_select_gain:registerScriptTapHandler(handler(self, self.onSelectGain))
	btn_select_gain:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_select_gain:setLabelOffset(cc.p(0, 0))
	btn_select_gain:setLabelSize(48)
	btn_select_gain:setLabelOutLine(cc.c4b(26,86,171,255), 4)
	btn_select_gain:setLabelText(ex.Tools:getLang(580028))
	self:addLoadRes(3, btn_select_gain, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-blue-7.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_select_gain)
	lyt:setRightMargin(32.35)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(-27)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_select_gain.lyt = lyt
	menu_bottom:addChild(btn_select_gain)
	self.btn_select_gain = btn_select_gain

	 self:startLoadRes()
end
return AliceWonderlandChallengeLayer