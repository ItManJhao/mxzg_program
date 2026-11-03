local BlessingPoolData = class("BlessingPoolData")

function BlessingPoolData:ctor()
	self.refresh_times = {}
	self.refresh_over_times = {}
	self.common_list = {}
	self.senior_list = {}
	self.award_list = {}

	self.lucky_info = {
		{
			lucky_value = 0,
			lucky_reward = {}
		},
		{
			lucky_value = 0,
			lucky_reward = {}
		}
	}

	self.shop_free_refresh = 0
	self.shop_list = {}

	self.tag = 0
	self.done_index = 0
	self.cur_pool_type = 0
	self.gain_item_key = nil

	self.common_pool_type_id = 1
	self.senior_pool_type_id = 2
end

function BlessingPoolData:clear()
	self.refresh_times = {}
	self.refresh_over_times = {}
	self.common_list = {}
	self.senior_list = {}
	self.award_list = {}
end

function BlessingPoolData:addRefreshTimes(pool_type, time)
	if pool_type == self.common_pool_type_id then
		self.refresh_times[1] = time
	end
	if pool_type == self.senior_pool_type_id then
		self.refresh_times[2] = time
	end
end

function BlessingPoolData:setRefreshTime(pool_type, time)
	if (pool_type == self.common_pool_type_id) or (pool_type == self.senior_pool_type_id) then
		self.refresh_over_times[pool_type] = time
	end
	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_BLESSING_POOL)
 	if cur_layer then
		cur_layer:updateCdTimeShow()
	end
end

function BlessingPoolData:getRefreshTime(clickType)
	if self.refresh_over_times and self.refresh_over_times[clickType] then
		return self.refresh_over_times[clickType] or 0
	end
	return 0
end

function BlessingPoolData:addAward(pool_type, item)
	if pool_type == self.common_pool_type_id then
		table.insert(self.common_list, item)
	end
	if pool_type == self.senior_pool_type_id then
		table.insert(self.senior_list, item)
	end
end

function BlessingPoolData:addAwardData(item)
	table.insert(self.award_list, item)
end

function BlessingPoolData:getNeedItem(pool_type, play_time)
	for _,v in pairs(cfg.wishpoolneed.pool) do
        if v.wishpool_type == pool_type and v.play_time == play_time then
           return v.need_item[1]
        end
    end
    return nil
end

function BlessingPoolData:getTimesByPosition(pool_type, pos)
	for i,v in ipairs(cfg.wishpoolreward.wishpoolreward) do
		if v.wishpool_type == pool_type and v.place == pos then
			return v.gain_limit
		end
	end
	return -1
end

function BlessingPoolData:getLuckyMax(pool_type)
	local max = 0
	for k,v in pairs(cfg.wishpoolluckyreward.wishpoolluckyreward) do
		if pool_type == v.type and v.lucky_value_need > max then
			max = v.lucky_value_need
		end
	end

	return max
end

function BlessingPoolData:setLuckyValue(pool_type, value)
	self.lucky_info[pool_type].lucky_value = value
end

function BlessingPoolData:setLuckyRewardList(pool_type, list)
	self.lucky_info[pool_type].lucky_reward = list
end

function BlessingPoolData:isGotLockyRewardForIdx(pool_type, idx)
	if self.lucky_info[pool_type] ~= nil then
		for k,v in pairs(self.lucky_info[pool_type].lucky_reward) do
			if v == idx then
				return true
			end
		end
	end

	return false
end

function BlessingPoolData:clearLockTag(pool_type)
	if pool_type == 1 then
		self.lock_common_list = {}
	elseif pool_type == 2 then
		self.lock_senior_list = {}
	end
end

function BlessingPoolData:addLockTag(pool_type, index)
	if pool_type == 1 then
		table.insert(self.lock_common_list, index)
	elseif pool_type == 2 then
		table.insert(self.lock_senior_list, index)
	end
end

function BlessingPoolData:runTurn()
	local need_item = ex.Player.blessing_pool:getNeedItem(self.cur_pool_type, self.tag)
		-- 计算10连开启等级
	local need_level = 0
	for i,v in ipairs(cfg.goddessvip.goddessvip) do
		if v.unlock_normal_wishpool_10 >= 1 then
			need_level = v.vip_level
			break
		end
	end
	
	if self.done_index == 10 then
		if ex.Player.fetter_data.vip.vip_level < need_level then
			ex.MessageView:add(string.format(ex.Tools:getLang(47518), need_level))
			return false
		end
	end

	local hasItemNum = ex.Player:getItemNum(need_item.item_type)
	-- 背包数据不足
	if hasItemNum < need_item.item_num then
		-- ex.MessageView:add(string.format(ex.Tools:getLang(1108),
		-- 	ex.Tools:getLang(need_item.item_type)))
		ex.Tools:showEnoughTip(need_item.item_type)
		return false
	end
	
	-- 扣除许愿币
	-- ex.Player:addItem(need_item.item_type, -need_item.item_num)

	-- 获得许愿池商货币
	-- local data = ex.Tools:getSysCfg(self.gain_item_key)
	-- ex.Player:addItem(data[1].item_type, data[1].item_num * self.tag)
	local type = self.done_index
	if type >= 10 then
		type = math.floor(self.done_index / 10)
	end

	local req_done = BlessingPool_pb.GReqBlessingPoolDone()
	req_done.type = type
	req_done.times = self.done_index >= 10 and 10 or 1
	NetManager:sendMessage(ProtocolID.GReqBlessingPoolDone, req_done)

	return true
end

function BlessingPoolData:checkBlessingPoolRedDot()
	if self:isRedDotForPoolType(self.common_pool_type_id) or self:isRedDotForPoolType(self.senior_pool_type_id) then
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_XYC, true)
		return true
	else
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_XYC, false)
		return false
	end
end

function BlessingPoolData:isRedDotForPoolType(pool_type)
	local lucky_info = self.lucky_info[pool_type]
	if lucky_info then
		for k,v in pairs(cfg.wishpoolluckyreward.wishpoolluckyreward) do
			local is_got = self:isGotLockyRewardForIdx(pool_type, v.idx)
			if pool_type == v.type and lucky_info.lucky_value >= v.lucky_value_need and not is_got then
				return true
			end
		end
	end

	return false
end


----------------------------
function BlessingPoolData:clearShop(free)
	self.shop_list = {}
	self.shop_free_refresh = free
end

function BlessingPoolData:addShopData(data)
	table.insert(self.shop_list, data)
end

function BlessingPoolData:buyShopItem(index)
	for _,v in pairs(self.shop_list) do
		if v.index == index then
			if v.limit.count > 0 then
				v.limit.times = v.limit.times + 1
			end
			return
		end
	end
end

return BlessingPoolData