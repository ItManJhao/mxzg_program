local CrusadeGroupMapLayer = class("CrusadeGroupMapLayer", require("src.comp.EventLayer"))

local UIFastTMXHexBuilding = require("src.comp.UIFastTMXHexBuilding")
local UIFastTMXHexTile = require("src.comp.UIFastTMXHexTile")
local UIFastTMXHexTileUI = require("src.comp.UIFastTMXHexTileUI")

function CrusadeGroupMapLayer:onCreate()
    local sfc = cc.SpriteFrameCache:getInstance() 
    sfc:addSpriteFrames("ccbi-res/crusade-group-map.plist")
    sfc:addSpriteFrames("ccbi-res/tile-building.plist")

    self.ben_x = 0
    self.end_x = 0
    self.ben_y = 0
    self.end_y = 0
    self.show_last_occupation_id = -1

    self.scrollViewDidScrollCallback = nil

    self.map = require("src.comp.UIFastTMXHexLayer"):create()
    self.map:loadWithFile(ctr.crusade_group.data.map_config, "ccbi-res/tile.png")
    self.map:setTouchCallBack(handler(self, self.onTouchTile))
    self.map:setTileChangeCallback(handler(self, self.mapTileChange))
    self.map:setCreateBuildingCallback(handler(self, self.createBuilding))
    self.map:setCreateTileCallback(handler(self, self.createTile))
    self.map:setCreateUICallback(handler(self, self.createUI))

    -- 设置滑动视图属性
    self.map:setPositionX(-self.map:getTileSize().width * 0.5)
    self.scroll_view:getContainer():addChild(self.map)
    self.scroll_view:setContentSize(cc.size(self.map:getMapSize().width - self.map:getTileSize().width, self.map:getMapSize().height))

    self.scroll_view:setMinScale(0.5)
    self.scroll_view:setMaxScale(1)

    self.scroll_view:setShowMinScale(0.5)
    self.scroll_view:setShowMaxScale(1)
    self.scroll_view:setMoveSpeed(0.7)

    self.scroll_view:setDelegate()
    self.scroll_view:registerScriptHandler(handler(self, self.scrollViewDidScroll), cc.SCROLLVIEW_SCRIPT_SCROLL) --滚动时的回掉函数

    -- 添加格子功能面板
    self.tileInfoLayer = require("src.layer.crusadegroup.map.CrusadeGroupTileInfoLayer"):createWithCCBIFile("ccbi/CrusadeGroupTileInfoLayer.ccbi")
    self.tileInfoLayer:setTileSize(self.map:getMapTileSize())
    self.tileInfoLayer:setVisible(false)
    self:addChild(self.tileInfoLayer)

    -- 添加选中状态精灵
    self.spr_select = require("src.comp.UIFastTMXHexSelect"):create()
    self.scroll_view:getContainer():addChild(self.spr_select)

    self.astar = require("src.model.AStar"):create()
    self.astar.width = self.map:getMapTileSize().width
    self.astar.height = self.map:getMapTileSize().height
    self.astar.find_callback = handler(self, self.tileFind)
    self.astar.search_callback = handler(self, self.tileSearch)

    ctr.crusade_group.data:updateLinkPath()
    ctr.crusade_group:refreshAllMapData()

    self:onShowLastTile()

    self:addEvent(EVENT.CRUSADE_GROUP.UPDATA_TILE, handler(self, self.updateTileData))
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATA_TILE_ALL, handler(self, self.updateAllTile))
    self:addEvent(EVENT.CRUSADE_GROUP.SET_MAP_FOCUS, handler(self, self.setFocusWithIdx))
    self:addEvent(EVENT.CRUSADE_GROUP.SET_MAP_FOCUS_PERCENT_ANIM, handler(self, self.setFocusWithPercentAnim))
    self:addEvent(EVENT.CRUSADE_GROUP.SET_MAP_FOCUS_ID_ANIM, handler(self, self.setFocusWithIdAnim))
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_GIVEUP, handler(self, self.updateGiveup))
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_GIVEUP_REVOKE, handler(self, self.updateGiveupRevoke))
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATA_TILE_SELECT, handler(self, self.updateTileSelect))
    self:addEvent(EVENT.CRUSADE_GROUP.RUN_OCCUPY_EFFECT, handler(self, self.runOccupyEffect))
    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_MAP_CUR_PAGE, handler(self, self.refreshCurMapData))
    self:addEvent(EVENT.CRUSADE_GROUP.MAIN_INFO, handler(self, self.showLastTile))
