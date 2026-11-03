local AliceHeroInfoAttrCell = class("AliceHeroInfoAttrCell", require("src.comp.CCCLayerBase")) 

function AliceHeroInfoAttrCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(165, 40)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local s = cc.Sprite:create()
	s:setPosition(88.47, 20)
	s:setContentSize(150, 29)
	self:addLoadRes(2, s, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-dark.png")
	self:addChild(s)
	self.s = s

	local spr_attr = cc.Sprite:create()
	spr_attr:setPosition(12.9, 20)
	spr_attr:setContentSize(48, 48)
	spr_attr:setScale(0.6, 0.6)
	self:addLoadRes(2, spr_attr, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/spr-attribute-201.png")
	self:addChild(spr_attr)
	self.spr_attr = spr_attr

	local lbl_attr = cc.Label:createWithTTF(ex.Tools:getLang(57203),FONT_DEFAULT_NAME_BOLD, 18)
	lbl_attr:setPosition(29.79, 20)
	lbl_attr:setContentSize(36, 22.68)
	lbl_attr:setAnchorPoint(cc.p(0, 0.5))
	lbl_attr:setTextColor(cc.c3b(255, 224, 178))
	lbl_attr:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_attr:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_attr)
	self.lbl_attr = lbl_attr

	local lbl_value = cc.Label:createWithTTF(ex.Tools:getLang(57203),FONT_DEFAULT_NAME_BOLD, 18)
	lbl_value:setPosition(153.06, 20)
	lbl_value:setContentSize(34.45, 22.68)
	lbl_value:setAnchorPoint(cc.p(1, 0.5))
	lbl_value:setTextColor(cc.c3b(255, 224, 178))
	lbl_value:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_value:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_value)
	self.lbl_value = lbl_value

	 self:startLoadRes()
end
return AliceHeroInfoAttrCell