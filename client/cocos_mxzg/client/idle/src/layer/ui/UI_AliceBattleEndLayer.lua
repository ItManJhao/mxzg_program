local AliceBattleEndLayer = class("AliceBattleEndLayer", require("src.comp.CCCLayerBase")) 

function AliceBattleEndLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(640, 556)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(640, 556)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(4, spr_bg, nil, "ccbi-res/map-bg-result-1.png")
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

	local spr_wing = cc.Sprite:create()
	spr_wing:setPosition(320, 530)
	spr_wing:setContentSize(360, 200)
	self:addLoadRes(2, spr_wing, "ccbi-res/battle-end-1.plist", "ccbi-res/battle-end-1.pvr.ccz", "battle-end/spr-wing-0.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_wing)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-74)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_wing.lyt = lyt
	spr_bg:addChild(spr_wing)
	self.spr_wing = spr_wing

	local spr_result = cc.Sprite:create()
	spr_result:setPosition(320, 520)
	spr_result:setContentSize(172, 116)
	self:addLoadRes(2, spr_result, "ccbi-res/battle-end-lang.plist", "ccbi-res/battle-end-lang.pvr.ccz", "battle-end-lang/lbl-result-0.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_result)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(-22)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	spr_result.lyt = lyt
	spr_bg:addChild(spr_result)
	self.spr_result = spr_result

	local lbl_title = cc.Label:createWithTTF("当前层数：仙境之战。6",FONT_DEFAULT_NAME_BOLD, 24)
	lbl_title:setPosition(305.69, 423.94)
	lbl_title:setContentSize(253.69, 30.24)
	lbl_title:setTextColor(cc.c3b(255, 185, 63))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_bg:addChild(lbl_title)
	self.lbl_title = lbl_title

	local spr_lbl_cell_rank_bg = cc.Sprite:create()
	spr_lbl_cell_rank_bg:setPosition(305.69, 367.34)
	spr_lbl_cell_rank_bg:setContentSize(510, 36)
	self:addLoadRes(2, spr_lbl_cell_rank_bg, "ccbi-res/battle-end-1.plist", "ccbi-res/battle-end-1.pvr.ccz", "battle-end/spr-title.png")
	spr_bg:addChild(spr_lbl_cell_rank_bg)
	self.spr_lbl_cell_rank_bg = spr_lbl_cell_rank_bg

	local lbl_cell_rank = cc.Label:createWithTTF(ex.Tools:getLang(580069),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_cell_rank:setPosition(255, 18)
	lbl_cell_rank:setContentSize(26.3, 27.72)
	lbl_cell_rank:setTextColor(cc.c3b(255, 255, 255))
	lbl_cell_rank:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_cell_rank:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_lbl_cell_rank_bg:addChild(lbl_cell_rank)
	self.lbl_cell_rank = lbl_cell_rank

	local lbl_cell_rank_num = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_cell_rank_num:setPosition(255, 18)
	lbl_cell_rank_num:setContentSize(26.3, 27.72)
	lbl_cell_rank_num:setTextColor(cc.c3b(51, 229, 16))
	lbl_cell_rank_num:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_cell_rank_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_lbl_cell_rank_bg:addChild(lbl_cell_rank_num)
	self.lbl_cell_rank_num = lbl_cell_rank_num

	local spr_lbl_round_bg = cc.Sprite:create()
	spr_lbl_round_bg:setPosition(305.69, 313.6)
	spr_lbl_round_bg:setContentSize(510, 36)
	self:addLoadRes(2, spr_lbl_round_bg, "ccbi-res/battle-end-1.plist", "ccbi-res/battle-end-1.pvr.ccz", "battle-end/spr-title.png")
	spr_bg:addChild(spr_lbl_round_bg)
	self.spr_lbl_round_bg = spr_lbl_round_bg

	local lbl_round = cc.Label:createWithTTF(ex.Tools:getLang(580071),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_round:setPosition(255, 18)
	lbl_round:setContentSize(26.3, 27.72)
	lbl_round:setTextColor(cc.c3b(255, 255, 255))
	lbl_round:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_round:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_lbl_round_bg:addChild(lbl_round)
	self.lbl_round = lbl_round

	local lbl_round_num = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_round_num:setPosition(255, 18)
	lbl_round_num:setContentSize(26.3, 27.72)
	lbl_round_num:setTextColor(cc.c3b(51, 229, 16))
	lbl_round_num:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_round_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_lbl_round_bg:addChild(lbl_round_num)
	self.lbl_round_num = lbl_round_num

	local spr_lbl_hero_die_bg = cc.Sprite:create()
	spr_lbl_hero_die_bg:setPosition(305.69, 258.93)
	spr_lbl_hero_die_bg:setContentSize(510, 36)
	self:addLoadRes(2, spr_lbl_hero_die_bg, "ccbi-res/battle-end-1.plist", "ccbi-res/battle-end-1.pvr.ccz", "battle-end/spr-title.png")
	spr_bg:addChild(spr_lbl_hero_die_bg)
	self.spr_lbl_hero_die_bg = spr_lbl_hero_die_bg

	local lbl_hero_die = cc.Label:createWithTTF(ex.Tools:getLang(580072),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_hero_die:setPosition(255, 18)
	lbl_hero_die:setContentSize(26.3, 27.72)
	lbl_hero_die:setTextColor(cc.c3b(255, 255, 255))
	lbl_hero_die:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_hero_die:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_lbl_hero_die_bg:addChild(lbl_hero_die)
	self.lbl_hero_die = lbl_hero_die

	local lbl_hero_die_num = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_hero_die_num:setPosition(255, 18)
	lbl_hero_die_num:setContentSize(26.3, 27.72)
	lbl_hero_die_num:setTextColor(cc.c3b(51, 229, 16))
	lbl_hero_die_num:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_hero_die_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_lbl_hero_die_bg:addChild(lbl_hero_die_num)
	self.lbl_hero_die_num = lbl_hero_die_num

	local lbl_win_tips = cc.Label:createWithTTF(ex.Tools:getLang(75628),FONT_DEFAULT_NAME_BOLD, 26)
	lbl_win_tips:setPosition(305.69, 220.6)
	lbl_win_tips:setContentSize(31.08, 32.76)
	lbl_win_tips:setTextColor(cc.c3b(255, 230, 132))
	lbl_win_tips:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_win_tips:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_bg:addChild(lbl_win_tips)
	self.lbl_win_tips = lbl_win_tips

	local lbl_fail_tips = cc.Label:createWithTTF(ex.Tools:getLang(5367),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_fail_tips:setPosition(305.69, 217.75)
	lbl_fail_tips:setContentSize(26.3, 27.72)
	lbl_fail_tips:setTextColor(cc.c3b(255, 221, 130))
	lbl_fail_tips:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_fail_tips:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_bg:addChild(lbl_fail_tips)
	self.lbl_fail_tips = lbl_fail_tips

	local btn_menu = cpp.UIMenu:create()
	btn_menu:setPosition(320, 65)
	btn_menu:setContentSize(0, 0)
	btn_menu:setAnchorPoint(cc.p(0.5, 0.5))
	btn_menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	btn_menu.lyt = lyt
	spr_bg:addChild(btn_menu)
	self.btn_menu = btn_menu

	local btn_confirm = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_confirm:setPosition(0, 0)
	btn_confirm:setContentSize(136, 58)
	btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	btn_confirm:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_confirm:setLabelOffset(cc.p(0, -2))
	btn_confirm:setLabelSize(44)
	btn_confirm:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_confirm:setLabelText(ex.Tools:getLang(74224))
	self:addLoadRes(3, btn_confirm, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-big-1.png"})
	btn_menu:addChild(btn_confirm)
	self.btn_confirm = btn_confirm

	local btn_report = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_report:setPosition(226.02, 377.37)
	btn_report:setContentSize(66, 74)
	self:addLoadRes(3, btn_report, "ccbi-res/common-ui.plist", "ccbi-res/common-ui.pvr.ccz", {spr1="button/btn-battle-detail.png"})
	btn_menu:addChild(btn_report)
	self.btn_report = btn_report

	local scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	scroll_view:setPosition(320, 147.56)
	scroll_view:setContentSize(560, 100)
	scroll_view:setAnchorPoint(cc.p(0.5, 0.5))
	scroll_view:setIgnoreAnchorPointForPosition(false)
	scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_view:setItemType(1)
	scroll_view:setItemSize(cc.size(110, 110))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(scroll_view)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	scroll_view.lyt = lyt
	spr_bg:addChild(scroll_view)
	self.scroll_view = scroll_view

	local menu = cpp.UIMenu:create()
	menu:setPosition(0, 150)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	self:addChild(menu)
	self.menu = menu

	 self:startLoadRes()
end
return AliceBattleEndLayer