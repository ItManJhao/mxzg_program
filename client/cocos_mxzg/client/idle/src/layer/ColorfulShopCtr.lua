local ColorfulShopCtr = class("AltarShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ShopLayer = require("src.layer.shop.PromotionShopLayer")

function ColorfulShopCtr:onCreate()
	self:setCCBIPath("ccbi/LimitShopLayer.ccbi")
	self:setIsSingle(false)

	self.promotion_id = 44
end

function ColorfulShopCtr:getLayerClass()
	return ShopLayer
end

function ColorfulShopCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initSwallowLayer()
	self:initData()
end

function ColorfulShopCtr:initData()
	self.refresh_cost = {}

	local time_callback = nil

	self.layer:initDone(ex.Tools:getLang(47312), ItemType.IT_COLORFUL, ProtocolID.GReqColourfulShopReward, function(index, num)
		if not ex.Player.promotion_data:getTimeIsOpen(self.promotion_id) then
			ex.MessageView:add(ex.Tools:getLang(47324))
			return
		end

		local req = Promotion044_pb.GReqColourfulShopReward()
		req.idx = index
		req.num = num
		NetManager:sendMessage(ProtocolID.GReqColourfulShopReward, req)
	end, time_callback)

	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self:updateLayer()
end

--触摸吞噬
function ColorfulShopCtr:initSwallowLayer()
    self.touch_layer = cc.Layer:create()
    self.touch_layer:setTouchEnabled(true)
    self.touch_layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.touch_layer:registerScriptTouchHandler(function(event)
        if event == "began" then
            return true
        end
    end)
    self.layer:addChild(self.touch_layer, 100)
end

function ColorfulShopCtr:touchSwallowTouches(is_lock)
    self.touch_layer:setSwallowsTouches(is_lock)
end

function ColorfulShopCtr:updateLayer()
	if not self:getLayer() then
		return
	end
	local list = {}
	for k,v in pairs(cfg.promotioncolourfulshops.promotioncolourfulshops) do
		local data = {}
		data.index = v.idx
		
		data.goods = {}
		data.goods.item_type = v.item[1].item_type
		data.goods.item_num = v.item[1].item_num
		
		data.need = {}
		data.need.item_type = v.cost[1].item_type
		data.need.item_num = v.cost[1].item_num
		
		data.limit = {}
		data.limit.count = v.limit
		data.limit.times = ex.Player.promotion_data:getColorfulBoughtTimes(v.idx)
		
		data.seting = {}
		data.seting.mark_icon = v.mark_icon
		data.seting.show_mark = v.show_mark
		
		table.insert(list, data)
	end
	
	table.sort( list, function (a,b) 
		return a.index < b.index
	end)

	self.layer:updateShop(list)

	self:touchSwallowTouches(false)
end

return ColorfulShopCtr
