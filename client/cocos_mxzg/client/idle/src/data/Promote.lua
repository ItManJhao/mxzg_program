local Promote = class("Promote")

local CheckType = {
	Talent = 100,	-- [101 - 103]
}


function Promote:ctor(parent)

	self.parent = parent
	self.select_hero_id = nil   -- 选中英雄
--------------升星-------------------------
	self.upStar_count = 0       -- 升星选择的个数 
	self.select_list = nil		-- 升星选择列表
	self.comsume_list = {}		-- 升星消耗英雄列表
	self.hero_star_red = {}		-- 英雄升星红点
--------------升星-------------------------

--------------升级-------------------------

	self.battle_list = {}
	self.hero_level_red = {}
	self.hero_grade_red = {}
	self.hero_level_items = {}

	self.hero_level_items[1] = ItemType.IT_GOLD
	self.hero_level_items[2] = ItemType.IT_HERO_EXP

--------------升级-------------------------

------------------创造法阵---------------------

	self.creat_hero_red = {}
	self.creat_hero_count = {}
	self.creat_hero_elem_red = {}
	self:editMaxGrade()
	self.isReplace_tab = {}

------------------ 通用红点检测 2020-03-16 ---------------------
	-- 使用物品类型进行检索。加快遍历速度
	self.reddot_list = {}
	-- self.reddot_list[CheckType.Talent + 1] = {need = {}, call = handler(self, self.checkTalentReddot)}


------------------ 天赋红点 ---------------------
	local talent_call_back = function()
		ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATE_REDDOT)
	end
	
	self.talent_hero_red = {}
	local list = {}
	for k,v in pairs(cfg.talent.talent) do
		local reddot_data = self.reddot_list[CheckType.Talent + v.level] or {need = {}, call = talent_call_back}
		table.insert(reddot_data.need, v.upgrade_need)

		self.reddot_list[CheckType.Talent + v.level] =  reddot_data
	end

------------------ 物品检测缓存 ---------------------
	self.item_need = {}
	for k,v in pairs(self.reddot_list) do
		for i,vd in ipairs(v.need) do
			for k,vi in pairs(vd) do
				if self.item_need[vi.item_type] == nil then
					self.item_need[vi.item_type] = {}
				end
				table.insert(self.item_need[vi.item_type], v)
			end
		end
	end

------------------创造法阵---------------------
	self:registerEvent()
end

function Promote:clear()
	self:removeEvent()
end

function Promote:registerEvent()
	self.event_list = {
		-- ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD,handler(self,self.updateRedPoint)),
		-- ex.EventManager:add(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST,handler(self,self.updateRedPoint)),
		ex.EventManager:add(EVENT.BACK_PACK_EVENT.BACKPACK_INIT_FINISH,handler(self,self.initRedPoint))
	}
end

function Promote:removeEvent()
	if self.event_list ~= nil then 
		for k,v in pairs(self.event_list) do
			ex.EventManager:remove(v)
		end
	end
end

function Promote:initRedPoint(event,item_type)

	local list = ex.Player.backpack_data.backpack_list
	for k,v in pairs(list) do
		self:updateRedPoint(nil,v.item_type)
	end
end

function Promote:updateRedPoint(event, item_type)
	
	if item_type == ItemType.IT_HERO_UP_STONE then 
		for k,v in pairs(self.battle_list) do
			self:checkUpStar(k)
			self:checkHeroCanUpgrade(k)
		end

		local creatHeroData = self:getCreatHeroData()
		for k,v in pairs(creatHeroData) do
			self:checkUpStar(v,true)
		end
		self:checkCreatHeroRedPoint()
	elseif item_type == ItemType.IT_HERO_EXP then 
		self.hero_level_red = {}
		for k,v in pairs(self.battle_list) do
			self:checkCanUpLevel(k)
			self:checkHeroCanUpgrade(k)
		end
	elseif item_type == ItemType.IT_GOLD then 
		self.hero_level_red = {}
		for k,v in pairs(self.battle_list) do
			self:checkCanUpLevel(k)
			self:checkHeroCanUpgrade(k)
		end
	else
		local data = self.item_need[item_type]
		-- 是对应的消耗品
		if data then
			for i,v in ipairs(data) do
				for k,vt in pairs(self.battle_list) do
					v.call(k, v)
				end
			end
			-- data.call()
		end
	end
	-- local isRed = self:checkMainCityRedPoint()