end

function CrusadeGroupMapLayer:setScrollViewDidScrollCallback(callback)
    self.scrollViewDidScrollCallback = callback
end

function CrusadeGroupMapLayer:createBuilding(data, x, y)
    local spr_tile = UIFastTMXHexBuilding:create(string.format("tile-building/%d.png", data.img))
    spr_tile:setAnchorPoint(data.anchor)
    spr_tile:setImg(data.img)

    self:updateBuilding(spr_tile, x, y)
    return spr_tile
end

function CrusadeGroupMapLayer:createTile(img, rect, x, y)
    local spr_tile = UIFastTMXHexTile:create(img, rect)

    self:updateTile(spr_tile, x, y)
    return spr_tile
end

function CrusadeGroupMapLayer:createUI( )
    return UIFastTMXHexTileUI:create()
end

function CrusadeGroupMapLayer:updateBuilding(spr_tile, x, y)
    local tile_id = ctr.crusade_group.data:convertPosToGridId(x, y)
    if ctr.crusade_group.data.area_level < cfg.crusadegrouptilelevel.getAreaLevel(tile_id)  then
        spr_tile:setColor(cc.c3b(125, 125, 125))
    else
        spr_tile:setColor(cc.c3b(255, 255, 255))
    end

    local main_idx = self.map:getMainGroupIdx(tile_id)
    local map_data = ctr.crusade_group.data.map_data[main_idx]
    if tile_id == main_idx and map_data and map_data.occupied_id == 1 and cfg.crusadegrouptilelevel.getFightType(main_idx) == 3 then
        ex.Tools:setSpriteFrame(spr_tile, spr_tile:getImg() + 1000)
    end
end

function CrusadeGroupMapLayer:updateTile(spr_tile, x, y)
    local map_size = self.map:getMapTileSize()

    local tile_id = y * map_size.width + x + 1

    -- 判断是否有迷雾
    if ctr.crusade_group.data.area_level < cfg.crusadegrouptilelevel.getAreaLevel(tile_id)  then
        spr_tile:setColor(cc.c3b(125, 125, 125))
    else
        spr_tile:setColor(cc.c3b(255, 255, 255))
    end

    local main_idx = self.map:getMainGroupIdx(tile_id)
    local map_data = ctr.crusade_group.data.map_data[main_idx]
    if map_data then
        local pos_list = {
            x + 1 + self.map:getTileIndexOffset(y + 1) + (y + 1) * map_size.width,
            x + 2 + self.map:getTileIndexOffset(y + 1) + (y + 1) * map_size.width,
            x + y * map_size.width,
            x + 2 + y * map_size.width,
            x + 1 + self.map:getTileIndexOffset(y - 1) + (y - 1) * map_size.width,
            x + 2 + self.map:getTileIndexOffset(y - 1) + (y - 1) * map_size.width,
        }

        local lightData = {}
        for i=1,6 do
            lightData[i] = ctr.crusade_group.data.map_data[self.map:getMainGroupIdx(pos_list[i])]
        end

        local light_type = ctr.crusade_group.data.map_link_path[main_idx] and 1 or 3
        local centet_type = map_data.occupied_id == ex.Player.role_id and 1 or 3
        if map_data.occupied_id == 1 then
            light_type = 6
            centet_type = 6
        end
        spr_tile:setLight(true, lightData, centet_type, light_type)

        local node_ui = self.map:getOrCreateUINode(x, y)

        -- 显示收菜，不做按钮。在点击格子时判断是否收菜
        node_ui:showCollect(tile_id == map_data.id and map_data.occupied_id == ex.Player.role_id and ctr.crusade_group.data.can_acquisition)

        if tile_id == 6020 then
            print("11")
        end
        -- 显示占领元素
        node_ui:showElem(tile_id == map_data.id and map_data.hero_id > 0 and map_data.element or 0)

        -- 显示驻扎信息 只有空地才能驻扎
        -- node_ui:showStation(true, "测试")

        -- 占领特效
        -- node_ui:runOccupyEffect()

    elseif spr_tile:isLight() then  -- 提升效率
        spr_tile:setLight(false)
    end

    if tile_id == main_idx and cfg.crusadegrouptilelevel.getFightType(main_idx) == 3 then
        local node_ui = self.map:getOrCreateUINode(x, y)
        node_ui:showSpine(true)
    end
