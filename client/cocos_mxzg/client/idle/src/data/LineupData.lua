local LineupData = class("LineupData")

LineupData.vec_lineup = {}

function LineupData:ctor()
	self.vec_lineup = {}
	self.max_fighting = 0
	self.server_max_fighting = 0
	self.assistance_unlock = true	-- 是否可以开启助阵功能
end

function LineupData:resLineup(data, assistance_unlock)
	for i,v in ipairs(data) do
		-- dump(v, "resLineup")
		local team_data = {}
		team_data.goddess_type = v.goddess_type
		team_data.time = v.time
		team_data.type = v.type
		team_data.formation_id = v.formation_id

		team_data.hero_list = {}
		for ih,vh in ipairs(v.hero_list) do
			local hero_data = {}
			hero_data.hero_id = vh.hero_id
			hero_data.hp = vh.hp
			hero_data.position = vh.position
			team_data.hero_list[vh.position] = hero_data
		end

		-- 补够9个位置
		local hero_num = table.nums(team_data.hero_list)
		for i=1, LineupIdxMax do
			if team_data.hero_list[i] == nil then
				local hero_data = {}
				hero_data.hero_id = 0
				hero_data.hp = 0
				hero_data.position = i
				team_data.hero_list[i] = hero_data
			end
		end

		self.vec_lineup[v.type] = team_data
		-- dump(team_data, "team_data")
	end

	self.assistance_unlock = assistance_unlock or false

	self:checkChapterTeam()
	-- add 熊梦 再调用一次主城英雄按钮的红点刷新 
	-- 因为有的时候因为网络问题，checkChapterTeam还没执行 导致battle_list英雄出战队列还未赋值
	-- 但是initRedPoint()已经执行完毕 并且获取battle_list的时候为nil 
	-- 所以有时候会出现主城英雄按钮红点 不显示的问题 
	ex.Player.hero_data:initRedPoint()
	-- dump(self.vec_lineup, "self.vec_lineup")
end

function LineupData:setLineup(type, vec_hero, fetter_type, formation_id)
	if self.vec_lineup[type] then
		self.vec_lineup[type] = nil
	end

	local data = {}
	data.type = type
	data.time = 0
	data.goddess_type = fetter_type or 0
	data.formation_id = formation_id or 0

	data.list_count = table.nums(vec_hero)
	data.hero_list = vec_hero

	self.vec_lineup[type] = data

	-- 发送数据
	local req = Battle_pb.GReqLineUpSave()
	req.lineData.type = data.type
	req.lineData.time = data.time
	req.lineData.goddess_type = data.goddess_type
	req.lineData.formation_id = data.formation_id
	for k,v in pairs(vec_hero) do
		local hero_data = req.lineData.hero_list:add()
		hero_data.hero_id = v.hero_id
		hero_data.hp = v.hp
		hero_data.position = k
	end
	NetManager:sendMessage(ProtocolID.GReqLineUpSave, req)
	
	ex.EventManager:fire(EVENT.BATTLE_EVENT.HANG_LINE_UP, type)
	
	if type == LineupType.CHAPTER then
		self:checkChapterTeam()
	end
end

function LineupData:checkChapterTeam()
	local vec_hero = ex.Player.lineup_data:getIdList(LineupType.CHAPTER, {NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID})

	--红点检测
	ex.Player.hero_data.promote:initBattlelist()

	for k,v in pairs(vec_hero) do
		if v ~= 0 then 
			ex.Player.hero_data.promote:setBattleHero(v)

			ex.Player.hero_data.promote:checkCanUpLevel(v)
			ex.Player.hero_data.promote:checkHeroCanUpgrade(v)
		end
	end
	
	ex.Player.hero_data.promote:initUpStarRedPoint()
	local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
	local artifact_red = false
	if bool == false then
		for _,hero_id in pairs(vec_hero) do
			if hero_id ~= NULL_ID then
				local reds = ex.Player.hero_data.artifact:checkRedPointByHeroId(hero_id)
				for _,show_red in pairs(reds) do
					if show_red == true then
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

-- 是否是无效阵容，1-8号位置无英雄
function LineupData:isNullBattleList(type)
	local vec_lineup = self.vec_lineup[type]
	if not vec_lineup then
		return true
	end

	for i=1,LineupNum do
		if vec_lineup.hero_list[i] == nil or vec_lineup.hero_list[i].hero_id <= 0 then
			return true
		end
	end

	return false
end

function LineupData:getIdList(type, vec_default)
	local vec_lineup = self.vec_lineup[type]
	if not vec_lineup then
		return vec_default or {}, 0, 1
	end

	local num = #vec_lineup.hero_list
	local vec_hero = {}
	for i=1,num do
		table.insert(vec_hero, vec_lineup.hero_list[i].hero_id)
	end

	return vec_hero, vec_lineup.goddess_type, vec_lineup.formation_id
end

function LineupData:getLineup(type)
	return self.vec_lineup[type]
end

-- 获得神器类型
function LineupData:getFettersType(type)
	local lineup_data = self.vec_lineup[type]
	return (lineup_data == nil or lineup_data.goddess_type == nil) and -1 or lineup_data.goddess_type
end

function LineupData:setLineupById(type, vec_battle, fetter_type, formation_id)
	local vec_hero = {}
    for k, v in pairs(vec_battle) do
        local data = {}
        data.hero_id = v
        data.hp = 10000
        table.insert(vec_hero, data)
    end
	self:setLineup(type, vec_hero, fetter_type, formation_id)
end

function LineupData:isLineup(battle_type)
	local battle_config = cfg.battletype.battletype[battle_type]
	if not battle_config then
		print("battle_config is nil")
		return false
	end
	
	local vec_hero, goddess_type = self:getIdList(battle_config.battle_config.line_up_type, {NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID})
	local is_null = TableEx.findValueFunction(vec_hero, function(value)
		return value ~= NULL_ID
	end)
	return is_null ~= nil
end

return LineupData