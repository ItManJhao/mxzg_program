--[[
    func: 国战 - 数据层
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarData = class("CountryWarData")

local Faction = {
    FACTION_1 = 1,
    FACTION_2 = 2,
    FACTION_3 = 4,
    FACTION_4 = 8,
    FACTION_UNION = 16, --联合阵营
}

function CountryWarData:ctor()
    self.stage = COUNTRY_WAR_STATE.NONE          -- 当前阶段   COUNTRY_WAR_STATE
    self.start_time = 0                          -- 当前阶段开始时间
    self.next_stage_time = 0                     -- 下一个阶段时间
    self.had_join = false                        -- 是否参赛
    self.round = 1                               -- 赛季
    self.type = 1                                -- 赛季主题
    self.main_server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id", -1) -- 主服id
    self.curr_id = 0                             -- 用户当前所在城市
    self.choice_idx = 0                          -- 选择城市的idx
    self.cities = {}                             -- 地图城池数据
    self.servers = {}                            -- 服务器阵营数据
    self.small_cities = {}                       -- 城内数据（每次请求都改变）
    self.occupy_time = 0                         -- 单个城市占领时间（每次请求都改变）
    self.attack_add_time = 0                     -- 攻城令获取时间
    self.move_add_time = 0                       -- 迁移令获取时间
    self.had_reward = false                      -- 是否有奖励可以获取
    self.attack_item_num = 0                     -- 攻击令数量
    self.move_item_num = 0                       -- 迁移令数量
    self.lottery_round = 1                       -- 抽奖轮次   
    self.task_round = 1                          -- 任务轮次 
end

-- 获取当前阶段 
function CountryWarData:getStage() return self.stage end
-- 获取当前赛季
function CountryWarData:getRound() return self.round end
-- 获取当前赛季主题
function CountryWarData:getType() return self.type end
-- 获得是否参赛
function CountryWarData:getHadjoin() return self.had_join end
-- 获得主服id
function CountryWarData:getMainServer() return self.main_server_id end
-- 获取当前所在城市位置
function CountryWarData:getCurrId() return self.curr_id end
-- 获取选择的城市位置
function CountryWarData:getChoiceidx() return self.choice_idx end
-- 是否有奖励可以领取
function CountryWarData:getHadReward() return self.had_reward end
-- 获得攻城令数量
function CountryWarData:getAttackNum() return self.attack_item_num end
-- 获得迁移令数量
function CountryWarData:getMoveNum() return self.move_item_num end
-- 获得攻城令道具Type
function CountryWarData:getAttackItemType() 
    if cfg.countrywarcity.countrywarcity == nil or cfg.countrywarcity == nil then
        print("cfg.countrywarcity is not")
        return
    end
    for k,v in pairs(cfg.countrywarcity.countrywarcity) do
        return v.item_cost.attack_item
    end
end
-- 获得迁移令道具Type
function CountryWarData:getMoveItemType() 
    if cfg.countrywarcity.countrywarcity == nil or cfg.countrywarcity == nil then
        print("cfg.countrywarcity is not")
        return
    end
    for k,v in pairs(cfg.countrywarcity.countrywarcity) do
        return v.item_cost.move_item
    end
end

-- 设置当前选择的城市
function CountryWarData:setChoiceidx(idx) 
    -- 验证位置的合法性
    local isbool = false
    for k,v in pairs(cfg.countrywarcityrelation.countrywarcityrelation) do
        if v.city_id == idx then
            isbool = true
            break
        end
    end
    if not isbool then
        print("isetChoiceidx dx 不合法",idx)
        return
    end
    self.choice_idx = idx
end

-- 设置当前所在城市位置
function CountryWarData:setCurrId(idx) 
    -- 验证位置的合法性
    local isbool = false
    for k,v in pairs(cfg.countrywarcityrelation.countrywarcityrelation) do
        if v.city_id == idx then
            isbool = true
            break
        end
    end
    if not isbool then
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
        print("setCurrId idx 不合法",idx)
        return
    end
    self.curr_id = idx
end

-- 设置道具时间
function CountryWarData:setItemTime(attack_add_time,move_add_time) 
    self.attack_add_time = attack_add_time       -- 攻城令获取时间
    self.move_add_time = move_add_time           -- 迁移令获取时间
end

-- 设置所有城市的信息
function CountryWarData:setCities(data)
    if data == nil or next(data) == nil then return end
    local data_temp = {}
    for k,v in pairs(data) do
        data_temp[v.idx] = v
    end
    self.cities = data_temp
end

-- 设置阵营数据
function CountryWarData:setServers(data)
    if data == nil or next(data) == nil then return end
    self.servers = data
end

-- 设置攻城令牌数量
function CountryWarData:setAttackNum(num)
    if num < 0 then return end
    self.attack_item_num = num
end

-- 设置迁移令数量
function CountryWarData:setMoveNum(num)
    if num < 0 then return end
    self.move_item_num = num
end

-- 设置是否可以领取奖励
function CountryWarData:setHadReward(isbool)
    self.had_reward = isbool ~= nil and isbool or false
    if ex.Player.level < cfg.opencondition.condition["main_country_war"].condition_value then
        self.had_reward = false
    end
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_GZ_LQJL, self.had_reward)
end

-- 获取全部大本营的城池数据 （不包括npc大本营）
function CountryWarData:getBigCities()
   if self.cities == nil then return end
   local table_temp = {}

   for i=1,4 do
        for k,v in pairs(cfg.countrywarcity.countrywarcity) do
            if v.type == 1 and v.camp == i then
                table.insert(table_temp, self.cities[k])
                break
            end
        end 
   end
    return table_temp
end

-- 获取自己的大本营信息
function CountryWarData:getMyBigCitis()
    for k,v in pairs(self.cities) do
        if v.server_id == self:getMainServer() and cfg.countrywarcity.countrywarcity[v.idx].type == 1 then
            return v
        end
    end
    return nil
end

-- 获取服务器的阵营
function CountryWarData:getCamp(server_id)
    if server_id == nil then return end
    for k,v in pairs(self.servers) do
        if v.server_id == server_id then
            return v.faction
        end
    end
    
    return {}
end

-- 判断城市是不是我们阵营的
function CountryWarData:isCityMy(city_id)
    if city_id == nil then return end
    return self.cities[city_id].server_id == self:getMainServer()
end

-- 判断城市是否为我的结盟
function CountryWarData:isCityFriend(city_id)
    if city_id == nil then return end
    if self.cities[city_id].server_id == 0 then return false end
    if #self:getCamp(self:getMainServer()) < 2 then return false end
    
    local camp = self:getCamp(self.cities[city_id].server_id)
    if #camp < 2 then 
        return false 
    end

    return true
end

-- 当前城池是否满员
function CountryWarData:isFull(city_id)
    if city_id == nil then return end
    return self.cities[city_id].defend_num >= cfg.countrywarcity.countrywarcity[city_id].accommodate_count
end

-- 刷新单个城市数据 大地图 Cities
function CountryWarData:UpdataCities(data)
    if data == nil or next(data) == nil then return end
    for k,v in pairs(data) do
        self.cities[v.idx] = v
    end
end

-- 时间是否开启
function CountryWarData:isOpen()
    return self:getHadjoin() and self.stage == COUNTRY_WAR_STATE.BATTLE 
end

-----------------------------------------------------排行榜----------------------------------------------------------
--获取排行榜数据
function CountryWarData:setRankInfo(data)
    self.country_war_rank_info = data  
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATE_RANK)
end

