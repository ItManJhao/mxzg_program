local RankListCtr = class("RankListCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RankListLayer = class("RankListLayer", require("src.comp.EventLayer"))
local RankListCell = class("RankListCell", require("src.comp.LuaLayerBase"))

-- /**
-- * 战力
-- */
-- FIGTH_ING(1, 100, false),
-- /**
-- * 竞技场，冠军赛需要128名玩家，因此排名必须大于128
-- */
-- ARENA(2, 200, false),
-- /**
-- * 商会
-- */
-- CLAN(3, 100, false),
-- /**
-- * 幻境
-- */
-- TOWER(4, 100, false),
-- /**
-- * 地牢
-- */
-- DUNGEON(5, 100, false),
-- /**
-- * 点石成金
-- */
-- BUY_GOLD(6, 200, false),
-- /**
-- * 速战之王
-- */
-- SPEED_FIGHT(7, 200, false),
-- /**
-- * 试炼之路
-- */
-- ADVENTURE(8, 200, false),
-- /**
-- * 酒馆常客
-- */
-- TAVERN(9, 200, false),
-- /**
-- * 公会世界BOSS角色积分排行
-- */
-- CLAN_WORLD_BOSS_ROLE(10, 9999, false),
-- /**
-- * 公会世界BOSS公会积分排行
-- */
-- CLAN_WORLD_BOSS_CLAN(11, 9999, false),
-- /**
-- * 永恒梦境排行榜
-- */
-- DREAMLAND(12, 100, false),
-- /***
-- * 跨服战力
-- */
-- CROSS_FIGHTING(13, 100, true),
-- /***
-- * 跨服公会
-- */
-- CROSS_CLAN(14, 100, true),

-- /***
-- * 主线榜
-- */
-- ROLE_MISSION(15, 100, false),

-- /***
-- * 诸神遗迹
-- */
-- GOD_RELIC(16, 100, false),

local RankType = {
    rank_chapter = 15,
    rank_tower = 4,
    rank_clan = 3,
    rank_pvp = 2,
    rank_player = 1,
    rank_cross_fighting = 13,
    rank_cross_clan = 14,
}

local RankListLayerType = {}
RankListLayerType.SERVER_CUR = 1
RankListLayerType.SERVER_CROSS = 2

function RankListCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function RankListCell:setTableView(table_view)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu:setSwallowsTouches(false)
end

function RankListCell:initData(data)
    self.data = data

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    local status = ex.Player.rank_data:getWorshipStatus(RankType[data[1]])
    self.btn_worship:setVisible(status == 1)
    self.btn_worship:setTag(RankType[data[1]])
    self.spr_reddot:setVisible(status == 1)

    -- 设置第一名的信息
    if data[1] == "rank_chapter" then
        -- 暂时没有
        ex.Tools:setSpriteFrame(self.spr_cell_bg, "rank-lang/spr-rank-chapter.png")

        local data_top_one = ex.Player.rank_data.rank_chapter_list[1]
        if data_top_one ~= nil then
            self.role_id = data_top_one.player_id
            self.btn_worship.role_id = data_top_one.player_id
            ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data_top_one.head_id))
            ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data_top_one.border_id))
            self.lbl_name:setString(data_top_one.name)
            self.lbl_num:setString(string.format("%s %d", ex.Tools:getLang(41305), data_top_one.score))
        else
            self.role_id = 0
            self.spr_head_bg:setVisible(false)

            self.spr_photo:setVisible(false)
            self.spr_frame:setVisible(false)
            self.lbl_name:setVisible(false)
            self.lbl_num:setVisible(false)
        end
    elseif data[1] == "rank_tower" then
        ex.Tools:setSpriteFrame(self.spr_cell_bg, "rank-lang/spr-rank-tower.png")

        local data_top_one = ex.Player.rank_data.rank_tower_list[1]
        if data_top_one ~= nil then
            self.role_id = data_top_one.player_id
            self.btn_worship.role_id = data_top_one.player_id
            ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data_top_one.head_id))
            ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data_top_one.border_id))
            self.lbl_name:setString(data_top_one.name)
            self.lbl_num:setString(string.format("%s %d", ex.Tools:getLang(41197), data_top_one.score))
        else
            self.role_id = 0
            self.spr_head_bg:setVisible(false)
            self.spr_frame:setVisible(false)
            self.spr_photo:setVisible(false)
            self.lbl_name:setVisible(false)
            self.lbl_num:setVisible(false)
    end
    elseif data[1] == "rank_clan" then
        ex.Tools:setSpriteFrame(self.spr_cell_bg, "rank-lang/spr-rank-clan.png")

        local data_top_one = ex.Player.rank_data.rank_clan_list[1]
        self.spr_frame:setVisible(data[1] ~= "rank_clan")
        if data_top_one ~= nil then
            self.role_id = data_top_one.clan_id
            self.btn_worship.role_id = data_top_one.clan_id
            ex.Tools:setSpriteFrame(self.spr_photo, string.format("clan-photo/%02d.png", data_top_one.clan_photo))
            ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data_top_one.border_id))
            self.lbl_name:setString(data_top_one.clan_name)
            self.lbl_num:setString(string.format("%s %d", ex.Tools:getLang(41196), data_top_one.damage))
        else
            self.role_id = 0
            -- self.spr_head_bg:setVisible(false)
            self.spr_frame:setVisible(false)
            self.spr_photo:setVisible(false)
            self.lbl_name:setVisible(false)
            self.lbl_num:setVisible(false)
        end
    elseif data[1] == "rank_pvp" then
        ex.Tools:setSpriteFrame(self.spr_cell_bg, "rank-lang/spr-rank-pvp.png")

        local data_top_one = ex.Player.rank_data.rank_pvp_list[1]
        if data_top_one ~= nil then
            self.role_id = data_top_one.player_id
            self.btn_worship.role_id = data_top_one.player_id
            ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data_top_one.head_id))
            ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data_top_one.border_id))
            self.lbl_name:setString(data_top_one.name)
            self.lbl_num:setString(string.format("%s %d", ex.Tools:getLang(41195), data_top_one.score))
        else
            self.role_id = 0
            self.spr_head_bg:setVisible(false)
            self.spr_frame:setVisible(false)
            self.spr_photo:setVisible(false)
            self.lbl_name:setVisible(false)
            self.lbl_num:setVisible(false)
        end
    elseif data[1] == "rank_player" then
        ex.Tools:setSpriteFrame(self.spr_cell_bg, "rank-lang/spr-rank-player.png")

        local data_top_one = ex.Player.rank_data.rank_player_list[1]
        if data_top_one ~= nil then
            self.role_id = data_top_one.player_id
            self.btn_worship.role_id = data_top_one.player_id
            ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data_top_one.head_id))
            ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data_top_one.border_id))
            self.lbl_name:setString(data_top_one.name)
            self.lbl_num:setString(string.format("%s %d", ex.Tools:getLang(41194), data_top_one.combat_num))
        else
            self.role_id = 0
            self.spr_head_bg:setVisible(false)
            self.spr_frame:setVisible(false)
            self.spr_photo:setVisible(false)
            self.lbl_name:setVisible(false)
            self.lbl_num:setVisible(false)
        end
    elseif data[1] == "rank_cross_fighting" then
        ex.Tools:setSpriteFrame(self.spr_cell_bg, "rank-lang/spr-rank-cross-fighting.png")

        local data_top_one = ex.Player.rank_data.rank_cross_fighting_list[1]
        local ttf_config = self.lbl_name:getTTFConfig()
        ttf_config.fontSize = 40
        self.lbl_name:setTTFConfig(ttf_config)
        self.lbl_name:setPositionY(56)
        self.lbl_server_name:setVisible(true)
        ttf_config = self.lbl_num:getTTFConfig()
        ttf_config.fontSize = 36
        self.lbl_num:setTTFConfig(ttf_config)
        self.lbl_num:setPositionY(10)

        if data_top_one ~= nil then
            self.role_id = data_top_one.player_id
            self.btn_worship.role_id = data_top_one.player_id
            ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data_top_one.head_id))
            ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data_top_one.border_id))
            self.lbl_name:setString(data_top_one.name)
            self.lbl_server_name:setString(ex.StringUtil.getServerName(data_top_one.server_id))
            self.lbl_num:setString(string.format("%s %d", ex.Tools:getLang(41194), data_top_one.combat_num))
        else
            self.role_id = 0
            self.spr_head_bg:setVisible(false)
            self.spr_frame:setVisible(false)
            self.spr_photo:setVisible(false)
            self.lbl_name:setVisible(false)
            self.lbl_num:setVisible(false)
        end
    elseif data[1] == "rank_cross_clan" then
        ex.Tools:setSpriteFrame(self.spr_cell_bg, "rank-lang/spr-rank-cross-clan.png")

        local data_top_one = ex.Player.rank_data.rank_cross_clan_list[1]
        local ttf_config = self.lbl_name:getTTFConfig()
        ttf_config.fontSize = 40
        self.lbl_name:setTTFConfig(ttf_config)
        self.lbl_name:setPositionY(56)
        self.lbl_server_name:setVisible(true)
        ttf_config = self.lbl_num:getTTFConfig()
        ttf_config.fontSize = 36
        self.lbl_num:setTTFConfig(ttf_config)
        self.lbl_num:setPositionY(10)
        self.spr_frame:setVisible(data[1] ~= "rank_cross_clan")

        if data_top_one ~= nil then
            self.role_id = data_top_one.clan_id
            self.btn_worship.role_id = data_top_one.clan_id
            ex.Tools:setSpriteFrame(self.spr_photo, string.format("clan-photo/%02d.png", data_top_one.clan_photo))
            ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data_top_one.border_id))
            self.lbl_name:setString(data_top_one.clan_name)
            self.lbl_server_name:setString(ex.StringUtil.getServerName(data_top_one.server_id))
            self.lbl_num:setString(string.format("%s %d", ex.Tools:getLang(41196), data_top_one.damage))
        else
            self.role_id = 0
            -- self.spr_head_bg:setVisible(false)
            self.spr_frame:setVisible(false)
            self.spr_photo:setVisible(false)
            self.lbl_name:setVisible(false)
            self.lbl_num:setVisible(false)
        end
    end
