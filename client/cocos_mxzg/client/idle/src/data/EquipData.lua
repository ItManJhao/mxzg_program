local EquipData = class("EquipData")

function EquipData:ctor(parent)
	self.parent = parent
	self.equip_list = {}					--英雄装备列表
	self.equip_score ={}					--装备类型评分
	self.equip_compose_list = {}			--铁匠铺装备展示列表
	self.equip_compose_item_red = {}		--可以合成的装备类型的红点
	self.equip_compose_palce_red = {}		--铁匠铺tab部位的红点
	self.equip_remove_list = {}				--记录合成消耗装备的列表
	self.equip_base_type = {}				--每个部位装备的基础类型
	self.equip_need_gold = 0
	self:initComposeData()
	self:initEquipScore()
	self:registerEvent()
end

function EquipData:registerEvent()
	self.event_list = {
		-- ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD,handler(self,self.initRedPoint)),
		ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM,handler(self,self.updateRedPoint)),
		ex.EventManager:add(EVENT.BACK_PACK_EVENT.BACKPACK_INIT_FINISH,handler(self,self.initRedPoint)),
		ex.EventManager:add(EVENT.HERO_EQUIP_EVENT.HERO_EQUIP_CHANGE,handler(self,self.onChangeEquip)),
	}
end

function EquipData:onChangeEquip(event,data)
	if type(data) ~= "table" then return end
	local isRed = false
	for k,v in pairs(data) do
		local bool = self:checkMakeEquipRedPointByPlace(v)
		if isRed == false then isRed = bool end
	end
	self:checkMakeEquipRedPoint()
end

function EquipData:initRedPoint(event,item_type)
	-- if item_type == ItemType.IT_GOLD then 
	-- 	dump(item_type)
	-- else
	-- 	dump(self.equip_base_type)
	-- end
	
	for i=1,EquipMaxCount do
		self:checkMakeEquipRedPointByPlace(i)
	end
	self:checkHeroEquipRedPointByScene()
	self:checkMakeEquipRedPoint()
end

function EquipData:updateRedPoint(event,data)
	
    if not data then return end 
	local refresh = false 
	if type(data) == "number" then 
		if data == ItemType.IT_GOLD then 
			refresh = true 
		else
			local config = cfg.item.item[data]
			if config.mode == ItemData.IT_EQUIP then 
				refresh = true 
			end
		end
	elseif type(data) == "table" then 
		for i,v in ipairs(data) do
			if v.type == ItemType.IT_GOLD then 
				refresh = true 
				break
			else
				local config = cfg.item.item[v.type]
				if config.mode == ItemData.IT_EQUIP then 
					refresh = true 
					break
				end
			end
		end
	end
	if not refresh then return end 
	self:initRedPoint()
end

function EquipData:removeEvent()
	if self.event_list ~= nil then 
		for k,v in pairs(self.event_list) do
			ex.EventManager:remove(v)
		end
	end
end

function EquipData:setRemoveEquipList(list)
	self.equip_remove_list = list
end

function EquipData:getRemoveEquipList()
	return self.equip_remove_list
end

function EquipData:getBaseEquipByPlace(place)
	return self.equip_base_type[place]
end

function EquipData:initComposeData()
	for i=1,EquipMaxCount do
		self.equip_compose_list[i] = {}
	end

	for k,v in pairs(cfg.equipmenttype.equip) do
		if v.need_equipment ~= "" and table.nums(v.need_equipment) > 0 then
			local place = v.place
			table.insert(self.equip_compose_list[place],v)
		else
			local place = v.place
			self.equip_base_type[place] = v.equipment_type
		end
	end

	local function sor(a,b)
		return a.equipment_type < b.equipment_type
	end

	for k,v in pairs(self.equip_compose_list) do
		table.sort( v, sor )
	end
end


-----------------------一键合成--------------------------

