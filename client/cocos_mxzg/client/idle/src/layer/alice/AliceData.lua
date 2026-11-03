-- 讨伐团数据
local AliceData = class("AliceData")

function AliceData:ctor()
    self.star = 5           -- 星级
    self.cut_star = nil     --临时星级
    self.star_data = nil    -- 所有的星级数据
    self.rank_data = nil    -- 排行榜数据
    self.rank_top_data = nil-- 排行榜大神数据
    self.fight = 0          -- 英雄战力
    -- self.skill_point = 0    -- 英雄技能点
    self.enemy_attr = {}    -- 敌人增加的属性
    self.assist_hero_data = {}  --助战英雄
    self.battle_list  = {}   -- 上阵的英雄
    self.battle_list[1] = {}
    self.battle_list[2] = {}
    self.battle_list[3] = {}

    self.iswin = {}     --每回合战斗的胜负

    self.unicorn_list = {}  -- 独角兽数据列表

    self.end_time = nil     --结束时间
    self.stage = 0          --玩法开放状态
end

function AliceData:isOpen()
    return true
end

--设置初始化的星级
function AliceData:setStar(curr_star)
    if self.star_data then 

        -- --改关卡是否重置
        -- local function isreseted(star)
        --     for i,v in ipairs(self.star_data) do
        --         if star == v.satr and v.had_first then
        --             for i,level_info in ipairs(v.level_info) do
        --                 if not level_info.kill then
        --                    return true
        --                 end
        --             end
        --         end
        --     end
        -- end
        -- local function isfirst(star)
        --     for i,v in ipairs(self.star_data) do
        --         if star == v.satr and v.had_first then
        --             return true
        --         end
        --     end
        --     return false
        -- end
        
        if curr_star then
            if  curr_star ~= self.cut_star then
                curr_star = self.cut_star
            end
            for i,v in ipairs(self.star_data) do
                if v.star == curr_star then
                    for i,level_info in ipairs(v.level_info) do
                        if not level_info.kill then
                            self.star = v.star  
                            return
                        end
                    end
                end
            end
        end

        --没有全部通过拿最高星级
        for i,v in ipairs(self.star_data) do
            if not v.had_first then
               self.star = v.star  
                return
            end
        end  

        if self.cut_star == nil then
            self.star = self.star_data[#self.star_data].star
        else
            self.star = self.cut_star
        end         
    end
end

--获取最大层数的星级
function AliceData:getMaxStar()
    local max_star = 5
    for k,v in pairs(cfg.alicestarreward.alicestarreward) do
        if v.star > max_star then
            max_star = v.star
        end
    end
    return max_star
end

--获取最小层数的星级
function AliceData:getMinimumStar()
    local minimum_star = 5
    for k,v in pairs(cfg.alicestarreward.alicestarreward) do
        if v.star < minimum_star then
            minimum_star = v.star
        end
    end
    return minimum_star
end

--获取当前的星级的数据
function AliceData:getNowStarData()
    if self.star_data then
        for i,v in ipairs(self.star_data) do
            if  self.star == v.star then
                return clone(v)
            end
        end  
    end
    return nil
end

--获取当前星级表中的数据
function AliceData:getNowStarCongigData()
    local config_data = cfg.alicelevel.alicelevel
    local now_level_data = {}
    for i,v in ipairs(config_data) do
        if self.star == v.star then
            table.insert( now_level_data,v.elem, v)
        end
    end
    return now_level_data
end

--获取指定关卡数据
function AliceData:getLevelDataByTag(tag)
    local now_level_data = self:getNowStarCongigData()
    for i,v in ipairs(self:getNowStarData().level_info) do
        for i,now_level_data in ipairs(now_level_data) do
            if tag == now_level_data.elem and v.level == now_level_data.idx then
                return v
            end
        end
        -- if tag == i then
        --     return v
        -- end
    end
end

--获取该城池是否已击杀 true:已击杀 false:未击杀
function AliceData:getCityStage(tag)
    --now_level_data 策划表中的数据
    local now_level_data = self:getNowStarCongigData()
    --now_star_data 后端数据
    local now_star_data = self:getNowStarData()
    for k,v in pairs(now_star_data.level_info) do 
        for i,level_data in ipairs(now_level_data) do
            if level_data.idx == k and level_data.elem == tag then
                if v.kill then
                    return true
                end
            end

        end
    end
    return false
end

--获取当前关卡的怪物阵容
function AliceData:getMonsterLineup(level_tag)
    --英雄列表，战斗力
    --获取阵容数量
    --获取阵容对应的id
    --获取对应ID所对应的英雄

    local monster_all_list = {}
    local now_level_data = self:getNowStarCongigData()
  
    local monster_line_up_data = self:getLevelDataByTag(level_tag)
    local monster_data = cfg.alicemonster.alicemonster
    -- local Max_lineup_num = #monster_line_up_data.line_up
    for i,v in ipairs(monster_line_up_data.line_up) do
        local monster_list = {}
        monster_list.heros = {}
        for k,monster_data in ipairs(monster_data) do
            if v == monster_data.line_up then
                table.insert( monster_list.heros, monster_data )
            end
        end 
        monster_list.fighting = now_level_data[level_tag].fighting
        monster_list.lang_id = 580050 + i
        table.insert( monster_all_list, monster_list )
        
    end
   return monster_all_list
end

--获取当前层是否可以重置  有通关的关卡或者助阵的英雄可以重置
function AliceData:getLevelIsReset()
    local now_star_data = self:getNowStarData()
    local level_stage = {} 
    if now_star_data.assist_idx ~= 0 then
        return true
    end
    for k,v in pairs(now_star_data.level_info) do 
        if v.kill then
            return true
        end
        -- table.insert( level_stage, v.kill )
    end
    return false
end

--获取助陣对应元素的英雄
function AliceData:getHeroAssistList(elem)
    local hero_list = {}
    for i,v in pairs(cfg.herobase.herobase) do
        if v.star == self.star then
            table.insert( hero_list,v.type, v )
        end
    end
    local hero_elem_list = {}
    if elem ~= 0 then
        for i,v in ipairs(cfg.aliceplayerhero.aliceplayerhero) do
           local hero_elem = cfg.herotype.star[ v.hero_type].elem
            if elem == hero_elem and v.hero_star == self.star then
                local hero_data = {}
                hero_data.idx = v.idx
                hero_data.hero_id = v.hero_id or 0
                hero_data.hero_type = v.hero_type
                hero_data.elem = v.elem or cfg.herotype.star[ v.hero_type].elem
                hero_data.level = v.hero_level
                hero_data.star = v.hero_star
                hero_data.stage = v.stage
                hero_data.hp = hero_list[v.hero_type].hp
                hero_data.spd = hero_list[v.hero_type].spd
                hero_data.atk = hero_list[v.hero_type].atk
                hero_data.def = hero_list[v.hero_type].def
                table.insert( hero_elem_list, hero_data )
            end
        end
    else
        for i,v in ipairs(cfg.aliceplayerhero.aliceplayerhero) do
            if v.hero_star == self.star then
                local hero_data = {}
                hero_data.idx = v.idx
                hero_data.hero_id = v.hero_id or 0
                hero_data.hero_type = v.hero_type
                hero_data.elem = v.elem or cfg.herotype.star[ v.hero_type].elem
                hero_data.level = v.hero_level
                hero_data.star = v.hero_star
                hero_data.stage = v.stage
                hero_data.hp = hero_list[v.hero_type].hp
                hero_data.spd = hero_list[v.hero_type].spd
                hero_data.atk = hero_list[v.hero_type].atk
                hero_data.def = hero_list[v.hero_type].def
                table.insert( hero_elem_list, hero_data )
            end
        end
    end
    function sort_list(a,b)
        return a.idx < b.idx
    end
    table.sort( hero_elem_list, sort_list )
    return hero_elem_list
end

--获取玩家可以上阵的英雄
function AliceData:getPlayHero(elem)
    local line_up_list = {}
    if elem ~=0 then
        for i,v in ipairs(ex.Player.hero_data.hero_list) do
            if v.star <= self.star and v.elem == elem then
                table.insert( line_up_list, v )
            end
        end
    else
        for i,v in ipairs(ex.Player.hero_data.hero_list) do
            if v.star <= self.star then
                table.insert( line_up_list, v )
            end
        end
    end
    return line_up_list
end

--通过星级获取可以上阵的队伍数量
function AliceData:getLineupNumByStar()
    for i,v in ipairs(cfg.alicelevel.alicelevel) do
        if v.star == self.star then
            return v.line_up_num
        end
    end
end

--更新敌人的属性
function AliceData:setEnemyAttr(enemy_attr)
    for i,v in ipairs(self.star_data) do
        if v.star == self.star then
            v.enemy_attr = enemy_attr
        end
    end
end
--获取敌人属性
function AliceData:getEnemyAttr()
   
    local enemy_attr = {}
    for i,v in ipairs(self.star_data) do
        if v.star == self.star then
            enemy_attr = v.enemy_attr 
        end
    end
    -- if #enemy_attr <= 1 then
    --     return nil
    -- end
    local enemy_attr_list = {}
    for i,v in ipairs(cfg.aliceenemyattr.aliceenemyattr) do
        if v.type ~= 1 then
            for i,enemy_attr_idx in ipairs(enemy_attr) do
                if enemy_attr_idx == v.idx then
                    table.insert( enemy_attr_list, v.add_attr[1] )
                end
            end
        end
    end
    return enemy_attr_list
end

--设置助战英雄属性
function AliceData:setAssitData(star, idx)

    local star = star
    local idx = idx
    if not star then     
        for i,v in ipairs(self.star_data) do
            if v.star == self.star then
                idx = v.assist_idx
                star = v.star
            end
        end
    end


    local hero_data = {}
    for i,v in pairs(cfg.herobase.herobase) do
        if v.star == star then
            table.insert( hero_data,v.type, v )
        end
    end

    if idx ~= 0 then
        for i,v in ipairs(cfg.aliceplayerhero.aliceplayerhero) do
            if v.hero_star == star and v.idx ==idx then
                self.assist_hero_data.hero_id = 10
                self.assist_hero_data.idx = idx
                self.assist_hero_data.hp = hero_data[v.hero_type].hp
                self.assist_hero_data.elem = cfg.herotype.star[v.hero_type].elem
                self.assist_hero_data.is_lock = false
                self.assist_hero_data.star = star
                self.assist_hero_data.spd = hero_data[v.hero_type].spd
                self.assist_hero_data.tweak_cube_stage = 0
                self.assist_hero_data.fighting = 0
                self.assist_hero_data.level = v.hero_level
                self.assist_hero_data.stage = v.stage
                self.assist_hero_data.atk = hero_data[v.hero_type].atk
                self.assist_hero_data.occupation = 0 
                self.assist_hero_data.hero_type = v.hero_type
                self.assist_hero_data.tweak_cube_lv = 0
                self.assist_hero_data.def = hero_data[v.hero_type].def
            end
        end
    else
        self.assist_hero_data = {}
    end
end

--是否全部首通
function AliceData:getIsAllFirstPass()
    for i,v in ipairs(self.star_data) do
        if not v.had_first then  
            return false
        end
    end  
    return true
end

--判断当层是否首通
function AliceData:getIsFirstPass()
    for i,v in ipairs(self.star_data) do
        if v.star == self.star and v.had_first then
            return false
        end
    end
end

function AliceData:setBattleHero(type, vec_hero)
    self.battle_list[type] = {}
    for k,v in pairs(vec_hero) do
		if v.hero_id ~= 0 and v.position ~= 9 then 
            self.battle_list[type][v.hero_id] = true
		end
	end

    -- self.battle_list[type][hero_id] = true
end

function AliceData:heroIsBattle(hero_id,type)
    local new_battle_list = {}
   local type = self:getLineupNumByStar()
   for i=1,type do
    table.insert( new_battle_list, self.battle_list[i] )
   end
  
   for i,v in ipairs(new_battle_list) do
        for k,_ in pairs(v) do
            if k == hero_id then
                return true
            end
        end
   end
   return false
end

--获取当前的星级的技能点
function AliceData:getSkillPoint()
    for i,v in ipairs(self.star_data) do
        if v.star == self.star then
            return v.skill_point
        end
    end
end

--获取当前星级的增益buff
function AliceData:getSkillBuff()
    for i,v in ipairs(self.star_data) do
        if v.star == self.star then
            return v.player_attr
        end
    end
end

function AliceData:checkAliceRed()
    for i,v in ipairs(self.star_data) do
        local buff_point = clone( v.skill_point)
        for idx,attr_idx in ipairs(v.player_attr) do
            local config = cfg.aliceplayerattr.aliceplayerattr[attr_idx]
            buff_point = buff_point - config.cost_point
            if  buff_point > 6 then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ALSXJ, true)
                return true
            end 
        end
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_ALSXJ, true)
    return false
