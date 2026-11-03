local FetterData = class("FetterData")

function FetterData:ctor()


	self.vip = require("src.data.FetterVIPData").new(self)

	self.vip_selected_type = 0

	-- 女神重置次数。所有女神共享这个次数
	self.reset_count = 0

	-- 根据下标。索引对应的羁绊类型
	self.vec_idx = {}
	for k,v in pairs(cfg.goddessunlock.goddessunlock) do
		table.insert(self.vec_idx, v.type)
	end

	local sort = function(a,b)
		return a.type > b.type
	end
	table.sort(self.vec_idx)

	local data = {}
	data.type = 0
	data.exp = 0
	data.level = 0
	data.skill_level = 0
	data.refine_level = 0
	data.uplimit_level = 0
	data.wash_level = 0 -- add 熊梦 洗炼等级
	self.vec_fetter = {}
	for k,v in pairs(cfg.goddessunlock.goddessunlock) do
		data.type = v.type
		self.vec_fetter[data.type] = clone(data)
	end

	-- 羁绊幻化任务数据
	self.lllusion_task_cfg = {}
	for k,v in pairs(cfg.goddessfashionmission.goddessfashionmission) do
        table.insert(self.lllusion_task_cfg,v)
    end
    local function sor (a, b)
		return a.idx <  b.idx
	end
	table.sort( self.lllusion_task_cfg, sor )
	

	self:registerEvent()

	self.fetterContractInfo ={}

	-- 羁绊幻化数据
	self.fetterIllusionInfo ={}

	-- 羁绊幻化任务进度数据
	self.fetterIllusionTaskInfo ={}

	-- 监听道具更新
	--self:addEventTemp(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM,handler(self,self.checkExchangeShopRedDot)) 
end

function FetterData:addEventTemp(event,listener)
    if not self.eventList then self.eventList = {} end
    table.insert(self.eventList,ex.EventManager:add(event,listener))
end

function FetterData:registerEvent()
	self.event_list = {
		-- ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD,handler(self,self.initRedPoint)),
		ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD,handler(self,self.checkReddot)),
		ex.EventManager:add(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST,handler(self,self.checkReddot)),
	}
end

function FetterData:setFetterContractInfo(data)
	self.fetterContractInfo = data
end


--------------------------------------羁绊幻化----------------------------------------
-- 幻化
function FetterData:setFetterIllusionData(data)
	self.fetterIllusionInfo = data
end

-- 检幻化红点
function FetterData:checkIllusionReddot(type)
	local is_visible = false
	local redskin1 = true
	local redskin2 = true
	local unlock = self:isUnlockAll() 
	if not unlock then return is_visible end

	local open_config = cfg.opencondition.condition["main_fetter_Illusion"]
	if not open_config then
		return is_visible
	end
	if ex.Player.level < open_config.condition_value then
		return is_visible
	end

	-- 激活后 redskin1 redskin2 为false
	if self.fetterIllusionInfo.active_type ~= nil then
		for i,v in ipairs(self.fetterIllusionInfo.active_type) do
			if v == 1 then
				redskin1 = false
			elseif v == 2 then
				redskin2 = false
			end
		end
	end
	
	-- 熔炼红点
	if not is_visible then
		local origin_config = cfg.goddessfashionsmelt.goddessfashionsmelt[1].origin_item[1]
		local target_config = cfg.goddessfashionsmelt.goddessfashionsmelt[1].target_item[1]
		local origin_num = ex.Player:getItemNum(origin_config.item_type)
		local target_num =  math.floor((origin_num / origin_config.item_num) * target_config.item_num) 
		if target_num > 0 then
			is_visible = true
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_HHT_RL, true)
		else
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_HHT_RL, false)
		end
	end

	-- 皮肤一 激活红点
	if redskin1 then
		local suretask = 0
		for i,v in ipairs(ex.Player.fetter_data.fetterIllusionTaskInfo) do
			if v.had_reward then
				suretask = suretask + 1
			end
		end
		if suretask >= #ex.Player.fetter_data.lllusion_task_cfg then
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_HHT_HHZBQH_PFYJH, true)
		else
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_HHT_HHZBQH_PFYJH, false)
		end
	else
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_HHT_HHZBQH_PFYJH, false)
	end

	-- 皮肤一 任务领取红点
	if redskin1 and not is_visible then
		for i,v in ipairs(self.lllusion_task_cfg) do
			if is_visible then break end
			for index,value in ipairs(self.fetterIllusionTaskInfo) do
				if value.task_id == v.idx and value.process >= v.task.target and not value.had_reward then	
					is_visible = true
					break
				end
			end
		end
	end

	-- 皮肤二激活红点
	--if redskin2 then
		local config = cfg.goddessfashiontype.goddessfashiontype[2].need_item[1]
		if ex.Player:getItemNum(config.item_type) >= config.item_num and redskin2 then
			is_visible = true
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_HHT_HHYBQH_PFEJH, true)
		else
			ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_HHT_HHYBQH_PFEJH, false)
		end
	--end 

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB_HHT, is_visible)

	return is_visible
