local HeroData = class("HeroData")

-- 招募完成度
function HeroData:ctor()
	self.hero_list = {}
	self.hero_illustrat = {} -- 英雄图鉴数据
	self.fight_hero = {} -- 上阵英雄

	self.sort_index = 0 -- 排序后.符合条件的英雄
	self.free_time = 0
	self.hero_capacity = 0		-- 英雄容量
	self.buy_space_times = 0	-- 英雄容量购买次数
	self.hero_illustrat_select = 0 --选择的索引
	self.hero_illustrat_cfg = {}	--当前选择的图鉴数据
	self.all_illustrat_cfg = {}		--全部的图鉴数据
	self.evolve_illustrat_cfg = {}	-- 全部的进化图鉴数据
	self.hero_layer_tab = 1			--英雄界默认显示英雄

	self.hero_bag_tip = 0
	self.hero_bag_tip_time = 0

	self.hero_palace_list = {}	-- 英雄殿堂数据列表

	self.hero_stone_list = {}
	self.btn_elem_state = 0    --英雄界面属性的状态

	self.promote = require("src.data.Promote").new(self)	--英雄提升，升级升星，创造法阵
	self.equip = require("src.data.EquipData").new(self)
	self.artifact = require("src.data.ArtifactData").new(self)
	self.fashion = require("src.data.HeroFashionData").new(self)
	self.astrolabe = require("src.data.HeroAstrolabeData").new(self)
	self.pet = require("src.data.PetData").new(self)
	self.totems = require("src.data.TotemsData").new(self)
    self.magicCube = require("src.data.MagicCubeData").new(self)
	self.hexagram = require("src.data.HexagramData").new(self)
	self.magic_wand = require("src.data.MagicWandData").new(self)

	self:initHeroIllustrat()
	self:registerEvent()
	self:initAllIllustrat()
	self:initEvolveAllIllustrat()
end


----------------------------------英雄宝石--------------------------------------
function HeroData:setHeroJewelList(data)
	self.hero_stone_list = data
end

function HeroData:getHeroJewelListForHeroid( hero_id )
	return self.hero_stone_list[hero_id] or {}
end


function HeroData:changeHeroJewelListForHeroid( hero_id , jewel)
	
	if not self.hero_stone_list[hero_id] then 
		self.hero_stone_list[hero_id] = {}
		table.insert( self.hero_stone_list[hero_id] , jewel)
	else 

		local flag = false
		for i,v in ipairs(self.hero_stone_list[hero_id].jewel_list) do
			if v.place == jewel.place then 
				v.jewel_id = jewel.jewel_id
				v.place = jewel.place
				v.jewel_type = jewel.jewel_type
				flag = true
			end 
		end
		if flag == false then 
			table.insert( self.hero_stone_list[hero_id].jewel_list, jewel )
		end 
	end 
end

function HeroData:subHeroJewelListForHeroid(hero_id , jewel )
	if self.hero_stone_list[hero_id] then 
		for i,v in ipairs(self.hero_stone_list[hero_id].jewel_list) do
			if v.place == jewel.place then 
				self.hero_stone_list[hero_id].jewel_list[i] = {}
			end 
		end
	end 
end

function HeroData:refreshJewelData(hero_id , jewel_list )
	-- if self.hero_stone_list[hero_id] then 
	-- 	self.hero_stone_list[hero_id].jewel_list = jewel_list
	-- end 

	if not self.hero_stone_list[hero_id] then 
		self.hero_stone_list[hero_id] = {}
	end 

	self.hero_stone_list[hero_id].jewel_list = jewel_list
end


-- 红点检测
function HeroData:checkHeroJewelRed( hero_id ,hero_star)
	local return_stone_type= {}
	local now_hero_stone_data = self:getHeroJewelListForHeroid(hero_id)

    local place_list = {}
    local vec_dec = ex.Tools:stringSplit( cfg.system.jewel_single_open_star, ";")
    for i,v in ipairs(vec_dec) do
        local position  = ex.Tools:stringSplit( v, "_")
        if position and #position > 1 then 
            place_list[tonumber(position[1])] =tonumber(position[2])
        end 
    end

	for i=1,3 do
		local cur_item_type = 0
		-- 检测我的宝石情况
		if not now_hero_stone_data.jewel_list then  now_hero_stone_data.jewel_list = {} end 
		for ji,jv in ipairs(now_hero_stone_data.jewel_list) do
			if jv.place == i then 
				cur_item_type = jv.jewel_type
				break;
			end 
		end

		local stone_list = ex.Player.backpack_data:getStoneByPlace(i)
		-- 判断我当前的宝石跟我仓库的宝石
		local save_hero_stone_list = {}
		for si,sv in ipairs(stone_list) do
			local stone_config =  cfg.jeweltype.jeweltype[sv.item_type] 
			if stone_config then  table.insert( save_hero_stone_list, stone_config )  end 
		end
		if #save_hero_stone_list > 0 then 
			local sort = function ( a, b  )
				return a.star > b.star
			end
			table.sort( save_hero_stone_list, sort )	
			if tonumber(hero_star) >= tonumber( place_list[i] ) then 
				if cur_item_type > 0 then 
					local cur_stone_config =  cfg.jeweltype.jeweltype[cur_item_type] 
					if save_hero_stone_list[1].star > cur_stone_config.star then 
						local position_data = {}
						position_data.place = i
						position_data.item_type = save_hero_stone_list[1].jewel_type
						table.insert( return_stone_type, position_data )
					end 
				else 
					local position_data = {}
					position_data.place = i
					position_data.item_type = save_hero_stone_list[1].jewel_type
					table.insert( return_stone_type, position_data )
				end 
			end 
		end 
	end
	return return_stone_type
end


function HeroData:checkHeroStoneTao(hero_id )
	local hero_jewel_data = self:getHeroJewelListForHeroid(hero_id)
	local now_nums = 0
	local min_star = 1000
	if not hero_jewel_data.jewel_list then hero_jewel_data.jewel_list = {} end 
    for i,v in ipairs(hero_jewel_data.jewel_list) do
        if v.jewel_type and v.jewel_type > 0  then 
			local cur_stone_config =  cfg.jeweltype.jeweltype[v.jewel_type] 
			if cur_stone_config.star <  min_star then 
				min_star = cur_stone_config.star 
				now_nums = 1
			elseif cur_stone_config.star >=  min_star then 
				now_nums = now_nums + 1
			end 
        end 
	end	

	now_nums = 0
    for i,v in ipairs(hero_jewel_data.jewel_list) do
        if v.jewel_type and v.jewel_type > 0  then 
			local cur_stone_config =  cfg.jeweltype.jeweltype[v.jewel_type] 
			if cur_stone_config.star >=  min_star then 
				now_nums = now_nums + 1
			end 
        end 
	end	


	if min_star == 1000 then min_star = 0 end 

	return now_nums, min_star
