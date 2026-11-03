local HeroMagicWandRefineLayer = class("HeroMagicWandRefineLayer", require("src.comp.CCCLayerBase")) 

function HeroMagicWandRefineLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(620, 1020)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	self:addBlackBackground()
	local s = cc.Scale9Sprite:create()
	s:setPosition(0, 0)
	s:setContentSize(620, 1020)
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

	local s = cc.Scale9Sprite:create()
	s:setPosition(310, 556.02)
	s:setContentSize(570, 726)
	self:addLoadRes(1, s, "ccbi-res/hero-magic-wand.plist", "ccbi-res/hero-magic-wand.pvr.ccz", {frame = "hero-magic-wand/bg1.png", capInsets = cc.rect(54,267,57,37)})
	local lyt = ccui.LayoutComponent:bindLayoutComponent(s)
	lyt:setLeftMargin(25)
	lyt:setRightMargin(25)
	lyt:setHorizontalEdge(3)
	lyt:setStretchWidthEnabled(true)
	lyt:setTopMargin(100.98)
	lyt:setBottomMargin(193.02)
	lyt:setVerticalEdge(3)
	lyt:setStretchHeightEnabled(true)
	self:addLyt(lyt)
	s.lyt = lyt
	self:addChild(s)
	self.s = s

	local s = cc.Sprite:create()
	s:setPosition(310, 629.43)
	s:setContentSize(497, 16)
	self:addLoadRes(2, s, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-parttern.png")
	self:addChild(s)
	self.s = s

	local lbl_rand_pre = cc.Label:createWithTTF(ex.Tools:getLang(57161),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_rand_pre:setPosition(310, 629.98)
	lbl_rand_pre:setContentSize(92, 31.72)
	lbl_rand_pre:setTextColor(cc.c3b(255, 227, 183))
	lbl_rand_pre:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rand_pre:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rand_pre:enableOutline(cc.c4b(87,56,29,255), 2)
	self:addChild(lbl_rand_pre)
	self.lbl_rand_pre = lbl_rand_pre

	local s = cc.Sprite:create()
	s:setPosition(310, 420.99)
	s:setContentSize(497, 16)
	self:addLoadRes(2, s, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-parttern.png")
	self:addChild(s)
	self.s = s

	local lbl_rand_now = cc.Label:createWithTTF(ex.Tools:getLang(57162),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_rand_now:setPosition(310, 421.54)
	lbl_rand_now:setContentSize(92, 31.72)
	lbl_rand_now:setTextColor(cc.c3b(255, 227, 183))
	lbl_rand_now:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rand_now:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rand_now:enableOutline(cc.c4b(87,56,29,255), 2)
	self:addChild(lbl_rand_now)
	self.lbl_rand_now = lbl_rand_now

	local s = cc.Sprite:create()
	s:setPosition(310, 715.32)
	s:setContentSize(116, 34)
	self:addLoadRes(2, s, "ccbi-res/hero-magic-wand.plist", "ccbi-res/hero-magic-wand.pvr.ccz", "hero-magic-wand/titlebg1.png")
	self:addChild(s)
	self.s = s

	local update_layout = cc.Node:create()
	update_layout:setPosition(310, 675)
	update_layout:setContentSize(226, 35)
	update_layout:setAnchorPoint(cc.p(0.5, 0.5))
	update_layout:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 20, false)
	ly.node = update_layout
	update_layout.layoutex = ly
	self:addLyt(ly)
	self:addChild(update_layout)
	self.update_layout = update_layout

	local rare_layout = cc.Node:create()
	rare_layout:setPosition(52.65, 17.5)
	rare_layout:setContentSize(105.3, 35)
	rare_layout:setAnchorPoint(cc.p(0.5, 0.5))
	rare_layout:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 5, false)
	ly.node = rare_layout
	rare_layout.layoutex = ly
	self:addLyt(ly)
	update_layout:addChild(rare_layout)
	self.rare_layout = rare_layout

	local l = cc.Label:createWithTTF(ex.Tools:getLang(57174),FONT_DEFAULT_NAME_BOLD, 22)
	l:setPosition(70, 17.5)
	l:setContentSize(70, 31.72)
	l:setAnchorPoint(cc.p(1, 0.5))
	l:setTextColor(cc.c3b(253, 252, 224))
	l:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	l:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	l:enableOutline(cc.c4b(87,56,29,255), 2)
	rare_layout:addChild(l)
	self.l = l

	local lbl_rare = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_rare:setPosition(75, 17.5)
	lbl_rare:setContentSize(30.3, 31.72)
	lbl_rare:setAnchorPoint(cc.p(0, 0.5))
	lbl_rare:setTextColor(cc.c3b(253, 252, 224))
	lbl_rare:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rare:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_rare:enableOutline(cc.c4b(87,56,29,255), 2)
	rare_layout:addChild(lbl_rare)
	self.lbl_rare = lbl_rare

	local level_layout = cc.Node:create()
	level_layout:setPosition(175.65, 17.5)
	level_layout:setContentSize(100.7, 35)
	level_layout:setAnchorPoint(cc.p(0.5, 0.5))
	level_layout:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 5, false)
	ly.node = level_layout
	level_layout.layoutex = ly
	self:addLyt(ly)
	update_layout:addChild(level_layout)
	self.level_layout = level_layout

	local l = cc.Label:createWithTTF(ex.Tools:getLang(57175),FONT_DEFAULT_NAME_BOLD, 22)
	l:setPosition(70, 19.14)
	l:setContentSize(70, 31.72)
	l:setAnchorPoint(cc.p(1, 0.5))
	l:setTextColor(cc.c3b(253, 252, 224))
	l:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	l:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	l:enableOutline(cc.c4b(87,56,29,255), 2)
	level_layout:addChild(l)
	self.l = l

	local lbl_level = cc.Label:createWithTTF(ex.Tools:getLang(5151),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_level:setPosition(75, 17.5)
	lbl_level:setContentSize(25.7, 27.72)
	lbl_level:setAnchorPoint(cc.p(0, 0.5))
	lbl_level:setTextColor(cc.c3b(255, 0, 0))
	lbl_level:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_level:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	level_layout:addChild(lbl_level)
	self.lbl_level = lbl_level

	local lbl_equip_name = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_equip_name:setPosition(310, 713.01)
	lbl_equip_name:setContentSize(27.91, 29.2)
	lbl_equip_name:setTextColor(cc.c3b(255, 227, 183))
	lbl_equip_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_equip_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_equip_name:enableOutline(cc.c4b(87,56,29,255), 2)
	self:addChild(lbl_equip_name)
	self.lbl_equip_name = lbl_equip_name

	local node_title = cc.Node:create()
	node_title:setPosition(310, 1008.57)
	node_title:setContentSize(0, 0)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_title)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	lyt:setTopMargin(11.43)
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

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57185),FONT_DEFAULT_NAME_BOLD, 56)
	lbl_title:setPosition(0, -48.18)
	lbl_title:setContentSize(228, 74.56)
	lbl_title:setScale(0.5, 0.5)
	lbl_title:setTextColor(cc.c3b(255, 227, 183))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title:enableOutline(cc.c4b(87,56,29,255), 2)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local node_attr = cc.Node:create()
	node_attr:setPosition(310, 530.01)
	node_attr:setContentSize(620, 154)
	node_attr:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr:setIgnoreAnchorPointForPosition(false)
	self:addChild(node_attr)
	self.node_attr = node_attr

	local CCScale9Sprite = cc.Scale9Sprite:create()
	CCScale9Sprite:setPosition(310, 75.5)
	CCScale9Sprite:setContentSize(550, 157)
	self:addLoadRes(1, CCScale9Sprite, "ccbi-res/fantasyland.plist", "ccbi-res/fantasyland.pvr.ccz", {frame = "fantasy-land/spr-cell-bg.png", capInsets = cc.rect(9,11,11,10)})
	node_attr:addChild(CCScale9Sprite)

	local scroll_attr = cc.ScrollView:create(cc.size(535, 154))
	scroll_attr:setPosition(310, 77)
	scroll_attr:setContentSize(535, 154)
	scroll_attr:setAnchorPoint(cc.p(0.5, 0.5))
	scroll_attr:setIgnoreAnchorPointForPosition(false)
	scroll_attr:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_attr:setContentSize(cc.size(535, 192))
	node_attr:addChild(scroll_attr)
	self.scroll_attr = scroll_attr

	local content = scroll_attr:getContainer()
	local s = cc.Node:create()
	s:setPosition(267.5, 192)
	s:setContentSize(560, 192)
	s:setAnchorPoint(cc.p(0.5, 1))
	s:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 0, 0, 0, false)
	ly.node = s
	s.layoutex = ly
	self:addLyt(ly)
	content:addChild(s)
	self.s = s

	local node_attr1 = cc.Node:create()
	node_attr1:setPosition(17.83, 168)
	node_attr1:setContentSize(0, 48)
	node_attr1:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr1:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr1)
	self.node_attr1 = node_attr1

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr1:addChild(ss)
	self.ss = ss

	local spr_icon1 = cc.Sprite:create()
	spr_icon1:setPosition(22.76, 24)
	spr_icon1:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon1, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr1:addChild(spr_icon1)
	self.spr_icon1 = spr_icon1

	local lbl_attr1 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr1:setPosition(54.74, 24)
	lbl_attr1:setContentSize(51.33, 27.72)
	lbl_attr1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr1:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr1:addChild(lbl_attr1)
	self.lbl_attr1 = lbl_attr1

	local prog_attr1 = require("src.comp.UIProgreeBar"):create()
	prog_attr1:setPosition(114.29, 24)
	prog_attr1:setContentSize(185, 19)
	prog_attr1:setAnchorPoint(cc.p(0, 0.5))
	prog_attr1:setBgSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt1.png", cc.rect(0,0,0,0))
	prog_attr1:setBarSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt2.png")
	prog_attr1:setType(1)
	prog_attr1:setMidpoint(cc.p(0, 0.5))
	prog_attr1:setBarChangeRate(cc.p(1, 0))
	prog_attr1:setPercentage(100)
	node_attr1:addChild(prog_attr1)
	self.prog_attr1 = prog_attr1

	local lbl_attr_num1 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_num1:setPosition(92.5, 9.5)
	lbl_attr_num1:setContentSize(15.32, 27.2)
	lbl_attr_num1:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_num1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_num1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_num1:enableOutline(cc.c4b(0,0,0,255), 1)
	prog_attr1:addChild(lbl_attr_num1)
	self.lbl_attr_num1 = lbl_attr_num1

	local node_attr2 = cc.Node:create()
	node_attr2:setPosition(17.83, 120)
	node_attr2:setContentSize(0, 48)
	node_attr2:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr2:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr2)
	self.node_attr2 = node_attr2

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr2:addChild(ss)
	self.ss = ss

	local spr_icon2 = cc.Sprite:create()
	spr_icon2:setPosition(22.76, 24)
	spr_icon2:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon2, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr2:addChild(spr_icon2)
	self.spr_icon2 = spr_icon2

	local lbl_attr2 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr2:setPosition(54.74, 24)
	lbl_attr2:setContentSize(51.33, 27.72)
	lbl_attr2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr2:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr2:addChild(lbl_attr2)
	self.lbl_attr2 = lbl_attr2

	local prog_attr2 = require("src.comp.UIProgreeBar"):create()
	prog_attr2:setPosition(114.29, 24)
	prog_attr2:setContentSize(185, 19)
	prog_attr2:setAnchorPoint(cc.p(0, 0.5))
	prog_attr2:setBgSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt1.png", cc.rect(0,0,0,0))
	prog_attr2:setBarSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt2.png")
	prog_attr2:setType(1)
	prog_attr2:setMidpoint(cc.p(0, 0.5))
	prog_attr2:setBarChangeRate(cc.p(1, 0))
	prog_attr2:setPercentage(100)
	node_attr2:addChild(prog_attr2)
	self.prog_attr2 = prog_attr2

	local lbl_attr_num2 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_num2:setPosition(211.47, 24)
	lbl_attr_num2:setContentSize(15.32, 27.2)
	lbl_attr_num2:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_num2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_num2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_num2:enableOutline(cc.c4b(0,0,0,255), 1)
	node_attr2:addChild(lbl_attr_num2)
	self.lbl_attr_num2 = lbl_attr_num2

	local node_attr3 = cc.Node:create()
	node_attr3:setPosition(17.83, 72)
	node_attr3:setContentSize(0, 48)
	node_attr3:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr3:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr3)
	self.node_attr3 = node_attr3

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr3:addChild(ss)
	self.ss = ss

	local spr_icon3 = cc.Sprite:create()
	spr_icon3:setPosition(22.76, 24)
	spr_icon3:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon3, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr3:addChild(spr_icon3)
	self.spr_icon3 = spr_icon3

	local lbl_attr3 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr3:setPosition(54.74, 24)
	lbl_attr3:setContentSize(51.33, 27.72)
	lbl_attr3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr3:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr3:addChild(lbl_attr3)
	self.lbl_attr3 = lbl_attr3

	local prog_attr3 = require("src.comp.UIProgreeBar"):create()
	prog_attr3:setPosition(114.29, 24)
	prog_attr3:setContentSize(185, 19)
	prog_attr3:setAnchorPoint(cc.p(0, 0.5))
	prog_attr3:setBgSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt1.png", cc.rect(0,0,0,0))
	prog_attr3:setBarSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt2.png")
	prog_attr3:setType(1)
	prog_attr3:setMidpoint(cc.p(0, 0.5))
	prog_attr3:setBarChangeRate(cc.p(1, 0))
	prog_attr3:setPercentage(100)
	node_attr3:addChild(prog_attr3)
	self.prog_attr3 = prog_attr3

	local lbl_attr_num3 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_num3:setPosition(211.47, 24)
	lbl_attr_num3:setContentSize(15.32, 27.2)
	lbl_attr_num3:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_num3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_num3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_num3:enableOutline(cc.c4b(0,0,0,255), 1)
	node_attr3:addChild(lbl_attr_num3)
	self.lbl_attr_num3 = lbl_attr_num3

	local node_attr4 = cc.Node:create()
	node_attr4:setPosition(17.83, 24)
	node_attr4:setContentSize(0, 48)
	node_attr4:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr4:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr4)
	self.node_attr4 = node_attr4

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr4:addChild(ss)
	self.ss = ss

	local spr_icon4 = cc.Sprite:create()
	spr_icon4:setPosition(22.76, 24)
	spr_icon4:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon4, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr4:addChild(spr_icon4)
	self.spr_icon4 = spr_icon4

	local lbl_attr4 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr4:setPosition(54.74, 24)
	lbl_attr4:setContentSize(51.33, 27.72)
	lbl_attr4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr4:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr4:addChild(lbl_attr4)
	self.lbl_attr4 = lbl_attr4

	local prog_attr4 = require("src.comp.UIProgreeBar"):create()
	prog_attr4:setPosition(114.29, 24)
	prog_attr4:setContentSize(185, 19)
	prog_attr4:setAnchorPoint(cc.p(0, 0.5))
	prog_attr4:setBgSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt1.png", cc.rect(0,0,0,0))
	prog_attr4:setBarSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt2.png")
	prog_attr4:setType(1)
	prog_attr4:setMidpoint(cc.p(0, 0.5))
	prog_attr4:setBarChangeRate(cc.p(1, 0))
	prog_attr4:setPercentage(100)
	node_attr4:addChild(prog_attr4)
	self.prog_attr4 = prog_attr4

	local lbl_attr_num4 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_num4:setPosition(211.47, 24)
	lbl_attr_num4:setContentSize(15.32, 27.2)
	lbl_attr_num4:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_num4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_num4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_num4:enableOutline(cc.c4b(0,0,0,255), 1)
	node_attr4:addChild(lbl_attr_num4)
	self.lbl_attr_num4 = lbl_attr_num4

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(310, 455.9)
	CCSprite:setContentSize(32, 30)
	self:addLoadRes(2, CCSprite, "ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-dx.png")
	self:addChild(CCSprite)

	local node_attr_rand = cc.Node:create()
	node_attr_rand:setPosition(310, 307.97)
	node_attr_rand:setContentSize(620, 178)
	node_attr_rand:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand:setIgnoreAnchorPointForPosition(false)
	self:addChild(node_attr_rand)
	self.node_attr_rand = node_attr_rand

	local ss = cc.Scale9Sprite:create()
	ss:setPosition(310, 89)
	ss:setContentSize(550, 178)
	self:addLoadRes(1, ss, "ccbi-res/fantasyland.plist", "ccbi-res/fantasyland.pvr.ccz", {frame = "fantasy-land/spr-cell-bg.png", capInsets = cc.rect(9,11,11,10)})
	node_attr_rand:addChild(ss)
	self.ss = ss

	local scroll_attr_rand = cc.ScrollView:create(cc.size(535, 172))
	scroll_attr_rand:setPosition(310, 89)
	scroll_attr_rand:setContentSize(535, 172)
	scroll_attr_rand:setAnchorPoint(cc.p(0.5, 0.5))
	scroll_attr_rand:setIgnoreAnchorPointForPosition(false)
	scroll_attr_rand:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
	scroll_attr_rand:setContentSize(cc.size(535, 212))
	node_attr_rand:addChild(scroll_attr_rand)
	self.scroll_attr_rand = scroll_attr_rand

	local content = scroll_attr_rand:getContainer()
	local s = cc.Node:create()
	s:setPosition(267.5, 212)
	s:setContentSize(560, 212)
	s:setAnchorPoint(cc.p(0.5, 1))
	s:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 10, 10, 0, false)
	ly.node = s
	s.layoutex = ly
	self:addLyt(ly)
	content:addChild(s)
	self.s = s

	local node_attr_rand1 = cc.Node:create()
	node_attr_rand1:setPosition(17.83, 178)
	node_attr_rand1:setContentSize(0, 48)
	node_attr_rand1:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand1:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr_rand1)
	self.node_attr_rand1 = node_attr_rand1

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_rand1:addChild(ss)
	self.ss = ss

	local spr_icon_rand1 = cc.Sprite:create()
	spr_icon_rand1:setPosition(22.76, 24)
	spr_icon_rand1:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon_rand1, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr_rand1:addChild(spr_icon_rand1)
	self.spr_icon_rand1 = spr_icon_rand1

	local lbl_attr_rand1 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand1:setPosition(54.74, 24)
	lbl_attr_rand1:setContentSize(51.33, 27.72)
	lbl_attr_rand1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand1:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand1:addChild(lbl_attr_rand1)
	self.lbl_attr_rand1 = lbl_attr_rand1

	local prog_attr_rand1 = require("src.comp.UIProgreeBar"):create()
	prog_attr_rand1:setPosition(114.29, 24)
	prog_attr_rand1:setContentSize(185, 19)
	prog_attr_rand1:setAnchorPoint(cc.p(0, 0.5))
	prog_attr_rand1:setBgSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt1.png", cc.rect(0,0,0,0))
	prog_attr_rand1:setBarSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt2.png")
	prog_attr_rand1:setType(1)
	prog_attr_rand1:setMidpoint(cc.p(0, 0.5))
	prog_attr_rand1:setBarChangeRate(cc.p(1, 0))
	prog_attr_rand1:setPercentage(100)
	node_attr_rand1:addChild(prog_attr_rand1)
	self.prog_attr_rand1 = prog_attr_rand1

	local lbl_attr_num_rand1 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_num_rand1:setPosition(211.47, 24)
	lbl_attr_num_rand1:setContentSize(15.32, 27.2)
	lbl_attr_num_rand1:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_num_rand1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_num_rand1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_num_rand1:enableOutline(cc.c4b(0,0,0,255), 1)
	node_attr_rand1:addChild(lbl_attr_num_rand1)
	self.lbl_attr_num_rand1 = lbl_attr_num_rand1

	local node_attr_rand2 = cc.Node:create()
	node_attr_rand2:setPosition(17.83, 130)
	node_attr_rand2:setContentSize(0, 48)
	node_attr_rand2:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand2:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr_rand2)
	self.node_attr_rand2 = node_attr_rand2

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_rand2:addChild(ss)
	self.ss = ss

	local spr_icon_rand2 = cc.Sprite:create()
	spr_icon_rand2:setPosition(22.76, 24)
	spr_icon_rand2:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon_rand2, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr_rand2:addChild(spr_icon_rand2)
	self.spr_icon_rand2 = spr_icon_rand2

	local lbl_attr_rand2 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand2:setPosition(54.74, 24)
	lbl_attr_rand2:setContentSize(51.33, 27.72)
	lbl_attr_rand2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand2:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand2:addChild(lbl_attr_rand2)
	self.lbl_attr_rand2 = lbl_attr_rand2

	local prog_attr_rand2 = require("src.comp.UIProgreeBar"):create()
	prog_attr_rand2:setPosition(114.29, 24)
	prog_attr_rand2:setContentSize(185, 19)
	prog_attr_rand2:setAnchorPoint(cc.p(0, 0.5))
	prog_attr_rand2:setBgSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt1.png", cc.rect(0,0,0,0))
	prog_attr_rand2:setBarSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt2.png")
	prog_attr_rand2:setType(1)
	prog_attr_rand2:setMidpoint(cc.p(0, 0.5))
	prog_attr_rand2:setBarChangeRate(cc.p(1, 0))
	prog_attr_rand2:setPercentage(100)
	node_attr_rand2:addChild(prog_attr_rand2)
	self.prog_attr_rand2 = prog_attr_rand2

	local lbl_attr_num_rand2 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_num_rand2:setPosition(211.47, 24)
	lbl_attr_num_rand2:setContentSize(15.32, 27.2)
	lbl_attr_num_rand2:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_num_rand2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_num_rand2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_num_rand2:enableOutline(cc.c4b(0,0,0,255), 1)
	node_attr_rand2:addChild(lbl_attr_num_rand2)
	self.lbl_attr_num_rand2 = lbl_attr_num_rand2

	local node_attr_rand3 = cc.Node:create()
	node_attr_rand3:setPosition(17.83, 82)
	node_attr_rand3:setContentSize(0, 48)
	node_attr_rand3:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand3:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr_rand3)
	self.node_attr_rand3 = node_attr_rand3

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_rand3:addChild(ss)
	self.ss = ss

	local spr_icon_rand3 = cc.Sprite:create()
	spr_icon_rand3:setPosition(22.76, 24)
	spr_icon_rand3:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon_rand3, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr_rand3:addChild(spr_icon_rand3)
	self.spr_icon_rand3 = spr_icon_rand3

	local lbl_attr_rand3 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand3:setPosition(54.74, 24)
	lbl_attr_rand3:setContentSize(51.33, 27.72)
	lbl_attr_rand3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand3:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand3:addChild(lbl_attr_rand3)
	self.lbl_attr_rand3 = lbl_attr_rand3

	local prog_attr_rand3 = require("src.comp.UIProgreeBar"):create()
	prog_attr_rand3:setPosition(114.29, 24)
	prog_attr_rand3:setContentSize(185, 19)
	prog_attr_rand3:setAnchorPoint(cc.p(0, 0.5))
	prog_attr_rand3:setBgSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt1.png", cc.rect(0,0,0,0))
	prog_attr_rand3:setBarSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt2.png")
	prog_attr_rand3:setType(1)
	prog_attr_rand3:setMidpoint(cc.p(0, 0.5))
	prog_attr_rand3:setBarChangeRate(cc.p(1, 0))
	prog_attr_rand3:setPercentage(100)
	node_attr_rand3:addChild(prog_attr_rand3)
	self.prog_attr_rand3 = prog_attr_rand3

	local lbl_attr_num_rand3 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_num_rand3:setPosition(211.47, 24)
	lbl_attr_num_rand3:setContentSize(15.32, 27.2)
	lbl_attr_num_rand3:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_num_rand3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_num_rand3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_num_rand3:enableOutline(cc.c4b(0,0,0,255), 1)
	node_attr_rand3:addChild(lbl_attr_num_rand3)
	self.lbl_attr_num_rand3 = lbl_attr_num_rand3

	local node_attr_rand4 = cc.Node:create()
	node_attr_rand4:setPosition(17.83, 34)
	node_attr_rand4:setContentSize(0, 48)
	node_attr_rand4:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand4:setIgnoreAnchorPointForPosition(false)
	s:addChild(node_attr_rand4)
	self.node_attr_rand4 = node_attr_rand4

	local ss = cc.Sprite:create()
	ss:setPosition(19.85, 24)
	ss:setContentSize(82, 38)
	ss:setScale(2.3, 1)
	ss:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, ss, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-bg.png")
	node_attr_rand4:addChild(ss)
	self.ss = ss

	local spr_icon_rand4 = cc.Sprite:create()
	spr_icon_rand4:setPosition(22.76, 24)
	spr_icon_rand4:setContentSize(47, 47)
	self:addLoadRes(2, spr_icon_rand4, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-act-0.png")
	node_attr_rand4:addChild(spr_icon_rand4)
	self.spr_icon_rand4 = spr_icon_rand4

	local lbl_attr_rand4 = cc.Label:createWithTTF("统御:",FONT_DEFAULT_NAME_BOLD, 22)
	lbl_attr_rand4:setPosition(54.74, 24)
	lbl_attr_rand4:setContentSize(51.33, 27.72)
	lbl_attr_rand4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand4:setTextColor(cc.c3b(83, 45, 29))
	lbl_attr_rand4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand4:addChild(lbl_attr_rand4)
	self.lbl_attr_rand4 = lbl_attr_rand4

	local prog_attr_rand4 = require("src.comp.UIProgreeBar"):create()
	prog_attr_rand4:setPosition(114.29, 24)
	prog_attr_rand4:setContentSize(185, 19)
	prog_attr_rand4:setAnchorPoint(cc.p(0, 0.5))
	prog_attr_rand4:setBgSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt1.png", cc.rect(0,0,0,0))
	prog_attr_rand4:setBarSpriteFrame("ccbi-res/god-equip.plist", "ccbi-res/god-equip.pvr.ccz", "god-equip/spr-jdt2.png")
	prog_attr_rand4:setType(1)
	prog_attr_rand4:setMidpoint(cc.p(0, 0.5))
	prog_attr_rand4:setBarChangeRate(cc.p(1, 0))
	prog_attr_rand4:setPercentage(100)
	node_attr_rand4:addChild(prog_attr_rand4)
	self.prog_attr_rand4 = prog_attr_rand4

	local lbl_attr_num_rand4 = cc.Label:createWithTTF("--",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_num_rand4:setPosition(211.47, 24)
	lbl_attr_num_rand4:setContentSize(15.32, 27.2)
	lbl_attr_num_rand4:setTextColor(cc.c3b(253, 252, 224))
	lbl_attr_num_rand4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_num_rand4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr_num_rand4:enableOutline(cc.c4b(0,0,0,255), 1)
	node_attr_rand4:addChild(lbl_attr_num_rand4)
	self.lbl_attr_num_rand4 = lbl_attr_num_rand4

	local node_res_need_1 = cc.Node:create()
	node_res_need_1:setPosition(211.52, 157.8)
	node_res_need_1:setContentSize(120, 40)
	node_res_need_1:setAnchorPoint(cc.p(0.5, 0.5))
	node_res_need_1:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_res_need_1)
	lyt:setLeftMargin(151.52)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(137.8)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_res_need_1.lyt = lyt
	self:addChild(node_res_need_1)
	self.node_res_need_1 = node_res_need_1

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(0, 20)
	CCSprite:setContentSize(145, 37)
	CCSprite:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, CCSprite, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-res-bg.png")
	node_res_need_1:addChild(CCSprite)

	local spr_res_need_1 = cc.Sprite:create()
	spr_res_need_1:setPosition(9.26, 20)
	spr_res_need_1:setContentSize(62, 84)
	spr_res_need_1:setScale(0.5, 0.5)
	self:addLoadRes(2, spr_res_need_1, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/900002.png")
	node_res_need_1:addChild(spr_res_need_1)
	self.spr_res_need_1 = spr_res_need_1

	local lbl_res_need_1 = cc.Label:createWithTTF("99999",FONT_DEFAULT_NAME_BOLD, 44)
	lbl_res_need_1:setPosition(81.21, 19)
	lbl_res_need_1:setContentSize(125.47, 55.44)
	lbl_res_need_1:setScale(0.5, 0.5)
	lbl_res_need_1:setTextColor(cc.c3b(255, 229, 191))
	lbl_res_need_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_res_need_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_res_need_1:addChild(lbl_res_need_1)
	self.lbl_res_need_1 = lbl_res_need_1

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(60, 20)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	node_res_need_1:addChild(UIMenu)

	local btn_res_info1 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_res_info1:setPosition(-50.61, 0)
	btn_res_info1:setContentSize(40, 40)
	btn_res_info1:registerScriptTapHandler(handler(self, self.onItemInfo))
	UIMenu:addChild(btn_res_info1)
	self.btn_res_info1 = btn_res_info1

	local node_res_need_2 = cc.Node:create()
	node_res_need_2:setPosition(381.52, 158)
	node_res_need_2:setContentSize(120, 40)
	node_res_need_2:setAnchorPoint(cc.p(0.5, 0.5))
	node_res_need_2:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(node_res_need_2)
	lyt:setLeftMargin(321.52)
	lyt:setHorizontalEdge(1)
	lyt:setBottomMargin(138)
	lyt:setVerticalEdge(1)
	self:addLyt(lyt)
	node_res_need_2.lyt = lyt
	self:addChild(node_res_need_2)
	self.node_res_need_2 = node_res_need_2

	local CCSprite = cc.Sprite:create()
	CCSprite:setPosition(0, 20)
	CCSprite:setContentSize(145, 37)
	CCSprite:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, CCSprite, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-res-bg.png")
	node_res_need_2:addChild(CCSprite)

	local spr_res_need_2 = cc.Sprite:create()
	spr_res_need_2:setPosition(9.26, 20)
	spr_res_need_2:setContentSize(62, 84)
	spr_res_need_2:setScale(0.5, 0.5)
	self:addLoadRes(2, spr_res_need_2, "ccbi-res/backpack-4.plist", "ccbi-res/backpack-4.pvr.ccz", "backpack/900002.png")
	node_res_need_2:addChild(spr_res_need_2)
	self.spr_res_need_2 = spr_res_need_2

	local lbl_res_need_2 = cc.Label:createWithTTF("99999",FONT_DEFAULT_NAME_BOLD, 44)
	lbl_res_need_2:setPosition(81.21, 19)
	lbl_res_need_2:setContentSize(125.47, 55.44)
	lbl_res_need_2:setScale(0.5, 0.5)
	lbl_res_need_2:setTextColor(cc.c3b(255, 229, 191))
	lbl_res_need_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_res_need_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_res_need_2:addChild(lbl_res_need_2)
	self.lbl_res_need_2 = lbl_res_need_2

	local UIMenu = cpp.UIMenu:create()
	UIMenu:setPosition(60, 20)
	UIMenu:setContentSize(0, 0)
	UIMenu:setAnchorPoint(cc.p(0.5, 0.5))
	UIMenu:setIgnoreAnchorPointForPosition(false)
	node_res_need_2:addChild(UIMenu)

	local btn_res_info2 = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_res_info2:setPosition(-50.61, 0)
	btn_res_info2:setContentSize(40, 40)
	btn_res_info2:registerScriptTapHandler(handler(self, self.onItemInfo))
	UIMenu:addChild(btn_res_info2)
	self.btn_res_info2 = btn_res_info2

	local menu = cpp.UIMenu:create()
	menu:setPosition(310, 0)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setPositionPercentXEnabled(true)
	lyt:setPositionPercentX(0.5)
	self:addLyt(lyt)
	menu.lyt = lyt
	self:addChild(menu)
	self.menu = menu

	local btn_refine = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_refine:setPosition(-80, 87.98)
	btn_refine:setContentSize(134, 56)
	btn_refine:registerScriptTapHandler(handler(self, self.onRefine))
	btn_refine:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_refine:setLabelOffset(cc.p(0, -2))
	btn_refine:setLabelSize(44)
	btn_refine:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_refine:setLabelText(ex.Tools:getLang(5070))
	self:addLoadRes(3, btn_refine, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-green-big-1.png"})
	menu:addChild(btn_refine)
	self.btn_refine = btn_refine

	local btn_save = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_save:setPosition(80, 87.98)
	btn_save:setContentSize(134, 56)
	btn_save:registerScriptTapHandler(handler(self, self.onSave))
	btn_save:getLabel():setTextColor(cc.c4b(255, 255, 255, 255))
	btn_save:setLabelOffset(cc.p(0, -2))
	btn_save:setLabelSize(44)
	btn_save:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_save:setLabelText(ex.Tools:getLang(70117))
	self:addLoadRes(3, btn_save, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-orange-big-1.png"})
	menu:addChild(btn_save)
	self.btn_save = btn_save

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(250, 1020)
	btn_close:setContentSize(53, 56)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(-231.41, 861.08)
	btn_info:setContentSize(58, 59)
	btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png"})
	menu:addChild(btn_info)
	self.btn_info = btn_info

	local btn_equip = require("src.comp.menu.UIMenuItemBag"):createWithData(0, 0)
	btn_equip:setPosition(-1.5, 800)
	menu:addChild(btn_equip)
	self.btn_equip = btn_equip

	local btn_preview = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_preview:setPosition(224.41, 630.67)
	btn_preview:setContentSize(96, 38)
	btn_preview:registerScriptTapHandler(handler(self, self.onPreview))
	btn_preview:getLabel():setTextColor(cc.c4b(241, 211, 139, 255))
	btn_preview:setLabelOffset(cc.p(0, -2))
	btn_preview:setLabelSize(36)
	btn_preview:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_preview:setLabelText(ex.Tools:getLang(57160))
	self:addLoadRes(3, btn_preview, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/spr-red-bg.png"})
	menu:addChild(btn_preview)
	self.btn_preview = btn_preview

	local lbl_refine_num = cc.Label:createWithTTF(ex.Tools:getLang(5151),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_refine_num:setPosition(68.95, 38.55)
	lbl_refine_num:setContentSize(131.41, 25.2)
	lbl_refine_num:setAnchorPoint(cc.p(0, 0.5))
	lbl_refine_num:setTextColor(cc.c3b(230, 149, 45))
	lbl_refine_num:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_refine_num:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_refine_num)
	self.lbl_refine_num = lbl_refine_num

	local l = cc.Label:createWithTTF(ex.Tools:getLang(57100),FONT_DEFAULT_NAME_BOLD, 20)
	l:setPosition(310, 874.01)
	l:setContentSize(82, 27.2)
	l:setTextColor(cc.c3b(255, 227, 183))
	l:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	l:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	l:enableOutline(cc.c4b(68,32,11,255), 1)
	self:addChild(l)
	self.l = l

	local lbl_title1 = cc.Label:createWithTTF(ex.Tools:getLang(5561),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_title1:setPosition(140, 157.8)
	lbl_title1:setContentSize(50, 32.24)
	lbl_title1:setAnchorPoint(cc.p(1, 0.5))
	lbl_title1:setTextColor(cc.c3b(253, 252, 224))
	lbl_title1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_title1:enableOutline(cc.c4b(68,32,11,255), 1)
	self:addChild(lbl_title1)
	self.lbl_title1 = lbl_title1

	 self:startLoadRes()
end
return HeroMagicWandRefineLayer