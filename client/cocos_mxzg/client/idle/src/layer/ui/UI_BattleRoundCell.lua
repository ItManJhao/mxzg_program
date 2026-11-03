local BattleRoundCell = class("BattleRoundCell", require("src.comp.CCCLayerBase")) 

function BattleRoundCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(360, 50)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(180, 28.5)
	spr_title_bg:setContentSize(356, 57)
	self:addLoadRes(1, spr_title_bg, "ccbi-res/battle-end-1.plist", "ccbi-res/battle-end-1.pvr.ccz", {frame = "battle-end/spr-round-bg-2.png", capInsets = cc.rect(0,0,0,0)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_title_bg)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	spr_title_bg.lyt = lyt
	self:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580525),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_title:setPosition(178, 28.5)
	lbl_title:setContentSize(28.69, 30.24)
	lbl_title:setTextColor(cc.c3b(83, 61, 38))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	spr_title_bg:addChild(lbl_title)
	self.lbl_title = lbl_title

	local node_round_info = cc.Node:create()
	node_round_info:setPosition(180, -5)
	node_round_info:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_round_info)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(-5)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_round_info.lyt = lyt
	self:addChild(node_round_info)
	self.node_round_info = node_round_info

	 self:startLoadRes()
end
return BattleRoundCell