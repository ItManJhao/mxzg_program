local HeroMagicWandPreviewLayer = class("HeroMagicWandPreviewLayer", require("src.comp.CCCLayerBase")) 

function HeroMagicWandPreviewLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(390, 218.72)
	self:setAnchorPoint(cc.p(0, 0))
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 0, 0, 0, false)
	ly.node = self
	self.layoutex = ly
	self:addLyt(ly)
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(390, 218.72)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-24.png", capInsets = cc.rect(16,16,14,15)})
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 6, 10, 0, false)
	ly.node = spr_bg
	spr_bg.layoutex = ly
	self:addLyt(ly)
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local menu = cpp.UIMenu:create()
	menu:setPosition(390, 212.72)
	menu:setContentSize(0, 0)
	menu:setLocalZOrder(1)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	local lyt = ccui.LayoutComponent:bindLayoutComponent(menu)
	lyt:setRightMargin(0)
	lyt:setHorizontalEdge(2)
	lyt:setTopMargin(6)
	lyt:setVerticalEdge(2)
	self:addLyt(lyt)
	menu.lyt = lyt
	spr_bg:addChild(menu)
	self.menu = menu

	local btn_close = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_close:setPosition(-45.53, 7.75)
	btn_close:setContentSize(53, 56)
	btn_close:setScale(0.8, 0.8)
	btn_close:setAnchorPoint(cc.p(0.5, 1))
	btn_close:registerScriptTapHandler(handler(self, self.onClose))
	self:addLoadRes(3, btn_close, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-close-1.png", spr2="button/btn-close-1.png"})
	menu:addChild(btn_close)
	self.btn_close = btn_close

	local x = cc.Node:create()
	x:setPosition(195, 182.72)
	x:setContentSize(390, 60)
	x:setAnchorPoint(cc.p(0.5, 0.5))
	x:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(x)
	self.x = x

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57203),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(195, 30)
	lbl_title:setContentSize(88, 27.72)
	lbl_title:setTextColor(cc.c3b(255, 224, 178))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	x:addChild(lbl_title)
	self.lbl_title = lbl_title

	local x = cc.Node:create()
	x:setPosition(195, 112.72)
	x:setContentSize(390, 80)
	x:setAnchorPoint(cc.p(0.5, 0.5))
	x:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(x)
	self.x = x

	local s = cc.Sprite:create()
	s:setPosition(31.61, 59.43)
	s:setContentSize(150, 27)
	s:setScale(2.2, 1)
	s:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, s, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-dark.png")
	x:addChild(s)
	self.s = s

	local spr_attr1 = cc.Sprite:create()
	spr_attr1:setPosition(38.12, 59.43)
	spr_attr1:setContentSize(46, 46)
	spr_attr1:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_attr1, "ccbi-res/hero-info.plist", "ccbi-res/hero-info.pvr.ccz", "hero-info/spr-attr-4.png")
	x:addChild(spr_attr1)
	self.spr_attr1 = spr_attr1

	local lbl_add1 = cc.Label:createWithTTF("国战属性",FONT_DEFAULT_NAME_BOLD, 16)
	lbl_add1:setPosition(350.42, 59.72)
	lbl_add1:setContentSize(64, 20.16)
	lbl_add1:setAnchorPoint(cc.p(1, 0.5))
	lbl_add1:setTextColor(cc.c3b(255, 224, 178))
	lbl_add1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	x:addChild(lbl_add1)
	self.lbl_add1 = lbl_add1

	local lbl_attr1 = cc.Label:createWithTTF("国战属性",FONT_DEFAULT_NAME_BOLD, 16)
	lbl_attr1:setPosition(54.5, 59.72)
	lbl_attr1:setContentSize(64, 20.16)
	lbl_attr1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr1:setTextColor(cc.c3b(255, 224, 178))
	lbl_attr1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	x:addChild(lbl_attr1)
	self.lbl_attr1 = lbl_attr1

	local s = cc.Sprite:create()
	s:setPosition(31.61, 19.57)
	s:setContentSize(150, 27)
	s:setScale(2.2, 1)
	s:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, s, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-dark.png")
	x:addChild(s)
	self.s = s

	local spr_attr2 = cc.Sprite:create()
	spr_attr2:setPosition(38.12, 19.57)
	spr_attr2:setContentSize(46, 46)
	spr_attr2:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_attr2, "ccbi-res/hero-info.plist", "ccbi-res/hero-info.pvr.ccz", "hero-info/spr-attr-4.png")
	x:addChild(spr_attr2)
	self.spr_attr2 = spr_attr2

	local lbl_attr2 = cc.Label:createWithTTF("国战属性",FONT_DEFAULT_NAME_BOLD, 16)
	lbl_attr2:setPosition(54.5, 19.57)
	lbl_attr2:setContentSize(64, 20.16)
	lbl_attr2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr2:setTextColor(cc.c3b(255, 224, 178))
	lbl_attr2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	x:addChild(lbl_attr2)
	self.lbl_attr2 = lbl_attr2

	local lbl_add2 = cc.Label:createWithTTF("国战属性",FONT_DEFAULT_NAME_BOLD, 16)
	lbl_add2:setPosition(350.42, 19.57)
	lbl_add2:setContentSize(64, 20.16)
	lbl_add2:setAnchorPoint(cc.p(1, 0.5))
	lbl_add2:setTextColor(cc.c3b(255, 224, 178))
	lbl_add2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_add2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	x:addChild(lbl_add2)
	self.lbl_add2 = lbl_add2

	local x = cc.Node:create()
	x:setPosition(195, 57.72)
	x:setContentSize(390, 30)
	x:setAnchorPoint(cc.p(0.5, 0.5))
	x:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(x)
	self.x = x

	local s = cc.Sprite:create()
	s:setPosition(195, 15)
	s:setContentSize(380, 2)
	self:addLoadRes(2, s, "ccbi-res/backpack-info.plist", "ccbi-res/backpack-info.pvr.ccz", "backpack-info/spr-line.png")
	x:addChild(s)
	self.s = s

	local x = cc.Node:create()
	x:setPosition(195, 40.22)
	x:setContentSize(390, 5)
	x:setAnchorPoint(cc.p(0.5, 0.5))
	x:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(x)
	self.x = x

	local lbl_tip = cpp.RichTextEx:createWithXMLLua("")
	lbl_tip:setPosition(25.32, 37.72)
	lbl_tip:setAnchorPoint(cc.p(0, 1))
	lbl_tip:setFontFace(FONT_DEFAULT_NAME_BOLD)
	lbl_tip:setFontSize(18)
	lbl_tip:setFontColor("#ffffff")
	lbl_tip:setAnchorTextShadow(true)
	lbl_tip:ignoreContentAdaptWithSize(false)
	lbl_tip:setWrapMode(1)
	lbl_tip:setContentSize(cc.size(330, 0))
	spr_bg:addChild(lbl_tip)
	self.lbl_tip = lbl_tip

	 self:startLoadRes()
end
return HeroMagicWandPreviewLayer