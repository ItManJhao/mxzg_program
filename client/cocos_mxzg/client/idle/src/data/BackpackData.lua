local BackpackData = class("BackpackData")

function BackpackData:ctor(n, parent)
	self.parent = parent
    self.backpack_list = {}
	self.piece_red = {}
    self.runes_list = {}
	self.god_equip_list = {}
	self.magic_wand_list = {}
	
	self.prop_limit_time_list = {}		-- 限时道具[{item_id, item_type, end_time}]

	-- self.runes_list = {}	-- 符文列表 {item_id, item_type, ability_id, skill{sort, skill_id, level}, exp,
							--			wash_ability_id, wash_skill{sort, skill_id, level}, hero_id, place}
end

function BackpackData:getRunesListNotWear()
	local data = {}
	for i,v in ipairs(self.runes_list) do
		if v.hero_id <= 0 then
			table.insert(data, v)
		end
	end

	local function sor(a, b)
		local score_a = 10000000 * (a.item_type % 100) + a.item_id
		local score_b = 10000000 * (b.item_type % 100) + b.item_id
		return score_a > score_b
	end
	table.sort(data, sor)

	return data
end

function BackpackData:getCombineConfig(item_type)
	local config = TableEx.findValueFunction(cfg.runescombine.runescombine, function(value)
        if value.type == item_type then
            return true
        end
    end)
    return config
end

function BackpackData:getTypeConfig(item_type)
	-- 遍历配置表
    local config = TableEx.findValueFunction(cfg.runestype.runestype, function(value)
        if value.type == item_type then
            return true
        end
    end)
    return config
end

function BackpackData:getRunesAbilityConfig(item_rare, ability_type)
	-- 遍历配置表
    local config = TableEx.findValueFunction(cfg.runesability.runesability, function(value)
        if value.rare == item_rare and value.type == ability_type then
            return true
        end
	end)
	if config == nil then
		return nil
	end
    return config.ability[1]
end

function BackpackData:getRunesSkillConfig(skill_type, skill_level)
	-- 遍历配置表
    local config = TableEx.findValueFunction(cfg.runeskilltype.skill, function(value)
        if value.skill_id == skill_type and value.level == skill_level then
            return true
        end
    end)
    return config
end

function BackpackData:addRunes(data)
	-- body
	data.item_tag = ItemData.IT_SPECIAL
	
	-- 如果存在则直接替换
	for i,v in ipairs(self.runes_list) do
		if v.item_id == data.item_id then 
			self.runes_list[i] = data
			return
		end
	end

	-- 如果不存在则直接添加
	table.insert(self.runes_list, data)
end

function BackpackData:deleteRunesById(runes_id)
	for i,v in ipairs(self.runes_list) do
		if v.item_id == runes_id then 
			table.remove(self.runes_list,i)
			break
		end
	end
end

function BackpackData:getRunesDataByHeroId(hero_id)
	local runes_data = {}
	for k,v in pairs(self.runes_list) do
		if v.hero_id == hero_id then 
			runes_data[v.place] = v
		end
	end
	return runes_data
end

function BackpackData:checkRunesRedByHero(hero_id)
	local runes = {}
	local red = false
	local reds = {}
	for i,v in ipairs(self.runes_list) do
		if v.hero_id == hero_id then 
			runes[v.place] = v
		end
	end
	local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
	if not hero_data then return red , reds end
	for i = 1 , 2 do 
		local key = i == 1 and "elf_1_unlock_level" or "elf_2_unlock_star"
		local value = ex.Tools:getSysCfg(key)
		local open = false


        local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(hero_id)
        local level = is_cube_hero and hero_data.tweak_cube_lv or hero_data.level 
		if i == 1 then 
			open = hero_data.level >= value
		else 
			open = hero_data.star >= value
		end

		local data = runes[i]
		if not data then 
			-- reds[i] = true and open 
			for idx,v in ipairs(self.runes_list) do
				if v.hero_id == 0 and open then 
					reds[i] = v.hero_id == 0 and open 
					if reds[i] == true then break end 
				end
			end
		else
			local conf = cfg.runestype.runestype[data.item_type]
			local rare = conf.rare
			for idx,v in ipairs(self.runes_list) do
				if v.hero_id == 0 and open then 
					reds[i] = cfg.runestype.runestype[v.item_type].rare > rare 
					if reds[i] == true then break end 
				end
			end
		end
	end

	for i,v in pairs(reds) do
		if v == true then red = true break end
	end
	return red,reds
end

function BackpackData:getRunesById(item_id)
	-- print("item_id", item_id)
	if (item_id == nil) or (tonumber(item_id) <= 0) then
		return nil
	end
	
	for _,v in pairs(self.runes_list) do
		if v.item_id == item_id then 
			return v
		end
	end
	return nil