end

function CrusadeGroupMapLayer:updateTileData(event, data)
    for k,v in pairs(data.territory) do
        local tile = self.map:getTileByIdx(v.id)
        if tile then
            local x, y = self.map:getPosByIdx(v.id)
            self:updateTile(tile, x, y)
        end
    end
end

function CrusadeGroupMapLayer:updateAllTile(event, list, can_skip)

    can_skip = can_skip and can_skip or true
    local is_skip = true

    if can_skip then
        for k,v in pairs(list) do
            local x, y = ctr.crusade_group.data:convertGridIdToPos(v.id)
            if x >= self.ben_x and x <= self.end_x and y >= self.ben_y and y <= self.end_y then
                is_skip = false
                break
            end
        end
    end

    if is_skip and can_skip == true then
        return
    end

    for i=self.ben_x,self.end_x do
        for j=self.ben_y,self.end_y do
            -- local idx = ctr.crusade_group.data:convertPosToGridId(i, j)
            local tile, building = self.map:getTileAndBuilding(i, j)
            if tile then
                self:updateTile(tile, i, j)
            end

            if building then
                self:updateBuilding(building, i, j)
            end
        end
    end
end

function CrusadeGroupMapLayer:tileFind(astar, root,  ends)
    local idx = root.x + root.y * astar.width + 1
    local map_data = ctr.crusade_group.data.map_data[idx]
    if map_data and map_data.occupied_id == ex.Player.role_id then
        return 1
    end
    return 0
end

function CrusadeGroupMapLayer:tileSearch(astar, root,  ends)
    local map_data = ctr.crusade_group.data
    
    -- 遍历自身周围格子
    local data1 = map_data:getAStarNode(root.x + self.map:getTileIndexOffset(root.y + 1), root.y + 1)
    local data2 = map_data:getAStarNode(root.x + self.map:getTileIndexOffset(root.y + 1) + 1, root.y + 1)
    local data3 = map_data:getAStarNode(root.x - 1, root.y)
    local data4 = map_data:getAStarNode(root.x + 1, root.y)
    local data5 = map_data:getAStarNode(root.x + self.map:getTileIndexOffset(root.y - 1) , root.y - 1)
    local data6 = map_data:getAStarNode(root.x + self.map:getTileIndexOffset(root.y - 1) + 1, root.y - 1)

    astar:checkMove(data1, root, ends, 1, data1.is_move)
    astar:checkMove(data2, root, ends, 1, data2.is_move)
    astar:checkMove(data3, root, ends, 1, data3.is_move)
    astar:checkMove(data4, root, ends, 1, data4.is_move)
    astar:checkMove(data5, root, ends, 1, data5.is_move)
    astar:checkMove(data6, root, ends, 1, data6.is_move)
end

