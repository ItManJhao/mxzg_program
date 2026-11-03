local HeroAbilityData = class("HeroAbilityData")


-- 英雄属性说明
-- 	背包中的英雄属性由后端计算
-- 	图鉴中的英雄属性由前端计算，只显示基础数值

function HeroAbilityData:ctor()
	self.hero_id = NULL_ID
	self.hero_type = 0
	self.level = 0
	self.stage = 0
	self.star = 0
	self.atk = 0
	self.hp = 0
	self.def = 0
	self.spd = 0
	--进化阶段
	self.evolve = {
		type = 0,
		level = 0
	}
end

-- 该函数已废弃
function HeroAbilityData:updateAbility()
	self.vec_ability = {}

	local ability = ex.Player.hero_data:getHeroAttribute(self.hero_type, self.stage, self.star, self.level)
	for k,v in pairs(ability) do
		self[k] = v
	end

	-- print(ex.Tools:getLang(47129), self:getAtk(), self:getHp(), self:getDef())
	local vec_equip_ability = self:updateEquipAbility()
	-- print(ex.Tools:getLang(47653), self:getAtk(), self:getHp(), self:getDef())

	-- print(ex.Tools:getLang(47129), self:getAtk(), self:getHp(), self:getDef())
	local vec_stone_ability = self:updateStoneAbility()
	-- print(ex.Tools:getLang(47457), self:getAtk(), self:getHp(), self:getDef())

	local vec_clan_ability = ex.Player.clan_data:getSkillAbilityNumByList(ex.Player.clan_data.clan_skill_list or {})

	-- 工会属性
	local hero_type_config = cfg.herotype.star[self.hero_type]
	if hero_type_config then
		vec_clan_ability = vec_clan_ability[hero_type_config.occupation]
		if vec_clan_ability then
			for k,v in pairs(vec_clan_ability) do
				self.vec_ability[k] = self.vec_ability[k] and (self.vec_ability[k] + v) or v
			end
		end
	end
	-- print(ex.Tools:getLang(47745), self:getAtk(), self:getHp(), self:getDef())


	-- 英雄被动技能.暂时不封装.
	local vec_skill_ability = {}
	local vec_skill = {} -- ex.Player.hero_data:getHeroSkillList(self.hero_type)

	-- 
	local addRunesSkill = function(skill_type, level)
		local skill_data = TableEx.findValueFunction(vec_skill, function(value)
			return value.skill_type == skill_type
		end)

		if skill_data ~= nil then
			skill_data.level = level > skill_data.level and level or skill_data.level
		else
			table.insert(vec_skill, {skill_type = skill_type, level = level})
		end
	end

	-- 获取英雄符文信息
	local runes_data = ex.Player.backpack_data:getRunesDataByHeroId(self.hero_id)
	if runes_data ~= nil then
		for k,v in pairs(runes_data) do
			local runes_cfg = cfg.runestype.runestype[v.item_type]
			if runes_cfg ~= nil then
				local ability = ex.Player.backpack_data:getRunesAbilityConfig(runes_cfg.rare, v.ability_id)
				if ability ~= nil then
					self.vec_ability[ability.attr] = self.vec_ability[ability.attr] and (self.vec_ability[ability.attr] + ability.value) or ability.value

					if v.skill[1] ~= nil and v.skill[1].skill_id > 0 then
						-- table.insert(vec_skill, {skill_type = v.skill[1].skill_id, level = v.skill[1].level } )
						addRunesSkill(v.skill[1].skill_id, v.skill[1].level)
					end

					if v.skill[2] ~= nil and v.skill[2].skill_id > 0 then
						-- table.insert(vec_skill, {skill_type = v.skill[2].skill_id, level = v.skill[2].level })
						addRunesSkill(v.skill[2].skill_id, v.skill[2].level)
					end
				end
			end
		end
	end

	-- 天赋生效, 天赋跟精灵技能是冲突的
	for i=1, 2 do
		local talent = ex.Player.hero_data:getTalentByIDAndSlot(self.hero_id, i)
		if talent and talent.skill_id ~= 0 then
			addRunesSkill(talent.skill_id, talent.level)
			-- self:getSkillAbility(vec_skill_ability, talent.skill_id, talent.level)
		end
	end

	-- 精灵和天赋被动生效
	for i,v in ipairs(vec_skill) do
		self:getSkillAbility(vec_skill_ability, v.skill_type, v.level)
	end


	vec_skill = ex.Player.hero_data:getHeroSkillList(self.hero_type)
	for i,v in ipairs(vec_skill) do
		-- 英雄被动技能生效
		local skill_level = ex.Player.hero_data:getHeroSkillLevel(self.stage, self.star, i, self.hero_type)
		self:getSkillAbility(vec_skill_ability, v, skill_level)
	end

	-- 将被动额外加的属性添加到自身属性是上面
	for k,v in pairs(vec_skill_ability) do
		self.vec_ability[k] = self.vec_ability[k] and (self.vec_ability[k] + v) or v
	end
	-- print(ex.Tools:getLang(47599), self:getAtk(), self:getHp(), self:getDef())


	-- 前端不计算战斗力

	local bat = 0
	local vec_type = {
		atk = "getAtk",
		hp = "getHp",
		def = "getDef",
	}

	for k,v in pairs(cfg.scorecount.equip) do
		local func = vec_type[v.type]
		if func then
			local ratio = v.ratio / 10000
			local num = self[func](self) * ratio
			bat = bat + num
		end
	end

	self.bat = math.floor(bat) * 3
	-- print(ex.Tools:getLang(47602), self.bat)
	
	return self
