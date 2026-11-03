local UIFastTMXHexLayer = class("UIFastTMXHexLayer", require("src.comp.EventLayer"))

local radical3 = 1.7320508075689
local maxDrawNum = 100

local building = {
    [17] = {img=101, anchor=cc.p(0.5, 0.5), gnum=1},
    [18] = {img=102, anchor=cc.p(0.5, 0.5), gnum=1},
    [19] = {img=103, anchor=cc.p(0.5, 0.5), gnum=1},
    [20] = {img=104, anchor=cc.p(0.5, 0.5), gnum=1},
    [21] = {img=105, anchor=cc.p(0.5, 0.445), gnum=1},
    [22] = {img=106, anchor=cc.p(0.5, 0.66), gnum=3},
    [23] = {img=107, anchor=cc.p(0.5, 0.66), gnum=3},
    [24] = {img=108, anchor=cc.p(0.5, 0.482), gnum=7},
}

function UIFastTMXHexLayer:onCreate(...)
    self.isUpdateFinish = true
    self.ben_x = 0
    self.end_x = 0
    self.ben_y = 0
    self.end_y = 0
    
    self.touch_position = cc.p(0, 0)
    self.touch_callback = nil
    self.tile_change_callback = nil

    self.create_tile_callback = nil
    self.create_building_callback = nil
    self.create_ui_callback = nil
end

-- 读取地图文件。地图文件由工具生成。src/config/crusadegroupmap.lua
function UIFastTMXHexLayer:loadWithFile(config, image)    
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/tile.plist")
    
    -- 地图信息
    self._mapInfo = config
    self._mapTileSize = cc.size(self._mapInfo.width, self._mapInfo.height)
    self._tileSize = cc.size(self._mapInfo.tilewidth, self._mapInfo.tileheight)
    self._drawTileType = self._mapInfo.staggerindex == "odd" and 1 or 2
    -- self._sideLength = math.sqrt(math.pow(self._tileSize.width * 0.5, 2) + math.pow(self._tileSize.width * 0.25, 2))

    -- 斜边点击判断需要用到
    self._sideLength = self._tileSize.width * 0.5

    -- 第一个格子的y坐标是60，第二个格子的y坐标是150。除了第一个格子的坐标比较特殊。其他的格子y坐标偏移都是90
    self._realTileHeight = 3 / 4 * self._tileSize.height
    self._mapSize = cc.size(self._mapInfo.width > 0 and (self._mapTileSize.width + 0.5) * self._tileSize.width or 0, self._mapInfo.height > 0 and (self._mapTileSize.height - 1) * self._realTileHeight + self._tileSize.height or 0)


    -- 计算渲染的格子的数量, 给外部获取
    self._drawTileSize = cc.size(ex.p.width / self._tileSize.width + 2, ex.p.height / self._tileSize.height + 2)


    -- 渲染的图层数据
    self._usedTile = {}
    for i,v in ipairs(self._mapInfo.layers) do
        self._usedTile[v.id] = {}
        local layer = cc.Layer:create()
        layer:setName(v.id)
        self:addChild(layer)
    end
    
    self.layer_ui = cc.Layer:create()
    self.layer_ui:setName(TMXMap.UILayer)
    self:addChild(self.layer_ui, 1000)
    self._usedTile[TMXMap.UILayer] = {}

    -- 对象池，初始化足够数量的瓦片

    -- 重新组织图层数据
    self._tileLayerData = {}
    self._buildingLayerData = {}

    for k,v in pairs(self._mapInfo.layers) do
        if v.id == TMXMap.TileLayer then
            self._tileLayerData = v
        else
            self._buildingLayerData = v
        end
    end

    -- 使用的图片。sprite是从image截取一部分来渲染的。采用逐个格子生成方法
    self._image = image
    self._imageColNum = 1
    self._imageSize = cc.size(1, 1)
    local texture = display.loadImage(image)
    if texture == nil then
        print("image not found", image)
        return 
    end

    self._imageSize = texture:getContentSize()
    self._imageColNum = math.floor(self._imageSize.width / self._tileSize.height)