end



function HeroData:checkHeroStoneTaoByItemType(hero_id , item_type)

	local hero_jewel_data = self:getHeroJewelListForHeroid(hero_id)

	local item_config = cfg.jeweltype.jeweltype[item_type] 
	local show_flag = false
	for i,v in ipairs(cfg.jewelsettype.jewelsettype) do
		if v.star == item_config.star then 
			show_flag = true 
		end 
	end
	if show_flag == false then return nil end 

	local return_data = {}
	return_data.item_type = item_type
	return_data.star = item_config.star
	return_data.num = 0
	return_data.max_num = 3
	
	if not hero_jewel_data.jewel_list then hero_jewel_data.jewel_list = {} end 
	for i,v in ipairs(hero_jewel_data.jewel_list) do
        if v.jewel_type and v.jewel_type > 0  then 
			local cur_stone_config =  cfg.jeweltype.jeweltype[v.jewel_type] 
			if cur_stone_config.star >= item_config.star then 
				return_data.num = return_data.num + 1
			end 
        end 
	end	
	return return_data
end






------------------------------------------------------------------------



function HeroData:getHeroBattleMsg(hero_id)
	-- 英雄所在战斗提示
	local req = Hero_pb.GReqChoose()
	req.hero_id = hero_id
	NetManager:sendMessage(ProtocolID.GReqChoose, req)
end


function HeroData:refreshHeroList()
	-- 刷新英雄背包
	local req = Hero_pb.GReqHeroList()
	req.page = 1
	NetManager:sendMessage(ProtocolID.GReqHeroList, req)
end

function HeroData:getHeroCapacityConfig(buy_times)
	for i,v in ipairs(cfg.herospace.herospace) do
		if v.times == buy_times then
			return v
		end
	end
	return nil
end

function HeroData:getHeroMaxStar(hero_type)
	local star = 0
    for k,v in pairs(cfg.herotype.star) do
		if v.type == hero_type then
			star = 5
			for i=6,13 do
				if v["to_"..i.."_star"] ~= "" and table.nums(v["to_"..i.."_star"]) > 0 then
					star = i
				else
					return star
				end
			end
			break
		end
	end
	return star
end

function HeroData:getSkillDescription(skill_type, skill_level)
    local config = cfg.heroskill.getConfigByType(skill_type, skill_level);
    if config == nil then
        return ""
	end
	
    local vec_dec = ex.StringUtil.splitStringIntoVector("##", ex.Tools:getLang(skill_type + skill_level - 1))
	
	local str_desc = ""
	for i,v in ipairs(vec_dec) do
        if i % 2 == 1 then
            vec_dec[i] = self:getAttribute(v, skill_level)
		end
        str_desc = ""..str_desc..v
    end
    return str_desc
end

function HeroData:getAttribute(str_key, skill_level)
	local str = ""
	local vec_key = ex.StringUtil.splitStringIntoVector(",", str_key)
		
	local buff_config = cfg.buff.buff[tonumber(vec_key[0])]
	if buff_config == nil or table.nums(vec_key) < 3 or skill_level < 1 then
		return str
	end
		
	local value = 0
	if vec_key[2][0] == 'v' then
		local index = tonumber(vec_key[2].substr(1))
		value = buff_config.map_value_level[index - 1][level-1]
	elseif vec_key[2][0] == 't' then
		value = buff_config.vec_target_num[level-1]
	elseif vec_key[2][0] == 'r' then
		value = buff_config.vec_round_num[level-1]
	elseif vec_key[2][0] == 'a' then
		value = buff_config.vec_attach_percent[level-1]
	end
		
	if vec_key[1] == "i" then
		-- 整数显示
		str = string.format("%d", abs(value))
	elseif vec_key[1] == "p" then
		-- 百分比显示
		str = string.format("%g", 1.0 * abs(value) * 0.01)
	elseif vec_key[1] == "o" then
		-- 显示职业
		str = ex.Tools:getLang(111000 + value)
	end

	return str
end
	
function HeroData:setOpenTab(tab)
	self.hero_layer_tab = tab
end

function HeroData:getOpenTab()
	return self.hero_layer_tab
end

function HeroData:setIllustratIdx(idx)
	self.hero_illustrat_select = idx
end

function HeroData:getIllustratIdx()
	return self.hero_illustrat_select
end

function HeroData:editIllustratListByElem(elem)

    local list = {}
    local has_list = self.all_illustrat_cfg
    --local config = cfg.herotype.star
    for k,v in ipairs(has_list) do
        table.insert(list,v)
    end
    -- dump(list)
    local function sor(a, b)
        -- local proA = a.unlock == true and 100 or 0
        -- local proB = b.unlock == true and 100 or 0

        -- 不需要按照是否拥有排序了
		local proA = 0
        local proB = 0

        if proA ~= proB then return proA > proB end
        local starA = a.star 
        local starB = b.star 
        if starA ~= starB then return starA > starB end
        return a.type > b.type
    end

    -- if not self.hero_max_star then 
    --     self.hero_max_star = self:getIllustratMaxStar(config)
    -- end
    -- local function sor(a,b)
    --     local proA = has_list[a] == true and 100 or 0
    --     local proB = has_list[b] == true and 100 or 0
    --     if proA ~= proB then return proA > proB end
    --     local starA = self.hero_max_star[a]
    --     local starB = self.hero_max_star[b]
    --     if starA ~= starB then return starA > starB end
    --     local typeA = config[a].type
    --     local typeB = config[b].type
    --     return typeA > typeB
    -- end
    table.sort(list,sor)

    elem = elem or ElemType.ALL

    if elem == ElemType.ALL then
    	return list
    end

    local cur_list = {}
    for i,v in ipairs(list) do
        local config = cfg.herotype.star[v.type]
        if elem == config.elem and config.kind == 1 then table.insert(cur_list, v) end
    end

    return cur_list
end

