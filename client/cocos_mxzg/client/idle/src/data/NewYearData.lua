local NewYearData = class("NewYearData")

function NewYearData:ctor()
    self.level = 0
    self.max_level = 0
    self.buy_special = false            --特权购买状态
    self.exp = 0                        --经验值
    self.base_reward_geted = {}         --基础奖励领取记录
    self.special_reward_geted = {}      --特殊奖励领取记录
    self.task_geted = {}                --任务领取记录
    self.task_progress = {}             --任务进度
    self.stauts = 0                     --弹窗
    self.round = 1                      --轮次

    self.reward_red = false             --奖励红点
    self.task_red = {}                  --任务红点
    self.remain_time = 0
    self:initMaxLevel()
    self:registerEvent()
    
end

function NewYearData:setStatus(status)
    self.stauts = status
end

function NewYearData:getStatus( )
    return self.stauts
end

function NewYearData:getMaxLevel( )
    return self.max_level
end

function NewYearData:initData(data)
    self.task_progress = {}
    self:setLevel(data.level)
    self:setExp(data.exp)
    self:setBuySpecial(data.buy_privilege)
    self:setBaseRewardReward(data.finish_reward)
    self:setSpecialRewardReward(data.privilege_reward)
    self:setTaskGeted(data.task_idx)
    self:setTaskProgressList(data.task_list)
    self:setDayEndTime(data.day_end_time)
    self:setWeekEndTime(data.week_end_time)
    self:setStatus(data.status)
    self:setRound(data.round)
    self:initRedPoint()
    ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_new_year")
    ex.EventManager:fire(EVENT.NEW_YEAR_ACTIVE.REFRESH_INIT_DATA,"act_new_year")
end

function NewYearData:setRound(round)
    if round < 1 then
        return
    end
    self.round = round
end

function NewYearData:setDayEndTime(time)
    self.day_end_time = time
end

function NewYearData:setWeekEndTime(time)
    self.week_end_time = time
end

function NewYearData:getOpenData( )
    return self.open_data
end

function NewYearData:getTaskEndTimeByType(type)
    if type == 1 then 
        return self.day_end_time
    elseif type == 2 then 
        return self.week_end_time
    else
        return self.open_data.end_time
    end
end

function NewYearData:startTime(event,data)

    for i,v in ipairs(data) do
        if v.id == 53 then 
            self.open_data = {}
            self.open_data.clear_time = ex.Tools:getTimeWithUTC(v.clear_time)
            self.open_data.end_time = ex.Tools:getTimeWithUTC(v.end_time)
            self.open_data.id = v.id
            self.open_data.start_time = ex.Tools:getTimeWithUTC(v.start_time)
            self.open_data.turns = v.turns
            break
        end
    end
    if not self.open_data then return end 
    local is_open = self.open_data.end_time - ex.Game:getServerTime() > 0
    if is_open then 
        self:startTimer()
    end
    self.remain_time =  self.open_data.end_time - ex.Game:getServerTime()
    self:initRedPoint()
    self.open_timer = ex.Timer:addTimer(1000,function ( )
        if self.open_data == nil then
            self:removeTimer()
            return
        end
        if self.open_data.start_time >= ex.Game:getServerTime() then 
            ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_new_year")
            ex.Timer:removeTimerById(self.open_timer)
        end
    end,true)
    ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_new_year")
end

function NewYearData:startTimer( )
    self:removeTimer()
    self.timer = ex.Timer:addTimer(1000, function () 
        if not self.open_data then 
            self:removeTimer()
            return 
        end
        self.remain_time =  self.open_data.end_time - ex.Game:getServerTime()
        if self.remain_time <= 0 then 
            ex.Timer:removeTimerById(self.timer)
            self:initRedPoint()
            ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_new_year")
        end
    end, true)
end

function NewYearData:removeTimer( )
    if self.timer ~= nil then 
        ex.Timer:removeTimerById(self.timer)
    end
    self.timer = nil
end

