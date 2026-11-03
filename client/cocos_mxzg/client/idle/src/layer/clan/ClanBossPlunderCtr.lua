local ClanBossPlunderCtr = class("ClanBossPlunderCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanBossPlunderLayer = class("ClanBossPlunderLayer", require("src.comp.EventLayerAdaptiveWidth"))

local ClanBossPlunderCell = class("ClanBossPlunderCell", require("src.comp.LuaLayerBase"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function ClanBossPlunderCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ClanBossPlunderCell:initData(data)
    self.data = data
    self.btn_plunder.data = data

    self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..data.nick)
    self.lbl_clan_name:setString(ex.Tools:getLang(52203) .. data.clan_name)
    self.lbl_point:setString(data.point)
    self.lbl_rank:setString(data.rank)
    self.lbl_fighting:setString(data.fighting)
    
    self.scroll_view.margin = 0
    self.scroll_view:setCreateNum(1)
    self.scroll_view:setSwallowsTouches(false)
    self.scroll_view:setItemSize(cc.size(60, 60))
    self.scroll_view.createItemFunction = function(data, scale)
        local item_hero = UIMenuItemHero:createWithData(0, data.hero_type, data.elem, data.level, data.star)
        if data.fashion_id ~= 0 and data.fashion_id ~= nil then   -- 有皮肤
            item_hero:setFashionShowForce(data.fashion_id)
        end
        item_hero:setScale(0.5)
        return item_hero
    end
    self.scroll_view:reloadData(data.heros)
end

function ClanBossPlunderLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 155))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function ClanBossPlunderCtr:onCreate()
    self:setCCBIPath("ccbi/ClanBossPlunderLayer.ccbi")
    self:setIsSingle(false)
end

function ClanBossPlunderCtr:getLayerClass()
    return ClanBossPlunderLayer
end

function ClanBossPlunderCtr:getClanBossPlunderLayer()
    return self.layer
end

function ClanBossPlunderCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanBossPlunderCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    NetManager:sendMessage(ProtocolID.GReqScanRoleRank)

    -- self.offset_1 = 0
    -- self.offset_2 = 0

    self:onTab(1)
end

function ClanBossPlunderCtr:onTab(tag, pSender)
    self.layer_type = tag

    self:updateTableView()
end

function ClanBossPlunderCtr:updateTableView()
    self.layer.scroll_view.createItemFunction = function(data, scale)
        -- 创建ccbi cell
        local cell_rank = ClanBossPlunderCell:createWithCCBIFile("ccbi/ClanBossPlunderCell.ccbi")
        cell_rank:setIgnoreAnchorPointForPosition(false)
        cell_rank:setAnchorPoint(0.5, 0.5)

        cell_rank:initData(data)

        cell_rank.btn_plunder:registerScriptTapHandler(handler(self, self.onPlunder))
        return cell_rank
    end
    self.layer.scroll_view:reloadData(ex.Player.clan_data.clan_boss_plunder_list)
end

function ClanBossPlunderCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 开始挑战
function ClanBossPlunderCtr:onPlunder(tag, pSender)
    -- print("ClanBossPlunderCtr:onPlunder", tag)
    self.data = pSender.data
    require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47524),
                                                             ex.Tools:getLang(47064),
                                                             BattleType.CLAN_BOSS,
                                                             handler(self, self.onBattleConfirm))

end

function ClanBossPlunderCtr:onBattleConfirm(vec_battle, fetter_type)
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_BATTLE_ROB, self.data)
    self:closeWindow()
end

return ClanBossPlunderCtr
