local SevenDayCell = class("SevenDayCell", require("src.comp.EventLayer"))

function SevenDayCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:createMenu()
    self:reset(nil)
end

function SevenDayCell:reset(data)
    if not data then return end
    self.data = data
    self.node_geted:setVisible(false)
    self:setSelected(true)
    self:setIcon(self.data.item[1].item_type)
    self:setDay(self.data.day)
    self.lbl_tips:setString(ex.Tools:getLang(self.data.lan or 0))
end

function SevenDayCell:setDay(day)
    -- body
    self.lbl_skew:setString(string.format(ex.Tools:getLang(47721), day))
end

function SevenDayCell:setIcon(item_type)
    if not item_type then item_type = 900102 end
    local str 
    local item_config = cfg.item.item[item_type]

    print("item_type = ", item_type)
    local is_piece = ex.Player.backpack_data:isPiece(item_type)
    str = item_type == 0 and "backpack/item-default-2.png" or string.format( "%s.png", item_config.icon)

    -- local type = ex.Player.backpack_data:getPropType(item_type)

    -- if ItemData.IT_PIECE == type then 
    --     str = string.format("hero-icon/%d.png", item_type - 10000000)

    -- else
    --     str = item_type == 0 and "backpack/item-default-2.png" or string.format("backpack/%d.png", item_type)
    -- end
    
    local scale = item_type == 0 and 0.5 or 1
    -- self.spr_icon:setSpriteFrame(str)
    ex.Tools:setSpriteFrame(self.spr_icon, str)
    
    self.spr_icon:setScale(scale)
    self.spr_ps:setVisible(is_piece)
end

function SevenDayCell:setSelected( selected )
    -- body
    self.selected = selected
    self.spr_select:setVisible(self.selected)
end

function SevenDayCell:createMenu()
    self.menu = cpp.UIMenu:create()
    self:addChild(self.menu)
    self.menu:setPosition(0,0)
    self.item = cpp.UIMenuItemImage:createWithSpriteFrameName("seven-day-gift/spr-day-cell-bg.png", "seven-day-gift/spr-day-cell-bg.png", "seven-day-gift/spr-day-cell-bg.png")
    self.menu:addChild(self.item)
    local size = self.item:getContentSize()
    self.item:setPosition(size.width / 2 ,size.height / 2)


    self.spr_bg:removeFromParent()

    self.spr_icon:retain()
    self.spr_icon:removeFromParent()
    self.item:addChild(self.spr_icon)
    self.spr_icon:release()

    self.spr_select:retain()
    self.spr_select:removeFromParent()
    self.item:addChild(self.spr_select)
    self.spr_select:release()

    self.lbl_tips:retain()
    self.lbl_tips:removeFromParent()
    self.item:addChild(self.lbl_tips)
    self.lbl_tips:release()

    self.node_geted:retain()
    self.node_geted:removeFromParent()
    self.item:addChild(self.node_geted)
    self.node_geted:release()

    self.spr_skew_bg:retain()
    self.spr_skew_bg:removeFromParent()
    self.item:addChild(self.spr_skew_bg)
    self.spr_skew_bg:release()

    self.lbl_skew:retain()
    self.lbl_skew:removeFromParent()
    self.item:addChild(self.lbl_skew)
    self.lbl_skew:release()
end

function SevenDayCell:setGray()
    ex.Tools:setGrayAuto(self.item:getNormalImage(), true)
    ex.Tools:setGrayAuto(self.item:getSelectedImage(), true)
    ex.Tools:setGrayAuto(self.spr_icon, true)
    ex.Tools:setGrayAuto(self.spr_skew_bg, true)
end

return SevenDayCell