end

-- 获取符文列表
function BackpackData:getRunesDataListByHeroList(vec_hero)
	local vec_runes = {}
	
	for k,v in pairs(vec_hero) do
		if v.hero_id then
			local result_data = {}
			result_data.hero_id = v.hero_id

			local tmp_runes = {}
			local runes_data = self:getRunesDataByHeroId(v.hero_id)

			if runes_data then
				for k2,v2 in pairs(runes_data) do
					table.insert(tmp_runes, v2)
				end
			end
			result_data.runes_list = tmp_runes
			table.insert(vec_runes, result_data)
		end
	end

	return vec_runes
end

function BackpackData:refreshBackpack()
	-- local req_backpack = cpp.ByteArray:create()
 	-- req_backpack:writeInt(ProtocolID.GReqBackPackList)
 	-- cpp.NetManager:instance():sendByteArray(req_backpack)
     NetManager:sendMessage(ProtocolID.GReqBackPackList)
end

-- 添加 或 减少 背包数据数量

function BackpackData:changeBackpack(item_type, item_num, item_id, ex_attr_idx, skill_type_1, skill_num_1, skill_type_2, skill_num_2)
	for i,v in ipairs(self.backpack_list) do
		if v.item_type == item_type and (item_id == NULL_ID or v.item_id == item_id) then
			v.item_num = v.item_num + item_num
			if v.item_num <= 0 then
				table.remove(self.backpack_list, i)
				ex.EventManager:fire(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST,item_type)
			end
			return
		end
	end

	-- 没有此数据 新增
	self:addNewBackpack(item_type, item_num, item_id, ex_attr_idx, skill_type_1, skill_num_1, skill_type_2, skill_num_2)

	ex.MainSceneCtr:addResEvent(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST, item_type)
	-- ex.EventManager:fire(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST, item_type)
end

--查询物品
function BackpackData:getItemById(item_id, is_runes)
	if item_id == nil then
		return nil
	end

	if tonumber(item_id) <= 0 then
		return nil
	end

	if is_runes == nil or is_runes == false then
		for _,v in pairs(self.backpack_list) do
			if v.item_id == item_id then 
				return v
			end
		end
		for _,v in pairs(self.god_equip_list) do
			if v.item_id == item_id then 
				return v
			end
		end
	else
		for _,v in pairs(self.runes_list) do
			if v.item_id == item_id then 
				return v
			end
		end
	end
	return nil
end

function BackpackData:getLimitTimeItemById(item_id)
	for _,v in pairs(self.prop_limit_time_list) do
		if v.item_id == item_id then 
			return v
		end
	end

	return nil
end

--查询物品
function BackpackData:removeItemById(item_id)
	if tonumber(item_id) <= 0 then
		return false
	end

	for i,v in pairs(self.backpack_list) do
		if tonumber(v.item_id) == tonumber(item_id) then 
			local item_type = v.item_type
			table.remove(self.backpack_list, i)
			ex.EventManager:fire(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST, item_type)
			return true
		end
	end
	return false
end

--查询物品类型的个数
function BackpackData:getItemNum(item_type)
	local prop_type = self:getPropType(item_type)

	if prop_type == ItemData.IT_RUNES then
		local item_num = 0
		for _,v in pairs(self.runes_list) do
			if v.item_type == item_type then 
				item_num = item_num + 1
			end
		end
		return item_num
	elseif prop_type == ItemData.IT_HERO_GODEQUIP then
		local item_num = 0
		for _,v in pairs(self.god_equip_list) do
			if v.item_type == item_type then 
				item_num = item_num + 1
			end
		end
		return item_num
	else
		for _,v in pairs(self.backpack_list) do
			if v.item_type == item_type then 
				return v.item_num
			end
		end
		return 0
	end
end

-- 新增背包数据
function BackpackData:addNewBackpack(item_type, item_num, item_id, ex_attr_idx, skill_type_1, skill_num_1, skill_type_2, skill_num_2)
	if item_num > 0 then
		local backpack = {}
		backpack.item_id = item_id
		backpack.item_type = item_type
		backpack.item_num = item_num
		-- backpack.ex_attr_idx = ex_attr_idx
		-- backpack.skill_type_1 = skill_type_1
		-- backpack.skill_num_1 = skill_num_1
		-- backpack.skill_type_2 = skill_type_2
		-- backpack.skill_num_2 = skill_num_2

		if item_type > 30000000 then -- 特殊
			backpack.item_tag = ItemData.IT_SPECIAL
		elseif item_type > 20000000 then -- 碎片
			backpack.item_tag = ItemData.IT_PIECE
		elseif item_type > 1100000 then -- 符文
			backpack.item_tag = ItemData.IT_RUNES
		elseif item_type > 1000000 then -- 装备
			backpack.item_tag = ItemData.IT_EQUIP
		elseif item_type > 900003 then -- 道具
			backpack.item_tag = ItemData.IT_PROP
		else -- 其他
			backpack.item_tag = ItemData.IT_INVALID
		end

		table.insert(self.backpack_list, backpack)
	end
