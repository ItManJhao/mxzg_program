local BattleHeroData = class('BattleHeroData')

--[[
    英雄所属队伍的定义
]]
BattleHeroData.TeamType = {
    Player = 1,
    Enemy  = 2
}

--[[
    initData:
    {
        id           : 英雄的唯一ID
        team         : 英雄所属团队。参考BattleHeroData.TeamType
        index        : 英雄的位置索引
        indexPosition : <{x,y}> 英雄的索引位置，只跟索引有关，与英雄所在队伍无关
        position     : <{x,y}> 英雄所在位置
        heroNode     : 英雄的可视化对象
    }
]]
function BattleHeroData:ctor(initData)
    self._id            = initData.id
    self._team          = initData.team
    self._index         = initData.index
    self._indexPosition = initData.indexPosition
    self._position      = initData.position
    self._bfSize        = initData.bfSize
    self._heroNode      = initData.heroNode
end

function BattleHeroData:getId()
    return self._id
end

function BattleHeroData:getTeam()
    return self._team
end

function BattleHeroData:getIndex()
    return self._index
end

function BattleHeroData:setIndex(index)
    self._index = index
end

function BattleHeroData:getIndexPosition()
    return self._indexPosition
end

function BattleHeroData:setIndexPosition(indexPosition)
    self._indexPosition = indexPosition
end

function BattleHeroData:getPosition()
    if  self._heroNode:getChangePos() ~= nil then
        return self._heroNode:getChangePos()
    end
    return self._position
end

function BattleHeroData:setPosition(position)
    self._position = position
end

function BattleHeroData:getBfSize()
    return self._bfSize
end

function BattleHeroData:setBfSize(bfSize)
    self._bfSize = bfSize
end

function BattleHeroData:getBattleNode()
    return self._heroNode
end

function BattleHeroData:setBattleNode(node)
    self._heroNode = node
end

function BattleHeroData:setFindHeroDataByUnitIdHandler(handler)
    self.findHeroDataByUnitIdHandler = handler
end

function BattleHeroData:getHeroDataByUnitId(unit_id)
    if self.findHeroDataByUnitIdHandler ~= nil then
        return self.findHeroDataByUnitIdHandler(unit_id)
    end
    return nil
end

return BattleHeroData