--[[
	@param min_star, max_star: 星级区间
]]
function HeroData:editIllustratListByStar(min_star, max_star)

    local list = {}
    local has_list = self.all_illustrat_cfg
    --local config = cfg.herotype.star
    for k,v in ipairs(has_list) do
        table.insert(list,v)
    end
    -- dump(list)
    local function sor(a, b)
        -- local proA = a.unlock == true and 100 or 0
        -- local proB = b.unlock == true and 100 or 0

        -- 不需要按照是否拥有排序了
		local proA = 0
        local proB = 0

        if proA ~= proB then return proA > proB end
        local starA = a.star 
        local starB = b.star 
        if starA ~= starB then return starA > starB end
        return a.type > b.type
    end

    -- if not self.hero_max_star then 
    --     self.hero_max_star = self:getIllustratMaxStar(config)
    -- end
    -- local function sor(a,b)
    --     local proA = has_list[a] == true and 100 or 0
    --     local proB = has_list[b] == true and 100 or 0
    --     if proA ~= proB then return proA > proB end
    --     local starA = self.hero_max_star[a]
    --     local starB = self.hero_max_star[b]
    --     if starA ~= starB then return starA > starB end
    --     local typeA = config[a].type
    --     local typeB = config[b].type
    --     return typeA > typeB
    -- end
    table.sort(list,sor)

    local cur_list = {}
    for i,v in ipairs(list) do
		if min_star <= v.star and max_star > v.star then 
			table.insert(cur_list, v) 
		end
    end

    return cur_list
end

function HeroData:setCurIllustratCfg(data)
	self.hero_illustrat_cfg = data 
end

function HeroData:getCurIllustraCfg()
	return self.hero_illustrat_cfg
end

function HeroData:initHeroIllustrat()
	self.hero_illustrat = {}

	for k,v in pairs(cfg.herotype.star) do
		self.hero_illustrat[v.type] = 0
	end
end

function HeroData:initAllIllustrat()
	self.all_illustrat_cfg = {}
	local config = cfg.skin.skin
	for k,v in pairs(config) do
		for _,val in pairs(v.handbook) do
			if cfg.herotype.star[v.type] and cfg.herotype.star[v.type].kind == 1 then
				local data = {}
				data.type = v.type 
				data.star = val
				data.unlock = false
				table.insert(self.all_illustrat_cfg , data)
			end
		end
	end
end

function HeroData:initEvolveAllIllustrat()
    self.evolve_illustrat_cfg = {}
	local record_list = {}
	local elem_dict = {}
	local evolve_num = 0
    local config = cfg.heroevolvelevel.heroevolvelevel
    for k, v in pairs(config) do
		local hero_type = v.hero_type
		local hero_config = cfg.herotype.star[hero_type]
		if not record_list[hero_type] and hero_config then
			for index, skin_config in pairs(cfg.skin.skin) do
				if hero_type == skin_config.type then
					local elem = hero_config.elem
					local skin = skin_config.skin
					local stars = skin_config.star_limit
					if skin and #skin > 0 and stars and #stars > 0 then
						local star = stars[#stars]
						local hero_star_config = cfg.herostar.star[star]
						if not self.evolve_illustrat_cfg[elem] then
							self.evolve_illustrat_cfg[elem] = {}
						end

						if not elem_dict[elem] then
							elem_dict[elem] = 1
						else
							elem_dict[elem] = elem_dict[elem] + 1
						end

						local model = {
							idx = elem_dict[elem],
							hero_type = hero_type,
							elem = elem,
							star = star,
							level = hero_star_config.level_limit
						}
						table.insert(self.evolve_illustrat_cfg[elem], model)
						record_list[hero_type] = true
						evolve_num = evolve_num + 1
						break
					end
				end	
			end
		end
    end

	local last_evolve_num = cc.UserDefault:getInstance():getIntegerForKey("evolve_num", 0)
	if evolve_num > last_evolve_num then
		cc.UserDefault:getInstance():setIntegerForKey("evolve_num", evolve_num)
		cc.UserDefault:getInstance():setBoolForKey("has_evolve_red_point", true)
	end
end

function HeroData:setIllustratUnLock(type)
	local star = self.hero_illustrat[type]
	for k,v in pairs(self.all_illustrat_cfg) do
		if v.type == type then 
			v.unlock = v.star <= star
		end
	end
end

function HeroData:getIllustratData(type,star)
	for k,v in pairs(self.all_illustrat_cfg) do
		if v.type == type and v.star == star then 
			return v
		end
	end
end

function HeroData:initRedPoint()
	self.promote:initUpStarRedPoint()
	-- self.equip:initRedPoint()

	local isRed = false
	-- add 熊梦 用统一的红点变量 is_show_red为true 就不检测别的条件了 减少运算
	local is_show_red = false
	for i=1,EquipMaxCount do
		isRed = self.equip:getEquipRedPointByPlace(i)
		if isRed == true then break end
	end
	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCTJP  , isRed)
	local battle_list = self.promote.battle_list
	local runes_red = false
	for k,v in pairs(battle_list) do
		local red = ex.Player.backpack_data:checkRunesRedByHero(k)
		if red == true then 
			runes_red = red 
			is_show_red = red
			break 
		end
	end


	local jewel_red = false
	local god_equip_red = false 

	if not is_show_red then
		for k,v in pairs(battle_list) do
			local hero = ex.Player.hero_data:getHeroDataById(k)
			if not hero then break end 
			local update_stone_type_list = self:checkHeroJewelRed(hero.hero_id, hero.star)
	
			if god_equip_red == false then 
				god_equip_red = ex.Player.backpack_data:checkGodEquipRedDot(hero.hero_id,hero.star)
				is_show_red = god_equip_red
			end 
	
			if #update_stone_type_list > 0 then 
				jewel_red = true 
				is_show_red = true
				break;
			end 
		end
	end
	


	-- add 熊梦 检测是否可以免费觉醒
	if not is_show_red then
		for k,v in pairs(battle_list) do
			local hero_data = ex.Player.hero_data:getHeroDataById(k)
			-- 预防报错
			if hero_data then
				local is_awaken_red = ex.Player.hero_data.promote:checkAwakenReddot(hero_data.hero_type,hero_data.star,hero_data.awaken)
				if is_awaken_red then
					is_show_red = is_awaken_red
					break
				end
			end
		end
	end

	-- add 熊梦 检测是否可操作皮肤 
	if not is_show_red then
		for k,v in pairs(battle_list) do
			local hero_data = ex.Player.hero_data:getHeroDataById(k)
			-- 预防报错
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
	end

	-- 魔杖红点
	if not is_show_red then
		for k,v in pairs(battle_list) do
			local red = self.magic_wand:checkReddot(k)
			if red then
				is_show_red = true
				break
			end
		end
	end

	-- 六芒星红点
	if not is_show_red then
		for k,v in pairs(battle_list) do
			local red = self.hexagram:checkReddot(k)
			if red then
				is_show_red = true
				break
			end
		end
	end

	-- 检测神器
	--local redpoint = self.promote:checkLevelRedPoint() or  self.promote:checkUpstarRedPoint() or self.equip:checkHeroEquipRedPointByScene() or self.promote:checkMainCityRedPoint() or runes_red or jewel_red or god_equip_red or is_show_red
	local artifact_red = self.artifact:checkMainCityRedPoint() 
	local pet_red = self.pet:checkMainCityRedPoint()
	local totem_red = self.totems:checkMainCityRedPoint()

	local redpoint = self.promote:checkLevelRedPoint() or  self.promote:checkUpstarRedPoint() or self.equip:checkHeroEquipRedPointByScene() or self.promote:checkMainCityRedPoint() or is_show_red or artifact_red or pet_red or totem_red
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, redpoint)

