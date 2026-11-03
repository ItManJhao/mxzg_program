--[[
    func: 城池-小块分割地图
    author:熊梦
    time:2021-04-13 10:16:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarCityMapBlockLayer = class("CountryWarCityMapBlockLayer", require("src.comp.EventLayer"))

-- 地图类型
local Map = {
    TileLayer = 1,
    ArchitectureLayer = 10000,
    UserLayer = 100000
}

-- 用户位置
local City_Pos = {
    cc.p(903,268),cc.p(791,404),cc.p(624,317),cc.p(1289,287),cc.p(1582,267),
    cc.p(473,611),cc.p(434,749),cc.p(309,535),cc.p(194,652),
    cc.p(901,975),cc.p(1165,1050),cc.p(1271,909),cc.p(1503,1031),cc.p(1495,901),cc.p(1531,750),cc.p(1799,863),cc.p(1744,701),
    cc.p(1771,427),cc.p(1976,474),cc.p(1972,584),
}

-- 城堡位置
local capital_pos = {
    cc.p(1095,345),
    cc.p(1095,350),
    cc.p(1095,355),
} 

function CountryWarCityMapBlockLayer:onCreate(...)
    self.isUpdateFinish = true
    self.ben_x = 0
    self.end_x = 0
    self.ben_y = 0
    self.end_y = 0
    self.touch_callback = nil
end

--[[
    @desc: 熊梦
    author:{author}
    time:2021-04-15 16:34:44
	--@tilewidth:瓦片宽度
	--@tileheight:瓦片高度
	--@width:地图格子的列数
	--@height:地图格子的行数
    --@architecture_data:建筑物的数据
    --@city_user_data:在当前地图的用户信息
    --@occupy_time:占领时间
    @return:
]]
-- 读取地图文件。
function CountryWarCityMapBlockLayer:loadWithFile(tilewidth,tileheight,width,height,architecture_data,city_user_data,occupy_time)
    -- 地图信息
    self._mapTileSize = cc.size(width, height)         -- 地图的格子数
    self._tileSize = cc.size(tilewidth, tileheight)    -- 地图格子的大小

    -- 地图块是正方形 偏移就是边长
    self._realTileHeight = self._tileSize.width
    self._mapSize = cc.size(width * tilewidth,height * tileheight)

    -- 计算渲染的格子的数量, 给外部获取
    self._drawTileSize = cc.size(ex.p.width / self._tileSize.width + 2, ex.p.height / self._tileSize.height + 2)

    -- 建筑信息
    self._mapData = architecture_data

    -- 占领时间
    self.occupy_time = occupy_time

    -- 地图层
    self._mapTile = cc.Layer:create()
    self._mapTile:setName(Map.TileLayer)
    self:addChild(self._mapTile)
    -- 地图层的数据
    self._usedTile = {}
    self._usedTile[Map.TileLayer] = {}
    -- 已经存在的地图的资源idx
    self._dataTile = {} 
    -- 建筑层
    self._mapArchitecture = cc.Layer:create()
    self._mapArchitecture:setName(Map.ArchitectureLayer)
    self:addChild(self._mapArchitecture)

    -- 创建城堡
    self:createCity()
    -- 占领时间不为0 手动刷新一下
    if self.occupy_time ~= 0 and self._mapData.server_id ~= 0 then
        self:setOccupyTime(self.occupy_time)
    end

    -- 用户层
    self._mapUserLayer = cc.Layer:create()
    self._mapUserLayer:setName(Map.UserLayer)
    self:addChild(self._mapUserLayer)

    self.menu = cpp.UIMenu:create()
    self.menu:setPosition(0,0)
    self._mapUserLayer:addChild(self.menu)

    self.city_user_data = city_user_data

    self:UpdateCityUser(self.city_user_data)

end

-- 设置创建的回调
function CountryWarCityMapBlockLayer:setCreateBuildingCallback(callback)
    self.create_building_callback = callback
end

-- 地图的渲染大小
function CountryWarCityMapBlockLayer:getMapSize() return self._mapSize  end

-- 地图的格子数
function CountryWarCityMapBlockLayer:getMapTileSize() return self._mapTileSize  end

-- 地图格子的大小
function CountryWarCityMapBlockLayer:getTileSize() return self._tileSize end

-- 渲染格子的范围
function CountryWarCityMapBlockLayer:getDrawTileSize() return self._drawTileSize end

-- 设置点击回掉
function CountryWarCityMapBlockLayer:setTouchCallBack(callback) 
    self.touch_callback = callback
end

function CountryWarCityMapBlockLayer:updateTilesTimer()
    -- 更新格子，
    local beg_pos = self:convertToNodeSpace(cc.p(0, 0))
    local end_pos = self:convertToNodeSpace(cc.p(ex.p.width, ex.p.height))

    local rect = cc.rect(beg_pos.x, beg_pos.y, end_pos.x, end_pos.y)
    self:updateTiles(rect)
end

-- 将某个格子标记为已使用。避免重复生成
function CountryWarCityMapBlockLayer:addTileUse(layer,idx)
    self._usedTile[layer][idx] = true
end

-- 删除使用标记
function CountryWarCityMapBlockLayer:removeTileUse(layer,idx)
    self._usedTile[layer][idx] = nil
end

-- 格子是否被使用了
function CountryWarCityMapBlockLayer:isUsedTile(layer,idx)
    return self._usedTile[layer][idx] == true
end

-- 清除格子的使用标记。并删除对应的精灵
function CountryWarCityMapBlockLayer:clearTile(idx)
    self:removeTileUse(Map.TileLayer,idx)
    local spr_tile = self._mapTile:getChildByName(tostring(idx))
    if spr_tile == nil then
        print("clearTile idx is nil", idx)
        return
    end
    if spr_tile then
        spr_tile:removeFromParent()
    end
end

function CountryWarCityMapBlockLayer:getPositionByTile(x, y)
    return cc.p(x * self._tileSize.width, self._tileSize.height * y )
end

function CountryWarCityMapBlockLayer:onEventLayerEnter()
    self.super.super.onEventLayerEnter(self)

    -- 每帧刷新一次地图
    self:addTimer("updateTilesTimer", 17, handler(self, self.updateTilesTimer), true)
    self:updateTilesTimer()
end

-- 创建城堡
function CountryWarCityMapBlockLayer:createCity()
    -- 城堡直接显示出现
    if self._mapData.effect_type ~= 4 then
        -- str_id：
        -- 1: 包围大本营的4个城市
        -- 2: 普通城市
        -- 3: 大本营城市
        local str_id = self._mapData.type ~= 2 and 3 or self._mapData.type
        -- 4个特殊一点的房子
        local idx_city = {1001400,1001000,1001100,1002800}
        for k,v in pairs(idx_city) do
            if v == self._mapData.idx then
                str_id = 1
                break
            end
        end
        local str = string.format("countrywar-map-architecture/countrywar_type_city_%d.png",str_id)
        local spr_tile = cc.Sprite:createWithSpriteFrameName(str)
        spr_tile:setAnchorPoint(cc.p(0.5, 0.5))
        spr_tile:setName(used_idx)
        spr_tile:setPosition(self:getPsPos(capital_pos[str_id]))
        self._mapArchitecture:addChild(spr_tile)
    end

    local spr_name_bg = cc.Sprite:createWithSpriteFrameName("countrywar/spr-build-name-bg.png")
    spr_name_bg:setPosition(1100,710)
    self._mapArchitecture:addChild(spr_name_bg, 1)
  
    local name_str = self._mapData.type == 1 and string.format(ex.Tools:getLang(self._mapData.lan_id[ctr.country_war.data:getRound()]),ex.StringUtil.getServerName(self._mapData.server_id)) or ex.Tools:getLang(self._mapData.lan_id[ctr.country_war.data:getRound()])
    local lbl_name = cc.Label:createWithTTF(name_str, FONT_DEFAULT_NAME_BOLD, 26)
    lbl_name:setPosition(spr_name_bg:getContentSize().width / 2, 25)
    lbl_name:setColor(cc.c3b(253, 224, 177))
    lbl_name:enableOutline(cc.c3b(70,50,28), 2)
    spr_name_bg:addChild(lbl_name, 1)

    if (self._mapData.server_id == nil or self._mapData.server_id == 0) and self._mapData.type == 1 then
        spr_name_bg:setVisible(false)
    end
end

-- 换算为格子id
function CountryWarCityMapBlockLayer:getTileId(culledRect)
    local tile_tab = {}
    -- x范围增大一个格子
    local ben_x = math.min(math.max(0, math.floor(culledRect.x / self._tileSize.width) - 1), self._mapTileSize.width - 1)
    local end_x = math.min(math.floor(culledRect.width / self._tileSize.width) + 2, self._mapTileSize.width - 1)
  
    -- y范围增大一个格子
    local ben_y = math.min(math.max(0, math.floor(culledRect.y / self._realTileHeight) - 1), self._mapTileSize.height - 1)
    local end_y = math.min(math.floor(culledRect.height / self._realTileHeight + 2), self._mapTileSize.height - 1)

    local direction = 1
    local tmp_ben_x = ben_x
    local tmp_end_x = end_x

     -- 翻转刷新方向
     if self.ben_x - ben_x > 0 then
        tmp_ben_x = end_x
        tmp_end_x = ben_x
        direction = -1
    end

    for i=tmp_ben_x, tmp_end_x, direction do
        local tab = {}
        for j=ben_y, end_y do
            local tab_temp = {}
            tab_temp.idx = self._mapTileSize.width * (self._mapTileSize.height - j - 1) + i + 1
            tab_temp.index = cc.p(i,j)
            table.insert( tab, tab_temp ) 
        end
        if #tab > 0 then
            table.insert( tile_tab, tab) 
        end
    end
    return tile_tab
end

-- 去掉交集
function CountryWarCityMapBlockLayer:removeEqual(t1, t2)
    local ret = {}
    for k, v1 in pairs(t1) do
        local equal = false
        for k, v2 in pairs(t2) do
            if v1 == v2 then
                equal = true
                break
            end
        end
        if not equal then
            table.insert(ret, v1[1])
        end
    end
    return ret
end

-- 更新格子
function CountryWarCityMapBlockLayer:updateTiles(culledRect)
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

    self.isUpdateFinish = false
    local tile_tab = self:getTileId(culledRect)
    if self._dataTile ~= nil and next(self._dataTile) ~= nil then
        for i,v in ipairs(self:removeEqual(tile_tab,self._dataTile)) do
            if self:isUsedTile(Map.TileLayer,used_idx) then
                self:clearTile(v)
            end
        end
    end

    for i,v in ipairs(tile_tab) do
        for j,k in ipairs(v) do
            local used_idx = k.idx
            if self:isUsedTile(Map.TileLayer,used_idx) ~= true then
                local str = string.format("countrywar-city-map/countrywar_map_city_%d.png",used_idx)
                local spr_tile = cc.Sprite:createWithSpriteFrameName(str)
                spr_tile:setName(used_idx)
                spr_tile:setAnchorPoint(cc.p(0, 0))
                spr_tile:setPosition(self:getPositionByTile(k.index.x, k.index.y))
                self._mapTile:addChild(spr_tile)
                self:addTileUse(Map.TileLayer,used_idx)
            end
        end
    end

    self._dataTile = tile_tab 
    self.isUpdateFinish = true
    self.ben_x = ben_x
    self.end_x = end_x
    self.ben_y = ben_y
    self.end_y = end_y
end

function CountryWarCityMapBlockLayer:onTouchEnded(tag, pSender)
    if self.touch_callback then
        self.touch_callback(pSender.player_id,pSender.server_id)
    end
end

-- 坐标转换
function CountryWarCityMapBlockLayer:getPsPos(pos)
    --  后面修改了地图大小 懒得一个一个的修改坐标 所以统一加在这里
     return cc.p(pos.x + 25,self:getMapSize().height - pos.y + 27)
end


function CountryWarCityMapBlockLayer:setOccupyTime(time)
    if ex.Game:getServerTime() - time < 0 then return end
    -- 占领时间
    self.occupy_time = time

    self:UpdateOccupyTime()
end

-- 更新占领时间
function CountryWarCityMapBlockLayer:UpdateOccupyTime()
    if self._mapData.type == 1 then return end

    if (ex.Game:getServerTime() - self.occupy_time) < 0 then
        if self:getTimerByName("timerInfo") then
            self:removeTimerByName("timerInfo")
            local lbl_time = self._mapArchitecture:getChildByName("lbl_occupy_time")
            if lbl_time then lbl_time:removeFromParent() end
            return
        end
    end
    
    local spr_occupy_bg = self._mapArchitecture:getChildByName("spr_occupy_bg")
    if spr_occupy_bg == nil then
        spr_occupy_bg = cc.Sprite:createWithSpriteFrameName("countrywar/spr-surround-bg.png")
        spr_occupy_bg:setName("spr_occupy_bg")
        spr_occupy_bg:setPosition(cc.p(1100,670))
        self._mapArchitecture:addChild(spr_occupy_bg, 1)
    end

    local lbl_time = self._mapArchitecture:getChildByName("lbl_occupy_time")
    if lbl_time == nil then
        lbl_time = cpp.RichTextEx:createWithXMLLua("")
        lbl_time:setFontSize(36)
        lbl_time:setScale(0.5)
        lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
        lbl_time:setFontColor("#FF3759")
        lbl_time:setAnchorTextShadow(false)
        lbl_time:setAnchorPoint(ex.a.center)
        lbl_time:setPosition(cc.p(1100,670))
        lbl_time:setLocalZOrder(10)
        lbl_time:setName("lbl_occupy_time")
        self._mapArchitecture:addChild(lbl_time)
    end

    self:updateCDTime(lbl_time,self.occupy_time) 

    if self:getTimerByName("timerInfo") then
        return
    end
    
    self:addTimer("timerInfo", 1000, handler(self,self.UpdateOccupyTime), true)
end

-- 更新玩家模型信息
function CountryWarCityMapBlockLayer:UpdateCityUser(data)
    -- 清除所有的玩家
    self.menu:removeAllChildren()

    self.city_user_data = data

    -- tabel 排序
    local function sor(a,b)
        return a.idx < b.idx
    end 
    table.sort(self.city_user_data,sor)

    for i,v in ipairs(self.city_user_data) do

        local btn = cpp.UIMenuItemImage:createWithSpriteFrameName("countrywar-map-architecture/countrywar_city_army.png",
                                                                        nil,
                                                                        nil)
        btn:setEnableAction(false)
        if btn == nil then
            return 
        end
        btn:setAnchorPoint(0.5, 0.5)
        btn.player_id = v.rid
        btn.server_id = v.server_id
        btn:setName(i)
        btn:setPosition(self:getPsPos(City_Pos[i]))
        btn:registerScriptTapHandler(handler(self, self.onTouchEnded))
        self.menu:addChild(btn)

        local lbl_name = cc.Label:createWithTTF(v.nick, FONT_DEFAULT_NAME_BOLD, 20)
        lbl_name:setPosition(btn:getContentSize().width * 0.5, 10)
        lbl_name:setColor(cc.c3b(253, 224, 177))
        lbl_name:enableOutline(cc.c3b(70,50,28), 2)
        btn:addChild(lbl_name)
    end
    
end

function CountryWarCityMapBlockLayer:updateCDTime(lbl_time,star_time)
    local remain_time =  ex.Game:getServerTime() - star_time

    if remain_time < 0 then return end

    if lbl_time ~= nil then
        if remain_time > 86400 then
            local remainder = math.fmod( remain_time, 86400)
            local text = ex.Tools:getLang(55567) .. string.format(ex.Tools:getLang(47162),
            math.floor(remain_time / 86400),
            math.floor(remainder / 3600),
            math.floor(remainder / 60 % 60))
            lbl_time:setXmlTextLua(text)
        else
            local text = ex.Tools:getLang(55567) .. string.format(ex.Tools:getLang(47140), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60))
            lbl_time:setXmlTextLua(text)
        end
    end

    lbl_time:formatText()
end

function CountryWarCityMapBlockLayer:onExit()
    self:removeTimerByName("timerInfo")
end


return CountryWarCityMapBlockLayer