--type : 1积分，  2英雄，  3杀敌，   4伤害,  
function CountryWarData:getCountryWarRankInfo(type)
    local data_tabel = {}
    if self.country_war_rank_info ~= nil and self.country_war_rank_info.ranks ~= nil then  
        for i,v in pairs(self.country_war_rank_info.ranks) do
            local data_list = {}
            data_list.rank_type = self.country_war_rank_info.rank_type
            data_list.my = {}
            data_list.ranks = {}
            data_list.my.rank = self.country_war_rank_info.self.rank
            data_list.my.server_id = self.country_war_rank_info.self.server_id
        
            data_list.ranks.rank = v.rank
            data_list.ranks.server_id = v.server_id
            if type == 1 then
                data_list.my.score = self.country_war_rank_info.self.score
                data_list.my.hour_score = self.country_war_rank_info.self.hour_score   
                data_list.my.occupy_count = self.country_war_rank_info.self.occupy_count
                data_list.ranks.score = v.score
                data_list.ranks.hour_score = v.hour_score  
                data_list.ranks.occupy_count = v.occupy_count         
            elseif type == 2 then 
                data_list.my.name = self.country_war_rank_info.self.name
                data_list.my.occupy_count = self.country_war_rank_info.self.occupy_count
                data_list.ranks.occupy_count = v.occupy_count
                data_list.ranks.name = v.name
            elseif type == 3 then
                data_list.my.name = self.country_war_rank_info.self.name
                data_list.my.kill = self.country_war_rank_info.self.kill
                data_list.ranks.kill = v.kill
                data_list.ranks.name = v.name
            elseif type == 4 then
                data_list.my.name = self.country_war_rank_info.self.name
                data_list.my.damage = self.country_war_rank_info.self.damage
                data_list.ranks.damage = v.damage
                data_list.ranks.name = v.name
            end
            table.insert( data_tabel, data_list )      
        end
    end
    return data_tabel