end

function HeroData:registerEvent()
	self.event_list = {
		ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.ITEM_TYPE_IT_GOLD,handler(self,self.onGold)),
		ex.EventManager:add(EVENT.BACK_PACK_EVENT.BACKPACK_UPDATA_LIST,handler(self,self.onItem)),
	}
end

function HeroData:onGold( evnet,data )
	self.promote:updateRedPoint(evnet,data)
	self.equip:initRedPoint(evnet,data)
	self:checkMainCityRedPoint()
end

function HeroData:onItem(evnet, data)
	self.promote:updateRedPoint(evnet,data)
	self.equip:updateRedPoint(evnet,data)

	self:checkMainCityRedPoint()
end

function HeroData:checkMainCityRedPoint(data)
	local is_red = false
	is_red = is_red or self.equip:checkHeroEquipRedPointByScene()
	is_red = is_red or self.promote:checkMainCityRedPoint()
	is_red = is_red or self.artifact:checkMainCityRedPoint()
	is_red = is_red or self.pet:checkMainCityRedPoint()
	is_red = is_red or self.totems:checkMainCityRedPoint()
	is_red = is_red or self.magic_wand:checkReddotByScene()

	
	local evo_red = self:checkEvolveRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, is_red)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_TJT_JHTJ, evo_red)
end

function HeroData:checkEvolveRedPoint()
	local first_evolve_ill_rp_status = cc.UserDefault:getInstance():getIntegerForKey("first_evolve_ill_rp_status", -1)
	if first_evolve_ill_rp_status == -1 then
		local star = cfg.system.heroevo_need_herostar or 10
		local need_num = cfg.system.heroevo_open or 1
		local hero_list = self:getHeroByStar(star)
		if hero_list and #hero_list >= need_num then
			cc.UserDefault:getInstance():setIntegerForKey("first_evolve_ill_rp_status", 1)
			first_evolve_ill_rp_status = 1
		end
	end

	if first_evolve_ill_rp_status == 0 then
		local evolve_rp = cc.UserDefault:getInstance():getBoolForKey("has_evolve_red_point", false)
		return evolve_rp
	else
		return first_evolve_ill_rp_status == 1
	end
end

function HeroData:removeEvent()
	if self.event_list ~= nil then
		for k, v in pairs(self.event_list) do
			ex.EventManager:remove(v)
		end
	end
end


function HeroData:clear()
	self.promote:clear()
	self.equip:clear()
	self.artifact:clear()
	self.pet:clear()
	self.totems:clear()
    self.magicCube:clear()
	self:removeEvent()
	self.hero_layer_tab = nil
end


function HeroData:initSort()
	for k, v in pairs(self.hero_list) do
		self.sort_index = self.sort_index + 1
	end
end

function HeroData:getHeroByElem(elem)
	if elem == 0 then
		return self.hero_list
	end
	local list = {}
	for i, v in ipairs(self.hero_list) do
		if v.elem == elem then
			table.insert(list, v)
		end
	end

	return list
end

function HeroData:getHeroList( )
	return self.hero_list
end

function HeroData:getCapacity()
	local num = 0
	-- local config =  cfg.goddessvip.goddessvip[ex.Player.fetter_data.vip.vip_level]--cfg.vip.vip[ex.Player.vip_level]
	-- if config then
	-- 	num = config.extra_bag_space
	-- end

	return self.hero_capacity + num
end

function HeroData:addCapacity(capacity)
	self.hero_capacity = self.hero_capacity + capacity
end

function HeroData:addHero(newhero)
	table.insert(self.hero_list, newhero)
end

function HeroData:addIllustrat(hero_type,star)
	-- local illustrat_item = {}
	self.hero_illustrat[hero_type] = star
	-- table.insert(self.hero_illustrat, illustrat_item)
end

function HeroData:removePart(cur_list, part_hero_id_list)
	for _,id in pairs(part_hero_id_list) do
		repeat
			for i,v in ipairs(cur_list) do
				if id == v.hero_id then
					table.remove(cur_list, i)
					break
				end
			end
		until true
	end

	return cur_list
end

function HeroData:sortByTask(cur_list, task_hero_id_list)
	-- 给执行任务的英雄一个递增的标记
    local task_tag = 0
    for _,v in pairs(cur_list) do
    	v.hasTask = 0
    	repeat
    		for _,id in pairs(task_hero_id_list) do
    			if v.hero_id == id then
    				task_tag =  task_tag + 1
    				v.hasTask = task_tag
    				break
    			end
    		end
    	until true
    end
    
    -- 排序
    local function sor(a, b)
    	local comp_a = a.hasTask * 100000000 + a.star * 10000000 + a.hero_type
		local comp_b = b.hasTask * 100000000 + b.star * 10000000 + b.hero_type
		return comp_a < comp_b
    end
    table.sort(cur_list, sor)
    
    return cur_list
end

function HeroData:sortByStar(cur_list)
	local function sor(a, b)
    	local comp_a = a.star * 10000000 + a.hero_type
		local comp_b = b.star * 10000000 + b.hero_type
		return comp_a < comp_b
    end
    table.sort(cur_list, sor)

	return cur_list
end

function HeroData:changeHeroType(hero_id, to_type)
	for _, v in pairs(self.hero_list) do
		if v.hero_id == hero_id then
			local config = cfg.herotype.star[to_type]
			v.hero_type = config.type
			v.occupation = config.occupation
			return
		end
	end
end

function HeroData:getLen(elem)
	elem = elem or 0

	local len = 0
	for _, v in pairs(self.hero_list) do
		if elem == 0 then
			len = len + 1
		elseif v.elem == elem then
			len = len + 1
		end
	end
	return len
end

function HeroData:getHeroNum(hero_type)
	local num = 0
	for k, v in pairs(self.hero_list) do
		if v.hero_type == hero_type then
			num = num + 1
		end
	end
	return num
end

function HeroData:getHeroDataById(hero_id)
	for k, v in pairs(self.hero_list) do
		if v.hero_id == hero_id then
			return v
		end
	end
	return nil
end

function HeroData:getHeroDataByType(hero_type)
	for k, v in pairs(self.hero_list) do
		if v.hero_type == hero_type then
			return v
		end
	end
	return nil
