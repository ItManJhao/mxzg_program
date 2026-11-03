local ShopData = class("ShopData")

local ios_limit_recharge_key = "%s_ios_recharge"


function ShopData:ctor()
	self.shop_free_refresh = 0
	self.shop_refresh_num = 0
	self.shop_list = {}

	self.black_market_shop_list = {}

	----充值
	self.recharge_list = {}

	-- 点金
	-- 点金购买情况 [{idx,num}]
	self.buy_gold_list = {}

	-- 上次刷新时间
	self.buy_gold_time = 0
end

function ShopData:clear()
	self.shop_list = {}
end

function ShopData:setRefresh(free, num)
	self.shop_free_refresh = free
	self.shop_refresh_num = num
end

function ShopData:addShopData(data)
	table.insert(self.shop_list, data)
end

function ShopData:buyShopItem(index)
	for _,v in pairs(self.shop_list) do
		if v.index == index then
			if v.limit.count > 0 then
				v.limit.times = v.limit.times + 1
			end
			return
		end
	end
end

function ShopData:buyBlackMarketItem(index)
	for i, v in ipairs(cfg.shopstall.shopstall) do
		if v.idx == index then
			-- if ex.Player.vip_level < v.noble_require then
			-- 	ex.MessageView:add(ex.Tools:getLang(47333))
			-- 	return false
			-- end
			
			if ex.Player:getItemNum(v.need_item[1].item_type) < v.need_item[1].item_num then
				ex.MessageView:add(ex.Tools:getLang(47249))
				return false
			end

			local is_have = false
			for i2, v2 in ipairs(ex.Player.shop_data.black_market_shop_list) do
				if v2.index == v.idx then
					v2.times = v2.times + 1
					is_have = true
					break
				end
			end

			if is_have == false then
				local data = {}
				data.index = index
				data.times = 1
				table.insert(self.black_market_shop_list, data)
			end

			-- ex.Player:addItem(v.need_item[1].item_type, -tonumber(v.need_item[1].item_num))

			-- local req_shop_buy = ProtocolRequest.ReqBlackMarketBuy
			-- req_shop_buy.index.value = index
			-- NetManager:sendLuaData(req_shop_buy)

			return true
		end
	end

	-- for _,v in pairs(self.black_market_shop_list) do
	-- 	if v.index == index then
	-- 		local config = cfg.shopstall.shopstall[v.index]
	-- 		if config ~= nil and config.buy_limit > 0 and v.times < config.buy_limit then
	-- 			v.times = v.times + 1
				
	-- 			local req_shop_buy = ProtocolRequest.ReqBlackMarketBuy
	-- 			req_shop_buy.index.value = index
	-- 			NetManager:sendLuaData(req_shop_buy)
	-- 			return true
	-- 		end
	-- 		break
	-- 	end
	-- end
	
	return false
end

-------------------------------------------------------------------
-- 不停的检查充值订单
function ShopData:startCheckRecharge()
	-- 5秒检查一次订单
	if self.scheduler_id then
		return 
	end

	self.check_count = 1;
	local scheduler = cc.Director:getInstance():getScheduler()
	self.scheduler_id = scheduler:scheduleScriptFunc(handler(self, self.checkRecharge), 2, false)
	self:checkRecharge()
end

-- 停止检查充值订单
function ShopData:stopCheckRecharge()
	if self.scheduler_id ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
		self.scheduler_id = nil
	end

	self:startSecondCheckRecharge()
end

-- 重复检查一次
function ShopData:startSecondCheckRecharge()
	self.second_count = 1
	local scheduler = cc.Director:getInstance():getScheduler()
	if self.scheduler_second ~= nil then 
		scheduler:unscheduleScriptEntry(self.scheduler_second)
		self.scheduler_second = nil
	end
	self.scheduler_second = scheduler:scheduleScriptFunc(handler(self, self.secondCheckRecharge), 5, false)
end

function ShopData:secondCheckRecharge()
	self.second_count = self.second_count - 1
	if self.second_count <= 0 then
		local scheduler = cc.Director:getInstance():getScheduler()
		scheduler:unscheduleScriptEntry(self.scheduler_second)
	end

    NetManager:sendMessage(ProtocolID.GReqShopRechargeCheck)
end


