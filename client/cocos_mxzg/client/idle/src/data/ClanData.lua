local ClanData = class("ClanData")

-- 公会id
-- ClanData.clan_id = 0
-- ClanData.clan_photo = 1
-- ClanData.clan_level = 1
-- ClanData.clan_exp = 1
-- ClanData.clan_name = ""
-- ClanData.clan_notice = ""

-- /** 公会职位枚举 */
ClanPositionType = {}
ClanPositionType.INVALID = 0   	-- 无效
ClanPositionType.HEAD = 1  		-- 会长
ClanPositionType.VICE_HEAD = 2  -- 副会长
ClanPositionType.NORMAL = 3  	-- 普通成员


function ClanData:ctor()
	self:reset()

	self.up_leve_id = ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.ROLE_LEVEL, handler(self, self.checkBossReddot))
end

-- 清除
function ClanData:reset()
    self.clan_id = 0
    self.clan_photo = 1
	self.clan_level = 1
	self.clan_exp = 1
	self.clan_name = ""
	self.clan_notice = ""
	self.last_join_time = 0		-- 下次可加入公会时间

	self.clan_mission_cur_boss_idx = 1	-- 公会副本怪物idx
	self.clan_boss_cur_hp = 0	-- 公会副本怪物当前血量
	self.left_count = 0		-- 公会副本剩余免费次数
	self.attack_count = 0	-- 公会副本今天攻打过的次数
	self.buy_count = 0		-- 公会副本剩余购买次数
	
	self.clan_member_list = {}		-- 公会成员列表	{rid, nick, photo, rank, level, damage, position}
	self.clan_history_list = {}		-- 公会日志列表	{manager_id, member_id, info_type, member_name, manager_name, value, time}
	self.clan_recommend_list = {}	-- 公会推荐列表	{clan_id, clan_level, clan_photo, clan_name, clan_member_num}
	self.clan_search_list = {}		-- 公会搜索列表	{clan_id, clan_level, clan_photo, clan_name, clan_member_num}

	self.clan_skill_next_reset_times = 0	-- 公会科技重置次数
	self.clan_skill_list = {}		-- 公会科技列表	{profession_type, stage, elem_idx}

	self.donate_things = 0			-- 公会已捐献类型，0为为捐献

	self.total_donate_num = 0		-- 公会总捐献数
	self.clan_total_donate_list = {}-- 公会总捐献列表	{reward_idx}

	-- 公会战相关
	self.clan_gvg_info = {}			--公会战信息 {round_start_time, round_end_time, stage, next_stage_time, war_infos{clan_id, name, server_id, roads{road, battling, total, alive}}}
	self.clan_gvg_info.round_start_time = 0	-- 公会战活动开始时间
	self.clan_gvg_info.round_end_time = 0	-- 公会战活动结束时间
	self.clan_gvg_info.stage = 1	-- 公会战活动阶段	1匹配阶段，2备战阶段，3调整阶段，4开战阶段，5休战阶段
	self.clan_gvg_info.next_stage_time = 0	-- 公会战活动阶段结束时间
	self.clan_gvg_info.first_round_time = 0	-- 首轮时间
	self.clan_gvg_info.war_infos = {}

	self.clan_gvg_team_list = {}	-- 公会战公会成员布阵队列 {{road_type, road_idx, hero_type, hero_star, hero_level, player_name, fighting}}
	self.clan_gvg_reward_info = {}	-- 公会战公会成员领奖信息 {box_number, box_type, box{position, name, item_type, item_num}}
	self.clan_gvg_reward_info.box_number = 0
	self.clan_gvg_cur_history_list = {} -- 公会战当前战况 {battle_id, battling{clan_id, teams{rid, name, hero_type, hero_level, hero_star, fighting}}}
	self.clan_gvg_history_list = {} -- 公会战历史战况 {battle_id, players{name, clan_id, rid, heros{ResHeroData}, win}}
	
	-- 公会boss相关
	self.clan_boss_info = {} 		-- 公会boss战信息 {boss_id, challenge_count, challenge_cd, rob_count, rob_cd, stage, next_stage_time, round_start_time, round_end_time, has_new_record}
	self.clan_boss_info.boss_id = 1
	self.clan_boss_info.stage = 1
	self.clan_boss_info.round_start_time = 0
	self.clan_boss_info.round_end_time = 0
	self.clan_boss_info.challenge_count = 0
	self.clan_boss_info.rob_count = 0
	self.clan_boss_info.has_new_record = 0

	self.clan_boss_rank_clan = {}	-- 公会boss公会排行 {my_clan{clan_id, clan_name, rank, point}, ranks{clan_id, clan_name, rank, point}}
	self.clan_boss_rank_clan.my_rank = {}
	self.clan_boss_rank_clan.ranks = {}
	self.clan_boss_rank_player = {}	-- 公会boss个人排行 {my_rank{rid, nick, rank, point}, ranks{rid, nick, rank, point}}
	self.clan_boss_rank_player.my_rank = {}
	self.clan_boss_rank_player.ranks = {}
	self.clan_boss_plunder_list = {}-- 公会boss抢夺列表 {rid, nick, fighting, clan_name, heros{}, point, rank}


	-- 这次登录是否打开过科技界面
	self.is_visible_clan_skill = false
	self.clan_skill_check_time = {}

	self:registerEvent()