end

function Promote:checkTalentReddot(hero_id)
	-- self.is_max = cfg.heroskill.isMaxLevel(self.data.skill_id, self.data.level)
	for i=1, 2 do
		local is_red = self.parent:isTalentUplevel(hero_id, i, true)
		if is_red then
			return is_red
		end
		-- local hero_data = self.parent:getHeroDataById(hero_id)
		-- if hero_data then
		-- 	local talent = self.parent:getTalentByIDAndSlot(hero_id, i)
		-- 	local is_open = hero_data.star >= cfg.system.getTalentSlotOpenStar(i)
		-- 	if is_open and (talent == nil or cfg.heroskill.isMaxLevel(talent.skill_id, talent.level) ~= true) then
		-- 		local red = self:checkTalentReddotLevel(hero_id, talent and talent.skill_id or 0, talent and talent.level + 1 or 1)
		-- 		if red then
		-- 			return red
		-- 		end
		-- 	end
		-- end
	end
	return false
end

-- function Promote:checkTalentReddotLevel(hero_id, skill_id, level)
-- 	local red_data = self.reddot_list[CheckType.Talent + level]
-- 	if red_data == nil then
-- 		return false
-- 	end

-- 	-- 天赋生效
-- 	for i=1, 2 do
-- 		for i,v in ipairs(red_data.need) do
-- 			local comp_num = 0
-- 			for i,vi in ipairs(v) do
-- 				if ex.Player:getItemNum(vi.item_type) >= vi.item_num then
-- 					comp_num = comp_num + 1
-- 				end
-- 			end

-- 			self.talent_hero_red[hero_id] = comp_num >= table.nums(v)
-- 			if self.talent_hero_red[hero_id] == true then
-- 				break
-- 			end
-- 		end 
-- 	end

-- 	return self.talent_hero_red[hero_id]
-- end

function Promote:initUpStarItem()
	if not self.upStar_items then 
		self.upStar_items = {} 
		for _,data in pairs(cfg.herostar.star) do
			if type(data.upstar_cost) == "table" then
				for _,v in pairs(data.upstar_cost) do
					self.upStar_items[v.item_type] = v.item_type
				end
			end
		end
	end
	return self.upStar_items
end

function Promote:getCreatHeroData()
	if not self.creat_hero_data then self.creat_hero_data = self:initCreatHeroData() end
	return self.creat_hero_data
end

function Promote:initCreatHeroData()
	local data = {}
	for k,v in pairs(cfg.herotype.star) do
		if v["to_" .. v.star + 1 .. "_star"] ~= nil and v["to_" .. v.star + 1 .. "_star"] ~= "" and table.nums(v["to_" .. v.star + 1 .. "_star"]) > 0 and v.kind == 1 then 
			table.insert(data,v)
		end
	end
	local sor = function (a,b)
		return a.star < b.star
	end
	table.sort(data,sor)
	return data
end

function Promote:checkMainCityRedPoint()
	-- body
	local star_red = self:checkUpstarRedPoint()
	local level_red = self:checkLevelRedPoint()
	local grade_red = self:checkGradeRedPoint()	
	-- add 熊梦 出战的时候再判断一下 英雄皮肤是否可以操作	
	local skin_red = self:checkSkinRedPoint()	
	-- add 熊梦 英雄精灵红点是否可以操作
	local spirit_red = self:checkSpiritRedPoint()	
	-- ex.Player.hero_data.promote:getHeroUpStarRedPoint(v)

	-- print("star_red",star_red,"level_red",level_red,"grade_red",grade_red)
	return star_red or level_red or grade_red or skin_red or spirit_red
end

function Promote:checkLevelRedPoint( ... )
	-- body
	local bool = false
	for i,v in pairs(self.hero_level_red) do
		if v == true and self.battle_list[i] == true then bool = v break end
	end
	return bool 
end

function Promote:checkGradeRedPoint()
	local bool = false
	for k,v in pairs(self.hero_grade_red) do
		if v == true and self.battle_list[k] == true then bool = v break end
	end
	return bool
end

