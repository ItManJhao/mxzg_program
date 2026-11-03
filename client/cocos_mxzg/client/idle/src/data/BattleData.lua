local BattleData = class("BattleData")


function BattleData:ctor()
	self.quick_battle_count  = 0
	self.quick_total_num = 0
	self.quick_free = 0
	self.max_battle_count = 0
	self.is_promotion = false
	self.is_privilege = false
end

function BattleData:QuickNums()
	local data = cfg.speedupcost.count
	local te = ex.Player.promotion_data:isExistSpeedBattlePrivilege()
	local key = "cost_gem"
	if te == true then 
		key = "cost_gem_adv"
	end

	self.quick_free = 0
	self.quick_total_num = 0
	for k,v in pairs(data) do
		if v[key] == 0 then self.quick_free = self.quick_free + 1 end
		if te == true then 
			self.quick_total_num = self.quick_total_num + 1
		else
			if v[key] ~= -1 then 
				self.quick_total_num = self.quick_total_num + 1
			end
		end
	end

end

function BattleData:showQuickNums()
	local data = cfg.speedupcost.count
	local te = true
	local key = "cost_gem_adv"


	local quick_free = 0
	local quick_total_num = 0
	for k,v in pairs(data) do
		if v[key] == 0 then quick_free = quick_free + 1 end
		if te == true then 
			quick_total_num = quick_total_num + 1
		end
	end
	return quick_free , quick_total_num
end

function BattleData:getQuickFree()
	return self.quick_free
end

function BattleData:getQuickTotal()
	return self.quick_total_num
end

function BattleData:setBattleCount(num)
	self.quick_battle_count = num
end

function BattleData:getBattleCount()
	return self.quick_battle_count
end

function BattleData:setQuickTotalNum(num)
	self.quick_total_num = num
end

function BattleData:getFreeCount()
	local count = 0
	-- 特权读cost_gem_adv.无特权读cost_gem
	local key = self.is_privilege and "cost_gem_adv" or "cost_gem"
	for i,v in ipairs(cfg.speedupcost.count) do
		if  v[key] == 0 then
			count = count + 1
		end
	end
	return count
end

function BattleData:getQuickBattleData()
	local cost_gem = 0
	local cur_count = self.quick_battle_count
	local max_count = self.max_battle_count
	local promotion_count = self.quick_battle_count - (self.is_promotion and ex.Tools:getSysCfg("promotion_speed_fight_get_free_times") or 0) + 1
	local config = cfg.speedupcost.count[promotion_count]

	if cur_count >= max_count then
		cost_gem = -1
		return cost_gem, cur_count, max_count
	end

	if not config then
		return cost_gem, cur_count, max_count
	end

	local key = self.is_privilege and "cost_gem_adv" or "cost_gem"
	local free_count = self:getFreeCount()
	if promotion_count < free_count then
		cost_gem = 0
	else
		cost_gem = config[key]
	end

	return cost_gem, cur_count, max_count
end

function BattleData:checkQuickRedDot()
	
	local cost_gem, cur_count, max_count = self:getQuickBattleData()
	local is_red = cost_gem == 0 and ex.Player.chapter_data.chapter_id > 0
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZD_KSZD_KSZD, is_red)

	-- 无效
	-- local te = ex.Player.promotion_data:isExistSpeedBattlePrivilege()
	-- local key = "cost_gem"
	-- if te == true then 
	-- 	key = "cost_gem_adv"
	-- end

	-- local count = ex.Player.battle_data:getBattleCount()
	-- count = count + 1
	-- local conf = cfg.speedupcost.count[count]
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZD_KSZD, not (conf ~= nil and conf[key] > 0))
end

