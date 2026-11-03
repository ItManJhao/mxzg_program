--[[
    讨伐团战报界面
    在讨伐团Boss挑战界面调用
]]

local CrusadeGroupBattleLogCtr = class("CrusadeGroupBattleLogCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupBattleLogLayer = class("CrusadeGroupBattleLogLayer", require("src.comp.EventLayerAdaptiveWidth"))

local CrusadeGroupBattleLogCell = class("CrusadeGroupBattleLogCell", require("src.comp.LuaLayerBase"))

-----------------------------------------------------------------------------
function CrusadeGroupBattleLogCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.btn_photo:setContentSize(self.spr_photo:getContentSize())
end

function CrusadeGroupBattleLogCell:initData(data)
    self.data = data

    self.btn_photo.role_id = data.rid
    self.btn_photo.player_server_id = data.server_id

    self.btn_report.battle_id = data.battle_id

    if self.spr_rank ~= nil then
        self.spr_rank:setVisible(false)
        self.lbl_rank:setVisible(true)
        self.lbl_rank:enableShadow(FONT_BLACK_C4B, cc.size(1, -1))
        if data.rank > 0 and data.rank < 4 then 
            self.spr_rank:setVisible(true)
            self.lbl_rank:setVisible(false)
            -- self.spr_rank:setSpriteFrame(string.format("rank/spr-paihang-%s.png", data.rank))
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

    ex.Tools:setSpriteFrame(self.spr_photo, "head-icon/"..data.head_id..".png")
    ex.Tools:setSpriteFrame(self.spr_border, ex.Tools:getBorderIconByIdx(data.border_id))
    self.lbl_level:setString(data.level)

    self.lbl_name:setString(data.nick)
    self.lbl_num:setString(string.format(ex.Tools:getLang(75405), data.damage))
end

-----------------------------------------------------------------------------
function CrusadeGroupBattleLogLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.scroll_view:setItemSize(cc.size(560, 115))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function CrusadeGroupBattleLogCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupBattleLogLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupBattleLogCtr:getLayerClass()
    return CrusadeGroupBattleLogLayer
end

function CrusadeGroupBattleLogCtr:openWindow(town_id)
    if self:isOpened() then
        return
    end

    self.town_id = town_id
    
    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupBattleLogCtr:initData()
    self.layer:addEvent(EVENT.CRUSADE_GROUP.UPDATE_BOSS_BATTLE_LOG, handler(self, self.receiveEvent))
    
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self:updateLayer()

    local req = CrusadeGroup_pb.GReqBossChallengeRecord()
    req.territory_id = self.town_id
    NetManager:sendMessage(ProtocolID.GReqBossChallengeRecord, req)
end

function CrusadeGroupBattleLogCtr:updateLayer()
    self:updateScrollView()
end

function CrusadeGroupBattleLogCtr:updateScrollView()
    if self.record_data == nil or self.record_data.territory_id ~= self.town_id or self.record_data.records == nil then
        return
    end

    local item_list = self.record_data.records

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupBattleLogCell:createWithCCBIFile("ccbi/CrusadeGroupBattleLogCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell.btn_photo:registerScriptTapHandler(handler(self, self.onPlayerInfo))
        cell.btn_report:registerScriptTapHandler(handler(self, self.onBattleReport))

        cell:initData(data)
    
        return cell
    end

    self.layer.scroll_view:reloadData(item_list)
end

function CrusadeGroupBattleLogCtr:receiveEvent(event, data)
    if self.town_id ~= data.territory_id then
        return
    end
    
    table.sort( data.records, function(a,b)return a.damage > b.damage end )
    self.record_data = data
    for i,v in ipairs(self.record_data.records) do
        v.rank = i
    end

    self:updateLayer()
end

-- 玩家信息
function CrusadeGroupBattleLogCtr:onPlayerInfo(tag, pSender)
    ex.Tools:showPlayerInfo(pSender.role_id, pSender.player_server_id)
end

-- 战报回放
function CrusadeGroupBattleLogCtr:onBattleReport(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER)

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.BATTLE_REPORT, BattleType.CRUSADE_GROUP_AREA)

    local req = CrusadeGroup_pb.GReqBossReport()
    req.battle_id = pSender.battle_id
    NetManager:sendMessage(ProtocolID.GReqBossReport, req)

    self:closeWindow()
end

return CrusadeGroupBattleLogCtr