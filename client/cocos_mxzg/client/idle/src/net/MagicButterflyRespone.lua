local MagicButterflyRespone = class("MagicButterflyRespone")

function MagicButterflyRespone:onInitData(data)
    ex.Player.promotion_data.magic_butterfly_data:setSummonNum(data.summon_num)
    ex.Player.promotion_data.magic_butterfly_data:resetRewardStatus()
    for i,v in ipairs(data.rewards) do
        ex.Player.promotion_data.magic_butterfly_data:setRewardStatus(v)
    end
    ex.Player.promotion_data.magic_butterfly_data:setFreeTime(data.free_time)
    ex.Player.promotion_data.magic_butterfly_data:setHeroOutNum(data.hero_out_num)
    ex.EventManager:fire(EVENT.MAGIC_BUTTERFLY.UPDATE_SUMMON_NUM)
end

function MagicButterflyRespone:onRewardData(data)
    ex.Player.promotion_data.magic_butterfly_data:setRewardStatus(data.idx)
    ex.EventManager:fire(EVENT.MAGIC_BUTTERFLY.GET_REWARD)
end

function MagicButterflyRespone:onUpdateSummonNum(data)
    ex.Player.promotion_data.magic_butterfly_data:setSummonNum(data.summon_num)
    ex.Player.promotion_data.magic_butterfly_data:setFreeTime(data.free_time)
    ex.Player.promotion_data.magic_butterfly_data:setHeroOutNum(data.hero_out_num)
    ex.EventManager:fire(EVENT.MAGIC_BUTTERFLY.UPDATE_SUMMON_NUM)
end

return MagicButterflyRespone