function ShopData:checkRecharge()
	self.check_count = self.check_count - 1
	if self.check_count <= 0 then
		self:stopCheckRecharge()
	end

    NetManager:sendMessage(ProtocolID.GReqShopRechargeCheck)
end

function ShopData:stopAllCheck()
	if self.scheduler_id ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
		self.scheduler_id = nil
	end
	
	if self.scheduler_second ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_second)
		self.scheduler_second = nil
	end
end

function ShopData:payDone(idx)
	-- 支付成功.添加对应的道具
	local config = cfg.buygem.buygem[idx]
	if not config then
		return
	end

	-- 钻石充值
	if config.kind == RechargeKindType.RECHARGE then
		ex.Tools:addBackpackMsg(config.item[1].item_type, config.item[1].item_num)
		--ex.MessageView:add(string.format(ex.Tools:getLang(47358), config.item[1].item_type, ex.Tools:getLang(config.item[1].item_type), config.item[1].item_num), 0)
		if not self:isPurchased(idx) then
			ex.Tools:addBackpackMsg(config.first_buy_reward[1].item_type, config.first_buy_reward[1].item_num)
			--ex.MessageView:add(string.format(ex.Tools:getLang(47358), config.first_buy_reward[1].item_type, ex.Tools:getLang(config.first_buy_reward[1].item_type), config.first_buy_reward[1].item_num), 0)
		end
		table.insert(self.recharge_list, idx)
		ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.RECHARGE_GEM)

	elseif config.kind == RechargeKindType.PROMOTION then
		ex.MessageView:add(ex.Tools:getLang(47722), 0)
		ex.Player.promotion_data.is_buy_foundation = true
		ex.Player.promotion_data:checkRCGGrowthRedDot()

		ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.PROMATION_BUY)
	elseif config.kind == RechargeKindType.HERO_UPSTAR then
		-- 限时礼包
    	ex.Player.promotion_data:reqLimitGift()
    	
		-- 获得礼包奖励
		require("src.layer.ItemRewardCtr"):instance():openWindow(config.item)
	elseif config.kind == RechargeKindType.WEAK_GIFT then
	
		-- for _,v in pairs(ex.Player.promotion_data.week_gift.list) do
		-- 	if v.idx == idx then
		-- 		v.hasNum = v.hasNum - 1
		-- 		for _,goods in pairs(v.goods) do
		-- 			ex.Tools:addBackpackMsg(goods.item_type, goods.item_num)
		-- 		end				
		-- 		break
		-- 	end
		-- end
		ex.Player.promotion_data:subWeekGiftNum(idx, 1)
		ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.WEEK_GIFT)

	elseif config.kind == RechargeKindType.DAY_LIMIT then
		-- ex.MessageView:add("", 0)

		ex.Player.promotion_data:addDayLimitNum(idx)

		ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.PROMATION_DAYLIMIT)
	elseif config.kind == RechargeKindType.MONTHLY_INVESTMENT then
		-- 月度回馈计划
		ex.Player.promotion_data:reqMonthInvest()
	elseif config.kind == RechargeKindType.PRIVILEGE_GIFT then

		ex.Player.promotion_data:reqPrivilegeGift()	-- 重新请求礼包数据
		
		-- 如果购买的是圣龙礼包，需要刷新圣龙数据
		NetManager:sendMessage(ProtocolID.GReqDragonScanInfo)
	elseif config.kind == RechargeKindType.MOUTH_WELFARE then

		ex.Player.promotion_data:reqMouthWelfare()
	elseif config.kind == RechargeKindType.DAILY_WELFARE then
		-- for _,v in pairs(ex.Player.promotion_data.daily_welfare) do
		-- 	if v.idx == idx then
		-- 		v.hasNum = v.hasNum - 1

		-- 		for _,goods in pairs(v.goods) do
		-- 			ex.Tools:addBackpackMsg(goods.item_type, goods.item_num)
		-- 		end

		-- 		break
		-- 	end
		-- end
		ex.Player.promotion_data:reqDailyWelfare()

	elseif config.kind == RechargeKindType.SUPER_GIFT then

		for _,v in pairs(ex.Player.promotion_data.super_gift) do
			if v.idx == idx then
				v.hasNum = v.hasNum - 1
				for _,goods in pairs(v.goods) do
					ex.Tools:addBackpackMsg(goods.item_type, goods.item_num)
				end
				break
			end
		end
		ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.SUPER_WELFARE)
	elseif config.kind == RechargeKindType.NEW_SERVER_LIMIT then
		-- 发放奖励
		-- for k,v in pairs(config.item) do
		-- 	ex.Tools:addBackpackMsg(v.item_type, v.item_num)
		-- end

		ex.Player.promotion_data:reqNewServerLimit()	-- 重新请求数据
	elseif config.kind == RechargeKindType.UPGRADE_GIFT then	-- 升级礼包
		-- 限时礼包
    	ex.Player.promotion_data:reqLimitGift()
    	
		-- -- 礼包如背包
		-- for _,v in pairs(config.item) do
		-- 	ex.Tools:addBackpackMsg(v.item_type, v.item_num)
		-- end

		-- 获得礼包奖励
		require("src.layer.ItemRewardCtr"):instance():openWindow(config.item)
	elseif config.kind == RechargeKindType.LEVEL_GIFT then		-- 关卡礼包
		-- 限时礼包
    	ex.Player.promotion_data:reqLimitGift()
    	
		-- 获得礼包奖励
		require("src.layer.ItemRewardCtr"):instance():openWindow(config.item)
	elseif config.kind == RechargeKindType.MID_AUTUMN then		-- 中秋特惠
		-- 礼包如背包
		for _,v in pairs(config.item) do
			ex.Tools:addBackpackMsg(v.item_type, v.item_num)
		end
		
		-- 刷新已购买
		ex.Player.promotion_data.mid_autumn_info.is_bought = true
	elseif config.kind == RechargeKindType.HAPPY_MONTH then		-- 狂欢特权
		if type(config.item) == "table" then
			for _,v in pairs(config.item) do
				ex.Tools:addBackpackMsg(v.item_type, v.item_num)
			end
		end

		-- 刷新已购买
		ex.Player.promotion_data:setHappyMonthBuyStatus(true)
	elseif config.kind == RechargeKindType.FASHION_BUY then		-- 皮肤购买
		-- 刷新已购买
		ex.Player.promotion_data:reqFlashSaleData()
		ex.Player.promotion_data:reqLimitGift()
	elseif config.kind == RechargeKindType.RECHARGE_FIRST then	-- 超值首充
		ex.Player.promotion_data:reqRechargeFirst()
	elseif config.kind == RechargeKindType.LIMIT_BUY then	-- 诸神遗迹礼包
		ex.Player.promotion_data:reqLimitGift()
	elseif config.kind == RechargeKindType.SUMMON_WEEK_CARD then	-- 召唤周卡
		ex.Player.promotion_data:reqSummonWeeksCardsInfo()
	elseif config.kind == RechargeKindType.SUPER_SUMMON_WEEK_CARD then	-- 超级召唤周卡
		ex.Player.promotion_data:reqSuperSummonWeeksCardsInfo()
	elseif config.kind == RechargeKindType.SUPER_STAGE_TOKEN then	--超凡段位賽王之戰令
		ex.Player.super_stage_data:reqInfo()
	elseif config.kind == RechargeKindType.SECRET_TREASURE then
		ex.Player.promotion_data:reqPromotion70Data()
	elseif config.kind == RechargeKindType.MAGIC_TOWER_ROAD_KING then
		ex.Player.magic_tower_data:reqData()
	end

	-- -- 判断是否是小额充值，记录购买时间
	-- if config.rmb < ex.Tools:getSysCfg("recharge_limit_money_ios") then
	-- 	local now_time = ex.Game:getServerTime() 
	-- 	local vec_time = cc.UserDefault:getInstance():getStringForKey(string.format(ios_limit_recharge_key, ex.Player.role_id), "{}")
	-- 	vec_time = json.decode(vec_time)
	-- 	if table.nums(vec_time) < ex.Tools:getSysCfg("recharge_limit_num_ios") then
	-- 		table.insert(vec_time, now_time)
	-- 	else
	-- 		table.sort(vec_time, function(a, b)
	-- 			return a < b
	-- 		end)
	-- 		vec_time[1] = now_time
	-- 	end
	-- 	cc.UserDefault:getInstance():setStringForKey(string.format(ios_limit_recharge_key, ex.Player.role_id), json.encode(vec_time))
	-- end
	local equip_red = ex.Player.hero_data.equip:checkHeroEquipRedPointByScene()
    local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
    local promote_red = ex.Player.hero_data.promote:checkMainCityRedPoint()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, equip_red or artifact_red or promote_red)
