local UIFastTMXHexSelect = class("UIFastTMXHexSelect", function ( ... )
    return cc.Node:create(...)
end)

UIFastTMXHexSelect.TYPE_NONE = 0        -- 空
UIFastTMXHexSelect.TYPE_ERROR = 4       -- 选中了障碍物。红点带有禁止标识符
UIFastTMXHexSelect.TYPE_GENERAL = 5     -- 选中一般的格式。显示黄色
UIFastTMXHexSelect.TYPE_WARNING = 6     -- 红色

-- 边缘顺序
-- 1，2
-- 3，4
-- 5，6

-- local TileRangeData = {
--     [0] = {0,0,0,0,0,0},    -- 无
--     [1] = {1,1,1,1,0,0},    -- 缺少下面两个斜杆
--     [2] = {1,0,1,0,1,1},    -- 缺少右上，右中
--     [3] = {0,1,0,1,1,1},    -- 缺少左上，左中
--     [4] = {1,0,1,0,1,0},    -- 缺少右上，右中，右下
--     [5] = {1,1,1,0,0,0},    -- 缺少左下，右中，右下
--     [6] = {1,1,0,1,0,0},    -- 缺少左中，左下，右下
--     [7] = {0,1,0,1,0,1},    -- 缺少左中，左下，左上
--     [8] = {0,0,0,1,1,1},    -- 缺少左中，左上，右上
--     [9] = {0,0,1,0,1,1},    -- 缺少左上，右上，右中
--     [10] = {1,1,1,1,1,1},    -- 全部都有
-- }

-- local TilePosData = {
--     [1] = {cc.p(0, 0)},
--     [3] = {cc.p(0, 0), cc.p(-60, -90), cc.p(60, -90)},
--     [7] = {cc.p(0, 0), cc.p(-120, 0), cc.p(-60, 90), cc.p(60, 90), cc.p(120, 0), cc.p(60, -90), cc.p(-60, -90)},
-- }

-- local pos_list = {
--     cc.p(0, 1),
--     cc.p(1, 1),
--     cc.p(-1, 0),
--     cc.p(1, 0),
--     cc.p(0, -1),
--     cc.p(1, -1),
-- }


function UIFastTMXHexSelect:ctor()
    self.type = UIFastTMXHexSelect.TYPE_NONE
    self:setCascadeOpacityEnabled(true)
end