end

-- 幻化皮肤激活
function FetterData:setFetterIllusionskinActivation(data)
	if self.fetterIllusionInfo.active_type ~= nil then
		for i,v in ipairs(self.fetterIllusionInfo.active_type) do
			if v == data.type then
				return		
			end	
		end 
	else
		self.fetterIllusionInfo.active_type = {}
	end
	table.insert(self.fetterIllusionInfo.active_type,data.type)
	-- 检查红点
	self:checkIllusionReddot()
	ex.EventManager:fire(EVENT.FETTER_EVENT.ILLUSION_SKIN_ACTIVATION)
end

-- 设置幻化任务
function FetterData:setFetterIllusionTaskData(data)
	self.fetterIllusionTaskInfo = data.task

	-- 检查红点
	self:checkIllusionReddot()
end

-- 幻化任务更新
function FetterData:UpdataFetterIllusionTaskData(data)
	for i,v in ipairs(self.fetterIllusionTaskInfo) do
		if v.task_id == data.task[1].task_id then
			v.had_reward = data.task[1].had_reward
			v.process = data.task[1].process
		end
	end
	-- 检查红点
	self:checkIllusionReddot()

	-- 更新任務
	ex.EventManager:fire(EVENT.FETTER_EVENT.ILLUSION_UPDATE_TASK)
end

-- 幻化领取奖励
function FetterData:UpdataFetterIllusionTaskDataTemp(data)
	for i,v in ipairs(self.fetterIllusionTaskInfo) do
		if v.task_id == data.task.task_id then
			v.had_reward = data.task.had_reward
			v.process = data.task.process
		end
	end
	-- 检查红点
	self:checkIllusionReddot()

	-- 更新任務
	ex.EventManager:fire(EVENT.FETTER_EVENT.ILLUSION_UPDATE_TASK)
end

-- 幻化皮肤穿戴
function FetterData:UpdataFetterIllusionWear(data)
	self.fetterIllusionInfo.use_type = data.use_type
	ex.EventManager:fire(EVENT.FETTER_EVENT.ILLUSION_SKIN_WRAR)
end
------------------------------------------------------------------------------
function FetterData:changeFetterContractInfo(type)

	table.insert( self.fetterContractInfo, type )
end

function FetterData:checkFetterContractInfo()
	local res = false

	local flag = false
    for i,v in ipairs(self.fetterContractInfo) do
        if v == 1 then 
            flag = true
        end 
    end

	if not flag then
		local has_num = 0
		local max_num = 0
		for k,v in pairs(self.vec_fetter) do
			max_num = max_num + 1
			if v.level > 0  then 
				has_num  = has_num + 1
			end 
		end

		if has_num == max_num then 
			res = true
		end
	end

	return res
end

function FetterData:checkFetterRed()
	if not self:isUnlockOne() then return false end
	
	local fetter_type = ex.Player.lineup_data:getFettersType(0)
	if fetter_type <= 0 then
		return true
	end

	return false
end

function FetterData:checkContract2Info()
	local res = false
	
	local condInfo = cfg.system['contract_2_mission']
	local count = 0
    for i, v in ipairs(ex.Player.hero_data.hero_list) do
        if v.star >= condInfo.condition then
            count = count + 1
        end
	end
	
	if count > condInfo.target then
		res = true
	end

	return res
end

-- 根据下标。索引对应的羁绊类型
function FetterData:getFetterDataByIdx(idx)
	return self:getFetterData(self.vec_idx[idx])
end

function FetterData:getFetterIdxByType(type)
	-- dump(self.vec_idx, type, "getFetterIdxByType")
	for i,v in ipairs(self.vec_idx) do
		if v == type then
			return i
		end
	end
	return 1
end


function FetterData:saveSelectedFetterType(type)
	cc.UserDefault:getInstance():setIntegerForKey(string.format("fetter-selected-%s", ex.Player.role_id), type)
