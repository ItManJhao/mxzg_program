--[[
    func: 小块分割地图
    author:熊梦
    time:2021-04-13 10:16:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]
local CountryWarMapBlockLayer = class("CountryWarMapBlockLayer", require("src.comp.EventLayer"))

local Map = {
    TileLayer = 1,
    ArchitectureLayer = 10000
}

local Faction = {
    FACTION_1 = 1,
    FACTION_2 = 2,
    FACTION_3 = 4,
    FACTION_4 = 8,
    FACTION_UNION = 16, --联合阵营
}

function CountryWarMapBlockLayer:onCreate(...)
    self.isUpdateFinish = true
    self.ben_x = 0
    self.end_x = 0
    self.ben_y = 0
    self.end_y = 0
    self.touch_callback = nil
    self.map_config = nil
    self.Country_Color = {}
end

--[[
    @desc: 熊梦
    author:{author}
    time:2021-04-15 16:34:44
	--@tilewidth:瓦片宽度
	--@tileheight:瓦片高度
	--@width:地图格子的列数
	--@height:地图格子的行数
	--@mapwidth:地图的宽度
	--@mapheight: 地图的高度
    --@architecture_data:建筑物的数据
    @return:
]]
-- 读取地图文件。
function CountryWarMapBlockLayer:loadWithFile(tilewidth,tileheight,width,height,mapwidth,mapheight,architecture_data)
    -- 地图信息
    self._mapTileSize = cc.size(width, height) -- 地图的格子数
    self._tileSize = cc.size(tilewidth, tileheight)    -- 地图格子的大小

    -- 地图块是正方形 偏移就是边长
    self._realTileHeight = self._tileSize.width
    self._mapSize = cc.size(mapwidth,mapheight)

    -- 计算渲染的格子的数量, 给外部获取
    self._drawTileSize = cc.size(ex.p.width / self._tileSize.width + 2, ex.p.height / self._tileSize.height + 2)

    -- 建筑信息
    self._mapData = architecture_data

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
    self.menu = cpp.UIMenu:create()
    self.menu:setPosition(0,0)
    -- self.menu:setAnchorPoint(0.5, 0.5)
    self._mapArchitecture:addChild(self.menu)
    self:addChild(self._mapArchitecture)
    -- 建筑层数据
    self._usedTile[Map.ArchitectureLayer] = {}
    -- 计算出建筑所对应的x，y坐标
    local end_pos = self:convertToNodeSpace(cc.p(ex.p.width, ex.p.height))
    for k,v in pairs(self._mapData) do
        -- 计算出当前点的坐标系的坐标
        local x1 = math.min(math.max(0, math.floor(v.x / self._tileSize.width) - 1), self._mapTileSize.width - 1)
        local y1 = math.min(math.max(0, math.floor(v.y / self._realTileHeight) - 1), self._mapTileSize.height - 1)
        v.index = cc.p(x1,y1)
    end

    -- 我的位置 添加到建筑层上面
    self.node_my = cc.Node:create()
    self.node_my:setPosition(0,0)
    self.node_my:setName("node_my")
    self._mapArchitecture:addChild(self.node_my)

    self:addTimer("timerInfo", 1000, handler(self,self.updateWarCDTime), true)
    self:addTimer("timerEvent", 1000, handler(self,self.updateEventCDTime), true)
end


function CountryWarMapBlockLayer:updataMap(map_config)
    self.map_config = map_config
    if self.map_config == nil or next(self.map_config) == nil then return end 
    local  country_color_temp =
    {
        [0]="countrywar/spr-grey-flag.png",
        [1]="countrywar/spr-green-flag.png",
        [2]="countrywar/spr-purple-flag.png",
        [4]="countrywar/spr-red-flag.png",
        [8]="countrywar/spr-yellow-flag.png",
    }
    self.Country_Color[0] = country_color_temp[0]
    for _,v in pairs(self.map_config.servers) do
        for _,k in pairs(v.faction) do
            if k ~= Faction.FACTION_UNION then
                self.Country_Color[v.server_id] = country_color_temp[k]
                break
            end
        end
    end

    self:updataCity()
end

-- 设置创建的回调
function CountryWarMapBlockLayer:setCreateBuildingCallback(callback)
    self.create_building_callback = callback
end

-- 地图的渲染大小
function CountryWarMapBlockLayer:getMapSize() return self._mapSize  end

-- 地图的格子数
function CountryWarMapBlockLayer:getMapTileSize() return self._mapTileSize  end

-- 地图格子的大小
function CountryWarMapBlockLayer:getTileSize() return self._tileSize end

-- 渲染格子的范围
function CountryWarMapBlockLayer:getDrawTileSize() return self._drawTileSize end

-- 设置点击回掉
function CountryWarMapBlockLayer:setTouchCallBack(callback) self.touch_callback = callback end

function CountryWarMapBlockLayer:onEventLayerEnter()
    -- 每帧刷新一次地图
    self:addTimer("updateTilesTimer", 17, handler(self, self.updateTilesTimer), true)
    self:updateTilesTimer()
end

function CountryWarMapBlockLayer:updateTilesTimer()
    -- 更新格子，
    local beg_pos = self:convertToNodeSpace(cc.p(0, 0))
    local end_pos = self:convertToNodeSpace(cc.p(ex.p.width, ex.p.height))

    local rect = cc.rect(beg_pos.x, beg_pos.y, end_pos.x, end_pos.y)
    self:updateTiles(rect)
end

-- 将某个格子标记为已使用。避免重复生成
function CountryWarMapBlockLayer:addTileUse(layer,idx)
    self._usedTile[layer][idx] = true
end

-- 删除使用标记
function CountryWarMapBlockLayer:removeTileUse(layer,idx)
    self._usedTile[layer][idx] = nil
end

-- 格子是否被使用了
function CountryWarMapBlockLayer:isUsedTile(layer,idx)
    return self._usedTile[layer][idx] == true
end

-- 清除格子的使用标记。并删除对应的精灵
function CountryWarMapBlockLayer:clearTile(idx)
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

function CountryWarMapBlockLayer:getPositionByTile(x, y)
    return cc.p(x * self._tileSize.width, self._tileSize.height * y )
end

-- 换算为格子id
function CountryWarMapBlockLayer:getTileId(culledRect)
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
function CountryWarMapBlockLayer:removeEqual(t1, t2)
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
function CountryWarMapBlockLayer:updateTiles(culledRect)
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
            -- 地图瓦片
            if self:isUsedTile(Map.TileLayer,used_idx) ~= true then
                local str = string.format("countrywar-map/countrywar_map_%d.png",used_idx)
                local spr_tile = cc.Sprite:createWithSpriteFrameName(str)
                spr_tile:setName(used_idx)
                spr_tile:setAnchorPoint(cc.p(0, 0))
                spr_tile:setPosition(self:getPositionByTile(k.index.x, k.index.y))

                self._mapTile:addChild(spr_tile)
                self:addTileUse(Map.TileLayer,used_idx)
            end
            -- 地图城市建筑物
            if table.nums(self._usedTile[Map.ArchitectureLayer]) < table.nums(self._mapData) then
                for w,h in pairs(self._mapData) do
                    if h.index.x == k.index.x and h.index.y == k.index.y then
                        if self:isUsedTile(Map.ArchitectureLayer,h.idx) ~= true then
                            local architecture_data = h
                            self:CreateCity(architecture_data)
                        end
                        break
                    end
                end
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

-- 刷新所有城市
function CountryWarMapBlockLayer:updataCity()
    for i,v in pairs(self._mapData) do
        self:updataCityLogic(v.idx)
    end
end

-- 创建城市
function CountryWarMapBlockLayer:CreateCity(data)
    if data == nil then return end
    local str = string.format("countrywar-map-architecture/countrywar_type_%d.png",data.effect_type)
    local btn = cpp.UIMenuItemImage:createWithSpriteFrameName(str, nil, nil)
    if btn == nil then
        print("创建城市失败",data.effect_type)
        return 
    end
    btn:setAnchorPoint(0.5, 0.5)
    btn.idx = data.idx
    btn:setName(data.idx)
    btn:setPosition(cc.p(data.x,data.y))
    btn:registerScriptTapHandler(handler(self, self.onTouchEnded))
    self.menu:addChild(btn)
    self:addTileUse(Map.ArchitectureLayer,data.idx)

   self:updataCityLogic(data.idx)
 
end

function CountryWarMapBlockLayer:updataCityLogic(idx)
    local btn_city = self.menu:getChildByName(idx)
    if btn_city == nil then return end
    local data = self._mapData[idx]
    local server_id = nil 
    if self.map_config ~= nil and ctr.country_war.data:isOpen() then 
        server_id = self.map_config.cities[idx].server_id
    end
    -- 创建名字
    self:creatorName(btn_city,data,server_id)

    -- 创建旗帜
    self:creatorfFlag(btn_city,data,server_id)

    -- 没有数据的情况下 活动未开始或已经结束
    if self.map_config == nil or not ctr.country_war.data:isOpen() then 
        if data.type == 1 then
            btn_city:getChildByName("spr_name_bg"):setVisible(false)
        end
        return 
    end

    local cities_data = self.map_config.cities[idx]
    --  我的位置图标
    self:ShowMyCurr(data.idx)
    -- 当前城市是否满员
    self:isFull(cities_data.idx)
    -- 当前城市是否有特殊事件 （包括商城） 商城和特殊事件不会同时出现在一个城市
    if (cities_data.event_duration - ex.Game:getServerTime()) > 0 or (cities_data.shop_duration - ex.Game:getServerTime()) > 0 then
        self:updateEventCDTime()
    end
    -- 如果可以攻击 显示作战的动画 两把剑
    self:ShowattackAnimation(cities_data.idx)
    -- 是否被包围
    self:ShowSurround(cities_data.idx,cities_data.isolate)
    -- 是否为交战状态
    if ex.Game:getServerTime()  <  cities_data.war_duration then 
        -- 手动刷新一下交战时间
        self:updateWarCDTime()
    end
    self:WarStateAnimation(cities_data.idx,ex.Game:getServerTime()  <  cities_data.war_duration)
end

-- 城池名字
function CountryWarMapBlockLayer:creatorName(btn_city,data,server_id)
    if btn_city:getChildByName("spr_name_bg") == nil then
        local spr_name_bg = cc.Sprite:createWithSpriteFrameName("countrywar/spr-name-bg.png")
        spr_name_bg:setPosition(btn_city:getContentSize().width * 0.5,0)
        spr_name_bg:setName("spr_name_bg")
        btn_city:addChild(spr_name_bg, 1)

        local lbl_name = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 24)
        lbl_name:setPosition(spr_name_bg:getContentSize().width * 0.5, 23)
        lbl_name:setColor(cc.c3b(253, 224, 177))
        lbl_name:enableOutline(cc.c3b(70,50,28), 2)
        lbl_name:setName("lbl_name")
        spr_name_bg:addChild(lbl_name, 1)
    end

    if data.type ~= 1 then
        btn_city:getChildByName("spr_name_bg"):getChildByName("lbl_name"):setString(ex.Tools:getLang(data.lan_id[ctr.country_war.data:getType()]))
    end

    -- 别的语言的适配 繁体注释掉
    -- btn_city:getChildByName("spr_name_bg"):getChildByName("lbl_name"):setAnchorPoint(cc.p(0,0.5))
    -- btn_city:getChildByName("spr_name_bg"):getChildByName("lbl_name"):setPositionX(30)

    if self.map_config == nil or not ctr.country_war.data:isOpen() then 
        return
    end

     -- data.type:
    -- 1.大本营
    -- 2.普通城池
    -- 3.npc城池
    if data.type == 1 then
        if server_id == nil or server_id == 0 then
            btn_city:getChildByName("spr_name_bg"):setVisible(false)
            return
        else
            btn_city:getChildByName("spr_name_bg"):getChildByName("lbl_name"):setString(string.format(ex.Tools:getLang(data.lan_id[ctr.country_war.data:getType()]),ex.StringUtil.getServerName(server_id))) 
            btn_city:getChildByName("spr_name_bg"):setVisible(true)
        end
    end