end

-- 刷新限时道具
function BackpackData:refreshLimitTimeProp(prop_list)
	self.prop_limit_time_list = {}

	for i, v in ipairs(prop_list) do
		local prop = {}
		prop.item_id = v.item_id
		prop.item_type = v.item_type
		prop.item_num = v.item_num or 1
		prop.end_time = v.end_time
		prop.item_tag = ItemData.IT_PROP_LIMIT_TIME
		
		table.insert(self.prop_limit_time_list, prop)
	end
end

-- 是否为碎片 3:普通碎片 8:精英碎片
function BackpackData:isPiece(item_type)
	local item_config = cfg.item.item[item_type]
	if not item_config then
		return false
	end
	
	return item_config.mode == ItemData.IT_PIECE or item_config.mode == ItemData.IT_SPECIAL_ELITE
end

-- 显示一个背包数据
function BackpackData:createWithData(item_type, item_num, bg_path)
	local node = nil
	if self:isPiece(item_type) then -- 碎片
		node = require("src.comp.menu.UIMenuItemHeroPiece"):createWithData(item_type, false, bg_path)
		node:setNum(item_num)
	else -- 特殊 装备 道具 其他
		node = require("src.comp.menu.UIMenuItemBackpack"):createWithData(item_type, item_num, bg_path)
	end
	return node
end

-- 清除
function BackpackData:clear()
	self.backpack_list = {}
end

-- 获取类型总数
-- ItemData.IT_EQUIP 		= 1 -- 装备
-- ItemData.IT_PROP 		= 2 -- 道具
-- ItemData.IT_PIECE 		= 3 -- 碎片
-- ItemData.IT_SPECIAL		= 4	-- 特殊
function BackpackData:getLen(tag)
	local len = 0
	local equip = {}
  	for k, v in pairs(self.backpack_list) do
  		if not tag then
  			len = len + 1
  		else
  			if tag == ItemData.IT_EQUIP then 
  				if v.item_tag == tag then 
  					if not equip[v.item_type] then 
  						equip[v.item_type] = true
  						len = len + 1
  					end
  				end

  			else
	  			if v.item_tag == tag then
	  				len = len + 1
	  			end
	  		end
  		end
  	end
  	return len
end

function BackpackData:getItemsByTag(tag)
	local data = {}
	local equip = {}
	for k,v in pairs(self.backpack_list) do
		if tag == ItemData.IT_EQUIP and tag == v.item_tag  then 
			if not equip[v.item_type] then 
				equip[v.item_type] = 1 
			else
				equip[v.item_type] = equip[v.item_type] + 1 
			end
		elseif tag == v.item_tag then
			table.insert(data,v)
		end
	end

	if tag == ItemData.IT_EQUIP then
		for k,v in pairs(equip) do
			local item = {}
			item.item_id = "0"
			item.item_tag = tag 
			item.item_num = v 
			item.item_type = k
			table.insert(data, item)
		end
	elseif tag == ItemData.IT_HALLOWS then
		local item_tab = cfg.dragonrelic.dragonrelic
		table.sort(data, function(a, b)
			local config_a = item_tab[a.item_type]
			local config_b = item_tab[b.item_type]
			if config_a == nil or config_b == nil then
				return false
			end
			if config_a.star ~= config_b.star then return config_a.star > config_b.star end

			return config_a.relic_type < config_b.relic_type
		end)
	elseif tag == ItemData.IT_PIECE or tag == ItemData.IT_SPECIAL_ELITE then
		local item_tab = cfg.item.item
		local function sor(a, b)
			-- 20105007
			-- 100000000
			local item_a = item_tab[a.item_type]
			local item_b = item_tab[b.item_type]
			if item_a == nil or item_b == nil then
				return false
			end
			local score_a = 100000000 * item_a.star - item_a.sort
			local score_b = 100000000 * item_b.star - item_b.sort
			if item_a.use_value <= a.item_num then
				score_a = score_a + 1000000000
			end
			if item_b.use_value <= b.item_num then
				score_b = score_b + 1000000000
			end
			return score_a > score_b
		end
		table.sort(data, sor)

	elseif tag == ItemData.IT_SPECIAL then
		data = self:getRunesListNotWear()
	end

	return data
