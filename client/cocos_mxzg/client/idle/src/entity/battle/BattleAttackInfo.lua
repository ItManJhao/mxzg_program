local BattleAttackInfo = class('BattleAttackInfo')

--[[
    initData:
    {
        id             : <int> 英雄在战斗中的唯一ID
        actionHeroData : <BattleHeroData|BattleGoddessData|BattleDragonData> 执行动作的英雄对象
        skillId        : <int> 技能ID
        effects        : [<BattleEffectInfo>] 技能产生的效果信息列表
        energyUpdate   : <int> 能力更新信息
        skillType      : <int> 技能类型(1技能 2普攻)
    }
]]
function BattleAttackInfo:ctor(initData)
    self._id             = initData.id
    self._actionHeroData = initData.actionHeroData
    self._skillId        = initData.skillId
    self._effects        = initData.effects
    self._energyUpdate   = initData.energyUpdate
    self._skillType      = initData.skillType
end

function BattleAttackInfo:getId()
    return self._id
end

function BattleAttackInfo:getActionHeroData()
    return self._actionHeroData
end

function BattleAttackInfo:getSkillId()
    return self._skillId
end

function BattleAttackInfo:getEffects()
    return self._effects
end

function BattleAttackInfo:getEnergyUpdate()
    return self._energyUpdate
end

function BattleAttackInfo:getSkillType()
    return self._skillType
end

return BattleAttackInfo