end

-- 旗帜
function CountryWarMapBlockLayer:creatorfFlag(btn_city,data,server_id)
     -- 旗帜“大本营”的图片
     if data.type ~= 2 then
        local spr_dby_bg = btn_city:getChildByName("spr_dby_bg")
        if spr_dby_bg == nil then
            local pos_y = data.type == 3 and 180 or 210
            spr_dby_bg = cc.Sprite:createWithSpriteFrameName("countrywar/spr-name-bg.png")
            spr_dby_bg:setPosition(btn_city:getContentSize().width * 0.5,pos_y)
            spr_dby_bg:setName("spr_dby_bg")
            btn_city:addChild(spr_dby_bg)

            local spr_name_dby = cc.Sprite:createWithSpriteFrameName("countrywar-lang/spr-dby.png")
            spr_name_dby:setPosition(80,25)
            spr_dby_bg:addChild(spr_name_dby)
        end
    end

    if data.type == 1 then
        -- 旗帜
       local spr_label = btn_city:getChildByName("spr_dby_bg"):getChildByName("spr_label")
       if spr_label ~= nil then spr_label:removeFromParent() end

       -- 4个大本营的图片
       local color_type = 
       {
           "countrywar/spr-green-flag.png",
           "countrywar/spr-purple-flag.png",
           "countrywar/spr-red-flag.png",
           "countrywar/spr-yellow-flag.png",
       }

       -- 大本营的旗帜 固定不变 不管活动开没开都显示
       local str = color_type[self._mapData[data.idx].camp]
       local spr_label = cc.Sprite:createWithSpriteFrameName(str)
       spr_label:setPosition(10,25)
       spr_label:setName("spr_label")
       btn_city:getChildByName("spr_dby_bg"):addChild(spr_label, 1)
    else
        if self.map_config == nil or not ctr.country_war.data:isOpen() then 
            return 
        end

        local spr_label = btn_city:getChildByName("spr_name_bg"):getChildByName("spr_label")
        if spr_label ~= nil then spr_label:removeFromParent() end

        local str = self.Country_Color[server_id]
        local pos_label_y = data.type ~= 2 and 206 or 25
        local spr_label = cc.Sprite:createWithSpriteFrameName(str)
        spr_label:setPosition(10,pos_label_y)
        spr_label:setName("spr_label")
        btn_city:getChildByName("spr_name_bg"):addChild(spr_label, 1)
    end