end

function BackpackData:getItemsByPageSign(tag)

	local cfg_item = cfg.item.item

	-- 排序函数的key = tag
	local sort_func_list = {}

	-- 装备的排序方式
	sort_func_list[ItemData.IT_EQUIP] = function(a, b)
		local confA = cfg.equipmenttype.equip[a.item_type]
        local confB = cfg.equipmenttype.equip[b.item_type]
        local rareA = confA ~= nil and confA.rare or 0
		local rareB = confB ~= nil and confB.rare or 0

		rareA = rareA + cfg_item[a.item_type].sort * 10000000
		rareB = rareB + cfg_item[b.item_type].sort * 10000000

        return rareA > rareB
	end

	-- 道具的排序方式
	sort_func_list[ItemData.IT_PROP] = function(a, b)
		local rareA = cfg_item[a.item_type].sort * 10000000
		local rareB = cfg_item[b.item_type].sort * 10000000

        return rareA > rareB
	end

	-- 道具的排序方式
	sort_func_list[ItemData.IT_PROP_LIMIT_TIME] = function(a, b)
		local rareA = cfg_item[a.item_type].sort * 10000000
		local rareB = cfg_item[b.item_type].sort * 10000000

        return rareA > rareB
	end

	-- 碎片的排序方式
	sort_func_list[ItemData.IT_PIECE] = function(a, b)
		-- 20105007
		-- 100000000
		local item_num_a = cfg_item[a.item_type].use_value
		local item_num_b = cfg_item[b.item_type].use_value
		local score_a = (item_num_a <= a.item_num and 1000000000000 or 0)
		local score_b = (item_num_b <= b.item_num and 1000000000000 or 0)

		score_a = score_a + cfg_item[a.item_type].sort * 100000
		score_b = score_b + cfg_item[b.item_type].sort * 100000

		return score_a > score_b
	end

	-- 特殊页的排序方式
	sort_func_list[ItemData.IT_SPECIAL] = function(a, b)
		local compA = a.item_type >= b.item_type                     and -1000000 or 0
        compA = compA + (tonumber(a.item_id) < tonumber(b.item_id)   and -1000    or 0)

        local compB = b.item_type >= a.item_type                     and -1000000 or 0
        compB = compB + (tonumber(b.item_id) < tonumber(a.item_id)   and -1000    or 0)
		
        return compA < compB
	end

	-- 道具的排序方式
	sort_func_list[ItemData.IT_HERO_STONE] = function(a, b)
		local rareA = cfg_item[a.item_type].sort * 10000000
		local rareB = cfg_item[b.item_type].sort * 10000000

        return rareA > rareB
	end

	-- 魔杖
	sort_func_list[ItemData.MAGIC_WAND] = function(a, b)
		local rareA = cfg_item[a.item_type].sort * 10000000
		local rareB = cfg_item[b.item_type].sort * 10000000
		rareA = rareA + a.strengthen_lv;
		rareB = rareB + b.strengthen_lv;

        return rareA > rareB
	end
	

	-- 圣物的排序方式
	local config_hallows = cfg.dragonrelic.dragonrelic
	sort_func_list[ItemData.IT_HALLOWS] = function(a, b)
		local config_a = config_hallows[a.item_type]
		local config_b = config_hallows[b.item_type]
		if config_a == nil or config_b == nil then
			return false
		end
		if config_a.star ~= config_b.star then return config_a.star > config_b.star end

		return config_a.relic_type < config_b.relic_type
	end

	-- 神装的排序方式
	sort_func_list[ItemData.IT_HERO_GODEQUIP] = function(a, b)
		local rareA = cfg_item[a.item_type].sort * 10000000
		local rareB = cfg_item[b.item_type].sort * 10000000

        return rareA > rareB
	end

	-- 宠物的排序方式
	sort_func_list[ItemData.PET] = function(a, b)
		local proA = cfg.pet.pet[a.item_type]
		local proB = cfg.pet.pet[b.item_type]
		-- if proA.elem ~= proB.elem then 
		-- 	if proA.rare ~= proB.rare then 
		-- 		return proA.rare > proB.rare
		-- 	else
		-- 		return a.level > b.level
		-- 	end
		-- else
		-- 	if proA.rare ~= proB.rare then 
		-- 		return proA.rare > proB.rare
		-- 	else
		-- 		return a.level > b.level
		-- 	end
		-- end

		if proA.rare ~= proB.rare then return proA.rare > proB.rare end
		if proA.elem ~= proB.elem then return proA.elem > proB.elem end
		if a.level ~= b.level then return a.level > b.level end

		return a.item_type > b.item_type
	end

	-- 符文列表跟装备列表是分开的。只能做特殊处理
	local data = {}
	if tag == ItemData.IT_SPECIAL then
		data = clone(self.runes_list)
	elseif tag == ItemData.IT_HERO_STONE then	-- 背包物品类型与item表中place不对应，特此特例
		local item_list = {}

		-- 当前实现效率不高。需要优化
		for k, v in pairs(self.backpack_list) do
			local item_config = cfg_item[v.item_type]
			if item_config.mode == tag then
				item_list[v.item_type] = item_list[v.item_type] and item_list[v.item_type] + v.item_num or v.item_num
			end
		end

		for k,v in pairs(item_list) do
			local item = {}
			item.item_id = "0"
			item.item_tag = tag
			item.item_num = v 
			item.item_type = k
			table.insert(data, item)
		end
	elseif tag == ItemData.IT_HALLOWS then
		-- 当前实现效率不高。需要优化
		for k, v in pairs(self.backpack_list) do
			local item_config = cfg_item[v.item_type]
			if item_config.mode == tag then
				table.insert(data, v)
			end
		end
	elseif tag == ItemData.IT_HERO_GODEQUIP then
		data = clone(self.god_equip_list)
	elseif tag == ItemData.MAGIC_WAND then
		data = clone(self.magic_wand_list)
	elseif tag == ItemData.PET then 
		local tmp = ex.Player.hero_data.pet:notCarryPetList()
		data = {}
		for i,v in ipairs(tmp) do
			local d = {}
			d.level = v.level
			d.item_type = v.sys_id
			d.item_id = v.pet_id
			d.item_tag = ItemData.PET
			table.insert(data,d)
		end
	else
		local item_list = {}

		-- 当前实现效率不高。需要优化
		for k, v in pairs(self.backpack_list) do
			local item_config = cfg_item[v.item_type]
			if item_config.place == tag then
				item_list[v.item_type] = item_list[v.item_type] and item_list[v.item_type] + v.item_num or v.item_num
			end
		end
		
		for k,v in pairs(item_list) do
			local item = {}
			item.item_id = "0"
			item.item_tag = tag
			item.item_num = v 
			item.item_type = k
			table.insert(data, item)
		end
		
		if tag == ItemData.IT_PROP then		-- 限时道具也是放在道具栏
			for k, v in pairs(self.prop_limit_time_list) do
				if v.end_time > ex.Game:getServerTime() then	-- 过滤过期的
					local item = {}
					item.item_id = v.item_id
					item.item_tag = v.item_tag
					item.item_num = v.item_num
					item.item_type = v.item_type
					item.end_time = v.end_time
					table.insert(data, item)
				end
			end
		end
	end

	-- 排序
	table.sort(data, sort_func_list[tag])
	if tag == ItemData.IT_SPECIAL then
		local dt = ex.Player.hero_data.artifact:getBagItem()
		for i,v in ipairs(data) do
			table.insert(dt,v)
		end
		return dt
	end

	return data
