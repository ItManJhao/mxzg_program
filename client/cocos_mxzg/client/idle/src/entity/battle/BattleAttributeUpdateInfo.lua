local BattleAttributeUpdateInfo = class('BattleAttributeUpdateInfo')

--[[
    initData:
    {
        heroData : <BattleHeroData> 属性产生变化的英雄对象
        type     : 变化的属性类型
        value    : 变化的属性值
    }
]]
function BattleAttributeUpdateInfo:ctor(initData)
    self._heroData = initData.heroData
    self._type     = initData.type
    self._value    = initData.value
    self._pos    = initData.pos
end

function BattleAttributeUpdateInfo:getHeroData()
    return self._heroData
end

function BattleAttributeUpdateInfo:getType()
    return self._type
end

function BattleAttributeUpdateInfo:getValue()
    return self._value
end

function BattleAttributeUpdateInfo:getPos()
    return self._pos
end

return BattleAttributeUpdateInfo
