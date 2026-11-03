local BattleLayerContext = class('BattleLayerContext')

--[[
    initData:
    {
        layer              : <cc.Node> 战场显示对象
        actionLayer        : <cc.Node> 用于执行战斗相关action的层对象
        fullEffectLayer    : <cc.Node> 全屏特效层对象
        containEffectLayer : <cc.Node> 战场大小的特效层
        leftEffectLayer    : <cc.Node> 以左边单位为基础的特效层对象
        rightEffectLayer   : <cc.Node> 以右边单位为基础的特效层对象
        labelLayer         : <cc.Node> 用于显示战斗相关label的层对象
        topEffectLayer     : <cc.Node> 顶层特效层对象
    }
]]
function BattleLayerContext:ctor(initData)
    self._layer = initData.layer
    self._actionLayer = initData.actionLayer
    self._fullEffectLayer = initData.fullEffectLayer
    self._containEffectLayer = initData.containEffectLayer
    self._leftEffectLayer = initData.leftEffectLayer
    self._rightEffectLayer = initData.rightEffectLayer
    self._labelLayer = initData.labelLayer
    self._topEffectLayer = initData.topEffectLayer
end

function BattleLayerContext:getLayer()
    return self._layer
end

function BattleLayerContext:getActionLayer()
    return self._actionLayer
end

function BattleLayerContext:getFullEffectLayer()
    return self._fullEffectLayer
end

function BattleLayerContext:getContainEffectLayer()
    return self._containEffectLayer
end

function BattleLayerContext:getLeftEffectLayer()
    return self._leftEffectLayer
end

function BattleLayerContext:getRightEffectLayer()
    return self._rightEffectLayer
end

function BattleLayerContext:getLabelLayer()
    return self._labelLayer
end

function BattleLayerContext:getTopEffectLayer()
    return self._topEffectLayer
end

return BattleLayerContext