-- add 熊梦 检测英雄皮肤红点是否可以显示
function Promote:checkSkinRedPoint()
	local is_show_red = false
	-- add 熊梦 检测是否可操作皮肤 
	for k,v in pairs(self.battle_list) do
		local hero_data = ex.Player.hero_data:getHeroDataById(k)
		if hero_data then
			local fashion_list = cfg.herofashion.getConfigsByHeroType(hero_data.hero_type)
			for g, h in ipairs(fashion_list) do
				if h.fashion_id ~= 0 then
					local data = ex.Player.hero_data.fashion:getFashionDataByID(h.fashion_id)
					local is_active = ex.Player.hero_data.fashion:isActive(h.fashion_id)
					local is_actionable = ex.Player.hero_data.fashion:isActionable(h.fashion_id)
					-- 皮肤是否可激活
					if not is_active and is_actionable then
						is_show_red = true
						break
					end
					
					-- 皮肤是否可升级
					if data~= nil and is_active then
						local max_config = cfg.herofashionup.getMaxConfigByType(h.fashion_id)
						local max_level = max_config.level
						local level = is_active and data.level or 0
						local up_config = cfg.herofashionup.getConfigByTypeAndLevel(h.fashion_id, math.max(0, math.min(max_level, level)))
						if data.status == 0 and up_config.level < max_level then
							if ex.Player.hero_data.fashion:isCanUpgrade(h.fashion_id, level) then
								is_show_red = true
								break
							end
						end
					end
				end
			end
		end
	end
	return is_show_red
end

-- add 熊梦 英雄精灵红点是否可以操作
function Promote:checkSpiritRedPoint()
	local is_show_red = false
	-- add 熊梦 检测是否可操作皮肤 
	for k,v in pairs(self.battle_list) do
		local hero_data = ex.Player.hero_data:getHeroDataById(k)
		if hero_data then
			local red ,_ = ex.Player.backpack_data:checkRunesRedByHero(hero_data.hero_id)
			if red == true then
				return true
			end
		end

	end
	return false
end

-- add 熊梦 觉醒红点
function Promote:checkAwakenReddot(hero_type,star,awaken)
	local attribute = cfg.heroawaken.heroawaken[hero_type]
	if attribute == nil then return false end
	if attribute.need_star == star then
		if #awaken.base_index == 0 or #awaken.special_index == 0 then
			return true
		end
	end
	return false
end

function Promote:initBattlelist()
	self.battle_list = {}
end

function Promote:setBattleHero(hero_id)
	self.battle_list[hero_id] = true
end

function Promote:heroIsBattle(hero_id)
	if not self.battle_list[hero_id] then return false end
	return self.battle_list[hero_id]
end

function Promote:getBattleList()
	return self.battle_list
end

function Promote:getCanUpLevelMax()
	local config = cfg.herolevel.level
	local hasGold = ex.Player:getItemNum(ItemType.IT_GOLD)
	local hasExp = ex.Player:getItemNum(ItemType.IT_HERO_EXP)
	local level = 0

	for i,v in ipairs(config) do
		level = v.level
		if hasGold < v.gold_need then 
			return v.level 
		end
		if hasExp < v.exp_need then 
			return v.level 
		end
	end
	return level
end

function Promote:checkCanUpLevel(hero_id)
	local hero_data = self.parent:getHeroDataById(hero_id)
	-- dump(debug.traceback())

	if not hero_data then
		print("hero_data not found! hero_id = ", hero_id)
		return 
	end

	local is_cube_hero = self.parent.magicCube:isCubeHero(hero_id) == true
	
    if is_cube_hero then 
        self:setHeroUp(hero_id,false) 
        return 
    end 

	local config = cfg.herolevel.level[hero_data.level]
	if not config or not hero_data then 
		self:setHeroUp(hero_id,false)
		return 
	end

	local max_grade = hero_data.stage == self.max_grade
	local level_limit 
	local max_level 

	-- print("hero_data.stage, hero_data.star", hero_data.stage, hero_data.star,self.max_grade)
	if max_grade == true then 
		level_limit = math.max(hero_data.stage, hero_data.star)
		max_level = cfg.herostar.star[level_limit].level_limit
	else
		level_limit = hero_data.stage
		max_level = cfg.heroupgrade.grade[level_limit].level
	end

	if hero_data.level == max_level then 
		self:setHeroUp(hero_id,false)
		return 
	end

	local hasGold = ex.Player:getItemNum(ItemType.IT_GOLD)
	local hasExp = ex.Player:getItemNum(ItemType.IT_HERO_EXP)

	local can = hasGold >= config.gold_need and hasExp >= config.exp_need
	self:setHeroUp(hero_id,can)

