
local HeroMagicWandIllustrateCell = class("HeroMagicWandIllustrateCell", require("src.layer.ui.UI_HeroMagicWandIllustrateCell"))

function HeroMagicWandIllustrateCell:onCreate()
    self.super.onCreate(self)
	self:setName("HeroMagicWandIllustrateCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)
end

function HeroMagicWandIllustrateCell:resetData(data)
    self.data = data

    self.item:refreshData(data.type_id)

    for i,v in ipairs(data.base_attrs) do
        self["lbl_attr"..i]:setString(string.format("%s: %s", ex.Tools:getAttrTextOnly(v.attr), ex.Tools:getAttrValue(v.attr, v.value)))
    end

    
    for i=1, 4 do
        if data.random_attr_max >= i  then
            self["lbl_attr_rand"..i]:setString(string.format(ex.Tools:getLang(57204), i))
            ex.Tools:setLimitWidth(self["lbl_attr_rand"..i], 110)
        else
            self["lbl_attr_rand"..i]:setVisible(false)
        end
    end
    ex.Tools:setLimitWidth(self.lbl_attr1, 100)
    ex.Tools:setLimitWidth(self.lbl_attr2, 100)
    ex.Tools:setLimitWidth(self.lbl_uplevel_tip, 80)
    ex.Tools:setLimitWidth(self.lbl_refine_tip, 80)
    self.spr_refine_tip:setVisible(data.random_attr_max > 0)
    self.lbl_refine_tip:setVisible(data.random_attr_max > 0)
end

function HeroMagicWandIllustrateCell:setScrollView(scroll_view)
    self.menu:setIsTouchInsideNode(scroll_view)
end

function HeroMagicWandIllustrateCell:onEquip()
    ex.Tools:onClickItemInfo(self.data.type_id)
end

return HeroMagicWandIllustrateCell