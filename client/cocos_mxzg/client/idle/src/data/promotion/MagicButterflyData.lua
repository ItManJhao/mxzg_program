local MagicButterflyData = class("MagicButterflyData")

function MagicButterflyData:ctor( )
    self._summon_num = 0
    self._free_time = 0
    self._hero_out_num = 0
    self._geted = {}
end

function MagicButterflyData:resetRewardStatus()
    self._geted = {}
end

function MagicButterflyData:getRewardStatus(id)
    return self._geted[id]
end

function MagicButterflyData:setSummonNum(num)
    self._summon_num = num 
end

function MagicButterflyData:setHeroOutNum(num)
    self._hero_out_num = num 
end

function MagicButterflyData:setRewardStatus(id)
    self._geted[id] = true
end

function MagicButterflyData:setFreeTime(time)
    self._free_time = time
end

function MagicButterflyData:getSummonNum( )
    return self._summon_num
end

function MagicButterflyData:getHeroOutNum( )
    return self._hero_out_num
end

function MagicButterflyData:getFreeTime( )
    return self._free_time
end

function MagicButterflyData:clear()
    self._summon_num = nil
    self._free_time = nil 
    self._geted = nil
    self._hero_out_num = nil
end

-- 0: 进度未达到， 1：可以领取 2：已经领取
function MagicButterflyData:getBoxRewardStatus(idx)
    local reward_cfg = cfg.promotionnewherolotter.promotionnewherolotter
    local config_progress = reward_cfg[idx].task_count

    local is_reward = self._geted[idx]

    if is_reward then
        return 2
    end
    
    if self._summon_num >= config_progress then
        return 1
    end

    return 0
end


return MagicButterflyData