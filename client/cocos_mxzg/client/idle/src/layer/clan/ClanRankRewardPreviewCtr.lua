local ClanRankRewardPreviewCtr = class("ClanRankRewardPreviewCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanRankRewardPreviewLayer = class("ClanRankRewardPreviewLayer", require("src.comp.EventLayer"))

local ClanRankRewardPreviewCell = class("ClanRankRewardPreviewCell", require("src.comp.LuaLayerBase"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ClanRankRewardPreviewCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ClanRankRewardPreviewLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.viewSize = self.spr_scroll_bg:getContentSize()
    self.viewSize.height = self.viewSize.height - 10

    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 105))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function ClanRankRewardPreviewCtr:onCreate()
    self:setCCBIPath("ccbi/ClanRankRewardPreviewLayer.ccbi")
    self:setIsSingle(false)
end

function ClanRankRewardPreviewCtr:getLayerClass()
    return ClanRankRewardPreviewLayer
end

function ClanRankRewardPreviewCtr:getClanRankRewardPreviewLayer()
    return self.layer
end

function ClanRankRewardPreviewCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanRankRewardPreviewCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    -- self.offset_1 = 0
    -- self.offset_2 = 0

    self:onTab(1)
end

function ClanRankRewardPreviewCtr:onTab(tag, pSender)
    self.layer_type = tag

    self:updateScrollView()
end

function ClanRankRewardPreviewCtr:updateScrollView()
    self.layer.scroll_view:getContainer():removeAllChildren()
    
    local vec_item = {}
    for i, v in ipairs(cfg.clanbossrankreward.clanbossrankreward) do
        if v.boss_id == ex.Player.clan_data.clan_mission_cur_boss_idx then
            table.insert(vec_item, v)
        end
    end
    local item_count = table.nums(vec_item)

    self.layer.scroll_view.createItemFunction = function(data, scale)
        -- 创建ccbi cell
        local cell_rank = ClanRankRewardPreviewCell:createWithCCBIFile("ccbi/ClanRankRewardPreviewCell.ccbi")
        cell_rank:setAnchorPoint(0.5, 0.5)
        cell_rank:setIgnoreAnchorPointForPosition(false)

            if data.rank_low == data.rank_up then
                cell_rank.lbl_rank:setVisible(false)
                -- cell_rank.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank_low))
                ex.Tools:setSpriteFrame(cell_rank.spr_rank, string.format("rank/spr-paihang-%s.png", data.rank_low))
            else
                cell_rank.spr_rank:setVisible(false)
                cell_rank.lbl_rank:setString(""..data.rank_low.."-"..data.rank_up)
            end

            local menu = cpp.UIMenu:create()
            :setIsTouchInsideNode(self.layer.scroll_view)
            :setSwallowsTouches(false)
            :setPosition(cc.p(0, 0))
            :setName("menu_reward")
            cell_rank:addChild(menu)
        
            local item_size = cc.size(100, 100)
            for i2,v2 in ipairs(data.rank_reward) do
                local item_backpack = ex.Tools:createBackpackItem(v2.item_type, v2.item_num)
                item_backpack:registerScriptTapHandler(handler(self, self.onItemInfo))
                item_backpack:setPosition(cell_rank:getContentSize().width - (item_size.width + 5) * (i2 - 0.5), cell_rank:getContentSize().height / 2)
                item_backpack:setScale(0.8)
                menu:addChild(item_backpack)
        end

        return cell_rank
    end
    self.layer.scroll_view:reloadData(vec_item)
end

function ClanRankRewardPreviewCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

return ClanRankRewardPreviewCtr
