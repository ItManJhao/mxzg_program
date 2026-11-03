local RankTopThreeCtr = class("RankTopThreeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RankTopThreeLayer = class("RankTopThreeLayer", require("src.comp.EventLayerAdaptiveWidth"))

local RankTopThreeCell = class("RankTopThreeCell", require("src.comp.LuaLayerBase"))
function RankTopThreeCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_photo:setContentSize(self.spr_photo:getContentSize())
end

function RankTopThreeCell:setTableView(table_view)
    self.menu:setIsTouchInsideNode(table_view)
    self.menu:setSwallowsTouches(false)
end

function RankTopThreeCell:initData(data, cell_type)
    if data == nil or data.rank == nil then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    self.btn_photo.role_id = data.player_id
    self.btn_photo.player_server_id = data.server_id

    if ((data.player_id ~= nil and 
        data.player_id > 0 and 
        data.player_id == ex.Player.role_id) or
        (data.clan_id ~= nil and 
         data.clan_id > 0 and 
         data.clan_id == ex.Player.clan_data.clan_id)) and
        data.server_id ~= nil and 
        data.server_id == cc.UserDefault:getInstance():getIntegerForKey("server_id", -1) then
        
        self.spr_cell_bg:setVisible(false)
    end
    
    if self.spr_rank ~= nil then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
        if data.rank > 0 and data.rank < 4 then 
            self.spr_rank:setVisible(true)
            self.lbl_rank:setVisible(false)
            self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank))
        end
              
        if data.rank > 0 then
            self.lbl_rank:setString(string.format("%d", data.rank))
            self.lbl_rank:setScale(0.5)
        else
            self.lbl_rank:setString(ex.Tools:getLang(52012))
            self.lbl_rank:setScale(0.3)
        end
    end

    self.lbl_total_dmg:setVisible(false)
    self.lbl_max_dmg:setVisible(false)

    if cell_type == RankTopThreeLayerType.CHAPTER or
            cell_type == RankTopThreeLayerType.TOWER or
            cell_type == RankTopThreeLayerType.PVP or
            cell_type == RankTopThreeLayerType.DUNGEON or
            cell_type == RankTopThreeLayerType.BUY_GOLD or
            cell_type == RankTopThreeLayerType.PUB_TASK or
            cell_type == RankTopThreeLayerType.TRIAL or
            cell_type == RankTopThreeLayerType.QUICK_BATTLE or
            cell_type == RankTopThreeLayerType.GOD_RELIC then
        ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))
        ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))
        self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.name)
        self.lbl_lv:setString(string.format(ex.Tools:getLang(47139), data.level))
        self.lbl_num:setString(string.format("%d", data.score))
    elseif cell_type == RankTopThreeLayerType.PLAYER or 
           cell_type == RankTopThreeLayerType.LADDER then
        ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))
        ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))
        self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.name)
        self.lbl_lv:setString(string.format(ex.Tools:getLang(47139), data.level))
        self.lbl_num:setString(string.format("%d", data.combat_num))

    elseif cell_type == RankTopThreeLayerType.FLOATING_ISLANDS_BOSS then
        ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))
        ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))
        self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.name)
        self.lbl_lv:setString(string.format(ex.Tools:getLang(47139), data.level))
        -- self.lbl_num:setString(string.format("%d", data.combat_num))
        self.lbl_total_dmg:setVisible(true)
        self.lbl_max_dmg:setVisible(true)
        self.lbl_num:setVisible(false)
        self.lbl_total_dmg:setString(string.format(ex.Tools:getLang(75405), ex.StringUtil.getScientificNumber(data.total_dmg)))
        self.lbl_max_dmg:setString(string.format(ex.Tools:getLang(75406), ex.StringUtil.getScientificNumber(data.self_max_dmg)))

    elseif cell_type == RankTopThreeLayerType.CLAN then
        ex.Tools:setSpriteFrame(self.spr_photo, string.format("clan-photo/%02d.png", data.clan_photo))
        self.spr_frame:setVisible(false)
        self.btn_photo:setEnabled(false)
        self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.clan_name)
        self.lbl_lv:setString(string.format(ex.Tools:getLang(47489), data.head_name))
        self.lbl_num:setString(string.format("%d", data.damage))
    elseif cell_type == RankTopThreeLayerType.CROSS_FIGHTING then
        ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))
        ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))
        local ttf_config = self.lbl_name:getTTFConfig()
        ttf_config.fontSize = 40
        self.lbl_name:setTTFConfig(ttf_config)
        self.lbl_name:setPositionY(80)
        self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.name)
        self.lbl_server_name:setVisible(true)
        self.lbl_server_name:setString(ex.StringUtil.getServerName(data.server_id))
        self.lbl_lv:setString(string.format(ex.Tools:getLang(47139), data.level))
        self.lbl_num:setString(string.format("%d", data.combat_num))
    elseif cell_type == RankTopThreeLayerType.CROSS_CLAN then
        ex.Tools:setSpriteFrame(self.spr_photo, string.format("clan-photo/%02d.png", data.clan_photo))
        self.spr_frame:setVisible(false)
        self.btn_photo:setEnabled(false)
        local ttf_config = self.lbl_name:getTTFConfig()
        ttf_config.fontSize = 40
        self.lbl_name:setTTFConfig(ttf_config)
        self.lbl_name:setPositionY(80)
        self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.clan_name)
        self.lbl_server_name:setVisible(true)
        self.lbl_server_name:setString(ex.StringUtil.getServerName(data.server_id))
        self.lbl_lv:setString(string.format(ex.Tools:getLang(47489), data.head_name))
        self.lbl_num:setString(string.format("%d", data.damage))
    elseif cell_type == RankTopThreeLayerType.MAGIC_TOWER then
        ex.Tools:setSpriteFrame(self.spr_photo, string.format("head-icon/%d.png", data.head_id))
        ex.Tools:setSpriteFrame(self.spr_frame, ex.Tools:getBorderIconByIdx(data.border_id))
        self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.name)
        self.lbl_name:setPosition(self.spr_photo:getPositionX() + 50, self.spr_photo:getPositionY())
        self.lbl_lv:setVisible(false)
        self.lbl_num:setString(string.format("%d", data.pass_level))
    end
