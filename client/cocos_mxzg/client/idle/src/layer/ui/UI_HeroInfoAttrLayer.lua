local HeroInfoAttrLayer = class("HeroInfoAttrLayer", require("src.comp.CCCLayerBase")) 

function HeroInfoAttrLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(390, 16)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 0, 0, 0, false)
	ly.node = self
	self.layoutex = ly
	self:addLyt(ly)
	local spr_bg = cc.Scale9Sprite:create()
	spr_bg:setPosition(0, 0)
	spr_bg:setContentSize(390, 16)
	spr_bg:setAnchorPoint(cc.p(0, 0))
	self:addLoadRes(1, spr_bg, "ccbi-res/common-ui-2.plist", "ccbi-res/common-ui-2.pvr.ccz", {frame = "win-bg/block-bg-24.png", capInsets = cc.rect(16,16,14,15)})
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 6, 10, 0, false)
	ly.node = spr_bg
	spr_bg.layoutex = ly
	self:addLyt(ly)
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	 self:startLoadRes()
end
return HeroInfoAttrLayer