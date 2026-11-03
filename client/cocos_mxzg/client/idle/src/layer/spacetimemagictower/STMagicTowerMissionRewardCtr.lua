local STMagicTowerMissionRewardCtr = class("STMagicTowerMissionRewardCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local STMagicTowerMissionRewardLayer = class("STMagicTowerMissionRewardLayer", require("src.comp.EventLayerAdaptiveWidth"))
local STMagicTowerMissionRewardCell = class("STMagicTowerMissionRewardCell", require("src.comp.LuaLayerBase"))

-----------------------------------------------------------------------------
function STMagicTowerMissionRewardLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

-------------------------------------STMagicTowerMissionRewardCell-------------------------------------
function STMagicTowerMissionRewardCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)
end

function STMagicTowerMissionRewardCell:reset(data)
    if not data then
        return
    end

    self.data = data
    self.lbl_mission_title:setString(string.format(ex.Tools:getLang(75618), data.mission))
    if data.reward and #data.reward > 0 then
        local startX = self:getContentSize().width / 2
        local scale = 1
        local offsetX = 28
        for i, v in ipairs(data.reward) do
            local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
            local itemW = item:getContentSize().width * scale
            local itemH = item:getContentSize().height * scale

            if i == 1 then
                local halfNum = math.floor(#data.reward / 2)
                if #data.reward % 2 == 0 then
                    startX = self:getContentSize().width / 2 - (halfNum - 1) * (itemW + offsetX) - (itemW + offsetX) / 2
                else
                    startX = self:getContentSize().width / 2 - halfNum * (itemW + offsetX)
                end
            end

            item:setScale(scale)
            item:setPosition(startX + (i - 1) * (itemW + offsetX), 16 +  itemH / 2)
            item:registerScriptTapHandler(handler(self, self.onItemInfo))
            self.menu:addChild(item)
        end
    end
end

function STMagicTowerMissionRewardCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function STMagicTowerMissionRewardCtr:onCreate()
    self:setCCBIPath("ccbi/STMagicTowerMissionRewardLayer.ccbi")
    self:setIsSingle(false)
end

function STMagicTowerMissionRewardCtr:getLayerClass()
    return STMagicTowerMissionRewardLayer
end

function STMagicTowerMissionRewardCtr:openWindow(level)
    if self:isOpened() then
        return
    end

    self.level = level

    self:loadLayer()
    self:open()
    self:initData(level)
end

function STMagicTowerMissionRewardCtr:initData(level)
    local configs = cfg.timetowermisson.getConfigsByLevel(level)
    if not configs or #configs == 0 then
        return
    end

    self.layer.scroll_view:setItemType(1)
    local sv_width = self.layer:getContentSize().width - 80
    local sv_height = self.layer:getContentSize().height - 136
    self.layer.scroll_view:setViewSize(cc.size(sv_width, sv_height))
    self.layer.scroll_view:setItemSize(cc.size(self.layer.scroll_view:getViewSize().width, 174))
    self.layer.scroll_view.createItemFunction = function(item_data, scale)
    local cell = STMagicTowerMissionRewardCell:createWithCCBIFile("ccbi/STMagicTowerMissionRewardCell.ccbi")
        cell:reset(item_data)
        cell.menu:setSwallowsTouches(false)
        cell.menu:setIsTouchInsideNode(self.layer.scroll_view)
        return cell
    end
    self.layer.scroll_view:reloadData(configs)
end

return STMagicTowerMissionRewardCtr
