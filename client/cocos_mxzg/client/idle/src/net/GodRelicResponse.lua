local GodRelicResponse = class("GodRelicResponse")

function GodRelicResponse:godRelicData(data)
    ex.Player.god_relic_data.vec_data = data.starMap
    ex.Player.god_relic_data.vec_star = data.star_reward_record
    ex.Player.god_relic_data.can_challenge_count = data.can_challenge_count
    ex.Player.god_relic_data.buy_count = data.buy_count
    
    ex.Player.god_relic_data:checkReddot()
    ex.EventManager:fire(EVENT.GOD_RELIC.UPDATE)
end

function GodRelicResponse:godRelicChallenge(data)

    ex.Player.god_relic_data.can_challenge_count = data.can_challenge_count
    ex.Player.god_relic_data:updateMissionData(data.max_star_map)

    ctr.god_relic:addBattleLayer(data, 1)

    ex.Player.promotion_data:reqLimitGift()
end

function GodRelicResponse:godRelicBuyCount(data)
    ex.Player.god_relic_data.can_challenge_count = data.can_challenge_count
    ex.Player.god_relic_data.buy_count = data.buy_count
    ex.EventManager:fire(EVENT.GOD_RELIC.BUY_COUNT)
end

function GodRelicResponse:godRelicGetStarReward(data)
    table.insert(ex.Player.god_relic_data.vec_star, data.idx)
    ex.EventManager:fire(EVENT.GOD_RELIC.STAR_REWARD)
end

function GodRelicResponse:godRelicSweep(data)
    ex.Player.god_relic_data.can_challenge_count = data.can_challenge_count
    ex.EventManager:fire(EVENT.GOD_RELIC.BUY_COUNT)
end

return GodRelicResponse