end

function ClanData:registerEvent()
	self.event_list = {
		-- ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD,handler(self,self.initRedPoint)),
		ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD,handler(self,self.checkClanSkillReddot)),
		ex.EventManager:add(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST,handler(self,self.checkClanSkillReddot)),
	}
end

function ClanData:clean()
	if self.up_leve_id then
		ex.EventManager:remove(self.up_leve_id)
		self.up_leve_id = nil
	end
end

function ClanData:getMemberByRoleId(role_id) 
	for i,v in ipairs(self.clan_member_list) do
		if v.rid == role_id then
			return v
		end
	end
	return nil
end

function ClanData:getMemberByIdx(idx) 
	local tmp_idx = 1
	for i,v in ipairs(self.clan_member_list) do
		if tmp_idx == idx then
			return v
		end
		tmp_idx = tmp_idx + 1
	end
	return nil
end

function ClanData:getClanHead()
	for i,v in ipairs(self.clan_member_list) do
		if v.position == ClanPositionType.HEAD then
			return v
		end
	end
	return nil
end

function ClanData:getNumByClanPos(pos)
	local num = 0
	for i,v in ipairs(self.clan_member_list) do
		if v.position == pos then
			num = num + 1
		end
	end
	return num
end

function ClanData:getPosStringWithPos(pos)
	if pos == ClanPositionType.HEAD or pos == ClanPositionType.VICE_HEAD or pos == ClanPositionType.NORMAL then
		return ex.Tools:getLang(3004 + pos)
	end
	return ""
end

function ClanData:getMemberPosition(role_id) 
	local member = self:getMemberByRoleId(role_id)
	if member == nil then
		return -1
	end
	return member.position
end

function ClanData:addClanExp(exp_num)
	self.clan_exp = self.clan_exp + exp_num

	repeat
		local config = cfg.clanlevel.clanlevel[self.clan_level]
		if config == nil then
			-- 满级
			break
		elseif self.clan_exp >= config.need_clan_exp then
			-- 升级
			if cfg.clanlevel.clanlevel[self.clan_level + 1] == nil then
				-- 满级
				break
			end
			
			self.clan_exp = self.clan_exp - config.need_clan_exp

			self.clan_level = self.clan_level + 1
		else
			break
		end
	until false
end

----------------------公会科技------------------------
function ClanData:getSkillDataByProfessionType(profession_type)
	for k,v in pairs(self.clan_skill_list) do
		if v.profession_type == profession_type then
			return v
		end
	end
	return nil
end

function ClanData:getSkillResNeed(skill_stage, skill_idx)
	local res_need = {}
	for i, v in ipairs(cfg.clanskillbase.clanskillbase) do
		if v.level == skill_stage and v.attr_type == skill_idx then
			for i2,v2 in ipairs(v.cost_res) do
				res_need[v2.item_type] = v2.item_num
			end
			break
		end
	end
	
	return res_need
