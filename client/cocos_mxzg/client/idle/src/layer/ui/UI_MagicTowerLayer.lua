local MagicTowerLayer = class("MagicTowerLayer", require("src.comp.CCCLayerBase")) 

function MagicTowerLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(640, 1280)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(self)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	self.lyt = lyt
	local scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	scroll_view:setPosition(420, 100)
	scroll_view:setContentSize(430, 1180)
	scroll_view:setAnchorPoint(cc.p(0.5, 0))
	scroll_view:setIgnoreAnchorPointForPosition(false)
	scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_view:setItemType(1)
	scroll_view:setItemSize(cc.size(430, 166))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(scroll_view)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(100)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	scroll_view.lyt = lyt
	self:addChild(scroll_view)
	self.scroll_view = scroll_view

	local menu_right_top = cpp.UIMenu:create()
	menu_right_top:setPosition(540, 1133)
	menu_right_top:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_right_top)
	lyt:setRightMargin(100)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(147)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu_right_top.lyt = lyt
	self:addChild(menu_right_top)
	self.menu_right_top = menu_right_top

	local btn_back = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_back:setPosition(0, 0)
	btn_back:setContentSize(119, 55)
	btn_back:registerScriptTapHandler(handler(self, self.onBack))
	self:addLoadRes(3, btn_back, "ccbi-res/common-ui.plist", "ccbi-res/common-ui.pvr.ccz", {spr1="button/btn-back-1.png"})
	menu_right_top:addChild(btn_back)
	self.btn_back = btn_back

	local node_bottom = cc.Node:create()
	node_bottom:setPosition(320, 0)
	node_bottom:setContentSize(640, 260)
	node_bottom:setAnchorPoint(cc.p(0.5, 0))
	node_bottom:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_bottom)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_bottom.lyt = lyt
	self:addChild(node_bottom)
	self.node_bottom = node_bottom

	local spr_bg_bottom = cc.Scale9Sprite:create()
	spr_bg_bottom:setPosition(320, 0)
	spr_bg_bottom:setContentSize(640, 260)
	spr_bg_bottom:setAnchorPoint(cc.p(0.5, 0))
	spr_bg_bottom:setOpacity(122)
	self:addLoadRes(1, spr_bg_bottom, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-7.png", capInsets = cc.rect(15,14,16,14)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg_bottom)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg_bottom.lyt = lyt
	node_bottom:addChild(spr_bg_bottom)
	self.spr_bg_bottom = spr_bg_bottom

	local menu_left_bottom = cpp.UIMenu:create()
	menu_left_bottom:setPosition(30, 180)
	menu_left_bottom:setContentSize(100, 100)
	menu_left_bottom:setAnchorPoint(cc.p(0, 0))
	menu_left_bottom:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_left_bottom)
	lyt:setLeftMargin(30)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(180)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	menu_left_bottom.lyt = lyt
	self:addChild(menu_left_bottom)
	self.menu_left_bottom = menu_left_bottom

	local btn_star_select = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_star_select:setPosition(40, 40)
	btn_star_select:setContentSize(100, 92)
	btn_star_select:registerScriptTapHandler(handler(self, self.onStarSelect))
	btn_star_select:getLabel():setTextColor(cc.c4b(255, 229, 138, 255))
	btn_star_select:setLabelOffset(cc.p(0, -35))
	btn_star_select:setLabelSize(40)
	btn_star_select:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_star_select:setLabelText(ex.Tools:getLang(57534))
	self:addLoadRes(3, btn_star_select, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", {spr1="magic-tower/btn-star-select.png", spr2="magic-tower/btn-star-select.png"})
	menu_left_bottom:addChild(btn_star_select)
	self.btn_star_select = btn_star_select

	local btn_rank = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_rank:setPosition(40, 140)
	btn_rank:setContentSize(60, 60)
	btn_rank:registerScriptTapHandler(handler(self, self.onRank))
	btn_rank:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_rank:setLabelOffset(cc.p(0, -30))
	btn_rank:setLabelSize(40)
	btn_rank:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_rank:setLabelText(ex.Tools:getLang(57508))
	self:addLoadRes(3, btn_rank, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-new-rank-2.png", spr2="button/btn-new-rank-2.png"})
	menu_left_bottom:addChild(btn_rank)
	self.btn_rank = btn_rank

	local btn_road = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_road:setPosition(40, 240)
	btn_road:setContentSize(100, 100)
	btn_road:registerScriptTapHandler(handler(self, self.onRoad))
	btn_road:getLabel():setTextColor(cc.c4b(255, 229, 138, 255))
	btn_road:setLabelOffset(cc.p(0, -30))
	btn_road:setLabelSize(40)
	btn_road:setLabelOutLine(cc.c4b(76,37,49,255), 4)
	btn_road:setLabelText(ex.Tools:getLang(57533))
	self:addLoadRes(3, btn_road, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", {spr1="magic-tower/btn-road.png", spr2="magic-tower/btn-road.png"})
	menu_left_bottom:addChild(btn_road)
	self.btn_road = btn_road

	local btn_shop = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_shop:setPosition(40, 340)
	btn_shop:setContentSize(60, 60)
	btn_shop:registerScriptTapHandler(handler(self, self.onShop))
	btn_shop:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_shop:setLabelOffset(cc.p(0, -20))
	btn_shop:setLabelSize(40)
	btn_shop:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_shop:setLabelText(ex.Tools:getLang(57515))
	self:addLoadRes(3, btn_shop, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-new-shop.png", spr2="button/btn-new-shop.png"})
	menu_left_bottom:addChild(btn_shop)
	self.btn_shop = btn_shop

	local node_right_bottom = cc.Node:create()
	node_right_bottom:setPosition(640, 180)
	node_right_bottom:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_right_bottom)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(2)
	lyt:setBottomMargin(180)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_right_bottom.lyt = lyt
	self:addChild(node_right_bottom)
	self.node_right_bottom = node_right_bottom

	local spr_res_bg = cc.Scale9Sprite:create()
	spr_res_bg:setPosition(-60, 50)
	spr_res_bg:setContentSize(240, 40)
	spr_res_bg:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(1, spr_res_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "other/spr-res-bg-1.png", capInsets = cc.rect(20,0,20,0)})
	node_right_bottom:addChild(spr_res_bg)
	self.spr_res_bg = spr_res_bg

	local lbl_challenge_time_title = cc.Label:createWithTTF(ex.Tools:getLang(5158),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_challenge_time_title:setPosition(-145, 48)
	lbl_challenge_time_title:setContentSize(140.7, 29.72)
	lbl_challenge_time_title:setAnchorPoint(cc.p(1, 0.5))
	lbl_challenge_time_title:setTextColor(cc.c3b(255, 255, 255))
	lbl_challenge_time_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_challenge_time_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_challenge_time_title:enableOutline(cc.c4b(120,81,68,255), 1)
	node_right_bottom:addChild(lbl_challenge_time_title)
	self.lbl_challenge_time_title = lbl_challenge_time_title

	local lbl_challenge_times = cc.Label:createWithTTF("2/2",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_challenge_times:setPosition(-140, 48)
	lbl_challenge_times:setContentSize(36.12, 29.72)
	lbl_challenge_times:setAnchorPoint(cc.p(0, 0.5))
	lbl_challenge_times:setTextColor(cc.c3b(255, 255, 255))
	lbl_challenge_times:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_challenge_times:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_challenge_times:enableOutline(cc.c4b(120,81,68,255), 1)
	node_right_bottom:addChild(lbl_challenge_times)
	self.lbl_challenge_times = lbl_challenge_times

	local lbl_buy_time_title = cc.Label:createWithTTF(ex.Tools:getLang(5203),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_buy_time_title:setPosition(-130, 10)
	lbl_buy_time_title:setContentSize(140.7, 29.72)
	lbl_buy_time_title:setAnchorPoint(cc.p(1, 0.5))
	lbl_buy_time_title:setTextColor(cc.c3b(255, 255, 255))
	lbl_buy_time_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_buy_time_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_buy_time_title:enableOutline(cc.c4b(120,81,68,255), 1)
	node_right_bottom:addChild(lbl_buy_time_title)
	self.lbl_buy_time_title = lbl_buy_time_title

	local lbl_buy_times = cc.Label:createWithTTF("3",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_buy_times:setPosition(-125, 10)
	lbl_buy_times:setContentSize(14.55, 29.72)
	lbl_buy_times:setAnchorPoint(cc.p(0, 0.5))
	lbl_buy_times:setTextColor(cc.c3b(30, 255, 0))
	lbl_buy_times:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_buy_times:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_buy_times:enableOutline(cc.c4b(120,81,68,255), 1)
	node_right_bottom:addChild(lbl_buy_times)
	self.lbl_buy_times = lbl_buy_times

	local menu = cpp.UIMenu:create()
	menu:setPosition(-60, 50)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	node_right_bottom:addChild(menu)
	self.menu = menu

	local btn_buy_times = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_buy_times:setPosition(-20, 0)
	btn_buy_times:setContentSize(38, 38)
	btn_buy_times:registerScriptTapHandler(handler(self, self.onBuyTimes))
	self:addLoadRes(3, btn_buy_times, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-add-4.png"})
	menu:addChild(btn_buy_times)
	self.btn_buy_times = btn_buy_times

	local node_rank = cc.Node:create()
	node_rank:setPosition(30, 1130)
	node_rank:setContentSize(270, 220)
	node_rank:setAnchorPoint(cc.p(0, 1))
	node_rank:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_rank)
	lyt:setLeftMargin(30)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(150)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_rank.lyt = lyt
	self:addChild(node_rank)
	self.node_rank = node_rank

	local spr_bg_rank = cc.Scale9Sprite:create()
	spr_bg_rank:setPosition(0, 220)
	spr_bg_rank:setContentSize(270, 220)
	spr_bg_rank:setAnchorPoint(cc.p(0, 1))
	self:addLoadRes(1, spr_bg_rank, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", {frame = "magic-tower/spr-bg-rank.png", capInsets = cc.rect(30,60,30,30)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_bg_rank)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_bg_rank.lyt = lyt
	node_rank:addChild(spr_bg_rank)
	self.spr_bg_rank = spr_bg_rank

	local menu = cpp.UIMenu:create()
	menu:setPosition(0, 220)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0, 1))
	menu:setIgnoreAnchorPointForPosition(false)
	node_rank:addChild(menu)
	self.menu = menu

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(30, 30)
	btn_info:setContentSize(60, 61)
	btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png"})
	menu:addChild(btn_info)
	self.btn_info = btn_info

	local btn_rank_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_rank_info:setPosition(210, -185)
	btn_rank_info:setContentSize(88, 36)
	btn_rank_info:registerScriptTapHandler(handler(self, self.onRank))
	self:addLoadRes(3, btn_rank_info, "ccbi-res/fantasy-tower-lang.plist", "ccbi-res/fantasy-tower-lang.pvr.ccz", {spr1="fantasy-tower-lang/btn-rank-2.png"})
	menu:addChild(btn_rank_info)
	self.btn_rank_info = btn_rank_info

	local lbl_rank_title = cc.Label:createWithTTF(ex.Tools:getLang(57508),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_title:setPosition(135, 192)
	lbl_rank_title:setContentSize(27.91, 29.2)
	lbl_rank_title:setTextColor(cc.c3b(255, 238, 178))
	lbl_rank_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rank_title:enableOutline(cc.c4b(81,60,65,255), 2)
	node_rank:addChild(lbl_rank_title)
	self.lbl_rank_title = lbl_rank_title

	local lbl_rank_self_title = cc.Label:createWithTTF(ex.Tools:getLang(74811),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_self_title:setPosition(20, 35)
	lbl_rank_self_title:setContentSize(27.91, 29.2)
	lbl_rank_self_title:setAnchorPoint(cc.p(0, 0.5))
	lbl_rank_self_title:setTextColor(cc.c3b(255, 255, 255))
	lbl_rank_self_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_self_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rank_self_title:enableOutline(cc.c4b(81,60,65,255), 2)
	node_rank:addChild(lbl_rank_self_title)
	self.lbl_rank_self_title = lbl_rank_self_title

	local lbl_rank_self = cc.Label:createWithTTF(ex.Tools:getLang(57508),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_self:setPosition(20, 35)
	lbl_rank_self:setContentSize(27.91, 29.2)
	lbl_rank_self:setAnchorPoint(cc.p(0, 0.5))
	lbl_rank_self:setTextColor(cc.c3b(255, 255, 255))
	lbl_rank_self:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_self:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rank_self:enableOutline(cc.c4b(81,60,65,255), 2)
	node_rank:addChild(lbl_rank_self)
	self.lbl_rank_self = lbl_rank_self

	local node_rank_cell_1 = cc.Node:create()
	node_rank_cell_1:setPosition(0, 160)
	node_rank_cell_1:setContentSize(0, 0)
	node_rank:addChild(node_rank_cell_1)
	self.node_rank_cell_1 = node_rank_cell_1

	local spr_rank_1 = cc.Sprite:create()
	spr_rank_1:setPosition(30, 0)
	spr_rank_1:setContentSize(34, 34)
	self:addLoadRes(2, spr_rank_1, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", "rank/spr-rank-1.png")
	node_rank_cell_1:addChild(spr_rank_1)
	self.spr_rank_1 = spr_rank_1

	local lbl_rank_name_1 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_name_1:setPosition(60, 0)
	lbl_rank_name_1:setContentSize(23.91, 25.2)
	lbl_rank_name_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_rank_name_1:setTextColor(cc.c3b(255, 255, 255))
	lbl_rank_name_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_name_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_rank_cell_1:addChild(lbl_rank_name_1)
	self.lbl_rank_name_1 = lbl_rank_name_1

	local lbl_rank_stage_1 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_stage_1:setPosition(220, 0)
	lbl_rank_stage_1:setContentSize(27.91, 29.2)
	lbl_rank_stage_1:setTextColor(cc.c3b(255, 255, 255))
	lbl_rank_stage_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_stage_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rank_stage_1:enableOutline(cc.c4b(81,60,65,255), 2)
	node_rank_cell_1:addChild(lbl_rank_stage_1)
	self.lbl_rank_stage_1 = lbl_rank_stage_1

	local node_rank_cell_2 = cc.Node:create()
	node_rank_cell_2:setPosition(0, 120)
	node_rank_cell_2:setContentSize(0, 0)
	node_rank:addChild(node_rank_cell_2)
	self.node_rank_cell_2 = node_rank_cell_2

	local spr_rank_2 = cc.Sprite:create()
	spr_rank_2:setPosition(30, 0)
	spr_rank_2:setContentSize(34, 34)
	self:addLoadRes(2, spr_rank_2, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", "rank/spr-rank-2.png")
	node_rank_cell_2:addChild(spr_rank_2)
	self.spr_rank_2 = spr_rank_2

	local lbl_rank_name_2 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_name_2:setPosition(60, 0)
	lbl_rank_name_2:setContentSize(23.91, 25.2)
	lbl_rank_name_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_rank_name_2:setTextColor(cc.c3b(255, 255, 255))
	lbl_rank_name_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_name_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_rank_cell_2:addChild(lbl_rank_name_2)
	self.lbl_rank_name_2 = lbl_rank_name_2

	local lbl_rank_stage_2 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_stage_2:setPosition(220, 0)
	lbl_rank_stage_2:setContentSize(27.91, 29.2)
	lbl_rank_stage_2:setTextColor(cc.c3b(255, 255, 255))
	lbl_rank_stage_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_stage_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rank_stage_2:enableOutline(cc.c4b(81,60,65,255), 2)
	node_rank_cell_2:addChild(lbl_rank_stage_2)
	self.lbl_rank_stage_2 = lbl_rank_stage_2

	local node_rank_cell_3 = cc.Node:create()
	node_rank_cell_3:setPosition(0, 80)
	node_rank_cell_3:setContentSize(0, 0)
	node_rank:addChild(node_rank_cell_3)
	self.node_rank_cell_3 = node_rank_cell_3

	local spr_rank_3 = cc.Sprite:create()
	spr_rank_3:setPosition(30, 0)
	spr_rank_3:setContentSize(34, 34)
	self:addLoadRes(2, spr_rank_3, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", "rank/spr-rank-3.png")
	node_rank_cell_3:addChild(spr_rank_3)
	self.spr_rank_3 = spr_rank_3

	local lbl_rank_name_3 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_name_3:setPosition(60, 0)
	lbl_rank_name_3:setContentSize(23.91, 25.2)
	lbl_rank_name_3:setAnchorPoint(cc.p(0, 0.5))
	lbl_rank_name_3:setTextColor(cc.c3b(255, 255, 255))
	lbl_rank_name_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_name_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_rank_cell_3:addChild(lbl_rank_name_3)
	self.lbl_rank_name_3 = lbl_rank_name_3

	local lbl_rank_stage_3 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rank_stage_3:setPosition(220, 0)
	lbl_rank_stage_3:setContentSize(27.91, 29.2)
	lbl_rank_stage_3:setTextColor(cc.c3b(255, 255, 255))
	lbl_rank_stage_3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank_stage_3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rank_stage_3:enableOutline(cc.c4b(81,60,65,255), 2)
	node_rank_cell_3:addChild(lbl_rank_stage_3)
	self.lbl_rank_stage_3 = lbl_rank_stage_3

	 self:startLoadRes()
end
return MagicTowerLayer