end

function BackpackData:checkPieceRed()
	self.piece_red = {}
	local cfg_item = cfg.item.item
	for k, v in pairs(self.backpack_list) do
		local item_config = cfg_item[v.item_type]
		if item_config.place == ItemData.IT_PIECE then
			local item_config = cfg.item.item[v.item_type]
			if item_config and item_config.mode == ItemData.IT_SPECIAL_ELITE then
				self:setPieceRed(v.item_type , v.item_num >= item_config.use_value)
			end
		end
	end

	local is_red = false

	for k,v in pairs(self.piece_red) do
		if v == true then 
			is_red = true 
			break 
		end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHBB_BBSP, is_red) 
end

function BackpackData:setPieceRed(type,bool)
	self.piece_red[type] = bool
end

function BackpackData:getPieceRed(type)
	return self.piece_red[type]
end

function BackpackData:getEquipByPlace(place)
	local data = {}

	for k,v in pairs(self.backpack_list) do
		-- if v.item_tag == 1 then 
			local config = cfg.equipmenttype.equip[v.item_type]
			if config ~= nil then 
				if config.place == place then 
					-- print(v.item_type,">>>>>>>","BackpackData")
					table.insert(data,v)
				end
			end
		-- end
	end
	return data
end


function BackpackData:getStoneByMode()
	local data = {}
	for k,v in pairs(self.backpack_list) do
		local config = cfg.item.item[v.item_type]
		if config.mode == ItemData.IT_HERO_STONE then 
			table.insert(data,v)
		end
	
	end
	return data
end


function BackpackData:getStoneByPlace(place)
	local data = {}
	for k,v in pairs(self.backpack_list) do
		local config = cfg.item.item[v.item_type]
		if config and config.mode == ItemData.IT_HERO_STONE then 
			local jeweltype_config = cfg.jeweltype.jeweltype[v.item_type]
			if  jeweltype_config.place == place then 
				table.insert(data,v)
			end 
		end
	end
	return data