end

function Promote:setHeroUp(hero_id,bool)
	self.hero_level_red[hero_id] = bool
end

function Promote:getHeroUp(hero_id)
	return self.hero_level_red[hero_id]
end

function Promote:editMaxGrade()
	self.max_grade = 0
	for i,v in ipairs(cfg.heroupgrade.grade) do
		if v.grade > self.max_grade then 
			self.max_grade = v.grade
		end
	end
end

function Promote:returnHeroCost(hero_data)
	local items = {}
	-- 升星返还的材料
	for _,v in pairs(cfg.herostar.star[hero_data.star].upstar_cost) do
		-- inserItem(n.item_type, n.item_num * vip_add)
		if v.item_num > 0 then 
			if items[v.item_type] == nil then 
				items[v.item_type] = 0
			end
			items[v.item_type] = items[v.item_type] + v.item_num
		end
	end

	-- 升级返还的材料
	for i=2,hero_data.level-1 do
		local config = cfg.herolevel.level[i]
		if config then

			if config.gold_need > 0 then 
				if items[ItemType.IT_GOLD] == nil then 
					items[ItemType.IT_GOLD] = 0
				end
				items[ItemType.IT_GOLD] = items[ItemType.IT_GOLD] + config.gold_need
			end

			if config.exp_need > 0 then 
				if items[ItemType.IT_HERO_EXP] == nil then 
					items[ItemType.IT_HERO_EXP] = 0
				end
				items[ItemType.IT_HERO_EXP] = items[ItemType.IT_HERO_EXP] + config.exp_need
			end
		end
	end

	-- 返还升阶材料
	for i=0, hero_data.stage - 1 do
		local config = cfg.heroupgrade.grade[i]
		if config then
			if config.soul > 0 then 

				if items[ItemType.IT_HERO_UP_STONE] == nil then 
					items[ItemType.IT_HERO_UP_STONE] = 0
				end

				items[ItemType.IT_HERO_UP_STONE] = items[ItemType.IT_HERO_UP_STONE] + config.soul
			end

			if config.gold > 0 then 

				if items[ItemType.IT_GOLD] == nil then 
					items[ItemType.IT_GOLD] = 0
				end

				items[ItemType.IT_GOLD] = items[ItemType.IT_GOLD] + config.gold
			end

		end
	end
	return items
end

function Promote:checkHeroCanUpgrade(hero_id)
	local hero_data = self.parent:getHeroDataById(hero_id)

	-- dump(debug.traceback())
	if not hero_data then
		print("hero_data not found! hero_id = ", hero_id)
		return 
	end
    local is_cube_hero = self.parent.magicCube:isCubeHero(hero_id) == true

    if is_cube_hero then 
        self.hero_grade_red[hero_id] = false 
        return 
    end 




	local max_grade = math.min(hero_data.star,self.max_grade)

	if max_grade <= hero_data.stage then 
		self.hero_grade_red[hero_id] = false
		return 
	end
	local gradeData = cfg.heroupgrade.grade[hero_data.stage]
	local canUpgrade = false
	if not gradeData then return end
	local hasSoul = ex.Player:getItemNum(ItemType.IT_HERO_UP_STONE)
	local hasGold = ex.Player:getItemNum(ItemType.IT_GOLD)
	self.hero_grade_red[hero_id] = hero_data.level == gradeData.level and hasSoul >= gradeData.soul and hasGold >= gradeData.gold
end

function Promote:getHeroCanUpgrade(hero_id)
	if not self.hero_grade_red[hero_id] then return false end
	return self.hero_grade_red[hero_id]
end

function Promote:setSelectHero(hero_id)
	self.select_hero_id = hero_id
end

function Promote:getSelectHeroById()
	return self.select_hero_id
end

function Promote:setSelectHeroType(hero_type)
	self.select_hero_type = hero_type
end

function Promote:getSelectHeroTypeByData()
	if not self.select_hero_type then return end
	return cfg.herotype.star[self.select_hero_type]
end

function Promote:getSelectHero()
	local selectHeroData = self.parent:getHeroDataById(self.select_hero_id)
	return selectHeroData
end