function BattleData:getBattleHalo(vec_hero)
	-- 计算当前队伍元素{elem=count, elem=count}
	local vec_hero_elem = {}
	for k,v in pairs(vec_hero) do
		local hero_type = type(v) == "number" and v or v.hero_type
		local config = cfg.herotype.star[hero_type]
		if config ~= nil then 
			vec_hero_elem[config.elem] = vec_hero_elem[config.elem] and vec_hero_elem[config.elem] + 1 or 1
		end 
	end

	-- 获取符合条件的idx {elem=count, elem=count}
	local vec_idx = {}
	for i,v in ipairs(cfg.elementaddition.elementaddition) do
		-- {elem=count, elem=count}
		local vec_elem = {}
		-- 取出表元素条件
		for ie,ve in ipairs(v.elements) do
			vec_elem[ve] = vec_elem[ve] and vec_elem[ve] + 1 or 1
		end

		-- 比对队伍是否跟表元素条件是否相同
		local is_match = true
		for ke,ve in pairs(vec_elem) do
			-- 条件符合
			if vec_hero_elem[ke] == nil or vec_hero_elem[ke] < ve then
				is_match = false
				break
			end
		end

		if is_match then
			-- 过滤相同类型的属性加成
			local tmp_index = TableEx.getIndexFunction(vec_idx, function(value)
				return cfg.elementaddition.elementaddition[value].type == cfg.elementaddition.elementaddition[v.idx].type
			end)

			if tmp_index > 0 then
				vec_idx[tmp_index] = vec_idx[tmp_index] > v.idx and vec_idx[tmp_index] or v.idx
			else
				table.insert(vec_idx, v.idx)
			end
		end
	end

	-- local tmp_vec_attr = {}
	-- for k,v in pairs(vec_idx) do
	-- 	local vec_ability = cfg.elementaddition.elementaddition[v].ability
	-- 	for ia,va in ipairs(vec_ability) do

	-- 		tmp_vec_attr[va.attr] = tmp_vec_attr[va.attr] and (tmp_vec_attr[va.attr] + va.value) or va.value
	-- 	end
	-- end

	-- local vec_attr = {}
	-- for k,v in pairs(tmp_vec_attr) do
	-- 	table.insert(vec_attr, {attr = k, value=v} )
	-- end

	local vec_attr = {}
	for k,v in pairs(vec_idx) do
		local vec_ability = cfg.elementaddition.elementaddition[v].ability
		for ia,va in ipairs(vec_ability) do
			local attr_data = TableEx.findValueFunction(vec_attr, function(value)
				return value.attr == va.attr
			end)
			
			if attr_data then
				attr_data.value = attr_data.value + va.value
			else
				table.insert(vec_attr,clone(va))
			end
		end
	end

	table.sort(vec_idx, function(a, b)
		return a > b
	end)

	local icon = ""
	local vec_type = {}
	for i, v in ipairs(vec_idx) do
		table.insert(vec_type, cfg.elementaddition.elementaddition[v].type)
	end

	table.sort(vec_type, function(a, b)
		return a > b
	end)

	if vec_type[1] ~= nil and vec_type[1] == 6 then
		icon = "6"
	else
		for i,v in ipairs(vec_type) do
			icon = icon .. tostring(v)
		end
	end

	if icon == "" then
		icon = "10000"
	end

	return vec_idx, vec_attr, icon, vec_type
end

function BattleData:getBattleMap(mode)
	for k,v in pairs(cfg.map.map) do
		if mode == v.play_mode then
			return "ccbi-res/chapter/" .. v.map_name .. ".jpg"
		end
	end
	return nil
end


function BattleData:canSkipBattle(battle_type, is_show_tip)
    if ex.Player.total_charge > 0 then
        return true
    end

    local need_level = ex.Tools:getSysCfg("battle_skip_level")
    if ex.Player.level >= need_level then
        return true
	end

    if is_show_tip == true then
		ex.MessageView:add(string.format(ex.Tools:getLang(41037), need_level))	
	end
	return false
end

function BattleData:canChangeSpeed(battle_type, speed, is_show_tip)
    speed = speed + 1
    if speed <= 1 then
        return true
    end

    local key = "battle_speed_" .. speed .. "x"
    local config_vip = ex.Player.fetter_data:getSpeedConfig(key)
     if config_vip ~= nil then
		if config_vip.vip_level > ex.Player.fetter_data.vip.vip_level then
			if is_show_tip == true then
				ex.MessageView:add(string.format(ex.Tools:getLang(47518), config_vip.vip_level))
			end
        else
            return true
        end
    end
    return false
end


return BattleData