end

function BackpackData:getEquipTypeNum(equip_type)
	-- local num = 0
	-- for k,v in pairs(self.backpack_list) do
	-- 	if v.item_type == equip_type then 
	-- 		num = num + 1
	-- 	end
	-- end
	-- return num
	return self:getItemNum(equip_type)
end

function BackpackData:getItemDataByType(type)
	local data 
	for i,v in ipairs(self.backpack_list) do
		if type == v.item_type then 
			data = v 
			break
		end 
	end
	return data
end

function BackpackData:removeItemById(item_id)
	if item_id == "0" then return end
	for k,v in pairs(self.backpack_list) do
		if v.item_id == item_id then 
			table.remove(self.backpack_list,k)
			break
		end
	end
end

function BackpackData:getEquipTypeByData(item_type)
	local data = {}
	for k,v in pairs(self.backpack_list) do
		if v.item_type == item_type then 
			table.insert(data,v)
		end
	end
	return data
end

-- function BackpackData:getUnitInfo(item_type)
-- 	if item_type > 20100 then
-- 		return ex.Tools:getLang(2100000 + item_type)
-- 	end

-- 	-- local config = ex.ItemTypeTable:getConfig(item_type)
-- 	local config = cfg.itemtype.item[item_type]
-- 	if config then
-- 		return string.format(ex.Tools:getLang(2100000 + item_type), config.item_num)
-- 		-- return string.format(ex.Tools:getLang(2100000 + item_type), tonumber(config.item_num))
-- 	else 
-- 		print("cfg.itemtype.item[" .. item_type .. ex.Tools:getLang(47456)) 
-- 	end

-- 	return ""
-- end

function BackpackData:getPropType(item_type)
	-- if item_type >= ItemType.VIP_EXP and item_type <= ItemType.IT_ROLE_EXP then
	-- 	return ItemData.IT_RES
	-- elseif item_type > ItemType.IT_ROLE_EXP and item_type < 1000000 then
	-- 	return ItemData.IT_PROP
	-- elseif item_type > 1000000 and item_type < 2000000 then
	-- 	return ItemData.IT_EQUIP
	-- elseif item_type > 20000000 and item_type < 30000000 then
	-- 	return ItemData.IT_PIECE
	-- elseif item_type > 2000000 and item_type < 3000000 then
	-- 	return ItemData.IT_RUNES
	-- end

	local config = cfg.item.item[item_type]
	if config then
		return config.mode
	end
	-- return .mode
	return ItemData.IT_INVALID
end

function BackpackData:getPieceIcon(item_type)
	local is_rand_piece = (item_type % 100) <= 0
	if is_rand_piece then
		return item_type - (math.floor(item_type / 100000) % 10) * 100000 - 10000000
	else
		return item_type - 10000000
	end
	
	return 0
end

function BackpackData:getBagConfig(item_type)
	local item_config = cfg.item.item[item_type]
	if not item_config then
		return nil, nil
	end

-- 对应的是item表中的mode.
-- ItemData = {}
-- ItemData.IT_INVALID 	= 0
-- ItemData.IT_EQUIP 		= 1 -- 装备
-- ItemData.IT_PROP 		= 2 -- 道具
-- ItemData.IT_PIECE 		= 3 -- 碎片
-- ItemData.IT_SPECIAL 	= 4	-- 特殊
-- ItemData.IT_RES 		= 5 -- 资源
-- ItemData.IT_RUNES 		= 6 -- 符文
-- ItemData.IT_HERO 		= 7 -- 英雄
-- ItemData.IT_SPECIAL_ELITE = 8 -- 精英碎片
-- ItemData.IT_HERO_MATERIAL = 9 -- 5星狗粮
	if item_config.mode == ItemData.IT_HERO then
		return item_config, cfg.herotype.star[item_type]
	elseif item_config.mode == ItemData.IT_EQUIP then
		return item_config, cfg.equipmenttype.equip[item_type]
	end
	return item_config, nil
end

function BackpackData:getgodequipmentrandomability(place, star ,type , level)
    for i,v in ipairs(cfg.godequipmentrandomability.godequipmentrandomability) do
        if v.place == place and v.star == star and  v.ability_type == type and v.level == level then 
            return v.ability , v.rare
        end 
    end
    return {}
end

--获取套装
function BackpackData:getGodEquipGroupBySystemid(hero_id, item_type)
	local equip_list = self:getGodEquipByHeroid(hero_id)
	local min_type, min_star, nums = self:getGodEquipGroupByList(hero_id, item_type, equip_list)
	return min_type, min_star, nums
