local NewYearResponse = class("NewYearResponse")

function NewYearResponse:initList(data)
    -- dump(data)
    ex.Player.promotion_data.new_year_data:initData(data)
    
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

function NewYearResponse:buyLevel(data)
    -- dump(data)
    ex.Player.promotion_data.new_year_data:setExp(data.exp)
    ex.Player.promotion_data.new_year_data:setLevel(data.level)
    ex.Player.promotion_data.new_year_data:checkRewardRed()
    ex.Player.promotion_data.new_year_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.NEW_YEAR_ACTIVE.UP_LEVEL)
end

function NewYearResponse:getLevelReward(data)
    -- dump(data)
    ex.Player.promotion_data.new_year_data:setBaseRewardReward(data.finish_reward)
    ex.Player.promotion_data.new_year_data:setSpecialRewardReward(data.privilege_reward)
    ex.Player.promotion_data.new_year_data:checkRewardRed()
    ex.Player.promotion_data.new_year_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.NEW_YEAR_ACTIVE.ONE_KEY_GET_REWARD)
end

function NewYearResponse:oneKeyLevelReward(data)
    -- dump(data)
    -- for i,v in ipairs(data.finish_reward) do
        
    -- end

    -- for i,v in ipairs(data.privilege_reward) do
    ex.Player.promotion_data.new_year_data:setBaseRewardReward(data.finish_reward)
    ex.Player.promotion_data.new_year_data:setSpecialRewardReward(data.privilege_reward)
    ex.Player.promotion_data.new_year_data:checkRewardRed()
    ex.Player.promotion_data.new_year_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.NEW_YEAR_ACTIVE.ONE_KEY_GET_REWARD)
    -- end
end

function NewYearResponse:getTaskReward(data)
    -- dump(data)
    local up_level = data.level > ex.Player.promotion_data.new_year_data:getLevel()
    ex.Player.promotion_data.new_year_data:setExp(data.exp)
    ex.Player.promotion_data.new_year_data:setLevel(data.level)
    ex.Player.promotion_data.new_year_data:setTaskGetedById(data.idx)
    ex.Player.promotion_data.new_year_data:checkTaskRed()
    ex.Player.promotion_data.new_year_data:checkRewardRed()
    ex.Player.promotion_data.new_year_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.NEW_YEAR_ACTIVE.GET_TASK_REWARD)
    if up_level then 
        ex.EventManager:fire(EVENT.NEW_YEAR_ACTIVE.UP_LEVEL)
    end
end

function NewYearResponse:updateTaskProgress(data)
    -- dump(data)
    ex.Player.promotion_data.new_year_data:setTaskProgressList(data.task_progress)
    ex.Player.promotion_data.new_year_data:checkTaskRed()
    ex.Player.promotion_data.new_year_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.NEW_YEAR_ACTIVE.UP_TASK_PROGRESS)
end

function NewYearResponse:buySpecial(data)
    dump(data)
    ex.Player.promotion_data.new_year_data:setLevel(data.level)
    ex.Player.promotion_data.new_year_data:setExp(data.exp)
    ex.Player.promotion_data.new_year_data:setBuySpecial(data.buy_privilege)
    ex.Player.promotion_data.new_year_data:setSpecialRewardReward(data.privilege_reward)
    ex.Player.promotion_data.new_year_data:checkRewardRed()
    ex.Player.promotion_data.new_year_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.NEW_YEAR_ACTIVE.BUY_SPECIAL)
end

-- function NewYearResponse:initList(data)

-- end

-- function NewYearResponse:initList(data)

-- end

return NewYearResponse