end

-- 设置创建的回调
function UIFastTMXHexLayer:setCreateBuildingCallback(callback)
    self.create_building_callback = callback
end

function UIFastTMXHexLayer:setCreateTileCallback(callback)
    self.create_tile_callback = callback
end

function UIFastTMXHexLayer:setCreateUICallback(callback)
    self.create_ui_callback = callback
end

-- 地图的渲染大小
function UIFastTMXHexLayer:getMapSize() return self._mapSize  end

-- 地图的格子数
function UIFastTMXHexLayer:getMapTileSize() return self._mapTileSize  end

-- 地图格子的大小
function UIFastTMXHexLayer:getTileSize() return self._tileSize end

-- 渲染格子的范围
function UIFastTMXHexLayer:getDrawTileSize() return self._drawTileSize end

function UIFastTMXHexLayer:setTileChangeCallback(callback)
    self.tile_change_callback = callback
end

-- 你懂的
function UIFastTMXHexLayer:setTouchCallBack(callback) 
    self.touch_callback = callback

	local touch_node = cc.Node:create()
	self:addChild(touch_node, -9999999)
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

    	self:onTouchEnded(touch, event)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    local event_dispatcher = touch_node:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, touch_node)
end

function UIFastTMXHexLayer:onEventLayerEnter()
    self.super.super.onEventLayerEnter(self)

    -- 每帧刷新一次地图
    self:addTimer("updateTilesTimer", 17, handler(self, self.updateTilesTimer), true)
    self:updateTilesTimer()
end

function UIFastTMXHexLayer:updateTilesTimer()
    -- 更新格子，
    local beg_pos = self:convertToNodeSpace(cc.p(0, 0))
    local end_pos = self:convertToNodeSpace(cc.p(ex.p.width, ex.p.height))

    local rect = cc.rect(beg_pos.x, beg_pos.y, end_pos.x, end_pos.y)
    self:updateTiles(rect)
end

-- 将某个格子标记为已使用。避免重复生成
function UIFastTMXHexLayer:addTileUse(layerId, idx)
    self._usedTile[layerId][idx] = true
end

-- 删除使用标记
function UIFastTMXHexLayer:removeTileUse(layerId, idx)
    self._usedTile[layerId][idx] = nil
end

-- 格子是否被使用了
function UIFastTMXHexLayer:isUsedTile(layerId, idx)
    return self._usedTile[layerId][idx] == true
end

-- 清除格子的使用标记。并删除对应的精灵
function UIFastTMXHexLayer:clearTile(layerId, ben_x, end_x, ben_y, end_y)
    local layer = self:getChildByName(layerId)
    if layer == nil then
        print("layer is nil", layerId)
        return
    end
    
    local used_data = self._usedTile[layerId]
    for kk,vk in pairs(used_data) do
        local row = math.floor(kk / self._mapTileSize.width)
        local col = kk - row * self._mapTileSize.width
        if vk and (col < ben_x or col > end_x or row < ben_y or row > end_y) then
            used_data[kk] = nil
            local spr_tile = layer:getChildByName(kk)
            if spr_tile then
                spr_tile:removeFromParent()
            end
        end
    end
end

-- 将格子图片id转换成图片的纹理坐标
function UIFastTMXHexLayer:getImageRectByIndex(index)
    index = index - 1

    local rect = cc.rect(0, 0, self._tileSize.width, self._tileSize.height)

    local imageY = math.floor(index / self._imageColNum)
    local imageX = index - imageY * self._imageColNum

    rect.x = 1 + imageX * self._tileSize.width + imageX
    rect.y = imageY  * self._tileSize.height + 1 + imageY

    return rect
end

