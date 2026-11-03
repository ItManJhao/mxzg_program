local PermanentSkinCell = class("PermanentSkinCell", require("src.comp.CCCLayerBase")) 

function PermanentSkinCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(190, 263)
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:setIgnoreAnchorPointForPosition(false)
	local node_1 = cc.Node:create()
	node_1:setPosition(95, 131.5)
	node_1:setContentSize(190, 263)
	node_1:setAnchorPoint(cc.p(0.5, 0.5))
	node_1:setIgnoreAnchorPointForPosition(false)
	self:addChild(node_1)
	self.node_1 = node_1

	local btn_skin = cc.Sprite:create()
	btn_skin:setPosition(95, 131.5)
	btn_skin:setContentSize(190, 263)
	node_1:addChild(btn_skin)
	self.btn_skin = btn_skin

	local spr_item_bg = cc.Sprite:create()
	spr_item_bg:setPosition(95, 89.5)
	spr_item_bg:setContentSize(178, 82)
	self:addLoadRes(2, spr_item_bg, "ccbi-res/permanent-skin.plist", "ccbi-res/permanent-skin.pvr.ccz", "permanent-skin/spr-item-bg.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_item_bg)
	lyt:setLeftMargin(6)
	lyt:setRightMargin(6)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setBottomMargin(48.5)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	spr_item_bg.lyt = lyt
	node_1:addChild(spr_item_bg)
	self.spr_item_bg = spr_item_bg

	local skin_name = cc.Label:createWithTTF("英雄皮肤",FONT_DEFAULT_NAME_BOLD, 16)
	skin_name:setPosition(89, 14.84)
	skin_name:setContentSize(68, 24.16)
	skin_name:setTextColor(cc.c3b(255, 255, 255))
	skin_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	skin_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	skin_name:enableOutline(cc.c4b(0,0,0,255), 2)
	spr_item_bg:addChild(skin_name)
	self.skin_name = skin_name

	local spr_permanent = cc.Sprite:create()
	spr_permanent:setPosition(148.93, 230)
	spr_permanent:setContentSize(76, 66)
	self:addLoadRes(2, spr_permanent, "ccbi-res/promotion.plist", "ccbi-res/promotion.pvr.ccz", "promotion/spr-permanent.png")
	self:addChild(spr_permanent)
	self.spr_permanent = spr_permanent

	local item_scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	item_scroll_view:setPosition(95, 79.79)
	item_scroll_view:setContentSize(170, 50)
	item_scroll_view:setAnchorPoint(cc.p(0.5, 0))
	item_scroll_view:setIgnoreAnchorPointForPosition(false)
	item_scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
	item_scroll_view:setItemType(1)
	item_scroll_view:setItemSize(cc.size(50, 40))
	self:addChild(item_scroll_view)
	self.item_scroll_view = item_scroll_view

	local btn_buy_menu = require('src.comp.menu.UIMenuEx'):create()
	btn_buy_menu:setPosition(95, 31.5)
	btn_buy_menu:setContentSize(0, 0)
	btn_buy_menu:setAnchorPoint(cc.p(0.5, 0.5))
	btn_buy_menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_buy_menu)
	lyt:setLeftMargin(95)
	lyt:setRightMargin(95)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setBottomMargin(31.5)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	btn_buy_menu.lyt = lyt
	self:addChild(btn_buy_menu)
	self.btn_buy_menu = btn_buy_menu

	local btn_buy = cpp.UIMenuItemLabel:create("", nil, "--", nil)
	btn_buy:setPosition(0, 0)
	btn_buy:setContentSize(176, 36)
	btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
	btn_buy:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_buy:setLabelOffset(cc.p(0, -2))
	btn_buy:setLabelSize(44)
	btn_buy:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	self:addLoadRes(3, btn_buy, "ccbi-res/permanent-skin.plist", "ccbi-res/permanent-skin.pvr.ccz", {spr1="permanent-skin/btn-buy.png", spr3="permanent-skin/btn-buy-disabled.png"})
	btn_buy_menu:addChild(btn_buy)
	self.btn_buy = btn_buy

	 self:startLoadRes()
end
return PermanentSkinCell