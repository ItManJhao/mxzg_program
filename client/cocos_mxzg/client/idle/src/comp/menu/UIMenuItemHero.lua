local UIMenuItemHero = class("UIMenuItemHero", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

function UIMenuItemHero:reset(data)
	self.data = data or {}
	self:onInit(self.data.hero_id,self.data.hero_type, self.data.elem, self.data.level, self.data.star , self.data.count , self.data.selected, self.data.fashion_id)
	self:initDone()
end

function UIMenuItemHero:getData()
	return self.data 
end

function UIMenuItemHero:onInit(hero_id , hero_type, elem, level, star , count , selected, fashion_id)
	self.hero_id = hero_id or 0
	self.hero_id = self.hero_id
	
	self.fashion_id = fashion_id or 0
	self.hero_type = hero_type or 0
	self.elem = elem or 0
	self.level = level or 0
	self.star = star or 0
	self.star = star == "" and 0 or star
	self.shopCount = count
	self.selected = selected or false

	self.tasking = false
	self.battle =  false
	self.locked =  false

	self.occupation = 0

	self.friend_type = 0

	self.is_show_fashion = true
end

function UIMenuItemHero:initNode()
	self.spr_hero_icon = nil
	self.spr_elem = nil
	self.lbl_level = nil
	self.node_star = nil
	self.lbl_shop_count = nil
	self.spr_select = nil
end

function UIMenuItemHero:createWithData(hero_id , hero_type, elem, level, star , count , selected, fashion_id)

	local pRet = UIMenuItemHero:create(string.format("other/rare-%d.png", self:getRare(star)), nil, nil)
	if pRet then
		pRet:onInit(hero_id , hero_type, elem, level, star , count,selected, fashion_id)
		pRet:initNode()
		pRet:initDone()
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemHero:initDone()
	-- self:setEnableAction(false)

	if self.hero_type ~= 0 then
		-- icon
		self:removeIcon()
		self:setIcon(self.hero_type)

		-- 元素图标
		self:setElem(self.elem)

		-- 等级
		self:setLevel(self.level)

		-- 星级
		self:setStar(self.star)

		-- 商店物品个数
		--self:setShopCount(self.shopCount)
	else
		self:removeIcon()

		if self.lbl_level then
			self.lbl_level:setVisible(false)
		end

		if self.node_star then
			self.node_star:setVisible(false)
		end

		self:setElem(0)
	end

	self:setShopCount(self.shopCount)
	
	self:setSelected(self.selected)
end

function UIMenuItemHero:setPieceIcon()
	self:removeIcon()
	local icon_size = self:getContentSize()
	self.elem = self.elem or 0
	-- self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName("hero-icon/10005000.png")
	if self.star > 4 then
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", 20005000 + self.elem * 100000))
	elseif self.star == 4 then
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", 20004000 + self.elem * 100000))
	else 
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", 20003000 + self.elem * 100000))
	end
	
	if self.spr_hero_icon == nil then
		print("self.item_type333 = ", self.item_type, self.star)
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName("hero-icon/0.png")
	end

	self.spr_hero_icon:setPosition(icon_size.width * 0.5, icon_size.height * 0.5)
	:setScale(0.9)
    self:addChild(self.spr_hero_icon, 1)
end

function UIMenuItemHero:setIcon(hero_type, is_show_fashion, fashion_id, is_force)
	local l_is_show_fashion = is_show_fashion == nil and true or is_show_fashion	-- 缺省状态为显示
	if self.is_show_fashion == l_is_show_fashion and self.spr_hero_icon and not is_force then return end

	self.is_show_fashion = l_is_show_fashion

	self:removeIcon()

	self.hero_type = hero_type or 0

	local star = self.star or cfg.herotype.star[self.hero_type].star
	
	-- 处理皮肤
	local icon = nil
	if self.is_show_fashion then
		icon = fashion_id	-- 指定了皮肤则显示指定皮肤
		if icon == nil then	-- 没指定皮肤则显示已穿戴皮肤
			icon = ex.Player.hero_data.fashion:getWearByID(self.hero_id)
		end
	end

	local hero_data = ex.Player.hero_data:getHeroDataById(self.hero_id)
	if not hero_data and self.data then
		hero_data = self.data
	end

	if not icon and hero_data and hero_data.evolve and hero_data.evolve.type > 0 then
		local config = cfg.heroevolvelevel.getEvolutionConfig(hero_type, hero_data.evolve.level, hero_data.evolve.type)
		if config and type(config.evolve_icon_id) == "number" then
			icon = config.evolve_icon_id
		end
	end

	if icon == nil or icon == 0 then
		icon = ex.Tools:getHeroIconByStar(hero_type , star) + 10000000
	end

	local icon_size = self:getContentSize()
	self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/%d.png", icon))
	if self.spr_hero_icon == nil then
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/%d.png", 10000000))
		print(self.__cname, string.format("hero-icon/%d.png", icon)..ex.Tools:getLang(47685))
	end

	--self.spr_hero_icon:setScale(0.5)
	self.spr_hero_icon:setPosition(icon_size.width * 0.5, icon_size.height * 0.5)
	:setScale(0.9)
    self:addChild(self.spr_hero_icon, 1)
end

function UIMenuItemHero:setFashionShow(is_show)
	self:setIcon(self.hero_type, is_show)
end

function UIMenuItemHero:setFashionShowForce(fashion_id)
	self:setIcon(self.hero_type, true, fashion_id, true)
end

function UIMenuItemHero:setIconScale(scale)
	if self.spr_hero_icon and scale then
		self.spr_hero_icon:setScale(scale)
	end
end

function UIMenuItemHero:removeIcon()
	if self.spr_hero_icon then
		self.spr_hero_icon:removeFromParent()
		self.spr_hero_icon = nil
	end
	--self:setNormalImage(normalSprite)
end

function UIMenuItemHero:resetBg(is_null, rare)
	local spr_bg = nil
	if is_null then
		spr_bg = cc.Sprite:createWithSpriteFrameName("other/spr-null.png")
	else
		local rare = rare or self:getRare(self.star)
		spr_bg = cc.Sprite:createWithSpriteFrameName(string.format("other/rare-%d.png", rare))
	end
    self:setNormalImage(spr_bg)
end


function UIMenuItemHero:setElem(elem,hasZero)
	self.elem = elem or 0

	-- local elem_size = cc.Sprite:createWithSpriteFrameName("hero-icon/item-elem-bg.png"):getContentSize()

	-- local elem_path = ""
	-- if self.elem == 0 and not hasZero then
	-- 	elem_path = "hero-icon/item-elem-bg.png"
	-- else
	-- 	elem_path = string.format("hero-icon/elem-%d.png", self.elem)
	-- end
	-- -- elem_path = string.format("hero-icon/elem-%d.png", self.elem)

	-- -- ex.log("elem_path: "..elem_path)
	-- local icon_size = self:getContentSize()
	-- self.spr_elem = cc.Sprite:createWithSpriteFrameName(elem_path)
	-- self.spr_elem:setScale(elem_size.width / self.spr_elem:getContentSize().width)
	-- self.spr_elem:setPosition(cc.p(elem_size.width / 2 + 3,  icon_size.height - elem_size.height / 2 - 3))
	-- self:addChild(self.spr_elem, 2)
end

function UIMenuItemHero:removeElem()
	if self.spr_elem then
		self.spr_elem:removeFromParent()
		self.spr_elem = nil
	end
end

function UIMenuItemHero:setLevel(level,origin)
	self.level = level or 0
    if not origin then 
        if self.hero_id ~= 0 then 
            local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_id)
            if is_cube_hero == true then 
                local hero_data = ex.Player.hero_data:getHeroDataById(self.hero_id)
                self.level = hero_data.tweak_cube_lv 
            end 
        end 
    end 
	self:setSelectNum(tostring(self.level),origin)