-- 根据y判断当前这行的x坐标是否偏移0.5个格子大小
function UIFastTMXHexLayer:getTileOffsetX(y)
    local realY = self._mapTileSize.height - y - 1
    local offset_x = self._drawTileType == 1 and (math.fmod(realY, 2) == 1 and 0.5  or 0) or (math.fmod(realY, 2) == 0 and 0.5  or 0)
    return offset_x
end

-- 根据y判断当前的格子id是否-1
function UIFastTMXHexLayer:getTileIndexOffset(y)
   return self:getTileOffsetX(y) == 0.5 and -1 or 0
end

function UIFastTMXHexLayer:getPositionByTile(x, y)
    local offset_x = self:getTileOffsetX(y)
    return cc.p((x + 0.5 + offset_x) * self._tileSize.width, self._tileSize.height * 0.5 + (y) * self._realTileHeight)
end

function UIFastTMXHexLayer:getPosByIdx(idx)
    idx = idx - 1
    
    local y = math.floor(idx / self._mapTileSize.width)
    local x = idx - y * self._mapTileSize.width

    return x, y
end

function UIFastTMXHexLayer:getPositionByIdx(idx)
    -- idx = idx - 1
    
    -- local y = math.floor(idx / self._mapTileSize.width)
    -- local x = idx - y * self._mapTileSize.width
    
    local x, y = self:getPosByIdx(idx)

    return self:getPositionByTile(x, y)
end

function UIFastTMXHexLayer:getGroupMainPosition(x, y)
    local usedIdx = y * self._mapTileSize.width + x
    local buildingData = self._buildingLayerData.obj[usedIdx]
    if buildingData then
        local mainGroupData = self._buildingLayerData.obj[buildingData.group_id - 1]
        if mainGroupData then
            return mainGroupData.x, mainGroupData.y
        end
    end

    return x, y
end

-- 更新格子
function UIFastTMXHexLayer:updateTiles(culledRect)
    -- x范围增大一个格子
    local ben_x = math.min(math.max(0, math.floor(culledRect.x / self._tileSize.width) - 1), self._mapTileSize.width - 1)
    local end_x = math.min(math.floor(culledRect.width / self._tileSize.width) + 2, self._mapTileSize.width - 1)

    -- y范围增大一个格子
    local ben_y = math.min(math.max(0, math.floor(culledRect.y / self._realTileHeight) - 1), self._mapTileSize.height - 1)
    local end_y = math.min(math.floor(culledRect.height / self._realTileHeight + 2), self._mapTileSize.height - 1)

    if self.ben_x == ben_x and self.end_x == end_x and self.ben_y == ben_y and self.end_y == end_y and self.isUpdateFinish then
        -- 没有格子需要刷新
        return
    end

    if self.tile_change_callback then
        self.tile_change_callback(ben_x, end_x, ben_y, end_y)
    end

    self.isUpdateFinish = false
    
    local direction = 1
    local tmp_ben_x = ben_x
    local tmp_end_x = end_x
    -- 翻转刷新方向
    if self.ben_x - ben_x > 0 then
        tmp_ben_x = end_x
        tmp_end_x = ben_x
        direction = -1
    end

    self:clearTile(TMXMap.UILayer, ben_x, end_x, ben_y, end_y)

    local drawNum = 0
    for i,v in ipairs(self._mapInfo.layers) do
        self:clearTile(v.id, ben_x, end_x, ben_y, end_y)
        local layer = self:getChildByName(v.id)
        if v.type == "tilelayer" then
            for i=tmp_ben_x, tmp_end_x, direction do
                for j=ben_y, end_y do
                    local used_idx = j * self._mapTileSize.width + i
                    local image_idex = v.data[used_idx+1]
                    if self:isUsedTile(v.id, used_idx) ~= true and image_idex and image_idex ~= 0 then

                        local spr_tile = self.create_tile_callback(self._image, self:getImageRectByIndex(image_idex), i, j)
                        spr_tile:setName(used_idx)
                        spr_tile:setPosition(self:getPositionByTile(i, j))
                        layer:addChild(spr_tile)
                        self:addTileUse(v.id, used_idx)

                        -- node_ui:setName(used_idx)
                        -- node_ui:setPosition(spr_tile:getPosition())
                        -- self.layer_ui:addChild(node_ui)
                        -- self:addTileUse(TMXMap.UILayer, used_idx)

                        drawNum = drawNum + 1
                        if drawNum > maxDrawNum  then
                            self.isUpdateFinish = false
                            return
                        end

                    end
                end
            end
        elseif v.type == "buildinglayer" then
            -- 为了建筑始终在地皮的上面。所以将建筑跟地皮分开层次渲染。但是引来了新的麻烦。比如UI元素要显示在建筑的上面
            for i=ben_x, end_x do
                for j=ben_y, end_y do
                    local used_idx = j * self._mapTileSize.width + i
                    local obj = v.obj[used_idx]
                    if obj and obj.group_main and self:isUsedTile(v.id, used_idx) ~= true then
                        local buildingData = building[obj.gid]
                        local spr_tile = self.create_building_callback(buildingData, i, j)
                        spr_tile:setName(used_idx)
                        spr_tile:setPosition(self:getPositionByTile(i, j))
                        layer:addChild(spr_tile)
                        self:addTileUse(v.id, used_idx)

                        -- local tile = self:getTile(TMXMap.TileLayer, i, j)
                        -- spr_tile:setName(string.format("%s-%s", v.id, used_idx))
                        -- spr_tile:setPosition(cc.p(tile:getContentSize().width * 0.5, tile:getContentSize().height * 0.5))
                        -- tile:addChild(spr_tile, 10)
                        -- tile:setLocalZOrder(1)

                        drawNum = drawNum + 1 
                        if drawNum > maxDrawNum  then
                            self.isUpdateFinish = false
                            return
                        end
                    end
                end
            end
        end
    end

    self.isUpdateFinish = true
    self.ben_x = ben_x
    self.end_x = end_x
    self.ben_y = ben_y
    self.end_y = end_y
