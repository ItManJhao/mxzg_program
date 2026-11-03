local SuperStageHistoryCtr = class("SuperStageHistoryCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageHistoryLayer = class("SuperStageHistoryLayer", require("src.comp.EventLayerAdaptiveWidth"))

local SuperStageHistoryCell = class("SuperStageHistoryCell", require("src.comp.EventLayer"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

-----------------------------------------------------------------------------
function SuperStageHistoryCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
end

function SuperStageHistoryCell:initData(data)
    self.data = data
    self.btn_data.data = data

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/super-stage-icon.plist")

    -- 戰鬥時間
    local time_start = os.date("*t", data.battle_time)
    self.lbl_time:setString(string.format("%d-%02d-%02d %02d:%02d:%02d",
                                          time_start.year,
                                          time_start.month,
                                          time_start.day,
                                          time_start.hour,
                                          time_start.min,
                                          time_start.sec))

    local config_stage_1 = cfg.superstage.superstage[data.attacker.stage_id] or {}
    local config_stage_2 = cfg.superstage.superstage[data.defender.stage_id] or {}
    local str_default = ex.Tools:getLang(74845)

    -- 攻方
    ex.Tools:setSpriteFrame(self.spr_photo1, "head-icon/"..data.attacker.head_id..".png")
    ex.Tools:setSpriteFrame(self.spr_frame1, ex.Tools:getBorderIconByIdx(data.attacker.border_id))
    ex.Tools:setSpriteFrame(self.spr_rank1, "super-stage-icon/rank-2-"..(config_stage_1.icon_idx or 1)..".png")

    self.spr_win1:setVisible(data.win)

    self.lbl_name1:setString(data.attacker.name)
    self.lbl_server1:setString(ex.StringUtil.getServerName(data.attacker.server_id))
    self.lbl_rank1:setString((config_stage_1.name_lang ~= nil and ex.Tools:getLang(config_stage_1.name_lang) or str_default))
    self.lbl_rank_num1:setString(data.attacker.rank > 0 and data.attacker.rank or str_default)
    self.lbl_level1:setString(data.attacker.level)
    
    -- 守方
    ex.Tools:setSpriteFrame(self.spr_photo2, "head-icon/"..data.defender.head_id..".png")
    ex.Tools:setSpriteFrame(self.spr_frame2, ex.Tools:getBorderIconByIdx(data.defender.border_id))
    ex.Tools:setSpriteFrame(self.spr_rank2, "super-stage-icon/rank-2-"..(config_stage_2.icon_idx or 1)..".png")

    self.spr_win2:setVisible(not data.win)

    self.lbl_name2:setString(data.defender.name)
    self.lbl_server2:setString(ex.StringUtil.getServerName(data.defender.server_id))
    self.lbl_rank2:setString((config_stage_2.name_lang ~= nil and ex.Tools:getLang(config_stage_2.name_lang) or str_default))
    self.lbl_rank_num2:setString(data.defender.rank > 0 and data.defender.rank or str_default)
    self.lbl_level2:setString(data.defender.level)
end

function SuperStageHistoryCell:onReport(tag, pSender)
    require("src.layer.superstage.SuperStageHistoryVideoCtr"):instance():openWindow({pSender.data.battle_log}, pSender.data.battle_time)
end

-----------------------------------------------------------------------------
function SuperStageHistoryLayer:onCreate()
    self:addBlackBackground()
    self.scroll_view:setItemType(1)
    self.scroll_view:setItemSize(cc.size(560.0, 280))

    self.btn_tab_1:setLabelText(ex.Tools:getLang(5643))
    self.btn_tab_2:setLabelText(ex.Tools:getLang(5056))
end

-----------------------------------------------------------------------------
function SuperStageHistoryCtr:onCreate()
    self:setCCBIPath("ccbi/SuperStageHistoryLayer.ccbi")
    self:setIsSingle(false)
end

function SuperStageHistoryCtr:getLayerClass()
    return SuperStageHistoryLayer
end

function SuperStageHistoryCtr:openWindow(callback_change_tab_req, callback_data, str_tip_title, str_tip)
    if self:isOpened() then
        return
    end

    self.callback_change_tab_req = callback_change_tab_req
    self.callback_data = callback_data
    self.str_tip_title = str_tip_title
    self.str_tip = str_tip

    self:loadLayer()
    self:open()
    self:initData()
end

function SuperStageHistoryCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
    self.layer.btn_tab_1:registerScriptTapHandler(handler(self, self.onTab))
    self.layer.btn_tab_2:registerScriptTapHandler(handler(self, self.onTab))

    self.layer:addEvent(EVENT.SUPER_STAGE.BATTLE_LOG, handler(self, self.updateLayer))
    self.layer:addEvent(EVENT.SUPER_STAGE.SUPER_BATTLE_LOG, handler(self, self.updateLayer))

    local stage_id = ex.Player.super_stage_data.cur_stage_id
    local config_stage = cfg.superstage.superstage[stage_id > 0 and stage_id or 1]
    self.layer.lbl_my_stage_title:setString(self.str_tip_title)
    self.layer.lbl_my_stage:setString(self.str_tip)

    self.select_type = 0
    self:onTab(1)
end

function SuperStageHistoryCtr:onTab(tag, pSender)
    if self.select_type == tag then
        return
    end
    self.select_type = tag

    self.callback_change_tab_req(self.select_type)

    self:updateLayer()
end

function SuperStageHistoryCtr:updateLayer()
    self.layer.btn_tab_1:setChecked(self.select_type == 1)
    self.layer.btn_tab_2:setChecked(self.select_type == 2)

    self.layer.lbl_my_stage_title:setVisible(self.select_type == 1)
    self.layer.lbl_my_stage:setVisible(self.select_type == 1)

    -- 判断类型读取对应的记录
    local video_data = self.callback_data(self.select_type)

    -- 
    self.layer.scroll_view.createItemFunction = function(data, scale)
        local cell = SuperStageHistoryCell:createWithCCBIFile("ccbi/SuperStageHistoryCell.ccbi")
        cell:initData(data)
        return cell
    end
    self.layer.scroll_view:reloadData(video_data)
end

return SuperStageHistoryCtr
