BattleHeroFactory = {}

local BattleHeroNode = require('src.entity.battle.BattleHeroNode')
local BattleGoddessNode = require('src.entity.battle.BattleGoddessNode')
local BattleDragonNode = require('src.entity.battle.BattleDragonNode')

--[[
    initData : 英雄的初始化数据
    {
        hero_id    : <int>    英雄的类型
        fashion_id : <int>    英雄的皮肤ID
        hp         : <int>    英雄血量
        max_hp     : <int>    英雄的最大血量
        energy     : <int>    英雄的能量值
        max_energy : <int>    英雄的最大能量值
        element    : <int>    英雄的元素标识
        level      : <int>    英雄的等级
        star       : <int>    英雄的星级
    }
]]
BattleHeroFactory.create = function(initData)
    return BattleHeroNode.new(initData)
end

--[[
    initData : 女神的初始化数据
    {
        hero_id    : <int>    女神的类型
        energy     : <int>    女神的能量值
        max_energy : <int>    女神的最大能量值
        level      : <int>    女神的等级
    }
]]
BattleHeroFactory.createGoddess = function(initData)
    return BattleGoddessNode.new(initData)
end

--[[
    initData : 圣龙的初始化数据
    {
        hero_id    : <int>    圣龙的类型
        level      : <int>    圣龙的等级
    }
]]
BattleHeroFactory.createDragon = function(initData)
    return BattleDragonNode.new(initData)
end