end



-- 根据屏幕坐标。返回处于坐标的格子所在的行和列。能精确判断六边形
function UIFastTMXHexLayer:getTileByPosition(position)
    -- 点击判断参考文章
    -- https://blog.csdn.net/iteye_10018/article/details/82541460

    -- 先确定Y下标。有1-2个
    local row = math.floor((position.y - self._tileSize.height * 0.5) / self._realTileHeight) 

    -- 小于0是第一行，最小值是1，防止遍历出现负数
    row = row > 0 and row + 1 or 1

    -- 再确定X下标。有1-2个
    local col = math.floor(position.x / self._tileSize.width)

    -- 防止遍历出现负数
    col = math.max(1, col)

    local tileRow = nil
    local tileCol = nil
    -- 判断点击的格子
    for i=col-1,col do
        for j=row-1,row do

            -- 计算对应格子的中心点坐标
            local offset_x = self:getTileOffsetX(j)
            local tilePosition = cc.p((i + 0.5 + offset_x) * self._tileSize.width, self._tileSize.height * 0.5 + (j) * self._realTileHeight)

            -- 点击坐标 - 格子坐标 取绝对值
            local absPosition = cc.p(math.abs(position.x - tilePosition.x), math.abs(position.y - tilePosition.y))

            -- 计算点击的坐标是否在这个格子里面
            local isInTouch = false
            -- if absPosition.y <= self._sideLength and absPosition.x <= radical3 * self._sideLength * 0.5  then
                -- isInTouch = true
            -- end


            -- if isInTouch and self._sideLength - absPosition.y > absPosition.x / radical3 then
            --     isInTouch = true
            -- end

            -- 非正六边形判断
            if absPosition.y <= self._sideLength and absPosition.x <= self._sideLength then
                isInTouch = true
            end

            -- if isInTouch and (self._sideLength - absPosition.y) >= absPosition.x * math.tan(30.0*math.pi / 180)  then
            if isInTouch then
                local MP = (self._sideLength - absPosition.y)
                local MN = absPosition.x * math.tan(30.0 * math.pi / 180.0)

                -- 范围容错大一点。避免点到边界没有返回值
                if MP - MN >= -3 then
                    isInTouch = true
                else
                    isInTouch = false
                end
            end

            if isInTouch then
                tileRow = j
                tileCol = i
            end
        end
    end

    return tileCol, tileRow