end

function BackpackData:getGodEquipGroupByList(hero_id, item_type, equip_list)
	local min_star = 0 
    local min_star_item_type = 0 
    local min_type = 0

    local god_equip_data = cfg.godequipment.godequipment[item_type]
    min_star_item_type = item_type
    min_star = god_equip_data.star
    min_type = god_equip_data.settype
    -- 找到最小
    for i,v in ipairs(equip_list) do
        local cur_equip_data = cfg.godequipment.godequipment[v.item_type]
        if min_star > cur_equip_data.star and god_equip_data.settype == cur_equip_data.settype  then 
            min_star = cur_equip_data.star
            min_star_item_type = v.item_type
        end 
    end

    -- 计算数量
    local nums = 0
    for i,v in ipairs(equip_list) do
        local cur_equip_data = cfg.godequipment.godequipment[v.item_type]
        if hero_id ~= 0 and v.hero_id == hero_id and cur_equip_data.star >= min_star and god_equip_data.settype == cur_equip_data.settype then 
            nums = nums + 1
        end 
    end
	-- 套装类型，套装星级，套装数量
	return min_type, min_star, nums
end


function BackpackData:getGodEquipByHeroid( hero_id )
    local return_data = {}
    for i,v in pairs(self.god_equip_list) do
        if v.hero_id == hero_id  then 
            table.insert( return_data, clone(v) )
        end 
    end
    return return_data
end

function BackpackData:checkGodEquipRedDot( hero_id, star)

	-- add 熊梦 神装红点判断
	if star < 6 then return false end
	local flag = false 
	for i=1,4 do
		local cur_item_id = self:getGodEquipData(hero_id, i)
		if cur_item_id == 0 then 
			local return_list = self:getGodEquipByPlaceAndHeroid(i, hero_id)
			if table.nums(return_list) > 0 then 
				flag = true 
				break
			end 
		end 
	end
	return flag
end


function BackpackData:getGodEquipByPlaceAndHeroid( place , hero_id)
    local return_data = {}
    for i,v in pairs(self.god_equip_list) do
        if v.place == place and (v.hero_id == 0 or v.hero_id == hero_id) then 
            table.insert(return_data, clone(v))
        end 
    end
    return return_data
end

function BackpackData:changeGodEquipList(hero_id , equips )
	for i,v in pairs(self.god_equip_list) do
		if v.item_id == equips.id then 
            self.god_equip_list[i].hero_id = equips.hero_id
        end 
    end
end

function BackpackData:subGodEquipList(hero_id , equips_id )
    for i,v in pairs(self.god_equip_list) do
        if v.item_id == equips_id then 
            self.god_equip_list[i].hero_id = 0
        end 
    end
end

function BackpackData:getGodEquipData(hero_id , place )
	for i,v in pairs(self.god_equip_list) do
		if v.hero_id == hero_id and v.place == place then 
            return v.item_id
        end 
    end
    return 0 
end

function BackpackData:getGodEquipDataByID(id )
    for i,v in pairs(self.god_equip_list) do
        if v.item_id == id  then 
            return v
        end 
    end
    return nil
end

-- 根据条件获取未穿戴神装
function BackpackData:getFreeGodEquipsForRareAndStar(rare_grade, star_grade)
    local result = {}
    for i,v in ipairs(self.god_equip_list) do
        local config = cfg.godequipment.getConfigByType(v.item_type)
        if v.hero_id == 0 and config.rare == rare_grade and config.star == star_grade then 
            table.insert(result, v)
        end 
    end

    return result
end


function BackpackData:updateGodEquipOff(id )
    for i,v in pairs(self.god_equip_list) do
        if v.item_id == id  then 
			self.god_equip_list[i].hero_id = 0
		end 
	end
end

-- 洗练
function BackpackData:washGodEquip(equip_data )
    for i,v in pairs(self.god_equip_list) do
        if v.item_id == equip_data.id  then 
			self.god_equip_list[i].wash_attrs = equip_data.wash_attrs
			self.god_equip_list[i].wash_num = equip_data.wash_num
		end 
	end
end

-- 保存洗练
function BackpackData:saveWashGodEquip(equip_data )
    for i,v in pairs(self.god_equip_list) do
        if v.item_id == equip_data.id  then 
			self.god_equip_list[i].attrs = equip_data.attrs
			self.god_equip_list[i].wash_attrs = {}
        end 
    end
end

