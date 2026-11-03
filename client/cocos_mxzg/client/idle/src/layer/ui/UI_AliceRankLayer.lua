local AliceRankLayer = class("AliceRankLayer", require("src.comp.CCCLayerBase")) 

function AliceRankLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 1020)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
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

	local node_title = cc.Node:create()
	node_title:setCascadeOpacityEnabled(true)
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
	spr_title_bg:setContentSize(342, 46)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/title-bar-2.png", capInsets = cc.rect(0,0,0,0)})
	node_title:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580574),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -22)
	lbl_title:setContentSize(228, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(545, 1020)
	menu:setContentSize(0, 0)
	menu:setSwallowsTouches(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setRightMargin(75)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(-1, 0)
	btn_close:setContentSize(55, 58)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_close)
	lyt:setRightMargin(-26.5)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_close.lyt = lyt
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local menu_tab = cpp.UIMenu:create()
	menu_tab:setCascadeOpacityEnabled(true)
	menu_tab:setPosition(310, 910)
	menu_tab:setContentSize(0, 0)
	menu_tab:setSwallowsTouches(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_tab)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(110)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu_tab.lyt = lyt
	self:addChild(menu_tab)
	self.menu_tab = menu_tab

	local btn_tab_1 = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_tab_1:setPosition(5, 0)
	btn_tab_1:setContentSize(134, 56)
	btn_tab_1:setAnchorPoint(cc.p(1, 0.5))
	btn_tab_1:setTag(1)
	btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
	btn_tab_1:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_tab_1:setLabelOffset(cc.p(0, -2))
	btn_tab_1:setLabelText(ex.Tools:getLang(580036))
	local l = btn_tab_1:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_tab_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-17.png", spr2="button/btn-tab-18.png"})
	menu_tab:addChild(btn_tab_1)
	self.btn_tab_1 = btn_tab_1

	local btn_tab_2 = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_tab_2:setPosition(-5, 0)
	btn_tab_2:setContentSize(134, 56)
	btn_tab_2:setAnchorPoint(cc.p(0, 0.5))
	btn_tab_2:setTag(2)
	btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))
	btn_tab_2:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_tab_2:setLabelOffset(cc.p(0, -2))
	btn_tab_2:setLabelText(ex.Tools:getLang(70410))
	local l = btn_tab_2:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_tab_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-21.png", spr2="button/btn-tab-22.png"})
	menu_tab:addChild(btn_tab_2)
	self.btn_tab_2 = btn_tab_2

	local node_rank = cc.Node:create()
	node_rank:setCascadeOpacityEnabled(true)
	node_rank:setPosition(310, 460)
	node_rank:setContentSize(560, 820)
	node_rank:setAnchorPoint(cc.p(0.5, 0.5))
	node_rank:setIgnoreAnchorPointForPosition(false)
	node_rank:setVisible(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_rank)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(150)
	lyt:setBottomMargin(50)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	node_rank.lyt = lyt
	self:addChild(node_rank)
	self.node_rank = node_rank

	local spr_content_bg = cc.Scale9Sprite:create()
	spr_content_bg:setPosition(0, 140)
	spr_content_bg:setContentSize(560, 680)
	spr_content_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_content_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-43.png", capInsets = cc.rect(13,10,13,11)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_content_bg)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(140)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_content_bg.lyt = lyt
	node_rank:addChild(spr_content_bg)
	self.spr_content_bg = spr_content_bg

	local spr_content_self_bg = cc.Scale9Sprite:create()
	spr_content_self_bg:setPosition(280, 55)
	spr_content_self_bg:setContentSize(560, 110)
	self:addLoadRes(1, spr_content_self_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-43.png", capInsets = cc.rect(13,10,13,11)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_content_self_bg)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	spr_content_self_bg.lyt = lyt
	node_rank:addChild(spr_content_self_bg)
	self.spr_content_self_bg = spr_content_self_bg

	local spr_rank_self = cc.Sprite:create()
	spr_rank_self:setPosition(280, 101)
	spr_rank_self:setContentSize(226, 42)
	self:addLoadRes(2, spr_rank_self, "ccbi-res/rank-lang.plist", "ccbi-res/rank-lang.pvr.ccz", "rank-lang/spr-paimingk-3.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_rank_self)
	lyt:setBottomMargin(80)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	spr_rank_self.lyt = lyt
	node_rank:addChild(spr_rank_self)
	self.spr_rank_self = spr_rank_self

	local scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	scroll_view:setPosition(280, 145)
	scroll_view:setContentSize(550, 625)
	scroll_view:setAnchorPoint(cc.p(0.5, 0))
	scroll_view:setIgnoreAnchorPointForPosition(false)
	scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_view:setItemType(1)
	scroll_view:setItemSize(cc.size(510, 110))
	scroll_view:setItemOffset(cc.p(0, 5))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(scroll_view)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(50)
	lyt:setBottomMargin(145)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	scroll_view.lyt = lyt
	node_rank:addChild(scroll_view)
	self.scroll_view = scroll_view

	local node_banner = cc.Node:create()
	node_banner:setCascadeOpacityEnabled(true)
	node_banner:setPosition(280, 820)
	node_banner:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_banner)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_banner.lyt = lyt
	node_rank:addChild(node_banner)
	self.node_banner = node_banner

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(0, 0)
	spr_title_bg:setContentSize(550, 46)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", {frame = "rank/spr-cell-bg.png", capInsets = cc.rect(10,10,10,10)})
	node_banner:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title_1 = cc.Label:createWithTTF(ex.Tools:getLang(91325),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title_1:setPosition(-210, -25)
	lbl_title_1:setContentSize(30.3, 31.72)
	lbl_title_1:setTextColor(cc.c3b(255, 227, 183))
	lbl_title_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_1:enableOutline(cc.c4b(87,56,29,255), 2)
	node_banner:addChild(lbl_title_1)
	self.lbl_title_1 = lbl_title_1

	local lbl_title_2 = cc.Label:createWithTTF(ex.Tools:getLang(5621),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title_2:setPosition(-50, -25)
	lbl_title_2:setContentSize(30.3, 31.72)
	lbl_title_2:setTextColor(cc.c3b(255, 227, 183))
	lbl_title_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_2:enableOutline(cc.c4b(87,56,29,255), 2)
	node_banner:addChild(lbl_title_2)
	self.lbl_title_2 = lbl_title_2

	local lbl_title_3 = cc.Label:createWithTTF(ex.Tools:getLang(580032),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title_3:setPosition(160, -25)
	lbl_title_3:setContentSize(30.3, 31.72)
	lbl_title_3:setTextColor(cc.c3b(255, 227, 183))
	lbl_title_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title_3:enableOutline(cc.c4b(87,56,29,255), 2)
	node_banner:addChild(lbl_title_3)
	self.lbl_title_3 = lbl_title_3

	local node_top = cc.Node:create()
	node_top:setCascadeOpacityEnabled(true)
	node_top:setPosition(310, 460)
	node_top:setContentSize(560, 820)
	node_top:setAnchorPoint(cc.p(0.5, 0.5))
	node_top:setIgnoreAnchorPointForPosition(false)
	node_top:setVisible(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_top)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(150)
	lyt:setBottomMargin(50)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	node_top.lyt = lyt
	self:addChild(node_top)
	self.node_top = node_top

	local spr_content_bg = cc.Scale9Sprite:create()
	spr_content_bg:setPosition(280, 0)
	spr_content_bg:setContentSize(560, 820)
	spr_content_bg:setAnchorPoint(cc.p(0.5, 0))
	self:addLoadRes(1, spr_content_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {frame = "alice/spr-top-bg.png", capInsets = cc.rect(0,0,0,0)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_content_bg)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_content_bg.lyt = lyt
	node_top:addChild(spr_content_bg)
	self.spr_content_bg = spr_content_bg

	local node_top_1 = cc.Node:create()
	node_top_1:setCascadeOpacityEnabled(true)
	node_top_1:setPosition(280, 533.28)
	node_top_1:setContentSize(0, 0)
	node_top:addChild(node_top_1)
	self.node_top_1 = node_top_1

	local spr_seat = cc.Sprite:create()
	spr_seat:setPosition(0, -40)
	spr_seat:setContentSize(304, 199)
	self:addLoadRes(2, spr_seat, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/rank-1.png")
	node_top_1:addChild(spr_seat)
	self.spr_seat = spr_seat

	local node_name_1 = cc.Node:create()
	node_name_1:setCascadeOpacityEnabled(true)
	node_name_1:setPosition(0, 200)
	node_name_1:setContentSize(0, 0)
	node_top_1:addChild(node_name_1)
	self.node_name_1 = node_name_1

	local spr_name_bg = cc.Sprite:create()
	spr_name_bg:setPosition(0, 0)
	spr_name_bg:setContentSize(186, 48)
	spr_name_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(2, spr_name_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/rank-1-name.png")
	node_name_1:addChild(spr_name_bg)
	self.spr_name_bg = spr_name_bg

	local spr_rank = cc.Sprite:create()
	spr_rank:setPosition(-100, -5)
	spr_rank:setContentSize(58, 71)
	spr_rank:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(2, spr_rank, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", "rank/spr-paihang-1.png")
	node_name_1:addChild(spr_rank)
	self.spr_rank = spr_rank

	local lbl_name_1 = cc.Label:createWithTTF(ex.Tools:getLang(91326),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_name_1:setPosition(0, -28)
	lbl_name_1:setContentSize(27.91, 29.2)
	lbl_name_1:setTextColor(cc.c3b(255, 255, 255))
	lbl_name_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name_1:enableOutline(cc.c4b(0,0,0,255), 2)
	node_name_1:addChild(lbl_name_1)
	self.lbl_name_1 = lbl_name_1

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	node_top_1:addChild(menu)
	self.menu = menu

	local btn_log_1 = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_log_1:setPosition(5, -55)
	btn_log_1:setContentSize(130, 40)
	btn_log_1:setTag(1)
	btn_log_1:registerScriptTapHandler(handler(self, self.onBattleLog))
	btn_log_1:getLabel():setTextColor(cc.c4b(101, 67, 50, 255))
	btn_log_1:setLabelOffset(cc.p(0, 0))
	btn_log_1:setLabelSize(36)
	btn_log_1:setLabelText(ex.Tools:getLang(580035))
	self:addLoadRes(3, btn_log_1, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {spr1="alice/rank-1-log.png"})
	menu:addChild(btn_log_1)
	self.btn_log_1 = btn_log_1

	local node_top_2 = cc.Node:create()
	node_top_2:setCascadeOpacityEnabled(true)
	node_top_2:setPosition(130, 260)
	node_top_2:setContentSize(0, 0)
	node_top:addChild(node_top_2)
	self.node_top_2 = node_top_2

	local spr_seat = cc.Sprite:create()
	spr_seat:setPosition(0, -40)
	spr_seat:setContentSize(258, 177)
	self:addLoadRes(2, spr_seat, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/rank-2.png")
	node_top_2:addChild(spr_seat)
	self.spr_seat = spr_seat

	local node_name_2 = cc.Node:create()
	node_name_2:setCascadeOpacityEnabled(true)
	node_name_2:setPosition(0, 200)
	node_name_2:setContentSize(0, 0)
	node_top_2:addChild(node_name_2)
	self.node_name_2 = node_name_2

	local spr_name_bg = cc.Sprite:create()
	spr_name_bg:setPosition(0, 0)
	spr_name_bg:setContentSize(186, 49)
	spr_name_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(2, spr_name_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/rank-2-name.png")
	node_name_2:addChild(spr_name_bg)
	self.spr_name_bg = spr_name_bg

	local spr_rank = cc.Sprite:create()
	spr_rank:setPosition(-100, -5)
	spr_rank:setContentSize(58, 71)
	spr_rank:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(2, spr_rank, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", "rank/spr-paihang-2.png")
	node_name_2:addChild(spr_rank)
	self.spr_rank = spr_rank

	local lbl_name_2 = cc.Label:createWithTTF(ex.Tools:getLang(91326),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_name_2:setPosition(0, -28)
	lbl_name_2:setContentSize(27.91, 29.2)
	lbl_name_2:setTextColor(cc.c3b(255, 255, 255))
	lbl_name_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name_2:enableOutline(cc.c4b(0,0,0,255), 2)
	node_name_2:addChild(lbl_name_2)
	self.lbl_name_2 = lbl_name_2

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	node_top_2:addChild(menu)
	self.menu = menu

	local btn_log_2 = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_log_2:setPosition(0, -55)
	btn_log_2:setContentSize(123, 38)
	btn_log_2:setTag(2)
	btn_log_2:registerScriptTapHandler(handler(self, self.onBattleLog))
	btn_log_2:getLabel():setTextColor(cc.c4b(101, 67, 50, 255))
	btn_log_2:setLabelOffset(cc.p(0, 0))
	btn_log_2:setLabelSize(36)
	btn_log_2:setLabelText(ex.Tools:getLang(580035))
	self:addLoadRes(3, btn_log_2, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {spr1="alice/rank-2-log.png"})
	menu:addChild(btn_log_2)
	self.btn_log_2 = btn_log_2

	local node_top_3 = cc.Node:create()
	node_top_3:setCascadeOpacityEnabled(true)
	node_top_3:setPosition(430, 230)
	node_top_3:setContentSize(0, 0)
	node_top:addChild(node_top_3)
	self.node_top_3 = node_top_3

	local spr_seat = cc.Sprite:create()
	spr_seat:setPosition(0, -40)
	spr_seat:setContentSize(270, 177)
	self:addLoadRes(2, spr_seat, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/rank-3.png")
	node_top_3:addChild(spr_seat)
	self.spr_seat = spr_seat

	local node_name_3 = cc.Node:create()
	node_name_3:setCascadeOpacityEnabled(true)
	node_name_3:setPosition(0, 200)
	node_name_3:setContentSize(0, 0)
	node_top_3:addChild(node_name_3)
	self.node_name_3 = node_name_3

	local spr_name_bg = cc.Sprite:create()
	spr_name_bg:setPosition(0, 0)
	spr_name_bg:setContentSize(186, 49)
	spr_name_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(2, spr_name_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/rank-3-name.png")
	node_name_3:addChild(spr_name_bg)
	self.spr_name_bg = spr_name_bg

	local spr_rank = cc.Sprite:create()
	spr_rank:setPosition(-100, -5)
	spr_rank:setContentSize(58, 71)
	spr_rank:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(2, spr_rank, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", "rank/spr-paihang-3.png")
	node_name_3:addChild(spr_rank)
	self.spr_rank = spr_rank

	local lbl_name_3 = cc.Label:createWithTTF(ex.Tools:getLang(91326),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_name_3:setPosition(0, -28)
	lbl_name_3:setContentSize(27.91, 29.2)
	lbl_name_3:setTextColor(cc.c3b(255, 255, 255))
	lbl_name_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name_3:enableOutline(cc.c4b(0,0,0,255), 2)
	node_name_3:addChild(lbl_name_3)
	self.lbl_name_3 = lbl_name_3

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	node_top_3:addChild(menu)
	self.menu = menu

	local btn_log_3 = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_log_3:setPosition(5, -55)
	btn_log_3:setContentSize(123, 38)
	btn_log_3:setTag(3)
	btn_log_3:registerScriptTapHandler(handler(self, self.onBattleLog))
	btn_log_3:getLabel():setTextColor(cc.c4b(101, 67, 50, 255))
	btn_log_3:setLabelOffset(cc.p(0, 0))
	btn_log_3:setLabelSize(36)
	btn_log_3:setLabelText(ex.Tools:getLang(580035))
	self:addLoadRes(3, btn_log_3, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", {spr1="alice/rank-3-log.png"})
	menu:addChild(btn_log_3)
	self.btn_log_3 = btn_log_3

	 self:startLoadRes()
end
return AliceRankLayer