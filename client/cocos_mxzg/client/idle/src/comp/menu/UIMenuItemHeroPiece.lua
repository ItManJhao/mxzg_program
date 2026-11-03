local UIMenuItemHeroPiece = class("UIMenuItemHeroPiece", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

function UIMenuItemHeroPiece:onInit(item_type, selected, bg_path)
	self:setEnableAction(false)
	
	local item_config = cfg.item.item[item_type]
	self.item_type = item_type
	self.star = item_config.star
	self.need_num = item_config.use_value

	self.selected = selected or false

	if bg_path then
		local btn_size = self:getContentSize()
		local spr_bg = cc.Sprite:createWithSpriteFrameName(bg_path)
		:setPosition(btn_size.width / 2, btn_size.height / 2)
		self:addChild(spr_bg, -100)

		local size = spr_bg:getContentSize()
		if btn_size.width > size.width then
			btn_size.width = size.width
			btn_size.height = size.height
			--spr_bg:setScale()
			self:setScale(size.width / btn_size.width * 0.75)
			spr_bg:setScale(1.0 / self:getScale())
		end
	end
end

function UIMenuItemHeroPiece:initBtn()
	self.spr_hero_icon = nil
	self.node_star = nil
	self.spr_select = nil
	self.completed_node = nil
	self.progressTimer = nil
	self.lbl_completed = nil
    
    -- 初始化英雄碎片图标
    self:setPieceIcon(self.item_type)
    self:setStar(self.star)
    self:setSelected(self.selected)

    -- 右上角小碎片
    local btn_size = self:getContentSize()
    self.spr_ps = cc.Sprite:createWithSpriteFrameName("backpack/shop-sp.png")
    :setScale(0.8)
    self.spr_ps:setPosition(btn_size.width - self.spr_ps:getContentSize().width / 2 - 3,
    	btn_size.height - self.spr_ps:getContentSize().height / 2 - 3)
    self:addChild(self.spr_ps, 5)
end

function UIMenuItemHeroPiece:createWithData(item_type, selected, bg_path)
	local pRet = UIMenuItemHeroPiece:create("other/rare-0.png", nil, nil)
	if pRet then
		pRet:onInit(item_type, selected, bg_path)
		pRet:initBtn()
		return pRet
	end

	pRet = nil
	return nil
end

function UIMenuItemHeroPiece:setPieceIcon(item_type)
	self.item_type = item_type or 0

	if self.spr_hero_icon then
		self.spr_hero_icon:removeFromParent()
		self.spr_hero_icon = nil
	end

	if self.item_type == 0 then
		self:setNormalSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame("other/rare-0.png"))
		return
	end

	-- 设置碎片星级对应的颜色框
	-- local file_name = string.format("other/rare-%d.png", math.max(self.star - 1, 1))
	-- self:setNormalSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name))

	-- 设置碎片图标
	-- self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/%d.png", item_type - 10000000))
	-- if self.spr_hero_icon == nil then
	-- 	local type_w10 = item_type - (math.floor(item_type / 100000) % 10) * 100000 - 10000000
	-- 	--print("item_type = "..item_type)
	-- 	--print("type_w10  = "..type_w10)
	-- 	self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/%d.png", type_w10))
	-- 	if self.spr_hero_icon == nil then
	-- 		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName("hero-icon/0.png")
	-- 	end
	-- end
	
	local item_config = cfg.item.item[self.item_type]

	-- 设置品质框
	ex.Tools:setSpriteFrame(self:getNormalImage(), string.format("other/rare-%d.png", item_config.rare_mark))


	-- dump(item_config, "item_config")
	self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("%s.png", item_config.icon))

	if self.spr_hero_icon == nil then
		print("self.item_type = ", self.item_type)
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName("hero-icon/0.png")
	end

	local btn_size = self:getContentSize()
	self.spr_hero_icon:setPosition(btn_size.width / 2, btn_size.height / 2)
	:setScale(0.9)
    self:addChild(self.spr_hero_icon, 1)

 --    local icon_width = self.spr_hero_icon:getContentSize().width
	-- if icon_width > btn_size.width then
	-- 	self.spr_hero_icon:setScale(btn_size.width / icon_width * 0.75)
	-- end
end

function UIMenuItemHeroPiece:setStar(star)
	self.star = star or 0

	if self.node_star then
		self.node_star:removeFromParent()
		self.node_star = nil
	end

	self.node_star = cc.Node:create()
	-- :setCascadeOpacityEnabled(true)
	self:addChild(self.node_star, 1)

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
	-- if star_type >= 1 then
	-- 	star_count = star_count + 1
	-- end

	local btn_size = self:getContentSize()

	local diff = 9.0
	local start_pos = cc.p(btn_size.width * 0.5 - (star_count - 1) * diff * 0.5, 14)

	for i=1,star_count do
		local spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
		:setScale(0.5)
		:setPosition(cc.p(start_pos.x + (i - 1) * diff, start_pos.y))
		self.node_star:addChild(spr_star, 3)
	end