end

function UIMenuItemHero:setSelectNum(str,origin)
	local color = cc.c3b(255,255,255)
    if not origin then 
        if self.hero_id ~= 0 then 
            local is_cube_hero = ex.Player.hero_data.magicCube:isCubeHero(self.hero_id)
            if is_cube_hero == true then 
                local hero_data = ex.Player.hero_data:getHeroDataById(self.hero_id)
                color = is_cube_hero and cc.c3b(126,255,48) or cc.c3b(255,255,255)
            end 
        end 
    end 
	if self.lbl_level == nil then
		local icon_size = self:getContentSize()
		self.lbl_level = cc.Label:createWithTTF(string.format("%s", str), FONT_DEFAULT_NAME_BOLD, 44)
		:setScale(0.5)
		:setAnchorPoint(ex.a.right_center)
		:enableOutline(ex.c3b.BLACK, 2)
		:setPosition(icon_size.width - 8, icon_size.width - 16)
		self:addChild(self.lbl_level, 100)
	else
		self.lbl_level:setVisible(true)
		self.lbl_level:setString(str)
	end
	self.lbl_level:setColor(color)
end

function UIMenuItemHero:initSelectItem(data)
	self.hero_id = data.hero_id
	-- 星级
	self:setStar(data.star)
	
	-- icon
	self:setIcon(data.type)

	-- 元素图标
	self:setElem(data.elem,true)

	-- 等级
	self:setSelectNum(data.num)

	self:setShopCount(self.shopCount)
	
	self:setSelected(self.selected)