end

--排行榜中我的排行
--type : 1积分，  2英雄，  3杀敌，   4伤害,  
function CountryWarData:getCountryWarRankMyInfo(type)
    local data_tabel = {}
    if self.country_war_rank_info ~= nil and self.country_war_rank_info.self ~= nil then  
            local data_list = {}
            data_list.rank_type = self.country_war_rank_info.rank_type
            data_list.my = {}
            data_list.my.rank = self.country_war_rank_info.self.rank
            data_list.my.server_id = self.country_war_rank_info.self.server_id
        
            if type == 1 then
                data_list.my.score = self.country_war_rank_info.self.score
                data_list.my.hour_score = self.country_war_rank_info.self.hour_score   
                data_list.my.occupy_count = self.country_war_rank_info.self.occupy_count       
            elseif type == 2 then 
                data_list.my.name = self.country_war_rank_info.self.name
                data_list.my.occupy_count = self.country_war_rank_info.self.occupy_count
            elseif type == 3 then
                data_list.my.name = self.country_war_rank_info.self.name
                data_list.my.kill = self.country_war_rank_info.self.kill
            elseif type == 4 then
                data_list.my.name = self.country_war_rank_info.self.name
                data_list.my.damage = self.country_war_rank_info.self.damage
            end
            table.insert( data_tabel, data_list )      
    end
    return data_tabel
end

--小地图中的排行榜
function CountryWarData:getSmallMapData()
    local server_rank = {}
    if self.country_war_rank_info ~= nil and self.country_war_rank_info.ranks ~= nil then
        for i,v in ipairs(self.country_war_rank_info.ranks) do
            local data = {}
            data.rank = v.rank
            data.server_id = v.server_id
            data.score = v.score
            data.hour_score = v.hour_score  
            data.occupy_count = v.occupy_count 
            table.insert(server_rank, data )
        end
        local sort = function ( a,b )
            return a.rank < b.rank
        end
        table.sort(server_rank, sort)
    end
    return server_rank
end

--------------------------------------------------大转盘抽奖------------------------------------------------------
--抽奖数据
function CountryWarData:setLotterData(data)
    self.lottery_data = data
    self:setLotterRed()
    ex.EventManager:fire(EVENT.COUNTRY_WAR.LOTTERY, data)
end

--抽奖轮次
function CountryWarData:setLotterRound(data)
    self.lottery_round = data.round
    ex.EventManager:fire(EVENT.COUNTRY_WAR.OPEN_BIG_TURNTABLE)  
end

--红点
function CountryWarData:setLotterRed()
    local isRed = false
    local cost_cfg = cfg.system.country_war_lottery_cost[1] 
    local isRed = ex.Player:getItemNum(cost_cfg.item_type) > 0 and true or false 

    if ex.Player.level < cfg.opencondition.condition["main_country_war"].condition_value then
        isRed = false
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_GZ_DZP, isRed)
end

--------------------------------------------------战旗任务 即 任务奖励------------------------------------------------------
--战旗任务数据
function CountryWarData:setTaskRewardData(data)
    self.task_reward_data = data
    self.get_reward_num = data.round_reward
    self.task_data = data.tasks
    self.task_round = data.round 
    if data.round < self:getMaxRound() then
        self.task_round = data.round + 1
    end  
    self:setTaskRewardRed()
    ex.EventManager:fire(EVENT.COUNTRY_WAR.OPEN_TASK_REWARD)