-- type : 1
function UIFastTMXHexSelect:setType(type, building_level, outline)
    if self.type == type then
        return
    end

    self:removeAllChildren()

    self:stopAllActions()
    self:setOpacity(255)
    local action_fade = cc.Sequence:create(cc.FadeTo:create(1, 70), cc.FadeTo:create(1, 255))
    self:runAction(cc.RepeatForever:create(action_fade))


    local file_name = nil
    if type == UIFastTMXHexSelect.TYPE_GENERAL then
        file_name = "crusade-group-map/s5.png"
    elseif type == UIFastTMXHexSelect.TYPE_WARNING then
        file_name = "crusade-group-map/s4.png"
    elseif type == UIFastTMXHexSelect.TYPE_ERROR then
        file_name = "crusade-group-map/s4.png"
    end


    if type == UIFastTMXHexSelect.TYPE_ERROR then
        local spr_select = cc.Sprite:createWithSpriteFrameName(file_name)
        self:addChild(spr_select)
    else
        -- -- 这里写死
        -- local tile_list = {}
        -- if building_level <= 5 then
        --     tile_list = {10}
        -- elseif building_level <= 7 then
        --     tile_list = {1, 2, 3}
        -- elseif building_level <= 8 then
        --     tile_list = {0, 4, 5, 6, 7, 8, 9}
        -- end

        -- local pos_list = TilePosData[#tile_list]

        -- for i,v in ipairs(tile_list) do
        --     local pos = pos_list[i]
        --     -- 使用时才创建。避免地图生成速度过慢
        --     local spr_centre = cc.Sprite:createWithSpriteFrameName(string.format("crusade-group-map/s%d.png", type))
        --     spr_centre:setPosition(pos.x, pos.y)
        --     self:addChild(spr_centre)

        --     -- 修改的话。需要同步更改UIFastTMXHexTile
        --     for ii,vv in ipairs(TMXMapLightData) do
        --         local lightData = TileRangeData[v][ii]
        --         if lightData ~= 0 then
        --             local spr_light = cc.Sprite:createWithSpriteFrameName(string.format("crusade-group-map/s%d-%d.png", type, vv.img))
        --             spr_light:setPosition(pos.x, pos.y)
        --             spr_light:setRotation(vv.r)
        --             spr_light:setAnchorPoint(vv.a)
        --             spr_light:setFlippedX(vv.fx)
        --             spr_light:setFlippedY(vv.fy)
        --             self:addChild(spr_light)
        --         end
        --     end
        -- end

        local r = 1
        local vec_tile = {}
        
        -- 这里写死
        if building_level <= 5 then
            -- vec_tile = Maths.getHexRangeByRadius(0, 0, 0, nil)
            vec_tile = Maths.getHexRangeByRadius(0, 0, outline and 1 or 0, outline and 0 or nil)
        elseif building_level <= 7 then
            if outline then
                local vec_tile1 = Maths.getHexRangeByRadius(0, 0, 1, nil)
                local vec_tile2 = Maths.getHexRangeByRadius(0, -1, 1, nil)
                local vec_tile3 = Maths.getHexRangeByRadius(1, -1, 1, nil)
    
                -- 修正坐标。不想想算法了
                for i,v in ipairs(vec_tile2) do
                    v.x = v.x + ctr.crusade_group.data:getTileIndexOffset(v.y - 1)
                end
    
                for i,v in ipairs(vec_tile3) do
                    v.x = v.x + ctr.crusade_group.data:getTileIndexOffset(v.y - 1)
                end
    
                TableEx.insertAndUnique(vec_tile, vec_tile1, function(s, d)
                    return s.x == d.x and s.y == d.y
                end)
    
                TableEx.insertAndUnique(vec_tile, vec_tile2, function(s, d)
                    return s.x == d.x and s.y == d.y
                end)
    
                TableEx.insertAndUnique(vec_tile, vec_tile3, function(s, d)
                    return s.x == d.x and s.y == d.y
                end)

                -- 删除三个格子
                TableEx.removeTableData(vec_tile, function(value)
                    return (value.x == 0 and value.y == 0) or 
                            (value.x == 0 and value.y == -1) or 
                            (value.x == 1 and value.y == -1) 
                end)
            else
                vec_tile = {
                    cc.p(0, 0),
                    cc.p(0, -1),
                    cc.p(1, -1),
                }
            end
        elseif building_level <= 8 then
            vec_tile = Maths.getHexRangeByRadius(0, 0, outline and 2 or 1, outline and 1 or nil)
            -- vec_tile = Maths.getHexRangeByRadius(0, 0, 3, 1)
        end

        for i,v in ipairs(vec_tile) do
            local pos_list = {
                cc.p(v.x + ctr.crusade_group.data:getTileIndexOffset(v.y), v.y + 1),
                cc.p(v.x + 1 + ctr.crusade_group.data:getTileIndexOffset(v.y), v.y + 1),
                cc.p(v.x-1, v.y),
                cc.p(v.x+1, v.y),
                cc.p(v.x + ctr.crusade_group.data:getTileIndexOffset(v.y) , v.y - 1),
                cc.p(v.x + 1 + ctr.crusade_group.data:getTileIndexOffset(v.y) , v.y - 1),
            }

            local lightData = {}
            for ii,vv in ipairs(pos_list) do
                lightData[ii] = TableEx.findValueFunction(vec_tile, function(value)
                    return value.x == vv.x and value.y == vv.y
                end)
            end
            
            local pos = cc.p(v.x * 120 + ctr.crusade_group.data:getTileIndexOffset(v.y) * 60, v.y * 90)
            self:addLightSprite(lightData, pos.x, pos.y, type)
        end
    end
end


function UIFastTMXHexSelect:addLightSprite(data, x, y, type)
    self.spr_light = cc.Sprite:createWithSpriteFrameName(string.format("crusade-group-map/s%d.png", type))
    self.spr_light:setPosition(x, y)
    self:addChild(self.spr_light)

    -- 修改的话。需要同步更改UIFastTMXHexSelect
    for i,v in ipairs(TMXMapLightData) do
        local lightData = data[i]
        if lightData == nil then
            local spr_light = cc.Sprite:createWithSpriteFrameName(string.format("crusade-group-map/s%d-%d.png", type, v.img))
            spr_light:setPosition(x, y)
            spr_light:setRotation(v.r)
            spr_light:setAnchorPoint(v.a)
            spr_light:setFlippedX(v.fx)
            spr_light:setFlippedY(v.fy)
            self:addChild(spr_light)
        end
    end
end



return UIFastTMXHexSelect