function CrusadeGroupMapLayer:scrollViewDidScroll()
    local pos = self.tileInfoLayer:getShowTilePosition()
    local tile_pos = self.map:getPositionByTile(pos.x, pos.y)
    self.tileInfoLayer:setPosition(self.scroll_view:getContainer():convertToWorldSpace(cc.p(tile_pos.x + self.map:getPositionX(), tile_pos.y + self.map:getPositionY())))

    if self.scrollViewDidScrollCallback then
        self.scrollViewDidScrollCallback()
    end
end

function CrusadeGroupMapLayer:onShowLastTile()
    local last_occupation_id = ctr.crusade_group.data.game_data.last_occupation_id
    if last_occupation_id == -1 then
        return
    end
    self.show_last_occupation_id = last_occupation_id
    self:setFocusWithIdx(nil, ctr.crusade_group.data.game_data.last_occupation_id)
end

function CrusadeGroupMapLayer:showLastTile( )
    if self.show_last_occupation_id > 0 or ctr.crusade_group.data.game_data.last_occupation_id <= 0 then
        return
    end
    
    self:onShowLastTile()
end

function CrusadeGroupMapLayer:setFocusWithIdx(n, idx)
    local tile_pos = self.map:getPositionByIdx(idx)
    self:setFocus(cc.p(tile_pos.x + self.map:getPositionX(), tile_pos.y + self.map:getPositionY()))
end

function CrusadeGroupMapLayer:setFocus(pos)
    local center = self.scroll_view:convertToWorldSpace(cc.p(self.scroll_view:getViewSize().width * 0.5, self.scroll_view:getViewSize().height * 0.5))
    local newCenter = self.scroll_view:getContainer():convertToWorldSpace(pos)
    local offset = self.scroll_view:getContentOffset()

    self.scroll_view:setContentOffset(cc.p(offset.x + (center.x - newCenter.x), offset.y + (center.y - newCenter.y)))
end

function CrusadeGroupMapLayer:setFocusPercent(pos)
    local x = self.scroll_view:getContentSize().width * pos.x
    local y = self.scroll_view:getContentSize().height * pos.y
    self:setFocus(cc.p(x, y))
end

function CrusadeGroupMapLayer:getViewFocus()
    local view_size = self.scroll_view:getViewSize()
    local pos = self.scroll_view:convertToWorldSpace(cc.p(view_size.width * 0.5, view_size.height * 0.5))
    pos = self.scroll_view:getContainer():convertToNodeSpace(pos)
    return pos, view_size, self.scroll_view:getZoomScale()
end

function CrusadeGroupMapLayer:getMapScale()
    return self.scroll_view:getZoomScale()
end

function CrusadeGroupMapLayer:onMapScale(old_scale, scale)
    self.scroll_view:setZoomScale(old_scale + 0.3 * scale)
end