function NewYearData:registerEvent( )
    self.event_list = {
        ex.EventManager:add(EVENT.MAIN_CITY_PROMOTION.ACT_OPEN_TIME,handler(self,self.startTime))
    }
end

function NewYearData:removeEvent( )
    if self.event_list == nil then return end 
    for i,v in ipairs(self.event_list) do
        ex.EventManager:remove(v)
    end
    self.event_list = nil
end

function NewYearData:initRedPoint( )
    self:checkRewardRed()
    self:checkTaskRed()
    self:actAtomIsRed()
end

function NewYearData:actAtomIsRed( )
    local task_red = false
    for i,v in ipairs(self.task_type_red) do
        if v == true then
            task_red = v 
            break
        end
    end
    local bool = self.reward_red or task_red
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_XCHD, bool)
end

function NewYearData:checkTaskRed()
    local conf = cfg.promotiontrafficpermit.task
    self.task_red = {}
    self.task_type_red = {}
    if self.remain_time <= 0 then return end 
    for k,v in pairs(self.task_progress) do
        local data = conf[k]
        local not_geted = not self.task_geted[k]
        local condition = v >= data.mission.target 
        local task_type = data.task_type
        self.task_type_red[task_type] = false
        self.task_red[k] = condition and not_geted
    end

    for k,v in pairs(self.task_red) do
        if v == true then 
            local data = conf[k]
            local task_type = data.task_type
            self.task_type_red[task_type] = true
        end
    end
end

function NewYearData:checkRewardRed( )
    self.reward_red = false
    if self.remain_time <= 0 then return end 
    local conf = cfg.promotiontrafficpermitreward.reward
    for i=1,table.nums(conf) do
        -- local red = conf[i].level <= self.level 
        local condition_level = conf[i].level <= self.level 
        if condition_level == false then return end
        local baseConfRewaed = conf[i].finish_reward
        local condition_base = (self.base_reward_geted[conf[i].level] ~= true) and (baseConfRewaed and next(baseConfRewaed))
        local specialConfReward  = conf[i].privilege_reward
        local condition_special = self.buy_special and self.special_reward_geted[conf[i].level] ~= true and (specialConfReward and next(specialConfReward))
        local not_geted = (condition_base) or (condition_special)
        local bool = condition_level and not_geted
        if bool then 
            self.reward_red = true 
            break
        end
    end
end

function NewYearData:getRewardRed( )
    return self.reward_red
end

function NewYearData:getTaskByType(type)
    return self.task_type_red[type] == true
end

function NewYearData:canOneKeyReward( )
    if self.level == 0 then return false end 
    local can = false 
    for i=1,self.level do
        can = self.base_reward_geted[i] ~= true or self.special_reward_geted[i] ~= true  
        if can then break end 
    end
    return can 
end

function NewYearData:setExp(exp)
    self.exp = exp
end

function NewYearData:setBuySpecial(buy_special)
    self.buy_special = buy_special == 1
end

function NewYearData:setBaseRewardReward(list)
    for i,v in ipairs(list) do
        self.base_reward_geted[v] = true
    end
end

function NewYearData:setSpecialRewardReward(list)
    for i,v in ipairs(list) do
        self.special_reward_geted[v] = true
    end
end

function NewYearData:setTaskGeted(list)
    for i,v in ipairs(list) do
        self.task_geted[v] = true
    end
end

function NewYearData:setTaskGetedById(id)

    self.task_geted[id] = true
end

function NewYearData:setTaskProgressList(list)
    for i,v in ipairs(list) do
        self.task_progress[v.key] = v.value
    end
end

function NewYearData:updateTaskProgress(list)
    for i,v in ipairs(list) do
        self.task_progress[v.key] = v.value
    end
end

function NewYearData:getTaskList( )
    return self.task_progress
end

function NewYearData:getTaskProgressById(id)
    return self.task_progress[id]
end

function NewYearData:getTaskById(id)
    return self.task_geted[id]
end

function NewYearData:getSpecialRewardById(id)
    return self.special_reward_geted[id]
end

