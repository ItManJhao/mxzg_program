local BattleGoddessData = class('BattleGoddessData')

--[[
    英雄所属队伍的定义
]]
BattleGoddessData.TeamType = {
    Player = 1,
    Enemy  = 2
}

--[[
    initData:
    {
        id           : 英雄的唯一ID
        team         : 英雄所属团队。参考BattleGoddessData.TeamType
        position     : <{x,y}> 英雄所在位置
        goddessNode  : 英雄的可视化对象
    }
]]
function BattleGoddessData:ctor(initData)
    self._id            = initData.id
    self._team          = initData.team
    self._position      = initData.position
    self._goddessNode   = initData.goddessNode
end

function BattleGoddessData:getId()
    return self._id
end

function BattleGoddessData:getTeam()
    return self._team
end

function BattleGoddessData:getPosition()
    return self._position
end

function BattleGoddessData:getBattleNode()
    return self._goddessNode
end

function BattleGoddessData:setBattleNode(node)
    self._goddessNode = node
end

return BattleGoddessData
