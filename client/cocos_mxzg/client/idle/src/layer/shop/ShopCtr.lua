

local ShopCtr = class("ShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
--local ShopLayer = class("ShopLayer", require("src.comp.EventLayer"))
local ShopLayer = class("ShopLayer", require("src.layer.shop.ShopLayer"))

function ShopCtr:onCreate()
	self:setCCBIPath("ccbi/ShopLayer.ccbi")
	self:setIsSingle(false)
end

function ShopCtr:getLayerClass()
	return ShopLayer
end

function ShopCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function ShopCtr:initData(data)
    local layer = self.layer
	layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	if not data or table.nums(data) <= 0 then 
		ex.MessageView:add(ex.Tools:getLang(47239))
		return 
	end

	layer:updateView(data)
	layer:changeTime()
end

return ShopCtr