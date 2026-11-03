local PromWarOrderResponse = class("PromWarOrderResponse")

function PromWarOrderResponse:initList(data)
    ex.Player.promotion_data.prom_war_order_data:initData(data)
    
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

function PromWarOrderResponse:buyLevel(data)
    ex.Player.promotion_data.prom_war_order_data:setExp(data.exp)
    ex.Player.promotion_data.prom_war_order_data:setLevel(data.level)
    ex.Player.promotion_data.prom_war_order_data:checkRewardRed()
    ex.Player.promotion_data.prom_war_order_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.WAR_ORDER_ACTIVE.UP_LEVEL)
end

function PromWarOrderResponse:getLevelReward(data)
    ex.Player.promotion_data.prom_war_order_data:setBaseRewardReward(data.finish_reward)
    ex.Player.promotion_data.prom_war_order_data:setSpecialRewardReward(data.privilege_reward)
    ex.Player.promotion_data.prom_war_order_data:checkRewardRed()
    ex.Player.promotion_data.prom_war_order_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.WAR_ORDER_ACTIVE.ONE_KEY_GET_REWARD)
end

function PromWarOrderResponse:oneKeyLevelReward(data)
    ex.Player.promotion_data.prom_war_order_data:setBaseRewardReward(data.finish_reward)
    ex.Player.promotion_data.prom_war_order_data:setSpecialRewardReward(data.privilege_reward)
    ex.Player.promotion_data.prom_war_order_data:checkRewardRed()
    ex.Player.promotion_data.prom_war_order_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.WAR_ORDER_ACTIVE.ONE_KEY_GET_REWARD)
end

function PromWarOrderResponse:getTaskReward(data)
    local up_level = data.level > ex.Player.promotion_data.prom_war_order_data:getLevel()
    ex.Player.promotion_data.prom_war_order_data:setExp(data.exp)
    ex.Player.promotion_data.prom_war_order_data:setLevel(data.level)
    ex.Player.promotion_data.prom_war_order_data:setTaskGetedById(data.idx)
    ex.Player.promotion_data.prom_war_order_data:checkTaskRed()
    ex.Player.promotion_data.prom_war_order_data:checkRewardRed()
    ex.Player.promotion_data.prom_war_order_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.WAR_ORDER_ACTIVE.GET_TASK_REWARD)
    if up_level then 
        ex.EventManager:fire(EVENT.WAR_ORDER_ACTIVE.UP_LEVEL)
    end
end

function PromWarOrderResponse:updateTaskProgress(data)
    ex.Player.promotion_data.prom_war_order_data:setTaskProgressList(data.task_progress)
    ex.Player.promotion_data.prom_war_order_data:checkTaskRed()
    ex.Player.promotion_data.prom_war_order_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.WAR_ORDER_ACTIVE.UP_TASK_PROGRESS)
end

function PromWarOrderResponse:buySpecial(data)
    ex.Player.promotion_data.prom_war_order_data:setLevel(data.level)
    ex.Player.promotion_data.prom_war_order_data:setExp(data.exp)
    ex.Player.promotion_data.prom_war_order_data:setBuySpecial(data.buy_privilege)
    ex.Player.promotion_data.prom_war_order_data:setSpecialRewardReward(data.privilege_reward)
    ex.Player.promotion_data.prom_war_order_data:checkRewardRed()
    ex.Player.promotion_data.prom_war_order_data:actAtomIsRed()
    ex.EventManager:fire(EVENT.WAR_ORDER_ACTIVE.BUY_SPECIAL)
end
return PromWarOrderResponse