end



function RankTopThreeLayer:getAsynImage()
    local vec_image = {
    }
    return vec_image
end

function RankTopThreeLayer:onCreate()
    print("RankTopThreeLayer:onCreate")
    -- self:setAutoClose(false)
    self:addBlackBackground()
    
    self.scroll_view:setItemSize(cc.size(544,115))
    self.scroll_view:setItemType(1)
    self:addEvent(EVENT.RANK_EVENT.UPDATE_RANK_TOP_LAYER, function()
        require("src.layer.RankTopThreeCtr"):instance():updateTableView()
    end)
end

-- 公会排行类型枚举
RankTopThreeLayerType = {}
RankTopThreeLayerType.INVALID = 0       -- 无效
RankTopThreeLayerType.CHAPTER = 1       -- 剧情排行
RankTopThreeLayerType.TOWER = 2         -- 幻境之塔排行
RankTopThreeLayerType.CLAN = 3          -- 公会排行
RankTopThreeLayerType.PVP = 4           -- 竞技场排行
RankTopThreeLayerType.PLAYER = 5        -- 玩家战力排行
RankTopThreeLayerType.CROSS_FIGHTING = 6-- 跨服战力排行
RankTopThreeLayerType.CROSS_CLAN = 7    -- 跨服公会排行
RankTopThreeLayerType.DUNGEON = 11      -- 地牢排行
RankTopThreeLayerType.LADDER = 12       -- 天梯排行
RankTopThreeLayerType.BUY_GOLD = 13     -- 点金排行
RankTopThreeLayerType.PUB_TASK = 14     -- 酒馆常客排行
RankTopThreeLayerType.TRIAL = 15        -- 试炼之路排行
RankTopThreeLayerType.QUICK_BATTLE = 16 -- 速战之王排行
RankTopThreeLayerType.GOD_RELIC = 17    -- 速战之王排行
RankTopThreeLayerType.MAGIC_TOWER = 18  -- 幻魔塔排行

RankTopThreeLayerType.FLOATING_ISLANDS_BOSS= 20       -- 浮空岛boss伤害排行


