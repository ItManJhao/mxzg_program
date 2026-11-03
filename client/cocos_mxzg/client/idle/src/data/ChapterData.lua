local ChapterData = class("ChapterData")

ChapterData.vec_idle_team = {}
ChapterData.vec_battle_team = {}

function ChapterData:ctor()

	self.now_idx = 0
	self.max_idx = 0
	self.chapter_id = 0
	-- 最大的关卡数
	self.max_chapter_id = table.nums(cfg.chapterreward.chapterreward)

	self.res_reward_time = 0
	self.max_reward_time = 99999
	self.exp = 0
	self.gold = 0
	self.hero_exp = 0
	
	-- [hero_id]
	self.vec_idle_team = {}

	-- [hero_id]
	self.vec_battle_team = {}

	-- [idx]
	self.vec_chapter_reward = {}
	-- [{idx, status}]
	self.vec_chapter_reward_status = {}
	
	-- [{idx, is_reward}]
	self.vec_chapter_extra_reward = {}
end


function ChapterData:setNowIdx(idx)
	self.now_idx = idx
end

function ChapterData:setMaxIdx(idx)
	self.max_idx = idx
end

function ChapterData:getNowIdx()
	return math.max(self.now_idx, 1) 
end

function ChapterData:getMaxIdx()
	return math.max(self.max_idx, 1)
end

function ChapterData:missionCompletion(idx)
	self.now_idx = idx

	local next_idx = Maths.clampf(idx + 1, 1, table.nums(cfg.chapterreward.chapterreward)) 

	self.now_idx = next_idx
	
	if self.now_idx <= 0 then
		self.now_idx = next_idx
	end
	
	if self.now_idx >= self.max_idx then
		self.max_idx = self.now_idx
	end
end


function ChapterData:setIldeTeam(vec_hero, is_send)
	if not vec_hero then
		vec_hero = {}
	end

	if is_send == nil then
		is_send = true
	end

	local is_change = false
	if (not self.vec_idle_team) or (table.nums(self.vec_idle_team) ~= table.nums(vec_hero)) then
		is_change = true
	end

	if not is_change then
		for i, v in ipairs(self.vec_idle_team) do
			if vec_hero[i] ~= v then
				is_change = true
				break
			end
		end
	end

	for i, v in ipairs(vec_hero) do
		local hero_data = ex.Player.hero_data:getHeroDataById(v)
		if not hero_data then
			vec_hero[i] = NULL_ID
		end
	end

	-- 插入0
	for i = 1, 20 do
		if not vec_hero[i] then
			vec_hero[i] = NULL_ID
		end
	end

	self.vec_idle_team = vec_hero
	-- print("ChapterData:setIldeTeam", json.encode(self.vec_idle_team))
end

function ChapterData:getIldeTeam()
	return self.vec_idle_team
end

function ChapterData:setBattleTeam(vec_hero, is_send)
	if not vec_hero then
		vec_hero = {}
	end

	if is_send == nil then
		is_send = true
	end

	local is_change = false
	if (not self.vec_battle_team) or (table.nums(self.vec_battle_team) ~= table.nums(vec_hero)) then
		is_change = true
	end

	if not is_change then
		for i, v in ipairs(self.vec_battle_team) do
			if vec_hero[i] ~= v then
				is_change = true
				break
			end
		end
	end

	for i, v in ipairs(vec_hero) do
		local hero_data = ex.Player.hero_data:getHeroDataById(v)
		if not hero_data then
			vec_hero[i] = NULL_ID
		end
	end

	-- 插入0
	for i = 1, 6 do
		if not vec_hero[i] then
			vec_hero[i] = NULL_ID
		end
	end

	self.vec_battle_team = vec_hero
	-- print("ChapterData:setBattleTeam", json.encode(self.vec_battle_team))

	if is_change and is_send then
		local req = Battle_pb.GReqChapterBattleLineup()
		req.list = self.vec_battle_team
    	NetManager:sendMessage(ProtocolID.GReqChapterBattleLineup, req)

	end
	--红点检测
	ex.Player.hero_data.promote:initBattlelist()

	local artifact_red = false
	for k,v in pairs(vec_hero) do
		if v ~= "0" then 
			ex.Player.hero_data.promote:setBattleHero(v)
			local hero = ex.Player.hero_data:getHeroDataById(v)
			ex.Player.hero_data.promote:checkCanUpLevel(v)
			-- ex.Player.hero_data.promote:setHeroUp(v,hero.level < maxlevel)
			ex.Player.hero_data.promote:checkHeroCanUpgrade(v)
		end
	end
	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	if bool == false then 
		if v ~= "0" then 
			for k,v in pairs(vec_hero) do
				local reds = ex.Player.hero_data.artifact:checkRedPointByHeroId(v)
				for k,v in pairs(reds) do
					if v == true then 
						artifact_red = true 
						break
					end
				end
			end
		end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, bool or artifact_red)
	ex.EventManager:fire(EVENT.HERO_EVENT.UP_BATTLE_RED_POINT)