end

--获取当前的星级剩余的技能点
function AliceData:getSurplusSkillPoint()
    local buff_point = clone(self:getSkillPoint())
    local all_select_buf = clone(self:getSkillBuff())
	for idx,attr_idx in ipairs(all_select_buf) do
		local config = cfg.aliceplayerattr.aliceplayerattr[attr_idx]
		buff_point = buff_point - config.cost_point
	end
    if  buff_point >= 6 then
        return true
    else
        return false
    end 
end

function AliceData:getRound(round)
   
    local new_is_win = {}
    for i=1,round do
        table.insert( new_is_win, self.iswin[i] )
    end
    return new_is_win
    
end
----------------------------------独角兽数据----------------------------------------

-- 获取独角兽数据
function AliceData:getUnicornDataByHeroId(hero_id)
    for _,unicorn_data in ipairs(self.unicorn_list) do
        if unicorn_data.hero_id == hero_id then
            return unicorn_data
        end
    end

    return nil
end

-- 独角兽洗练完成
function AliceData:unicornWashDone(hero_id, attr_list)
    for _,unicorn_data in ipairs(self.unicorn_list) do
        if unicorn_data.hero_id == hero_id then
            unicorn_data.wash_rare_attr = attr_list
            return
        end
    end
end

-- 独角兽洗练保存完成
function AliceData:unicornWashSaveDone(hero_id)
    for _,unicorn_data in ipairs(self.unicorn_list) do
        if unicorn_data.hero_id == hero_id then
            unicorn_data.rare_attr = unicorn_data.wash_rare_attr
            unicorn_data.wash_rare_attr = {}
            return
        end
    end
