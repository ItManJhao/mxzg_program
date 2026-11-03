local RCGBaseLayer = class("RCGBaseLayer", require("src.layer.promotion.PromotionBaseLayer"))

function RCGBaseLayer:addVipExpCell(y)
	if y == nil then
		local top_y = self.layer_promotion:getTopY()
		y = top_y - 20 - 126
	end
	
	local win_size = cc.Director:getInstance():getWinSize()
	local cell = require("src.layer.promotion.RCGVipCell"):createWithCCBIFile("ccbi/RCGVipCell.ccbi")
	cell:setPosition(win_size.width * 0.5 - cell:getContentSize().width * 0.5, y)
	self:addChild(cell)
	return cell
end

return RCGBaseLayer