end

function UIMenuItemHero:removeLevel()
	if self.lbl_level then
		self.lbl_level:removeFromParent()
		self.lbl_level = nil
	end
end

function UIMenuItemHero:setShopCount(count)
	self.shopCount = count
	-- self.shopCount = 999
	-- print(self.__cname,"shopCount")
	if not self.shopCount then return end


	if self.lbl_shop_count == nil then
		local icon_size = self:getContentSize()
		self.lbl_shop_count = cc.Label:createWithTTF(string.format("%d", self.shopCount), FONT_DEFAULT_NAME_BOLD, 32)
		:setScale(0.5)
		:setAnchorPoint(ex.a.right_center)
		:enableOutline(ex.c3b.BLACK, 1)
		:setPosition(icon_size.width - 10, 13)
		self:addChild(self.lbl_shop_count, 2)
	else
		self.lbl_shop_count:setString(string.format("%d", self.shopCount))
	end
end

function UIMenuItemHero:setShopCountVisible(bool)
	if self.lbl_shop_count ~= nil then 
		self.lbl_shop_count:setVisible(bool)
	end
	
end

function UIMenuItemHero:selectHero()
	self.selected = not self.selected
	self.spr_select:setVisible(self.selected)
end

function UIMenuItemHero:setShopCountVisible(bool)
	if self.lbl_shop_count ~= nil then 
		self.lbl_shop_count:setVisible(bool)
	end
	
end

function UIMenuItemHero:isGray()
	return self.selected == true or self.is_death == true
end

function UIMenuItemHero:setSelected(selected)
	self.selected = selected
	if not self.spr_select then
		if self.selected then
			local icon_size = self:getContentSize()
			self.spr_select = cc.Sprite:createWithSpriteFrameName("hero-icon/spr-selected.png")
			self:addChild(self.spr_select, 2)
			self.spr_select:setPosition(icon_size.width / 2 ,icon_size.height / 2)
		end
	else
		self.spr_select:setVisible(self.selected)
	end

	if self.spr_hero_icon then
		if self:isGray() then
			self.spr_hero_icon:setColor(FONT_GRAY)
		else
			self.spr_hero_icon:setColor(cc.WHITE)
		end
	end
	self:resetBg()
end

function UIMenuItemHero:setDeath(d)
	self.is_death = d
	if not self.spr_death then
		if self.is_death then
			local icon_size = self:getContentSize()
			self.spr_death = cc.Sprite:createWithSpriteFrameName("other/spr-death-1.png")
			self:addChild(self.spr_death, 2)
			self.spr_death:setPosition(icon_size.width / 2 ,icon_size.height / 2)
		end
	else
		self.spr_death:setVisible(self.is_death)
	end

	if self.spr_hero_icon then
		if self:isGray() then
			self.spr_hero_icon:setColor(FONT_GRAY)
		else
			self.spr_hero_icon:setColor(cc.WHITE)
		end
	end

	-- self:resetBg()
end

function UIMenuItemHero:isSelected()
	return self.selected
end