end


function HeroAbilityData:getSkillAbility(vec_skill_ability, skill_type, skill_level)

	-- 技能配置
	local config_skill = cfg.heroskill.getConfigByType(skill_type, skill_level)

	-- 读取对应的技能等级
	-- local skill_level = ex.Player.hero_data:getHeroSkillLevel(self.stage, self.star, i % 4)
	-- 是否计算英雄技能等级
	if config_skill and config_skill.count_stats == 1 and skill_level >= 1 then
		-- 遍历art
		for ka,a in pairs(config_skill.art_list) do
			-- 读取art
			local config_art = cfg.buffart.buffart[a]
			if config_art then
				-- 遍历buff
				for kb,b in pairs(config_art.buff_list) do
					-- 读取buff属性
					local config_buff = cfg.buff.buff[b]
					
					if config_buff and config_buff.type == 160 then
						-- 取出被动加的属性值
						-- local value = config_buff["value2_" .. tostring(skill_level)]
						local value = ex.StringUtil.splist(config_buff.value, "|")
						if value then
							local key = tonumber(value[1])
							local num = tonumber(value[2])
							vec_skill_ability[key] = vec_skill_ability[key] and (vec_skill_ability[key] + num) or num
						end
					elseif config_buff and config_buff.type == 163 then
						-- 取出被动加的属性值
						-- local value = config_buff["value1_" .. tostring(skill_level)]
						local value = ex.StringUtil.splist(config_buff.value, "|")
						if value then
							local key = AbilityType.AT_HP_MAX_BASE
							local num = tonumber(value[1])
							vec_skill_ability[key] = vec_skill_ability[key] and (vec_skill_ability[key] + num) or num
						end
					end
				end
			end
		end
	end

end



function HeroAbilityData:updateStoneAbility()

    local hero_jewel_data = ex.Player.hero_data:getHeroJewelListForHeroid(self.hero_id)
	if not hero_jewel_data.jewel_list then return end 
	local save_stone_list = {}
    for i,v in ipairs(hero_jewel_data.jewel_list) do
        if v.jewel_type and  v.jewel_type > 0 then 
            table.insert( save_stone_list, v.jewel_type )
        end 
    end

	if #save_stone_list > 0  then
		
		local return_vec_ability = self.getStoneAbility(save_stone_list, self.hero_id)
		
		-- vec_result[v1.attr] = v1.value


		-- for k1,v1 in pairs(show_data.attr) do
		-- 	if vec_result[v1.attr] then	
		-- 		vec_result[v1.attr] = vec_result[v1.attr] + v1.value
		-- 	else
		-- 		vec_result[v1.attr] = v1.value
		-- 	end
		-- end


		for k,v in pairs(return_vec_ability) do
			if self.vec_ability[k] then	
				self.vec_ability[k] = self.vec_ability[k] + v
			else
				self.vec_ability[k] = v
			end
		end
		
	end

	return self.vec_ability