function BackpackData:getGodEquipUpStarOneKey()
	local can_up, result = false, {}

	local isCanCompose = function(item_type)
		local config = cfg.godequipment.getConfigByType(item_type)
		if config and config.combine_target ~= 0 then
			return true
		end

		return false
	end

	local num_map = {}
	for i,v in pairs(self.god_equip_list) do
		if v.hero_id == 0 then
			if #result <= 0 then
				if isCanCompose(v.item_type) then
					table.insert(result, v)
				end
			else
				if result[1].item_type >= v.item_type then
					if result[1].item_type > v.item_type then
						result = {}
					end
					if isCanCompose(v.item_type) then
						table.insert(result, v)
					end
				end
			end

			if not num_map[v.item_type] then
				num_map[v.item_type] = {}
			end
			
			table.insert(num_map[v.item_type], v)
		end
	end

	for k, v in pairs(num_map) do
		if #v >= 3 then
			if isCanCompose(k) then
				if not can_up or k < result[1].item_type then
					-- 可合成
					result = v
					can_up = true
				end
			end
		end
	end

	local item_ids = {}
	local length = math.min(3, #result)
	for i = 1, length do
		table.insert(item_ids, result[i].item_id)
	end

	return can_up, item_ids
end

function BackpackData:addMagicWand(data)
	data.item_id = data.magic_id
	table.insert(self.magic_wand_list, data)
end

function BackpackData:changeMagicWand(data)
	for i,v in ipairs(self.magic_wand_list) do
		if v.magic_id == data.magic_id then 
			self.magic_wand_list[i] = data
			return
		end
	end
end

function BackpackData:deleteMagicWand(item_id)
	for i,v in ipairs(self.magic_wand_list) do
		if v.magic_id == item_id then 
			table.remove(self.magic_wand_list, i)
			break
		end
	end
end

function BackpackData:getMagicWand(item_id)
	for i,v in ipairs(self.magic_wand_list) do
		if v.magic_id == item_id then
			return v
		end
	end
	return self.parent.hero_data.magic_wand:getMagicWandByMagicId(item_id)
end

-- 根据条件获取未穿戴魔杖
function BackpackData:getFreeMagicWandForRare(rare_list)
    local result = {}
    for i,v in ipairs(self.magic_wand_list) do
		if v.hero_id == 0 then
			local config = cfg.magicwandtype.magicwandtype[v.item_type]
			local is_has = false
			for k,v2 in pairs(rare_list) do
				if v2 == config.rare then
					is_has = true
					break
				end
			end
			if is_has then 
				table.insert(result, v)
			end 
		end
    end

    return result
end

function BackpackData:getFreeMagicWandForType(type)
	local result = {}
	for i,v in ipairs(self.magic_wand_list) do
		if v.hero_id == 0 then
			local config = cfg.magicwandtype.magicwandtype[v.item_type]
			if config.type == 0 or config.type == type then
				table.insert(result, v)
			end
		end
	end

	table.sort(result, function(a, b)
		local ca = cfg.magicwandtype.magicwandtype[a.item_type]
		local cb = cfg.magicwandtype.magicwandtype[b.item_type]
		if ca.rare ~= cb.rare then
			return ca.rare > cb.rare
		end
		if ca.type_id ~= cb.type_id then
			return ca.type_id > cb.type_id
		end

		if a.strengthen_lv ~= b.strengthen_lv then
			return a.strengthen_lv > b.strengthen_lv
		end

		return a.wash_times > b.wash_times
	end)


	return result
end

function BackpackData:getMagicWandSourceCost(magic_id)
	local magic_data = self:getMagicWand(magic_id)
	if magic_data == nil then
		return {}
	end

	local c = cfg.magicwandtype.magicwandtype[magic_data.item_type]
	
	local result = clone(c.recover_reward)
	-- 计算强化消耗
	for i,v in ipairs(cfg.magicwandstrengthen.magicwandstrengthen) do
		if v.item_type == magic_data.item_type and v.level < magic_data.strengthen_lv then

			for ii,vv in ipairs(v.cost) do
				-- 合并
				local d = TableEx.findValueFunction(result, function(va)
					if va.item_type == vv.item_type then
						return true
					end
				end)
	
				if d then
					d.item_num = d.item_num + vv.item_num
				else
					table.insert(result, clone(vv))
				end
			end
			
		end
	end

	for i,v in ipairs(c.cost) do
		-- 合并
		local d = TableEx.findValueFunction(result, function(va)
			if va.item_type == v.item_type then
				return true
			end
		end)

		local data = clone(v)
		data.item_num = data.item_num * magic_data.wash_times
		if data.item_num > 0 then
			if d then
				d.item_num = d.item_num + data.item_num 
			else
				table.insert(result, data)
			end
		end
	end

	table.sort(result,function(a, b)
		return a.item_type > b.item_type
	end)
	
	return result
end

return BackpackData
