local AliceRankCell = class("AliceRankCell", require("src.comp.CCCLayerBase")) 

function AliceRankCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(550, 105)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_cell_bg = cc.Scale9Sprite:create()
	spr_cell_bg:setPosition(275, 52.5)
	spr_cell_bg:setContentSize(550, 105)
	self:addLoadRes(1, spr_cell_bg, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", {frame = "rank/spr-cell-bg-2.png", capInsets = cc.rect(40,40,40,40)})
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

	local spr_cell_bg_self = cc.Scale9Sprite:create()
	spr_cell_bg_self:setPosition(255, 52.5)
	spr_cell_bg_self:setContentSize(510, 105)
	spr_cell_bg_self:setVisible(false)
	self:addLoadRes(1, spr_cell_bg_self, "ccbi-res/rank.plist", "ccbi-res/rank.pvr.ccz", {frame = "rank/spr-cell-bg-1.png", capInsets = cc.rect(40,40,40,40)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_cell_bg_self)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_cell_bg_self.lyt = lyt
	self:addChild(spr_cell_bg_self)
	self.spr_cell_bg_self = spr_cell_bg_self

	local menu_item = require('src.comp.menu.UIMenuEx'):create()
	menu_item:setPosition(180, 22)
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
	node_rank:setPosition(60, 105)
	node_rank:setContentSize(0, 0)
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

	local node_player = cc.Node:create()
	node_player:setPosition(100, 50)
	node_player:setContentSize(0, 0)
	self:addChild(node_player)
	self.node_player = node_player

	local spr_border = cc.Sprite:create()
	spr_border:setPosition(60, 0)
	spr_border:setContentSize(138, 138)
	spr_border:setScale(0.75, 0.75)
	self:addLoadRes(2, spr_border, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/1005017.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_border)
	self:addLyt(lyt)
	spr_border.lyt = lyt
	node_player:addChild(spr_border)
	self.spr_border = spr_border

	local spr_photo = cc.Sprite:create()
	spr_photo:setPosition(60, 0)
	spr_photo:setContentSize(91, 91)
	spr_photo:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_photo, "ccbi-res/head-icon-1.plist", "ccbi-res/head-icon-1.pvr.ccz", "head-icon/0.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_photo)
	self:addLyt(lyt)
	spr_photo.lyt = lyt
	node_player:addChild(spr_photo)
	self.spr_photo = spr_photo

	local lbl_server = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_server:setPosition(120, 20)
	lbl_server:setContentSize(26.3, 27.72)
	lbl_server:setAnchorPoint(cc.p(0, 0.5))
	lbl_server:setTextColor(cc.c3b(122, 71, 45))
	lbl_server:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_server:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_player:addChild(lbl_server)
	self.lbl_server = lbl_server

	local lbl_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_name:setPosition(120, -20)
	lbl_name:setContentSize(26.3, 27.72)
	lbl_name:setAnchorPoint(cc.p(0, 0.5))
	lbl_name:setTextColor(cc.c3b(122, 71, 45))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_player:addChild(lbl_name)
	self.lbl_name = lbl_name

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
	node_player:addChild(menu)
	self.menu = menu

	local btn_photo = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_photo:setPosition(60, 0)
	btn_photo:setContentSize(32, 37)
	btn_photo:registerScriptTapHandler(handler(self, self.onPhoto))
	menu:addChild(btn_photo)
	self.btn_photo = btn_photo

	local node_info = cc.Node:create()
	node_info:setPosition(360, 50)
	node_info:setContentSize(0, 0)
	self:addChild(node_info)
	self.node_info = node_info

	local lbl_round = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_round:setPosition(0, 20)
	lbl_round:setContentSize(23.91, 25.2)
	lbl_round:setAnchorPoint(cc.p(0, 0.5))
	lbl_round:setTextColor(cc.c3b(194, 101, 39))
	lbl_round:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_round:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_info:addChild(lbl_round)
	self.lbl_round = lbl_round

	local lbl_hero = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_hero:setPosition(0, -20)
	lbl_hero:setContentSize(23.91, 25.2)
	lbl_hero:setAnchorPoint(cc.p(0, 0.5))
	lbl_hero:setTextColor(cc.c3b(194, 101, 39))
	lbl_hero:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_hero:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_info:addChild(lbl_hero)
	self.lbl_hero = lbl_hero

	 self:startLoadRes()
end
return AliceRankCell