function CrusadeGroupMapLayer:onTouchTile(x, y)
    local tile, building = self.map:getTileAndBuilding(x, y)
    -- 测试选中效果
    x, y = self.map:getGroupMainPosition(x, y)

    local map_size = self.map:getMapTileSize()
    local tile_id = y * map_size.width + x + 1
    local main_idx = self.map:getMainGroupIdx(tile_id)
    local building_level = cfg.crusadegrouptilelevel.getBuildingLevel(main_idx)

    if is_game_controller then
        ex.MessageView:add(string.format("测试-格子id：%d, 区域等级：%d", y * self.map:getMapTileSize().width + x + 1, cfg.crusadegrouptilelevel.getAreaLevel(tile_id)))
    end

    -- 点击了自己的格子。并且可以收菜了
    local tile_data = ctr.crusade_group.data.map_data[main_idx]
    if tile_data and tile_data.occupied_id == ex.Player.role_id and ctr.crusade_group.data.can_acquisition then

        local server_time = ex.Game:getServerTime()
        -- 刷新数据
        local time_diff = (server_time - ctr.crusade_group.data.last_acquisition_time)
        -- ex.MessageView:add(string.format("%d - %d - %d", time_diff, server_time, ctr.crusade_group.data.last_acquisition_time))

        ctr.crusade_group.data.last_acquisition_time_old = ctr.crusade_group.data.last_acquisition_time
        ctr.crusade_group.data.last_acquisition_time = server_time + 1;
        ctr.crusade_group:updateStatus()
        
        -- 发送收菜协议
        NetManager:sendMessage(ProtocolID.GReqCollectResources)

        -- 刷新收菜时间
        NetManager:sendMessage(ProtocolID.GReQCrusadeGroupMain)
        return
    end

    local show_info = self.tileInfoLayer:isShow(x, y)
    local is_obstacle = self.map:getObstacleByPos(x, y)

    if is_obstacle ~= true then
        self.tileInfoLayer:setTimeNumShowFasle()
        -- 请求城镇信息
        local req = CrusadeGroup_pb.GReqViewTerritory()
        req.territory_id = tile_id
        NetManager:sendMessage(ProtocolID.GReqViewTerritory, req)
    end
    
    local tile_pos = self.map:getPositionByTile(x, y)
    self.tileInfoLayer:setVisible(show_info and (not is_obstacle))
    self.tileInfoLayer:setPosition(self.scroll_view:getContainer():convertToWorldSpace(cc.p(tile_pos.x + self.map:getPositionX(), tile_pos.y + self.map:getPositionY())))

    if show_info then
        self.tileInfoLayer:setShowTilePosition(x, y)
        self.tileInfoLayer:updateLayer()
    else
        self.tileInfoLayer:setShowTilePosition(-1, -1)
    end

    self.spr_select:setPosition(cc.p(tile_pos.x + self.map:getPositionX(), tile_pos.y + self.map:getPositionY()))
    self.spr_select:setType(is_obstacle and self.spr_select.TYPE_ERROR or self.spr_select.TYPE_GENERAL, building_level)
    self.spr_select:setVisible(show_info or is_obstacle)
    
    local can_attack = ctr.crusade_group.data:canAttackTile(self.astar, x, y)
    self.tileInfoLayer:setCanAttack(can_attack)
end


function CrusadeGroupMapLayer:refreshCurMapData(event)
    self:mapTileChange(self.ben_x, self.end_x, self.ben_y, self.end_y, true)
end



function CrusadeGroupMapLayer:mapTileChange(ben_x, end_x, ben_y, end_y, is_force)
    if self.ben_x == ben_x and self.end_x == end_x and self.ben_y == ben_y and self.end_y == end_y and (is_force == nil or is_force == false) then
        return
    end

    self.ben_x = ben_x 
    self.end_x = end_x 
    self.ben_y = ben_y 
    self.end_y = end_y

    local refresh_size = ctr.crusade_group.data.map_refresh_page_size
    
    local refresh_ben_x = math.floor(ben_x / refresh_size.width)
    local refresh_end_x = math.floor(end_x / refresh_size.width)
    local refresh_ben_y = math.floor(ben_y / refresh_size.height)
    local refresh_end_y = math.floor(end_y / refresh_size.height)

    local time = ex.Game:getServerTime()
    for i=refresh_ben_x, refresh_end_x do
        for j=refresh_ben_y, refresh_end_y do

            local col = Maths.clampf(i, 0, ctr.crusade_group.data.map_refresh_page_range.width)
            local row = Maths.clampf(j, 0, ctr.crusade_group.data.map_refresh_page_range.height)
            local page_idx = row * refresh_size.width + col

            local refresh_data = ctr.crusade_group.data.map_refresh_page_recorder[page_idx]

            -- 強制刷新，或者上一次刷新的時間超過了5分鐘，或者没有刷新过。或者上一次刷新没有回复并超过了5秒
            if is_force or refresh_data == nil or time - refresh_data.time >= 300  or (refresh_data.is_recv ~= true and time - refresh_data.time > 5) then
                ctr.crusade_group.data.map_refresh_page_recorder[page_idx] = {is_recv = false, time = time}

                -- 出血
                local begin_pos = cc.p(col * refresh_size.width - 5, row * refresh_size.height - 5)
                local end_pos = cc.p(begin_pos.x + refresh_size.width + 5, begin_pos.y + refresh_size.height + 5)

                begin_pos.x = Maths.clampf(begin_pos.x , 0, ctr.crusade_group.data.map_size.width - 1)
                begin_pos.y = Maths.clampf(begin_pos.y , 0, ctr.crusade_group.data.map_size.height - 1)
                end_pos.x = Maths.clampf(end_pos.x , 0, ctr.crusade_group.data.map_size.width - 1)
                end_pos.y = Maths.clampf(end_pos.y , 0, ctr.crusade_group.data.map_size.height - 1)

                local req_map = CrusadeGroup_pb.GReqMapData()
                req_map.mark_id = page_idx
                req_map.bottom_left.x = begin_pos.x
                req_map.bottom_left.y = begin_pos.y
                req_map.upper_right.x = end_pos.x
                req_map.upper_right.y = end_pos.y
                NetManager:sendMessage(ProtocolID.GReqMapData, req_map)
            end
        end
    end