-----------------------------------------------------------------------------
function RankTopThreeCtr:onCreate()
    self:setCCBIPath("ccbi/RankTopThreeLayer.ccbi")
    self:setIsSingle(false)
end

function RankTopThreeCtr:getLayerClass()
    return RankTopThreeLayer
end

function RankTopThreeCtr:getRankTopThreeLayer()
    return self.layer
end

function RankTopThreeCtr:openWindow(layer_type)
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/rank.plist")
    sfc:addSpriteFrames("ccbi-res/clan-photo.plist")

    self.layer_type = layer_type

    self:loadLayer()
    self:open()
    self:initData()
end

function RankTopThreeCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    print("clan rank tab", self.layer_type)

    if self.layer_type == RankTopThreeLayerType.CHAPTER then
        self.layer.lbl_title:setString(ex.Tools:getLang(47072))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47650))

        ex.Player.rank_data:onRefresh(self.layer_type)
    elseif self.layer_type == RankTopThreeLayerType.TOWER then
        self.layer.lbl_title:setString(ex.Tools:getLang(47273))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47374))

        ex.Player.rank_data:onRefresh(self.layer_type)
    elseif self.layer_type == RankTopThreeLayerType.MAGIC_TOWER then
        self.layer.lbl_title:setString(ex.Tools:getLang(57501))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47374))

        ex.Player.rank_data:onRefresh(self.layer_type)
    elseif self.layer_type == RankTopThreeLayerType.CLAN then
        self.layer.lbl_title:setString(ex.Tools:getLang(47134))
        self.layer.lbl_title_2:setString(ex.Tools:getLang(47245))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47367))

        ex.Player.rank_data:onRefresh(self.layer_type)
    elseif self.layer_type == RankTopThreeLayerType.PVP then
        self.layer.lbl_title:setString(ex.Tools:getLang(47663))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47181))

        ex.Player.rank_data:onRefresh(self.layer_type)
    elseif self.layer_type == RankTopThreeLayerType.PLAYER then
        self.layer.lbl_title:setString(ex.Tools:getLang(47720))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47390))

        ex.Player.rank_data:onRefresh(self.layer_type)
    elseif self.layer_type == RankTopThreeLayerType.CROSS_FIGHTING then
        self.layer.lbl_title:setString(ex.Tools:getLang(47697))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47390))

        ex.Player.rank_data:onRefresh(self.layer_type)
    elseif self.layer_type == RankTopThreeLayerType.CROSS_CLAN then
        self.layer.lbl_title:setString(ex.Tools:getLang(47387))
        self.layer.lbl_title_2:setString(ex.Tools:getLang(47245))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47367))

        ex.Player.rank_data:onRefresh(self.layer_type)
    elseif self.layer_type == RankTopThreeLayerType.DUNGEON then
        self.layer.lbl_title:setString(ex.Tools:getLang(47030))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47374))

        ex.Player.rank_data:onRefreshDungeon()
    elseif self.layer_type == RankTopThreeLayerType.LADDER then
        self.layer.lbl_title:setString(ex.Tools:getLang(47690))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47390))

        ex.Player.rank_data:onRefreshLadder()
    elseif self.layer_type == RankTopThreeLayerType.FLOATING_ISLANDS_BOSS then
        self.layer.lbl_title:setString(ex.Tools:getLang(75410))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(2150221))

        -- ex.Player.rank_data:onRefreshLadder()
        ex.Player.rank_data:onRefreshFloatingIslands()
    elseif self.layer_type == RankTopThreeLayerType.BUY_GOLD then
        self.layer.lbl_title:setString(ex.Tools:getLang(47525))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47596))

        ex.Player.rank_data:onRefreshBuyGold()
    elseif self.layer_type == RankTopThreeLayerType.PUB_TASK then
        self.layer.lbl_title:setString(ex.Tools:getLang(47431))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47233))

        ex.Player.rank_data:onRefreshPubTask()
    elseif self.layer_type == RankTopThreeLayerType.TRIAL then
        self.layer.lbl_title:setString(ex.Tools:getLang(47431))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47233))

        ex.Player.rank_data:onRefreshTrial()
    elseif self.layer_type == RankTopThreeLayerType.QUICK_BATTLE then
        self.layer.lbl_title:setString(ex.Tools:getLang(47431))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47233))

        ex.Player.rank_data:onRefreshQuickBattle()
    elseif self.layer_type == RankTopThreeLayerType.GOD_RELIC then
        self.layer.lbl_title:setString(ex.Tools:getLang(47431))
        self.layer.lbl_title_3:setString(ex.Tools:getLang(47306))

        ex.Player.rank_data:onRefreshGodRelic()
    end

    self.layer.cell_self = RankTopThreeCell:createWithCCBIFile("ccbi/RankTopThreeCell.ccbi")
    self.layer.cell_self:setPosition(10, 5)
    self.layer.cell_self:setAnchorPoint(0, 0)
    self.layer.spr_rank_bg_self:addChild(self.layer.cell_self)

    self:updateTableView()
