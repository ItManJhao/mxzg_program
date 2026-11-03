local UIMenuItemSeventTarget = class("UIMenuItemSeventTarget", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

function UIMenuItemSeventTarget:reset(data)
	self.data = data or {}
	self:setIconType(self.data.icon)
	self:setDay(self.data.day)
	-- self:onInit()
	-- self:initDone()

end

function UIMenuItemSeventTarget:getData()
	return self.data 
end

function UIMenuItemSeventTarget:init()
	local size = self:getContentSize()
	self.spr_prop_icon = cc.Sprite:createWithSpriteFrameName("backpack/item-default-2.png")
	self:addChild(self.spr_prop_icon)
	self.spr_prop_icon:setPosition(size.width / 2, size.height / 2)
	-- self.spr_prop_icon:setScale(0.5)

	self.spr_selected = cc.Sprite:createWithSpriteFrameName("seven-day-target/spr-item-select.png")
	self:addChild(self.spr_selected)
	self.spr_selected:setPosition(size.width / 2 , size.height / 2)
	-- self:setSelected(false)

	self.spr_geted = cc.Sprite:createWithSpriteFrameName("seven-day-target/spr-geted.png")
	self:addChild(self.spr_geted)
	self.spr_geted:setPosition(size.width / 2 , size.height / 2)
	-- self.spr_geted:setScale(0.8)
	self:setGeted(false)

	    -- 右上角小碎片

    self.spr_ps = cc.Sprite:createWithSpriteFrameName("hero-icon/shop-sp.png")
    -- :setScale(0.8)
    self.spr_ps:setPosition(size.width - self.spr_ps:getContentSize().width + 3,
    	size.height - self.spr_ps:getContentSize().height + 10)
    self:addChild(self.spr_ps, 5)
    self.spr_ps:setVisible(false)

    self.spr_day_bg = cc.Sprite:createWithSpriteFrameName("seven-day-target/spr-day-bg.png")
    self:addChild(self.spr_day_bg)
    self.spr_day_bg:setPosition(size.width / 2, size.height + self.spr_day_bg:getContentSize().height / 2)
	self.spr_day_bg:setLocalZOrder(1)
	
    local color = cc.c3b(20,83,126)
	self.lbl_day = cc.Label:createWithTTF(ex.Tools:getLang(47592),FONT_DEFAULT_NAME_BOLD,48)
    self.lbl_day:setScale(0.5)
    self.lbl_day:setLocalZOrder(2)
    self.lbl_day:setPosition(self.spr_day_bg:getPosition())
    self.lbl_day:setColor(color)
    self:addChild(self.lbl_day)
end

function UIMenuItemSeventTarget:initNode()

end

function UIMenuItemSeventTarget:createWithData(data)
	local pRet = UIMenuItemSeventTarget:create("seven-day-target/spr-item-bg.png", nil, nil)
	if pRet then
		pRet:init()
		pRet:reset(data)
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemSeventTarget:removeIcon()
	if self.spr_hero_icon then
		self.spr_hero_icon:removeFromParent()
		self.spr_hero_icon = nil
	end
	--self:setNormalImage(normalSprite)
end

function UIMenuItemSeventTarget:setDay(day)
	self.lbl_day:setString(string.format(ex.Tools:getLang(47721),day or 1))
end

function UIMenuItemSeventTarget:setIconType(item_type)
	self.item_type = item_type or 0
	local str 
    local item_config = cfg.item.item[item_type]

    -- print("item_type = ", item_type)
    local is_piece = ex.Player.backpack_data:isPiece(item_type)
	str = item_type == 0 and "backpack/item-default-2.png" or string.format( "%s.png", item_config.icon)
	
	
	local scale = self.item_type == 0 and 0.75 or 1.1
	ex.Tools:setSpriteFrame(self.spr_prop_icon, str)

	-- self.spr_prop_icon:setSpriteFrame(str)
	self.spr_prop_icon:setScale(scale)
	self.spr_ps:setVisible(is_piece)

end

function UIMenuItemSeventTarget:setGeted(geted)
	self.geted = geted
	self.spr_geted:setVisible(geted)
end

function UIMenuItemSeventTarget:isGeted()
	return self.geted
end

function UIMenuItemSeventTarget:setSelected(selected)
	self.selected = selected
	self.spr_selected:setVisible(selected)
end

function UIMenuItemSeventTarget:isSelected()
	return self.selected
end

function UIMenuItemSeventTarget:setRedPoint(bool)
	ex.Tools:addRedPoint(self,bool)
end

function UIMenuItemSeventTarget:setGrayed(isGray)
	if isGray then 
		ex.Tools:setGray(self.spr_prop_icon)
		ex.Tools:setGray(self.spr_ps)
	else
		ex.Tools:delGray(self.spr_prop_icon)
		ex.Tools:delGray(self.spr_ps)
	end
end

return UIMenuItemSeventTarget
