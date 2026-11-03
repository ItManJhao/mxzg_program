BattleUtils = {}

local HEIGHT_SCALE_MAP = {
    {max = 640, scale = 1.0},
    {max = 768, scale = 0.9},
    {max = 960, scale = 0.8},
    {max = 1280, scale = 0.75}
}

--[[
    index     : 战斗对象的索引位置
    layerSize : 用来计算位置的容器的宽高
]]
BattleUtils.getHeroPosition = function(index, layerSize)
    local HEIGHT_SCALE = 1.0
    for k,v in ipairs(HEIGHT_SCALE_MAP) do
        if layerSize.height <= v.max then
            HEIGHT_SCALE = v.scale
            break
        end
    end

    local VIEWPORT_SIZE = cc.size(
        1.0 * layerSize.width,
        HEIGHT_SCALE * layerSize.height
    )
    local ORIGIN_OFFSET = cc.p(0.0, 0.02 * VIEWPORT_SIZE.height)
    local SPACE_RATIO = cc.p(-0.03, 0.0)

    local COLUMN_BASE_1 = 0.4
    local COLUMN_BASE_2 = 0.85

    local H_START_OFFSET = 0.1 * math.max(1.0-HEIGHT_SCALE, 0.0)
    local H_SPACE_OFFSET = 0.1 * math.max(1.0-HEIGHT_SCALE, 0.0)

    local COLUMN_START_Y_LIST = {
        [1] = -0.8 + H_START_OFFSET,
        [2] = -0.8 + H_START_OFFSET
    }

    local COLUMN_SPACE_Y_LIST = {
        [1] = 0.4 + H_SPACE_OFFSET,
        [2] = 0.4 + H_SPACE_OFFSET
    }

    local calcPostFunc = function(ratioPos)
        local originPos = cc.p(
            0.5 * VIEWPORT_SIZE.width + ORIGIN_OFFSET.x,
            0.5 * VIEWPORT_SIZE.height + ORIGIN_OFFSET.y - 10
        )

        local pos = cc.p(
            (0.5 * ratioPos.x + SPACE_RATIO.x) * VIEWPORT_SIZE.width,
            (0.5 * ratioPos.y + SPACE_RATIO.y) * VIEWPORT_SIZE.height
        )
        
        return cc.pAdd(originPos, pos)
    end

    local calcYSpace = function(col, i)
        return COLUMN_START_Y_LIST[col] + ((i-1) * COLUMN_SPACE_Y_LIST[col])
    end
    
    local posList = {
        -- column 1
        [1] = calcPostFunc(cc.p(COLUMN_BASE_1, calcYSpace(1, 1))),
        [2] = calcPostFunc(cc.p(COLUMN_BASE_1, calcYSpace(1, 2))),
        [3] = calcPostFunc(cc.p(COLUMN_BASE_1, calcYSpace(1, 3))),
        [4] = calcPostFunc(cc.p(COLUMN_BASE_1, calcYSpace(1, 4))),

        -- column 2
        [5] = calcPostFunc(cc.p(COLUMN_BASE_2, calcYSpace(2, 1))),
        [6] = calcPostFunc(cc.p(COLUMN_BASE_2, calcYSpace(2, 2))),
        [7] = calcPostFunc(cc.p(COLUMN_BASE_2, calcYSpace(2, 3))),
        [8] = calcPostFunc(cc.p(COLUMN_BASE_2, calcYSpace(2, 4)))
    }

    local res = clone(posList[index] or cc.p(0,0))
    res.x = layerSize.width - res.x

    return res
end

--[[
    计算女神的位置
]]
BattleUtils.getGoddessPosition = function(layerSize)
    local HEIGHT_SCALE = 1.0
    for k,v in ipairs(HEIGHT_SCALE_MAP) do
        if layerSize.height <= v.max then
            HEIGHT_SCALE = v.scale
            break
        end
    end

    local bgSize = clone(layerSize)

    local x = bgSize.width * 1 - 120
    local y = bgSize.height * HEIGHT_SCALE + 30

    x = layerSize.width - x
    
    return cc.p(x, y)
end

--[[
    计算圣龙的位置
]]
BattleUtils.getDragonPosition = function(layerSize)
    local HEIGHT_SCALE = 1.0
    for k,v in ipairs(HEIGHT_SCALE_MAP) do
        if layerSize.height <= v.max then
            HEIGHT_SCALE = v.scale
            break
        end
    end

    local bgSize = clone(layerSize)

    local x = bgSize.width * 1
    local y = bgSize.height * HEIGHT_SCALE - 40

    x = layerSize.width - x
    
    return cc.p(x, y)
end

--[[
    计算挂机位置

    index     : 战斗对象的索引位置
    layerSize : 用来计算位置的容器的宽高
    isMirror  : 用来控制英雄显示在中点的哪一边，如果为true，则在左边，否则在右边(默认)
]]
BattleUtils.getHangHeroPosition = function(index, layerSize, isMirror)
    -- 左右
    local bg_size = clone(layerSize)
    
    bg_size.height = bg_size.height * 0.9;

    -- 列间隔
    local index_x = index
    
    -- 第一列距离地图中间的长度
    local hero_offset = bg_size.width * 0.15
    local x = bg_size.width * 0.5

    local offsetX = 0.0
    local offsetY = 0.0
    if isMirror then
        local baseX = bg_size.width * 0.22
        offsetX = -baseX * (1+math.floor(index / 2)) * 1.1
        if index > 1 then
            offsetY = bg_size.height * 0.2 * (index % 2 == 0 and 1 or -1)
        end
    else
        local baseX = bg_size.width * 0.1
        offsetX = baseX + index_x * hero_offset
    end

    local pos = {}
    
    pos.x = x + offsetX + (isMirror and bg_size.width * 0.2 or 0)
    pos.y = bg_size.height * 0.5 + offsetY - 20

    return pos
end

--[[
    计算圣龙技能位置
]]
BattleUtils.getHeroAttackPosition = function(index, layerSize, isMirror)
end

--[[
    计算近战攻击的位置

    position : <{x,y}> 被攻击的英雄的位置
    isMirror : <boolean> 用来控制英雄显示在哪一边，如果为true，则在左边，否则在右边(默认)
]]
BattleUtils.getHeroAttackPosition = function(position, isMirror)
    local factor = isMirror and -1 or 1
    return cc.p(
        position.x + -100*factor,
        position.y
    )
end
