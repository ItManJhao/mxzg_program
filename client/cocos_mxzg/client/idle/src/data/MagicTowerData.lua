local MagicTowerData = class("MagicTowerData")

function MagicTowerData:ctor()
	self.can_challenge_times = 0	-- 可挑战次数，与扫荡次数共通
	self.buy_times = 0				-- 已购买次数

	self.stage_num = table.nums(cfg.magictower.magictower)	-- 最大层数

	self.stage_list = {}		-- 层信息列表
	self.now_stage = 0			-- 当前层

	self.challenger_list = {}	-- 擂主列表

	self.road_normal_list = {}	-- 斩魔之路领取列表
	self.road_king_list = {}	-- 斩魔王者领取列表
	self.is_buy_king = 0		-- 斩魔王者是否解锁

	self.stage_log = {}
end

function MagicTowerData:reqData()
	NetManager:sendMessage(ProtocolID.GReqMagicTowerData)
	NetManager:sendMessage(ProtocolID.GReqMagicTowerRoadInfo)
end

function MagicTowerData:getNowStage()
	return self.now_stage
end

function MagicTowerData:setNowStage(stage_list)
	self.stage_list = stage_list or {}
	
	local max_stage = 0
	for i,v in ipairs(self.stage_list) do
		if v.level > max_stage and v.complete_id ~= nil and table.nums(v.complete_id) > 0 then
			max_stage = v.level
		end
	end
	self.now_stage = max_stage
end

function MagicTowerData:getStageNum()
	return self.stage_num
end

function MagicTowerData:getStageShowIndex()
	local stage = self:getNowStage()
	if stage == 0 then
		stage = 0
	elseif stage + 5 >= self:getStageNum() then
		stage = self:getStageNum() - 8
	else
		stage = math.max(stage - 5, 0) 
	end

	return stage
end

function MagicTowerData:getStageData(stage)
	for _,v in ipairs(self.stage_list) do
		if v.level == stage then
			return v
		end
	end

	return nil
end

function MagicTowerData:getStageListByStar(star)
	local data = {}
	for _,v in ipairs(self.stage_list) do
		if table.nums(v.complete_id) == star then
			table.insert(data, v.level)
		end
	end

	return data
end

function MagicTowerData:getChallengerData(stage)
	for _,v in ipairs(self.challenger_list) do
		if v.level == stage then
			return v
		end
	end

	return nil
end

function MagicTowerData:getStarTotalNum()
	local num = 0
	for _,v in ipairs(self.stage_list) do
		num = num + table.nums(v.complete_id)
	end

	return num
end

function MagicTowerData:checkReddot()
	if not cfg.funcopen.magic_tower.isVisible() then
		return
	end
	local stage_need = ex.Tools:getSysCfg("magic_tower_level_need")
	if stage_need >= ex.Player.tower_data:getNowStage() then
		return
	end

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HJZT_HMT_HMTTL, self.can_challenge_times > 0)

	local star_num = self:getStarTotalNum()
	local is_have = false
	for _,config_data in pairs(cfg.magictowerstarreward.magictowerstarreward) do
		if config_data.star <= star_num then
			local is_has = false
			for _,reward_idx in ipairs(self.road_normal_list) do
				if reward_idx == config_data.idx then
					is_has = true
					break
				end
			end
			if not is_has then
				is_have = true
				break
			end
		end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HJZT_HMT_ZMZL_ZMLC, is_have)

	if self.is_buy_king then
		is_have = false
		for _,config_data in pairs(cfg.magictowerkingreward.magictowerkingreward) do
			if config_data.star <= star_num then
				local is_has = false
				for _,reward_idx in ipairs(self.road_king_list) do
					if reward_idx == config_data.idx then
						is_has = true
						break
					end
				end
				if not is_has then
					is_have = true
					break
				end
			end
		end
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HJZT_HMT_ZMZL_ZMWZ, is_have)
	else
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HJZT_HMT_ZMZL_ZMWZ, false)
	end
end

return MagicTowerData