end

function ChapterData:getBattleTeam()
	return self.vec_battle_team
end

function ChapterData:getBattleTeamWithType()
	local vec_hero = {}
	for k,v in pairs(self.vec_battle_team) do
		local hero_data = ex.Player.hero_data:getHeroDataById(v)
		if hero_data then
			table.insert(vec_hero, hero_data)
		end
	end
	return vec_hero
end


function ChapterData:getMonsterByChapter(chapter_idx)
	-- print("ChapterData:getMonsterByChapter", chapter_idx)
	local vec_monster = {}
	local max_idx = table.nums(cfg.chapterreward.chapterreward)
	if chapter_idx > max_idx then
		chapter_idx = max_idx
	end

	local now_config = cfg.chapterreward.chapterreward[chapter_idx]
	if not now_config then
		return vec_monster
	end

	for i, v in ipairs(cfg.chapter.chapter) do
		if v.mode_id == now_config.mode_id and
		   v.chapter_id == now_config.chapter_id and
		   v.mission_id == now_config.mission_id and
		   v.hero_type ~= 0 then
		   	v.is_monster = true
			table.insert(vec_monster, v)
		end
	end
	return vec_monster
end

function ChapterData:getModeList()
	local vec_mode = {}
	local tab_chapter = cfg.chapterreward.chapterreward

	for i,v in ipairs(tab_chapter) do
	-- for k, v in pairs(tab_chapter) do
		if not TableEx.isInTable(vec_mode, v.mode_id) then
			table.insert(vec_mode, v.mode_id)
		end
	end
	return vec_mode
end

function ChapterData:getChapterList(mode_id)
	local vec_chapter = {}
	local tab_chapter = cfg.chapterreward.chapterreward
	-- for i,v in ipairs(table_name) do
	for k, v in pairs(tab_chapter) do
		if v.mode_id == mode_id and (not TableEx.isInTable(vec_chapter, v.chapter_id)) then
			table.insert(vec_chapter, v.chapter_id)
		end
	end
	return vec_chapter
end

function ChapterData:getChapterIdx(mode_id, chapter_id, mission_id)
	local tab_chapter = cfg.chapterreward.chapterreward
	for k, v in pairs(tab_chapter) do
		if v.mode_id == mode_id and v.chapter_id == chapter_id and v.mission_id == mission_id then
			return v.idx
		end
	end
	return 1
end

function ChapterData:getMissionList(idx)
	local vec_mission = {}
	local now_config = cfg.chapterreward.chapterreward[idx]
	if not now_config then
		return vec_mission
	end

	for i, v in ipairs(cfg.chapterreward.chapterreward) do
		if v.mode_id == now_config.mode_id and v.chapter_id == now_config.chapter_id then
			table.insert(vec_mission, v)
		end
	end
	return vec_mission
end

function ChapterData:getMissionStatus(idx, max_idx)
	local chapter_config = cfg.chapterreward.chapterreward[idx]
	if not chapter_config then
		return -1
	end

	-- 如果之前没通关任何关卡。则第一关是开放的
	if chapter_config.idx == max_idx then
		return 0
	end

	-- 如果章节id大于自身最大id。则不能通关
	if chapter_config.idx > max_idx then
		return -1
	end

	-- 这个关卡已经通关
	return 1
end

function ChapterData:getBattleStatus(idx, level)

	local chapter_config = cfg.chapterreward.chapterreward[idx]

	-- 已经通关所有关卡
	local chapter_num = table.nums(cfg.chapterreward.chapterreward)
	if idx > chapter_num then
		return -4
	end

	if not chapter_config then
		return -1
	end

	-- -- 战力不足
	-- if chapter_config.combat_effectiveness > ex.Player.fighting then
	-- 	return -2
	-- end

	-- 等级不足
	if chapter_config.level > level then
		return -3
	end



	-- 可以挑战
	return 0
end

-- 0 已经领取  1 不可领取  2 可以领取
function ChapterData:getChapterRewardStatus(idx, max_id)
	local config = TableEx.findValueFunction(cfg.firstrewardchapter.firstrewardchapter, function(value)
		return value.chapter == idx
	end)

	if not config then
		return 1
	end
		
	if config.chapter <= max_id then
		local is_reward = TableEx.isInTable(self.vec_chapter_reward, config.chapter)
		if is_reward then
			return 0
		end
		return 2
	end
	return 1
