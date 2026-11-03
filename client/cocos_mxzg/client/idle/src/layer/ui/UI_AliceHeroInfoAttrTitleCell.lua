local AliceHeroInfoAttrTitleCell = class("AliceHeroInfoAttrTitleCell", require("src.comp.CCCLayerBase")) 

function AliceHeroInfoAttrTitleCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(195, 40)
	self:setContentSize(390, 40)
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:setIgnoreAnchorPointForPosition(false)
	local sl = cc.Sprite:create()
	sl:setPosition(150, 20)
	sl:setContentSize(148, 16)
	sl:setScale(0.9, 0.9)
	sl:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(2, sl, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-parttern-2.png")
	self:addChild(sl)
	self.sl = sl

	local sr = cc.Sprite:create()
	sr:setPosition(240, 20)
	sr:setContentSize(148, 16)
	sr:setScale(-0.9, 0.9)
	sr:setAnchorPoint(cc.p(1, 0.5))
	self:addLoadRes(2, sr, "ccbi-res/hero-hexagram.plist", "ccbi-res/hero-hexagram.pvr.ccz", "hero-hexagram/spr-parttern-2.png")
	self:addChild(sr)
	self.sr = sr

	local lbl_title = cc.Label:createWithTTF("国战属性",FONT_DEFAULT_NAME_BOLD, 18)
	lbl_title:setPosition(195, 20)
	lbl_title:setContentSize(72, 22.68)
	lbl_title:setTextColor(cc.c3b(255, 224, 178))
	lbl_title:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lbl_title:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	self:addChild(lbl_title)
	self.lbl_title = lbl_title

	local menu = cpp.UIMenu:create()
	menu:setPosition(195, 20)
	menu:setContentSize(0, 0)
	menu:setAnchorPoint(cc.p(0.5, 0.5))
	menu:setIgnoreAnchorPointForPosition(false)
	self:addChild(menu)
	self.menu = menu

	local btn_info = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_info:setPosition(171.18, 0)
	btn_info:setContentSize(60, 61)
	btn_info:setScale(0.7, 0.7)
	btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	self:addLoadRes(3, btn_info, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {spr1="button/btn-info-2.png"})
	menu:addChild(btn_info)
	self.btn_info = btn_info

	 self:startLoadRes()
end
return AliceHeroInfoAttrTitleCell