end

-- 我的位置
function CountryWarMapBlockLayer:ShowMyCurr(idx)
    local isbool = idx == self.map_config.curr_id
    -- 我的位置的图标创建一个就行了 根据不同的idx设置不同的位置
    local btn = self.menu:getChildByName(idx)
    if btn == nil then return end
    local spr = self.node_my:getChildByName("spr_my")
    if spr == nil then
        self.node_my:removeAllChildren()

        local pos_x = 90
        local pos_y = 65
        local spr_head = cc.Sprite:createWithSpriteFrameName(string.format("head-icon/%d.png", ex.Player.head_id))
        spr_head:setScale(0.7)
        spr_head:setPosition(cc.p(pos_x,pos_y))
        spr_head:setName("spr_my")
        self.node_my:addChild(spr_head)

        local spr_bg = cc.Sprite:createWithSpriteFrameName("countrywar/spr-txk.png")
        spr_bg:setPosition(cc.p(pos_x,pos_y))
        self.node_my:addChild(spr_bg)

        local spr_my = cc.Sprite:createWithSpriteFrameName("countrywar-lang/spr-my.png")
        spr_my:setPosition(cc.p(pos_x - 25,pos_y))
        self.node_my:addChild(spr_my)
    end

    if isbool then
        self.node_my:setPosition(cc.p(btn:getPositionX(),btn:getPositionY()))
        self.node_my.idx = idx
        self.node_my:setVisible(true)
    else
        if self.node_my.idx == idx then
            self.node_my:setVisible(false)
        end
    end
