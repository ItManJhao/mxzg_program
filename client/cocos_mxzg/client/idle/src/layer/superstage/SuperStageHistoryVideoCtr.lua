local SuperStageHistoryVideoCtr = class("SuperStageHistoryVideoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local SuperStageHistoryVideoLayer = class("SuperStageHistoryVideoLayer", require("src.comp.EventLayerAdaptiveWidth"))

-----------------------------------------------------------------------------
function SuperStageHistoryVideoLayer:onCreate()
    self:addBlackBackground()
    self.scroll_view:setItemType(1)
    self.scroll_view:setItemSize(cc.size(560.0, 480))
end

-----------------------------------------------------------------------------
function SuperStageHistoryVideoCtr:onCreate()
    self:setCCBIPath("ccbi/SuperStageHistoryVideoLayer.ccbi")
    self:setIsSingle(false)
end

function SuperStageHistoryVideoCtr:getLayerClass()
    return SuperStageHistoryVideoLayer
end

function SuperStageHistoryVideoCtr:openWindow(vec_battle_log, log_time)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData(vec_battle_log, log_time)
end

function SuperStageHistoryVideoCtr:initData(vec_battle_log, log_time)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.vec_battle_log = vec_battle_log
    self.log_time = log_time

    self:updateLayer()
end

function SuperStageHistoryVideoCtr:updateLayer()
    self.layer.scroll_view.createItemFunction = function(data, scale)
        local video_data = {}
        video_data.battle_log = data
        video_data.id = 1
        video_data.type = 1
        video_data.subtype = 1
        video_data.time = self.log_time

        local cell = require("src.layer.videostudio.VideoStudioCell"):createWithCCBIFile("ccbi/VideoStudioCell.ccbi")
        cell:resetSuperStageHistory(video_data)
        cell:setAutoClose(false)
        cell:setSwallowTouches(false)
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)

        cell.lbl_type:setString(ex.Tools:getLang(74941))

        return cell
    end
    self.layer.scroll_view:reloadData(self.vec_battle_log)
end

return SuperStageHistoryVideoCtr
