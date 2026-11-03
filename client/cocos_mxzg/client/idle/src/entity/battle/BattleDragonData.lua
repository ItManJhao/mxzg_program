local BattleDragonData = class('BattleDragonData')

--[[
    英雄所属队伍的定义
]]
BattleDragonData.TeamType = {
    Player = 1,
    Enemy  = 2
}

--[[
    initData:
    {
        id           : 英雄的唯一ID
        team         : 英雄所属团队。参考BattleDragonData.TeamType
        position     : <{x,y}> 英雄所在位置
        dragonNode  : 英雄的可视化对象
    }
]]
function BattleDragonData:ctor(initData)
    self._id            = initData.id
    self._team          = initData.team
    self._position      = initData.position
    self._dragonNode   = initData.dragonNode
end

function BattleDragonData:getId()
    return self._id
end

function BattleDragonData:getTeam()
    return self._team
end

function BattleDragonData:getPosition()
    return self._position
end

function BattleDragonData:getBattleNode()
    return self._dragonNode
end

function BattleDragonData:setBattleNode(node)
    self._dragonNode = node
end

return BattleDragonData
