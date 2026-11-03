local FloatingIslandsEndCell = class("FloatingIslandsEndCell", require("src.comp.LuaLayerBase"))

function FloatingIslandsEndCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0, 0)
    self:setPosition(cc.p(0, 0))

    self.scroll_view:setItemSize(cc.size(130, 110))
    self.scroll_view:setAlignmentCenter(true)
end

function FloatingIslandsEndCell:fixHeight(height)
    return self:getContentSize().height - 390
end

function FloatingIslandsEndCell:reset(data)
    self.lbl_damage:setString(ex.StringUtil.getScientificNumber(data.data.dmg))

    self.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        -- item:setScale(0.6)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view:reloadData(data.vec_reward)

end

return FloatingIslandsEndCell