function NewYearData:getBaseRewardById(id)
    return self.base_reward_geted[id]
end

function NewYearData:getExp()
    return self.exp
end

function NewYearData:isBuySpecial()
    return self.buy_special
end

function NewYearData:getRemainTime( )
    return self.remain_time
end

function NewYearData:initMaxLevel( )
    local conf = cfg.promotiontrafficpermitreward.reward
    for i,v in ipairs(conf) do
        if v.level > self.max_level then 
            self.max_level = v.level
        end
    end
end

function NewYearData:getCanBuyLevel( )
    local conf  = cfg.promotiontrafficpermitreward.reward
    local cost = {}
    cost.item_num = 0
    local can_level = self.level 
    for i=self.level + 1,self.max_level do
        local v = conf[i]
        if not cost.item_type then cost.item_type = v.level_cost[1].item_type end 
        local hasNum = ex.Player:getItemNum(v.level_cost[1].item_type)
        local need = cost.item_num + v.level_cost[1].item_num 
        if hasNum < need then break end 
        cost.item_num = need
        can_level = v.level
        print(i,v.level_cost[1].item_num )
    end

    return can_level
end

function NewYearData:getCanBuyLevelItem(level)
    if level > self.max_level then return end 
    local buy_max_level = level - self.level
    if buy_max_level == 0 then return end 
    local conf  = cfg.promotiontrafficpermitreward.reward
    local cost = {}
    cost.item_num = 0
    local base_tmp = {}
    local special_tmp = {}
    for _,config_data in ipairs(conf) do
        if config_data.round == self.round and config_data.level >= self.level + 1 and config_data.level <= level then
            if not cost.item_type then cost.item_type = config_data.level_cost[1].item_type end
            local num = cost.item_num + config_data.level_cost[1].item_num
            local has_num = ex.Player:getItemNum(cost.item_type)
    
            -- if num > has_num then break end 
    
            cost.item_num = cost.item_num + config_data.level_cost[1].item_num
            if config_data.finish_reward ~= "" then
                for i,item in ipairs(config_data.finish_reward) do
                    if not base_tmp[item.item_type] then base_tmp[item.item_type] = 0 end
                    base_tmp[item.item_type] = base_tmp[item.item_type] + item.item_num
                end
            end
    
            if config_data.privilege_reward ~= "" then
                for i,item in ipairs(config_data.privilege_reward) do
                    if not special_tmp[item.item_type] then special_tmp[item.item_type] = 0 end
                    special_tmp[item.item_type] = special_tmp[item.item_type] + item.item_num
                end
            end
        end
    end

    local base_items = {}
    for k,v in pairs(base_tmp) do
        local item = {}
        item.item_type = k 
        item.item_num = v
        table.insert(base_items,item)
    end

    local special_items = {}
    for k,v in pairs(special_tmp) do
        local item = {}
        item.item_type = k 
        item.item_num = v
        table.insert(special_items,item)
    end

    local function sor(a,b)
        return a.item_type < b.item_type
    end
    table.sort(base_items,sor)
    table.sort(special_items,sor)
    if cost.item_num == 0 then return end 
    return {cost = cost,special_items = special_items , base_items = base_items}
end

function NewYearData:setLevel(level)
    self.level = level 
end

function NewYearData:getLevel( )
    return self.level
end

function NewYearData:clean( )
    self:removeTimer()
    self:removeEvent()
    if self.open_timer ~= nil then 
        ex.Timer:removeTimerById(self.open_timer)
    end
    self.open_timer = nil
    self.level = nil
    self.max_level = nil
    self.buy_special = nil            --特权购买状态
    self.exp = nil                        --经验值
    self.base_reward_geted = nil         --基础奖励领取记录
    self.special_reward_geted = nil      --特殊奖励领取记录
    self.task_geted = nil                --任务领取记录
    self.task_progress = nil             --任务进度

    self.reward_red = nil             --奖励红点
    self.task_red = nil                  --任务红点
    self.open_data = nil

end

return NewYearData