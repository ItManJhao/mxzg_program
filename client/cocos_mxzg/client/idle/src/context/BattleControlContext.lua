local BattleControlContext = class('BattleControlContext')

--[[
    战斗控制上下文

    initData:
    {
        isBackground : <bool> 是否出在后台播放状态
    }
]]
function BattleControlContext:ctor(initData)
    self._isBackground = initData.isBackground
    self._eventHandler = initData.eventHandler
end

function BattleControlContext:setBackground(isBackground)
    self._isBackground = isBackground
end

function BattleControlContext:isBackground()
    return self._isBackground
end

function BattleControlContext:getEventHandler()
    return self._eventHandler
end

return BattleControlContext