end

function UIMenuItemHeroPiece:setNum(num)
	local btn_size = self:getContentSize()

	if num <= 0 then
		if self.lbl_num ~= nil then
			self.lbl_num:setVisible(false)
		end
		return
	end

	if self.lbl_num == nil then
		self.lbl_num = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 56)
		:setScale(0.5)
		:setAnchorPoint(ex.a.right_center)
		:enableOutline(ex.c3b.BLACK, 2)
		:setPosition(btn_size.width - 5, 14)
		self:addChild(self.lbl_num, 4)
	end
	self.lbl_num:setVisible(true)
	self.lbl_num:setString(tostring(num))
	return self
end

function UIMenuItemHeroPiece:setCompleted(count)
	self.count = count or 0

	if self.completed_node == nil then
		self.completed_node = cc.Node:create()
		self:addChild(self.completed_node)

		local spr_completed_bg = cc.Sprite:createWithSpriteFrameName("hero-icon/spr-bg-1.png")
		self.completed_node:addChild(spr_completed_bg)

		local btn_size = self:getContentSize()

		local scaleX = btn_size.width / spr_completed_bg:getContentSize().width
		spr_completed_bg:setScaleX(scaleX)

		-- 进度条
    	self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("hero-icon/spr-bg-2.png"))
    	:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    	:setScaleX(scaleX)
    	:setMidpoint(cc.p(0, 0.5))
    	:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    	self.completed_node:addChild(self.progressTimer)

    	-- 进度数字
    	self.lbl_completed = cc.Label:createWithTTF("0/0", FONT_DEFAULT_NAME_BOLD, 16)
    	-- :setScale(0.5)
		:enableOutline(cc.c3b(0,0,0), 1)
		self.completed_node:addChild(self.lbl_completed)

		self.completed_node:setPosition(btn_size.width / 2 , -spr_completed_bg:getContentSize().height / 2 - 3)
	end

	if self.count >= self.need_num then
        self.progressTimer:setPercentage(100.0)
    else
        self.progressTimer:setPercentage(100.0 * self.count / self.need_num)
    end
    self.lbl_completed:setString(string.format("%d/%d", self.count, self.need_num))

    return self
end

function UIMenuItemHeroPiece:removeCompleted()
	if self.completed_node then
		self.completed_node:removeFromParent()
		self.completed_node = nil
		self.progressTimer = nil
		self.lbl_completed = nil
	end
end

function UIMenuItemHeroPiece:setSelected(selected)
	self.selected = selected or false

	if self.spr_select == nil then
		local btn_size = self:getContentSize()
		self.spr_select = cc.Sprite:createWithSpriteFrameName("backpack/spr-selected.png")
		:setPosition(btn_size.width / 2, btn_size.height / 2)
		self:addChild(self.spr_select, 5)
	end

	self.spr_select:setVisible(self.selected)

	if self.spr_hero_icon then
		if self.selected then
			self.spr_hero_icon:setColor(FONT_GRAY)
		else
			self.spr_hero_icon:setColor(cc.WHITE)
		end
	end
end

function UIMenuItemHeroPiece:isSelected()
	return self.selected
end

function UIMenuItemHeroPiece:setRedPoint(bool)
	ex.Tools:addRedPoint(self,bool, ex.r.p95)
end

function UIMenuItemHeroPiece:setGrayed(is_gray)
	if is_gray == nil then is_gray = true end

	if is_gray then
		local btn_size = self:getContentSize()

		local layerColor = self:getChildByTag(98)
		if layerColor then
			layerColor:removeFromParent()
			layerColor = nil
		end
		layerColor = cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, btn_size.width, btn_size.height)
		self:addChild(layerColor, 98, 98)
	else
		local layerColor = self:getChildByTag(98)
		if layerColor then
			layerColor:removeFromParent()
			layerColor = nil
		end
	end
end

function UIMenuItemHeroPiece:setAllGray(gray)
	local img = self:getNormalImage()
	ex.Tools:setGrayAuto(self.spr_hero_icon,gray)
	ex.Tools:setGrayAuto(self.node_star,gray)
	ex.Tools:setGrayAuto(self.spr_select,gray)
	ex.Tools:setGrayAuto(img,gray)
	ex.Tools:setGrayAuto(self.spr_ps,gray)
	

	local items = self.node_star:getChildren()
	for k,v in pairs(items) do
		ex.Tools:setGrayAuto(v,gray)
	end
end


return UIMenuItemHeroPiece