end

-- 驻守城池的人 是否满成员
function CountryWarMapBlockLayer:isFull(idx)
    local btn = self.menu:getChildByName(idx)
    if btn == nil then
        return
    end
    local isfull = ctr.country_war.data:isFull(idx)
    local node = btn:getChildByName("node_full")
    if node ~= nil then
        if not isfull then
            node:removeFromParent()
        else
            node:setVisible(true)
        end
        return
    end
    if not isfull then return end

    node = cc.Node:create()
    node:setName("node_full")
    node:setAnchorPoint(cc.p(0,0))
    node:setPosition(cc.p(0,0))
    btn:addChild(node,1)

    local spr = cc.Sprite:createWithSpriteFrameName("countrywar-lang/spr-icon-man.png")
    spr:setPosition(-3,42)
    node:addChild(spr)
end

-- 显示攻击动画  两把箭头
function CountryWarMapBlockLayer:ShowattackAnimation(curr_id)
    if self._mapData[curr_id].type == 1 or self._mapData[curr_id].can_attack == 2 then 
        return 
    end
    
    if ctr.country_war.data:isCityMy(curr_id) or ctr.country_war.data:isCityFriend(curr_id) then
        return
    end
   
    local isbool = false
    for k,v in pairs(self._mapData[self.map_config.curr_id].connect_city_id) do
        if v == curr_id then
            isbool = true
            break
        end
    end
    
    local btn = self.menu:getChildByName(curr_id)
    if btn == nil then
        return
    end
    local node = btn:getChildByName("battle_animation")
    if node ~= nil then
        if not isbool then
            node:removeFromParent()
        else
            node:setVisible(true)
        end
        return
    end
    if not isbool then return end
 
    node = cc.Node:create()
    node:setName("battle_animation")
    node:setAnchorPoint(cc.p(0,0))
    node:setPosition(cc.p(0,0))
    btn:addChild(node,1)

    -- 动画
    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_countrywar_battle")
    spr_effect:setPosition(btn:getContentSize().width * 0.5,btn:getContentSize().height)
    node:addChild(spr_effect)
