local ShopCtr = class("ShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ShopLayer = require("src.layer.ShopLayer")

function ShopCtr:onCreate()
	self:setCCBIPath("ccbi/ShopLayer.ccbi")
	self:setIsSingle(false)
end

function ShopCtr:getLayerClass()
	return ShopLayer
end

function ShopCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initSwallowLayer()
	self:initData()
end

function ShopCtr:initData()
	self.refresh_cost = {}

	local time_callback = nil
	if cfg.shopcontrol.shop.market.show_all == 0 then
		time_callback = function()
			-- 时间到 重置刷新次数
			ex.Player.shop_data.shop_free_refresh = cfg.shopcontrol.shop.market.max_refresh_count
		end

		-- 刷新价值
		self.refresh_cost = cfg.shopcontrol.shop.market.refresh_item_cost[1]
	end

	-- 市 场
	self.layer:initDone(ex.Tools:getLang(41036), 0, ProtocolID.GReqMarketBuy, function(index)
		-- 购买回调
		ex.Player.shop_data:buyShopItem(index)
	end, time_callback)

	self.layer.btn_refresh:registerScriptTapHandler(handler(self, self.onBtnRefresh))
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self:updateLayer()
end

--触摸吞噬
function ShopCtr:initSwallowLayer()
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

function ShopCtr:touchSwallowTouches(is_lock)
    self.touch_layer:setSwallowsTouches(is_lock)
end

function ShopCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	--print("ShopCtr:updateLayer....")

	self:setRefreshNode()

	self.layer:updateShop(ex.Player.shop_data.shop_list, cfg.shopmarket.shopmarket)

	self:touchSwallowTouches(false)
end

function ShopCtr:setRefreshNode()
	if cfg.shopcontrol.shop.market.show_all ~= 0 then
		return
	end

	self.layer:setRefreshNode(self.refresh_cost, ex.Player.shop_data.shop_refresh_num,
		ex.Tools:getSysCfg("market_refresh_max"),
		ex.Player.shop_data.shop_free_refresh, 
		cfg.shopcontrol.shop.market.max_refresh_count)
end

function ShopCtr:onBtnRefresh(tag, pSender)
	if ex.Player.shop_data.shop_refresh_num >= ex.Tools:getSysCfg("market_refresh_max") then
		ex.MessageView:add(ex.Tools:getLang(47071))
		return
	end

	local hasNum = ex.Player:getItemNum(self.refresh_cost.item_type)

	if ex.Player.shop_data.shop_free_refresh < 1 and hasNum < self.refresh_cost.item_num then
        ex.MessageView:add(string.format(ex.Tools:getLang(1108),
            ex.Tools:getLang(self.refresh_cost.item_type)))
        return
    end

    if ex.Player.shop_data.shop_free_refresh > 0 then
        ex.Player.shop_data.shop_free_refresh = ex.Player.shop_data.shop_free_refresh - 1
        --print(ex.Tools:getLang(47667))
    else
        -- 扣除刷新消耗
        -- ex.Player:addItem(self.refresh_cost.item_type, -self.refresh_cost.item_num)
        self.layer:setItemNum()
    end

    self:setRefreshNode()
    
    self:touchSwallowTouches(true)

	-- 发送刷新协议
    local req_refresh = cpp.ByteArray:create()
    req_refresh:writeInt(ProtocolID.GReqMarketList)
    req_refresh:writeInt(1)
    cpp.NetManager:instance():sendByteArray(req_refresh)
end


return ShopCtr