end

-- 是否限制充值。IOS限制半小时内只能充值3笔小于30元的订单
function ShopData:isLimitRecharge(idx)
	if device.platform ~= "ios" then
		return false
	end

	local config = cfg.buygem.buygem[idx]
	if not config then
		return false
	end

	return true
	
	-- -- 判断钱数
	-- if config.rmb >= ex.Tools:getSysCfg("recharge_limit_money_ios") then
	-- 	return false
	-- end

	-- 判断时间
	-- local now_time = ex.Game:getServerTime()
	-- local limit_num = ex.Tools:getSysCfg("recharge_limit_num_ios")
	-- local limit_interval = ex.Tools:getSysCfg("recharge_limit_time_ios")
	-- local vec_time = cc.UserDefault:getInstance():getStringForKey(string.format(ios_limit_recharge_key, ex.Player.role_id), "{}")
	-- vec_time = json.decode(vec_time)

	-- local is_limit = table.nums(vec_time) > 0
	-- for k,v in pairs(vec_time) do
	-- 	if now_time - v > limit_interval then
	-- 		is_limit = false
	-- 		break
	-- 	end
	-- end

	-- return is_limit
end

function ShopData:getRechargeList(kind)
	local vec_list = {}
	local vec_idx = {}
	for k,v in pairs(cfg.buygem.buygem) do
		table.insert(vec_idx, v.idx)
	end

	table.sort(vec_idx, function(a, b)
		return a < b
	end)

	for i,v in ipairs(vec_idx) do
		local data = cfg.buygem.buygem[v]
		if data.kind == kind then
			table.insert(vec_list, data)
		end
	end
	return vec_list
