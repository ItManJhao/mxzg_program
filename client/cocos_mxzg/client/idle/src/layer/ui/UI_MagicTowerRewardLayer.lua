local MagicTowerRewardLayer = class("MagicTowerRewardLayer", require("src.comp.CCCLayerBase")) 

function MagicTowerRewardLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 1060)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(620, 1060)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-11.png", capInsets = cc.rect(58,64,56,71)})
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
	spr_content_bg:setPosition(30, 50)
	spr_content_bg:setContentSize(560, 890)
	spr_content_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_content_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-26.png", capInsets = cc.rect(9,9,9,9)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_content_bg)
	lyt:setLeftMargin(30)
	lyt:setRightMargin(30)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(120)
	lyt:setBottomMargin(50)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_content_bg.lyt = lyt
	self:addChild(spr_content_bg)
	self.spr_content_bg = spr_content_bg

	local node_title = cc.Node:create()
	node_title:setCascadeOpacityEnabled(true)
	node_title:setPosition(310, 1060)
	node_title:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_title.lyt = lyt
	self:addChild(node_title)
	self.node_title = node_title

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(0, 0)
	spr_title_bg:setContentSize(184, 67)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/title-bar-3.png", capInsets = cc.rect(0,0,0,0)})
	node_title:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57533),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -40)
	lbl_title:setContentSize(228, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(545, 1060)
	menu:setContentSize(0, 0)
	menu:setSwallowsTouches(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setRightMargin(75)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(-1, 0)
	btn_close:setContentSize(55, 58)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_close)
	lyt:setRightMargin(-26.5)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_close.lyt = lyt
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(-1, -91)
	btn_info:setContentSize(60, 61)
	btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png", spr2="button/btn-info-2.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_info)
	lyt:setRightMargin(-29)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(60.5)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_info.lyt = lyt
	menu:addChild(btn_info)
	self.btn_info = btn_info

	local menu_tab = cpp.UIMenu:create()
	menu_tab:setCascadeOpacityEnabled(true)
	menu_tab:setPosition(310, 960)
	menu_tab:setContentSize(0, 0)
	menu_tab:setSwallowsTouches(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu_tab)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(100)
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
	btn_tab_1:setLabelText(ex.Tools:getLang(57521))
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
	btn_tab_2:setLabelText(ex.Tools:getLang(57522))
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
	scroll_view:setPosition(310, 55)
	scroll_view:setContentSize(550, 675)
	scroll_view:setAnchorPoint(cc.p(0.5, 0))
	scroll_view:setIgnoreAnchorPointForPosition(false)
	scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_view:setItemType(1)
	scroll_view:setItemSize(cc.size(550, 160))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(scroll_view)
	lyt:setLeftMargin(35)
	lyt:setRightMargin(35)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(330)
	lyt:setBottomMargin(55)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	scroll_view.lyt = lyt
	self:addChild(scroll_view)
	self.scroll_view = scroll_view

	local spr_banner = cc.Sprite:create()
	spr_banner:setPosition(310, 935)
	spr_banner:setContentSize(552, 202)
	spr_banner:setAnchorPoint(cc.p(0.5, 1))
	self:addChild(spr_banner)
	self.spr_banner = spr_banner

	local node_banner = cc.Node:create()
	node_banner:setCascadeOpacityEnabled(true)
	node_banner:setPosition(310, 935)
	node_banner:setContentSize(0, 0)
	self:addChild(node_banner)
	self.node_banner = node_banner

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	node_banner:addChild(menu)
	self.menu = menu

	local btn_buy = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_buy:setPosition(-157.96, -161.76)
	btn_buy:setContentSize(196, 66)
	btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
	btn_buy:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_buy:setLabelOffset(cc.p(0, -2))
	btn_buy:setLabelSize(48)
	btn_buy:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_buy:setLabelText(ex.Tools:getLang(57524))
	self:addLoadRes(3, btn_buy, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-buy-4.png"})
	menu:addChild(btn_buy)
	self.btn_buy = btn_buy

	local node_king = cc.Node:create()
	node_king:setCascadeOpacityEnabled(true)
	node_king:setPosition(0, 0)
	node_king:setContentSize(0, 0)
	node_banner:addChild(node_king)
	self.node_king = node_king

	local spr_star_bg = cc.Scale9Sprite:create()
	spr_star_bg:setPosition(200, -170)
	spr_star_bg:setContentSize(200, 42)
	spr_star_bg:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(1, spr_star_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-messageview.png", capInsets = cc.rect(0,0,0,0)})
	node_king:addChild(spr_star_bg)
	self.spr_star_bg = spr_star_bg

	local lbl_star_title = cc.Label:createWithTTF(ex.Tools:getLang(57526),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_star_title:setPosition(115, -170)
	lbl_star_title:setContentSize(26.3, 27.72)
	lbl_star_title:setAnchorPoint(cc.p(1, 0.5))
	lbl_star_title:setTextColor(cc.c3b(255, 255, 255))
	lbl_star_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_star_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_king:addChild(lbl_star_title)
	self.lbl_star_title = lbl_star_title

	local lbl_star = cc.Label:createWithTTF("99999",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_star:setPosition(120, -170)
	lbl_star:setContentSize(62.73, 27.72)
	lbl_star:setAnchorPoint(cc.p(0, 0.5))
	lbl_star:setTextColor(cc.c3b(6, 225, 6))
	lbl_star:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_star:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_king:addChild(lbl_star)
	self.lbl_star = lbl_star

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(0, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	node_king:addChild(menu)
	self.menu = menu

	local btn_go = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_go:setPosition(224.57, -157.96)
	btn_go:setContentSize(78, 64)
	btn_go:registerScriptTapHandler(handler(self, self.onGo))
	btn_go:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_go:setLabelOffset(cc.p(0, -2))
	btn_go:setLabelSize(48)
	btn_go:setLabelOutLine(cc.c4b(0,6,146,255), 4)
	btn_go:setLabelText(ex.Tools:getLang(57525))
	self:addLoadRes(3, btn_go, "ccbi-res/magic-tower.plist", "ccbi-res/magic-tower.pvr.ccz", {spr1="magic-tower/btn-go.png"})
	menu:addChild(btn_go)
	self.btn_go = btn_go

	 self:startLoadRes()
end
return MagicTowerRewardLayer