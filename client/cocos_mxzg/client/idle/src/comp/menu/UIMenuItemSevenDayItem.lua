local UIMenuItemSevenDayItem = class("UIMenuItemSevenDayItem", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

function UIMenuItemSevenDayItem:reset(data)
	self.data = data or {}
	-- dump(data)
	self:setIconType(self.data.item_type)
	self:setNum(self.data.item_num)
end

function UIMenuItemSevenDayItem:getData()
	return self.data 
end

function UIMenuItemSevenDayItem:init()
	local size = self:getContentSize()
	self.spr_prop_icon = cc.Sprite:createWithSpriteFrameName("backpack/item-default-2.png")
	self:addChild(self.spr_prop_icon)
	self.spr_prop_icon:setPosition(size.width / 2, size.height / 2)
	self.spr_prop_icon:setScale(0.5)

    -- 右上角小碎片

    self.spr_ps = cc.Sprite:createWithSpriteFrameName("hero-icon/shop-sp.png")
    :setScale(0.8)
    self.spr_ps:setPosition(size.width - self.spr_ps:getContentSize().width / 2  - 3,
    	size.height - self.spr_ps:getContentSize().height / 2 - 3)
    self:addChild(self.spr_ps, 5)
    self.spr_ps:setVisible(false)

    local color = cc.WHITE
    self.lbl_num = cc.Label:createWithTTF("0",FONT_DEFAULT_NAME_BOLD,18)
    self:addChild(self.lbl_num)
    self.lbl_num:setAnchorPoint(1, 0.5)
    self.lbl_num:enableOutline(FONT_BLACK, 1)
    self.lbl_num:setPosition(size.width - 10,self.lbl_num:getContentSize().height / 2 + 3)
    self.lbl_num:setColor(color)
    self.lbl_num:setLocalZOrder(1)
end

function UIMenuItemSevenDayItem:initNode()

end

function UIMenuItemSevenDayItem:createWithData(data)
	local pRet = UIMenuItemSevenDayItem:create("seven-day-gift/spr-item-bg.png", nil, nil)
	if pRet then
		pRet:init()
		pRet:reset(data)
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemSevenDayItem:setNum(num)
	self.lbl_num:setString(string.format("%s",num or 1))
end

function UIMenuItemSevenDayItem:setIconType(item_type)
	self.item_type = item_type or 0
	local str 
	local type = ex.Player.backpack_data:getPropType(self.item_type)

	local config = cfg.item.item[self.item_type]
	local icon = config and config.icon or "backpack/item-default-2"

	-- if ItemData.IT_PIECE == type then 
	-- 	str = string.format("hero-icon/%d.png", self.item_type - 10000000)
 
	-- else
	-- 	str = self.item_type == 0 and "backpack/item-default-2.png" or string.format("backpack/%d.png", self.item_type)
	-- end
	local str = icon .. ".png"
	local scale = self.item_type == 0 and 0.5 or 1
	-- self.spr_prop_icon:setSpriteFrame(str)
	ex.Tools:setSpriteFrame(self.spr_prop_icon, str)
	self.spr_prop_icon:setScale(scale)
	self.spr_ps:setVisible(ItemData.IT_PIECE == type)

end

return UIMenuItemSevenDayItem