end

function FetterData:getSelectedFetterType()
	return cc.UserDefault:getInstance():getIntegerForKey(string.format("fetter-selected-%s", ex.Player.role_id), -1)
end

-- 根据类型。索引对应的羁绊数据
function FetterData:getFetterData(type)
	return self.vec_fetter[type]
end

-- 是否达到了最大等级
function FetterData:isMaxLevel(type)
	return false
end

-- 升级羁绊等级
function FetterData:uplevel(type)
	local req_level = Fetter_pb.GReqFetterUpLevel()
	req_level.idx = type
    NetManager:sendMessage(ProtocolID.GReqFetterUpLevel, req_level)

end

function FetterData:uplevelDone(type, level, exp)
	local data = self:getFetterData(type)

	-- 扣除资源
	-- local config = cfg.goddesslevel.goddesslevel[data.level]
	-- if config then
	-- 	ex.Player:addRes(ItemType.IT_FETTER_UNITY, -config.cost_item)
	-- 	ex.Player:addRes(ItemType.IT_GOLD, -config.cost_gold)
	-- end
	local vec_attr1 = self:getLevelAttr(data.level, data.exp)
	local vec_attr2 = self:getLevelAttr(level, exp)

	local is_uplevel = data.level ~= level
	data.level = level
	data.exp = exp

	-- 更新界面
	ex.EventManager:fire(EVENT.FETTER_EVENT.UPLEVEL)
	ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)

	if is_uplevel then
		require("src.layer.FettersResultCtr"):instance():openWindow("uplevel", data.type, level - 1, level, vec_attr1, vec_attr2)
		ex.AudioManager:playEffect("music/item-get.mp3")
	end
end

-- 升级羁绊技能等级
function FetterData:upskill(type)
	local req_level = Fetter_pb.GReqFetterUpSkill()
	req_level.idx = type
    NetManager:sendMessage(ProtocolID.GReqFetterUpSkill, req_level)
end

function FetterData:upskillDone(type, level)
	local data = self:getFetterData(type)

	-- 扣除资源
	-- local config = cfg.goddessskillcost.goddessskillcost[data.level]
	-- if config then
	-- 	ex.Player:addRes(ItemType.IT_FETTER_SIGNAL, -config.cost_item)
	-- 	ex.Player:addRes(ItemType.IT_GOLD, -config.cost_gold)
	-- end

	data.skill_level = level

	-- 更新界面
	ex.EventManager:fire(EVENT.FETTER_EVENT.UPSKILL)
	ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)

	require("src.layer.FettersResultCtr"):instance():openWindow("upskill", data.type, level - 1, level)
end


-- 发送羁绊幻任务数据
function FetterData:lllusiontask()
    local req = Fetter_pb.GReqFashionTasks()
    NetManager:sendMessage(ProtocolID.GReqFashionTasks, req)
end

-- 羁绊精炼等级
function FetterData:refine(type)
    local req_level = Fetter_pb.GReqFetterUpRefine()
    req_level.idx = type
    NetManager:sendMessage(ProtocolID.GReqFetterUpRefine, req_level)
end

-- 发送羁绊洗炼消息
function FetterData:baptism()
    local req = Fetter_pb.GReqFetterWash()
    NetManager:sendMessage(ProtocolID.GReqFetterWash, req)
end



-- add 熊梦 洗炼
function FetterData:baptismDone(type, level)

	local data = {}
	for key, value in pairs(self.vec_fetter) do
		value.wash_level =level
		data = value
	end

	--local vec_attr1 = self:getBaptismAttr(data.wash_level)

	-- 更新界面
	ex.EventManager:fire(EVENT.FETTER_EVENT.BAPTISM)
	ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)

	--require("src.layer.FettersResultCtr"):instance():openWindow("baptism", data.type, level - 1, level, vec_attr1, vec_attr2)
end

function FetterData:refineDone(type, level)
	local data = self:getFetterData(type)

	-- 扣除资源
	-- local config = cfg.goddessskillrefine.goddessskillrefine[data.level]
	-- if config then
	-- 	ex.Player:addRes(ItemType.IT_FETTER_STONE, -config.cost_item)
	-- 	ex.Player:addRes(ItemType.IT_GOLD, -config.cost_gold)
	-- end

	local vec_attr1 = self:getRefineAttr(data.type, data.refine_level)
	local vec_attr2 = self:getRefineAttr(data.type, level)

	data.refine_level = level

	-- 更新界面
	ex.EventManager:fire(EVENT.FETTER_EVENT.REFINE)
	ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)

	require("src.layer.FettersResultCtr"):instance():openWindow("refine", data.type, level - 1, level, vec_attr1, vec_attr2)
