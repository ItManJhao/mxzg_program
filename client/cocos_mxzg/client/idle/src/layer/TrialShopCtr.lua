local TrialShopCtr = class("TrialShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ShopLayer = require("src.layer.ShopLayer")

function TrialShopCtr:onCreate()
	self:setCCBIPath("ccbi/ShopLayer.ccbi")
	self:setIsSingle(false)
end

function TrialShopCtr:getLayerClass()
	return ShopLayer
end

function TrialShopCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initSwallowLayer()
	self:initData()
end

function TrialShopCtr:initData()
	self.refresh_cost = {}

	local time_callback = nil
	if cfg.shopcontrol.shop.adventure.show_all == 0 then
		time_callback = function()
			-- 时间到 重置刷新次数
			ex.Player.trial_data.shop_free_refresh = cfg.shopcontrol.shop.adventure.max_refresh_count
		end

		-- 刷新价值
		self.refresh_cost = cfg.shopcontrol.shop.adventure.refresh_item_cost[1]
	end

	-- 试炼商城
	self.layer:initDone(ex.Tools:getLang(41034), ItemType.IT_ADVENTURE, ProtocolID.GReqAdventureShopBuy, function(index)
		-- 购买回调
		ex.Player.trial_data:buyShopItem(index)
	end, time_callback)

	self:setRefreshNode()

	self.layer.btn_refresh:registerScriptTapHandler(handler(self, self.onBtnRefresh))
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self:updateLayer()
end

--触摸吞噬
function TrialShopCtr:initSwallowLayer()
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

function TrialShopCtr:touchSwallowTouches(is_lock)
    self.touch_layer:setSwallowsTouches(is_lock)
end

function TrialShopCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	--print("TrialShopCtr:updateLayer....")

	self.layer:updateShop(ex.Player.trial_data.shop_list)

	self:touchSwallowTouches(false)
end

function TrialShopCtr:setRefreshNode()
	if cfg.shopcontrol.shop.adventure.show_all ~= 0 then
		return
	end

	self.layer:setRefreshNode(self.refresh_cost, 0, 0,
		ex.Player.trial_data.shop_free_refresh, 
		cfg.shopcontrol.shop.adventure.max_refresh_count)
end

function TrialShopCtr:onBtnRefresh(tag, pSender)
	local hasNum = ex.Player:getItemNum(self.refresh_cost.item_type)

	if ex.Player.trial_data.shop_free_refresh < 1 and hasNum < self.refresh_cost.item_num then
        ex.MessageView:add(string.format(ex.Tools:getLang(1108),
            ex.Tools:getLang(self.refresh_cost.item_type)))
        return
    end

    if ex.Player.trial_data.shop_free_refresh > 0 then
        ex.Player.trial_data.shop_free_refresh = ex.Player.trial_data.shop_free_refresh - 1
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
    req_refresh:writeInt(ProtocolID.GReqAdventureShopList)
    req_refresh:writeInt(1)
    cpp.NetManager:instance():sendByteArray(req_refresh)
end



return TrialShopCtr