function Promote:getHeroTypeByList(type,star)
	local data = {}
	for k,v in pairs(self.parent.hero_list) do
		if v.hero_type == type and v.star == star then 
			local hero = clone(v)
			table.insert(data,hero)
		end
	end

	for _,v in pairs(self.comsume_list) do
		for i,value in pairs(v) do
			for k,val in pairs(data) do
				if value.hero_id == val.hero_id then 
					table.remove(data,k)
					break
				end
			end
		end
	end

	return data
end

function Promote:getCanSelectList(data,index)
	local hero_data = self:getSelectHero()
	self.select_list = clone(self.parent.hero_list)
	if hero_data ~= nil then 
		for k,v in pairs(self.select_list) do
			if v.hero_id == hero_data.hero_id then 
				table.remove(self.select_list,k)
				break
			end
		end
	else
		hero_data = self:getSelectHeroTypeByData()
		hero_data.hero_type = hero_data.type
	end
	
	local canSelectList = {}
	if not self.comsume_list[index] then self.comsume_list[index] = {} end
	for _,v in pairs(self.comsume_list) do
		for i,value in pairs(v) do
			for k,val in pairs(self.select_list) do
				if value.hero_id == val.hero_id then 
					table.remove(self.select_list,k)
					break
				end
			end
		end
	end

	local type = data.type == -1 and hero_data.hero_type or data.type
	local elem = data.elem == -1 and hero_data.elem or data.elem
	local id_list = {}

	for k,val in pairs(self.select_list) do
		if data.star == val.star then
			-- print(self.__cname,val.elem == elem ,val.star == data.star , type == val.hero_type , type ,val.hero_type)
			if elem == val.elem and type == val.hero_type then 
				table.insert(id_list,val.hero_id)
			elseif type == 0 and elem == val.elem then 
				table.insert(id_list,val.hero_id)
			elseif elem == 0 and type == val.hero_type then 
				table.insert(id_list,val.hero_id)
			elseif type == 0 and elem == 0 then 
				table.insert(id_list,val.hero_id)
			end
		end 
	end

	for i,v in pairs(id_list) do

		for k,val in pairs(self.select_list) do
			if v == val.hero_id then
				local hero = table.remove(self.select_list,k)
				if hero.selected == true then self:setUpStarCount(1) end
				table.insert(canSelectList,hero)
				break
			end
		end

	end


	local replace_item_list = nil
	if data.replace_item and data.replace_item > 0 then 
		replace_item_list = {}	

		local has_nums = ex.Player:getItemNum(data.replace_item)
		for i=1,has_nums do
			local now_replace_item = {}
			now_replace_item.item_type = data.replace_item
			now_replace_item.item_num = 1
			now_replace_item.is_item = 1
			table.insert( replace_item_list, now_replace_item)
		end
	end 


	return canSelectList, replace_item_list
end


function Promote:setSlectReplace(index, flag )	
	self.isReplace_tab[index] = flag
end

function Promote:getSlectReplace(index )	
	return self.isReplace_tab[index] and self.isReplace_tab[index] or false
end


function Promote:selectComsumeHero(idx,hero)
	if not self.comsume_list[idx] then self.comsume_list[idx] = {} end

	for k,v in pairs(self.comsume_list[idx]) do
		if v.hero_id == hero.hero_id then 
			return 
		end
	end
	table.insert(self.comsume_list[idx],hero)
end

function Promote:cancelComsumeHero(idx,hero_id)
	for k,v in pairs(self.comsume_list[idx]) do
		if v.hero_id == hero_id then 
			table.remove(self.comsume_list[idx],k)
			break
		end
	end

end

function Promote:getComsumeHeroList(idx)
	if not self.comsume_list[idx] then self.comsume_list[idx] = {} end
	return self.comsume_list[idx]
end

function Promote:getComsumeHeroLists()
	return self.comsume_list
end

function Promote:resetComsumeHeroList()
	self.comsume_list = {}
	self.isReplace_tab = {}
end

