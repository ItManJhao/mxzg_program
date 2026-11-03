BattleActionFactory = {}

local SHAKE_TIME = 0.016

--[[
    震动效果动作
]]
BattleActionFactory.createShake = function(range, times, slowDown)
    local DOUBLE_SHAKE_TIME = 2*SHAKE_TIME

    local actionArr = {}
    for i = 0, times do
        local doubleRange = 2 * range
        local inc = cc.MoveBy:create(SHAKE_TIME, cc.p(range, range))
        local dec = cc.MoveBy:create(DOUBLE_SHAKE_TIME, cc.p(-doubleRange, -doubleRange))

        table.insert(actionArr, inc)
        table.insert(actionArr, dec)
        table.insert(actionArr, inc)
        
        range = range - slowDown
        if range < 1 then
            range = 1
        end
    end

    return cc.Sequence:create(actionArr)
end

--[[
    变暗效果动作
]]
BattleActionFactory.createDimly = function(timeIn, timeOut, timeDelay)
    return cc.Sequence:create(
        cc.EaseExponentialOut:create(cc.FadeTo:create(timeIn, 128)),
        cc.DelayTime:create(timeDelay),
        cc.EaseExponentialOut:create(cc.FadeTo:create(timeOut, 0)),
        nil
    )
end