end

function ChapterData:rewardFirst(idx)
	table.insert(self.vec_chapter_reward, idx)
end


function ChapterData:getChapterMap()
	-- local chapter_config = cfg.chapterreward.chapterreward[ self:getNowIdx()]

	local max_idx = table.nums(cfg.chapterreward.chapterreward)
	local idx = Maths.clampf(self.chapter_id, 1, max_idx)
	local chapter_config = cfg.chapterreward.chapterreward[idx]
	if not chapter_config then
		return nil
	end
	
	return string.format("ccbi-res/chapter/%s.jpg", chapter_config.map)
end

function ChapterData:getChapterHangMap()
	-- local chapter_config = cfg.chapterreward.chapterreward[ self:getNowIdx()]

	local max_idx = table.nums(cfg.chapterreward.chapterreward)
	local idx = Maths.clampf(self.chapter_id, 1, max_idx)
	local chapter_config = cfg.chapterreward.chapterreward[idx]
	if not chapter_config then
		return nil
	end
	
	return string.format("ccbi-res/chapter/hang/%s_F.png", chapter_config.map)
end

function ChapterData:getChapterHangMapBackground()
	-- local chapter_config = cfg.chapterreward.chapterreward[ self:getNowIdx()]

	local max_idx = table.nums(cfg.chapterreward.chapterreward)
	local idx = Maths.clampf(self.chapter_id, 1, max_idx)
	local chapter_config = cfg.chapterreward.chapterreward[idx]
	if not chapter_config then
		return nil
	end
	
	return string.format("ccbi-res/chapter/hang/%s_B.jpg", chapter_config.map)
end

function ChapterData:sortReward()
	-- idx是非连续的。
	-- 排序
	-- local tab_reward = {}
	-- self.vec_chapter_reward_status = {}

	local max_idx = ex.Player.chapter_data.chapter_id
	for i,v in pairs(cfg.firstrewardchapter.firstrewardchapter) do
		local data = {}
		data.idx = v.idx
		data.status = ex.Player.chapter_data:getChapterRewardStatus(v.chapter, max_idx)
		self.vec_chapter_reward_status[data.idx] = data
	end

	local func_sort = function(a, b)
		local comp_a = a.status * -100000 + a.idx
		local comp_b = b.status * -100000 + b.idx
		return comp_a < comp_b
	end

	table.sort(self.vec_chapter_reward_status, func_sort)
end

function ChapterData:updateFirstRewardRedDot()
	self:sortReward()
	local is_visible = TableEx.findFunction(self.vec_chapter_reward_status, function(value )
		return value.status == 2
	end)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZD_TGJL, is_visible)
end

function ChapterData:updateMissionBattleRedDot()
	-- local now_idx = ex.Player.chapter_data:getNowIdx() 
	-- local max_idx = ex.Player.chapter_data:getMaxIdx()
	local status = ex.Player.chapter_data:getBattleStatus(self.chapter_id + 1, ex.Player.level)
	-- local chapter_config = cfg.chapterreward.chapterreward[now_idx]
	
	local is_visible = status == 0 or status == -1

	-- print("ChapterData:updateMissionBattleRedDot", is_visible, now_idx, ex.Player.level)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZD_ZXZD, is_visible)

end

-- 有两个协议需要用到它
function ChapterData:resExtraReward(list)
	local vec_idx = {}
	for k,v in pairs(cfg.chapterextrareward.chapterextrareward) do
		table.insert(vec_idx, v.idx)
	end

	table.sort(vec_idx, function(a, b)
		return a < b
	end)

	local vec_chapter_extra_reward = {}
	for i,v in ipairs(vec_idx) do
		local is_reward = TableEx.findValueFunction(list, function(value)
			return v == value
		end)
		
		local data = {}
		data.idx = v
		data.is_reward = is_reward ~= nil

		table.insert(vec_chapter_extra_reward, data)
	end

	self.vec_chapter_extra_reward = vec_chapter_extra_reward
end

function ChapterData:getNowExtraReward()
	for i, v in ipairs(self.vec_chapter_extra_reward) do
		if v.is_reward ~= true then
			return v.idx
		end
	end
	return nil
end

function ChapterData:isExtraRewardAll()
	return self:getNowExtraReward() == nil
end

function ChapterData:checkExtraRewardReddot()
	local is_visible = false
	local now_idx = self:getNowExtraReward()
    local chapter_id = self.chapter_id
	if now_idx ~= nil then
		local extra_config = cfg.chapterextrareward.chapterextrareward[now_idx]
		is_visible = chapter_id >= extra_config.chapter
    end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZD_STJL, is_visible)
end

return ChapterData
