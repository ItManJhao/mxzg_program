local BattleActionContext = class("BattleActionContext")

--[[
    技能的打击语义类型，虽然叫做打击，但是治愈型技能也是会触发打击语义的
]]
BattleActionContext.HitType = {
    --[[
        通用型
    ]]
    Common = 0,

    --[[
        伤害型
    ]]
    Harm = 1,

    --[[
        治愈型
    ]]
    Heal = 2,
}

--[[
    initData:
    {
        enabledPlaySpeed : <boolean> 是否启用全局战斗速度
        layer            : <cc.Node> 战场显示对象
        controlContext   : <BattleControlContext> 战斗控制上下文对象
        layerContext     : <BattleLayerContext> 战斗专用的层上下文对象
        actionHeroData   : <BattleHeroData> 执行动作的英雄数据对象
        effect           : <BattleEffectInfo> 效果信息对象
        isDelay          : <boolean> 是否开启延迟
        hitHandler       : <function(hitType)> 打击回调函数，执行动作过程中如果触发打击语义的情况下，就会调用这个函数，
                           并且传递 BattleActionContext.HitType 中的一个值
        completedHandler : <function> 动作完成回调函数，执行动作完成后调用这个函数
    }
]]
function BattleActionContext:ctor(initData)
    self._enabledPlaySpeed = initData.enabledPlaySpeed
    self._layer            = initData.layer
    self._controlContext   = initData.controlContext
    self._layerContext     = initData.layerContext
    self._actionHeroData   = initData.actionHeroData
    self._effect           = initData.effect
    self._isDelay          = initData.isDelay
    self._hitHandler       = initData.hitHandler
    self._completedHandler = initData.completedHandler
end

function BattleActionContext:getEnabledPlaySpeed()
    return self._enabledPlaySpeed
end

function BattleActionContext:getLayer()
    return self._layer
end

function BattleActionContext:getControlContext()
    return self._controlContext
end

function BattleActionContext:getLayerContext()
    return self._layerContext
end

function BattleActionContext:getActionHeroData()
    return self._actionHeroData
end

function BattleActionContext:getEffect()
    return self._effect
end

function BattleActionContext:isDelay()
    return self._isDelay
end

function BattleActionContext:getHitHandler()
    return self._hitHandler
end

function BattleActionContext:getCompletedHandler()
    return self._completedHandler
end

return BattleActionContext
