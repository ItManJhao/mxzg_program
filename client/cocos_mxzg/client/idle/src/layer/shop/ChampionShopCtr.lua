local ChampionShopCtr = class("ChampionShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
--local ShopLayer = class("ShopLayer", require("src.comp.EventLayer"))
local ChampionShopLayer = class("ChampionShopLayer", require("src.layer.shop.ShopLayer"))

-------------------------------------------------------------------
function ChampionShopCtr:onCreate()
	self:setCCBIPath("ccbi/ChampionShopLayer.ccbi")
	self:setIsSingle(false)

	self.cur_filter = 0
	self.data = {}
end

function ChampionShopCtr:getLayerClass()
	return ChampionShopLayer
end

function ChampionShopCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self.data = data
	self.cur_filter = 0

	self:loadLayer()
	self:open()

	-- 移除内部事件调用，改用这里控制
	self.layer:removeEvent()
	self.layer:addEvent(EVENT.SHOP_EVENT.UPDATE,handler(self,self.refresh))
	self.layer:addEvent(EVENT.SHOP_EVENT.UPDATE_FREE_REFRESH_TIME,handler(self,self.refresh))
	self:initData()
end

function ChampionShopCtr:initData()
    local layer = self.layer
	layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	if not self.data or table.nums(self.data) <= 0 then 
		ex.MessageView:add(ex.Tools:getLang(47239))
		return
	end

	self:refreshViewByElem(true)
	layer:changeTime()
end

function ChampionShopCtr:refresh( )
	if not self:isOpened() then
		return
	end

	self.data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.CHAMPION)

	self:refreshViewByElem(true)
end

function ChampionShopCtr:refreshViewByElem(is_force)
	if not is_force then
		return
	end

	self.layer:updateView(self.data)
	
	local conf = cfg.shopcontrol.shop[SHOP_TYPE.CHAMPION]
end

return ChampionShopCtr