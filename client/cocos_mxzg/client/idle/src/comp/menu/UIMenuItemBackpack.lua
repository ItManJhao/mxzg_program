local UIMenuItemBackpack = class("UIMenuItemBackpack", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

function UIMenuItemBackpack:onInit(item_type, num)
	self.item_type = item_type or 0
	self.num = num or 0

	self.config = cfg.item.item[item_type]
	self.selected = false
	-- print("item_type", item_type)

	if self.config then
		self.tag = self.config.mode
	end



	-- self.spr_prop_icon = nil
	self.lbl_num = nil
	self.spr_select = nil
end

function UIMenuItemBackpack:createWithData(item_type, num, btn_path)
	if not btn_path then
		btn_path = "backpack/rare-0.png"
	end

	local pRet = UIMenuItemBackpack:create(btn_path, nil, nil)
	if pRet then
		pRet:onInit(item_type, num)
		pRet:initDone()
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemBackpack:initDone()
	self:setEnableAction(false)

	if self.tag == ItemData.IT_EQUIP then 
		local config = cfg.equipmenttype.equip[self.item_type]
		self:resetBg(nil, self.config.rare_mark)
		self:setStar(config.star)
	elseif self.tag == ItemData.IT_HERO_STONE then
		self:setStar(self.config.star)
		self:resetBg(nil, self.config.rare_mark)
	elseif self.tag == ItemData.IT_GODEQUIP_ITEM then
		self:setStarWithBg(self.config.use_value)
		self:resetBg(nil, self.config.rare_mark)
	elseif self.tag == ItemData.IT_HERO_GODEQUIP then
		local config_equip = cfg.godequipment.getConfigByType(self.item_type)
		self:setGodEquipRare(config_equip.rare)
		self:setStarWithBg(config_equip.star)
		self:resetBg(nil, self.config.rare_mark)
	elseif self.tag == ItemData.IT_HALLOWS then
		local config_relic = cfg.dragonrelic.dragonrelic[self.item_type]
		self:resetBg(nil, self.config.rare_mark)
		self:setStar(config_relic.star)
	elseif self.tag == ItemData.PET then
		self:resetBg(nil, 1)
		self:showPetRare()
	elseif self.tag == ItemData.RECHAR_CARD then
		self:resetBg(nil, 1)
		self:showCardId(self.config.use_value)
	elseif self.config then
		self:resetBg(nil, self.config.rare_mark)
	end

	-- 添加蒙层边框
	local spr_frame = cc.Sprite:createWithSpriteFrameName("backpack/spr-frame.png")
	spr_frame:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
	self:addChild(spr_frame, 5)

	if self.item_type ~= 0 then
		-- icon
		-- self:setIconType(self.item_type)
		self:setIcon()
		-- 数字
		self:setNum(self.num)
	end
	self:palyEffect()
end


function UIMenuItemBackpack:removeItemData()

	if self.spr_prop_icon then
		self.spr_prop_icon:removeFromParent()
		self.spr_prop_icon = nil
		if self.lbl_num then 
			self.lbl_num:setString("")
		end 
		self:resetBg(nil, 0)
	
		self:onInit(0, 0)
		
	end

	if self.spr_godequip_rare then 
		self.spr_godequip_rare:setVisible(false)

	end 


	if self.node_star then
		self.node_star:removeFromParent()
		self.node_star = nil
	end


end 


function UIMenuItemBackpack:setIcon(type)
	local config = nil
	if type ~= nil then
		config = cfg.item.item[type]
	else
		config = self.config
	end

	local icon = config and config.icon or "backpack/spr-default"

	if self.spr_prop_icon then
		self.spr_prop_icon:removeFromParent()
		self.spr_prop_icon = nil
	end

	self.spr_prop_icon = cc.Sprite:createWithSpriteFrameName(icon .. ".png")
	if self.spr_prop_icon == nil then
		self.spr_prop_icon = cc.Sprite:createWithSpriteFrameName("backpack/item-default-2.png")
		self.spr_prop_icon:setScale(0.5)
	end

	local prop_size = self:getContentSize()
	self.spr_prop_icon:setPosition(prop_size.width * 0.5, prop_size.height * 0.535)

	-- local icon_width = self.spr_prop_icon:getContentSize().width
	-- if icon_width > prop_size.width then
	-- 	self.spr_prop_icon:setScale(prop_size.width / icon_width * 0.75)
	-- end

	self:addChild(self.spr_prop_icon, 10)
end

-- 旧版。 disused 2019-10-15
function UIMenuItemBackpack:setIconType(item_type)
	self.item_type = item_type or 0

	if self.spr_prop_icon then
		self.spr_prop_icon:removeFromParent()
		self.spr_prop_icon = nil
	end

	self.spr_prop_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", self.item_type))
	if self.spr_prop_icon == nil then
		self.spr_prop_icon = cc.Sprite:createWithSpriteFrameName("backpack/item-default-2.png")
		self.spr_prop_icon:setScale(0.5)
	end

	local prop_size = self:getContentSize()
	self.spr_prop_icon:setPosition(prop_size.width * 0.5, prop_size.height * 0.535)

	local icon_width = self.spr_prop_icon:getContentSize().width
	if icon_width > prop_size.width then
		self.spr_prop_icon:setScale(prop_size.width / icon_width * 0.75)
	end

	self:addChild(self.spr_prop_icon, 10)
end

function UIMenuItemBackpack:setDoubleIcon(v, type)
	if v then
		if self.icon_double == nil then
			self.icon_double = cc.Sprite:createWithSpriteFrameName("backpack/spr-double-"..type..".png")
			self.icon_double.type = type
			self.icon_double:setAnchorPoint(0, 1)
			self.icon_double:setPosition(-35, self:getContentSize().height + 25)
			self:addChild(self.icon_double, 100)
		elseif self.icon_double.type ~= type then
			self.icon_double:setSpriteFrame("backpack/spr-double-"..type..".png")
			self.icon_double.type = type
		end
	else
		if self.icon_double ~= nil then
			self.icon_double:removeFromParent()
			self.icon_double = nil
		end
	end
end

function UIMenuItemBackpack:setNum(num, color)
	self.num = num or 0

	if self.num == 0 or (self.item_type > 10000000 and self.item_type < 20000000) then
		return
	end

	local txtColor
	if color then
		txtColor = color
	else
		txtColor = ex.c3b.WHITE
	end

	local prop_size = self:getContentSize()

	if self.lbl_num == nil then
		self.lbl_num = cc.Label:createWithTTF(string.format("%s", self.num), FONT_DEFAULT_NAME_BOLD, 44)
		:setScale(0.5)
		:setAnchorPoint(ex.a.right_center)
		:setPosition(prop_size.width - 7, 15)
		self:addChild(self.lbl_num, 120)
	end
	
	self.lbl_num:setString(ex.StringUtil.getScientificNumber(self.num))
	self.lbl_num:setTextColor(txtColor)
	self.lbl_num:enableOutline(ex.c3b.BLACK, 2)
end

function UIMenuItemBackpack:setNumByStr(num)
	if self.lbl_str == nil then
		local prop_size = self:getContentSize()
		self.lbl_str = cc.Label:createWithTTF(string.format("%s", num), FONT_DEFAULT_NAME_BOLD, 56)
		:setScale(0.5)
		:setAnchorPoint(ex.a.right_center)
		:setPosition(prop_size.width - 10, prop_size.width - 15)
		self:addChild(self.lbl_str, 20)
	end
	self.lbl_str:setString(string.format("%s", num))
end

function UIMenuItemBackpack:setLblStrNumColor(color)
	if self.lbl_str ~= nil then 
		self.lbl_str:setColor(color)
	end
end

function UIMenuItemBackpack:getType()
	return self.item_type
end

function UIMenuItemBackpack:getNum()
	return self.num
end

function UIMenuItemBackpack:setLight(is_visible)
	if self.spr_light == nil and is_visible then
		local prop_size = self:getContentSize()
		self.spr_light = cc.Sprite:createWithSpriteFrameName("backpack/item-light-1.png")
		self.spr_light:setPosition(prop_size.width * 0.5, prop_size.height * 0.5)
		self:add(self.spr_light, -1)
	end

	if self.spr_light  then
		self.spr_light:setVisible(is_visible)
	end
end

function UIMenuItemBackpack:setGrayed()
	local btn_size = self:getContentSize()

	local layerColor = self:getChildByTag(98)
	if layerColor then
		layerColor:removeFromParent()
		layerColor = nil
	end
	layerColor = cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, btn_size.width, btn_size.height)
	self:addChild(layerColor, 98, 98)
