local FantasyTowerLogCtr = class('FantasyTowerLogCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FantasyTowerLogLayer = class('FantasyTowerLogLayer', require("src.comp.EventLayerAdaptiveWidth"))

function FantasyTowerLogLayer:onCreate()
    self:addBlackBackground()
    -- self.scroll_view:setBounceable(false)

    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 130))
    self.scroll_view:setItemType(1)

    self:addEvent(EVENT.TOWER_EVENT.TOWER_LOG, handler(self, self.updateReport))
end

function FantasyTowerLogLayer:updateReport()
    local data = ex.Player.tower_data.log
    if not data then
        return
    end

    -- 重新组建数据
    local vec_data = {data.fastest.battle_id ~= "" and data.fastest or nil, data.lowest.battle_id ~= "" and data.lowest or nil, data.lowest.battle_id ~= "" and data.self.battle_id ~= "" and data.self or nil}

    self.scroll_view.createItemFunction = function(data, scale, index)
        -- 创建ccbi cell
        local cell = require("src.layer.fantasytower.FantasyTowerLogCell"):createWithCCBIFile("ccbi/FantasyTowerLogCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
        cell:reset(data, index)
        return cell
    end
    self.scroll_view:reloadData(vec_data)
end

-----------------------------------------------------------------------------
function FantasyTowerLogCtr:onCreate()
    self:setCCBIPath('ccbi/FantasyTowerLogLayer.ccbi')
    self:setIsSingle(false)
end

function FantasyTowerLogCtr:getLayerClass()
    return FantasyTowerLogLayer
end

function FantasyTowerLogCtr:getFantasyTowerLogLayer()
    return self.layer
end

function FantasyTowerLogCtr:openWindow(stage, callback)
    if self:isOpened() then
        return
    end
    
    self:loadLayer()
    self:open()
    self:initData(stage, callback)
end

function FantasyTowerLogCtr:initData(stage, callback)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer:updateReport()

end

return FantasyTowerLogCtr
