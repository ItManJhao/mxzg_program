local BattleDragonAttackInfo = class('BattleDragonAttackInfo')

--[[
    initData:
    {
        dragonData          : 神龙的数据
        skill_id            : 神龙当前释放技能id
        next_attack_round   : 下次攻击间隔回合数
        attacks             : <BattleAttackInfo> 神龙攻击信息
    }
]]
function BattleDragonAttackInfo:ctor(initData)
    self._dragonData        = initData.dragonData
    self._skill_id          = initData.skill_id
    self._next_attack_round = initData.next_attack_round
    self._attacks           = initData.attacks
end

function BattleDragonAttackInfo:getDragonData()
    return self._dragonData
end

function BattleDragonAttackInfo:getSkillId()
    return self._skill_id
end

function BattleDragonAttackInfo:getNextAttackRound()
    return self._next_attack_round
end

function BattleDragonAttackInfo:getAttack()
    return self._attacks
end

return BattleDragonAttackInfo
