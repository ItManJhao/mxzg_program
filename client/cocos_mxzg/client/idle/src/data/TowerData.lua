local TowerData = class("TowerData")

function TowerData:ctor()
	self.energy = 0
	self.energy_time = 0
	self.now_stage = 0
	self.stage_num = 0
	self.sweep_times = 0

	self.stage_num = table.nums(cfg.towerreward.towerreward)
	self.rank_self = {}
	self.rank_list = {}

	-- [idx]
	self.vec_tower_reward = {}

	-- [{idx, status}]
	self.vec_tower_reward_status = {}

	-- 无限塔通关记录
	self.log = nil
end

function TowerData:resData(byte_array)

	self:setNowStage(byte_array:readInt())
	-- self:setNowStage(700)

	self.energy = byte_array:readInt()
	self.energy_time = byte_array:readInt() + 5
	self.sweep_times = byte_array:readInt()
end

function TowerData:getNowStage()
	return self.now_stage
end

function TowerData:setNowStage(stage)
	self.now_stage = stage

	ex.Player.magic_tower_data:checkReddot()
end

function TowerData:getStageNum()
	return self.stage_num
end

function TowerData:getStageShowIndex()
	-- local stage = self:getNowStage()
	-- if stage == 0 then
	-- 	stage = 0
	-- elseif stage + 5 >= self:getStageNum() then
	-- 	stage = self:getStageNum() - 8
	-- else
	-- 	stage = math.max(stage - 5, 0) 
	-- end

	return 0
end

function TowerData:getMonsterList(mission_id)
	local vec_monster = {}
	for k,v in pairs(cfg.tower.tower) do
		if v.mission_id == mission_id and v.hero_type ~= 0 then
			v.is_monster = true
			table.insert(vec_monster, v)
		end
	end

	return vec_monster
end

function TowerData:getRewardList(mission_id)
	return cfg.towerreward.towerreward[mission_id] and cfg.towerreward.towerreward[mission_id].first_reward_tower or {}
end

function TowerData:getSweepRewardList(mission_id)
	return cfg.towerreward.towerreward[mission_id] and cfg.towerreward.towerreward[mission_id].reward or {}
end

-- 0 已经领取  1 不可领取  2 可以领取
function TowerData:getTowerRewardStatus(idx, max_id)
	local config = TableEx.findValueFunction(cfg.firstrewardtower.firstrewardtower, function(value)
		return value.chapter == idx
	end)

	if not config then
		return 1
	end
	
	if config.chapter <= max_id then
		local is_reward = TableEx.isInTableFunction(self.vec_tower_reward, function( value )
														return value == config.chapter
													end)
		if is_reward == true then
			return 0
		end
		return 2
	end
	return 1
end

function TowerData:rewardFirst(idx)
	table.insert(self.vec_tower_reward, idx)
end

function TowerData:sortReward()
	-- 排序
	local max_idx = self:getNowStage() - 1


	for i,v in ipairs(cfg.firstrewardtower.firstrewardtower) do
		-- v.status = self:getTowerRewardStatus(v.idx, max_idx)

		local data = {}
		data.idx = v.idx
		data.status = self:getTowerRewardStatus(v.chapter, max_idx)
		self.vec_tower_reward_status[data.idx] = data

	end

	local func_sort = function(a, b)
		local comp_a = a.status * -100000 + a.idx
		local comp_b = b.status * -100000 + b.idx
		return comp_a < comp_b
	end

	table.sort(self.vec_tower_reward_status, func_sort)
end

function TowerData:updateFirstRewardRedDot()
	self:sortReward()
	local is_visible = TableEx.findFunction(self.vec_tower_reward_status, function(value)
		return value.status == 2
	end)

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HJZT_STJL, is_visible)
end

function TowerData:updateTowerRedDot()
	---------------大佬们确定 扫荡没有小红点
	------ 家立说有红点
	local is_visible = cfg.towersweep.towersweep[self.sweep_times + 1] and cfg.towersweep.towersweep[self.sweep_times + 1].cost_gem <= 0 or false
	-- print("TowerData:updateTowerRedDot", is_visible)
	if ex.Player.level >= cfg.opencondition.condition["main_fantasy_tower"].condition_value  then 
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HJZT_SD, is_visible)
	end 
end

function TowerData:getNextTip( )
	local stage = nil
	local str_stage = ""
	local str_reward = ""
	local str_fight_tip = ""
	local reward = {}
	local now_stage = self:getNowStage()
	local nums = table.nums(cfg.towerreward.towerreward)
	for i=now_stage,nums do
		local config =  cfg.towerreward.towerreward[i]
		if config and config.tip ~= "" then
			stage = config.mission_id
			str_stage = string.format(ex.Tools:getLang(47142), config.mission_id)
			str_reward = ex.Tools:getLang(config.tip)
			str_fight_tip = ex.Tools:getLang(config.fight_tip)
			table.insert( reward, config.tip_reward ~= "" and config.tip_reward or {} )
			break
		end
	end

	-- 兼容配置表报错问题
	if reward and reward[1] ~= nil then
		reward = reward[1]
	end

	return str_stage, str_reward, reward, stage, str_fight_tip
end


function TowerData:getFreeSweepCount( )
	local count = 0

	for i,v in ipairs(cfg.towersweep.towersweep) do
		if v.cost_gem == 0 then
			count = count + 1
		end
	end

	return count
end




return TowerData