function Promote:checkUpStar(hero,creat)

	local config 
	-- if creat == true then dump(hero) end
	if type(hero) == "number" then 
		hero = ex.Player.hero_data:getHeroDataById(hero)
		if not hero then return end
	end
	local hero_type = hero.type ~= nil and  hero.type or hero.hero_type
	if not creat then 
		config = cfg.herotype.star[hero_type]
	else
		config = cfg.herotype.star[hero_type]
		self.creat_hero_count[hero_type] = 0
		self.creat_hero_red[hero_type] = true
	end
	if config == nil then print("cfg.herotype.star[" .. (hero_type) .. "]") return end

	local config_star = cfg.herostar.star[hero.star]
	if config_star.world_level_require > ex.Player.world_level and config_star.role_level_require > ex.Player.level then
		self.hero_star_red[hero.hero_id] = false
		return 
	end

	local upgrade_item = config["to_" .. hero.star+1 .."_star"]
	if upgrade_item == nil or upgrade_item == "" or #upgrade_item <= 0 then 
		self.hero_star_red[hero.hero_id] = false
		return 
	end

	if config_star.need_item and config_star.need_item ~= "" then
		for i,v in ipairs(config_star.need_item) do
			if ex.Player:getItemNum(v.item_type) < v.item_num then
				self.hero_star_red[hero.hero_id] = false
				return
			end
		end
	end

	if type(upgrade_item) ~= "table" then print((hero.hero_type or hero.type) ..ex.Tools:getLang(47729)) return end
	local conf = cfg.herostar.star[hero.star].upstar_cost--[1]
	local hasNum
	local can = true
	if conf ~= "" and table.nums(conf) > 0 then 
		conf = conf[1]
		hasNum = ex.Player:getItemNum(conf.item_type)
		can = hasNum >= conf.item_num
	end

	if can == false then 
		if not creat then self.hero_star_red[hero.hero_id] = false return end
		-- self.creat_hero_red[hero_type] = false
	end


	-- local hero_list = clone(self.parent.hero_list)
	local hero_list = self.parent.hero_list
	local filter = {}


	if creat == true then 
		local has = false
		for k,v in pairs(hero_list) do
			if v.hero_type == hero_type and v.star == config.star then 
				-- table.remove(hero_list,k)
				table.insert(filter,v.hero_id)
				has = true
				self.creat_hero_count[hero_type] = self.creat_hero_count[hero_type] + 1
				break
			end
		end
		if not has then 
			self.creat_hero_red[hero_type] = false
			-- return 
		end
	else
		for k,v in pairs(hero_list) do
			if v.hero_id == hero.hero_id then 
				-- table.remove(hero_list,k)
				table.insert(filter,v.hero_id)
				break
			end
		end
	end



	local redPoint

	for i,v in ipairs(upgrade_item) do
		local type = v.type == -1 and hero.hero_type or v.type
		local elem = v.elem == -1 and hero.elem or v.elem
		-- local id_list = {}
		local count = 0
		redPoint = false


		for k,val in pairs(hero_list) do

			local has = false
			for k,v in pairs(filter) do
				if v == val.hero_id then 
					has = true
					break
				end
			end
			
			if not has then 
				if v.star == val.star and (not val.is_lock)  then
					if elem == val.elem and type == val.hero_type then 
						-- table.insert(id_list,val.hero_id)
						table.insert(filter,val.hero_id)
						count = count + 1
					elseif type == 0 and elem == val.elem then 
						-- table.insert(id_list,val.hero_id)
						table.insert(filter,val.hero_id)
						count = count + 1
					elseif elem == 0 and type == val.hero_type then 
						-- table.insert(id_list,val.hero_id)
						table.insert(filter,val.hero_id)
						count = count + 1
					elseif type == 0 and elem == 0 then 
						-- table.insert(id_list,val.hero_id)
						table.insert(filter,val.hero_id)
						count = count + 1
					end

					redPoint = count >= v.num 
					
					if redPoint == true then break end
				end 
			end
		end

		if creat == true then 
			self.creat_hero_count[hero_type] = self.creat_hero_count[hero_type] + count

			if self.creat_hero_red[hero_type] == true then 
				self.creat_hero_red[hero_type] = redPoint and can --hasNum >= conf.item_num
			end
		end

		if v.replace_item and v.replace_item > 0 then 
			local item_nums = ex.Player:getItemNum(v.replace_item)
			if item_nums > v.num  then 
				redPoint = true 
			end 
		end 

		if redPoint == false then
			if not creat then 
				self.hero_star_red[hero.hero_id] = redPoint
				return
			end
		end

		-- for i,v in pairs(id_list) do

		-- 	for k,val in pairs(hero_list) do
		-- 		if v == val.hero_id then
		-- 			local hero = table.remove(hero_list,k)
		-- 			break
		-- 		end
		-- 	end

		-- end
	end

	if not creat then 
		-- add 熊梦 策划需求 升14星(觉醒) 需要拥有3个13星以上的英雄才可以升14星
		if redPoint then
			if hero.star + 1 == ex.Player.awaken_star then
				local hero_list = ex.Player.hero_data:getHeroList()
				local hero_star = 0
				for i,v in ipairs(hero_list) do
					if v.star >= cfg.system.need_star_num[1] then 
						hero_star = hero_star + 1
						if hero_star >= cfg.system.need_star_num[2] then break end
					end 
				end
		
				if hero_star < cfg.system.need_star_num[2] then 
					redPoint = false
				end
			end
		end
		self.hero_star_red[hero.hero_id] = redPoint 
	end

	return 
