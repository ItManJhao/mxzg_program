local BattleBuffInfo = class('BattleBuffInfo')

--[[
    buff触发的打击类型
]]
BattleBuffInfo.HitType = {
    --[[
        命中
    ]]
    Hit = 0,

    --[[
        未命中
    ]]
    Miss = 1,

    --[[
        暴击
    ]]
    Crit = 2,

    --[[
        斩杀
    ]]
    Kill = 3,

    --[[
        格挡
    ]]
    Parry = 4,
}

--[[
    buff触发的受影响角色的状态
]]
BattleBuffInfo.Status = {
    --[[
        角色存活
    ]]
    Alive = 0,

    --[[
        角色死亡
    ]]
    Dead  = 1,
}

--[[
    buff产生的对抗效果类型
]]
BattleBuffInfo.ResistanceType = {
    Parry         = 210, -- 格挡
    ControlImmune = 212, -- 免控
    Silence       = 213, -- 沉默
    Disarm        = 214, -- 缴械
    Immobilized   = 215, -- 定身
    Frozen        = 216, -- 冰冻
    Dizzy         = 217, -- 眩晕
    Petrify       = 218, -- 石化
}

--[[
    initData:
    {
        unitId       : <int> buff的唯一ID
        heroData     : <BattleHeroData> 受影响的英雄数据对象
        buff         : <object> 在配置表中的buff数据
        expiredRound : <int> buff的过期回合
        hit          : <int> buff产生的打击类型
        status       : <int> buff产生的受影响的角色状态
        updates      : [<BattleAttributeUpdateInfo>] 受技能英雄的战斗英雄的属性变化列表
        resistances  : [<int>] 生效的对抗效果列表
    }
]]
function BattleBuffInfo:ctor(initData)
    self._unitId       = initData.unitId
    self._heroData     = initData.heroData
    self._buff         = initData.buff
    self._expiredRound = initData.expiredRound
    self._hit          = initData.hit
    self._status       = initData.status
    self._updates      = initData.updates
    self._resistances  = initData.resistances
    self._target_unitId = initData.target_unitId
end

function BattleBuffInfo:getTargetUnitId()
    return self._target_unitId
end

function BattleBuffInfo:getUnitId()
    return self._unitId
end

function BattleBuffInfo:getHeroData()
    return self._heroData
end

function BattleBuffInfo:getBuff()
    return self._buff
end

function BattleBuffInfo:getExpiredRound()
    return self._expiredRound or 0
end

function BattleBuffInfo:getHit()
    return self._hit
end

function BattleBuffInfo:getStatus()
    return self._status
end

function BattleBuffInfo:getUpdates()
    return self._updates
end

function BattleBuffInfo:getResistances()
    return self._resistances
end

return BattleBuffInfo
