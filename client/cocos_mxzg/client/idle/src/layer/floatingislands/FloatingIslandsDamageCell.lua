local FloatingIslandsDamageCell = class("FloatingIslandsDamageCell", require("src.comp.EventLayer"))

function FloatingIslandsDamageCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)

    self.scroll_view:setItemSize(cc.size(90, 90))
end

function FloatingIslandsDamageCell:reset(data, index)
    if index % 2 == 0 then
        ex.Tools:setScale9SpriteFrame(self.spr_bg, "floating-Islands/spr-bg-2.png", cc.rect(10, 25, 3, 3))
    end

    if data.dmg_value < 100000000 then
        self.lbl_damage:setString(data.dmg_value / 10000)
        ex.Tools:setSpriteFrame(self.spr_unit, "lang-1/spr-million-1.png")
    else
        self.lbl_damage:setString(data.dmg_value / 100000000)
    end

    self.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:setScale(0.8)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view:setViewSize(cc.size(math.min(self.scroll_view.item_size.width * table.nums(data.reward), 320), self.scroll_view:getViewSize().height))
    self.scroll_view:reloadData(data.reward)
    self.scroll_view:setFocus(table.nums(data.reward))
end

return FloatingIslandsDamageCell