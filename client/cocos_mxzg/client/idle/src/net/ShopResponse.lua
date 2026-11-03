local ShopResponse = class("ShopResponse")

function ShopResponse:shopList(data,byte_array)
	-- print("ShopResponse:shopList")
	-- dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResShopList, byte_array)	
	ex.Player.market_data.market_list = {}
	for k,v in ipairs(data.list) do
		ex.Player.market_data:addItem(v)
	end

	local list = ex.Player.market_data:getmarketList()
	-- dump(list)
	for k,v in pairs(list) do
		local end_time = 0
		local conf = cfg.shopcontrol.shop[k]
		if conf ~= nil then 
			if conf.auto_refresh_mode ~= "" then 
				if conf.auto_refresh_mode == 1 then 
					end_time = ex.Tools:getDayRemainingTime()
				elseif conf.auto_refresh_mode == 2 then 
					end_time = ex.Tools:getWeekRemainingTime()
				elseif conf.auto_refresh_mode == 3 then 
					end_time = ex.Tools:getMonthRemainingTime()
				end
				ex.Player.market_data:setEndTimeByType(k,end_time)
			end
		end
	end
	-- dump(ex.Player.market_data.end_time_list)
	ex.Player.market_data:checkNeedTimeByType()
	ex.EventManager:fire(EVENT.SHOP_EVENT.UPDATE)

end

function ShopResponse:shopBuy(data,byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResShopBuy, byte_array)	
	local item  = {}
	item.type = data.type 
	item.idx = data.idx
	item.buy_num = data.buy_num
	ex.Player.market_data:updateMarketDataByItem(item)
	
	-- local conf = ex.Player.market_data:getMarketItemCfg(item.type,item.idx)
	-- local need_item = conf.need_item[1]
	-- ex.Player:addItem(need_item.item_type,-need_item.item_num)
	ex.EventManager:fire(EVENT.SHOP_EVENT.UPDATE)
end

function ShopResponse:shopRefresh(data,byte_array)
	print("ShopResponse:shopRefresh")
	dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResShopRefresh, byte_array)	
	local fresh = data
	if fresh.operat == 1 then 
		local conf = ex.Player.market_data:ChargeItemCostyType(fresh.type)
		-- ex.Player:addItem(conf.item_type,-conf.item_num)
	end
	ex.Player.market_data:checkNeedTimeByType()
	ex.EventManager:fire(EVENT.SHOP_EVENT.UPDATE)
end


function ShopResponse:timeshopBuy(data)
	local conf = ex.Player.market_data:getMarketItemCfg(SHOP_TYPE.ORDER,data.idx)
	conf.buy_num  = conf.buy_num + 1

	ex.EventManager:fire(EVENT.SHOP_EVENT.UPDATE)
end

function ShopResponse:blackMarketList(byte_array)
	local data = NetManager:resLuaData(ProtocolResponse.ResBlackMarketList, byte_array)	
	ex.Player.shop_data.black_market_shop_list = data.list

	-- 刷新商店
	require("src.layer.BlackMarketCtr"):instance():updateLayer()
end

-- 收到充值列表
function ShopResponse:shopRecharge(data)
	ex.Player.shop_data.total_charge = data.total_charge
	ex.Player.total_charge = data.total_charge


	ex.Player.shop_data.recharge_list = {}
	for i,v in ipairs(data.buy_idx) do
		table.insert(ex.Player.shop_data.recharge_list, v)
	end
	ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.RECHARGE_GEM)


	local list_count = #data.list
	local list_recharge = {}
	for i,v in ipairs(data.list) do
		table.insert(list_recharge, v)
	end
	
-- dump(list_recharge, ex.Tools:getLang(47637))
	if  list_count <= 0 then
		return
	end
	

	ex.Player.shop_data:stopCheckRecharge()
	-- ex.Player.shop_data:
	for i,v in ipairs(list_recharge) do
		ex.Player.shop_data:payDone(v)
	end

	-- 每日首充
	ex.Player.promotion_data:reqDailyFirstRecharge()

	-- 每日累充
	ex.Player.promotion_data:reqDailyTotalRechargeList()

	-- 月卡
	ex.Player.promotion_data:reqMonthCard()
    
	-- 购买皮肤
	ex.Player.promotion_data:reqBuySkinRewardList()

	-- vip红点
	ex.Player.promotion_data:checkVipRedDot()

	ex.Player.promotion_data:reqTimeExchangeLimit()

	ex.Player.promotion_data:reqRechargeDays()
	--ex.Player.promotion_data:checkLTADailyRechargeGiftRedDot()
	ex.Player.promotion_data:reqRechargeReward()

	ex.Player.promotion_data:reqSignInList( )


	ex.Player.promotion_data:reqFestivalOvervalueGift()


	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZHFZ, ex.Player.summon_data:checkRedDot())
end


-- 钻石购买记录
function ShopResponse:shopLog(data)
	-- print("ShopResponse")
	-- dump_pbmsg(data)
	for i,v in ipairs(data.list) do
		-- table.insert(ex.Player.shop_data.recharge_list, v.index)
		table.insert(ex.Player.shop_data.recharge_list, v)
	end

	ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.RECHARGE_GEM)
end

function ShopResponse:buyGoldLog(byte_array)
	local data = NetManager:resLuaData(ProtocolResponse.ResBuyGoldLog, byte_array)

	ex.Player.shop_data.buy_gold_time = data.time
	ex.Player.shop_data.buy_gold_list = data.buy_gold_list

end

function ShopResponse:buyGold(byte_array)
	local data = NetManager:resLuaData(ProtocolResponse.ResBuyGold, byte_array)
	-- 添加金币
	ex.Player:addGold(data.gold)
	ex.Tools:addBackpackMsg(ItemType.IT_GOLD, data.gold)
	ex.Player.shop_data:checkBuyGoleReddot()
	-- ex.Player.shop_data:addBuyGoldNum(data.idx, 1)
end

function ShopResponse:refreshTime(data)
	for k,v in ipairs(data.list) do
		ex.Player.market_data:addItem(v)
	end
	-- ex.EventManager:fire(EVENT.SHOP_EVENT.UPDATE)
	ex.Player.market_data:checkNeedTimeByType()
	ex.EventManager:fire(EVENT.SHOP_EVENT.UPDATE_FREE_REFRESH_TIME)

	ex.EventManager:fire(EVENT.SHOP_EVENT.UPDATE)

end

function ShopResponse:addFreeNum(data)
	-- print("ShopResponse:addFreeNum")
	-- dump_pbmsg(data)
	ex.Player.market_data:addFreeNum(data)
	ex.Player.market_data:checkNeedTimeByType()
	ex.EventManager:fire(EVENT.SHOP_EVENT.UPDATE_FREE_REFRESH_TIME)
end

return ShopResponse