end


-- 
function FetterData:uplimit(type)
	local req_level = Fetter_pb.GReqFetterUplimit()
	req_level.idx = type
    NetManager:sendMessage(ProtocolID.GReqFetterUplimit, req_level)
    
	-- TEST
	-- local data = self:getFetterData(type)
	-- self:uplimitDone(type, data.uplimit_level + 1)
end

function FetterData:uplimitDone(type, level)
	local data = self:getFetterData(type)


	local vec_attr1 = self:getUplimitAttr(data.uplimit_level)
	local vec_attr2 = self:getUplimitAttr(level)

	-- 扣除资源
	data.uplimit_level = level
	
	-- 更新界面
	ex.EventManager:fire(EVENT.FETTER_EVENT.UPLIMIT)
	ex.EventManager:fire(EVENT.FETTER_EVENT.INFO)
	ex.EventManager:fire(EVENT.FETTER_EVENT.SKIN)

	require("src.layer.FettersResultCtr"):instance():openWindow("uplimit", data.type, level - 1, level, vec_attr1, vec_attr2)
end

-- 属性相关
function FetterData:getLevelAttr(level, exp)
	local vec_attr = {}
	vec_attr[AbilityType.AT_ATTACK_ADD] = 0
	vec_attr[AbilityType.AT_HP_ADD] = 0

	level = Maths.clampf(level, 1, table.nums(cfg.goddesslevel.goddesslevel))
	local config = cfg.goddesslevel.goddesslevel[level]

	if not config then
		return vec_attr
	end

	local prog = exp / config.point_add
	vec_attr[AbilityType.AT_ATTACK_ADD] = config.atk_base + config.atk_progress * prog
	vec_attr[AbilityType.AT_HP_ADD] = config.hp_base + config.hp_progress * prog
	
	return vec_attr
end


-- 获取精炼加成的属性
function FetterData:getRefineAttr(type, level)
	local vec_attr = {}
	vec_attr[AbilityType.AT_SKILL_ADD] = 0

	for k,v in pairs(cfg.goddessskillrefinelevel.goddessskillrefinelevel) do
		if v.type == type and v.level == level then
			vec_attr[AbilityType.AT_SKILL_ADD] = v.skill_atk
			return vec_attr
		end
	end
	return vec_attr
end

function FetterData:getRefineMaxLevel(type)
	local max_level = 0
	for k,v in pairs(cfg.goddessskillrefinelevel.goddessskillrefinelevel) do
		if v.type == type and v.level > max_level then
			max_level = v.level
		end
	end
	return max_level
end

--add 熊梦 获得洗炼最大等级
function FetterData:getBaptismMaxLevel()
	return #cfg.goddesswashattr.goddesswashattr
end

--add 熊梦 获取洗炼加成的属性 
function FetterData:getBaptismAttr(wash_level)
	local vec_attr = {}
	local level = wash_level + 1

	
	for i=1,2 do
		local data = {}
		data.attr = 0
		data.value = 0
		table.insert(vec_attr, data)
	end
	

	--local max_level = self:getBaptismMaxLevel()
	--level = level > max_level and max_level or level
	for k,v in pairs(cfg.goddesswashattr.goddesswashattr) do
		if v.wash_level == level  then
			if wash_level == 0 then
				vec_attr[1].attr = v.add_ability[1].attr
				vec_attr[1].value = 0
				vec_attr[2].attr = v.add_ability[1].attr
				vec_attr[2].value = v.add_ability[1].value
				return vec_attr
			else
				vec_attr[2].attr = v.add_ability[1].attr
				for j,h in pairs(v.ability) do 
					if h.attr == v.add_ability[1].attr then
						vec_attr[2].value = h.value
						break
					end
				end
			end
		end
	end

	for k,v in pairs(cfg.goddesswashattr.goddesswashattr) do
		if v.wash_level == wash_level  then
			for key, h in pairs(v.ability) do
				if h.attr == vec_attr[2].attr then
					vec_attr[1].attr = h.attr
					vec_attr[1].value = h.value
					break
				end
			end
		end
	end

	return vec_attr
end


