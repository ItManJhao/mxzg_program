local AliceRewardCell = class("AliceRewardCell", require("src.comp.CCCLayerBase")) 

function AliceRewardCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(510, 105)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_cell_bg = cc.Scale9Sprite:create()
	spr_cell_bg:setPosition(255, 52.5)
	spr_cell_bg:setContentSize(510, 105)
	self:addLoadRes(1, spr_cell_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/cell-bg-1.png", capInsets = cc.rect(13,12,13,13)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_cell_bg)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_cell_bg.lyt = lyt
	self:addChild(spr_cell_bg)
	self.spr_cell_bg = spr_cell_bg

	local menu_item = require('src.comp.menu.UIMenuEx'):create()
	menu_item:setPosition(180, 50)
	menu_item:setContentSize(420, 80)
	menu_item:setScale(0.75, 0.75)
	menu_item:setAnchorPoint(cc.p(0, 0))
	menu_item:setSwallowsTouches(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 10, false)
	ly.node = menu_item
	menu_item.layoutex = ly
	self:addLyt(ly)
	self:addChild(menu_item)
	self.menu_item = menu_item

	local node_rank = cc.Node:create()
	node_rank:setPosition(80, 105)
	node_rank:setContentSize(0, 0)
	node_rank:setVisible(false)
	self:addChild(node_rank)
	self.node_rank = node_rank

	local spr_rank = cc.Sprite:create()
	spr_rank:setPosition(0, 0)
	spr_rank:setContentSize(58, 71)
	spr_rank:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(2, spr_rank, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", "rank/spr-paihang-1.png")
	node_rank:addChild(spr_rank)
	self.spr_rank = spr_rank

	local lbl_rank = cc.Label:createWithTTF(ex.Tools:getLang(5313),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_rank:setPosition(0, -50)
	lbl_rank:setContentSize(45.72, 34.24)
	lbl_rank:setTextColor(cc.c3b(255, 255, 255))
	lbl_rank:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rank:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rank:enableOutline(cc.c4b(77,37,31,255), 2)
	node_rank:addChild(lbl_rank)
	self.lbl_rank = lbl_rank

	local node_star = cc.Node:create()
	node_star:setPosition(90, 50)
	node_star:setContentSize(0, 0)
	node_star:setVisible(false)
	self:addChild(node_star)
	self.node_star = node_star

	local spr_star_bg = cc.Sprite:create()
	spr_star_bg:setPosition(0, 0)
	spr_star_bg:setContentSize(140, 46)
	self:addLoadRes(2, spr_star_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "button/btn-tab-30.png")
	node_star:addChild(spr_star_bg)
	self.spr_star_bg = spr_star_bg

	local lbl_star = cc.Label:createWithTTF(ex.Tools:getLang(5313),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_star:setPosition(0, -2)
	lbl_star:setContentSize(89.89, 27.72)
	lbl_star:setTextColor(cc.c3b(165, 89, 27))
	lbl_star:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_star:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_star:addChild(lbl_star)
	self.lbl_star = lbl_star

	local node_self = cc.Node:create()
	node_self:setPosition(10, 50)
	node_self:setContentSize(0, 0)
	node_self:setVisible(false)
	self:addChild(node_self)
	self.node_self = node_self

	local lbl_self_rank = cc.Label:createWithTTF(ex.Tools:getLang(5313),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_self_rank:setPosition(0, 15)
	lbl_self_rank:setContentSize(38.24, 27.72)
	lbl_self_rank:setAnchorPoint(cc.p(0, 0.5))
	lbl_self_rank:setTextColor(cc.c3b(21, 165, 10))
	lbl_self_rank:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_self_rank:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_self:addChild(lbl_self_rank)
	self.lbl_self_rank = lbl_self_rank

	local lbl_self_rank_tip = cc.Label:createWithTTF(ex.Tools:getLang(5139),FONT_DEFAULT_NAME_BOLD, 16)
	lbl_self_rank_tip:setPosition(0, -15)
	lbl_self_rank_tip:setContentSize(112, 20.16)
	lbl_self_rank_tip:setAnchorPoint(cc.p(0, 0.5))
	lbl_self_rank_tip:setTextColor(cc.c3b(122, 71, 45))
	lbl_self_rank_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_self_rank_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_self:addChild(lbl_self_rank_tip)
	self.lbl_self_rank_tip = lbl_self_rank_tip

	 self:startLoadRes()
end
return AliceRewardCell