end

-- 显示包围
-- idx : 城市的idx   isbool : 是否顯示包圍
function CountryWarMapBlockLayer:ShowSurround(idx,isbool)
    local btn = self.menu:getChildByName(idx)
    if btn == nil then
        return
    end
    local node = btn:getChildByName("surround")
    if node ~= nil then
        if not isbool then
            node:removeFromParent()
        else
            node:setVisible(true)
        end
        return
    end
    if not isbool then return end

    node = cc.Node:create()
    node:setName("surround")
    node:setAnchorPoint(cc.p(0,0))
    node:setPosition(cc.p(0,0))
    btn:addChild(node, 2)

    local spr = cc.Sprite:createWithSpriteFrameName("countrywar/spr-surround.png")
    spr:setScale(0.85)
    spr:setPosition(btn:getContentSize().width * 0.5,btn:getContentSize().height * 0.5 + 15)
    node:addChild(spr, 2)

    local spr_bg = cc.Sprite:createWithSpriteFrameName("countrywar/spr-surround-bg.png")
    spr_bg:setPosition(btn:getContentSize().width * 0.5,btn:getContentSize().height * 0.5)
    node:addChild(spr_bg, 2)

    local lbl = cc.Label:createWithTTF(ex.Tools:getLang(55563), FONT_DEFAULT_NAME_BOLD, 20)
    lbl:setPosition(spr_bg:getContentSize().width * 0.5, 17)
    lbl:setColor(cc.c3b(253, 224, 177))
    lbl:enableOutline(cc.c3b(70,50,28), 2)
    spr_bg:addChild(lbl, 2)

    node:setVisible(isbool)
