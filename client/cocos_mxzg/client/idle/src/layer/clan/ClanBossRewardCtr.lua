local ClanBossRewardCtr = class("ClanBossRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanBossRewardLayer = class("ClanBossRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))

local ClanBossRewardCell = class("ClanBossRewardCell", require("src.comp.LuaLayerBase"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ClanBossRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.lbl_rank:enableOutline(FONT_BLACK, 2)

    self.lbl_my_rank:setVisible(false)
    self.lbl_my_rank_tip:setVisible(false)
end

function ClanBossRewardCell:setTableView(table)
    self.menu:setIsTouchInsideNode(table)
    self.menu:setSwallowsTouches(false)
end

function ClanBossRewardCell:reset(data)
    if data == nil then
        return
    end

    if data.rank_low == data.rank_up then
        if data.rank_low <= 3 then
            self.spr_rank:setSpriteFrame("rank/spr-paihang-"..data.rank_low..".png")
            self.lbl_rank:setVisible(false)
        else 
            self.spr_rank:setVisible(false)
            self.lbl_rank:setString(string.format("%d", data.rank_low))
        end
    else
        self.spr_rank:setVisible(false)
        self.lbl_rank:setString(string.format("%d-%d", data.rank_low, data.rank_up))
    end

    local item_size = cc.size(90, 90)
    local begin_x = 20
    local margin = 10
    
    local index = 1
    local item_max = table.nums(data.rank_reward)
    for i,v in ipairs(data.rank_reward) do
        local item_backpack = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item_backpack:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        item_backpack:setPosition(520 + (item_size.width + margin) * (index - item_max - 0.5), self:getContentSize().height * 0.5)
        item_backpack:setScale(0.8)
        self.menu:addChild(item_backpack)

        index = index + 1
    end
end

function ClanBossRewardCell:setMyRank(data)
	self.spr_rank:setVisible(false)
	self.lbl_rank:setVisible(false)

	self.lbl_my_rank:setVisible(true)
	self.lbl_my_rank_tip:setVisible(true)

    if data.rank == nil or data.rank <= 0 or data.rank > 9999 then
        self.lbl_my_rank:setString(ex.Tools:getLang(47124))
        self.lbl_my_rank_tip:setString(ex.Tools:getLang(52106))
    else
        self.lbl_my_rank:setString(ex.Tools:getLang(47055)..data.rank)
        self.lbl_my_rank_tip:setString(ex.Tools:getLang(52105))
    end

    if data.rank_reward ~= nil then
        local item_size = cc.size(90, 90)
        local begin_x = 20
        local margin = 10
        
        local index = 1
        local item_max = table.nums(data.rank_reward)
        for i,v in ipairs(data.rank_reward) do
            local item_backpack = ex.Tools:createBackpackItem(v.item_type, v.item_num)
            item_backpack:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
            item_backpack:setPosition(500 + (item_size.width + margin) * (index - item_max - 0.5), self:getContentSize().height * 0.5)
            item_backpack:setScale(0.8)
            self.menu:addChild(item_backpack)

            index = index + 1
        end
    end
end

-----------------------------------------------------------------------------
function ClanBossRewardLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.table_view = nil
    
    self.rank_type = 1
    self.btn_left:setChecked(true)
    self.btn_left:setLabelText(ex.Tools:getLang(52103))
    self.btn_left:setTag(1)
    self.btn_right:setLabelText(ex.Tools:getLang(52104))
    self.btn_right:setTag(2)

    self.cell_my_rank = ClanBossRewardCell:createWithCCBIFile("ccbi/ClanBossRewardCell.ccbi")
    self.cell_my_rank:setScale((self.spr_self_bg:getContentSize().width - 10) / self.cell_my_rank:getContentSize().width)
    self.cell_my_rank:setPosition(self.spr_self_bg:getPositionX() + 5, self.spr_self_bg:getPositionY() + 5)
    self:addChild(self.cell_my_rank, 100)

    -- 初始化tableview
    local view_size = cc.size(self.spr_scroll_bg:getContentSize().width - 10, self.spr_scroll_bg:getContentSize().height - 10)
    local pos = cc.p(self.spr_scroll_bg:getPositionX() + 5, self.spr_scroll_bg:getPositionY() + 5)
    self.table_view = ex.Tools:initTableView(self, {}, {ClanBossRewardCell, "ccbi/ClanBossRewardCell.ccbi"}, view_size, 5, pos)
end

-----------------------------------------------------------------------------
function ClanBossRewardCtr:onCreate()
    self:setCCBIPath("ccbi/ClanBossRewardLayer.ccbi")
    self:setIsSingle(false)
end

function ClanBossRewardCtr:getLayerClass()
    return ClanBossRewardLayer
end

function ClanBossRewardCtr:getClanBossRewardLayer()
    return self.layer
end

function ClanBossRewardCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanBossRewardCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer.btn_right:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_left:registerScriptTapHandler(handler(self, self.onTab))

    local clan_boss_data = cfg.clanworldboss.clanworldboss[ex.Player.clan_data.clan_boss_info.boss_id]

    self.rank_data_clan = {}
    for i,v in ipairs(cfg.clanworldbossrewardclan.clanworldbossrewardclan) do
        if v.reward_rank_type == clan_boss_data.reward_rank_type_clan then
            table.insert(self.rank_data_clan, v)
        end
    end
    self.rank_data_player = {}
    for i,v in ipairs(cfg.clanworldbossrewardplayer.clanworldbossrewardplayer) do
        if v.reward_rank_type == clan_boss_data.reward_rank_type_player then
            table.insert(self.rank_data_player, v)
        end
    end

    self:onTab(1)
end

function ClanBossRewardCtr:onTab(tag, pSender)
    self.rank_type = tag

    self:updateLayer()
end

function ClanBossRewardCtr:updateLayer()
    local data_self = {}
    data_self.rank_reward = {}
    local data = nil
    if self.rank_type == 1 then
        data_self.rank = ex.Player.clan_data.clan_boss_rank_clan.my_rank.rank
        data = self.rank_data_clan
    else
        data_self.rank = ex.Player.clan_data.clan_boss_rank_player.my_rank.rank
        data = self.rank_data_player
    end

    if data_self.rank ~= nil then
        for i,v in ipairs(data) do
            if v.rank_low <= data_self.rank and v.rank_up >= data_self.rank then
                data_self.rank_reward = v.rank_reward
                break
            end
        end
    end
    
    self.layer.cell_my_rank:setMyRank(data_self)

    self:updateTableView()
end

function ClanBossRewardCtr:updateTableView()
    local data = nil
    if self.rank_type == 1 then
        data = self.rank_data_clan
    else
        data = self.rank_data_player
    end

    self.layer.table_view:initData(data)
end

return ClanBossRewardCtr
