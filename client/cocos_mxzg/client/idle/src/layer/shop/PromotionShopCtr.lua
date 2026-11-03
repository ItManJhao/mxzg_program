local PromotionShopCtr = class("ShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ShopLayer = class("ShopLayer", require("src.layer.shop.ShopLayer"))

function PromotionShopCtr:onCreate()
	self:setCCBIPath("ccbi/LimitShopLayer.ccbi")
	self:setIsSingle(false)
end

function PromotionShopCtr:getLayerClass()
	return ShopLayer
end

function PromotionShopCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function PromotionShopCtr:initData(data)
    local layer = self.layer
	layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	if not data or table.nums(data) <= 0 then 
		ex.MessageView:add(ex.Tools:getLang(47239))
		return 
	end

	layer:updateView(data)
	layer:changeTime()

end

return PromotionShopCtr