-- 获取突破加成的属性
function FetterData:getUplimitAttr(level)
	local vec_attr = {}
	for k,v in pairs(cfg.goddessbreak.goddessbreak) do
		if v.lv == level and v.ability ~= "" then
			for h,hv in pairs(v.ability) do
				vec_attr[hv.attr] = hv.value
			end
			return vec_attr
		end
	end

	if table.nums(vec_attr) <= 0 then
		local config = cfg.goddessbreak.goddessbreak[table.nums(cfg.goddessbreak.goddessbreak) - 1]
		if config then
			for h,hv in pairs(config.ability) do
				vec_attr[hv.attr] = 0
			end
		end
	end
	
	return vec_attr
end

-- 获取羁绊的形态id
function FetterData:getSkin(fetter_type)
	local skin = 1
	local data = self:getFetterData(fetter_type)
	if not data then
		return fetter_type + skin - 1
	end

	-- for i=1,10 do
	-- 	local skill_num = config["skin"..i]
	-- 	if not skill_num then
	-- 		return skin
	-- 	end

	-- 	if data.skill_level <= skill_num then
	-- 		return fetter_type + skin - 1
	-- 	end

	-- 	skin = i
	-- end

	-- return fetter_type + skin - 1

	local config_passive = self:getPassive(fetter_type, data.skill_level)
	if not config_passive then
		return fetter_type
	end

	return fetter_type + config_passive.skin - 1
end

-- 获取羁绊最高形态id
function FetterData:getPerfectSkin(fetter_type)
	-- local config = cfg.goddesspassive.goddesspassive[fetter_type]
	-- if not config  then
	-- 	return fetter_type
	-- end

	-- for i=1,10 do
	-- 	local skill_num = config["skin"..i]
	-- 	if not skill_num then
	-- 		return skin
	-- 	end
	-- 	skin = i
	-- end

	local skin = 1
	for i,v in pairs(cfg.goddesspassive.goddesspassive) do
		if v.type == fetter_type and v.skin > skin then
		end
	end

	return fetter_type + skin - 1
end


-- 获取羁绊被动加成
function FetterData:getPassive(fetter_type, level)
	for i,v in ipairs(cfg.goddesspassive.goddesspassive) do
		if v.type == fetter_type and v.skill_level == level then
			return v
		end
	end
	return nil
end


-- 获取技能类型
function FetterData:getSkillType(fetter_type)
	local config = cfg.goddessskill.goddessskill[fetter_type]
	if not config then
		return 0
	end

	return config.skill or 0
end


function FetterData:getSkillLevelConfig(fetter_type, level)
	for k,v in pairs(cfg.goddessskilllevel.goddessskilllevel) do
		if v.type == fetter_type and v.level ==  level then
			return v
		end
	end

	return nil
end

function FetterData:getSkillRefineConfig(fetter_type, level)
	for k,v in pairs(cfg.goddessskillrefinelevel.goddessskillrefinelevel) do
		if v.type == fetter_type and v.level == level then
			return v
		end
	end

	return nil
end

-- 获取羁绊技能简介
function FetterData:getSkillInfo(fetter_type, skill_level, refine_level)
	
	local str_info = ""
	skill_level = skill_level or 1
	refine_level = refine_level or 0
	local skill_type = self:getSkillType(fetter_type)
	if skill_type == 0 then
		return str_info
	end

	local str_info = ex.Player.hero_data:getSkillDescription(skill_type, skill_level)

	local str_add = "" 
	local skill_atk = 0
	local config_level = self:getSkillLevelConfig(fetter_type, skill_level)
	if config_level then
		skill_atk = skill_atk + config_level.skill_atk
		str_add = tostring(skill_atk)
	end

	-- 有精炼属性时。文字额外显示精炼的加成
	local config_refine = self:getSkillRefineConfig(fetter_type, refine_level)
	if config_refine then
		-- skill_atk = skill_atk + 
		str_add = tostring(skill_atk + config_refine.skill_atk) .. string.format("（%d+%d）", skill_atk, config_refine.skill_atk)
	end
	str_info = string.format(str_info, str_add)
	return str_info
end


function FetterData:getSkillLevelAttr(fetter_type, skill_level)
	local vec_attr = {}

	for k,v in pairs(cfg.goddesspassive.goddesspassive) do
		if v.type == fetter_type and v.skill_level <= skill_level then
			local attr = v.ability ~= "" and v.ability or {}
			for k,v in pairs(attr) do
				vec_attr[v.attr] = vec_attr[v.attr] and (vec_attr[v.attr] + v.value) or v.value
			end
		end
	end

	return vec_attr