function UIMenuItemHero:setStar(star)
	self.star = star or 0

	if self.node_star then
		self.node_star:removeFromParent()
		self.node_star = nil
	end

	self.node_star = cc.Node:create()
	self:addChild(self.node_star, 100)

	if self.star < 10 then
		local star_type = math.floor(self.star / 5)
		local star_count = 1
	
		if self.star % 5 == 0 then 
			if self.star <= 5 then
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
			local spr_star = nil
			-- if self.star > 9 then
			-- 	spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-10-%d.png", self.star - 9))
			-- 	spr_star:setScale(0.75)
			-- else
				spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
				spr_star:setScale(0.5)
			-- end
			spr_star:setPosition(cc.p(start_pos.x + (i - 1) * diff, start_pos.y))
			self.node_star:addChild(spr_star)
		end
	else
		local spr_star_bg = cc.Sprite:createWithSpriteFrameName("backpack/spr-star-bg-2.png")
		:setPosition(cc.p(self:getContentSize().width / 2, 12))
		self.node_star:addChild(spr_star_bg, 5)
	

		-- 英雄觉醒 add 熊梦 图标修改 如果加到15星需要再次修改
		if self.star == ex.Player.awaken_star then
			spr_star_bg:setSpriteFrame("backpack/spr-star-bg-4.png")
		elseif self.star > 10 then
			local spr_star = cc.Sprite:createWithSpriteFrameName("backpack/lbl-star-"..(self.star - 10)..".png")
			:setPosition(spr_star_bg:getPosition())
			self.node_star:addChild(spr_star, 10)
		end
	

		-- 播放高星特效
		local spr_effect_star = ex.EffectFactory:createEffectWithNodeByName("eff_hero_star")
		spr_effect_star:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self.node_star:addChild(spr_effect_star, 100)
	end
end


function UIMenuItemHero:removeStar()
	if self.node_star then
		self.node_star:removeFromParent()
		self.node_star = nil
	end
end

function UIMenuItemHero:setCompleted(count, need_num, show_num)
	show_num = show_num == nil and true or show_num

	if need_num < 1 then
		count = 0
		need_num = 1
	end

	if not self.completed_node then 
		self.completed_node = cc.Node:create()
		self:addChild(self.completed_node, 1)

		local icon_size = self:getContentSize()

		local spr_completed_bg = cc.Sprite:createWithSpriteFrameName("hero-icon/spr-bg-1.png")
		self.completed_node:addChild(spr_completed_bg)

		local scaleX = icon_size.width / spr_completed_bg:getContentSize().width
		spr_completed_bg:setScaleX(scaleX)

		-- 进度条
	    self.progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("hero-icon/spr-bg-2.png"))
	    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
	    :setScaleX(scaleX)
	    :setMidpoint(cc.p(0, 0.5))
	    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	    self.completed_node:addChild(self.progressTimer)

	    -- 进度数字
		self.lbl_completed = cc.Label:createWithTTF("0/0", FONT_DEFAULT_NAME_BOLD, 32)
		:enableOutline(FONT_BLACK, 2)
	    :setScale(0.5)
		self.completed_node:addChild(self.lbl_completed)

		self.completed_node:setPosition(icon_size.width / 2
			, -spr_completed_bg:getContentSize().height / 2 )
	end

	if count >= need_num then
        self.progressTimer:setPercentage(100.0)
    else
        self.progressTimer:setPercentage(100.0 * count / need_num)
	end
		
	self.lbl_completed:setString(ex.StringUtil.getScientificNumber(count).."/"..ex.StringUtil.getScientificNumber(need_num))
	self.lbl_completed:setVisible(show_num)

    return self
end

function UIMenuItemHero:setRedPoint(bool)
	ex.Tools:addRedPoint(self,bool, ex.r.p95)
end

function UIMenuItemHero:setTasking()
	if self.tasking then
		return
	end

	self.tasking = true

	self:setGrayed(ex.Tools:getLang(47165))

	self:setEnabled(false)
end

function UIMenuItemHero:setBattling()
	if self.battle then
		return
	end

	self:setGray(false)

	self.battle = true

	if self.spr_locked == nil then
		self.spr_locked = cc.Sprite:createWithSpriteFrameName("hero-icon/spr-lock.png")
		self.spr_locked:setAnchorPoint(cc.p(0.5, 0.5))
		self.spr_locked:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self.spr_locked, 10)
	end

	-- self:setGrayed(ex.Tools:getLang(47759))

	-- self:setEnabled(false)
end

