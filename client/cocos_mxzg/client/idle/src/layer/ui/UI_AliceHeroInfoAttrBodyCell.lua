local AliceHeroInfoAttrBodyCell = class("AliceHeroInfoAttrBodyCell", require("src.comp.CCCLayerBase")) 

function AliceHeroInfoAttrBodyCell:onCreate() 
	 local sfc = cc.SpriteFrameCache:getInstance()
	self:setPosition(165, 40)
	self:setContentSize(400, 0)
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:setIgnoreAnchorPointForPosition(false)
	local ly = require("src.comp.UILayoutEx"):create()
	ly:setType(UILayout.Type.GRID)
	ly:setResizeMode(UILayout.ResizeMode.CONTAINER)
	ly:setAffectedByScale(false)
	ly:setVerticalDirection(UILayout.Direction.TTOB)
	ly:setHorizontalDirection(UILayout.Direction.LTOR)
	ly:setPaddingLeft(0)
	ly:setPaddingRight(0)
	ly:setPaddingTop(0)
	ly:setPaddingBottom(0)
	ly:setSpaceX(0)
	ly:setSpaceY(0)
	ly.node = self
	self.layoutex = ly
	self:addLyt(ly)
	 self:startLoadRes()
end
return AliceHeroInfoAttrBodyCell