end

function FetterData:getSoulLevelAttr(fetter_type, soul_level)
	local vec_attr = {}
	
    local vec_attr = {}
    local fetter_data = self:getFetterData(fetter_type)
    if fetter_data then
        local config = cfg.goddessmakesoul.goddessmakesoul[fetter_data.level]
        if config then
            for k,v in pairs(config.ability) do
                vec_attr[v.attr] = vec_attr[v.attr] and vec_attr[v.attr] + v.value * soul_level or v.value * soul_level 
            end
        end
    end
	return vec_attr
end

function FetterData:getTeamAttr(fetter_type)
	-- local skin
	local vec_skill = {}
	for k,v in ipairs(cfg.goddesspassive.goddesspassive) do
		if v.type == fetter_type and v.ability_show ~= 0 then
			table.insert(vec_skill, {skill_level = v.skill_level, attr=v.ability_show})
		end
	end
	return vec_skill
end

-- add 熊梦 获得洗炼增加的数值
function FetterData:getBaptismTeamAttr(wash_level)
	-- local skin
	local vec_ability = {}
	for k,v in pairs(cfg.goddesswashattr.goddesswashattr) do
		if v.wash_level == wash_level then
			return v.ability
		end
	end
	return vec_ability
end

-- 返回属性数组
function FetterData:getHeroAbility(fetter_data)
	local vec_attr = {}
	if not fetter_data then
		return vec_attr
	end 

	local fetter_type = fetter_data.type or 0
	if fetter_type == 0 then
		return vec_attr
	end

	local level = math.max(fetter_data.level or 1, 1)
	local exp = fetter_data.exp or 0
	local uplimit_level = fetter_data.uplimit_level or 0
	local skill_level = math.max(fetter_data.skill_level or 1, 1)

	-- 等级增益
	local vec_level_attr = ex.Player.fetter_data:getLevelAttr(level, exp)
	for k,v in pairs(vec_level_attr) do
		vec_attr[k] = vec_attr[k] and (vec_attr[k] + v) or v
	end

	-- 突破增益
    local vec_uplimit_attr = ex.Player.fetter_data:getUplimitAttr(uplimit_level)
    for k,v in pairs(vec_uplimit_attr) do
    	if k == AbilityType.AT_ATTACK_UP and vec_attr[AbilityType.AT_ATTACK_ADD] then
    		vec_attr[AbilityType.AT_ATTACK_ADD] = vec_attr[AbilityType.AT_ATTACK_ADD] * (1.0 + v * 0.0001)
    	elseif k == AbilityType.AT_HP_MAX_BASE and vec_attr[AbilityType.AT_HP_ADD] then
			vec_attr[AbilityType.AT_HP_ADD] = vec_attr[AbilityType.AT_HP_ADD] * (1.0 + v * 0.0001)
    	end
    end

    -- 技能等级加成
    local vec_skill_attr = ex.Player.fetter_data:getSkillLevelAttr(fetter_type, skill_level)
    for k,v in pairs(vec_skill_attr) do
		vec_attr[k] = vec_attr[k] and (vec_attr[k] + v) or v
	end
	
    -- 技能等级增益
    return vec_attr
end

function FetterData:getSkin(fetter_type)
	local fetter_data = self:getFetterData(fetter_type)
	if not fetter_data then
		return fetter_type
	end

	local config = cfg.goddessbreak.goddessbreak[fetter_data.uplimit_level]
	if not config then
		return fetter_type
	end

	return fetter_type + config.skin - 1
end

function FetterData:getSkinByLevel(fetter_type, uplimit_level)
	local config = cfg.goddessbreak.goddessbreak[uplimit_level]
	if not config then
		return fetter_type
	end

	return fetter_type + config.skin - 1
end

function FetterData:isUnlockSkin(fetter_type, skin)
	local max_skin = self:getSkin(fetter_type)
	max_skin = max_skin - fetter_type + 1

	-- 转换。如果传进来的是形态id[10103]。则将形态id转成形态下标[3]..如果传进来的是下标。则不变
	skin = skin >= fetter_type and (skin - fetter_type + 1) or skin

	return max_skin >= skin 
end

function FetterData:isUnlock(fetter_type)
	local fetter_data = self:getFetterData(fetter_type)
	if not fetter_data then
		return false
	end

	return fetter_data.level > 0
end