end

--领取战旗任务数据
function CountryWarData:setGetTaskRewardData(data)
    self.task_round = data.round 
    if data.round < self:getMaxRound() then
        self.task_round = data.round + 1
    end
    local data_list = {}
    data_list.task = {}
    table.insert(data_list.task, data.task)
    self:updateTaskRewardStatus(data_list)
    self:setTaskRewardRed()
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATA_TASK_REWARD)
end

--更新任务进度
function CountryWarData:setUpdateTaskRewardProgress(data)
    self:updateTaskRewardStatus(data)
    self:setTaskRewardRed()
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATA_TASK_REWARD)
    -- self:checkPromotion81RedDot()
end

--领取战旗轮次奖励 
function CountryWarData:setTaskRewardRoundGetData(data)
    self.get_reward_num = data.round_reward
    self:setTaskRewardRed()
end

--当前轮次任务是否有可领取
function CountryWarData:getTaskRewardRoundStatus()
    local round_task_status = {}
    for i,v in ipairs(cfg.countrywarflagmission.countrywarflagmission) do
        --确定轮次
        if self.task_data and v.round == self.task_round  then
            for j,k in ipairs(self.task_data) do
                if v.idx == k.idx and not k.reward and k.progress >= v.target.target then
                    return true
                end
            end
        end 
    end
    return false
end

--更新战旗任务状态
function CountryWarData:updateTaskRewardStatus(data)
    if data.task ~= nil and self.task_data ~= nil then
        for i,v in ipairs(data.task) do
            for j,k in ipairs(self.task_data) do
                if k.idx == v.idx then
                   k.reward = v.reward 
                   k.progress = v.progress 
                   break
                end 
            end 
        end
    end
end

--获取当前轮次任务完成的状态
function CountryWarData:getRoundTaskStatus(round)
    for i,v in ipairs(cfg.countrywarflagmission.countrywarflagmission) do
        if self.task_data and round == v.round then
            for j,k in ipairs(self.task_data) do
                if v.idx == k.idx and not k.reward then
                    return false
                end
            end
        end
    end
    return true
end

--获取最大轮次
function CountryWarData:getMaxRound()
    local max_round = 0
    for i,v in ipairs(cfg.countrywarflagmission.countrywarflagmission) do
        if max_round < v.round then
            max_round = v.round
        end
    end
    return max_round
end

--是否可以领取最终奖励
function CountryWarData:getTaskRewardEndReward()
    if self.get_reward_num == nil or #self.get_reward_num > 0 then return false end

    local max_round = self:getMaxRound()
    local round = self.task_round
    local bool = self:getRoundTaskStatus(max_round)
    if round >= max_round and bool then
        return true
    end
    
    return false
end

--战旗红点
function CountryWarData:setTaskRewardRed()
    local is_red = false
    if ex.Player.level >= cfg.opencondition.condition["main_country_war"].condition_value then
        if self:getTaskRewardEndReward() or self:getTaskRewardRoundStatus() then
            is_red = true
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_GZ_RWJL, is_red)
end

--------------------------------------------------积分奖励------------------------------------------------------
--积分成就
function CountryWarData:setScoreInfo(data)
    self.score_data = data
    local max = self:getMaxScore()
    if data.score >= max then
        self.score_data.score = max
    end
   self.score_buy_gem = data.buy_gem
   self.mystery_score_record = data.mystery_score_record
   self.score_record = data.score_record
   local task_data = {}
   for i,v in ipairs(data.tasks) do
       table.insert( task_data, v.task )
   end 
   self.all_score_tasks_data = self:newScoreTaskList(task_data)
   self:setScoreRed()
   ex.EventManager:fire(EVENT.COUNTRY_WAR.OPEN_SCORE_REWARD)
end

--领取积分任务
function CountryWarData:setScoreMissionGetInfo(data)
    self.score_data.score = data.score
    local max = self:getMaxScore()
    if data.score >= max then
        self.score_data.score = max
    end
    local data_list = {}
    data_list.task = {}
    table.insert(data_list.task, data.task)
    self:updateTaskStatus(data_list)
    self:setScoreRed()
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATE_SCORE_REWARD_TASK_AND_SCORE)
end

