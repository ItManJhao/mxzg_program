local HeroTalentShopCtr = class("HeroTalentShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
--local ShopLayer = class("ShopLayer", require("src.comp.EventLayer"))
local HeroTalentShopLayer = class("HeroTalentShopLayer", require("src.layer.shop.ShopLayer"))




-------------------------------------------------------------------
function HeroTalentShopCtr:onCreate()
	self:setCCBIPath("ccbi/HeroTalentShopLayer.ccbi")
	self:setIsSingle(false)

	self.cur_filter = 0
	self.data = {}
end

function HeroTalentShopCtr:getLayerClass()
	return HeroTalentShopLayer
end

function HeroTalentShopCtr:openWindow(data)
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

function HeroTalentShopCtr:initData()
    local layer = self.layer
	layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	if not self.data or table.nums(self.data) <= 0 then 
		ex.MessageView:add(ex.Tools:getLang(47239))
		return
	end

	self:refreshViewByElem(true)
	layer:changeTime()
end

function HeroTalentShopCtr:refresh( )
	if not self:isOpened() then
		return
	end

	self.data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.TALENT)

	self:refreshViewByElem(true)
end

function HeroTalentShopCtr:refreshViewByElem(is_force)
	if not is_force then
		return
	end

    local vec_selected = ex.Player.lineup_data:getIdList(LineupType.CHAPTER)
    
	-- 更新已领悟状态
	for k,v in pairs(self.data) do
		v.is_comprehend = false
		for i2,v2 in ipairs(vec_selected) do
			if v2 > 0 then
				local conf = ex.Player.market_data:getMarketItemCfg(v.type, v.idx)
				local flag = ex.Player.hero_data:isTalentItemStudy(v2, conf.item_type[1].item_type)
				if flag == true then
					v.is_comprehend = true
					break
				end
			end

		end
	end

	self.layer:updateView(self.data)
	
	local conf = cfg.shopcontrol.shop[SHOP_TYPE.TALENT]
	local vip_level = ex.Player.fetter_data.vip:getVIP()
	local rechage_refresh_max = conf.daily_charge_refresh
	local rechage_refresh_num = ex.Player.market_data:getChargeRefreshNumByType(SHOP_TYPE.TALENT)
	self.layer.lbl_limit_time:setString(string.format(ex.Tools:getLang(47398),rechage_refresh_max - rechage_refresh_num,rechage_refresh_max))
end

return HeroTalentShopCtr