end

function Promote:initUpStarRedPoint()
	for k,v in pairs(self:getBattleList()) do
		self:checkUpStar(k)
	end

	local creatHeroData = self:getCreatHeroData()
	for k,v in pairs(creatHeroData) do
		self:checkUpStar(v,true)
	end

	self:checkCreatHeroRedPoint()

end

function Promote:initUpLevelRedPoint()
	for k,v in pairs(self:getBattleList()) do
		self:checkCanUpLevel(k)
        self:checkCanUpLevel(k)
	end
    
end

function Promote:getCreatHeroRedPoint( hero_type )
	if self.creat_hero_red[hero_type] == nil then return false end
	return self.creat_hero_red[hero_type]
end

function Promote:getCreateHeroRedList()
	return self.creat_hero_red
end

function Promote:getCreatHeroHasNum(hero_type)
	return self.creat_hero_count[hero_type] or 0
end

function Promote:checkCreatHeroRedPoint()
	local bool = false

	self.creat_hero_elem_red = {}
	for k,v in pairs(self.creat_hero_red) do
		if v == true then 
			bool = v 
			break 
		end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCZFZ, bool)
	return bool
end

function Promote:getHeroElemRedPoint(elem)
	return self.creat_hero_elem_red[elem]
end

function Promote:getHeroUpStarRedPoint( hero_id )
	if self.hero_star_red[hero_id] == nil then return false end
	return self.hero_star_red[hero_id]
end

function Promote:checkUpstarRedPoint()
	local bool = false
	for k,v in pairs(self.hero_star_red) do
		if v == true and self.battle_list[k] == true then bool = v break end
	end
	return bool
end

function Promote:setUpStarCount(num)
	self.upStar_count = self.upStar_count + num 
end

function Promote:resetStarCount()
	self.upStar_count = 0
end

function Promote:getNewUpStarCount(index)

	local return_upStar_count = 0
	if self.isReplace_tab[index]  and self.isReplace_tab[index] == true then 
		return_upStar_count = self.upStar_count + 1 
	else 
		return_upStar_count = self.upStar_count
	end 

	return return_upStar_count
end


function Promote:getUpStarCount()
	return self.upStar_count
end


function Promote:setNeedCount(num)
	self.needCount = num
end

function Promote:getNeedCount()
	return self.needCount 
end

function Promote:creatSelectList()
	self.select_list = clone(self.parent.hero_list)
	for k,v in pairs(self.select_list) do
		if v.hero_id == self.select_hero_id then 
			table.remove(self.select_list,k)
			break
		end
	end

	for k,v in pairs(self.comsume_list) do
		for _,val in pairs(self.select_list) do
			if k == val.hero_id then 
				val.selected = v
				break
			end
		end
	end

end

function Promote:checkHeroIsBattle(hero_id)
	if not hero_id or hero_id == 0 then return false end 
	local bool = false
	local lock_cfg = cfg.battleformation.battleformation
	for k,v in pairs(lock_cfg) do
		-- dump(v,k)
		local lock = v.lock_hero
		if lock == 1 then 
			local team_data = ex.Player.lineup_data:getLineup(k)
			if team_data ~= nil then 
				local hero_list = team_data.hero_list
				for i,v in ipairs(hero_list) do
					if v.hero_id == hero_id then 
						bool = true 
						break
					end
				end
			end
		end
	end
	return bool 
end

return Promote