end

-- 独角兽重置完成
function AliceData:unicornResetDone(data)
    for i,unicorn_data in ipairs(self.unicorn_list) do
        if unicorn_data.hero_id == data.hero_id then
            self.unicorn_list[i] = data
            return
        end
    end
end

-- 独角兽强化完成
function AliceData:unicornStrenthenDone(hero_id, level)
    for _,unicorn_data in ipairs(self.unicorn_list) do
        if unicorn_data.hero_id == hero_id then
            unicorn_data.strengthen_lv = level
            return
        end
    end
end

-- 独角兽突破完成
function AliceData:unicornUpgradeDone(data)
    for i,unicorn_data in ipairs(self.unicorn_list) do
        if unicorn_data.hero_id == data.hero_id then
            self.unicorn_list[i] = data
            return
        end
    end
end

-- 檢查独角兽紅點
function AliceData:checkNobilityReddot(hero_id, occupation)

    local red_point_stage = -1
    local grade = 0
    local level = 0
    for i,unicorn_data in ipairs(self.unicorn_list) do
        if unicorn_data.hero_id == hero_id then
            grade = unicorn_data.grade
            level = unicorn_data.strengthen_lv
            break
        end
    end

    local grade_need = ex.Tools:getSysCfg("alice_unicorn_wash_open_grade")
    --是否可以洗练
    if grade >= grade_need then
        local config = cfg.aliceunicornwash.aliceunicornwash[0]
        local wash_need =  config.cost[1].item_num
        if ex.Player:getItemNum(config.cost[1].item_type) >= wash_need then
            red_point_stage = 0
        end  
    else
        --是否可以突破
        local config_level_next = cfg.aliceunicornstrengthen.getConfig(occupation, grade, level + 1)
        if config_level_next then
            local config_level = cfg.aliceunicornstrengthen.getConfig(occupation, grade, level + 1)
            local up_level_need_1 = ex.Player:getItemNum(config_level.up_cost[1].item_type) >= config_level.up_cost[1].item_num
            local up_level_need_2 = ex.Player:getItemNum(config_level.up_cost[2].item_type) >= config_level.up_cost[2].item_num
            if config_level ~= nil and #config_level.up_cost > 0 then
                if up_level_need_1 and up_level_need_2 then
                    red_point_stage = 1
                end
            end     
        else
            local config_grade = cfg.aliceunicornstrengthen.getConfig(occupation, grade + 1, 0)
            local up_grade_need_1 = ex.Player:getItemNum(config_grade.up_cost[1].item_type) >= config_grade.up_cost[1].item_num
            local up_grade_need_2 = ex.Player:getItemNum(config_grade.up_cost[2].item_type) >= config_grade.up_cost[2].item_num
            if config_grade ~= nil and #config_grade.up_cost > 0 then
                if up_grade_need_1 and up_grade_need_2 then
                    red_point_stage = 1
                end
            end
        end
    end

    return red_point_stage
    
end

return AliceData