end


function HeroAbilityData:updateEquipAbility()
	local equip_data = ex.Player.hero_data.equip:getHeroEquip(self.hero_id)
	self.vec_ability = {}

	if equip_data then
		self.vec_ability = self.getEquipAbility(equip_data.equip_list)
	end

	return self.vec_ability
end

function HeroAbilityData:updateEquipAbilityOnShare(equip_list)
	self.vec_ability = {}

	-- if equip_data then
		self.vec_ability = self.getEquipAbility(equip_list)
	-- end

	return self.vec_ability
end




HeroAbilityData.getStoneAbility = function(vec_stone, hero_id)
	local vec_result = {}

	for k,v in pairs(vec_stone) do
		if v== 0 then break end 
		local  stone_config = cfg.jeweltype.jeweltype[v]
		for k1,v1 in pairs(stone_config.ability) do
			if vec_result[v1.attr] then	
				vec_result[v1.attr] = vec_result[v1.attr] + v1.value
			else
				vec_result[v1.attr] = v1.value
			end
		end
	end



    local hero_star_num, hero_min_star = ex.Player.hero_data:checkHeroStoneTao(hero_id)
    
    local min_star = cfg.jewelsettype.jewelsettype[1]
    local max_star = cfg.jewelsettype.jewelsettype[#cfg.jewelsettype.jewelsettype]
    
    local show_data = {}
    local show_num = 0

    if min_star.star > hero_min_star then 
        show_data = min_star
    end 

    if max_star.star < hero_min_star then 
        show_data = max_star
    end 

    for i,v in ipairs(cfg.jewelsettype.jewelsettype) do
        if v.star == hero_min_star then 
            show_data = v
            show_num = hero_star_num
        end 
    end

	if show_num >= 3 then 
		for k1,v1 in pairs(show_data.attr) do
			if vec_result[v1.attr] then	
				vec_result[v1.attr] = vec_result[v1.attr] + v1.value
			else
				vec_result[v1.attr] = v1.value
			end
		end
	end 
	return vec_result
end





HeroAbilityData.getEquipAbility = function(vec_equip)
	local vec_result = {}

	-- dump(vec_equip)
	-- 套装属性
	-- 计算多个套装属性
	local vec_set = {}
	for k,v in pairs(vec_equip) do
		local config = cfg.equipmenttype.equip[v.item_type] 
		if config and config.set_type ~= 0 then
			if vec_set[config.set_type] then
				vec_set[config.set_type] = vec_set[config.set_type] + 1
			else
				vec_set[config.set_type] = 1
			end
		end
	end


	-- 取套装属性
	local max_num = 4
	for k,v in pairs(vec_set) do
		-- local config_set = cfg.equipmentsettype.set[k]
		for i=2,v do
			-- print(i, v)
			local data = ex.Player.hero_data.equip:getEquipSetConfig(k, i)
			if data then
				for ka,va in pairs(data.attr) do
					if vec_result[va.attr] then
						vec_result[va.attr] = vec_result[va.attr] + va.value
					else
						vec_result[va.attr] = va.value
					end
				end
			end
		end
	end

	-- dump(vec_result, "getEquipAbility")
	
	-- 单件装备属性
	for k,v in pairs(vec_equip) do
		local vec_ability = ex.Player.hero_data.equip:getEquipAbilityList(v.item_type)

		-- 合并相同属性
		for k1,v1 in pairs(vec_ability) do
			if vec_result[k1] then	
				vec_result[k1] = vec_result[k1] + v1
			else
				vec_result[k1] = v1
			end
		end
	end
	return vec_result
end

function HeroAbilityData:getAtk()
	-- local atk_multiple = self.vec_ability[AbilityType.AT_ATTACK_UP] and (1.0 + self.vec_ability[AbilityType.AT_ATTACK_UP] * 0.0001) or 1
	-- return (self.atk + (self.vec_ability[AbilityType.AT_ATTACK_ADD] or 0 )) * atk_multiple
	return self.atk
end

function HeroAbilityData:getHp()
	-- local hp_multiple = self.vec_ability[AbilityType.AT_HP_MAX_BASE] and (1.0 + self.vec_ability[AbilityType.AT_HP_MAX_BASE] * 0.0001) or 1
	-- return (self.hp + (self.vec_ability[AbilityType.AT_HP_ADD] or 0 )) * hp_multiple
	return self.hp
end

function HeroAbilityData:getDef()
	-- local def_multiple = self.vec_ability[AbilityType.AT_DEFENSE_UP] and (1.0 + self.vec_ability[AbilityType.AT_DEFENSE_UP] * 0.0001) or 1
	-- return (self.def + (self.vec_ability[AbilityType.AT_DEFENSE_ADD] or 0 )) * def_multiple
	return self.def
end

function HeroAbilityData:getSpd()
	-- local spd_multiple = self.vec_ability[AbilityType.AT_SPEED_UP] and (1.0 + self.vec_ability[AbilityType.AT_SPEED_UP] * 0.0001) or 1
	-- return (self.spd + (self.vec_ability[AbilityType.AT_SPEED_BASE] or 0)) * spd_multiple
	return self.spd
end

-- 战斗时使用的属性
function HeroAbilityData:getBattleAtk()
	return self.atk
end

function HeroAbilityData:getBattleHp()
	return self.hp
end

function HeroAbilityData:getBattleDef()
	return self.def
end

function HeroAbilityData:getBattleSpd()
	return self.spd
end


function HeroAbilityData:getAbilityData(type, stage, star, level)
	local data = HeroAbilityData:new()
	data.hero_id = NULL_ID
	data.hero_type = type
	data.level = level
	data.stage = stage
	data.star = star
	data.equip = {}

	-- 图鉴不计算被动技能
	
	-- data:updateAbility()

	-- local hp_multiple = data.vec_ability[AbilityType.AT_HP_MAX_BASE] and (1.0 + data.vec_ability[AbilityType.AT_HP_MAX_BASE] * 0.0001) or 1
	-- data.hp = (data.hp + (data.vec_ability[AbilityType.AT_HP_ADD] or 0 )) * hp_multiple

	-- local atk_multiple = data.vec_ability[AbilityType.AT_ATTACK_UP] and (1.0 + data.vec_ability[AbilityType.AT_ATTACK_UP] * 0.0001) or 1
	-- data.atk = (data.atk + (data.vec_ability[AbilityType.AT_ATTACK_ADD] or 0 )) * atk_multiple

	-- local def_multiple = data.vec_ability[AbilityType.AT_DEFENSE_UP] and (1.0 + data.vec_ability[AbilityType.AT_DEFENSE_UP] * 0.0001) or 1
	-- data.def = (data.def + (data.vec_ability[AbilityType.AT_DEFENSE_ADD] or 0 )) * def_multiple

	-- local spd_multiple = data.vec_ability[AbilityType.AT_SPEED_UP] and (1.0 + data.vec_ability[AbilityType.AT_SPEED_UP] * 0.0001) or 1
	-- data.spd = (data.spd + (data.vec_ability[AbilityType.AT_SPEED_BASE] or 0)) * spd_multiple

	data:updateBaseAbility()
	return data
end

function HeroAbilityData:updateBaseAbility()
	self.vec_ability = {}
	local ability = ex.Player.hero_data:getHeroAttribute(self.hero_type, self.stage, self.star, self.level)
	for k,v in pairs(ability) do
		self[k] = v
	end
end

return HeroAbilityData