end

function CrusadeGroupMapLayer:runOccupyEffect(event, idx)
    local building_level = cfg.crusadegrouptilelevel.getBuildingLevel(self.map:getMainGroupIdx(idx))

    local node_ui = self.map:getOrCreateUINode(self.map:getPosByIdx(idx))
    node_ui:runOccupyEffect(Maths.section(building_level, {0,5,1}, {6,7,3}, {8,9,7}))
end

function CrusadeGroupMapLayer:setFocusWithPercentAnim(event, x, y)
    ex.MainSceneCtr:runCloudAnimation(0.5, function()
        self:setFocusPercent(cc.p(x, y))
    end)
end

function CrusadeGroupMapLayer:setFocusWithIdAnim(event, idx)
    ex.MainSceneCtr:runCloudAnimation(0.5, function()
        self:setFocusWithIdx(nil, idx)
    end)
end

function CrusadeGroupMapLayer:updateGiveup()
    local time = ex.Game:getServerTime()
    for k,v in pairs(ctr.crusade_group.data.map_giveup) do
        local x, y = ctr.crusade_group.data:convertGridIdToPos(k)
        local node_ui = self.map:getOrCreateUINode(x, y)
        local time_diff = v.time - time
        if node_ui then
            node_ui:updateGiveup(time_diff)
            if time_diff <= 0 then
                node_ui:showElem(0)
                node_ui:showCollect(false)
            end
        end
    end
end

function CrusadeGroupMapLayer:updateGiveupRevoke(event, idx)
    local x, y = ctr.crusade_group.data:convertGridIdToPos(idx)
    local node_ui = self.map:getOrCreateUINode(x, y)
    if node_ui then
        node_ui:updateGiveup(0)
    end
end

function CrusadeGroupMapLayer:updateTileSelect(event, x, y)
    x, y = self.map:getGroupMainPosition(x, y)

    local map_size = self.map:getMapTileSize()
    local tile_id = y * map_size.width + x + 1
    local main_idx = self.map:getMainGroupIdx(tile_id)
    local building_level = cfg.crusadegrouptilelevel.getBuildingLevel(main_idx)

    local tile_pos = self.map:getPositionByTile(x, y)
    self.spr_select:setPosition(cc.p(tile_pos.x + self.map:getPositionX(), tile_pos.y + self.map:getPositionY()))
    self.spr_select:setType(self.spr_select.TYPE_WARNING, building_level, true)

    -- self.spr_select:setVisible(true)
end

return CrusadeGroupMapLayer