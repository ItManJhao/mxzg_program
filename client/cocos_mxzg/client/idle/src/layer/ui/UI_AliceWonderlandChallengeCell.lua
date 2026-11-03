local AliceWonderlandChallengeCell = class("AliceWonderlandChallengeCell", require("src.comp.CCCLayerBase")) 

function AliceWonderlandChallengeCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(546, 98)
	self:setAnchorPoint(cc.p(0, 0.5))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(273, 49)
	spr_bg:setContentSize(546, 98)
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-44.png", capInsets = cc.rect(8,43,9,29)})
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

	local team_scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	team_scroll_view:setPosition(350, 49)
	team_scroll_view:setContentSize(380, 98)
	team_scroll_view:setAnchorPoint(cc.p(0.5, 0.5))
	team_scroll_view:setIgnoreAnchorPointForPosition(false)
	team_scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
	team_scroll_view:setItemType(1)
	team_scroll_view:setItemSize(cc.size(80, 80))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(team_scroll_view)
	lyt:setRightMargin(6)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	team_scroll_view.lyt = lyt
	self:addChild(team_scroll_view)
	self.team_scroll_view = team_scroll_view

	local team_node = cc.Node:create()
	team_node:setPosition(0, 49)
	team_node:setContentSize(0, 98)
	team_node:setAnchorPoint(cc.p(0.5, 0.5))
	team_node:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(team_node)
	lyt:setLeftMargin(0)
	lyt:setHorizontalEdge(1)
	lyt:setPositionPercentYEnabled(true)
	lyt:setPositionPercentY(0.5)
	self:addLyt(lyt)
	team_node.lyt = lyt
	self:addChild(team_node)
	self.team_node = team_node

	local lbl_team_bg = cc.Sprite:create()
	lbl_team_bg:setPosition(0, 98)
	lbl_team_bg:setContentSize(109, 43)
	lbl_team_bg:setAnchorPoint(cc.p(0, 1))
	self:addLoadRes(2, lbl_team_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/lbl-team-bg.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_team_bg)
	lyt:setLeftMargin(0)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_team_bg.lyt = lyt
	team_node:addChild(lbl_team_bg)
	self.lbl_team_bg = lbl_team_bg

	local lbl_team_name = cc.Label:createWithTTF(ex.Tools:getLang(580051),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_team_name:setPosition(15, 24.09)
	lbl_team_name:setContentSize(60, 25.2)
	lbl_team_name:setAnchorPoint(cc.p(0, 0.5))
	lbl_team_name:setTextColor(cc.c3b(255, 255, 255))
	lbl_team_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_team_bg:addChild(lbl_team_name)
	self.lbl_team_name = lbl_team_name

	local lbl_fitting_bg = cc.Sprite:create()
	lbl_fitting_bg:setPosition(5, 32.5)
	lbl_fitting_bg:setContentSize(155, 31)
	lbl_fitting_bg:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, lbl_fitting_bg, "ccbi-res/alice.plist", "ccbi-res/alice.pvr.ccz", "alice/spr_atk_bg.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(lbl_fitting_bg)
	lyt:setLeftMargin(5)
	lyt:setHorizontalEdge(1)
	lyt:setTopMargin(50)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	lbl_fitting_bg.lyt = lyt
	team_node:addChild(lbl_fitting_bg)
	self.lbl_fitting_bg = lbl_fitting_bg

	local lbl_fitting_num = cc.Label:createWithTTF(ex.Tools:getLang(580051),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_fitting_num:setPosition(30, 15.5)
	lbl_fitting_num:setContentSize(91.25, 25.2)
	lbl_fitting_num:setAnchorPoint(cc.p(0, 0.5))
	lbl_fitting_num:setTextColor(cc.c3b(255, 255, 255))
	lbl_fitting_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_fitting_bg:addChild(lbl_fitting_num)
	self.lbl_fitting_num = lbl_fitting_num

	 self:startLoadRes()
end
return AliceWonderlandChallengeCell