end

function ClanData:getSkillStageMax()
	local stage_max = 0
	for i, v in ipairs(cfg.clanskillbase.clanskillbase) do
		if v.level > stage_max then
			stage_max = v.level 
		end
	end
	return stage_max
end

function ClanData:getSkillExtraType(skill_type)
	for i,v in ipairs(cfg.clanskillability.clanskillability) do
		if v.type == skill_type then
			return v.ability
		end
	end
	return 0
end

-- 获取公会科技对应职业和加成属性类型的加成数值
function ClanData:getSkillExtraNum(profession_type, skill_type)
	local stage = 0
	local elem_idx = 0
	local data = self:getSkillDataByProfessionType(profession_type)
	if data ~= nil then
		stage = data.stage
		elem_idx = data.elem_idx
	end
	local attr_type = 0
	for i,v in ipairs(cfg.clanskillability.clanskillability) do
		if v.occupation == profession_type and v.type == skill_type then
			attr_type = v.ability
			break
		end
	end
	local attr_num = 0
	local stage_max = self:getSkillStageMax()
	for i=1,stage_max do
		if i < stage or (i == stage and skill_type <= elem_idx) then
			local cur_level = i
			for i,v in ipairs(cfg.clanskillability.clanskillability) do
				if v.occupation == profession_type and v.type == skill_type then
					attr_num = attr_num + v.num
					break
				end
			end
		end
	end
	return attr_type, attr_num
end

-- 获取公会科技对应加成属性的所有加成
function ClanData:getSkillAbilityNumByList(vec_skill)
	local vec_ability = {}
	for k,v in pairs(vec_skill) do
		-- FIX
		local vec_add = self:getSkillAbilityNum(v.stage, v.elem_idx)
		vec_ability[v.profession_type] = vec_add
	end
	
	return vec_ability
end

-- 获取公会科技层数和当前点亮属性数来获取所有属性加成
function ClanData:getSkillAbilityNum(stage, elem_idx)
	local vec_ability = {}
	local stage_max = self:getSkillStageMax()
	for i=1,stage_max do
		if i <= stage then
			local skill_index = i < stage and table.nums(cfg.clanskillability.clanskillability) or elem_idx
			local cur_level = i
			for i,v in ipairs(cfg.clanskillability.clanskillability) do
				if v.type <= skill_index then
					vec_ability[v.ability] = vec_ability[v.ability] and (vec_ability[v.ability] + v.num) or v.num
				end
			end
		end
	end
	return vec_ability
end

-- 点亮对应职业类型的科技
function ClanData:lightSkill(profession_type, is_check)
	local idx = -1
	for k,v in pairs(self.clan_skill_list) do
		if v.profession_type == profession_type then
			idx = k
		end
	end
	local stage = 1
	local elem_idx = 1
	local data = self:getSkillDataByProfessionType(profession_type)

	if data ~= nil then 
		stage = data.stage
		elem_idx = data.elem_idx + 1
		if data.elem_idx >= 6 then
			stage = data.stage + 1
			elem_idx = 1
		else
			stage = data.stage
			if data.elem_idx <= 0 then 
				elem_idx = 1
			end
		end
	end
	if stage > self:getSkillStageMax() then
		return -1
	end

	-- 扣道具
	local res_need = self:getSkillResNeed(stage, elem_idx)
	local left_gold = ex.Player:getItemNum(900001) - res_need[900001]
	local left_donate = ex.Player:getItemNum(901301) - res_need[901301]
	if left_gold < 0 then
		return -2
	elseif left_donate < 0 then
		return -3
	end

	-- ex.Player:addItem(900001, - config_base["gold_"..elem_idx])
	-- ex.Player:addItem(901301, - config_base["donate_"..elem_idx])

	if is_check == nil then

		if idx == -1 then
			local data = {}
			data.profession_type = profession_type
			data.stage = stage
			data.elem_idx = elem_idx
			self.clan_skill_list[profession_type] = data
		else 
			self.clan_skill_list[idx].stage = stage
			self.clan_skill_list[idx].elem_idx = elem_idx
		end


    	local req_skill_light = Clan_pb.GReqClanSkillLight()
    	req_skill_light.profession_type = profession_type
    	NetManager:sendMessage(ProtocolID.GReqClanSkillLight, req_skill_light)
    end

	return 1