function UIMenuItemHero:setLocked()
	if self.locked then
		return
	end

	self:setGray(false)

	self.locked = true

	if self.spr_locked == nil then
		self.spr_locked = cc.Sprite:createWithSpriteFrameName("hero-icon/spr-lock.png")
		self.spr_locked:setAnchorPoint(cc.p(0.5, 0.5))
		self.spr_locked:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
		self:addChild(self.spr_locked, 10)
	end
end

function UIMenuItemHero:setFriendHeroStatus()
	
    local sfc = cc.SpriteFrameCache:getInstance() 
	sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")
	

	local icon_size = self:getContentSize()
	local yuanzhu_hero_icon = cc.Sprite:createWithSpriteFrameName("hero-info-lang/spr-yuanzhu.png")

	yuanzhu_hero_icon:setPosition(icon_size.width * 0.5, icon_size.height - 15 )
	:setScale(0.9)
	self:addChild(yuanzhu_hero_icon, 1)

	self.friend_type = 1
end


function UIMenuItemHero:getFriendHeroType()


	return self.friend_type 
end

function UIMenuItemHero:setGrayed(msg)
	local icon_size = self:getContentSize()
	
	self:setGray(false)
	-- self:addChild(cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, icon_size.width, icon_size.height), 99)

	if not msg then
		return
	end

	--:enableOutline(FONT_YELLOW, 2)
	local lbl_msg = cc.Label:createWithTTF(msg, FONT_DEFAULT_NAME_BOLD, 36)
	:setScale(0.5)
	:setTextColor(cc.c3b(12,253,0))
	:enableOutline(cc.c3b(13,70,217), 4)
	:setPosition(icon_size.width * 0.5, icon_size.height * 0.5)
	self:addChild(lbl_msg, 99)
end

function UIMenuItemHero:setGray(bool)
	ex.Tools:setGrayAuto(self.spr_hero_icon, not bool)
end

function UIMenuItemHero:setAllIcon()
	self:removeIcon()

	local icon_size = self:getContentSize()
	-- self.spr_hero_icon = nil
	self.elem = self.elem or 0
	print("UIMenuItemHero:setAllIcon star: ", self.star)
	if self.star > 4 then
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", 20005000 + self.elem * 100000))
	elseif self.star == 4 then
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", 20004000 + self.elem * 100000))
	else 
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", 20003000 + self.elem * 100000))
	end
	-- self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/%d.png", hero_type))
	if self.spr_hero_icon == nil then
		self.spr_hero_icon = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/%d.png", 0))
		print(self.__cname,string.format("hero-icon/%d.png", hero_type)..ex.Tools:getLang(47685))
	end

	--self.spr_hero_icon:setScale(0.5)
	self.spr_hero_icon:setPosition(icon_size.width * 0.5, icon_size.height * 0.5)
	:setScale(0.9)
    self:addChild(self.spr_hero_icon, 1)
end

function UIMenuItemHero:showOccupation()
	local config = cfg.herotype.star[self.hero_type]
	if config then
		self.occupation = config.occupation
		
		local icon_size = self:getContentSize()
		local elem_size = cc.Sprite:createWithSpriteFrameName("hero-icon/item-elem-bg.png"):getContentSize()
		-- 职业
		if self.spr_occupation == nil then
			self.spr_occupation = cc.Sprite:createWithSpriteFrameName(string.format("hero-info/spr-occup-%d.png", config.occupation))
			self.spr_occupation:setScale(elem_size.width / self.spr_occupation:getContentSize().width)
			self.spr_occupation:setPosition(elem_size.width / 2 + 9, icon_size.height - elem_size.height * 1.5 - 9)
			self:addChild(self.spr_occupation, 2, 99999)
		else
			-- self.spr_occupation:setSpriteFrame(string.format("hero-info/spr-occup-%d.png", config.occupation))
			ex.Tools:setSpriteFrame(self.spr_occupation, string.format("hero-info/spr-occup-%d.png", config.occupation))

		end
	end
end

function UIMenuItemHero:showHas(b, scale)
	if self.spr_has ~= nil then
		self.spr_has:removeFromParent()
		self.spr_has = nil
	end

	if b then
		local sfc = cc.SpriteFrameCache:getInstance() 
		sfc:addSpriteFrames("ccbi-res/hero-info-lang.plist")

		self.spr_has = cc.Sprite:createWithSpriteFrameName("hero-info-lang/spr-has-1.png")
		self.spr_has:setPosition(self:getContentSize().width * 0.85, self:getContentSize().height * 0.9)
		self.spr_has:setScale(scale)
		self:addChild(self.spr_has, 99999)
	end
