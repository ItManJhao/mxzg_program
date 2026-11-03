local RCGGrowthCell = class("RCGGrowthCell", require("src.comp.EventLayer"))

function RCGGrowthCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self:setAnchorPoint(0, 0)
	self.menu:setSwallowsTouches(false)
	-- self.btn_buy:setLabelSize(45)
	-- self.btn_buy:setLabelColor(FONT_BLACK)
end

return RCGGrowthCell