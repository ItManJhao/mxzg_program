local MagicTowerShopLayer = class("MagicTowerShopLayer", require("src.comp.CCCLayerBase")) 

function MagicTowerShopLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(640, 850)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(640, 850)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", {frame = "magic-tower/spr-bg-shop.png", capInsets = cc.rect(0,0,0,0)})
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

	local spr_content_bg = cc.Scale9Sprite:create()
	spr_content_bg:setPosition(320, 65)
	spr_content_bg:setContentSize(570, 630)
	spr_content_bg:setAnchorPoint(cc.p(0.5, 0))
	self:addLoadRes(1, spr_content_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-5.png", capInsets = cc.rect(9,10,9,10)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_content_bg)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(155)
	lyt:setBottomMargin(65)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_content_bg.lyt = lyt
	self:addChild(spr_content_bg)
	self.spr_content_bg = spr_content_bg

	local node_title = cc.Node:create()
	node_title:setCascadeOpacityEnabled(true)
	node_title:setPosition(320, 790)
	node_title:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(60)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_title.lyt = lyt
	self:addChild(node_title)
	self.node_title = node_title

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57515),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -15)
	lbl_title:setContentSize(116, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(640, 850)
	menu:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(-50, 0)
	btn_close:setContentSize(92, 92)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-7.png", spr2="button/btn-close-7.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_close)
	lyt:setRightMargin(4)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_close.lyt = lyt
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local menu_tab = cpp.UIMenu:create()
	menu_tab:setCascadeOpacityEnabled(true)
	menu_tab:setPosition(320, 715)
	menu_tab:setContentSize(0, 0)
	menu_tab:setSwallowsTouches(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_tab)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(135)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu_tab.lyt = lyt
	self:addChild(menu_tab)
	self.menu_tab = menu_tab

	local btn_tab_1 = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_tab_1:setPosition(-5, 0)
	btn_tab_1:setContentSize(111, 43)
	btn_tab_1:setAnchorPoint(cc.p(1, 0.5))
	btn_tab_1:setTag(1)
	btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
	btn_tab_1:getLabel():setTextColor(cc.c4b(122, 71, 45, 255))
	btn_tab_1:setLabelOffset(cc.p(0, -2))
	btn_tab_1:setLabelText(ex.Tools:getLang(57516))
	local l = btn_tab_1:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_tab_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-23.png", spr2="button/btn-tab-24.png"})
	menu_tab:addChild(btn_tab_1)
	self.btn_tab_1 = btn_tab_1

	local btn_tab_2 = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_tab_2:setPosition(5, 0)
	btn_tab_2:setContentSize(111, 43)
	btn_tab_2:setAnchorPoint(cc.p(0, 0.5))
	btn_tab_2:setTag(2)
	btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))
	btn_tab_2:getLabel():setTextColor(cc.c4b(122, 71, 45, 255))
	btn_tab_2:setLabelOffset(cc.p(0, -2))
	btn_tab_2:setLabelText(ex.Tools:getLang(57517))
	local l = btn_tab_2:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_tab_2, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-23.png", spr2="button/btn-tab-24.png"})
	menu_tab:addChild(btn_tab_2)
	self.btn_tab_2 = btn_tab_2

	local scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	scroll_view:setPosition(320, 70)
	scroll_view:setContentSize(560, 620)
	scroll_view:setAnchorPoint(cc.p(0.5, 0))
	scroll_view:setIgnoreAnchorPointForPosition(false)
	scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_view:setItemType(1)
	scroll_view:setItemSize(cc.size(180, 240))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(scroll_view)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(160)
	lyt:setBottomMargin(70)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	scroll_view.lyt = lyt
	self:addChild(scroll_view)
	self.scroll_view = scroll_view

	 self:startLoadRes()
end
return MagicTowerShopLayer