end

-- 获取重置科技可获得的资源
function ClanData:getClanSkillResetCostByProfession(profession)
	local item_cost = {}

	-- 获取对应职业的科技信息，如果没有则表示该科技未点亮过
	local profession_data = self.clan_skill_list[profession]
	if profession_data == nil then
		return item_cost
	end

	-- 先获取对应阶的消耗
	for i, v in ipairs(cfg.clanskillbase.clanskillbase) do
		if v.level > profession_data.stage or (v.level == profession_data.stage and v.attr_type > profession_data.elem_idx) then
			break
		end

		for i2,v2 in ipairs(v.cost_res) do
			if item_cost[v2.item_type] == nil then
				item_cost[v2.item_type] = v2.item_num
			else
				item_cost[v2.item_type] = item_cost[v2.item_type] + v2.item_num
			end
		end
	end

	local item_list = {}
	for k,v in pairs(item_cost) do
		local is_have = false
		for i2,v2 in ipairs(item_list) do
			if v2.item_type == k then
				v2.item_num = v2.item_num + v
				
				is_have = true
			end
		end
		if is_have == false then
			local data = {}
			data.item_type = k
			data.item_num = v
			table.insert(item_list, data)
		end
	end

    local gold_rate = ex.Tools:getSysCfg("clan_skill_reset_back_gold_percent")
	local donate_rate = ex.Tools:getSysCfg("clan_skill_reset_back_donate_percent")

	for i,v in ipairs(item_list) do
		if v.item_type == 901301 then
			v.item_num = math.floor(v.item_num * donate_rate / 100)
		elseif v.item_type == 900002 then
			v.item_num = math.floor(v.item_num * gold_rate / 100)
		end
	end

	return item_list
end

-- 获取科技重置所需资源数
function ClanData:getclanSkillResetNeed()
	if self.clan_skill_next_reset_times <= 0 then
		self.clan_skill_next_reset_times = 1
	end

	local need = 0
	for i, v in ipairs(cfg.clanskillresetgem.clanskillresetgem) do
		if v.times <= self.clan_skill_next_reset_times then
			need = v.need_gem
		else
			break
		end
	end

	return need
end

-- 重置科技
function ClanData:clanSkillReset(profession)
	local item_cost = self:getClanSkillResetCostByProfession(profession)

	-- 没有消耗代表科技未点亮过，则无法重置
	if item_cost == nil or table.nums(item_cost) <= 0 then
		return -1
	end

	-- 检查重置所需资源是否足够
	local gem_need = self:getclanSkillResetNeed()
	if ex.Player:getItemNum(gem_need[1].item_type) < gem_need[1].item_num then
		return -2
	end

	-- 发送请求
	local req_skill_reset = Clan_pb.GReqClanRemoveSkill()
    req_skill_reset.profession_type = profession
    NetManager:sendMessage(ProtocolID.GReqClanRemoveSkill, req_skill_reset)
end

----------------------公会捐献------------------------
-- 是否可以捐献
function ClanData:clanCanDonate(idx)
	return self.donate_things <= 0
end

-- 
function ClanData:checkClanDonate()
	-- 每天只能捐献一种。。
	if self.clan_id <= 0 then
		return false
	end

	if self.donate_things <= 0 then
		return true
	end

    for i,v in ipairs(cfg.clandonateactivity.clandonateactivity) do
		if self:clanCanDonateReward(v.idx) == 1 then
			return true
		end
	end
	return false
end


