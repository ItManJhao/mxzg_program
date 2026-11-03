local TimeExchangeShopCtr = class("TimeExchangeShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ShopLayer = require("src.layer.shop.PromotionShopLayer")

function TimeExchangeShopCtr:onCreate()
	self:setCCBIPath("ccbi/LimitShopLayer.ccbi")
	self:setIsSingle(false)


end

function TimeExchangeShopCtr:getLayerClass()
	return ShopLayer
end

function TimeExchangeShopCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function TimeExchangeShopCtr:initData()
	self.refresh_cost = {}

	local time_callback = nil	
	self.layer:initDone(ex.Tools:getLang(47312), ItemType.IT_TIME_EXCHANGE, ProtocolID.GReqExchangeBuy, function(index, num)
		local req = Promotion016_pb.GReqExchangeBuy()
		req.idx = index
		req.num = num
		NetManager:sendMessage(ProtocolID.GReqExchangeBuy, req)
	end, time_callback)

	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self:updateLayer()
end


function TimeExchangeShopCtr:updateLayer()
	if not self:getLayer() then
		return
	end
	local list = ex.Player.promotion_data.time_exchange_data.list
	table.sort( list, function (a,b) 
		return a.index < b.index
	end)
	self.layer:updateShop(list)

end

return TimeExchangeShopCtr