end

function HeroData:getHeroDataByList(vec_hero)
	local vec_result = {}
	for i,v in ipairs(vec_hero) do
		local hero_data = self:getHeroDataById(v)
		if hero_data then
			table.insert(vec_result, hero_data)
		else
			local data = {}
			data.hero_type = 0
			table.insert(vec_result, data)
		end
	end
	return vec_result
end

function HeroData:removeHeroDataById(hero_id)
	for k, v in pairs(self.hero_list) do
		if v.hero_id == hero_id then
			table.remove(self.hero_list, k)
			local reikis = self.artifact:getArtifactDataByHeroId(hero_id)
			for k,v in pairs(reikis) do
				v.hero_id = 0
			end
			break
		end
	end
end

-- is_fill 读不到配置时。填充0
function HeroData:getHeroElemByList(vec_hero, is_fill)
	local vec_result = {}
	for i,v in ipairs(vec_hero) do
		local hero_type = type(v) == "number" and v or v.hero_type
		local config = cfg.herotype.star[hero_type]

		if is_fill then
			table.insert(vec_result, config and config.elem or 0)
		elseif config then
			table.insert(vec_result, config.elem)
		end
	end
	return vec_result
end

function HeroData:getHeroSkillData(hero_id)
	for k, v in pairs(self.hero_list) do
		if v.hero_id == hero_id then
			return v.skill
		end
	end
	return nil
end

function HeroData:getHeroLevelNum(lelvel)
	local count = 0
	for i, v in ipairs(self.hero_list) do
		if v.level >= level then
			count = count + 1
		end
	end
end


function HeroData:getHeroBase(type, star)
	for k,v in pairs(cfg.herobase.herobase) do
		if v.type == type and v.star == star then
			return v
		end
	end
	return nil
end


function HeroData:getHeroAttribute(type, stage, star, level, evolve)
	local attribute = {}
	attribute.atk = 0
	attribute.hp = 0
	attribute.def = 0
	attribute.spd = 0
	attribute.bat = 0

	local hero_type_config = cfg.herotype.star[type]
	if not hero_type_config then
		return attribute
	end

	local hero_stage = TableEx.findValueFunction(cfg.heroupgraderate.grade, function(value)
		return value.hero_id == type and stage == value.grade
	end) -- cfg.heroupgrade.grade[stage]
	
	if not hero_stage then
		return attribute
	end

	local hero_base_config = self:getHeroBase(type, star)
	if not hero_base_config then
		return attribute
	end

	local hero_stage_level_pre = 1
	local hero_stage_pre = cfg.heroupgrade.grade[stage - 1]
	if hero_stage_pre then
		hero_stage_level_pre = hero_stage_pre.level
	end

	local hero_ratio = cfg.heroratio.ratio[1]

	-- 攻击
	attribute.atk =
		(1.0 * hero_base_config.atk * hero_stage.atk_rate / 10000.0 +
		(level - hero_stage_level_pre) * hero_base_config.atk * hero_stage.atk_grow / 10000.0)

	-- attribute.atk = (hero_type_config.base_atk * hero_stage.atk_rate / 100.0 + (math.min(140, level) - 本阶对应初始等级))

	-- 血量
	attribute.hp =
		(1.0 * hero_base_config.hp * hero_stage.hp_rate / 10000.0 +
		(level - hero_stage_level_pre) * hero_base_config.hp * hero_stage.hp_grow / 10000.0)

	-- 防御
	attribute.def =
		1.0 * hero_base_config.def * hero_stage.def_rate / 10000.0 +
		(level - hero_stage_level_pre) * hero_base_config.def * hero_stage.def_grow / 10000.0

	-- -- 速度
	-- attribute.spd = 1.0 * 200 * hero_stage.spd_rate / 10000.0 +
	-- 			    (hero_base_config.spd - 200) * hero_stage.spd_grow / 100.0 + (level - hero_stage_level_pre) *
	-- 			     200 * hero_stage.spd_grow / 10000.0
	
	-- 速度
	attribute.spd =
	1.0 * hero_base_config.spd * hero_stage.spd_rate / 10000.0 +
	(level - hero_stage_level_pre) * hero_base_config.spd * hero_stage.spd_grow / 10000.0

	local evolve_atk_redio = 1.0
	local evolve_hp_redio = 1.0
	local evolve_def_redio = 1.0
	local evolve_spd_redio = 1.0
	local evolve_atk_add = 0
	local evolve_hp_add = 0
	local evolve_def_add = 0
	local evolve_spd_add = 0
	if evolve and evolve.level then
		local evolve_config = cfg.heroevolvelevel.getEvolutionConfig(type, evolve.level, evolve.type)
		if evolve_config and evolve_config.attr and #evolve_config.attr > 0 then
			for k, v in ipairs(evolve_config.attr) do
				if v.attr == 101 then
					evolve_spd_add = evolve_spd_add + v.value
				elseif v.attr == 102 then
					evolve_hp_redio = evolve_hp_redio + v.value / 10000.0
				elseif v.attr == 201 then
					evolve_atk_redio = evolve_atk_redio + v.value / 10000.0
				elseif v.attr == 202 then
					evolve_def_redio = evolve_def_redio + v.value / 10000.0
				elseif v.attr == 204 then
					evolve_spd_redio = evolve_spd_redio + v.value / 10000.0
				elseif v.attr == 220 then
					evolve_atk_add = evolve_atk_add + v.value
				elseif v.attr == 223 then
					evolve_hp_add = evolve_hp_add + v.value
				elseif v.attr == 224 then
					evolve_def_add = evolve_def_add + v.value
				end
			end
		end
	end

	attribute.atk = (attribute.atk + evolve_atk_add) * evolve_atk_redio
	attribute.hp = (attribute.hp + evolve_hp_add) * evolve_hp_redio
	attribute.def = (attribute.def + evolve_def_add) * evolve_def_redio
	attribute.spd = (attribute.spd + evolve_spd_add) * evolve_spd_redio

	-- (基础值*rate/100+(当前等级-本阶对应初始等级)*基础值*grow/100)*max(IF(星級<7,1,(2^(0.01/((星級-6)*0.1+0.9))))^(等級-140)*1.015^(星級-7),1)*IF(星級<6,1,攻擊基礎值/100+攻擊參數*MAX(星級-5,1))
	-- (基础值*rate/100+(当前等级-本阶对应初始等级)*基础值*grow/100)*max(IF(星級<7,1,(2^(0.01/((星級-6)*0.1+0.9))))^(等級-140)*1.015^(星級-7),1)*IF(星級<6,1,生命基礎值/1000+生命參數*MAX(星級-5,1))


	-- (基础值*rate/100+(当前等级-本阶对应初始等级)*基础值*grow/100)*max(IF(星級<7,1,(2^(0.01/((星級-6)*0.1+0.9))))^(等級-140)*1.015^(星級-7),1)*IF(星級<6,1,攻擊基礎值/100+攻擊參數*MAX(星級-5,1)) + 攻击系数2 * (max(星级-10, 0))
	-- (基础值*rate/100+(当前等级-本阶对应初始等级)*基础值*grow/100)*max(IF(星級<7,1,(2^(0.01/((星級-6)*0.1+0.9))))^(等級-140)*1.015^(星級-7),1)*IF(星級<6,1,生命基礎值/1000+生命參數*MAX(星級-5,1))

	local score = 0
	for k,v in pairs(attribute) do
		for k1,v2 in pairs(cfg.scorecount.equip) do
			if k == v2.type then
				local ratio = v2.ratio / 10000
				score = score + math.floor(v * ratio)
			end
		end
	end

	-- 战斗力
	attribute.bat = math.floor(score) * 3

	return attribute