function EquipData:checkCanComposeByType(place)
	local has_equip = {}
	local list = self.equip_compose_list[place]
	local max_compose_type = 0
	local star_type = 0
	local end_type = 0
	local base_type = 0
	local total_gold = 0
	local place_list = {}

	for i,v in ipairs(list) do
		local has_num = ex.Player.backpack_data:getEquipTypeNum(v.equipment_type)
		table.insert(place_list,v.equipment_type)
		if not has_equip[v.need_equipment[1].item_type] then -- 基础装备不计入，所以要手动添加
			has_equip[v.need_equipment[1].item_type] = {}
			has_equip[v.need_equipment[1].item_type].has_num = ex.Player.backpack_data:getEquipTypeNum(v.need_equipment[1].item_type)
			has_equip[v.need_equipment[1].item_type].type = v.need_equipment[1].item_type
			has_equip[v.need_equipment[1].item_type].compose_num = 0
			star_type = v.need_equipment[1].item_type
			base_type = v.need_equipment[1].item_type
		end

		local has_need_num = has_equip[v.need_equipment[1].item_type].has_num + has_equip[v.need_equipment[1].item_type].compose_num
		local compose_num = math.floor(has_need_num / v.need_equipment[1].item_num)
		if ex.Player.gold - total_gold > 0 then 
			local has_gold = ex.Player.gold - total_gold
			local mix = math.floor(has_gold / v.need_gold)
			compose_num = math.min(mix,compose_num)
			total_gold = total_gold + compose_num * v.need_gold
		end

		has_equip[v.equipment_type] = {}
		has_equip[v.equipment_type].has_num = has_num --+ compose_num
		has_equip[v.equipment_type].type = v.equipment_type
		has_equip[v.equipment_type].compose_num = compose_num

		if compose_num > 0 then 
			max_compose_type = v.equipment_type
		end
 
		local need_num = compose_num * v.need_equipment[1].item_num

		if (has_equip[v.need_equipment[1].item_type].has_num - need_num) >= 0 then 

			has_equip[v.need_equipment[1].item_type].has_num = has_equip[v.need_equipment[1].item_type].has_num - need_num

		else -- 拥有物品不够时

			local need = need_num - has_equip[v.need_equipment[1].item_type].has_num
			has_equip[v.need_equipment[1].item_type].has_num = 0
			has_equip[v.need_equipment[1].item_type].compose_num = has_equip[v.need_equipment[1].item_type].compose_num - need

		end

	end

	local compose_num = has_equip[max_compose_type] and has_equip[max_compose_type].compose_num or 0
	local items = {}
	for k,v in pairs(has_equip) do

		local total_num = v.compose_num + v.has_num
		local has_num = ex.Player.backpack_data:getItemNum(v.type)
		if total_num > has_num then 
			table.insert( items,v.type )
		end
	end

	local data = {}
	data.equip = {}
	data.need_gold = total_gold
	for i,v in ipairs(items) do
		local equip = {max_compose_type = v , compose_num = has_equip[v].compose_num }
		table.insert(data.equip,equip)
	end
	return data --{max_compose_type = max_compose_type , compose_num = compose_num , need_gold = total_gold}

end
-----------------------一键合成--------------------------

function EquipData:getComposeListByPlace(place)
	return self.equip_compose_list[place]
end

function EquipData:checkMakeEquipRedPoint()
	local bool = false
	for i,val in pairs(self.equip_compose_list) do
		bool = self:checkMakeEquipRedPointByPlace(i)
		if bool == true then
			break
		end
	end

ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCTJP, bool and ex.JumpManager:checkOpenConditionByAtomNoMsg("main_smith_shop"))
end

function EquipData:checkMakeEquipRedPointByPlace(place)
	self.equip_compose_palce_red[place] = false 
	local data = self.equip_compose_list[place]
	local isRed = false
	for k,v in pairs(data) do
		local hasNum = ex.Player.backpack_data:getEquipTypeNum(v.need_equipment[1].item_type)
		local count = math.min(math.floor(hasNum / v.need_equipment[1].item_num) , math.floor(ex.Player.gold / v.need_gold) )
		local bool = count > 0
		self.equip_compose_item_red[v.equipment_type] = bool
		if bool == true then
			self.equip_compose_palce_red[v.place] = bool
			isRed = true
		end
	end
	return isRed