end

-- 战争状态的动画 时间倒计时 火的动画 
function CountryWarMapBlockLayer:WarStateAnimation(idx,isbool)
    local btn = self.menu:getChildByName(idx)
    if btn == nil then
        return
    end
    local node = btn:getChildByName("fire_animation")
    if node ~= nil then
        if not isbool then
            node:removeFromParent()
        else
            node:setVisible(true)
        end
        return
    end
    if not isbool then return end
 
    node = cc.Node:create()
    node:setName("fire_animation")
    node:setAnchorPoint(cc.p(0,0))
    node:setPosition(cc.p(0,0))
    btn:addChild(node,0)

    -- 动画
    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_countrywar_fire")
    spr_effect:setScale(0.7)
    spr_effect:setPosition(btn:getContentSize().width * 0.5,btn:getContentSize().height * 0.5 + 40)
    node:addChild(spr_effect)
end

-- 刷新地图上的交战时间
function CountryWarMapBlockLayer:updateWarCDTime()
    if self._mapData == nil then return end
    for k,v in pairs(self._mapData) do
        local btn = self.menu:getChildByName(v.idx)
        if self.map_config == nil or next(self.map_config) == nil then return end 
        if btn ~= nil then
            local end_time = self.map_config.cities[v.idx].war_duration
            if end_time - ex.Game:getServerTime() > 0 then
                local node = btn:getChildByName("node_time")
                if node == nil then
                    node = cc.Node:create()
                    node:setName("node_time")
                    node:setAnchorPoint(cc.p(0,0))
                    node:setPosition(cc.p(0,0))
                    btn:addChild(node,1)
                end

                local spr_bg = node:getChildByName("spr_bg")
                if spr_bg == nil then
                    spr_bg = cc.Sprite:createWithSpriteFrameName("countrywar/spr-time-bg.png")
                    spr_bg:setPosition(btn:getContentSize().width * 0.5,-25)
                    spr_bg:setName("spr_bg")
                    node:addChild(spr_bg)
                end
            
                local lbl_time = spr_bg:getChildByName("lbl_war_time")
                if lbl_time == nil then
                    lbl_time = cpp.RichTextEx:createWithXMLLua("")
                    lbl_time:setFontSize(36)
                    lbl_time:setScale(0.5)
                    lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
                    lbl_time:setFontColor("#ffffff")
                    lbl_time:setAnchorTextShadow(false)
                    lbl_time:setAnchorPoint(ex.a.left_bottom)
                    lbl_time:setPosition(cc.p(12, 15))
                    lbl_time:setLocalZOrder(10)
                    lbl_time:setName("lbl_war_time")
                    spr_bg:addChild(lbl_time)
                end

                if not self:setTimeInfo(lbl_time,end_time) then
                    node:removeFromParent()
                end
            else
                local node = btn:getChildByName("node_time")
                if node ~= nil then node:removeFromParent() end
            end
        end
    end
end

