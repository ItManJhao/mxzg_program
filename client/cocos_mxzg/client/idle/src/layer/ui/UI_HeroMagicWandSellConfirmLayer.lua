local HeroMagicWandSellConfirmLayer = class("HeroMagicWandSellConfirmLayer", require("src.comp.CCCLayerBase")) 

function HeroMagicWandSellConfirmLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(585, 480)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(585, 480)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-24.png", capInsets = cc.rect(25,30,25,29)})
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local node_title = cc.Node:create()
	node_title:setPosition(293, 476.64)
	node_title:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title)
	lyt:setTopMargin(3.36)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_title.lyt = lyt
	self:addChild(node_title)
	self.node_title = node_title

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(0, 0)
	spr_title_bg:setContentSize(225, 72)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/title-bar-4.png", capInsets = cc.rect(0,0,0,0)})
	node_title:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57102),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -48.18)
	lbl_title:setContentSize(116, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	self:addChild(menu)
	self.menu = menu

	local btn_cancel = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_cancel:setPosition(172, 52.78)
	btn_cancel:setContentSize(134, 56)
	btn_cancel:registerScriptTapHandler(handler(self, self.onClose))
	btn_cancel:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_cancel:setLabelOffset(cc.p(0, 0))
	btn_cancel:setLabelSize(40)
	btn_cancel:setLabelText(ex.Tools:getLang(72019))
	self:addLoadRes(3, btn_cancel, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_cancel)
	self.btn_cancel = btn_cancel

	local btn_confirm = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_confirm:setPosition(414, 52.78)
	btn_confirm:setContentSize(134, 56)
	btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
	btn_confirm:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_confirm:setLabelOffset(cc.p(0, 0))
	btn_confirm:setLabelSize(40)
	btn_confirm:setLabelText(ex.Tools:getLang(47584))
	self:addLoadRes(3, btn_confirm, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-big-1.png"})
	menu:addChild(btn_confirm)
	self.btn_confirm = btn_confirm

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(525.38, 480.16)
	btn_close:setContentSize(53, 56)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local node_desc = cc.Node:create()
	node_desc:setPosition(292.5, 340)
	node_desc:setContentSize(530, 100)
	node_desc:setAnchorPoint(cc.p(0.5, 0.5))
	node_desc:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_desc)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	node_desc.lyt = lyt
	self:addChild(node_desc)
	self.node_desc = node_desc

	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(292.5, 190)
	spr_bg:setContentSize(550, 168)
	spr_bg:setOpacity(100)
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-26.png", capInsets = cc.rect(9,9,9,9)})
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	scroll_view:setPosition(292.5, 190)
	scroll_view:setContentSize(545, 160)
	scroll_view:setAnchorPoint(cc.p(0.5, 0.5))
	scroll_view:setIgnoreAnchorPointForPosition(false)
	scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_view:setItemSize(cc.size(120, 120))
	self:addChild(scroll_view)
	self.scroll_view = scroll_view

	 self:startLoadRes()
end
return HeroMagicWandSellConfirmLayer