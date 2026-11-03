local HeroInfoSettingLayer = class("HeroInfoSettingLayer", require("src.comp.CCCLayerBase")) 

function HeroInfoSettingLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(182, 182)
	self:setAnchorPoint(cc.p(0, -0.02))
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, -3.64)
	spr_bg:setContentSize(182, 182)
	spr_bg:setAnchorPoint(cc.p(0, -0.02))
	self:addLoadRes(1, spr_bg, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {frame = "hero-info-2/bg-tck.png", capInsets = cc.rect(13,15,15,14)})
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	local CCMenu = cpp.UIMenu:create()
	CCMenu:setPosition(10, 9.96)
	CCMenu:setContentSize(162, 162)
	local ly = require("src.comp.UILayoutEx"):create()
	spr_bg:addChild(CCMenu)

	local btn_comment = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_comment:setPosition(41, 41)
	btn_comment:setContentSize(52, 52)
	btn_comment:registerScriptTapHandler(handler(self, self.onComment))
	self:addLoadRes(3, btn_comment, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-pinglun.png"})
	CCMenu:addChild(btn_comment)
	self.btn_comment = btn_comment

	local label = cc.Label:createWithTTF(ex.Tools:getLang(4601),FONT_DEFAULT_NAME_BOLD, 22)
	label:setPosition(26, 5.79)
	label:setContentSize(46, 29.72)
	label:setLocalZOrder(2)
	label:setTextColor(cc.c3b(255, 255, 255))
	label:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_comment:addChild(label)

	local btn_share = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_share:setPosition(121, 41)
	btn_share:setContentSize(52, 52)
	btn_share:registerScriptTapHandler(handler(self, self.onShare))
	self:addLoadRes(3, btn_share, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-fenxiang.png"})
	CCMenu:addChild(btn_share)
	self.btn_share = btn_share

	local label = cc.Label:createWithTTF(ex.Tools:getLang(2124),FONT_DEFAULT_NAME_BOLD, 22)
	label:setPosition(26, 5.79)
	label:setContentSize(46, 29.72)
	label:setLocalZOrder(1)
	label:setTextColor(cc.c3b(255, 255, 255))
	label:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_share:addChild(label)

	local btn_lock = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_lock:setPosition(41, 121)
	btn_lock:setContentSize(52, 52)
	btn_lock:registerScriptTapHandler(handler(self, self.onLock))
	self:addLoadRes(3, btn_lock, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-ssuoding.png"})
	CCMenu:addChild(btn_lock)
	self.btn_lock = btn_lock

	local spr_lock_mask1 = cc.Sprite:create()
	spr_lock_mask1:setPosition(26, 26)
	spr_lock_mask1:setContentSize(48, 48)
	spr_lock_mask1:setOpacity(175)
	spr_lock_mask1:setLocalZOrder(1)
	self:addLoadRes(2, spr_lock_mask1, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/btn-mask.png")
	btn_lock:addChild(spr_lock_mask1)
	self.spr_lock_mask1 = spr_lock_mask1

	local label = cc.Label:createWithTTF(ex.Tools:getLang(2123),FONT_DEFAULT_NAME_BOLD, 22)
	label:setPosition(26, 5.79)
	label:setContentSize(46, 29.72)
	label:setLocalZOrder(2)
	label:setTextColor(cc.c3b(255, 255, 255))
	label:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_lock:addChild(label)

	local btn_unlock = cpp.UIMenuItemImage:createWithSpriteFrameName("", nil, nil)
	btn_unlock:setPosition(121, 121)
	btn_unlock:setContentSize(52, 52)
	btn_unlock:registerScriptTapHandler(handler(self, self.onUnlock))
	self:addLoadRes(3, btn_unlock, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", {spr1="hero-info-2/btn-jiesuo.png"})
	CCMenu:addChild(btn_unlock)
	self.btn_unlock = btn_unlock

	local spr_lock_mask2 = cc.Sprite:create()
	spr_lock_mask2:setPosition(26, 26)
	spr_lock_mask2:setContentSize(48, 48)
	spr_lock_mask2:setOpacity(175)
	spr_lock_mask2:setLocalZOrder(1)
	self:addLoadRes(2, spr_lock_mask2, "ccbi-res/hero-info-2.plist", "ccbi-res/hero-info-2.pvr.ccz", "hero-info-2/btn-mask.png")
	btn_unlock:addChild(spr_lock_mask2)
	self.spr_lock_mask2 = spr_lock_mask2

	local label = cc.Label:createWithTTF(ex.Tools:getLang(5288),FONT_DEFAULT_NAME_BOLD, 22)
	label:setPosition(26, 5.79)
	label:setContentSize(46, 29.72)
	label:setLocalZOrder(1)
	label:setTextColor(cc.c3b(255, 255, 255))
	label:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	label:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
	label:enableOutline(cc.c4b(74,41,33,255), 1)
	btn_unlock:addChild(label)

	 self:startLoadRes()
end
return HeroInfoSettingLayer