end

function UIFastTMXHexLayer:onTouchEnded(touch, event)
    local touchLocation = touch:getLocation()
    touchLocation = self:convertToNodeSpace(touchLocation)

    -- 判断
    local x, y = self:getTileByPosition(touchLocation)

    if x == nil then
        return
    end

    if self.touch_callback then
        self.touch_callback(x, y)
    end
end

-- 获取
function UIFastTMXHexLayer:getTile(layerId, x, y)
    local used_idx = y * self._mapTileSize.width + x
    if self:isUsedTile(layerId, used_idx) ~= true then
        return
    end 

    local layer = self:getChildByName(layerId)
    if layer == nil then
        return
    end

    return layer:getChildByName(used_idx)
end

function UIFastTMXHexLayer:getOrCreateUINode(x, y)
    local node_ui = self:getTile(TMXMap.UILayer, x, y)

    if node_ui == nil then
        local used_idx = y * self._mapTileSize.width + x
        local spr_tile = self.create_ui_callback()
        spr_tile:setName(used_idx)
        spr_tile:setPosition(self:getPositionByTile(x, y))
        self.layer_ui:addChild(spr_tile)
        self:addTileUse(TMXMap.UILayer, used_idx)
        node_ui = spr_tile
    end

    return node_ui
end

function UIFastTMXHexLayer:removeUINode(x, y)
    self:clearTile(TMXMap.UILayer, x, x, y, y)
end

function UIFastTMXHexLayer:getTileByIdx(idx)
    -- idx = idx - 1
    
    -- local y = math.floor(idx / self._mapTileSize.width)
    -- local x = idx - y * self._mapTileSize.width
    local x, y = self:getPosByIdx(idx)
    return self:getTile(TMXMap.TileLayer, x, y)
end

function UIFastTMXHexLayer:getTileAndBuilding(x, y)
    local tile = self:getTile(TMXMap.TileLayer, x, y)
    local building = self:getTile(TMXMap.BuildingLayer, x, y)
    return tile, building
end



function UIFastTMXHexLayer:getBuildingGroup(x, y)
    local used_idx = y * self._mapTileSize.width + x
    local buildingData = self._buildingLayerData.obj[used_idx]
    if buildingData then
        local num = building[buildingData.gid].gnum
        if num == 1 then
            return {buildingData.idx}
        elseif num == 3 then
            local offset = self:getTileIndexOffset(buildingData.y - 1)
            return {buildingData.idx,
                    used_idx-self._mapTileSize.width+offset,
                    used_idx-self._mapTileSize.width+offset + 1}
        elseif num == 7 then
            local offset1 = self:getTileIndexOffset(buildingData.y + 1)
            local offset2 = self:getTileIndexOffset(buildingData.y - 1)
            return {used_idx+self._mapTileSize.width+offset,
                    used_idx+self._mapTileSize.width+offset + 1,
                    buildingData.idx - 1,
                    buildingData.idx,
                    buildingData.idx + 1,
                    used_idx-self._mapTileSize.width+offset,
                    used_idx-self._mapTileSize.width+offset + 1,
                }
        end
    end
    return {}
end

function UIFastTMXHexLayer:getMainGroupIdx(idx)
    local buildingData = self._buildingLayerData.obj[idx - 1]
    if buildingData then
        return buildingData.group_id
    end
    return idx
end

-----------------------------障碍物------------------------
function UIFastTMXHexLayer:getObstacleByPos(x, y)
    return self._mapInfo.obstacle[x + y * self._mapTileSize.width] or false
end


return UIFastTMXHexLayer