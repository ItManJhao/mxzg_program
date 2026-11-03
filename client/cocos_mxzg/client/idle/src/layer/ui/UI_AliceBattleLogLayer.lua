local AliceBattleLogLayer = class("AliceBattleLogLayer", require("src.comp.CCCLayerBase")) 

function AliceBattleLogLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(560, 900)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(560, 900)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-2.png", capInsets = cc.rect(10,10,10,10)})
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

	local node_buff_enermy = cc.Node:create()
	node_buff_enermy:setCascadeOpacityEnabled(true)
	node_buff_enermy:setPosition(280, 880)
	node_buff_enermy:setContentSize(500, 220)
	node_buff_enermy:setAnchorPoint(cc.p(0.5, 1))
	node_buff_enermy:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_buff_enermy)
	lyt:setTopMargin(20)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_buff_enermy.lyt = lyt
	self:addChild(node_buff_enermy)
	self.node_buff_enermy = node_buff_enermy

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(250, 220)
	spr_title_bg:setContentSize(500, 42)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-8.png", capInsets = cc.rect(10,10,10,10)})
	node_buff_enermy:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580076),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(250, 196)
	lbl_title:setContentSize(26.3, 27.72)
	lbl_title:setTextColor(cc.c3b(230, 199, 152))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_buff_enermy:addChild(lbl_title)
	self.lbl_title = lbl_title

	local node_buff_self = cc.Node:create()
	node_buff_self:setCascadeOpacityEnabled(true)
	node_buff_self:setPosition(280, 650)
	node_buff_self:setContentSize(500, 240)
	node_buff_self:setAnchorPoint(cc.p(0.5, 1))
	node_buff_self:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_buff_self)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(250)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_buff_self.lyt = lyt
	self:addChild(node_buff_self)
	self.node_buff_self = node_buff_self

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(250, 240)
	spr_title_bg:setContentSize(500, 42)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-8.png", capInsets = cc.rect(10,10,10,10)})
	node_buff_self:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580077),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(250, 216)
	lbl_title:setContentSize(26.3, 27.72)
	lbl_title:setTextColor(cc.c3b(230, 199, 152))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_buff_self:addChild(lbl_title)
	self.lbl_title = lbl_title

	local node_hero_list = cc.Node:create()
	node_hero_list:setCascadeOpacityEnabled(true)
	node_hero_list:setPosition(280, 400)
	node_hero_list:setContentSize(500, 380)
	node_hero_list:setAnchorPoint(cc.p(0.5, 1))
	node_hero_list:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_hero_list)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(500)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_hero_list.lyt = lyt
	self:addChild(node_hero_list)
	self.node_hero_list = node_hero_list

	local spr_title_bg = cc.Scale9Sprite:create()
	spr_title_bg:setPosition(250, 380)
	spr_title_bg:setContentSize(500, 42)
	spr_title_bg:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_title_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-8.png", capInsets = cc.rect(10,10,10,10)})
	node_hero_list:addChild(spr_title_bg)
	self.spr_title_bg = spr_title_bg

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(580078),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(250, 356)
	lbl_title:setContentSize(26.3, 27.72)
	lbl_title:setTextColor(cc.c3b(230, 199, 152))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_hero_list:addChild(lbl_title)
	self.lbl_title = lbl_title

	local scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	scroll_view:setPosition(250, 330)
	scroll_view:setContentSize(520, 330)
	scroll_view:setAnchorPoint(cc.p(0.5, 1))
	scroll_view:setIgnoreAnchorPointForPosition(false)
	scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_view:setItemType(1)
	scroll_view:setItemSize(cc.size(510, 120))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(scroll_view)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(50)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	scroll_view.lyt = lyt
	node_hero_list:addChild(scroll_view)
	self.scroll_view = scroll_view

	local menu = cpp.UIMenu:create()
	menu:setCascadeOpacityEnabled(true)
	menu:setPosition(525, 900)
	menu:setContentSize(0, 0)
	menu:setSwallowsTouches(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setRightMargin(35)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(0, 0)
	btn_close:setContentSize(55, 58)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(btn_close)
	lyt:setRightMargin(-27.5)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(0)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	btn_close.lyt = lyt
	menu:addChild(btn_close)
	self.btn_close = btn_close

	 self:startLoadRes()
end
return AliceBattleLogLayer