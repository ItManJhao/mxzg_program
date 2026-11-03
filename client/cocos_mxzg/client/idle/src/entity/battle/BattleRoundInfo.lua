local BattleRoundInfo = class('BattleRoundInfo')

--[[
    initData:
    {
        round          : 回合数字
        buffs          : {<int> : [<BattleBuffInfo>]} 回合开始时需要执行的buff效果列表(以英雄的唯一ID作为字典key)
        goddessAttacks : [<BattleAttackInfo>] 女神攻击信息
        dragonAttacks  : [<BattleAttackInfo>] 神龙攻击信息
        attacks        : [<BattleAttackInfo>] 英雄攻击信息
        afterBuffs     : {<int> : [<BattleBuffInfo>]} 回合结束时需要执行的buff效果列表(以英雄的唯一ID作为字典key)
    }
]]
function BattleRoundInfo:ctor(initData)
    self._round          = initData.round
    self._buffs          = initData.buffs
    self._goddessAttacks = initData.goddessAttacks
    self._dragonAttacks  = initData.dragonAttacks
    self._attacks        = initData.attacks
    self._afterBuffs     = initData.afterBuffs
end

function BattleRoundInfo:getRound()
    return self._round
end

function BattleRoundInfo:getBuffs()
    return self._buffs
end

function BattleRoundInfo:getGoddessAttacks()
    return self._goddessAttacks
end

function BattleRoundInfo:getDragonAttacks()
    return self._dragonAttacks
end

function BattleRoundInfo:getAttacks()
    return self._attacks
end

function BattleRoundInfo:getAfterBuffs()
    return self._afterBuffs
end

return BattleRoundInfo
