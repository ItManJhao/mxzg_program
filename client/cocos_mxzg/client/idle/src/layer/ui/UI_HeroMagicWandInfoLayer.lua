local HeroMagicWandInfoLayer = class("HeroMagicWandInfoLayer", require("src.comp.CCCLayerBase")) 

function HeroMagicWandInfoLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(390, 797)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 0, 0, 0, false)
	ly.node = self
	self.layoutex = ly
	self:addLyt(ly)
	local m = cpp.UIMenu:create()
	m:setPosition(390, 797)
	m:setContentSize(0, 0)
	m:setLocalZOrder(1)
	m:setAnchorPoint(cc.p(0.5, 0.5))
	m:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(m)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(2)
	self:addLyt(lyt)
	m.lyt = lyt
	self:addChild(m)
	self.m = m

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(-37.96, -24.37)
	btn_close:setContentSize(53, 56)
	btn_close:setScale(0.8, 0.8)
	btn_close:setLocalZOrder(1)
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png"})
	m:addChild(btn_close)
	self.btn_close = btn_close

	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(390, 797)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-24.png", capInsets = cc.rect(16,16,14,15)})
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 5, 5, 0, false)
	ly.node = spr_bg
	spr_bg.layoutex = ly
	self:addLyt(ly)
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local node_equip = cc.Node:create()
	node_equip:setPosition(195, 728.5)
	node_equip:setContentSize(390, 127)
	node_equip:setAnchorPoint(cc.p(0.5, 0.5))
	node_equip:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(node_equip)
	self.node_equip = node_equip

	local spr_rare = cc.Sprite:create()
	spr_rare:setPosition(195, 63.5)
	spr_rare:setContentSize(380, 127)
	self:addLoadRes(2, spr_rare, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-banner-backpack-1.png")
	node_equip:addChild(spr_rare)
	self.spr_rare = spr_rare

	local lbl_prop_type = cc.Label:createWithTTF(ex.Tools:getLang(57105),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_prop_type:setPosition(140, 60.5)
	lbl_prop_type:setContentSize(100, 25.2)
	lbl_prop_type:setAnchorPoint(cc.p(0, 0.5))
	lbl_prop_type:setTextColor(cc.c3b(255, 229, 191))
	lbl_prop_type:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_prop_type:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_equip:addChild(lbl_prop_type)
	self.lbl_prop_type = lbl_prop_type

	local lbl_name = cc.Label:createWithTTF(ex.Tools:getLang(5120),FONT_DEFAULT_NAME_BOLD, 24)
	lbl_name:setPosition(140, 94.5)
	lbl_name:setContentSize(100, 34.24)
	lbl_name:setAnchorPoint(cc.p(0, 0.5))
	lbl_name:setTextColor(cc.c3b(255, 255, 255))
	lbl_name:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_name:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_name:enableOutline(cc.c4b(0,0,0,255), 2)
	node_equip:addChild(lbl_name)
	self.lbl_name = lbl_name

	local menu = cpp.UIMenu:create()
	menu:setPosition(195, 124.52)
	menu:setContentSize(0, 0)
	node_equip:addChild(menu)
	self.menu = menu

	local btn_preview = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_preview:setPosition(135, -170)
	btn_preview:setContentSize(67, 55)
	btn_preview:setVisible(false)
	self:addLoadRes(3, btn_preview, "ccbi-res/common-ui.plist", "ccbi-res/common-ui.pvr.ccz", {spr1="button/btn-src.png"})
	menu:addChild(btn_preview)
	self.btn_preview = btn_preview

	local btn_equip = require("src.comp.menu.UIMenuItemBag"):createWithData(0, 0)
	btn_equip:setPosition(-125, -60)
	menu:addChild(btn_equip)
	self.btn_equip = btn_equip

	local lbl_rare_tip = cc.Label:createWithTTF("属性提示",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_rare_tip:setPosition(140, 26.5)
	lbl_rare_tip:setContentSize(80, 25.2)
	lbl_rare_tip:setAnchorPoint(cc.p(0, 0.5))
	lbl_rare_tip:setTextColor(cc.c3b(255, 229, 191))
	lbl_rare_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_rare_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_equip:addChild(lbl_rare_tip)
	self.lbl_rare_tip = lbl_rare_tip

	local node_attr = cc.Node:create()
	node_attr:setPosition(195, 615)
	node_attr:setContentSize(390, 100)
	node_attr:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(node_attr)
	self.node_attr = node_attr

	local t = cc.Label:createWithTTF(ex.Tools:getLang(47011),FONT_DEFAULT_NAME_BOLD, 22)
	t:setPosition(20, 75)
	t:setContentSize(88, 27.72)
	t:setAnchorPoint(cc.p(0, 0.5))
	t:setTextColor(cc.c3b(255, 229, 191))
	t:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	t:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr:addChild(t)
	self.t = t

	local node_arrt1 = cc.Node:create()
	node_arrt1:setPosition(30, 36.17)
	node_arrt1:setContentSize(0, 45)
	node_arrt1:setAnchorPoint(cc.p(0.5, 0.5))
	node_arrt1:setIgnoreAnchorPointForPosition(false)
	node_attr:addChild(node_arrt1)
	self.node_arrt1 = node_arrt1

	local spr_attr1 = cc.Sprite:create()
	spr_attr1:setPosition(22.5, 22.5)
	spr_attr1:setContentSize(45, 45)
	spr_attr1:setScale(0.8, 0.8)
	self:addLoadRes(2, spr_attr1, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attr-random.png")
	node_arrt1:addChild(spr_attr1)
	self.spr_attr1 = spr_attr1

	local n = cc.Node:create()
	n:setPosition(50, 22.5)
	n:setContentSize(83.91, 26)
	n:setAnchorPoint(cc.p(0, 0.5))
	n:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 0, false)
	ly.node = n
	n.layoutex = ly
	self:addLyt(ly)
	node_arrt1:addChild(n)
	self.n = n

	local lbl_attr_1 = cc.Label:createWithTTF(ex.Tools:getLang(75015),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_1:setPosition(0, 13)
	lbl_attr_1:setContentSize(60, 25.2)
	lbl_attr_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_1:setTextColor(cc.c3b(144, 111, 72))
	lbl_attr_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_attr_1)
	self.lbl_attr_1 = lbl_attr_1

	local lbl_value_1 = cc.Label:createWithTTF(ex.Tools:getLang(75015),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_value_1:setPosition(60, 13)
	lbl_value_1:setContentSize(23.91, 25.2)
	lbl_value_1:setAnchorPoint(cc.p(0, 0.5))
	lbl_value_1:setTextColor(cc.c3b(255, 229, 191))
	lbl_value_1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_value_1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_value_1)
	self.lbl_value_1 = lbl_value_1

	local node_arrt2 = cc.Node:create()
	node_arrt2:setPosition(210, 36.17)
	node_arrt2:setContentSize(0, 45)
	node_arrt2:setAnchorPoint(cc.p(0.5, 0.5))
	node_arrt2:setIgnoreAnchorPointForPosition(false)
	node_attr:addChild(node_arrt2)
	self.node_arrt2 = node_arrt2

	local spr_attr2 = cc.Sprite:create()
	spr_attr2:setPosition(22.5, 22.5)
	spr_attr2:setContentSize(45, 45)
	spr_attr2:setScale(0.8, 0.8)
	self:addLoadRes(2, spr_attr2, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attr-random.png")
	node_arrt2:addChild(spr_attr2)
	self.spr_attr2 = spr_attr2

	local n = cc.Node:create()
	n:setPosition(50, 22.5)
	n:setContentSize(83.91, 26)
	n:setAnchorPoint(cc.p(0, 0.5))
	n:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.HORIZONTAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.LTOR, 0, 0, 0, false)
	ly.node = n
	n.layoutex = ly
	self:addLyt(ly)
	node_arrt2:addChild(n)
	self.n = n

	local lbl_attr_2 = cc.Label:createWithTTF(ex.Tools:getLang(75015),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr_2:setPosition(0, 13)
	lbl_attr_2:setContentSize(60, 25.2)
	lbl_attr_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_2:setTextColor(cc.c3b(144, 111, 72))
	lbl_attr_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_attr_2)
	self.lbl_attr_2 = lbl_attr_2

	local lbl_value_2 = cc.Label:createWithTTF(ex.Tools:getLang(75015),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_value_2:setPosition(60, 13)
	lbl_value_2:setContentSize(23.91, 25.2)
	lbl_value_2:setAnchorPoint(cc.p(0, 0.5))
	lbl_value_2:setTextColor(cc.c3b(255, 229, 191))
	lbl_value_2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_value_2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	n:addChild(lbl_value_2)
	self.lbl_value_2 = lbl_value_2

	local m = cpp.UIMenu:create()
	m:setPosition(195, 50)
	m:setContentSize(0, 0)
	m:setAnchorPoint(cc.p(0.5, 0.5))
	m:setIgnoreAnchorPointForPosition(false)
	node_attr:addChild(m)
	self.m = m

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(169.53, 25)
	btn_info:setContentSize(58, 59)
	btn_info:setScale(0.7, 0.7)
	btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png"})
	m:addChild(btn_info)
	self.btn_info = btn_info

	local node_attr_rand = cc.Node:create()
	node_attr_rand:setPosition(195, 410)
	node_attr_rand:setContentSize(390, 310)
	node_attr_rand:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(node_attr_rand)
	self.node_attr_rand = node_attr_rand

	local t = cc.Label:createWithTTF(ex.Tools:getLang(47634),FONT_DEFAULT_NAME_BOLD, 22)
	t:setPosition(20, 284.37)
	t:setContentSize(88, 27.72)
	t:setAnchorPoint(cc.p(0, 0.5))
	t:setTextColor(cc.c3b(255, 229, 191))
	t:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	t:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand:addChild(t)
	self.t = t

	local node_attr_rand1 = cc.Node:create()
	node_attr_rand1:setPosition(39.31, 240.73)
	node_attr_rand1:setContentSize(0, 45)
	node_attr_rand1:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand1:setIgnoreAnchorPointForPosition(false)
	node_attr_rand:addChild(node_attr_rand1)
	self.node_attr_rand1 = node_attr_rand1

	local spr_attr_rand1 = cc.Sprite:create()
	spr_attr_rand1:setPosition(22.5, 22.5)
	spr_attr_rand1:setContentSize(45, 45)
	spr_attr_rand1:setScale(0.8, 0.8)
	self:addLoadRes(2, spr_attr_rand1, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attr-random.png")
	node_attr_rand1:addChild(spr_attr_rand1)
	self.spr_attr_rand1 = spr_attr_rand1

	local lbl_attr_rand1 = cc.Label:createWithTTF(ex.Tools:getLang(75015),FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_rand1:setPosition(50, 22.5)
	lbl_attr_rand1:setContentSize(21.52, 22.68)
	lbl_attr_rand1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand1:setTextColor(cc.c3b(144, 111, 72))
	lbl_attr_rand1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand1:addChild(lbl_attr_rand1)
	self.lbl_attr_rand1 = lbl_attr_rand1

	local node_attr_rand2 = cc.Node:create()
	node_attr_rand2:setPosition(39.31, 185.73)
	node_attr_rand2:setContentSize(0, 45)
	node_attr_rand2:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand2:setIgnoreAnchorPointForPosition(false)
	node_attr_rand:addChild(node_attr_rand2)
	self.node_attr_rand2 = node_attr_rand2

	local spr_attr_rand2 = cc.Sprite:create()
	spr_attr_rand2:setPosition(22.5, 22.5)
	spr_attr_rand2:setContentSize(45, 45)
	spr_attr_rand2:setScale(0.8, 0.8)
	self:addLoadRes(2, spr_attr_rand2, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attr-random.png")
	node_attr_rand2:addChild(spr_attr_rand2)
	self.spr_attr_rand2 = spr_attr_rand2

	local lbl_attr_rand2 = cc.Label:createWithTTF(ex.Tools:getLang(75015),FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_rand2:setPosition(50, 22.5)
	lbl_attr_rand2:setContentSize(21.52, 22.68)
	lbl_attr_rand2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand2:setTextColor(cc.c3b(144, 111, 72))
	lbl_attr_rand2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand2:addChild(lbl_attr_rand2)
	self.lbl_attr_rand2 = lbl_attr_rand2

	local node_attr_rand3 = cc.Node:create()
	node_attr_rand3:setPosition(39.31, 130.73)
	node_attr_rand3:setContentSize(0, 45)
	node_attr_rand3:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand3:setIgnoreAnchorPointForPosition(false)
	node_attr_rand:addChild(node_attr_rand3)
	self.node_attr_rand3 = node_attr_rand3

	local spr_attr_rand3 = cc.Sprite:create()
	spr_attr_rand3:setPosition(22.5, 22.5)
	spr_attr_rand3:setContentSize(45, 45)
	spr_attr_rand3:setScale(0.8, 0.8)
	self:addLoadRes(2, spr_attr_rand3, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attr-random.png")
	node_attr_rand3:addChild(spr_attr_rand3)
	self.spr_attr_rand3 = spr_attr_rand3

	local lbl_attr_rand3 = cc.Label:createWithTTF(ex.Tools:getLang(75015),FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_rand3:setPosition(50, 22.5)
	lbl_attr_rand3:setContentSize(21.52, 22.68)
	lbl_attr_rand3:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand3:setTextColor(cc.c3b(144, 111, 72))
	lbl_attr_rand3:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand3:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand3:addChild(lbl_attr_rand3)
	self.lbl_attr_rand3 = lbl_attr_rand3

	local node_attr_rand4 = cc.Node:create()
	node_attr_rand4:setPosition(39.31, 75.73)
	node_attr_rand4:setContentSize(0, 45)
	node_attr_rand4:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr_rand4:setIgnoreAnchorPointForPosition(false)
	node_attr_rand:addChild(node_attr_rand4)
	self.node_attr_rand4 = node_attr_rand4

	local spr_attr_rand4 = cc.Sprite:create()
	spr_attr_rand4:setPosition(22.5, 22.5)
	spr_attr_rand4:setContentSize(45, 45)
	spr_attr_rand4:setScale(0.8, 0.8)
	self:addLoadRes(2, spr_attr_rand4, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-attr-random.png")
	node_attr_rand4:addChild(spr_attr_rand4)
	self.spr_attr_rand4 = spr_attr_rand4

	local lbl_attr_rand4 = cc.Label:createWithTTF(ex.Tools:getLang(75015),FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr_rand4:setPosition(50, 22.5)
	lbl_attr_rand4:setContentSize(21.52, 22.68)
	lbl_attr_rand4:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr_rand4:setTextColor(cc.c3b(144, 111, 72))
	lbl_attr_rand4:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr_rand4:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand4:addChild(lbl_attr_rand4)
	self.lbl_attr_rand4 = lbl_attr_rand4

	local m = cpp.UIMenu:create()
	m:setPosition(195, 155)
	m:setContentSize(0, 0)
	m:setAnchorPoint(cc.p(0.5, 0.5))
	m:setIgnoreAnchorPointForPosition(false)
	node_attr_rand:addChild(m)
	self.m = m

	local btn_preview = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_preview:setPosition(136.7, 129.37)
	btn_preview:setContentSize(96, 38)
	btn_preview:registerScriptTapHandler(handler(self, self.onPreview))
	btn_preview:getLabel():setTextColor(cc.c4b(241, 211, 139, 255))
	btn_preview:setLabelOffset(cc.p(0, -2))
	btn_preview:setLabelSize(36)
	btn_preview:setLabelOutLine(cc.c4b(0,0,0,255), 2)
	btn_preview:setLabelText(ex.Tools:getLang(57160))
	self:addLoadRes(3, btn_preview, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", {spr1="hero-hexagram/spr-red-bg.png"})
	m:addChild(btn_preview)
	self.btn_preview = btn_preview

	local spr_null_tip = cc.Sprite:create()
	spr_null_tip:setPosition(195, 157.17)
	spr_null_tip:setContentSize(99, 85)
	self:addLoadRes(2, spr_null_tip, "ccbi-res/countrywar.plist", "ccbi-res/countrywar.pvr.ccz", "countrywar/spr-not-rank.png")
	node_attr_rand:addChild(spr_null_tip)
	self.spr_null_tip = spr_null_tip

	local lbl_null_tip = cc.Label:createWithTTF(ex.Tools:getLang(57205),FONT_DEFAULT_NAME_BOLD, 20)
	lbl_null_tip:setPosition(195, 114.1)
	lbl_null_tip:setContentSize(200, 25.2)
	lbl_null_tip:setTextColor(cc.c3b(255, 229, 191))
	lbl_null_tip:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_null_tip:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_attr_rand:addChild(lbl_null_tip)
	self.lbl_null_tip = lbl_null_tip

	local node_bottom = cc.Node:create()
	node_bottom:setPosition(195, 130)
	node_bottom:setContentSize(390, 250)
	node_bottom:setAnchorPoint(cc.p(0.5, 0.5))
	node_bottom:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 0, 10, 0, false)
	ly.node = node_bottom
	node_bottom.layoutex = ly
	self:addLyt(ly)
	spr_bg:addChild(node_bottom)
	self.node_bottom = node_bottom

	local l = cc.Node:create()
	l:setPosition(195, 240)
	l:setContentSize(0, 20)
	l:setAnchorPoint(cc.p(0.5, 0.5))
	l:setIgnoreAnchorPointForPosition(false)
	node_bottom:addChild(l)
	self.l = l

	local x = cc.Sprite:create()
	x:setPosition(0, 17.07)
	x:setContentSize(380, 2)
	self:addLoadRes(2, x, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-line.png")
	l:addChild(x)
	self.x = x

	local menu_wear = cpp.UIMenu:create()
	menu_wear:setPosition(195, 175)
	menu_wear:setContentSize(390, 110)
	menu_wear:setAnchorPoint(cc.p(0.5, 0.5))
	menu_wear:setIgnoreAnchorPointForPosition(false)
	node_bottom:addChild(menu_wear)
	self.menu_wear = menu_wear

	local btn_strengthen = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_strengthen:setPosition(125, 82.5)
	btn_strengthen:setContentSize(100, 42)
	btn_strengthen:registerScriptTapHandler(handler(self, self.onStrengthen))
	btn_strengthen:getLabel():setTextColor(cc.c4b(102, 54, 34, 255))
	btn_strengthen:setLabelOffset(cc.p(0, 0))
	btn_strengthen:setLabelSize(40)
	btn_strengthen:setLabelText(ex.Tools:getLang(57106))
	self:addLoadRes(3, btn_strengthen, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-small-1.png"})
	menu_wear:addChild(btn_strengthen)
	self.btn_strengthen = btn_strengthen

	local btn_refine = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_refine:setPosition(265, 82.5)
	btn_refine:setContentSize(100, 42)
	btn_refine:registerScriptTapHandler(handler(self, self.onRefine))
	btn_refine:getLabel():setTextColor(cc.c4b(102, 54, 34, 255))
	btn_refine:setLabelOffset(cc.p(0, 0))
	btn_refine:setLabelSize(40)
	btn_refine:setLabelText(ex.Tools:getLang(47618))
	self:addLoadRes(3, btn_refine, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-small-1.png"})
	menu_wear:addChild(btn_refine)
	self.btn_refine = btn_refine

	local btn_takeoff = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_takeoff:setPosition(125, 27.5)
	btn_takeoff:setContentSize(100, 42)
	btn_takeoff:registerScriptTapHandler(handler(self, self.onTakeOff))
	btn_takeoff:getLabel():setTextColor(cc.c4b(102, 54, 34, 255))
	btn_takeoff:setLabelOffset(cc.p(0, 0))
	btn_takeoff:setLabelSize(40)
	btn_takeoff:setLabelText(ex.Tools:getLang(47622))
	self:addLoadRes(3, btn_takeoff, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-small-1.png"})
	menu_wear:addChild(btn_takeoff)
	self.btn_takeoff = btn_takeoff

	local btn_replace = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_replace:setPosition(265, 27.5)
	btn_replace:setContentSize(100, 42)
	btn_replace:registerScriptTapHandler(handler(self, self.onReplace))
	btn_replace:getLabel():setTextColor(cc.c4b(102, 54, 34, 255))
	btn_replace:setLabelOffset(cc.p(0, 0))
	btn_replace:setLabelSize(40)
	btn_replace:setLabelText(ex.Tools:getLang(47236))
	self:addLoadRes(3, btn_replace, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-small-1.png"})
	menu_wear:addChild(btn_replace)
	self.btn_replace = btn_replace

	local lbl_desc = cc.Label:createWithTTF(ex.Tools:getLang(75015),FONT_DEFAULT_NAME_BOLD, 18)
	lbl_desc:setPosition(47, 60)
	lbl_desc:setContentSize(300, 22.68)
	lbl_desc:setAnchorPoint(cc.p(0, 0.5))
	lbl_desc:setVisible(false)
	lbl_desc:setTextColor(cc.c3b(255, 229, 191))
	lbl_desc:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_desc:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_desc:setDimensions(300, 0)
	node_bottom:addChild(lbl_desc)
	self.lbl_desc = lbl_desc

	local menu_unwear = cpp.UIMenu:create()
	menu_unwear:setPosition(195, 65)
	menu_unwear:setContentSize(390, 110)
	menu_unwear:setAnchorPoint(cc.p(0.5, 0.5))
	menu_unwear:setIgnoreAnchorPointForPosition(false)
	node_bottom:addChild(menu_unwear)
	self.menu_unwear = menu_unwear

	local btn_strengthen = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_strengthen:setPosition(125, 82.5)
	btn_strengthen:setContentSize(100, 42)
	btn_strengthen:registerScriptTapHandler(handler(self, self.onStrengthen))
	btn_strengthen:getLabel():setTextColor(cc.c4b(102, 54, 34, 255))
	btn_strengthen:setLabelOffset(cc.p(0, 0))
	btn_strengthen:setLabelSize(40)
	btn_strengthen:setLabelText(ex.Tools:getLang(57106))
	self:addLoadRes(3, btn_strengthen, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-small-1.png"})
	menu_unwear:addChild(btn_strengthen)
	self.btn_strengthen = btn_strengthen

	local btn_refine = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_refine:setPosition(265, 82.5)
	btn_refine:setContentSize(100, 42)
	btn_refine:registerScriptTapHandler(handler(self, self.onRefine))
	btn_refine:getLabel():setTextColor(cc.c4b(102, 54, 34, 255))
	btn_refine:setLabelOffset(cc.p(0, 0))
	btn_refine:setLabelSize(40)
	btn_refine:setLabelText(ex.Tools:getLang(47618))
	self:addLoadRes(3, btn_refine, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-small-1.png"})
	menu_unwear:addChild(btn_refine)
	self.btn_refine = btn_refine

	local btn_wear = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_wear:setPosition(125, 27.5)
	btn_wear:setContentSize(100, 42)
	btn_wear:registerScriptTapHandler(handler(self, self.onWear))
	btn_wear:getLabel():setTextColor(cc.c4b(102, 54, 34, 255))
	btn_wear:setLabelOffset(cc.p(0, 0))
	btn_wear:setLabelSize(40)
	btn_wear:setLabelText(ex.Tools:getLang(47326))
	self:addLoadRes(3, btn_wear, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-small-1.png"})
	menu_unwear:addChild(btn_wear)
	self.btn_wear = btn_wear

	local btn_sell = cpp.UIMenuItemLabel:create("", nil, " ", nil)
	btn_sell:setPosition(265, 27.5)
	btn_sell:setContentSize(100, 42)
	btn_sell:registerScriptTapHandler(handler(self, self.onSell))
	btn_sell:getLabel():setTextColor(cc.c4b(102, 54, 34, 255))
	btn_sell:setLabelOffset(cc.p(0, 0))
	btn_sell:setLabelSize(40)
	btn_sell:setLabelText(ex.Tools:getLang(47584))
	self:addLoadRes(3, btn_sell, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-small-1.png"})
	menu_unwear:addChild(btn_sell)
	self.btn_sell = btn_sell

	 self:startLoadRes()
end
return HeroMagicWandInfoLayer