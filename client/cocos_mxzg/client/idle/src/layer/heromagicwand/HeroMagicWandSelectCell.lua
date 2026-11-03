
local HeroMagicWandSelectCell = class("HeroMagicWandSelectCell", require("src.layer.ui.UI_HeroMagicWandSelectCell"))

function HeroMagicWandSelectCell:onCreate()
    self.super.onCreate(self)
	self:setName("HeroMagicWandSelectCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

function HeroMagicWandSelectCell:resetData(magic_id, data, callback)
    self.magic_id = magic_id
    self.data = data
    self.callback = callback

    if self.data == nil then
        return
    end
    self.item:refreshData(data.item_type, 0, data.magic_id)
    self.item:setStrengthen(data.strengthen_lv)

    for i,v in ipairs(data.base_attrs) do
        self["lbl_attr"..i]:setString(ex.Tools:getAttrText(v.attr_id, v.attr_value_old))
    end

    for i,v in ipairs(data.random_attrs) do
        self["lbl_attr_rand"..i]:setString(ex.Tools:getAttrText(v.attr_id, v.attr_value_old))
    end

    local num = math.max(0, table.nums(data.random_attrs))
    for i=1, 4 do
        if i > num then
            self["lbl_attr_rand"..i]:setVisible(false)
        end
    end
end

function HeroMagicWandSelectCell:setScrollView(scroll_view)
    self.menu:setIsTouchInsideNode(scroll_view)
end

function HeroMagicWandSelectCell:onWear()
    if self.callback then
        self.callback(self.magic_id, self)
    end
end

function HeroMagicWandSelectCell:onEquip()
    ex.Tools:onClickItemInfo(self.data.item_type, self.data.magic_id)
end

return HeroMagicWandSelectCell