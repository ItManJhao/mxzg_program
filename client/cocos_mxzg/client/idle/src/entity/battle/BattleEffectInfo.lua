local BattleEffectInfo = class('BattleEffectInfo')

--[[
    initData:
    {
        skillId : <int> 技能ID
        buff    : <object> buff数据，配置表中对应的buff数据
        buffs   : [<BattleBuffInfo>] buff产生效果的影响列表
    }
]]
function BattleEffectInfo:ctor(initData)
    self._skillId = initData.skillId
    self._buff    = initData.buff
    self._buffs   = initData.buffs
end

function BattleEffectInfo:getSkillId()
    return self._skillId
end

function BattleEffectInfo:getBuff()
    return self._buff
end

function BattleEffectInfo:getBuffs()
    return self._buffs
end

return BattleEffectInfo