end

function ShopData:isPurchased(idx)
	return TableEx.isInTableFunction(self.recharge_list, function(value)
		if idx == value then
			return true
		end
		return false
	end)
end

function ShopData:getVipStatus(key, value)
	for i,v in ipairs(cfg.vip.vip) do
		if v[key] ~= value then
			return v
		end
	end
	return nil
end

function ShopData:getLeftGem(exp_num)
	local need_item = {}
	local vec_idx = self:getRechargeList(RechargeKindType.RECHARGE)
	for i,v in ipairs(vec_idx) do
		local config = cfg.buygem.buygem[v.idx]
		need_item.gem = config.item[1].item_num
		need_item.exp = config.vip_exp
		if config.vip_exp > exp_num then
			break
		end
	end
	return need_item
end

function ShopData:getNeedGem(exp_num)

	return exp_num
	-- local gem = 0
	-- local exp = exp_num

	-- while true do
	-- 	-- 防止死循环
	-- 	local data = self:getLeftGem(exp)
	-- 	if data.exp == nil then
	-- 		break
	-- 	end
		
	-- 	exp = exp - data.exp
	-- 	gem = gem + data.gem
	-- 	if exp <= 0 then
	-- 		break
	-- 	end
	-- end
	-- return gem
end


function ShopData:getBuyGoldNum(idx)
	for i,v in ipairs(self.buy_gold_list) do
		if v.idx == idx then
			return v.num
		end
	end
	return 0
end

function ShopData:addBuyGoldNum(idx, num)

	local buy_data = TableEx.findValueFunction(self.buy_gold_list, function(value)
		if idx == value.idx then
			return true
		end
	end)

	if buy_data then
		buy_data.num = buy_data.num + num
	else
		buy_data = {}
		buy_data.idx = idx
		buy_data.num = num
		table.insert(self.buy_gold_list, buy_data)
	end
end

function ShopData:checkBuyGoleReddot()
	
	local config_cost = cfg.buygoldcost.buygoldcost[1]
	if not config_cost then
		return
	end

	local num = self:getBuyGoldNum(config_cost.type)
	local key = self.buy_gold_status ~= 0 and "promotion_limit" or "limit"
	local is_visible = num < config_cost[key]
	
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DJ_MFDJ, is_visible)
end

return ShopData