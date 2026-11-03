local BattleInfo = class('BattleInfo')

--[[
    initData:
    {
        id     : <string> 战斗的唯一ID
        type   : <int> 战斗的类型
        heroes : {unitId : <BattleHeroData>} 英雄信息映射列表，方便通过UnitID查找英雄
        rounds : {<int> : <BattleRoundInfo>} 战斗每回合的详细信息列表，以回合数字作为key
        isWin  : <boolean> 战斗是否胜利
    }
]]
function BattleInfo:ctor(initData)
    self._id     = initData.id
    self._type   = initData.type
    self._heroes = initData.heroes
    self._rounds = initData.rounds
    self._isWin  = initData.isWin
end

function BattleInfo:getId()
    return self._id
end

function BattleInfo:getType()
    return self._type
end

function BattleInfo:getHero(unitId)
    return self._heroes[unitId]
end

function BattleInfo:getHeroes()
    return self._heroes
end

function BattleInfo:getRound(round)
    return self._rounds[round]
end

function BattleInfo:isWin()
    return self._isWin
end

return BattleInfo