end

-----------------------------------------------------------------------------
function RankListLayer:onCreate()
    self:addBlackBackground()

    self.btn_tab_1:setChecked(true)

    self.btn_tab_1:setLabelText(ex.Tools:getLang(5490))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(5130))

    self.scroll_view:setItemSize(cc.size(480,155))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function RankListCtr:onCreate()
    self:setCCBIPath("ccbi/RankListLayer.ccbi")
    self:setIsSingle(false)

    self.layer_type = RankListLayerType.SERVER_CUR
end

function RankListCtr:getLayerClass()
    return RankListLayer
end

function RankListCtr:getRankListLayer()
    return self.layer
end

function RankListCtr:openWindow(layer_type)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function RankListCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))

    self.layer:addRedDotNode(RedDotType.ZCJ_DHZC_PHB_BF, self.layer.btn_tab_1)
    self.layer:addRedDotNode(RedDotType.ZCJ_DHZC_PHB_KF, self.layer.btn_tab_2)
    
    ex.Player.rank_data:checkRedDot()

    self.layer_type = RankListLayerType.SERVER_CUR
    self:updateTableView()

    ex.Player.rank_data:onRefresh()
end

function RankListCtr:onTab(tag, pSender)
    if tag <= 0 or self.layer_type == tag then
        return
    end

    -- 跨服和同省频道有等级限制
    if tag == RankListLayerType.SERVER_CROSS and cfg.opencondition.condition["main_rank_cross"].condition_value > ex.Player.level then
        ex.MessageView:add(string.format(ex.Tools:getLang(71051), tostring(cfg.opencondition.condition["main_rank_cross"].condition_value)))
        tag = self.layer_type
    end

    if self.layer_type == tag then
        pSender:setChecked(false)
        if self.layer_type == RankListLayerType.SERVER_CUR then
            self.layer.btn_tab_1:setChecked(true)
        elseif self.layer_type == RankListLayerType.SERVER_CROSS then
            self.layer.btn_tab_2:setChecked(true)
        end
    end

    if self.layer_type ~= tag then
        self.layer_type = tag
    
        self:updateTableView()
    end
