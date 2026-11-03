local DragonData = class("DragonData")

function DragonData:ctor()
	self.dragon_room_level = 1		-- 龙界等级
	self.dragon_level = 1			-- 圣龙等级
	self.vec_dragon_rooms = {}		-- 龙界鉴定位信息
	self.vec_hallows = {}			-- 穿戴的圣物列表
	self.privilege_end_time = 0		-- 特权将定位结束时间

	self.vec_collection = {}		-- 图鉴收藏列表，如果未获得过则显示问号
end

-- 根据龙界鉴定等级，获取消耗的遗物类型
function DragonData:getRemainsConfigByLevel(level)
	for k,v in pairs(cfg.dragonremains.dragonremains) do
		if v.type == 1 and v.level == level then
			return v
		end
	end
	
	return nil
end

function DragonData:getDragonLevelMaxByGrade(grade)
	local level_max = 0
	for k,v in pairs(cfg.dragonlevel.dragonlevel) do
		if v.grade == grade and v.level > level_max then
			level_max = v.level
		end
	end
	
	return level_max
end

-- 获取对应龙界剩余所需鉴定时间
function DragonData:getIdentifyLeftTime(room_type)
	for i,v in ipairs(self.vec_dragon_rooms) do
		if v.type == room_type then
			if v.level <= 0 then
				return -1, 0
			end

			-- 获取剩余鉴定点数
			local need_point = 0
			for k,v2 in pairs(cfg.dragonremains.dragonremains) do
				if v2.type == 1 and v2.level == v.level then
					need_point = v2.point
				end
			end
			local speed = cfg.dragonidentify.dragonidentify[self.dragon_room_level].speed
			local now = ex.Game:getServerTime()

			need_point = need_point - (now - v.start_time) * speed - v.speed_add
			need_point = (need_point > 0) and need_point or 0

			-- 根据剩余点数计算所需时间
			local left_time = math.floor(need_point / speed)
			if left_time < 0 then
				left_time = 0
			end

			return left_time, need_point
		end
	end

	return -1, 0
end

function DragonData:checkReddot()
	local visible = false
	local is_free = false
	local is_open = ex.Player.level >= cfg.opencondition.condition["main_dragon"].condition_value 

	-- 检测龙界是否有空闲槽位
	local now = ex.Game:getServerTime()
	for k,v in pairs(self.vec_dragon_rooms) do
		if v.type == 1 or self.privilege_end_time > now then
			if self:getIdentifyLeftTime(v.type) <= 0 then
				is_free = true
				break
			end
		end
	end

	-- 检测是否有遗物
	if is_free == true then
		for k,v in pairs(cfg.dragonremains.dragonremains) do
			if v.type == 1 and ex.Player:getItemNum(v.cost[1].item_type) > 0 then
				visible = true
				break
			end
		end
	end

	-- 设置鉴定红点
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_SL_JD_JDC, visible and is_open)
	
	-- 检测圣龙是否可升级
	local is_can_uplevel = true
	local config_level_next = cfg.dragonlevel.dragonlevel[self.dragon_level + 1]
	if config_level_next == nil then
		is_can_uplevel = false
	else
		local config_level = cfg.dragonlevel.dragonlevel[self.dragon_level]
		for i,v in ipairs(config_level.item_require) do
			if ex.Player:getItemNum(v.item_type) < v.item_num then
				-- 资源不足
				is_can_uplevel = false
				break
			end
		end
	end
	
	-- 设置升级红点
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_SL_LJ_SJ, is_can_uplevel and is_open)
	
	-- 检测是否有空闲生物槽，如果有则检测是否有空闲圣物，否则检测装备的圣物是否可升星
	local has_hallows_equip = false
	local has_hallows_upstar = false
    for i=1,4 do
        local hallows_data = nil
        for _,tmp_hallows in ipairs(self.vec_hallows) do
            if tmp_hallows.pos == i then
                hallows_data = tmp_hallows
                break
            end
		end

		if hallows_data == nil then
            
        elseif hallows_data.item_type > 0 then
			local config_relic = cfg.dragonrelic.dragonrelic[hallows_data.item_type]
			if config_relic ~= nil then
				if config_relic.up_star_require == "" or table.nums(config_relic.up_star_require) <= 0 then
					-- has_hallows_upstar = false
				else
					local can_up_star = true
					for _,item_need in ipairs(config_relic.up_star_require) do
						if ex.Player:getItemNum(item_need.item_type) < item_need.item_num then
							can_up_star = false
							break
						end
					end
					if can_up_star then
						has_hallows_upstar = true
					end
				end
			end
		else
			for _,item_backpack in pairs(ex.Player.backpack_data.backpack_list) do
				local item_config = cfg.item.item[item_backpack.item_type]
				if item_config == nil then
					print("item_type not found", item_backpack.item_type)
				end

				if item_config.mode == ItemData.IT_HALLOWS then
					local is_equip = false
					for _,tmp_hallows in ipairs(self.vec_hallows) do
						if tmp_hallows.item_type == item_backpack.item_type then
							is_equip = true
							break
						end
					end
					if not is_equip then
						has_hallows_equip = true
						break
					end
				end
			end
		end
	end

	-- 设置圣物装备红点，设置圣物升星红点
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_SL_LJ_SWC_KX, has_hallows_equip and is_open)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_SL_LJ_SWC_SWSX, has_hallows_upstar and is_open)
end

return DragonData