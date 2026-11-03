local AltarShopCtr = class("AltarShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ShopLayer = require("src.layer.ShopLayer")

function AltarShopCtr:onCreate()
	self:setCCBIPath("ccbi/ShopLayer.ccbi")
	self:setIsSingle(false)
end

function AltarShopCtr:getLayerClass()
	return ShopLayer
end
 
function AltarShopCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initSwallowLayer()
	self:initData()
end

function AltarShopCtr:initData()
	self.refresh_cost = {}

	local time_callback = nil
	if cfg.shopcontrol.shop.sacrifice.show_all == 0 then
		time_callback = function()
			-- 时间到 重置刷新次数
			ex.Player.altar_data.shop_free_refresh = cfg.shopcontrol.shop.sacrifice.max_refresh_count
		end

		-- 刷新价值
		self.refresh_cost = cfg.shopcontrol.shop.sacrifice.refresh_item_cost[1]
	end

	-- 祭坛商城
	self.layer:initDone(ex.Tools:getLang(41032), ItemType.IT_ALTAR_SHOP, ProtocolID.GReqAltarShopBuy, function(index)
		-- 购买回调
		ex.Player.altar_data:buyShopItem(index)
	end, time_callback)

	self:setRefreshNode()

	self.layer.btn_refresh:registerScriptTapHandler(handler(self, self.onBtnRefresh))
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self:updateLayer()
end

--触摸吞噬
function AltarShopCtr:initSwallowLayer()
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

function AltarShopCtr:touchSwallowTouches(is_lock)
    self.touch_layer:setSwallowsTouches(is_lock)
end

function AltarShopCtr:updateLayer()
	if not self:getLayer() then
		return
	end
	local getShopLimitItem = {}
	if ex.Player.promotion_data:checkAlterHeroIsOpen() then 
		getShopLimitItem = ex.Player.altar_data:getLimitShop()
	end	

	local show_shop_list = {}
	for k,data in pairs(ex.Player.altar_data.shop_list) do
		local nowdata = {}
		nowdata.index = data.index 

		nowdata.goods = {}
		nowdata.goods.item_id = data.goods.item_id 
		nowdata.goods.item_type  = data.goods.item_type 
		nowdata.goods.item_num  = data.goods.item_num 

		nowdata.need = {}
		nowdata.need.item_type = data.need.item_type 
		nowdata.need.item_num = data.need.item_num 

		nowdata.limit = {}
		nowdata.limit.count = data.limit.count 
		nowdata.limit.times = data.limit.times 
		nowdata.limit.isLimit = 0 
		for i,shopItem in pairs(getShopLimitItem) do
			if shopItem.item_type == nowdata.goods.item_type and  shopItem.item_num == nowdata.goods.item_num  then 
				nowdata.limit.isLimit = 1
			end 
		end
		table.insert( show_shop_list, nowdata )
	end

	self.layer:updateShop(show_shop_list)

	self:touchSwallowTouches(false)
end

function AltarShopCtr:setRefreshNode()
	if cfg.shopcontrol.shop.sacrifice.show_all ~= 0 then
		return
	end

	self.layer:setRefreshNode(self.refresh_cost, 0, 0,
		ex.Player.altar_data.shop_free_refresh,
		cfg.shopcontrol.shop.sacrifice.max_refresh_count)
end

function AltarShopCtr:onBtnRefresh(tag, pSender)
	local hasNum = ex.Player:getItemNum(self.refresh_cost.item_type)

	if ex.Player.altar_data.shop_free_refresh < 1 and hasNum < self.refresh_cost.item_num then
        ex.MessageView:add(string.format(ex.Tools:getLang(1108),
            ex.Tools:getLang(self.refresh_cost.item_type)))
        return
    end

    if ex.Player.altar_data.shop_free_refresh > 0 then
        ex.Player.altar_data.shop_free_refresh = ex.Player.altar_data.shop_free_refresh - 1
        --print(ex.Tools:getLang(47667))
    else
        -- 扣除刷新消耗
        -- ex.Player:addItem(self.refresh_cost.item_type, -self.refresh_cost.item_num)
        self.layer:setItemNum()
    end

    self:setRefreshNode()
    
    self:touchSwallowTouches(true)
end



return AltarShopCtr