-- 完成捐献
function ClanData:clanDonate(index)
	if self:clanCanDonate(index) == false then
		return -1
	end

	-- print("self:checkClanDonate()", self:checkClanDonate())
	if self:checkClanDonate() ~= true then
		ex.MessageView:add(ex.Tools:getLang(47157))
		return
	end

	-- 获取奖励, 扣除道具
	local config = cfg.clandonate.clandonate[index]
	if config == nil then
		print("config is nil, idx: ", index)
		return
	end

	local cur_cost_num = ex.Player:getItemNum(config.cost_res[1].item_type)

	if cur_cost_num < config.cost_res[1].item_num then
		return -2
	end

	-- 资源增删
	-- local cur_reward_num = ex.Player:getItemNum(config.reward[1].item_type)
	-- ex.Player:addItem(config.reward[1].item_type, config.reward[1].item_num)
	-- ex.Player:addItem(config.cost[1].item_type, - config.cost[1].item_num)

	-- 添加公会经验
	-- self:addClanExp(config.clan_exp_gain[1].item_num)

	-- ex.Tools:addBackpackMsg(config.clan_exp_gain[1].item_type, config.clan_exp_gain[1].item_num)

	-- 更新时间
	self.donate_things = index

	self.total_donate_num = self.total_donate_num + config.donate_exp_gain

	-- 发送请求
	local req_clan_donate = Clan_pb.GReqClanDonate()
    req_clan_donate.order_type = index
    NetManager:sendMessage(ProtocolID.GReqClanDonate, req_clan_donate)

    -- 刷新背包
    NetManager:sendMessage(ProtocolID.GReqBackPackList)
    return 1
end

-- 获取公会总捐献领奖点数上限
function ClanData:getClanTotalDonatePointMax()
	local point_max = 0
	for i,v in ipairs(cfg.clandonateactivity.clandonateactivity) do
		if point_max < v.donate_times then
			point_max = v.donate_times
		end
	end
	return point_max
end

-- 公会总捐献是否可以领奖
function ClanData:clanCanDonateReward(idx)
	local now_days = Maths.getDays(ex.Game:getServerTime())
	if cfg.clandonateactivity.clandonateactivity[idx].donate_times > self.total_donate_num then
		return -2
	end
	for i,v in ipairs(self.clan_total_donate_list) do
		if v == idx then
			return -1
		end
	end
	return 1
end

-- 公会总捐献领奖
function ClanData:clanDonateReward(index)
	local flag = self:clanCanDonateReward(index)
	if flag <= 0 then
		return flag
	end

	-- 获取奖励, 扣除道具
	local config = cfg.clandonateactivity.clandonateactivity[index]
	if config == nil then
		print("config is nil, idx: ", index)
		return
	end

	-- 资源增删
	-- ex.Player:addItem(config.reward[1].item_type, config.reward[1].item_num)

	-- ex.MessageView:add(string.format("你获得了%s x%d", ex.Tools:getLang(config.reward[1].item_type), config.reward[1].item_num), 0)

	-- 更新时间
	print("add clan_donate_data: ", index)
	table.insert(self.clan_total_donate_list, index)

	-- 发送请求
	local req_clan_donate_reward = Clan_pb.GReqClanTotalDonateReward()
    req_clan_donate_reward.reward_idx = index
    NetManager:sendMessage(ProtocolID.GReqClanTotalDonateReward, req_clan_donate_reward)

    return 1
end


----------------------工会商店------------------------
function ClanData:clearShop(free)
	self.shop_free_refresh = free
	self.shop_list = {}
end

function ClanData:addShopData(data)
	table.insert(self.shop_list, data)
end

function ClanData:buyShopItem(index)
	for _,v in pairs(self.shop_list) do
		if v.index == index then
			if v.limit.count > 0 then
				v.limit.times = v.limit.times + 1
			end
			return
		end
	end
end

