local GREndCell = class("GREndCell", require("src.comp.EventLayer"))

function GREndCell:onCreate()

    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0, 0)
    self:setPosition(cc.p(0, 0))
end

function GREndCell:reset(data)
    local mission_config = cfg.godrelic.getMissionConfig(data.data.starMap.chapter, data.data.starMap.level)
    if not mission_config then
        self:removeAllChildren()
        return
    end

    for i,v in ipairs(mission_config.target) do
        self["lbl_condition"..i]:setString(ex.Tools:getLang(cfg.godrelictarget.godrelictarget[v].language))
        if TableEx.isInTable(data.data.starMap.complete_id, v) ~= nil then
            ex.Tools:setSpriteFrame(self["spr_star"..i], "other/star-0.png")
        else
            ex.Tools:setSpriteFrame(self["spr_star"..i], "god-relic/xxwx.png")
        end
    end

    local scroll_view = self:getParent().scroll_view
    scroll_view:setViewSize(cc.size(scroll_view:getViewSize().width, 110))
    scroll_view:setPositionY(30)

    local is_show_gift = false
    for k,v in pairs(cfg.promotionlimitedsetgodrelic.promotionlimitedsetgodrelic) do
        if mission_config.idx == v.god_relic_id then
            is_show_gift = true
            break
        end
    end
    if is_show_gift == true then
        local vec_gift = ex.Player.promotion_data:getGodRelicGiftData()
        require("src.layer.GRMissionGiftCtr"):instance():openWindow(vec_gift, true)
    end
end

function GREndCell:fixHeight(height)
    return self:getContentSize().height - 290
end

return GREndCell