-- 刷新地图上的事件时间
function CountryWarMapBlockLayer:updateEventCDTime()
    if self._mapData == nil then return end
    for k,v in pairs(self._mapData) do
        local btn = self.menu:getChildByName(v.idx)
        if self.map_config == nil or next(self.map_config) == nil then return end 
        local cities_data = self.map_config.cities[v.idx]
        if btn ~= nil then
            if (cities_data.event_duration - ex.Game:getServerTime()) > 0 or (cities_data.shop_duration - ex.Game:getServerTime()) > 0 then
                local node = btn:getChildByName("node_event")
                if node == nil then
                    node = cc.Node:create()
                    node:setName("node_event")
                    node:setAnchorPoint(cc.p(0,0))
                    node:setPosition(cc.p(0,0))
                    btn:addChild(node,1)
                end
    
                local spr_bg = node:getChildByName("spr_bg")
                if spr_bg == nil then
                    local offset = v.effect_type == 3 and 50 or 40
                    spr_bg = cc.Sprite:createWithSpriteFrameName("countrywar/spr-surround-bg.png")
                    spr_bg:setPosition(btn:getContentSize().width * 0.5,btn:getContentSize().height + offset)
                    spr_bg:setName("spr_bg")
                    node:addChild(spr_bg)
                end
    
                local lbl_time = spr_bg:getChildByName("lbl_event_time")
                if lbl_time == nil then
                    lbl_time = cpp.RichTextEx:createWithXMLLua("")
                    lbl_time:setFontSize(36)
                    lbl_time:setScale(0.5)
                    lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
                    lbl_time:setFontColor("#6EFF6E")
                    lbl_time:setAnchorTextShadow(false)
                    lbl_time:setAnchorPoint(ex.a.left_bottom)
                    lbl_time:setPosition(cc.p(20, 7))
                    lbl_time:setLocalZOrder(10)
                    lbl_time:setName("lbl_event_time")
                    spr_bg:addChild(lbl_time)
                end
    
                local spr_icon = spr_bg:getChildByName("item_icon")
                if spr_icon == nil then
                    local str = "countrywar-lang/spr-shop-2.png"
                    local scale = 0.5
                    if (cities_data.event_duration - ex.Game:getServerTime()) > 0 then
                        for j,k in pairs(cfg.countrywarrandomevent.countrywarrandomevent) do
                            if k.idx == cities_data.event_id then
                                scale = ex.Player.backpack_data:isPiece(k.reward[1].item_type) and 0.3 or 0.5
                                str = string.format("backpack/%d.png",k.reward[1].item_type)
                                break
                            end
                        end
                    end
                    local spr_icon = cc.Sprite:createWithSpriteFrameName(str)
                    spr_icon:setScale((cities_data.event_duration - ex.Game:getServerTime()) > 0 and scale or 1)
                    spr_icon:setName("item_icon")
                    spr_icon:setPosition(cc.p(0,20))
                    spr_bg:addChild(spr_icon)
                end
                if not self:setTimeInfo(lbl_time,(cities_data.event_duration - ex.Game:getServerTime()) > 0 and cities_data.event_duration or cities_data.shop_duration) then
                    node:removeFromParent()
                end
            else
                local node = btn:getChildByName("node_event")
                if node ~= nil then 
                    node:removeFromParent() 
                end
            end
        end
    end
end

function CountryWarMapBlockLayer:setTimeInfo(lbl_time,end_time)
    local remain_time = end_time - ex.Game:getServerTime()

    if remain_time <= 0 then
        return false
    end

	if remain_time > 86400 then
		local remainder = math.fmod( remain_time, 86400)
        lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(47162),
			math.floor(remain_time / 86400),
			math.floor(remainder / 3600),
			math.floor(remainder / 60 % 60)))
    else
        lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(47140), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
    lbl_time:formatText()
    return true
end

-- 点击城市回掉
function CountryWarMapBlockLayer:onTouchEnded(tag, pSender)
    if self.touch_callback then
        -- ex.MessageView:add(string.format("%s  ID：%d",ex.Tools:getLang(self._mapData[pSender.idx].lan_id[ctr.country_war.data:getRound()]),pSender.idx))
        self.touch_callback(pSender.idx)
    end
end

return CountryWarMapBlockLayer