end

function RankTopThreeCtr:updateTableView()
    if not self:getLayer() then
        return
    end

    -- 显示自己和前三名
    local data_self = nil
    local list = nil
    if self.layer_type == RankTopThreeLayerType.CHAPTER then
        list = ex.Player.rank_data.rank_chapter_list
        data_self = ex.Player.rank_data.rank_chapter_self
    elseif self.layer_type == RankTopThreeLayerType.TOWER then
        list = ex.Player.rank_data.rank_tower_list
        data_self = ex.Player.rank_data.rank_tower_self
    elseif self.layer_type == RankTopThreeLayerType.MAGIC_TOWER then
        list = ex.Player.rank_data.rank_magic_tower_list
        data_self = ex.Player.rank_data.rank_magic_tower_self
    elseif self.layer_type == RankTopThreeLayerType.CLAN then
        list = ex.Player.rank_data.rank_clan_list
        data_self = ex.Player.rank_data.rank_clan_self
    elseif self.layer_type == RankTopThreeLayerType.PVP then
        list = ex.Player.rank_data.rank_pvp_list
        data_self = ex.Player.rank_data.rank_pvp_self
    elseif self.layer_type == RankTopThreeLayerType.PLAYER then
        list = ex.Player.rank_data.rank_player_list
        data_self = ex.Player.rank_data.rank_player_self
    elseif self.layer_type == RankTopThreeLayerType.CROSS_FIGHTING then
        list = ex.Player.rank_data.rank_cross_fighting_list
        data_self = ex.Player.rank_data.rank_cross_fighting_self
    elseif self.layer_type == RankTopThreeLayerType.CROSS_CLAN then
        list = ex.Player.rank_data.rank_cross_clan_list
        data_self = ex.Player.rank_data.rank_cross_clan_self
    elseif self.layer_type == RankTopThreeLayerType.DUNGEON then
        list = ex.Player.rank_data.rank_dungeon_list
        data_self = ex.Player.rank_data.rank_dungeon_self
    elseif self.layer_type == RankTopThreeLayerType.LADDER then
        list = ex.Player.rank_data.rank_ladder_list
        data_self = ex.Player.rank_data.rank_ladder_self
    elseif self.layer_type == RankTopThreeLayerType.FLOATING_ISLANDS_BOSS then
        list = ex.Player.rank_data.rank_floating_islands_list
        data_self = ex.Player.rank_data.rank_floating_islands_self
    elseif self.layer_type == RankTopThreeLayerType.BUY_GOLD then
        list = ex.Player.rank_data.rank_buy_gold_list
        data_self = ex.Player.rank_data.rank_buy_gold_self
    elseif self.layer_type == RankTopThreeLayerType.PUB_TASK then
        list = ex.Player.rank_data.rank_pub_task_list
        data_self = ex.Player.rank_data.rank_pub_task_self
    elseif self.layer_type == RankTopThreeLayerType.TRIAL then
        list = ex.Player.rank_data.rank_trial_list
        data_self = ex.Player.rank_data.rank_trial_self
    elseif self.layer_type == RankTopThreeLayerType.QUICK_BATTLE then
        list = ex.Player.rank_data.rank_quick_battle_list
        data_self = ex.Player.rank_data.rank_quick_battle_self
    elseif self.layer_type == RankTopThreeLayerType.GOD_RELIC then
        list = ex.Player.rank_data.rank_god_relic_list
        data_self = ex.Player.rank_data.rank_god_relic_self
    end

    self.layer.cell_self:initData(data_self, self.layer_type)

    if self.layer_type == RankTopThreeLayerType.CHAPTER or 
        self.layer_type == RankTopThreeLayerType.TOWER or 
        self.layer_type == RankTopThreeLayerType.MAGIC_TOWER or 
        self.layer_type == RankTopThreeLayerType.PVP or 
        self.layer_type == RankTopThreeLayerType.PLAYER or 
        self.layer_type == RankTopThreeLayerType.CROSS_FIGHTING or 
        self.layer_type == RankTopThreeLayerType.DUNGEON or 
        self.layer_type == RankTopThreeLayerType.LADDER or 
        self.layer_type == RankTopThreeLayerType.FLOATING_ISLANDS_BOSS or 
        self.layer_type == RankTopThreeLayerType.BUY_GOLD or 
        self.layer_type == RankTopThreeLayerType.PUB_TASK or 
        self.layer_type == RankTopThreeLayerType.TRIAL or 
        self.layer_type == RankTopThreeLayerType.QUICK_BATTLE or 
        self.layer_type == RankTopThreeLayerType.GOD_RELIC then
        for i=1,3 do
            local data = list[i]
            self.layer["node_"..i]:setVisible(data ~= nil)
            if data ~= nil then
                ex.Tools:setSpriteFrame(self.layer["spr_head_"..i], string.format("head-icon/%d.png", data.head_id))
                ex.Tools:setSpriteFrame(self.layer["spr_top_bg_"..i], ex.Tools:getBorderIconByIdx(data.border_id))
                self.layer["lbl_name_"..i]:setString(data.name)
            end
        end
    elseif self.layer_type == RankTopThreeLayerType.CLAN or 
            self.layer_type == RankTopThreeLayerType.CROSS_CLAN then
        for i=1,3 do
            local data = list[i]
            self.layer["node_"..i]:setVisible(data ~= nil)
            self.layer["spr_top_bg_"..i]:setVisible(self.layer_type ~= RankTopThreeLayerType.CLAN)
            if data ~= nil then
                ex.Tools:setSpriteFrame(self.layer["spr_head_"..i], string.format("clan-photo/%02d.png", data.clan_photo))
                ex.Tools:setSpriteFrame(self.layer["spr_top_bg_"..i], ex.Tools:getBorderIconByIdx(data.border_id))
                self.layer["lbl_name_"..i]:setString(data.clan_name)
            end
        end

        if tonumber(ex.Player.clan_data.clan_id) > 0 and data_self.rank > 0 then
            self.layer.cell_self:setVisible(true)
            if self.layer.spr_rank_bg_self.lbl_tips ~= nil then
                self.layer.spr_rank_bg_self.lbl_tips:removeFromParent()
                self.layer.spr_rank_bg_self.lbl_tips = nil
            end
            self.layer.cell_self:initData(data_self, self.layer_type)
        else
            self.layer.cell_self:setVisible(false)
            -- 添加未加入公会提示
            if self.layer.spr_rank_bg_self.lbl_tips == nil then
                self.layer.spr_rank_bg_self.lbl_tips = cc.Label:createWithTTF(ex.Tools:getLang(47317), FONT_DEFAULT_NAME_BOLD, 50)
                self.layer.spr_rank_bg_self.lbl_tips:setScale(0.5)
                self.layer.spr_rank_bg_self.lbl_tips:setPosition(self.layer.spr_rank_bg_self:getContentSize().width * 0.5, self.layer.spr_rank_bg_self:getContentSize().height * 0.5)
                self.layer.spr_rank_bg_self:addChild(self.layer.spr_rank_bg_self.lbl_tips)
            end
        end
    end

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = RankTopThreeCell:createWithCCBIFile("ccbi/RankTopThreeCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data, self.layer_type)
        cell:setTableView(self.layer.scroll_view)
    
        cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))

        return cell
    end

    self.layer.scroll_view:reloadData(list)

    self.layer.cell_self.spr_frame:setVisible(self.layer_type ~= RankTopThreeLayerType.CLAN and self.layer_type ~= RankTopThreeLayerType.CROSS_CLAN)
end

function RankTopThreeCtr:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.role_id, pSender.player_server_id)
end

return RankTopThreeCtr