--更新积分任务
function CountryWarData:setScoreMissionUpdateInfo(data)
    self:updateTaskStatus(data)
    self:setScoreRed()
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATE_SCORE_REWARD_TASK)
end

--积分奖励领取
function CountryWarData:setScoreGetInfo(data)
    self.mystery_score_record = data.mystery_score_record
    self.score_record = data.score_record
    self:setScoreRed()
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATE_SCORE_REWARD_LAYER)
end

--购买积分礼包
function CountryWarData:setScoreBuyGem(data)
    self.score_buy_gem = data.buy_gem
    self:setScoreRed()
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATE_BUY_GIFT)
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATE_SCORE_REWARD_TASK_AND_SCORE)
end 

--积分变动
function CountryWarData:setScoreNum(data)
    self.score_data.score = data.score
    local max = self:getMaxScore()
    if data.score >= max then
        self.score_data.score = max
    end
    self:setScoreRed()
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATE_SCORE_REWARD_TASK_AND_SCORE)
end 

--重组积分任务数据
function CountryWarData:newScoreTaskList(list)
    local all_score_tasks_data = {}
   for i,v in ipairs(list) do
        for j,k in ipairs(v) do
            table.insert( all_score_tasks_data, k )
        end  
   end
    return all_score_tasks_data
end

--获取积分任务
function CountryWarData:getScoreTask(type)
    local task_table = {}
    local task_list = cfg.countrywarmission.countrywarmission
    for i,v in ipairs(self.score_data.tasks) do
        for j,k in ipairs(task_list) do
            if type == v.type and v.type == k.type and v.round == k.round then
                --防止后段和前段数据不对应是报错
                for p,w in ipairs(v.task) do
                    if w.idx == k.idx then
                        table.insert( task_table, k)
                    end
                end
            end
        end
    end
    return task_table
end

--获取单个任务的状态
function CountryWarData:getTaskProgressById(idx)
    for i,v in ipairs( self.all_score_tasks_data) do
        if idx == v.idx then
            return v
        end
    end
end

--更新任务状态
function CountryWarData:updateTaskStatus(data)
    if data.task ~= nil and self.all_score_tasks_data ~= nil then
        for i,v in ipairs(data.task) do
            for j,k in ipairs(self.all_score_tasks_data) do
                if k.idx == v.idx then
                   k.reward = v.reward 
                   k.progress = v.progress 
                   break
                end 
            end 
        end
    end
end

--获取单个任务的是否已领取状态
function CountryWarData:getTaskGetStatus(idx)
    if idx == nil or idx == 0 or self.all_score_tasks_data[idx] == nil then
        return -1
    end

    return self.all_score_tasks_data[idx].reward and 1 or -1
end

--获取单个任务的是否可领取状态
function CountryWarData:getTaskProgressStatus(data)
    for i,v in ipairs( self.all_score_tasks_data) do
       if data.idx == v.idx then
          if v.progress >= data.target.target  then
                return 1
            else
                return -1
          end
       end
   end
end

--获取当前积分等级
function CountryWarData:getScoreLevel(score)
    for i,v in ipairs(self:getNowRoundReward()) do
        if score == v.need_score[1].item_num then
            return v.level
        else
            if score < v.need_score[1].item_num and score > self:getLevelScore(v.level - 1) then
                return v.level - 1
            end
        end
    end
    return 0
end

--根据等级查找对应积分
function CountryWarData:getLevelScore(lv)
    if lv == 0 then
        lv = 1
    end
    for i,v in ipairs(self:getNowRoundReward()) do   
        if lv == v.level then
            return v.need_score[1].item_num
        end
    end
end

