local AliceHeroInfoAttrLayer = class("AliceHeroInfoAttrLayer", require("src.comp.CCCLayerBase")) 

function AliceHeroInfoAttrLayer:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(0, 0)
	self:setContentSize(390, 360)
	self:setAnchorPoint(cc.p(0, 0))
	self:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 0, 0, 0, false)
	ly.node = self
	self.layoutex = ly
	self:addLyt(ly)
	local spr_bg = cc.Node:create()
	spr_bg:setPosition(0, 180)
	spr_bg:setContentSize(460, 360)
	spr_bg:setAnchorPoint(cc.p(0.5, 0.5))
	spr_bg:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setLayoutType(UILayout.Type.VERTICAL, UILayout.ResizeMode.CONTAINER, UILayout.Direction.TTOB, 6, 10, 0, false)
	ly.node = spr_bg
	spr_bg.layoutex = ly
	self:addLyt(ly)
	self:addChild(spr_bg)
	self.spr_bg = spr_bg

	 self:startLoadRes()
end
return AliceHeroInfoAttrLayer