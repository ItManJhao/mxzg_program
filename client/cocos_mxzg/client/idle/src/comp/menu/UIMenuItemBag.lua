local UIMenuItemBag = class("UIMenuItemBag", function (params1, params2, params3)
	                        return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
                        end)

function UIMenuItemBag:createWithData(item_type, item_num, item_id)
    -- 读取品质框
    local item_config, source_config = ex.Player.backpack_data:getBagConfig(item_type)
    local pRet = self.virtualCreate() -- UIMenuItemBag:create(item_config and item_config.rare_mark .. ".png" or "other/rare-0.png", nil, nil)
    if pRet then
        pRet.item_config = item_config
        pRet.source_config = source_config
        pRet:onInit(item_type, item_num, item_id)
        return pRet
    end
    pRet = nil
    return nil
end

function UIMenuItemBag:virtualCreate(...)
    return UIMenuItemBag:create(...)
end

function UIMenuItemBag:onInit(item_type, item_num, item_id)
    self:setEnableAction(false)

    self.item_type = item_type
    self.item_num = item_num
    self.item_id = item_id

	if self.item_config == nil then
		self:resetBg(nil, 1)
    elseif self.item_config.mode == ItemData.IT_EQUIP then
        self:resetBg(nil, self.source_config.rare)
		self:setStar(self.source_config.star)
	elseif self.item_config.mode == ItemData.IT_HERO_STONE then
		self:resetBg(nil, self.item_config.rare_mark)
		self:setStar(self.item_config.star)
    elseif self.item_config.mode == ItemData.IT_PIECE or self.item_config.mode == ItemData.IT_SPECIAL_ELITE or self.item_config.mode == ItemData.IT_HERO_MATERIAL then
        self:resetBg(nil, self.item_config.rare_mark)
		self:showPieceCorner(true)
	elseif self.item_config.mode == ItemData.PET then
		self:resetBg(nil, 1)
		self:showPetRare()
    else
        self:resetBg(nil, self.item_config.rare_mark)
    end

    if self.item_type ~= 0 then
        self:setIcon()
        self:setNum(self.item_num)
    end

    self:palyEffect()
end

function UIMenuItemBag:refreshData(item_type, item_num, item_id)
	local item_config, source_config = ex.Player.backpack_data:getBagConfig(item_type)
	self.item_config = item_config
	self.source_config = source_config
	self:onInit(item_type, item_num or 0, item_id)
end

function UIMenuItemBag:resetBg(is_null, rare)
	local spr_bg = nil
	if is_null then
		spr_bg = cc.Sprite:createWithSpriteFrameName("other/spr-null.png")
	else
		local rare = rare or self:getRare(self.source_config.star)
		spr_bg = cc.Sprite:createWithSpriteFrameName(string.format("backpack/rare-%d.png", rare))
	end
    self:setNormalImage(spr_bg)
end

function UIMenuItemBag:getRare(star)
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

function UIMenuItemBag:setBorder(border)
	self.border = border or false

	if self.spr_border == nil then
		local btn_size = self:getContentSize()
		self.spr_border = cc.Sprite:createWithSpriteFrameName("backpack/spr-select.png")
		:setPosition(btn_size.width / 2, btn_size.height / 2)
		self:addChild(self.spr_border, 100)
	end

	self.spr_border:setVisible(self.border)
end

function UIMenuItemBag:setRedPoint(bool)
	ex.Tools:addRedPoint(self,bool)
end

function UIMenuItemBag:setFrame(type)
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

function UIMenuItemBag:setFrameImage(file)
	-- self:setNormalImage()
	ex.Tools:setSpriteFrame(self:getNormalImage(), file)
end


function UIMenuItemBag:setAllGray(gray)
	local img = self:getNormalImage()
	ex.Tools:setGrayAuto(self.spr_prop_icon,gray)
	ex.Tools:setGrayAuto(self.spr_select,gray)
	ex.Tools:setGrayAuto(img,gray)
end

function UIMenuItemBag:palyEffect()
	if self.effect then 
		self.effect.layer:removeFromParent()
		self.effect = nil
    end
    
	if not self.item_config then return end
	if self.item_config.effect_mark == 0 then return end
	--self:resetBg(nil, self.rare_mark)

	if self.item_config.effect_mark then
		self.effect = ex.EffectCtr:playNormalEff(self.item_config.effect_mark, self:getContentSize().width * 0.5, self:getContentSize().height * 0.5, nil, self, 1000)
	end
end

function UIMenuItemBag:setRunesSelected(selected)
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


function UIMenuItemBag:setSelected(selected)
	self.selected = selected or false

	if self.spr_select == nil then
		local btn_size = self:getContentSize()
		self.spr_select = cc.Sprite:createWithSpriteFrameName("backpack/spr-selected.png")
		:setPosition(btn_size.width / 2, btn_size.height / 2)
		self:addChild(self.spr_select, 99)
	end

	self.spr_select:setVisible(self.selected)
