local HeroResetLifeLayer = class("HeroResetLifeLayer", require("src.comp.CCCLayerBase")) 

function HeroResetLifeLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(560, 925)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	self:setCascadeOpacityEnabled(true)
	self:setOpacity(0)
	self:runEnterAnim()
	local s = cc.Scale9Sprite:create()
	s:setPosition(0, 0)
	s:setContentSize(560, 925)
	s:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, s, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/win-bg-11.png", capInsets = cc.rect(58,64,56,71)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(s)
	lyt:setLeftMargin(0)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(0)
	lyt:setBottomMargin(0)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	s.lyt = lyt
	self:addChild(s)
	self.s = s

	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(280, 463)
	spr_bg:setContentSize(500, 580)
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-5.png", capInsets = cc.rect(9,10,9,10)})
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local spr_bg_1 = cc.Scale9Sprite:create()
	spr_bg_1:setPosition(280, 360)
	spr_bg_1:setContentSize(481, 355)
	self:addLoadRes(1, spr_bg_1, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-9.png", capInsets = cc.rect(16,16,14,13)})
	self:addChild(spr_bg_1)
	self.spr_bg_1 = spr_bg_1

	local node_title = cc.Node:create()
	node_title:setCascadeOpacityEnabled(true)
	node_title:setPosition(280, 915)
	node_title:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(10)
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

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(47511),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -48.18)
	lbl_title:setContentSize(116, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local lbl_show_node = cc.Node:create()
	lbl_show_node:setPosition(280, 580)
	lbl_show_node:setContentSize(0, 0)
	self:addChild(lbl_show_node)
	self.lbl_show_node = lbl_show_node

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setCascadeOpacityEnabled(true)
	UIMenu:setPosition(0, 0)
	UIMenu:setContentSize(0, 0)
	self:addChild(UIMenu)

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(500, 920)
	btn_close:setContentSize(53, 56)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	UIMenu:addChild(btn_close)
	self.btn_close = btn_close

	local btn_lv_reset = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_lv_reset:setPosition(205, 774)
	btn_lv_reset:setContentSize(136, 42)
	btn_lv_reset:setTag(1)
	btn_lv_reset:registerScriptTapHandler(handler(self, self.onChangeLayer))
	btn_lv_reset:getLabel():setTextColor(cc.c4b(120, 64, 8, 255))
	btn_lv_reset:setLabelOffset(cc.p(0, -2))
	btn_lv_reset:setLabelText(ex.Tools:getLang(70507))
	local l = btn_lv_reset:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_lv_reset, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-3.png", spr2="button/btn-tab-4.png"})
	UIMenu:addChild(btn_lv_reset)
	self.btn_lv_reset = btn_lv_reset

	local btn_star_reset = cpp.UIMenuItemTab:create("", nil, "--", 1, 1)
	btn_star_reset:setPosition(355, 774.1)
	btn_star_reset:setContentSize(136, 42)
	btn_star_reset:setTag(2)
	btn_star_reset:registerScriptTapHandler(handler(self, self.onChangeLayer))
	btn_star_reset:getLabel():setTextColor(cc.c4b(120, 64, 8, 255))
	btn_star_reset:setLabelOffset(cc.p(0, 0))
	btn_star_reset:setLabelText(ex.Tools:getLang(70511))
	local l = btn_star_reset:getLabel()
	if l then
		local t = l:getTTFConfig()
		t.fontSize = 44
		l:setTTFConfig(t)
	end
	self:addLoadRes(3, btn_star_reset, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-tab-3.png", spr2="button/btn-tab-4.png"})
	UIMenu:addChild(btn_star_reset)
	self.btn_star_reset = btn_star_reset

	local btn_level = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_level:setPosition(280, 74.24)
	btn_level:setContentSize(100, 42)
	btn_level:registerScriptTapHandler(handler(self, self.onLevelConfirm))
	btn_level:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_level:setLabelOffset(cc.p(0, -2))
	btn_level:setLabelSize(44)
	btn_level:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_level:setLabelText(ex.Tools:getLang(11))
	self:addLoadRes(3, btn_level, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-1.png"})
	UIMenu:addChild(btn_level)
	self.btn_level = btn_level

	local btn_star = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_star:setPosition(280, 74.24)
	btn_star:setContentSize(100, 42)
	btn_star:registerScriptTapHandler(handler(self, self.onStarConfirm))
	btn_star:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_star:setLabelOffset(cc.p(0, -2))
	btn_star:setLabelSize(44)
	btn_star:setLabelOutLine(cc.c4b(0,0,0,255), 4)
	btn_star:setLabelText(ex.Tools:getLang(11))
	self:addLoadRes(3, btn_star, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-1.png"})
	UIMenu:addChild(btn_star)
	self.btn_star = btn_star

	local lbl_resets_num = cc.Label:createWithTTF("今天剩余重生次数：3",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_resets_num:setPosition(280, 120)
	lbl_resets_num:setContentSize(210.55, 37.8)
	lbl_resets_num:setTextColor(cc.c3b(120, 64, 8))
	lbl_resets_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_resets_num)
	self.lbl_resets_num = lbl_resets_num

	local node_res_need_1 = cc.Node:create()
	node_res_need_1:setCascadeOpacityEnabled(true)
	node_res_need_1:setPosition(280, 120)
	node_res_need_1:setContentSize(145, 37)
	node_res_need_1:setAnchorPoint(cc.p(0.5, 0.5))
	node_res_need_1:setIgnoreAnchorPointForPosition(false)
	node_res_need_1:setVisible(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_res_need_1)
	lyt:setLeftMargin(207.5)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(101.5)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_res_need_1.lyt = lyt
	self:addChild(node_res_need_1)
	self.node_res_need_1 = node_res_need_1

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(72.5, 18.5)
	CCSprite:setContentSize(145, 37)
	self:addLoadRes(2, CCSprite, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-res-bg.png")
	node_res_need_1:addChild(CCSprite)

	local spr_res_need_1 = cc.Sprite:create()
	spr_res_need_1:setPosition(17.5, 18.5)
	spr_res_need_1:setContentSize(62, 84)
	spr_res_need_1:setScale(0.5, 0.5)
	self:addLoadRes(2, spr_res_need_1, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/900002.png")
	node_res_need_1:addChild(spr_res_need_1)
	self.spr_res_need_1 = spr_res_need_1

	local lbl_res_need_1 = cc.Label:createWithTTF("1",FONT_DEFAULT_NAME_BOLD, 44)
	lbl_res_need_1:setPosition(72.5, 18.5)
	lbl_res_need_1:setContentSize(25.09, 55.44)
	lbl_res_need_1:setScale(0.5, 0.5)
	lbl_res_need_1:setTextColor(cc.c3b(253, 252, 224))
	lbl_res_need_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_res_need_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_res_need_1:addChild(lbl_res_need_1)
	self.lbl_res_need_1 = lbl_res_need_1

	local star_item_need_node = cc.Node:create()
	star_item_need_node:setCascadeOpacityEnabled(true)
	star_item_need_node:setPosition(280, 120)
	star_item_need_node:setContentSize(145, 37)
	star_item_need_node:setAnchorPoint(cc.p(0.5, 0.5))
	star_item_need_node:setIgnoreAnchorPointForPosition(false)
	star_item_need_node:setVisible(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(star_item_need_node)
	lyt:setLeftMargin(207.5)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(101.5)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	star_item_need_node.lyt = lyt
	self:addChild(star_item_need_node)
	self.star_item_need_node = star_item_need_node

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(72.5, 18.5)
	CCSprite:setContentSize(145, 37)
	self:addLoadRes(2, CCSprite, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-res-bg.png")
	star_item_need_node:addChild(CCSprite)

	local star_spr_res_need_1 = cc.Sprite:create()
	star_spr_res_need_1:setPosition(17.5, 18.5)
	star_spr_res_need_1:setContentSize(62, 84)
	star_spr_res_need_1:setScale(0.5, 0.5)
	self:addLoadRes(2, star_spr_res_need_1, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/900002.png")
	star_item_need_node:addChild(star_spr_res_need_1)
	self.star_spr_res_need_1 = star_spr_res_need_1

	local satr_lbl_res_need_1 = cc.Label:createWithTTF("1",FONT_DEFAULT_NAME_BOLD, 44)
	satr_lbl_res_need_1:setPosition(72.5, 18.5)
	satr_lbl_res_need_1:setContentSize(25.09, 55.44)
	satr_lbl_res_need_1:setScale(0.5, 0.5)
	satr_lbl_res_need_1:setTextColor(cc.c3b(253, 252, 224))
	satr_lbl_res_need_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	satr_lbl_res_need_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	star_item_need_node:addChild(satr_lbl_res_need_1)
	self.satr_lbl_res_need_1 = satr_lbl_res_need_1

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setCascadeOpacityEnabled(true)
	UIMenu:setPosition(75.5, 18.5)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	star_item_need_node:addChild(UIMenu)

	local UIMenuItemImage = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	UIMenuItemImage:setPosition(53, 0)
	UIMenuItemImage:setContentSize(32, 32)
	UIMenuItemImage:registerScriptTapHandler(handler(self, self.onAddItem))
	self:addLoadRes(3, UIMenuItemImage, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-add-2.png"})
	UIMenu:addChild(UIMenuItemImage)

	local spr_reset_item_node = cc.Node:create()
	spr_reset_item_node:setPosition(160, 670)
	spr_reset_item_node:setContentSize(0, 0)
	self:addChild(spr_reset_item_node)
	self.spr_reset_item_node = spr_reset_item_node

	local spr_arrow = cc.Sprite:create()
	spr_arrow:setPosition(280, 663.64)
	spr_arrow:setContentSize(60, 48)
	self:addLoadRes(2, spr_arrow, "ccbi-res/hero-soul.plist", "ccbi-res/hero-soul.pvr.ccz", "hero-soul/spr-soul-arrow.png")
	self:addChild(spr_arrow)
	self.spr_arrow = spr_arrow

	local spr_reseted_item_node = cc.Node:create()
	spr_reseted_item_node:setPosition(400, 670)
	spr_reseted_item_node:setContentSize(0, 0)
	self:addChild(spr_reseted_item_node)
	self.spr_reseted_item_node = spr_reseted_item_node

	local spr_show_item_node = cc.Node:create()
	spr_show_item_node:setPosition(280, 450)
	spr_show_item_node:setContentSize(0, 0)
	self:addChild(spr_show_item_node)
	self.spr_show_item_node = spr_show_item_node

	local reward_scroll_view = require("src.comp.UIScrollViewItem"):createWithSize(cc.size(0, 0))
	reward_scroll_view:setPosition(45, 200)
	reward_scroll_view:setContentSize(470, 160)
	reward_scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	reward_scroll_view:setItemSize(cc.size(119, 126))
	self:addChild(reward_scroll_view)
	self.reward_scroll_view = reward_scroll_view

	 self:startLoadRes()
end
return HeroResetLifeLayer