end

function EquipData:getEquipRedPointByPlace(place)
	return self.equip_compose_palce_red[place]
end

function EquipData:getEquipRedPointByType(equip_type)
	return self.equip_compose_item_red[equip_type]
end

function EquipData:setHeroEquip(data)
	self.equip_list[data.hero_id] = data
end

function EquipData:getHeroEquip(hero_id)
	if not self.equip_list[hero_id] then self.equip_list[hero_id] = {equip_list = {} , hero_id = hero_id} end
	return self.equip_list[hero_id] 
end

function EquipData:clearHeroEquipData(hero_id)
	local hero_equip = self:getHeroEquip(hero_id).equip_list
	-- for k,v in pairs(hero_equip) do
	-- 	ex.Player:addItem(v.item_type, 1 ,v.item_id)
	-- end

	self.equip_list[hero_id] = nil
end

function EquipData:getHeroEquipByList(vec_hero)
	local vec_equip = {}
	for k,v in pairs(vec_hero) do
		local hero_id = type(v) == "number" and v or v.hero_id
		local equip = self.equip_list[hero_id] or {equip_list = {} , hero_id = hero_id}
		table.insert(vec_equip, equip)
	end
	return vec_equip
end

function EquipData:changeHeroEquip(hero_id,data)
	if not self.equip_list[hero_id] then return end
	self.equip_list[hero_id] = data
end

function EquipData:initEquipScore()
	for k,v in pairs(cfg.equipmenttype.equip) do
		self:setEquipScore(k)
	end
end

-- 角色战力&武器评分算法：攻击*1+血量*0.16+防御*1  速度不用算
function EquipData:setEquipScore(equip_type)
	local config = cfg.equipmenttype.equip[equip_type]
	local score = 0
	for k,v in pairs(config.ability) do
		local idx = TableEx.findValueFunction(cfg.scorecount.equip, function(value)
			return value.mapping == v.attr
		end) --cfg.scorecount.mapping[v.attr]

		if idx ~= nil then 
			idx = idx.idx
			local ratio = cfg.scorecount.equip[idx].ratio / 10000
			score = score + math.ceil(v.value * ratio)
		else
			score = score + 0
		end
	end
	self.equip_score[equip_type] = score
end

function EquipData:getEquipScore(equip_type)
	if equip_type == 0 or equip_type == nil then return 0 end
	return self.equip_score[equip_type]
end

function EquipData:checkHeroEquipRedPoint(hero_id)

	local equip_data = self.equip_list[hero_id]
	if not equip_data then return false end
	local hero_equip = equip_data.equip_list
	-- hero_equip.equip_list
	local redPoints = {}

	for i=1,EquipMaxCount do
		if hero_equip[i] ~= nil and hero_equip[i].item_type ~= 0 then 
			local data = ex.Player.backpack_data:getEquipByPlace(i)
			for k,v in pairs(data) do
				local curScore = self:getEquipScore(hero_equip[i].item_type) or 0
				local backScore = self:getEquipScore(v.item_type) or 0
				redPoints[i] = backScore > curScore
				if redPoints[i] == true then break end
			end
		else
			local data = ex.Player.backpack_data:getEquipByPlace(i)
			redPoints[i] = #data > 0
		end
	end
	return redPoints

end

function EquipData:checkHeroEquipRedPointByScene()
	local battle_list = self.parent.promote:getBattleList()
	local bool = false
	for k,v in pairs(battle_list) do
		bool = self:checkBattleHeroEquip(k)
		if bool == true then break end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, bool)
	return bool
end