end


function UIMenuItemBackpack:isSelected()
	return self.selected
end


function UIMenuItemBackpack:setSelected(selected)
	self.selected = selected or false

	if self.spr_select == nil then
		local btn_size = self:getContentSize()
		self.spr_select = cc.Sprite:createWithSpriteFrameName("backpack/spr-selected.png")
		:setPosition(btn_size.width / 2, btn_size.height / 2)
		self:addChild(self.spr_select, 99)
	end

	self.spr_select:setVisible(self.selected)

	if self.spr_prop_icon then
		if self.selected then
			self.spr_prop_icon:setColor(FONT_GRAY)
		else
			self.spr_prop_icon:setColor(cc.WHITE)
		end
	end
end

function UIMenuItemBackpack:setRunesSelected(selected, cb)
	self.selected = selected or false
	
	if self.spr_select == nil then
		local btn_size = self:getContentSize()

		self.spr_select_bg = cc.Sprite:createWithSpriteFrameName("win-bg/win-bg-18.png")
		:setPosition(btn_size.width * 0.88, btn_size.height * 0.88)
		self:addChild(self.spr_select_bg, 99)

		self.spr_select = cc.Sprite:createWithSpriteFrameName("backpack/spr-selected.png")
		:setPosition(btn_size.width * 0.88, btn_size.height * 0.88)
		self:addChild(self.spr_select, 99)
	end

	self.spr_select:setVisible(self.selected)