--获取最大积分
function CountryWarData:getMaxScore()
    local reward_data = self:getNowRoundReward()
    local item_num = reward_data[#reward_data].need_score[1].item_num or -1
    return item_num
end

--是否以领取普通奖励
function CountryWarData:getIsGetedReward(idx)
   for i,v in ipairs( self.score_record) do
       if idx == v then
           return true
       end
   end
   return false 
end

--是否以领取神秘奖励
function CountryWarData:getIsGetedMysteryReward(idx)
    for i,v in ipairs( self.mystery_score_record) do
        if idx == v then
            return true
        end
    end
    return false 
end

--是否有奖励可以领取
function CountryWarData:getIsHasRewardGet()
    if not self.score_data then
        return false
    end
    local lv = self:getScoreLevel(self.score_data.score)
    if lv == 0 then return false end 
    local can = false 
    if self.score_buy_gem then
        for i=1,lv do
            if not self.score_record[i] or not self.mystery_score_record[i] then
                can = true
                return can
            end
        end
    else
        for i=1,lv do
            if not self.score_record[i]then
                can = true
                return can
            end
        end
    end
    return can    
end

--是否有任务可以领取
function CountryWarData:getIsHasTaskGet()
    local task_data =  cfg.countrywarmission.countrywarmission
    if not self.all_score_tasks_data then
        return false
    end
    for i,v in ipairs(self.all_score_tasks_data) do
        for j,k in ipairs(task_data) do
            if v.idx == k.idx and not v.reward and v.progress >= k.target.target then
                return true
            end
        end
        
    end
    return false
end

--积分红点
function CountryWarData:setScoreRed()
    local is_red = false
    
    if ex.Player.level >= cfg.opencondition.condition["main_country_war"].condition_value then
        if self:getIsHasRewardGet() or self:getIsHasTaskGet() then
            is_red = true
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_GZ_JFJL, is_red)
end


--获取不同时间段的倒计时
function CountryWarData:getTime(idx)
    if self.score_data and self.score_data.tasks then
        for i,v in ipairs(self.score_data.tasks) do
            if idx == v.type then
                return v.refresh_time
            end
        end 
    end
end

--获取当前轮次的奖励表
function CountryWarData:getNowRoundReward()
    local reward_list_data = {}
    for i,v in ipairs(cfg.countrywarmissionscore.countrywarmissionscore) do
        if self.type == v.round then
            table.insert(reward_list_data, v )
        end
    end
    if not reward_list_data then
        print("后端参数错误(赛季主题)和表的轮次不对应")
    end
    return reward_list_data
end

--------------------------------------------------国战日志------------------------------------------------------
--战场日志
function CountryWarData:setServerLogData(data)
    self.server_log_data = data
    ex.EventManager:fire(EVENT.COUNTRY_WAR.OPEN_COUNTRY_WAR_LOG)
end

--角色日志
function CountryWarData:setRoleLogData(data)
    self.role_log_data = data
end

--根据对应的界面返回对应的数据
function CountryWarData:getLogData(tag)
    local data = nil
    local log_data = {}
    if tag == 1 and self.server_log_data ~= nil then
        data = self.server_log_data.logs
    elseif tag == 2 and self.role_log_data ~= nil then
        data = self.role_log_data.logs 
    else
        return nil
    end
    for i,v in pairs(data) do
        table.insert(log_data, v)
    end
    return log_data
end

--------------------------------------------------随机商城------------------------------------------------------
--随机商城
function CountryWarData:setRandomShopData(data)
   self.random_shop_data = data
   ex.EventManager:fire(EVENT.COUNTRY_WAR.OPEN_RANDOM_SHOP)
end

--随机商城购买
function CountryWarData:setRandomShopBuyData(data)
    self.random_shop_data = data
    ex.EventManager:fire(EVENT.COUNTRY_WAR.UPDATA_RANDOM_SHOP_LAYER)
end

--获取随机商城物品购买的数量
function CountryWarData:getBuyNum(idx)
    if self.random_shop_data then
        for i,v in ipairs(self.random_shop_data.buy_count) do
            if idx == v.key then
                return v.value   
            end
        end
    end
    return 0
end

--随机商城是否可以购买 并返回一个商店城池id
function CountryWarData:getRandomShopIsBuy()
    local is_buy = false
    local city_id = nil  --商店所在的城池
    for k,v in pairs(self.cities) do
        if v.shop_duration - ex.Game:getServerTime() > 0 then
            city_id = v.idx
            break
        end
    end 
    local is_buy = self:isCityFriend(city_id) and true or (self:isCityMy(city_id) and true or false)
    return is_buy, city_id
end

---------------------------------------

--是否开启子功能
function CountryWarData:checkOpen()
	if not self:isOpen() then
		ex.MessageView:add(ex.Tools:getLang(55583))
		return true
	end
	return false
end


return CountryWarData