end

function HeroData:getHeroElemAdd(elem, star)
	star = star - 5
	local attribute = {}
	attribute.atk = 1
	attribute.hp = 1
	attribute.def = 1
	attribute.spd = 1

	local num = table.nums(cfg.herocoe.herocoe)
	for i=1,num do
		local config = cfg.herocoe.herocoe[i]
		if config.type == elem and star >= config.star then
			-- print("getHeroElemAdd", elem, config.star, star)
			attribute.atk = attribute.atk * tonumber(config.atk)
			attribute.hp = attribute.hp * tonumber(config.hp)
		end
	end
	return attribute
end

function HeroData:getHeroStageByLevel(level)
	local num = table.nums(cfg.heroupgrade.grade)
	local max_grade = 0
	for i=0,num-1 do
		local v = cfg.heroupgrade.grade[i]
		max_grade = v.grade
		if v.level >= level then
			return v.grade
		end
	end
	return max_grade
end

function HeroData:getHeroSkillList(hero_type)
	local hero_type_config = cfg.herotype.star[hero_type]
	if not hero_type_config then
		return {}
	end

	local vec_skill = {}

	for i = 1, 4 do
		if hero_type_config["skill_" .. i] ~= 0 then
			table.insert(vec_skill, hero_type_config["skill_" .. i])
		end
	end

	return vec_skill
end

function HeroData:getHeroSkill(hero_type, active_type)
	local hero_type_config = cfg.herotype.star[hero_type]
	if not hero_type_config then
		return 0
	end

	for i = 1, 5 do
		local skill_type = hero_type_config[string.format("skill_%d", i)]
		if skill_type and skill_type ~= 0 then
			local skill_config = cfg.heroskill.heroskill[skill_type]
			if skill_config and skill_config.active_type == active_type then
				return skill_type
			end
		end
	end

	return 0
end

function HeroData:getHeroSkillLevel(stage, star, skill_index, hero_type, evolve)
	if stage < star and star <= 5 then
		star = stage + 1
	end

	local skill_id
	if hero_type then
		local star_config = cfg.herotype.star[hero_type]
		skill_id = star_config[string.format("skill_%s", skill_index)]
		if not skill_id then
			return 0, false, nil
		end
	end
	
	local hero_star_config = cfg.herostar.star[star]
	if not hero_star_config then
		print("HeroData:getHeroSkillLevel", star, "not found")
		return 0, false, skill_id
	end

	-- 查看技能是否解锁，有些英雄只有前面几个技能，不满四个
	local config = cfg.heroupgrade.grade[stage]
	local disabled = config["skill" .. skill_index] == 0
	if disabled then
		-- dump(config, "config..")
		return 0, false, skill_id
	end

	local evolve_config
	if evolve and type(evolve.type) == "number" then
		evolve_config = cfg.heroevolvelevel.getEvolutionConfig(hero_type, evolve.level, evolve.type)
	end

	local level = hero_star_config[string.format("skill%d", skill_index)]
	local is_evolve_skill = false
	if evolve_config and evolve_config.skill_old_id == skill_id then
		level = evolve_config.skill_level
		is_evolve_skill = true
		skill_id = evolve_config.skill_id
	end

	if level then
		return level, is_evolve_skill, skill_id
	end

	return 0, is_evolve_skill, skill_id
end

function HeroData:getHeroSkillLevelWithStarView(stage, star, skill_index)
	if stage < star and star <= 5 then
		star = stage + 1
	end

	local hero_star_config = cfg.herostar.star[star]
	if not hero_star_config then
		print("HeroData:getHeroSkillLevel", star, "not found")
		return 0
	end

	local level = hero_star_config[string.format("skill%d", skill_index)]
	if level then
		return level
	end

	return 0
end

function HeroData:getHeroSkillLevelNeedStar(level, skill_index, hero_type)
	if level <= 1 then
		local type_config = cfg.herotype.star[hero_type]
		if type_config ~= nil then
			local grade_need = 100
			for i,v in ipairs(cfg.heroupgrade.grade) do
				if grade_need > v.grade and v["skill"..skill_index] > 0 then
					grade_need = v.grade
				end
			end
			if grade_need < 100 then
				return grade_need
			else
				print("HeroData:getHeroSkillLevelNeedStar cfg.heroupgrade.grade not found", hero_type, skill_index, level)
			end
		else
			print("HeroData:getHeroSkillLevelNeedStar cfg.herotype.star not found", hero_type, skill_index, level)
		end
	else
		local need_star = nil
		for i,v in ipairs(cfg.herostar.star) do
			if v["skill"..skill_index] == level then
				if need_star == nil or need_star > v.star then
					need_star = v.star
				end
			end
		end
		local type_config = cfg.herotype.star[hero_type]
		if type_config ~= nil and need_star ~= nil and need_star >= 5 then
			if string.len(tostring(type_config["to_"..need_star.."_star"])) > 0 then
				return need_star
			end
		end
	end
	return -1
end

function HeroData:getSkillName(skill_type, skill_level)
	skill_level = skill_level or 1
	local config = cfg.heroskill.getConfigByType(skill_type, skill_level)
	if config and config.lan_name then
		return ex.Tools:getLang(config.lan_name)
	end

	return "--"
end

function HeroData:getSkillDescription(skill_type, skill_level)
	local config = cfg.heroskill.getConfigByType(skill_type, skill_level)
	if config and config.lan_name then
		return ex.Tools:getLang(config.lan_describe)
	end

	return ex.Tools:getLang(47710)
end

