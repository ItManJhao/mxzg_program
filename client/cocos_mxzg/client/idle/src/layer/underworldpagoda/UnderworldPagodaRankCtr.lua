local UnderworldPagodaRankCtr = class("UnderworldPagodaRankCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local UnderworldPagodaRankLayer = class("UnderworldPagodaRankLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UnderworldPagodaRankCell = class("UnderworldPagodaRankCell", require("src.comp.LuaLayerBase"))

local HadesDegree = {
    simple = 1,         --简单
    difficulty = 2      --困难
}

function UnderworldPagodaRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_photo:setContentSize(self.spr_photo:getContentSize())
end

function UnderworldPagodaRankCell:setTableView(table_view)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu:setSwallowsTouches(false)
end

function UnderworldPagodaRankCell:initData(data, cell_type,max_tab)
    if data == nil or data.rank == nil then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/super-stage-icon.plist")

    self.btn_photo.role_id = data.player_id
    self.btn_photo.player_server_id = data.server_id

    if self.spr_rank ~= nil then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
        if data.rank > 0 and data.rank < 4 then 
            self.spr_rank:setVisible(true)
            self.lbl_rank:setVisible(false)
            ex.Tools:setSpriteFrame(self.spr_rank, string.format("rank/spr-paihang-%s.png", data.rank))
        end
              
        if data.rank > 0 then
            self.lbl_rank:setString(string.format("%d", data.rank))
            self.lbl_rank:setScale(0.5)
        else
            self.lbl_rank:setString(ex.Tools:getLang(52012))
            self.lbl_rank:setScale(0.3)
        end
    end

    ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))
    ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))

    self.lbl_name:setString(data.name)
    self.lbl_server_name:setString(ex.StringUtil.getServerName(data.server_id))
    self.lbl_level:setString(string.format("%d", data.level))
    self.lbl_fighting:setString(string.format("%d", data.fighting))

    if data.floor > max_tab[HadesDegree.simple] then
        self.spr_rank_difficult:setVisible(true)
        self.lbl_layers_nums:setString(string.format(ex.Tools:getLang(6201), data.floor - max_tab[HadesDegree.simple] ))
    else
        self.spr_rank_difficult:setVisible(false)
        self.lbl_layers_nums:setString(string.format(ex.Tools:getLang(6201), data.floor))
    end

    self.lbl_name:setPositionX(self.lbl_server_name:getPositionX() + self.lbl_server_name:getContentSize().width * self.lbl_server_name:getScaleX() + 5)
end

-----------------------------------------------------------------------------
function UnderworldPagodaRankLayer:getAsynImage()
    local vec_image = {
    }
    return vec_image
end

function UnderworldPagodaRankLayer:onCreate()
    -- self:setAutoClose(false)
    self:addBlackBackground()
    
    self.scroll_view:setItemSize(cc.size(540, 135))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function UnderworldPagodaRankCtr:onCreate()
    self:setCCBIPath("ccbi/UnderworldPagodaRankLayer.ccbi")
    self:setIsSingle(false)
end

function UnderworldPagodaRankCtr:getLayerClass()
    return UnderworldPagodaRankLayer
end

function UnderworldPagodaRankCtr:openWindow(hadestype)
    if self:isOpened() then
        return
    end

    self.hadestype = hadestype
    self.max_tab = {}
    local type_1_conut = 0
    local type_2_conut = 0
    for i,v in ipairs(cfg.hadesfloor.hadesfloor) do
        if v.type == self.hadestype then 
            if v.difficulty_lv == HadesDegree.simple then
                type_1_conut = type_1_conut + 1
            else
                type_2_conut = type_2_conut + 1
            end
        end
    end
    table.insert( self.max_tab, type_1_conut )  -- 简单的关卡数量
    table.insert( self.max_tab, type_2_conut )  -- 困难的关卡数量
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function UnderworldPagodaRankCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer:addEvent(EVENT.UNDERWORLDPAGODA.UPDATE_RANKLIST, handler(self, self.updateTableView))

    ex.Player.underworld_pagoda_data:gReqHadesRankList(self.hadestype)

    local title_name_lang = {
        6252,
        6253,
    }
    self.layer.lbl_title_name:setString(ex.Tools:getLang(title_name_lang[self.hadestype]))
    
    self:updateTableView()
