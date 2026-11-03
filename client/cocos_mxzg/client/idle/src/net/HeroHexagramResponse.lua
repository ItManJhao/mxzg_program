local HeroHexagramResponse = class("HeroHexagramResponse")

-- 六芒星重置
function HeroHexagramResponse:hexagramReset(data)
    -- GResHeroHexagramReset
    ex.Player.hero_data.hexagram:resetDone(data.hero_id, data.type)
end

-- 六芒星强化/突破
function HeroHexagramResponse:hexagramUpgrade(data)
    -- GReqHeroHexagramUpgrade
    ex.Player.hero_data.hexagram:upgradeDone(data.hero_id, data.type, data.level)
end

return HeroHexagramResponse