-- add 熊梦 冷却时间提示
-- 一共就三种情况：
-- 无冷却时间
-- 第N回合释放，无冷却时间
-- 第N回合释放，冷却M回合
function HeroData:getSkillCoolingtime(skill_type, skill_level)
	local config = cfg.heroskill.getConfigByType(skill_type, skill_level)
	if config then
		if config.initial_round ==  0 then
			return ex.Tools:getLang(41336)
		else
			if config.cool_round ==  0 then
				return string.format( ex.Tools:getLang(41338) , config.initial_round) 
			else	
				return string.format( ex.Tools:getLang(41337) , config.initial_round , config.cool_round) 
			end
		end
	end

	return ""
end


function HeroData:getHeroSkillUpgrade(pre_star, now_star, stage, hero_type, evolve)
	local vec_level = {}

	for i = 1, 4 do
		local pre_level, is_pre_evolve_skill = self:getHeroSkillLevel(stage, pre_star, i, hero_type, evolve)
		local now_level, is_now_evolve_skill = self:getHeroSkillLevel(stage, now_star, i, hero_type, evolve)

		if pre_level and now_level and pre_level ~= now_level then
			local data = {}
			data.index = i
			data.pre_level = pre_level
			data.now_level = now_level
			data.is_pre_evolve_skill = is_pre_evolve_skill
			data.is_now_evolve_skill = is_now_evolve_skill
			table.insert(vec_level, data)
		end
	end
	return vec_level
end

function HeroData:changeHeroTalent(hero_id, talent)
	for k,v in pairs(self.hero_list) do
		if v.hero_id == hero_id then
			v.talents = v.talents or {}

			if talent.skill_id == 0 then
				-- 遗忘天赋
				local pos = 0
				for i = 1, #v.talents do
					if v.talents[i].slot == talent.slot then
						pos = i
						break
					end
				end
				if pos ~= 0 then
					table.remove(v.talents, pos)
				else
					printError("hero:"..tostring(v.hero_id).." not exist talent for slot:"..tostring(talent.slot))
				end
			else
				local is_exist = false
				for i = 1, #v.talents do
					if v.talents[i].slot == talent.slot then
						-- 现有数据存在，则更新
						v.talents[i].skill_id = talent.skill_id
						v.talents[i].level = talent.level
						is_exist = true
						break
					end
				end

				if not is_exist then
					-- 现有数据不存在，则新增
					local talent_data = {}
					talent_data.slot = talent.slot
					talent_data.skill_id = talent.skill_id
					talent_data.level = talent.level

					table.insert(v.talents, talent_data)
				end
			end

			ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UPDATE_TALENT)
			ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATE_REDDOT)
			ex.EventManager:fire(EVENT.HERO_INFO_EVENT.HERO_UP_LEVEL)

			return
		end
	end

	printError("hero:"..tostring(v.hero_id).." not exist")
end

function HeroData:getTalentListByLevel(level)
	local list = {}

	for k,v in pairs(cfg.talent.talent) do
		if v.level == level then
			table.insert(list, v)
		end
	end
	return list
end

function HeroData:getTalentByIDAndSlot(hero_id, slot)
	for k, v in pairs(self.hero_list) do
		if v.hero_id == hero_id and v.talents then
			for i = 1, #v.talents do
				if slot == v.talents[i].slot then
					return v.talents[i]
				end
			end

			break
		end
	end
	return nil
end

function HeroData:isTalentStudy(hero_id, skill_type)
	local hero_data = self:getHeroDataById(hero_id)
	if hero_data then
		for k,v in pairs(hero_data.talents) do
			if v.skill_id == skill_type then
				return true
			end
		end
	end
	return false
end

function HeroData:sortAllHero()
	local hero_list = self:getHeroByElem(ElemType.ALL)
    local promote = self.promote
    local function sor(a,b)
        local battle_a = promote:heroIsBattle(a.hero_id) and 1 or 0
        local battle_b = promote:heroIsBattle(b.hero_id) and 1 or 0

        if battle_a ~= battle_b then  return battle_a > battle_b  end

        if a.star ~= b.star then return a.star > b.star end
        if a.level ~= b.level then return a.level > b.level end
        return a.hero_type > b.hero_type
    end
    table.sort(hero_list,sor)
    return hero_list
end

function HeroData:isTalentUplevel(hero_id, slot, if_conflict)
	local hero_data = self:getHeroDataById(hero_id)
	if not hero_data then
		return false
	end

	-- 判断属性是否足够
	local is_open = hero_data.star >= cfg.system.getTalentSlotOpenStar(slot)
	if is_open == false then
		return false
	end

	-- 取出当前数据
	local talents = nil
	local getTalents = function(slot)
		for i = 1, #hero_data.talents do
			if slot == hero_data.talents[i].slot then
				return hero_data.talents[i]
			end
		end
		return nil
	end
	talents = getTalents(slot)


	if not talents then
		talents = {skill_id = 0, level = 0}
	end

	-- 取出冲突类型
	local conflict_type = nil
	if if_conflict then
		local other_talents = getTalents(slot == 1 and 2 or 1)
		if other_talents then
			conflict_type = other_talents.skill_id
		end
	end

	-- 0级可以匹配任意1级天赋，1级只能匹配对应技能天赋
	if talents.skill_id == 0 then
		for i,v in ipairs(cfg.talent.talent) do
			if v.level == talents.level + 1 and (conflict_type == nil or conflict_type ~= v.skill_type) then
				local comp_num = 0
				for i,vi in ipairs(v.upgrade_need) do
					if ex.Player:getItemNum(vi.item_type) >= vi.item_num then
						comp_num = comp_num + 1
					end
				end

				if comp_num >= table.nums(v.upgrade_need) then
					return true
				end
			end
		end
	else
		for i,v in ipairs(cfg.talent.talent) do
			if talents.skill_id == v.skill_type and talents.level + 1 == v.level then

				local comp_num = 0
				for i,vi in ipairs(v.upgrade_need) do
					if ex.Player:getItemNum(vi.item_type) >= vi.item_num then
						comp_num = comp_num + 1
					end
				end

				return comp_num >= table.nums(v.upgrade_need)
			end
		end
	end

	return false
end

function HeroData:isTalentItemStudy(hero_id, item_type)
	local list = self:getTalentListByLevel(1)
	for i,v in ipairs(list) do
		if v.upgrade_need[1].item_type == item_type then
			return self:isTalentStudy(hero_id, v.skill_type)
		end
	end
	return false
end