function FetterData:isUnlockOne()
	if table.nums(self.vec_fetter) <= 0 then
		return false
	end
	
	for k,v in pairs(self.vec_fetter) do
		if v.level > 0 then
			return true
		end
	end
	
	return false
end


function FetterData:isUnlockAll()
	if table.nums(self.vec_fetter) <= 0 then
		return false
	end
	
	for k,v in pairs(self.vec_fetter) do
		if v.level <= 0 then
			return false
		end
	end

	return true
end

function FetterData:getSpeedConfig(key)
	local index = 0
	local num = table.nums(cfg.goddessvip.goddessvip)
	for i=1,num do
		local config = cfg.goddessvip.goddessvip[index]

		if config and config[key] and config[key] == 1 then
			return config
		end

		index = index + 1
	end

	return nil
end

function FetterData:getResetCost()
	local vec_cost = {}
	for i,v in ipairs(cfg.goddessreset.goddessreset) do
		-- print(self.reset_count >= v.times_low and self.reset_count <= v.times_up, self.reset_count , v.times_low , v.times_up)
		if self.reset_count >= v.times_low and self.reset_count <= v.times_up then
			vec_cost = clone(v.need)
			-- table.insert(vec_cost, v.need)
			break
		end
	end
	return vec_cost
end

function FetterData:getResetBack(type)
	local vec_back = {}
	local fetter_data = self:getFetterData(type)
	if not fetter_data then
		print("FetterData:getResetBack is nil")
		return vec_back
	end

	local insert_cost = function(tab, cost_res)
		if cost_res == nil or tab == nil or cost_res == "" then
			print("cost_res == nil or tab == nil", cost_res == nil , tab == nil)
			return
		end

		for k,v in pairs(cost_res) do
			tab[v.item_type] = (tab[v.item_type] ~= nil) and (tab[v.item_type] + v.item_num) or v.item_num
		end
	end

	-- 计算等级返还的资源
	for i=1,fetter_data.level do
		local cost = {}
		local config = cfg.goddesslevel.goddesslevel[i]
		if config then
			local added_point = config.need_point
			if i == fetter_data.level then
				-- 获得不满级时的点数
				added_point = fetter_data.exp
			end

			local add_count = added_point / config.point_add

			for j=1,add_count do
				insert_cost(vec_back, config.cost_res)
			end
		end
	end

	-- 计算技能返还的资源
	for i=2,fetter_data.skill_level do
		local config = cfg.goddessskillcost.goddessskillcost[i - 1]
		if config then
			insert_cost(vec_back, config.cost_res)
		end
	end

	-- 计算精炼返还的资源
	for i=1,fetter_data.refine_level do
		local config = cfg.goddessskillrefine.goddessskillrefine[i]
		if config then
			insert_cost(vec_back, config.cost_res)
		end
	end

	-- 计算突破返还的资源
	for i=1,fetter_data.uplimit_level do
		local config = cfg.goddessbreak.goddessbreak[i-1]
		if config then
			insert_cost(vec_back, config.cost_res)
		end
	end

	-- 计算洗炼返还的资源
	for i=1,fetter_data.wash_level do
		local config = cfg.goddesswashattr.goddesswashattr[i-1]
		if config then
			insert_cost(vec_back, config.cost_res)
		end
	end

	-- 重新封装返回的物品
	local tmp_back = {}
	for k,v in pairs(vec_back) do
		table.insert(tmp_back, {item_type = k, item_num = v})
	end

	return tmp_back
end


-- 检查最外面的红点
function FetterData:checkReddot()
	if self:isUnlockAll() ~= true then
		return
	end

	local is_visible = false

	-- 升级红点
	if is_visible == false or (all and all == true) then
		for k,v in pairs(self.vec_fetter) do
			is_visible = self:checkLevelReddot(k)
			if is_visible == true then
				break
			end
		end
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB, is_visible)
	end

	-- 技能红点
	if is_visible == false or (all and all == true) then
		for k,v in pairs(self.vec_fetter) do
			is_visible = self:checkSkillReddot(k)
			if is_visible == true then
				break
			end
		end
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB, is_visible)
	end

	-- 突破红点
	if is_visible == false or (all and all == true) then
		for k,v in pairs(self.vec_fetter) do
			is_visible = self:checkUplimitReddot(k)
			if is_visible == true then
				break
			end
		end
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB, is_visible)
	end

	-- 铸魂红点
	if is_visible == false or (all and all == true) then
		for k,v in pairs(self.vec_fetter) do
			is_visible = self:checkSoulReddot(k)
			if is_visible == true then
				break
			end
		end
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB, is_visible)
	end

	-- 洗炼红点
	if is_visible == false or (all and all == true) then
		for k,v in pairs(self.vec_fetter) do
			is_visible = self:checkBaptismReddot(k)
			if is_visible == true then
				break
			end
		end
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB, is_visible)
	end

	-- 幻化
	if is_visible == false or (all and all == true) then
		is_visible = self:checkIllusionReddot() 
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHJB, is_visible)
	end

	return is_visible