end

function UIMenuItemBag:isSelected()
	return self.selected
end

function UIMenuItemBag:setLight(is_visible)
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

function UIMenuItemBag:setNum(num, color)
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
		self.lbl_num = cc.Label:createWithTTF(string.format("%d", self.num), FONT_DEFAULT_NAME_BOLD, 44)
		:setScale(0.5)
		:setAnchorPoint(ex.a.right_center)
		:setPosition(prop_size.width - 7, 15)
		self:addChild(self.lbl_num, 20)
	end
	
	self.lbl_num:setString(ex.StringUtil.getScientificNumber(self.num))
	self.lbl_num:setTextColor(txtColor)
	self.lbl_num:enableOutline(ex.c3b.BLACK, 2)
end

function UIMenuItemBag:setNumComp(has, need)
	if self.lbl_num == nil then
		self:setNum(1)
	end

	self.lbl_num:setString(ex.StringUtil.getScientificNumber(has) .. "/" .. ex.StringUtil.getScientificNumber(need))
	self.lbl_num:setTextColor(has < need and cc.c3b(233, 91, 72) or ex.c3b.WHITE)
	self.lbl_num:setLocalZOrder(10001)
end

function UIMenuItemBag:setNumVisible(b)
	if self.lbl_num then
		self.lbl_num:setVisible(b)
	end
end

function UIMenuItemBag:setIcon(type)
    local type = type or self.item_type
	if self.spr_prop_icon then
		self.spr_prop_icon:removeFromParent()
		self.spr_prop_icon = nil
    end
    
    -- 读取图标
    local icon = ""
    local scale = 1
    local y = 0.535
    if self.item_config.mode == ItemData.IT_HERO then
        scale = 0.9
        y = 0.5
        local star = self.item_config.star
        if self.item_id ~= nil  then
            local hero_data = ex.Player.hero_data:getHeroDataById(self.item_id)
            star = hero_data and hero_data.star or star
        end
        icon = string.format("hero-icon/%d.png", ex.Tools:getHeroIconByStar(type, self.star) + 10000000)
    elseif self.item_config.mode == ItemData.IT_PIECE or self.item_config.mode == ItemData.IT_SPECIAL_ELITE or self.item_config.mode == ItemData.IT_HERO_MATERIAL then
        scale = 0.9
        y = 0.5
        icon = self.item_config.icon
    else
        icon = self.item_config.icon
    end


    self.spr_prop_icon = cc.Sprite:createWithSpriteFrameName(icon .. ".png")
    if self.spr_prop_icon == nil then
        self.spr_prop_icon = cc.Sprite:createWithSpriteFrameName("backpack/item-default-2.png") 
    end
    
	local prop_size = self:getContentSize()
    self.spr_prop_icon:setPosition(prop_size.width * 0.5, prop_size.height * y)
    self.spr_prop_icon:setScale(scale)
	self:addChild(self.spr_prop_icon, 2)
end


function UIMenuItemBag:setStar(star)
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


function UIMenuItemBag:showPieceCorner(b)
    if self.spr_ps then
        self.spr_ps:removeFromParent()
        self.spr_ps = nil
    end

    if b then
        -- 右上角小碎片
        local icon_size = self:getContentSize()
        self.spr_ps = cc.Sprite:createWithSpriteFrameName("hero-icon/shop-sp.png")
        :setScale(0.8)
        self.spr_ps:setPosition(icon_size.width - self.spr_ps:getContentSize().width / 2 - 3,
                            icon_size.height - self.spr_ps:getContentSize().height / 2 - 3)
        self:addChild(self.spr_ps, 5)
    end
end

function UIMenuItemBag:setGet(b)
	self:setAllGray(b)

	if b and self:getChildByName("spr_geted") == nil then
		self.spr_geted = cc.Sprite:createWithSpriteFrameName("other/spr-geted.png")
		self.spr_geted:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self.spr_geted:setLocalZOrder(999)
		self.spr_geted:setName("spr_geted")
		self:addChild(self.spr_geted)
	else
		self:removeChildByName("spr_geted")
	end
end

-- 0：正常状态   1：可以领取   2：已经领取
function UIMenuItemBag:setRewardStatus1(status)
	self:setAllGray(status > 1)
	self:removeChildByName("spr_geted")
	self:removeChildByName("spr_effect")

	if status == 0 then
	elseif status == 1 then
		self.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_online_reward_1")
		self.spr_effect:setName("spr_effect")
		self.spr_effect:setPosition(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5 + 5)
		self:addChild(self.spr_effect, 200, 10)
	elseif status == 2 then
		-- self:setGet(true)
		self:setGet(true)
	end
end

function UIMenuItemBag:setLevel(level, color)
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

function UIMenuItemBag:setStrengthen(strengthen, color)
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

function UIMenuItemBag:showPetRare( )
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

return UIMenuItemBag