function HeroData:isCanHeroPalaceRewawrd(type,sever)
	-- 判断是否可以领取 -1:不可领取；0：可领取；1：已领取
	local hero_palace_data = nil
	for k,v in pairs(ex.Player.hero_data.hero_palace_list) do
        if v.type == type then
            local table_data = {}
            table_data.is_reward = v.is_reward
            table_data.is_worship = v.is_worship
            for j,n in pairs(v.server_rank_role) do
                if n.server_id == sever then
                    table_data.rank_role = n.rank_role
                    hero_palace_data = table_data
                    break
                end
            end
			break
		end
    end
	if hero_palace_data == nil then 
		return -1
	elseif hero_palace_data.is_reward == true then
		return 1
	end

	for k,v in pairs(cfg.heropalace.heropalace) do
		if v.type == type then
			if hero_palace_data.rank_role[v.rank] ~= nil and 
				hero_palace_data.rank_role[v.rank].player_id == ex.Player.role_id then
			
				return 0
			end
		end
	end

	return -1
end

function HeroData:isCanHeroPalaceWorship(type,sever)
	-- 判断是否可以领取 -1:不可膜拜；0：可膜拜；1：已膜拜
	local hero_palace_data = nil
	for k,v in pairs(ex.Player.hero_data.hero_palace_list) do
        if v.type == type then
            local table_data = {}
            table_data.is_reward = v.is_reward
            table_data.is_worship = v.is_worship
            for j,n in pairs(v.server_rank_role) do
                if n.server_id == sever then
                    table_data.rank_role = n.rank_role
                    hero_palace_data = table_data
                    break
                end
            end
			break
		end
    end
	if hero_palace_data == nil or hero_palace_data.rank_role == nil or table.nums(hero_palace_data.rank_role) <= 0 then 
		return -1
	elseif hero_palace_data.is_worship == true then
		return 1
	end

	return 0
end

-- add 熊梦 判断荣耀殿堂的大厅的红点
function HeroData:updateHeroPalacehallReddot(sever)
	local isVisible = false

	if ex.Player.level >= cfg.opencondition.condition["main_hero_palace"].condition_value then
		for k,v in ipairs(ex.Player.hero_data.hero_palace_list) do
			for j,n in ipairs(v.server_rank_role) do
				local is_can_reward = self:isCanHeroPalaceRewawrd(v.type,n.server_id) == 0
				local is_can_worship = self:isCanHeroPalaceWorship(v.type,n.server_id) == 0
				if is_can_reward or is_can_worship then
					isVisible = true
					break
				end
			end
			if isVisible then
				break
			end
		end
	end

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YXDT, isVisible)
end

function HeroData:updateHeroPalaceReddot(sever)
	if not ex.JumpManager:checkOpenConditionByAtomNoMsg("main_hero_palace") then
		return
	end

	local vec_reddot_type = {}
	table.insert(vec_reddot_type, RedDotType.ZCJ_DHZC_YXDT_HYS)
	table.insert(vec_reddot_type, RedDotType.ZCJ_DHZC_YXDT_SYS)
	table.insert(vec_reddot_type, RedDotType.ZCJ_DHZC_YXDT_MYS)
	table.insert(vec_reddot_type, RedDotType.ZCJ_DHZC_YXDT_GYS)
	table.insert(vec_reddot_type, RedDotType.ZCJ_DHZC_YXDT_AYS)
	table.insert(vec_reddot_type, RedDotType.ZCJ_DHZC_YXDT_SYYS)
	for i=1,6 do
		local is_can_reward = self:isCanHeroPalaceRewawrd(i,sever) == 0
		local is_can_worship = self:isCanHeroPalaceWorship(i,sever) == 0
		
		ex.RedDotManager:setRedNodeVisible(vec_reddot_type[i], is_can_reward or is_can_worship)
	end
end

function HeroData:getHeroByStar(star)
	local data = {}
	for i,v in ipairs(self.hero_list) do
		if v.star == star then 
			table.insert(data,v)
		end
	end

	return data
end

function HeroData:getHerosByStarAndCondition(star, condition)
    local data = {}
    for i, v in ipairs(self.hero_list) do
		if condition == ">" then
			if v.star > star then
            	table.insert(data, v)
			end
		elseif condition == "<" then
			if v.star < star then
            	table.insert(data, v)
			end
		elseif condition == ">=" then
			if v.star >= star then
            	table.insert(data, v)
			end
		elseif condition == "<=" then
			if v.star <= star then
            	table.insert(data, v)
			end
		else
			if v.star == star then
            	table.insert(data, v)
			end
		end
    end

    return data
end

-- 获取某类型英雄进化图鉴数据列表
function HeroData:getEvolveIllustratByElem(elem)
	return self.evolve_illustrat_cfg[elem]
end

function HeroData:checkHeroIsLock(hero_id)
    local hero_data = self:getHeroDataById(hero_id)
    if not hero_data then return false end 

    local is_battle = self.promote:checkHeroIsBattle(hero_id) 
    local is_magic_cube = self.magicCube:isCubeHero(hero_id)
    return is_battle == true or is_magic_cube == true 
end

function HeroData:setHeroResetNum(data)
	self.hero_reset_num = tonumber(data.times) 
	ex.EventManager:fire(EVENT.HERO_INFO_EVENT.UPDATA_HREO_RESET_NUM)
end

--------------英雄永久皮肤----------------
function HeroData:setheroSkinList(data)
	self.hero_skin_list = data.skins
	ex.EventManager:fire(EVENT.HERO_SKIN.UPADTE_HERO_SKIN_SHOP)
end

function HeroData:isOpenHeroSkinShop(isNotShowTips)
	--isNotShowTips 为真不弹提示，为假弹出提示
	local need_level = cfg.opencondition.condition["hero_skin_shop"].condition_value
    local day = cc.exports.GetAfterDaysForTime(ex.Player.server_create_time)
    local need_day = cfg.system.open_skin_store_days
    if ex.Player.level < need_level and day < need_day then 
		if not isNotShowTips then
        	ex.MessageView:add(string.format( ex.Tools:getLang(79003), need_day, need_level))
		end
        return false
    elseif ex.Player.level < need_level then
		if not isNotShowTips then
        	ex.MessageView:add(string.format( ex.Tools:getLang(79004), need_level))
		end
        return false
    elseif day < need_day then
		if not isNotShowTips then
        	ex.MessageView:add(string.format( ex.Tools:getLang(79005), need_day))
		end
        return false
	end
	return true
end

----------------------------------英雄重生------------------------
function HeroData:isShowReset(data)
	local is_open = false
	if data.star < cfg.system.hero_level_reset_limit then
		if data.level > 1 then
			is_open = true
		end
	else
		for i,v in ipairs(cfg.heroreborn.heroreborn) do
			if v.star == data.star then
				is_open = true
				break
			end			
		end
	end
	return is_open
end


return HeroData