end

function RankListCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    self.vec_rank_item = {}
    self.vec_rank_item[RankListLayerType.SERVER_CUR] = {}
    self.vec_rank_item[RankListLayerType.SERVER_CROSS] = {}
    if #ex.Player.rank_data.rank_chapter_list > 0 then      -- 剧情
        table.insert(self.vec_rank_item[RankListLayerType.SERVER_CUR], {"rank_chapter"})
    end
    if #ex.Player.rank_data.rank_tower_list > 0 then       -- 试练塔
        table.insert(self.vec_rank_item[RankListLayerType.SERVER_CUR], {"rank_tower"})
    end
    if #ex.Player.rank_data.rank_clan_list > 0 then        -- 公会
        table.insert(self.vec_rank_item[RankListLayerType.SERVER_CUR], {"rank_clan"})
    end
    if #ex.Player.rank_data.rank_pvp_list > 0 then         -- 竞技场
        table.insert(self.vec_rank_item[RankListLayerType.SERVER_CUR], {"rank_pvp"})
    end
    if #ex.Player.rank_data.rank_player_list > 0 then      -- 个人战力
        table.insert(self.vec_rank_item[RankListLayerType.SERVER_CUR], {"rank_player"})
    end
    if #ex.Player.rank_data.rank_cross_clan_list > 0 then       -- 跨服公会
        table.insert(self.vec_rank_item[RankListLayerType.SERVER_CROSS], {"rank_cross_clan"})
    end
    if #ex.Player.rank_data.rank_cross_fighting_list > 0 then   -- 跨服战力
        table.insert(self.vec_rank_item[RankListLayerType.SERVER_CROSS], {"rank_cross_fighting"})
    end

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.nodeTouched = handler(self, self.tableCellTouched)
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = RankListCell:createWithCCBIFile("ccbi/RankListCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
        cell:setTableView(self.layer.scroll_view)
    
        cell.btn_worship:registerScriptTapHandler(handler(self, self.onWorship))

        return cell
    end

    self.layer.scroll_view:reloadData(self.vec_rank_item[self.layer_type])
end

function RankListCtr:onWorship(tag, pSender)
    local req_worship = Rank_pb.GReqRankWorship()
    req_worship.type = tag
    req_worship.rid = pSender.role_id
    NetManager:sendMessage(ProtocolID.GReqRankWorship, req_worship)
    
    ex.Player.rank_data:addWorshipType(tag)
    ex.Player.rank_data:checkRedDot()
    
    self:updateTableView()
end

function RankListCtr:tableCellTouched(tag, pSender)
    local data = pSender.data
    local layer_type = 0
    if data[1] == "rank_chapter" then
        layer_type = 1
    elseif data[1] == "rank_tower" then
        layer_type = 2
    elseif data[1] == "rank_clan" then
        layer_type = 3
    elseif data[1] == "rank_pvp" then
        layer_type = 4
    elseif data[1] == "rank_player" then
        layer_type = 5
    elseif data[1] == "rank_cross_fighting" then
        layer_type = 6
    elseif data[1] == "rank_cross_clan" then
        layer_type = 7
    end

    require("src.layer.RankTopThreeCtr"):instance():openWindow(layer_type)
end

return RankListCtr
