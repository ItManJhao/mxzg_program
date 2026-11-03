local HeroMagicWandAttrPreviewLayer = class("HeroMagicWandAttrPreviewLayer", require("src.comp.CCCLayerBase")) 

function HeroMagicWandAttrPreviewLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(390, 145)
	self:setAnchorPoint(cc.p(0, 0))
	self:resetScaleAtWidth(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 0, 0, 0, false)
	ly.node = self
	self.layoutex = ly
	self:addLyt(ly)
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(390, 145)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-24.png", capInsets = cc.rect(16,16,14,15)})
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 10, 15, 0, false)
	ly.node = spr_bg
	spr_bg.layoutex = ly
	self:addLyt(ly)
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local node_title = cc.Node:create()
	node_title:setPosition(195, 115)
	node_title:setContentSize(0, 40)
	node_title:setAnchorPoint(cc.p(0.5, 0.5))
	node_title:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(node_title)
	self.node_title = node_title

	local lbl_title = cc.Label:createWithTTF(ex.Tools:getLang(57189),FONT_DEFAULT_NAME_BOLD, 22)
	lbl_title:setPosition(0, 20)
	lbl_title:setContentSize(132, 27.72)
	lbl_title:setTextColor(cc.c3b(252, 241, 208))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	node_title:addChild(lbl_title)
	self.lbl_title = lbl_title

	local node_attr1 = cc.Node:create()
	node_attr1:setPosition(26.99, 75)
	node_attr1:setContentSize(0, 40)
	node_attr1:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr1:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(node_attr1)
	self.node_attr1 = node_attr1

	local s = cc.Sprite:create()
	s:setPosition(9.54, 20)
	s:setContentSize(150, 29)
	s:setScale(2.1, 1)
	s:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, s, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-dark.png")
	node_attr1:addChild(s)
	self.s = s

	local spr_attr1 = cc.Sprite:create()
	spr_attr1:setPosition(12.9, 20)
	spr_attr1:setContentSize(48, 48)
	spr_attr1:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_attr1, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-201.png")
	node_attr1:addChild(spr_attr1)
	self.spr_attr1 = spr_attr1

	local lbl_attr1 = cc.Label:createWithTTF("属性1",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr1:setPosition(37.34, 20)
	lbl_attr1:setContentSize(180, 25.2)
	lbl_attr1:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr1:setTextColor(cc.c3b(252, 241, 208))
	lbl_attr1:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr1:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr1:setDimensions(180, 0)
	node_attr1:addChild(lbl_attr1)
	self.lbl_attr1 = lbl_attr1

	local node_attr2 = cc.Node:create()
	node_attr2:setPosition(26.99, 35)
	node_attr2:setContentSize(0, 40)
	node_attr2:setAnchorPoint(cc.p(0.5, 0.5))
	node_attr2:setIgnoreAnchorPointForPosition(false)
	spr_bg:addChild(node_attr2)
	self.node_attr2 = node_attr2

	local s = cc.Sprite:create()
	s:setPosition(9.54, 20)
	s:setContentSize(150, 29)
	s:setScale(2.1, 1)
	s:setAnchorPoint(cc.p(0, 0.5))
	self:addLoadRes(2, s, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-dark.png")
	node_attr2:addChild(s)
	self.s = s

	local spr_attr2 = cc.Sprite:create()
	spr_attr2:setPosition(12.9, 20)
	spr_attr2:setContentSize(48, 48)
	spr_attr2:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_attr2, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-201.png")
	node_attr2:addChild(spr_attr2)
	self.spr_attr2 = spr_attr2

	local lbl_attr2 = cc.Label:createWithTTF("属性1",FONT_DEFAULT_NAME_BOLD, 20)
	lbl_attr2:setPosition(37.34, 20)
	lbl_attr2:setContentSize(180, 25.2)
	lbl_attr2:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr2:setTextColor(cc.c3b(252, 241, 208))
	lbl_attr2:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr2:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	lbl_attr2:setDimensions(180, 0)
	node_attr2:addChild(lbl_attr2)
	self.lbl_attr2 = lbl_attr2

	 self:startLoadRes()
end
return HeroMagicWandAttrPreviewLayer