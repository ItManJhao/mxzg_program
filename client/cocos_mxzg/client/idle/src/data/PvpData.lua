local PvpData = class("PvpData")


function PvpData:ctor()

	-- pvp分数
	self.score = 0

	-- 赛季结束时间
	self.season_end_time = 0

	self.season_count = 0	-- 赛季已挑战次数
	self.like_list = {}		-- 已点赞列表

	self.season_reward_list = {}	-- 记录当前已领取的赛季奖励idx列表

	-- PSRankPlayerData
	self.rank_self = {}
	self.rank_list = {}

	-- PSRankPlayerData
	self.enemy_list = {}

	-- int64
	self.history_id_list = {}

	-- 战斗历史数据
	self.history_list = {}

	-- 免费次数
	self.free_count = 0

	self.shop_free_refresh = 0 -- 商店免费刷新时间
	self.shop_list = {}        -- 商品列表
end


function PvpData:getDailyConfigByRank(rank)
	local num = table.nums(cfg.pvpdailyreward.pvpdailyreward)
	local config = cfg.pvpdailyreward.pvpdailyreward[1]
	for i=1,num do
		local now_config = cfg.pvpdailyreward.pvpdailyreward[i]
		local pre_rank = config.rank or config.rank
		print(pre_rank, now_config.rank, rank)
		if rank >= pre_rank and rank <= now_config.rank  then
			config = now_config
			if (now_config.rank - config.rank) ~= 1  then
				config = now_config
			else
				-- config = now_config
			end
			break
		end
		config = now_config
	end

	if rank > config.rank then
		config = {}
		config.idx = num + 1
		config.reward = {}
		config.rank = rank
	end
	return config
end


function PvpData:getWeeklyConfigByRank(rank)
	local num = table.nums(cfg.pvpweeklyreward.pvpweeklyreward)
	local config = cfg.pvpweeklyreward.pvpweeklyreward[1]
	for i=1,num do
		local now_config = cfg.pvpweeklyreward.pvpweeklyreward[i]
		local pre_rank = config.rank or config.rank
		print(pre_rank, now_config.rank, rank)
		if rank >= pre_rank and rank <= now_config.rank  then
			config = now_config
			if (now_config.rank - config.rank) ~= 1  then
				config = now_config
			else
				-- config = now_config
			end
			break
		end
		config = now_config
	end

	if rank > config.rank then
		config = {}
		config.idx = num + 1
		config.reward = {}
		config.rank = rank
	end
	return config
end

function PvpData:clearShop(free)
	self.shop_free_refresh = free
	self.shop_list = {}
end

function PvpData:addShopData(data)
	table.insert(self.shop_list, data)
end

function PvpData:buyShopItem(index)
	for _,v in pairs(self.shop_list) do
		if v.index == index then
			if v.limit.count > 0 then
				v.limit.times = v.limit.times + 1
			end
			return
		end
	end
end

function PvpData:getEnemyData(player_id)
	for k,v in pairs(self.enemy_list) do
		if v.player_id == player_id then
			return v
		end
	end
	return nil
end

function PvpData:checkRedDot()
	if not ex.JumpManager:checkOpenConditionByAtomNoMsg("main_pvp") then
		return
	end

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_JJC, self.free_count > 0)
end

function PvpData:pvpCanTimesReward(idx)
	local config = cfg.pvptimesreward.pvptimesreward[idx]
	if config == nil then
		return 0
	end
	if config.times > self.season_count then
		return -2
	end
	for k,v in pairs(self.season_reward_list) do
		if v == idx then
			return -1
		end
	end
	return 1
end

function PvpData:pvpTimesReward(idx)
	local flag = self:pvpCanTimesReward(idx)
	if flag <= 0 then
		return flag
	end

	local req_reward = Pvp_pb.GReqPvpSeasonReward()
	req_reward.type = idx
	NetManager:sendMessage(ProtocolID.GReqPvpSeasonReward, req_reward)

	return 1
end

return PvpData