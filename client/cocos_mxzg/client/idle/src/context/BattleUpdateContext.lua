local BattleUpdateContext = class("BattleUpdateContext")

--[[
    initData:
    {
        enabledPlaySpeed : <boolean> 是否启用全局战斗速度
        layer   : <cc.Node> 战场显示对象
        update  : <BattleAttributeUpdateInfo> 属性变更信息
        isSkill : <boolean> 是否是技能
        hit     : <int> 打击类型
    }
]]
function BattleUpdateContext:ctor(initData)
    self._enabledPlaySpeed = initData.enabledPlaySpeed
    self._layer            = initData.layer
    self._update           = initData.update
    self._isSkill          = initData.isSkill
    self._hit              = initData.hit
end

function BattleUpdateContext:getEnabledPlaySpeed()
    return self._enabledPlaySpeed
end

function BattleUpdateContext:getLayer()
    return self._layer
end

function BattleUpdateContext:getUpdate()
    return self._update
end

function BattleUpdateContext:getHit()
    return self._hit
end

function BattleUpdateContext:isSkill()
    return self._isSkill
end

return BattleUpdateContext