end

function UnderworldPagodaRankCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    local super_stage_data = ex.Player.underworld_pagoda_data["hadesInfo_rank_list_"..self.hadestype]


    -- optional int64 player_id = 1; //玩家ID
    -- optional string name = 2; //玩家名字
    -- optional int32 level = 3; //玩家等级
    -- optional int32 head_id = 4; //玩家头像
    -- optional int32 border_id = 5; //头像框id
    -- optional int32 server_id = 6; //大区（服务器区号）.
    -- optional int32 rank = 7; //玩家排名
    -- optional int32 floor = 8; //当前通关层数1-12
    -- optional int64 fighting = 9; //战力

    

    -- 更新我的排名
    if super_stage_data.self.rank <= 0 then
        self.layer.lbl_rank_self:setString(ex.Tools:getLang(74811)..ex.Tools:getLang(74812))
    else
        self.layer.lbl_rank_self:setString(ex.Tools:getLang(74811)..super_stage_data.self.rank)
    end

    if super_stage_data.self.floor > self.max_tab[HadesDegree.simple] then
        self.layer.spr_rank_difficult_self:setVisible(true)
        self.layer.lbl_rank_self_clearance:setString(string.format(ex.Tools:getLang(6201), super_stage_data.self.floor - self.max_tab[HadesDegree.simple] ))
        self.layer.lbl_rank_self_clearance:setPositionX(532)
    else
        self.layer.spr_rank_difficult_self:setVisible(false)
        self.layer.lbl_rank_self_clearance:setString(string.format(ex.Tools:getLang(6201), super_stage_data.self.floor))
        self.layer.lbl_rank_self_clearance:setPositionX(509)
    end
    
    

    -- 显示前三名形象
    for i=1,3 do
        local data = super_stage_data.ranks[i]
        local node = self.layer["node_spine_"..i]
        node:setVisible(data ~= nil)
        node:removeAllChildren()
        self.layer["spr_rank_difficult_"..i]:setVisible(false)
        if data ~= nil then
        
            local hero_type = math.floor(data.image_id % 100000000)
            local star = math.floor(data.image_id / 100000000)
            
            local hero_skin = ex.Tools:getHeroSkinByStar(hero_type, star)
            local spine_hero = require("src.person.Hero"):create("1", "1", hero_type, 1, star, hero_skin)
            spine_hero:setAnimation(0, "stand", true);
            spine_hero:setScale(1.0)
            spine_hero:setPosition(cc.p(0, 50))
            spine_hero:setShadowVisible(false)
            node:addChild(spine_hero, 10)

            self.layer["lbl_name_"..i]:setString(data.name)
            self.layer["lbl_fighting_"..i]:setString(string.format("%d", data.fighting))

            if data.floor > self.max_tab[HadesDegree.simple] then
                self.layer["spr_rank_difficult_"..i]:setVisible(true)
                self.layer["lbl_stage_name_"..i]:setString(string.format(ex.Tools:getLang(6201), data.floor - self.max_tab[HadesDegree.simple] ))
            else
                self.layer["lbl_stage_name_"..i]:setString(string.format(ex.Tools:getLang(6201), data.floor))
            end
            
        else
            self.layer["lbl_name_"..i]:setString(ex.Tools:getLang(5067))
            self.layer["lbl_stage_name_"..i]:setString("")
            self.layer["lbl_fighting_"..i]:setString("--")
        end
    end
    
    -- 显示自己和前三名
    local list = {}
    for i,v in ipairs(super_stage_data.ranks) do
        if v.rank > 3 then
            table.insert(list, v)
        end
    end
    table.sort(list, function(a, b)
        return a.rank < b.rank
    end)

    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = UnderworldPagodaRankCell:createWithCCBIFile("ccbi/UnderworldPagodaRankCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data, self.layer_type,self.max_tab)
        cell:setTableView(self.layer.scroll_view)
    
        cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))

        return cell
    end

    self.layer.scroll_view:reloadData(list)
end

function UnderworldPagodaRankCtr:onPlayerInfo(tag, pSender)
    -- ex.Tools:showPlayerInfo(pSender.role_id, pSender.player_server_id)
end

return UnderworldPagodaRankCtr
