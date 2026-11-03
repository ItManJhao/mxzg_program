local DailyDungeonData = class("DailyDungeonData")

function DailyDungeonData:ctor()
	-- {type = count}
	self.mission_count = {}

	-- {type = id}
	self.mission_list = {}
end

function DailyDungeonData:setMissionCount(type, num)
	self.mission_count[type] = num
end

function DailyDungeonData:addMissionCount(type, num)
	self.mission_count[type] = self.mission_count[type] and (self.mission_count[type] + num) or math.max(0, num)
	print(self.mission_count[type])
end

function DailyDungeonData:getMissionCount(type)
	return self.mission_count[type] and self.mission_count[type] or 0
end

function DailyDungeonData:getMissionCountStatus(type)
	local num = self:getMissionCount(type)

	local limit_num = ex.Tools:getSysCfg("daily_mission_free_tickets")
	if num >= limit_num then

		-- 免费次数和vip次数都用完了
		-- print(limit_num, cfg.vip.vip[ex.Player.vip_level].extra_resource_times, num)
		if limit_num + cfg.goddessvip.goddessvip[ex.Player.fetter_data.vip.vip_level].extra_resource_times <= num then
			return 3
		end
		-- if limit_num <= num then
		-- 	return 3
		-- end

		-- 可以购买次数
		return 2
	end

	-- 使用免费次数
	return 0
end

function DailyDungeonData:setMissionId(type, num)
	local mission_id = self.mission_list[type] or 0
	self.mission_list[type] = math.max(mission_id, num)
end

function DailyDungeonData:getMissionId(type)
	return self.mission_list[type] and self.mission_list[type] or 0
end


function DailyDungeonData:getNowTypeCost(type)
	local num = self:getMissionCount(type)
	local need_gem = 0
	for k,v in pairs(cfg.dailymissioncost.dailymissioncost) do
		if v.mission_type == type and (num + 1) == v.battle_num and v.cost ~= "" and table.nums(v.cost) > 0 then 
			need_gem = v.cost[1].item_num
		end
	end
	return need_gem
end


-- add 熊梦 判断等级是否符合要求
-- true:符合
-- false:不符合
function DailyDungeonData:bLevelreach( level )
	return  ex.Player.level>=level
end 

function DailyDungeonData:getMissionIdMax(type)
	local mission_id = self.mission_list[type] or 0
	local battle_num = ex.Player.fighting		-- 战力
	local level = ex.Player.level 				-- 等级
	local mission_index = 0

	-- add 熊梦
	-- 判断条件更改为等级和战力
	-- open_level：开启等级
	-- power_require：开启战力
	for i,v in ipairs(cfg.dailymissionreward.dailymissionreward) do
		if v.mission_type == type and battle_num >= v.power_require and level >= v.open_level then
			mission_index = v.mission
		end
	end

	return math.max(mission_id, mission_index)
end


function DailyDungeonData:getMonsterList(type, mission_id)
	local mission_table = nil
	if type == 1 then
		mission_table = cfg.dailymissiongold.dailymissiongold
	elseif type == 2 then
		mission_table = cfg.dailymissionexp.dailymissionexp
	elseif type == 3 then
		mission_table = cfg.dailymissionpieces.dailymissionpieces
	elseif type == 4 then
		mission_table = cfg.dailymissiongoddess.dailymissiongoddess
	elseif type == 5 then
		mission_table = cfg.dailymissionelf.dailymissionelf
	end
	
	local vec_monster = {}
	for i, v in ipairs(mission_table) do
		if v.mission_id == mission_id and v.hero_type ~= 0 then
			table.insert(vec_monster, v)
		end
	end
	return vec_monster
end

function DailyDungeonData:getMissionTable(type, idx)
	-- local mission_table = nil
	-- if type == 1 then
	-- 	mission_table = cfg.dailymissiongoldreward.dailymissiongoldreward
	-- elseif type == 2 then
	-- 	mission_table = cfg.dailymissionexpreward.dailymissionexpreward
	-- elseif type == 3 then
	-- 	mission_table = cfg.dailymissionpiecesreward.dailymissionpiecesreward
	-- elseif type == 4 then
	-- 	mission_table = cfg.dailymissiongoddessreward.dailymissiongoddessreward
	-- elseif type == 5 then
	-- 	mission_table = cfg.dailymissionelfreward.dailymissionelfreward
	-- end

	-- if idx then
	-- 	return mission_table[idx]
	-- end
	-- return mission_table

	if idx == nil then
		local vec_mission = {}	
		for i,v in ipairs(cfg.dailymissionreward.dailymissionreward) do
			if v.mission_type == type then
				table.insert(vec_mission, v)
			end
		end
		return vec_mission
	else
		for i,v in ipairs(cfg.dailymissionreward.dailymissionreward) do
			if v.mission_type == type and v.mission == idx then
				return v
			end
		end
	end
	return nil
end

function DailyDungeonData:updateRedDot()
	local limit_num = ex.Tools:getSysCfg("daily_mission_free_tickets")
	local battle_num = ex.Player.fighting


	local system_data = ex.JumpManager:getSystemDataByAtom("main_mission")
	
	for i=1,5 do
		
		local child_data = system_data[i]
		if child_data then 
			local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg(child_data.atom)
			if  isOpen then   
				-- 检查剩余次数
				local reddot = self:getMissionCount(i) < limit_num
				local mission_table = self:getMissionTable(i, 1)

				-- 判断战斗力
				reddot = reddot and (mission_table.power_require <= battle_num)
				-- print("i, reddot", i, reddot)
				if i == 1 then
					ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHFB_RCFBRK_FBJBFB, reddot)
				elseif i == 2 then
					ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHFB_RCFBRK_FBJYFB, reddot)
				elseif i == 3 then
					ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHFB_RCFBRK_FBSPFB, reddot)
				elseif i == 4 then
					ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHFB_RCFBRK_FBJBAFB, reddot)
				elseif i == 5 then
					ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHFB_RCFBRK_FBJLFB, reddot)			
				end
			end
		end 
	end
end

return DailyDungeonData