end


function UIMenuItemBackpack:setStar(star)
	self.star = star or 0

	if self.node_star then
		self.node_star:removeFromParent()
		self.node_star = nil
	end

	self.node_star = cc.Node:create()
	-- :setCascadeOpacityEnabled(true)
	self:addChild(self.node_star, 2)

	local star_type = math.floor(self.star / 5)
	local star_count

	if self.star % 5 == 0 then 
		if self.star > 5 then
			star_count = 1
		else 
			star_count = 5
			star_type = 0
		end
	else
		star_count = self.star % 5
	end
	if self.star > 10 then star_count = star_count + 1 end

	local diff = 9.0
	local icon_size = self:getContentSize()
	local start_pos = cc.p(icon_size.width * 0.5 - (star_count - 1) * diff * 0.5, 15)

	for i=1,star_count do
		local spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
		:setScale(0.5)
		:setPosition(cc.p(start_pos.x + (i - 1) * diff, start_pos.y))
		self.node_star:addChild(spr_star)
	end
	self.node_star:setLocalZOrder(100)
end

function UIMenuItemBackpack:setStarWithBg(star)
	self.star = star or 0

	if self.node_star then
		self.node_star:removeFromParent()
		self.node_star = nil
	end

	if self.star == 0 then return end

	self.node_star = cc.Node:create()
	-- :setCascadeOpacityEnabled(true)
	self:addChild(self.node_star, 2)

	local spr_star_bg = cc.Sprite:createWithSpriteFrameName("backpack/spr-star-bg.png")
	:setPosition(cc.p(self:getContentSize().width / 2, 12))
	self.node_star:addChild(spr_star_bg, 5)

	local spr_star = cc.Sprite:createWithSpriteFrameName("backpack/lbl-star-"..self.star..".png")
	:setPosition(cc.p(self:getContentSize().width / 2, 12))
	self.node_star:addChild(spr_star, 10)

	self.node_star:setLocalZOrder(100)
end

function UIMenuItemBackpack:setGodEquipRare(rare)

	if self.spr_godequip_rare then
		self.spr_godequip_rare:removeFromParent()
		self.spr_godequip_rare = nil
		
	end

	self.spr_godequip_rare = cc.Sprite:createWithSpriteFrameName("backpack/spr-rare-"..rare..".png")
	:setAnchorPoint(cc.p(0, 1))
	:setPosition(5, self:getContentSize().height - 5)
	self:addChild(self.spr_godequip_rare, 20)
end

function UIMenuItemBackpack:resetBg(is_null, rare)
	local spr_bg = nil
	if is_null then
		spr_bg = cc.Sprite:createWithSpriteFrameName("other/spr-null.png")
	else
		local rare = rare or self:getRare(self.star)
		spr_bg = cc.Sprite:createWithSpriteFrameName(string.format("backpack/rare-%d.png", rare))
	end
    self:setNormalImage(spr_bg)
end

function UIMenuItemBackpack:getRare(star)
	if not star or star == 0 then
		return 0
	end

	if star > 10 then
		return 5
	elseif star > 4 then
		return 4
	elseif star == 4 then
		return 3
	elseif star == 3 then
		return 2
	else
		return 1
	end
end

function UIMenuItemBackpack:setBorder(border)
	self.border = border or false

	if self.spr_border == nil then
		local btn_size = self:getContentSize()
		self.spr_border = cc.Sprite:createWithSpriteFrameName("backpack/spr-select.png")
		:setPosition(btn_size.width / 2, btn_size.height / 2)
		-- self.spr_border:setScaleX(btn_size.width / self.spr_border:getContentSize().width)
		-- self.spr_border:setScaleY(btn_size.height / self.spr_border:getContentSize().height)
		self:addChild(self.spr_border, 90)
	end

	self.spr_border:setVisible(self.border)
end

function UIMenuItemBackpack:setData(data)
	self.data = data
end

function UIMenuItemBackpack:getData()
	return self.data 
end

function UIMenuItemBackpack:setRedPoint(bool)
	ex.Tools:addRedPoint(self,bool)
end

