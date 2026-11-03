local BattleGoddessAttackInfo = class('BattleGoddessAttackInfo')

--[[
    initData:
    {
        heroData : 女神的数据
        energy   : 女神在当前回合增加的能量
        attack   : <BattleAttackInfo> 女神攻击信息
    }
]]
function BattleGoddessAttackInfo:ctor(initData)
    self._goddessData = initData.goddessData
    self._energy   = initData.energy
    self._attack  = initData.attack
end

function BattleGoddessAttackInfo:getGoddessData()
    return self._goddessData
end

function BattleGoddessAttackInfo:getEnergy()
    return self._energy
end

function BattleGoddessAttackInfo:getAttack()
    return self._attack
end

return BattleGoddessAttackInfo
