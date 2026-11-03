local AliceShopCell = class("AliceShopCell", require("src.comp.CCCLayerBase")) 

function AliceShopCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(180, 240)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local spr_cell_bg = cc.Scale9Sprite:create()
	spr_cell_bg:setPosition(90, 120)
	spr_cell_bg:setContentSize(180, 240)
	self:addLoadRes(1, spr_cell_bg, "ccbi-res/shop.plist", "ccbi-res/shop.pvr.ccz", {frame = "shop/shop_7.png", capInsets = cc.rect(0,0,0,0)})
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

	local lbl_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_name:setPosition(90, 215)
	lbl_name:setContentSize(30.3, 31.72)
	lbl_name:setTextColor(cc.c3b(253, 224, 177))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name:enableOutline(cc.c4b(0,0,0,255), 2)
	self:addChild(lbl_name)
	self.lbl_name = lbl_name

	local menu_item = require('src.comp.menu.UIMenuEx'):create()
	menu_item:setPosition(0, 0)
	menu_item:setContentSize(0, 0)
	menu_item:setAnchorPoint(cc.p(0, 0))
	menu_item:setSwallowsTouches(false)
	self:addChild(menu_item)
	self.menu_item = menu_item

	local btn_item = require("src.comp.menu.UIMenuItemBag"):createWithData(0, 0)
	btn_item:setPosition(90, 140)
	btn_item:setScale(0.8, 0.8)
	btn_item:registerScriptTapHandler(handler(self, self.onItemInfo))
	menu_item:addChild(btn_item)
	self.btn_item = btn_item

	local btn_buy = cpp.UIMenuItemLabel:create("", nil, "--", nil)
	btn_buy:setPosition(90, 70)
	btn_buy:setContentSize(134, 56)
	btn_buy:setScale(0.75, 0.75)
	btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
	btn_buy:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_buy:setLabelOffset(cc.p(18, -2))
	btn_buy:setLabelSize(44)
	btn_buy:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	self:addLoadRes(3, btn_buy, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-old-1.png"})
	menu_item:addChild(btn_buy)
	self.btn_buy = btn_buy

	local lbl_limit = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_limit:setPosition(90, 30)
	lbl_limit:setContentSize(25.52, 26.68)
	lbl_limit:setTextColor(cc.c3b(129, 238, 253))
	lbl_limit:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_limit:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_limit:enableOutline(cc.c4b(0,0,0,255), 2)
	self:addChild(lbl_limit)
	self.lbl_limit = lbl_limit

	local lbl_tip = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_tip:setPosition(90, 30)
	lbl_tip:setContentSize(25.52, 26.68)
	lbl_tip:setTextColor(cc.c3b(255, 64, 64))
	lbl_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_tip:enableOutline(cc.c4b(0,0,0,255), 2)
	self:addChild(lbl_tip)
	self.lbl_tip = lbl_tip

	local spr_sell_out = cc.Sprite:create()
	spr_sell_out:setPosition(90, 140)
	spr_sell_out:setContentSize(80, 58)
	spr_sell_out:setVisible(false)
	self:addLoadRes(2, spr_sell_out, "ccbi-res/backpack.plist", "ccbi-res/backpack.pvr.ccz", "backpack/spr-sold-out.png")
	self:addChild(spr_sell_out)
	self.spr_sell_out = spr_sell_out

	 self:startLoadRes()
end
return AliceShopCell