function ClanData:checkBossReddot()
	local open_config = cfg.opencondition.condition["main_clan"]
	if not open_config then
		return
	end
	if open_config.condition_type == 1 and ex.Player.level <= open_config.condition_value then
		return
	end
	
	local is_rob = false
	local is_challenge = false
	local now = ex.Game:getServerTime()
	if self.clan_id > 0 and self.clan_boss_info.round_start_time <= now and self.clan_boss_info.round_end_time >= now then
		is_rob =  self.clan_boss_info.stage == 3 and self.clan_boss_info.rob_count < ex.Tools:getSysCfg("clan_world_boss_rob_times")
		is_challenge =  self.clan_boss_info.stage == 2 and self.clan_boss_info.challenge_count < ex.Tools:getSysCfg("clan_world_boss_challenge_times")
	end

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_ZCBOSSAN_SJBOSS_LD, is_rob)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_ZCBOSSAN_SJBOSS_ZD, is_challenge)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_SJBOSS, is_challenge == true or is_rob == true)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_ZCBOSSAN_SJBOSS_LS, self.clan_boss_info.has_new_record ~= nil and self.clan_boss_info.has_new_record > 0)
end

function ClanData:checkGvgReddot()
	local open_config = cfg.opencondition.condition["main_clan"]
	if not open_config then
		return
	end
	if open_config.condition_type == 1 and ex.Player.level <= open_config.condition_value then
		return
	end
	
	local is_can_lineup_hero = false
	local is_can_reward = false
	local now = ex.Game:getServerTime()
	if self.clan_id > 0 and self.clan_gvg_info.round_start_time <= now and self.clan_gvg_info.round_end_time >= now and self.clan_gvg_info.can_join > 0 then
		if self.clan_gvg_info.stage == 2 then
			-- 判断是否已经编队
			is_can_lineup_hero = true
			local is_lineup = false
			for i=1,3 do
				local road_data = ex.Player.clan_data.clan_gvg_team_list[4 - i]
				if road_data ~= nil then
					for i2,v2 in ipairs(road_data) do
						if v2.rid == ex.Player.role_id then
							is_lineup = true
							break
						end
					end
					if is_lineup then break end
				end
			end
			is_can_lineup_hero = not is_lineup
		end
		if self.clan_gvg_info.stage == 5 then
			-- 判断是否参与公会战
			if ex.Player.clan_data.clan_gvg_reward_info.has_box ~= nil and 
				ex.Player.clan_data.clan_gvg_reward_info.has_box > 0 and
				ex.Player.clan_data.clan_gvg_reward_info.box_number > 0 then
				-- 判断是否已经领取过宝箱
				local is_reward = false
				for k,v in pairs(ex.Player.clan_data.clan_gvg_reward_info.box) do
					if v.rid == ex.Player.role_id then
						is_reward = true
						break
					end
				end
				is_can_reward = not is_reward
			end
		end
	end

	-- print("checkGvgReddot is_can_lineup_hero", is_can_lineup_hero, " is_can_reward", is_can_reward)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_ZCGHZAN_GHZ_BM, is_can_lineup_hero)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_ZCGHZAN_GHZ_ZGBX, is_can_reward)
end


function ClanData:checkMissionReddot()
	local is_visible = false
	if self.clan_id > 0 then
		is_visible = self.left_count > 0
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_GHFB_ZD, is_visible)

end


function ClanData:checkClanSkillReddot()
	-- 今天已经打开过科技界面了
	if self.is_visible_clan_skill or self.clan_id <= 0 then
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_KJ_ZS, false)
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_KJ_FS, false)
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_KJ_MS, false)
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_KJ_CK, false)
		for i,v in ipairs(self.event_list) do
			ex.EventManager:remove(v)
		end
		self.event_list = {}
		return
	end

	local vec_profession = {
		{reddot = RedDotType.ZCJ_DHGH_KJ_ZS, type = 1},
		{reddot = RedDotType.ZCJ_DHGH_KJ_FS, type = 2},
		{reddot = RedDotType.ZCJ_DHGH_KJ_MS, type = 3},
		{reddot = RedDotType.ZCJ_DHGH_KJ_CK, type = 4},
	}
	-- 检测所有职业红点情况
	for k,v in pairs(vec_profession) do
		local flag = self:lightSkill(v.type, false)
		if flag <= 0 then
			self.clan_skill_check_time[v.type] = false
		end
		local is_check = self.clan_skill_check_time[v.type] ~= nil and self.clan_skill_check_time[v.type] == true
		ex.RedDotManager:setRedNodeVisible(v.reddot, flag > 0 and not is_check)
	end
end

return ClanData