function UIMenuItemBackpack:setFrame(type)
	if self.spr_frame then
		self.spr_frame:removeFromParent()
		self.spr_frame = nil
	end
	
	local prop_size = self:getContentSize()
	self.spr_frame = cc.Sprite:createWithSpriteFrameName(string.format("backpack/spr-frame-%d.png", type))
	self.spr_frame:setPosition(prop_size.width * 0.5, prop_size.height * 0.5)
	self.spr_frame:setScale(prop_size.width / self.spr_frame:getContentSize().width)
	self:add(self.spr_frame, 1)
end

function UIMenuItemBackpack:setAllGray(gray)
	local img = self:getNormalImage()
	ex.Tools:setGrayAuto(self.spr_prop_icon,gray)
	ex.Tools:setGrayAuto(self.spr_select,gray)
	ex.Tools:setGrayAuto(img,gray)
end

function UIMenuItemBackpack:palyEffect()
	if self.effect then 
		self.effect:removeFromParent()
		self.effect = nil
	end
	if not self.config then return end
	if self.config.effect_mark == 0 then return end
	--self:resetBg(nil, self.rare_mark)

	if self.config.effect_mark then
		self.effect = ex.EffectCtr:playNormalEff(self.config.effect_mark, self:getContentSize().width * 0.5, self:getContentSize().height * 0.5, nil, self, 1000)
	end
end

function UIMenuItemBackpack:setLevel(level, color)
	self.level = level or 0

	if self.level == 0 or (self.item_type > 10000000 and self.item_type < 20000000) then
		return
	end

	local txtColor
	if color then
		txtColor = color
	else
		txtColor = ex.c3b.WHITE
	end

	local prop_size = self:getContentSize()

	if self.lbl_level == nil then
		self.lbl_level = cc.Label:createWithTTF(string.format("%d", self.level), FONT_DEFAULT_NAME_BOLD, 44)
		:setScale(0.5)
		:setAnchorPoint(ex.a.right_center)
		:setPosition(prop_size.width - 7, 15)
		self:addChild(self.lbl_level, 120)
	end
	
	self.lbl_level:setString("lv." .. ex.StringUtil.getScientificNumber(self.level))
	self.lbl_level:setTextColor(txtColor)
	self.lbl_level:enableOutline(ex.c3b.BLACK, 2)
	self.lbl_level:setLocalZOrder(10001)
	if self.lbl_num then self.lbl_num:setVisible(false) end
end

function UIMenuItemBackpack:setStrengthen(strengthen, color)
	self.strengthen = strengthen or 0

	if self.strengthen == 0 or (self.item_type > 10000000 and self.item_type < 20000000) then
		return
	end

	local txtColor
	if color then
		txtColor = color
	else
		txtColor = ex.c3b.WHITE
	end

	local prop_size = self:getContentSize()

	if self.lbl_strengthen == nil then
		self.lbl_strengthen = cc.Label:createWithTTF(string.format("%d", self.strengthen), FONT_DEFAULT_NAME_BOLD, 44)
		:setScale(0.5)
		:setAnchorPoint(ex.a.right_center)
		:setPosition(prop_size.width - 7, prop_size.height - 15)
		self:addChild(self.lbl_strengthen, 120)
	end
	
	self.lbl_strengthen:setString(self.strengthen > 0 and "+"..self.strengthen or "")
	self.lbl_strengthen:setTextColor(txtColor)
	self.lbl_strengthen:enableOutline(ex.c3b.BLACK, 2)
	self.lbl_strengthen:setLocalZOrder(10001)
end

function UIMenuItemBackpack:showPetRare( )
	local pet_cfg = cfg.pet.pet[self.item_type]
	if not pet_cfg then return end
	local path = string.format("other/pet-rare-%d.png",pet_cfg.rare)
	if not self.pet_rare then 
		self.pet_rare = cc.Sprite:createWithSpriteFrameName(path)
		self.pet_rare:setLocalZOrder(10000)
		self:addChild(self.pet_rare)
	else
		-- self.pet_rare:setSpriteFrame(path)
		ex.Tools:setSpriteFrame(self.pet_rare, path)
	end
	self.pet_rare:setPosition(self:getContentSize().width/ 2,self:getContentSize().height/ 2 + 2)
end

function UIMenuItemBackpack:showCardId(idx)
	local prop_size = self:getContentSize()

	if self.lbl_card_id == nil then
		self.lbl_card_id = cc.Label:createWithTTF(string.format("%d", idx), FONT_DEFAULT_NAME_BOLD, 44)
		:setScale(0.5)
		:setAnchorPoint(ex.a.left_center)
		:setPosition(7, prop_size.height - 17)
		self:addChild(self.lbl_card_id, 120)
	end
	
	self.lbl_card_id:setString(idx)
	self.lbl_card_id:enableOutline(ex.c3b.BLACK, 2)
	self.lbl_card_id:setLocalZOrder(10001)
end

return UIMenuItemBackpack