function EquipData:checkBattleHeroEquip(hero_id)
	local isBattle = self.parent.promote:heroIsBattle(hero_id)
	if not isBattle then return false end

	local equip_data = self.equip_list[hero_id]
	if not equip_data then return false end
	local hero_equip = equip_data.equip_list
	-- hero_equip.equip_list
	local redPoint = false

	for i=1,EquipMaxCount do
		if hero_equip[i] ~= nil and hero_equip[i].item_type then 
			local data = ex.Player.backpack_data:getEquipByPlace(i)
			local curScore = self:getEquipScore(hero_equip[i].item_type)
			for k,v in pairs(data) do
				local backScore = self:getEquipScore(v.item_type)
				-- dump(curScore,backScore)
				redPoint = backScore > curScore
				if redPoint == true then 
					break
				end
			end
		else
			local data = ex.Player.backpack_data:getEquipByPlace(i)
			redPoint = #data > 0
		end

		if redPoint == true then 
			break
		end
	end
	return redPoint
end

function EquipData:checkWearEquip(hero_id)
	local equip_data = self.equip_list[hero_id]
	local maxWear = {}
	if not equip_data then return maxWear end
	local hero_equip = equip_data.equip_list

	for i=1,EquipMaxCount do
		local equip_items = ex.Player.backpack_data:getEquipByPlace(i)
		local score = 0
		local equip_item

		if hero_equip[i] ~= nil and hero_equip[i].item_type ~= 0 then 
			score = self:getEquipScore(hero_equip[i].item_type)
		end

		for k,v in pairs(equip_items) do
			local maxScore = self:getEquipScore(v.item_type)
			if score < maxScore then 
				score = maxScore
				equip_item = v
			end
		end
		maxWear[i] = equip_item
	end
	return maxWear
end

function EquipData:setOneKeyNeedGold(num)
	-- body
	self.equip_need_gold = num
end

function EquipData:getOneKeyNeedGold()
	-- body
	return self.equip_need_gold
end

function EquipData:clear()
	-- print("EquipData:clear", self)
	self:removeEvent()
	self.parent = nil
	self.equip_list = nil
	self.equip_score =nil
	self.equip_compose_list = nil
	self.equip_compose_item_red = nil
	self.equip_compose_palce_red = nil
	self.equip_remove_list = nil
	self.equip_need_gold = nil
end


function EquipData:getEquipAbilityList(equip_type)
	local cfg = cfg.equipmenttype.equip[equip_type]
	if not cfg then
		return {}
	end

	local vec_result = {}
	for k,v in pairs(cfg.ability) do
		-- 合并相同属性
		if vec_result[v.attr] then
			vec_result[v.attr] =  vec_result[v.attr] + v.value
		else
			vec_result[v.attr] = v.value
		end
	end
	return vec_result
end

function EquipData:getEquipSetConfig(equip_type, num)
	for k,v in pairs(cfg.equipmentsettype.set) do
		if v.type == equip_type and v.num == num then
			return v
		end
	end
	
	return nil
end

function EquipData:checkSoulReddot(hero_id)
	local is_actionable = false
	local max_level = {0,0,0,0}
	for i,v in ipairs(cfg.heroequipsoul.heroequipsoul) do
		max_level[v.place] = v.level > max_level[v.place] and v.level or max_level[v.place]
	end
	-- ex.Player.hero_data.equip
	local equip = self:getHeroEquip(hero_id).equip_list
	for i,v in pairs(equip) do
		if v.item_type ~= nil and v.item_type ~= 0 then
			local config = cfg.equipmenttype.equip[v.item_type]
			local requirement = cfg.heroequipsoulextra.heroequipsoulextra[i]
			if config.star >= requirement.need_equip_star and config.rare >= requirement.need_euqip_rare then
				if v.soul_lv < max_level[i] then
					for j,k in pairs(cfg.heroequipsoul.heroequipsoul) do
						if i == k.place then
							if k.level == v.soul_lv + 1 then
								local num = 0
								for w,g in pairs(k.cost) do
									if ex.Player:getItemNum( g.item_type) >= g.item_num then
										num = num + 1
									end
								end
								if num == 2 then
									is_actionable = true
									break
								end
							end
						end
					end
				end
			end
		end

		if is_actionable then
			break
		end
	end
	return is_actionable
end

return EquipData