end

function FetterData:isEnoughRes(config)
	if not config then
		return false
	end

	local cost_res = config.cost_res ~= "" and (config.cost_res or config.cost_item) or {}

	if table.nums(cost_res) <= 0 then
		return false
	end

	local is_enough = true
	for i,v in ipairs(cost_res) do
		local has_material = ex.Player:getItemNum(v.item_type)
		if has_material < v.item_num then
			is_enough = false
			break
		end
	end

	return is_enough
end

-- 获取铸魂数据
function FetterData:getSoulData(type)
	local has = 0
	local need = 0
	local soul_level = 0
	local level_max = 0
	local fetter_data = self:getFetterData(type)
	if not fetter_data then
		return has, need , soul_level, level_max
	end
	
	soul_level = fetter_data.soul_level

	local config = cfg.goddessmakesoul.goddessmakesoul[fetter_data.level]
	if config then
		has = ex.Player:getItemNum(config.cost_item[1].item_type)
		need = config.cost_item[1].item_num
		level_max = config.limit
	end

	return has, need, soul_level, level_max
	-- ex.EventManager:fire(EVENT.FETTER_EVENT.SOUL_UPDATE, has, need)
	-- ex.EventManager:fire(EVENT.FETTER_EVENT.SOUL_UPDATE_LEVEL, fetter_data.soul_level, level_max)
end

-- 检查升级红点
function FetterData:checkLevelReddot(type)
	local is_visible = false
	local fetter_data = ex.Player.fetter_data:getFetterData(type)
	if fetter_data then
		local max_level = table.nums(cfg.goddesslevel.goddesslevel)
		if fetter_data.level < max_level then
			is_visible = self:isEnoughRes(cfg.goddesslevel.goddesslevel[math.max(fetter_data.level, 1)])
		end
	end
	return is_visible
end

-- 检查技能红点
function FetterData:checkSkillReddot(type)
	local is_visible = false

	local fetter_data = ex.Player.fetter_data:getFetterData(type)
	if fetter_data then
		local max_level = table.nums(cfg.goddessskillcost.goddessskillcost)
		local config = cfg.goddessskillcost.goddessskillcost[math.max(fetter_data.skill_level, 1)]
		if fetter_data.skill_level < max_level and config ~= nil then
			is_visible = self:isEnoughRes(config) and fetter_data.level >= config.need_base_level
		end
	end

	return is_visible
end

-- 检查突破红点
function FetterData:checkUplimitReddot(type)
	local is_visible = false

	local fetter_data = self:getFetterData(type)
	if fetter_data then
		local max_level = table.nums(cfg.goddessbreak.goddessbreak) - 1
		local config = cfg.goddessbreak.goddessbreak[fetter_data.uplimit_level]
		is_visible = self:isEnoughRes(config)
	end

	return is_visible
end

-- 检查洗炼红点
function FetterData:checkBaptismReddot(type)
	local is_visible = false

	local fetter_data = self:getFetterData(type)
	if fetter_data then
		local config = cfg.goddesswashattr.goddesswashattr[fetter_data.wash_level]
		if fetter_data.level < config.level then
			return false
		end
		is_visible = self:isEnoughRes(config)
	end

	return is_visible
end

-- 检查铸魂红点
function FetterData:checkSoulReddot(type)
	if self:isUnlockAll() ~= true then
		return false
	end

	local is_visible = false

	-- 最大等级的女神才有红点
	local fetter_max_level = 0
	for k,v in pairs(self.vec_fetter) do
		if v.level > fetter_max_level then
			fetter_max_level = v.level
		end
	end

	local fetter_data = self:getFetterData(type)
	if fetter_data then
		local config = cfg.goddessmakesoul.goddessmakesoul[fetter_data.level]
		if config then
			is_visible = fetter_data.level == fetter_max_level
			is_visible = is_visible and fetter_data.soul_level < config.limit
			is_visible = is_visible and self:isEnoughRes(config)
		end
	end
	return is_visible
end


return FetterData