end

function UIMenuItemHero:hideOccupation()
	if self.spr_occupation ~= nil then
		self.spr_occupation:removeFromParent()
		self.spr_occupation = nil
	end
end

function UIMenuItemHero:isBattle(bool)
		
	if self.spr_battle == nil then 
		local icon_size = self:getContentSize()
		-- 职业
    	self.spr_battle = cc.Sprite:createWithSpriteFrameName("other/spr-battle.png")
    	local scale = 0.7
    	self.spr_battle:setScale(scale)
    	self.spr_battle:setPosition(icon_size.width - self.spr_battle:getContentSize().width/ 2 *scale , self.spr_battle:getContentSize().height/ 2*scale)
    	self:addChild(self.spr_battle, 1000)
    end

    self.spr_battle:setVisible(bool)
end

function UIMenuItemHero:setAllGray(gray)
	local img = self:getNormalImage()
	ex.Tools:setGrayAuto(self.spr_hero_icon,gray)
	ex.Tools:setGrayAuto(self.spr_elem,gray)
	ex.Tools:setGrayAuto(self.node_star,gray)
	ex.Tools:setGrayAuto(self.spr_select,gray)
	ex.Tools:setGrayAuto(img,gray)

	local items = self.node_star:getChildren()
	for k,v in pairs(items) do
		ex.Tools:setGrayAuto(v,gray)
	end
end

function UIMenuItemHero:getStar()
	return self.star
end

function UIMenuItemHero:getLevel()
	return self.level
end

function UIMenuItemHero:getHeroId()
	return self.hero_id
end

function UIMenuItemHero:setHeroId(hero_id)
	self.hero_id = hero_id
end

function UIMenuItemHero:getRare(star)
	if not star or star == 0 or star == "" then
		return 0
	end

	if star >= 10 then
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

function UIMenuItemHero:enableForPos(b)
	if b then
		self:removeChildByName("spr_pos")
	else
    	local spr_pos = cc.Sprite:createWithSpriteFrameName("hero-select/spr-lock.png")
		spr_pos:setScale(1.35)
		spr_pos:setName("spr_pos")
    	spr_pos:setPosition(self:getContentSize().width/ 2 , self:getContentSize().height/ 2)
    	self:addChild(spr_pos, 1000)
	end
end

function UIMenuItemHero:autoLocked()
    if self.hero_id ==0 then return end 
    local hero_data = ex.Player.hero_data:getHeroDataById(self.hero_id)
    local is_battle = ex.Player.hero_data.promote:checkHeroIsBattle(self.hero_id) 
	local is_magic_cube = ex.Player.hero_data.magicCube:isCubeHero(self.hero_id)
    local is_lock = hero_data and hero_data.is_lock
    local battle_list = ex.Player:getHeroBattleList()
    for i,v in ipairs(battle_list) do
        if v == self.hero_id then 
            is_lock = true 
            break 
        end 
    end
    
    is_lock = is_lock

    if is_battle or is_magic_cube or is_lock then 
        self:setLocked()
    end 
    
end

function UIMenuItemHero:showLockedMessage()
    if self.hero_id ==0 then return end 
    local hero_data = ex.Player.hero_data:getHeroDataById(self.hero_id)
    local is_battle = ex.Player.hero_data.promote:checkHeroIsBattle(self.hero_id) 
    local is_magic_cube = ex.Player.hero_data.magicCube:isCubeHero(self.hero_id)
    local is_lock = false 
    local battle_list = ex.Player:getHeroBattleList()
    for i,v in ipairs(battle_list) do
        if v == self.hero_id then 
            is_lock = true 
            break 
        end 
    end

    if is_magic_cube then 
        ex.MessageView:add(ex.Tools:getLang(77319)) 
        return true
    end 

    if is_battle then 
        ex.Player.hero_data:getHeroBattleMsg(self.hero_id)
        return true 
    end 

    if is_lock then 
        ex.MessageView:add(ex.Tools:getLang(41271))  
        return true 
    end 
    return false
end

return UIMenuItemHero
