local CrusadeGroupMapThumbnailLayer = class("CrusadeGroupMapThumbnailLayer", require("src.comp.EventLayerAdaptiveWidthFull"))


function CrusadeGroupMapThumbnailLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/cloud-1.pvr.ccz", plist_name = "ccbi-res/cloud-1.plist", remove_type=2},
    }
    return vec_image
end

function CrusadeGroupMapThumbnailLayer:onCreate()
    self.thumbnail_size = cc.size(285, 256)
    self.begin_pos = cc.p(48, 30)
    self.touch_callback = nil
    self.map_size = cc.size(0, 0)
    self.tile_size = cc.size(0, 0)
    self.map_layer = nil
    self.begin_pos_draw = cc.p(self.spr_map:getPositionX() - self.spr_map:getContentSize().width  * 0.5 * self.spr_map:getScaleX() + self.begin_pos.x,
                               self.spr_map:getPositionY() - self.spr_map:getContentSize().height * 0.5 * self.spr_map:getScaleY() + self.begin_pos.y)

    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(false)
    self.listener_touch:registerScriptHandler(function(touch, event)
        self.touch_position = touch:getLocation()
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.listener_touch:registerScriptHandler(function()
    end, cc.Handler.EVENT_TOUCH_MOVED)

    self.listener_touch:registerScriptHandler(function(touch, event)
        local touch_position = touch:getLocation()
        if math.abs(touch_position.x - self.touch_position.x) >= 5 or math.abs(touch_position.y - self.touch_position.y) >= 5 then
            return
        end

        local pos = self.spr_map:convertToNodeSpace(touch_position)
        -- 判断范围是否是点击到了地图
        if pos.x < self.begin_pos.x or pos.x > self.begin_pos.x + self.thumbnail_size.width or pos.y < self.begin_pos.y or pos.y > self.begin_pos.y + self.thumbnail_size.height then
            return
        end

        -- 计算百分比。传递到上级界面
        local x = (pos.x - self.begin_pos.x) / self.thumbnail_size.width
        local y = (pos.y - self.begin_pos.y) / self.thumbnail_size.height
        -- print(x, y)
        self.touch_callback(x, y)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    local event_dispatcher = self.spr_map:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, self.spr_map)

    self:registerTouchListen()

    -- 创建绘画节点
    self.draw_node_focus = cc.DrawNode:create()
    self:addChild(self.draw_node_focus)   

    self.draw_data = {}
    self.draw_node = cc.DrawNode:create()
    self:addChild(self.draw_node)
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_THUMBNAIL_DRAW, handler(self, self.updateDraw))
    
    self.scroll_view:setItemType(1)
    self.scroll_view:setItemSize(cc.size(270, 40))
    self.scroll_view:setResetOffset(true)
    self:updateMarkList()

    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_MARK, handler(self, self.updateMarkList))
    ctr.crusade_group:reqViewSmallMap()

    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_THUMBNAIL_FOCUS, handler(self, self.updateFocus))
end

function CrusadeGroupMapThumbnailLayer:setMapSize(size)
    self.map_size = size
end

function CrusadeGroupMapThumbnailLayer:setTileSize(size)
    self.tile_size = size
end

function CrusadeGroupMapThumbnailLayer:setMapLayer(layer)
    self.map_layer = layer
end

function CrusadeGroupMapThumbnailLayer:registerTouchListen()
    local touch_node = cc.Node:create()
	self:addChild(touch_node, -9999999)

    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(true)
    self.listener_touch:registerScriptHandler(function(touch, event)
        -- self.touch_began_inside = self:isTouchInside(touch)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.listener_touch:registerScriptHandler(function()
    end, cc.Handler.EVENT_TOUCH_MOVED)

    self.listener_touch:registerScriptHandler(function(touch, event)
        if self:isTouchInside(touch) == false then
            self:removeFromParent()
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)

    local event_dispatcher = touch_node:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, touch_node)
end

function CrusadeGroupMapThumbnailLayer:setTouchCallback(callback)
    self.touch_callback = callback
end

function CrusadeGroupMapThumbnailLayer:updateMarkList()
    self.scroll_view.createItemFunction = function(data)
        local cell = require("src.layer.crusadegroup.map.CrusadeGroupMapThumbnailCell"):createWithCCBIFile("ccbi/CrusadeGroupMapThumbnailCell.ccbi")
        cell:reset(data)
        return cell
    end
    self.scroll_view:reloadData(ctr.crusade_group.data.game_data.territory_mark)
    
    self.lbl_mark_tip:setVisible(#ctr.crusade_group.data.game_data.territory_mark <= 0)
    self.lbl_mark_num:setString(string.format("%d/%d", #ctr.crusade_group.data.game_data.territory_mark, ex.Tools:getSysCfg("crusade_group_coordinate")))
end

function CrusadeGroupMapThumbnailLayer:updateLayer()
    self:updateDraw(nil, ctr.crusade_group.data.map_thumbnail_data)
    self:updateFocus()

    for i=2,4 do
        local spr = self["spr_lock"..i]
        if spr then
            spr:setVisible(ctr.crusade_group.data.area_level <= i)
        end
    end
end

function CrusadeGroupMapThumbnailLayer:updateFocus()
    self.draw_node_focus:clear()
    local pos_focus, view_size, scale = self.map_layer:getViewFocus()
    local begin_pos = cc.p((pos_focus.x - view_size.width * 0.5 / scale) / self.map_layer.map:getMapSize().width  * self.thumbnail_size.width + self.begin_pos_draw.x,
                           (pos_focus.y - view_size.height * 0.5 / scale) / self.map_layer.map:getMapSize().height * self.thumbnail_size.height + self.begin_pos_draw.y)
    local end_pos = cc.p((pos_focus.x + view_size.width * 0.5 / scale) / self.map_layer.map:getMapSize().width  * self.thumbnail_size.width + self.begin_pos_draw.x,
                         (pos_focus.y + view_size.height * 0.5 / scale) / self.map_layer.map:getMapSize().height * self.thumbnail_size.height + self.begin_pos_draw.y)

    self.draw_node_focus:drawRect(begin_pos, end_pos, cc.c4f(1, 1, 1, 1))
end

function CrusadeGroupMapThumbnailLayer:updateDraw(event, data)

    local map_size = self.map_layer.map:getMapSize()

    for k, v in pairs(data) do
        local is_draw = self.draw_data[k]
        if is_draw == nil then
            self.draw_data[k] = true

            local pos = self.map_layer.map:getPositionByIdx(k)
            pos.x = pos.x / map_size.width * self.thumbnail_size.width
            pos.y = pos.y / map_size.height * self.thumbnail_size.height
            if v.id == ex.Player.role_id then
                -- print("111")
                self.draw_node:drawPoint(cc.p(self.begin_pos_draw.x + pos.x, self.begin_pos_draw.y + pos.y), 6, cc.c4f(1, 1, 1, 1))
            -- elseif v.id == 1 then
                -- self.draw_node:drawPoint(cc.p(self.begin_pos_draw.x + pos.x, self.begin_pos_draw.y + pos.y), 3 / self:getScaleX(), cc.c4f(0, 0.9, 0.823, 1))
            else
                self.draw_node:drawPoint(cc.p(self.begin_pos_draw.x + pos.x, self.begin_pos_draw.y + pos.y), 6, cc.c4f(0, 0.9, 0.823, 1))
            end
        end
    end
end

return CrusadeGroupMapThumbnailLayer