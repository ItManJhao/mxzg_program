local HeroListHeroLayer = class("HeroListHeroLayer", require("src.comp.CCCLayerBase")) 

function HeroListHeroLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(640, 836)
	self:setAnchorPoint(cc.p(0, 0))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(self)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(300)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	self.lyt = lyt
	local spr_box = cc.Scale9Sprite:create()
	spr_box:setPosition(320, 702)
	spr_box:setContentSize(581.84, 568.93)
	spr_box:setScale(1, 1.01)
	spr_box:setAnchorPoint(cc.p(0.5, 1))
	self:addLoadRes(1, spr_box, "ccbi-res/hero-info.plist", "ccbi-res/hero-info.pvr.ccz", {frame = "hero-info/spr-hero-image-3.png", capInsets = cc.rect(20,50,538,628)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(spr_box)
	lyt:setLeftMargin(30)
	lyt:setRightMargin(30)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(134)
	lyt:setBottomMargin(130)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	spr_box.lyt = lyt
	self:addChild(spr_box)
	self.spr_box = spr_box

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(320, 46.71)
	CCSprite:setContentSize(447, 36)
	self:addLoadRes(2, CCSprite, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "win-bg/spr-pattern-bottom.png")
	local lyt = ccui.LayoutComponent:bindLayoutComponent(CCSprite)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setBottomMargin(28.71)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	CCSprite.lyt = lyt
	self:addChild(CCSprite)

	local node_elem = cc.Node:create()
	node_elem:setPosition(320, 692.28)
	node_elem:setContentSize(0, 0)
	node_elem:setAnchorPoint(cc.p(0, 0))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_elem)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(143.72)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	node_elem.lyt = lyt
	self:addChild(node_elem)
	self.node_elem = node_elem

	local elem_menu = cpp.UIMenu:create()
	elem_menu:setPosition(0, 0)
	elem_menu:setContentSize(100, 1)
	elem_menu:setAnchorPoint(cc.p(0, 0))
	node_elem:addChild(elem_menu)
	self.elem_menu = elem_menu

	local btn_elem0 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem0:setPosition(-210, -34)
	btn_elem0:setContentSize(74, 72)
	btn_elem0:setScale(0.8, 0.8)
	self:addLoadRes(3, btn_elem0, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-0.png", spr2="hero-icon/elem-0.png"})
	elem_menu:addChild(btn_elem0)
	self.btn_elem0 = btn_elem0

	local btn_elem1 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem1:setPosition(-126, -34)
	btn_elem1:setContentSize(74, 72)
	btn_elem1:setScale(0.8, 0.8)
	self:addLoadRes(3, btn_elem1, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-1.png", spr2="hero-icon/elem-1.png"})
	elem_menu:addChild(btn_elem1)
	self.btn_elem1 = btn_elem1

	local btn_elem2 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem2:setPosition(-42, -34)
	btn_elem2:setContentSize(74, 72)
	btn_elem2:setScale(0.8, 0.8)
	btn_elem2:setAnchorPoint(cc.p(0.5, 0.5))
	self:addLoadRes(3, btn_elem2, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-2.png", spr2="hero-icon/elem-2.png"})
	elem_menu:addChild(btn_elem2)
	self.btn_elem2 = btn_elem2

	local btn_elem3 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem3:setPosition(42, -34)
	btn_elem3:setContentSize(74, 72)
	btn_elem3:setScale(0.8, 0.8)
	self:addLoadRes(3, btn_elem3, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-3.png", spr2="hero-icon/elem-3.png"})
	elem_menu:addChild(btn_elem3)
	self.btn_elem3 = btn_elem3

	local btn_elem4 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem4:setPosition(126, -34)
	btn_elem4:setContentSize(74, 72)
	btn_elem4:setScale(0.8, 0.8)
	self:addLoadRes(3, btn_elem4, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-4.png", spr2="hero-icon/elem-4.png"})
	elem_menu:addChild(btn_elem4)
	self.btn_elem4 = btn_elem4

	local btn_elem5 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_elem5:setPosition(210, -34)
	btn_elem5:setContentSize(74, 72)
	btn_elem5:setScale(0.8, 0.8)
	self:addLoadRes(3, btn_elem5, "ccbi-res/hero-icon-other.plist", "ccbi-res/hero-icon-other.pvr.ccz", {spr1="hero-icon/elem-5.png", spr2="hero-icon/elem-5.png"})
	elem_menu:addChild(btn_elem5)
	self.btn_elem5 = btn_elem5

	local node_capacity = cc.Node:create()
	node_capacity:setPosition(640, 0)
	node_capacity:setContentSize(0, 0)
	node_capacity:setAnchorPoint(cc.p(0, 0))
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_capacity)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(2)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_capacity.lyt = lyt
	self:addChild(node_capacity)
	self.node_capacity = node_capacity

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(-138.86, 72.71)
	CCSprite:setContentSize(159, 34)
	self:addLoadRes(2, CCSprite, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", "win-bg/block-bg-27.png")
	node_capacity:addChild(CCSprite)

	local lbl_capacity = cc.Label:createWithTTF("空间：20/40",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_capacity:setPosition(-138.86, 70.71)
	lbl_capacity:setContentSize(111.17, 25.2)
	lbl_capacity:setTextColor(cc.c3b(255, 230, 182))
	lbl_capacity:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_capacity:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_capacity:addChild(lbl_capacity)
	self.lbl_capacity = lbl_capacity

	local bottom_menu = cpp.UIMenu:create()
	bottom_menu:setPosition(0, 0)
	bottom_menu:setContentSize(100, 100)
	bottom_menu:setAnchorPoint(cc.p(0, 0))
	self:addChild(bottom_menu)
	self.bottom_menu = bottom_menu

	local btn_evolve = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_evolve:setPosition(129.46, 76.5)
	btn_evolve:setContentSize(178, 69)
	self:addLoadRes(3, btn_evolve, "ccbi-res/hero-info-lang.plist", "ccbi-res/hero-info-lang.pvr.ccz", {spr1="hero-info-lang/spr-evolve.png", spr2="hero-info-lang/spr-evolve.png"})
	bottom_menu:addChild(btn_evolve)
	self.btn_evolve = btn_evolve

	local scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	scroll_view:setPosition(320, 378)
	scroll_view:setContentSize(560, 486)
	scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_view:setItemSize(cc.size(119, 126))
	scroll_view:setItemOffset(cc.p(0, 5))
	scroll_view:setAutoOffset(true)
	scroll_view:setAutoScale(true)
	scroll_view:setAutoFull(true)
	scroll_view:setCreateNum(4)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(scroll_view)
	lyt:setLeftMargin(40)
	lyt:setRightMargin(40)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(215)
	lyt:setBottomMargin(135)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	scroll_view.lyt = lyt
	self:addChild(scroll_view)
	self.scroll_view = scroll_view

	 self:startLoadRes()
end
return HeroListHeroLayer