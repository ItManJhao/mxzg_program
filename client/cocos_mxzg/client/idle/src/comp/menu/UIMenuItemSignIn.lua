-- local UIMenuItemSignIn = class("UIMenuItemSignIn", function (params1, params2, params3)
-- 	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
-- end)


-- function UIMenuItemSignIn:onInit(idx, item_type, item_num)
-- 	self.idx = idx or 0
-- 	self.item_type = item_type or 0
-- 	self.item_num = item_num or 0

-- 	self.spr_signin_box = nil
-- end

-- function UIMenuItemSignIn:initDone()
-- 	self:setEnableAction(false)
	
-- 	local prop_size = self:getContentSize()

-- 	local lbl_num = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 32)
-- 	:setScale(0.5)
-- 	:enableOutline(ex.c3b.BLACK, 2)
-- 	self:addChild(lbl_num, 5)

-- 	-- icon
-- 	local spr_icon = nil
-- 	if self.item_type > 20000000 and self.item_type < 30000000 then
-- 		local elem = 0
-- 		local star = 1
-- 		local config = cfg.heropieces.pieces[self.item_type]
-- 		if config then
-- 			elem = config.element
-- 			star = config.star
-- 		end

-- 		-- 碎片
-- 		local item_config = cfg.item.item[self.item_type]
-- 		spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("%s.png", item_config.icon))
-- 		if spr_icon == nil then
-- 			-- local type_w10 = self.item_type - (math.floor(self.item_type / 100000) % 10) * 100000 - 10000000
-- 			-- spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/%d.png", type_w10))
-- 			-- if spr_icon == nil then
-- 				spr_icon = cc.Sprite:createWithSpriteFrameName("hero-icon/0.png")
-- 			-- end

-- 		end

-- 		local scale = (prop_size.width -  20) / spr_icon:getContentSize().width
-- 		spr_icon:setScale(scale)

-- 		spr_icon:setPosition(prop_size.width * 0.5, prop_size.height * 0.5)

-- 		--碎片元素
-- 		local icon_size = spr_icon:getContentSize()
-- 		icon_size.width = icon_size.width * scale
-- 		icon_size.height = icon_size.height * scale

-- 		local diff = cc.p((prop_size.width - icon_size.width) / 2, (prop_size.height - icon_size.height) / 2)

-- 		-- if elem > 0 then
-- 		-- 	local elem_size = cc.Sprite:createWithSpriteFrameName("hero-icon/item-elem-bg.png"):getContentSize()
-- 		-- 	local spr_elem = cc.Sprite:createWithSpriteFrameName(string.format("hero-icon/elem-%d.png", elem))
-- 		-- 	spr_elem:setScale(elem_size.width / spr_elem:getContentSize().width)
-- 		-- 	spr_elem:setPosition(cc.p(diff.x + elem_size.width / 2 + 3, diff.y + icon_size.height - elem_size.height / 2 - 3))
-- 		-- 	self:addChild(spr_elem, 1)
-- 		-- end

-- 		-- 星级
-- 		local node_star = cc.Node:create():move(diff.x, diff.y)
-- 		self:addChild(node_star, 1)

-- 		local star_type = math.floor(star / 5)
-- 		local star_count

-- 		if star % 5 == 0 then 
-- 			if star > 5 then
-- 				star_count = 1
-- 			else 
-- 				star_count = 5
-- 				star_type = 0
-- 			end
-- 		else
-- 			star_count = star % 5
-- 		end
-- 		if star > 10 then star_count = star_count + 1 end

-- 		local diff = 9.0
-- 		local start_pos = cc.p(icon_size.width * 0.5 - (star_count - 1) * diff * 0.5, 14)

-- 		for i=1,star_count do
-- 			local spr_star = cc.Sprite:createWithSpriteFrameName(string.format("other/star-%d.png", star_type))
-- 			:setScale(0.5)
-- 			:setPosition(cc.p(start_pos.x + (i - 1) * diff, start_pos.y))
-- 			node_star:addChild(spr_star)
-- 		end

-- 		lbl_num:setAnchorPoint(ex.a.right_center)
-- 		lbl_num:setPosition(prop_size.width - 17, 22)
-- 		lbl_num:setString(tostring(self.item_num))

-- 		-- 右上角小碎片
--     	local spr_ps = cc.Sprite:createWithSpriteFrameName("hero-icon/shop-sp.png")
--     	:setScale(0.8 * scale)
--     	spr_ps:setPosition(prop_size.width - spr_ps:getContentSize().width / 2 - 10,
--     		prop_size.height - spr_ps:getContentSize().height / 2 - 10)
--     	self:addChild(spr_ps, 5)
-- 	else
-- 		-- 道具 装备 其他
-- 		spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", self.item_type))
-- 		if spr_icon == nil then
-- 			spr_icon = cc.Sprite:createWithSpriteFrameName("backpack/item-default-2.png")
-- 			:setScale(0.5)
-- 		else
-- 			spr_icon:setScale(0.75)
-- 		end

-- 		spr_icon:setPosition(prop_size.width * 0.5, prop_size.height * 0.55)

-- 		lbl_num:setPosition(prop_size.width * 0.5, 22)
-- 		lbl_num:setString(string.format("x%d", self.item_num))
-- 	end

-- 	self:addChild(spr_icon)

-- 	-- 签到提示框
-- 	self.spr_signin_box = cc.Sprite:createWithSpriteFrameName("promotion/sign-box.png")
-- 	:setPosition(prop_size.width * 0.5, prop_size.height * 0.5)
-- 	self:addChild(self.spr_signin_box, 100)
-- end

-- function UIMenuItemSignIn:createWithData(idx, item_type, item_num)
-- 	local pRet = UIMenuItemSignIn:create("promotion/sign-bg.png", nil, nil)
-- 	if pRet then
-- 		pRet:onInit(idx, item_type, item_num)
-- 		pRet:initDone()
-- 		return pRet
-- 	end
-- 	return nil
-- end

-- -- function UIMenuItemSignIn:addSignInTag()
-- -- 	local prop_size = self:getContentSize()
-- -- 	local layer_color = cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, prop_size.width - 20, prop_size.height - 20)
-- -- 	:setPosition(10, 10)
-- -- 	self:addChild(layer_color, 99)

-- -- 	local spr_tag = cc.Sprite:createWithSpriteFrameName("promotion/sign-tag.png")
-- -- 	:setPosition(prop_size.width - 20, prop_size.height -20)
-- -- 	self:addChild(spr_tag, 100)
-- -- end



-- function UIMenuItemSignIn:addSignInTag()
-- 	if not self.layer_color then 
-- 		local prop_size = self:getContentSize()
-- 		self.layer_color = cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, prop_size.width - 20, prop_size.height - 20)
-- 		:setPosition(10, 10)
-- 		self:addChild(self.layer_color, 99)
-- 	end 
-- end





-- function UIMenuItemSignIn:addSignInImage(image_str)
-- 	local prop_size = self:getContentSize()

-- 	if not self.spr_tag then 
-- 		self.spr_tag = cc.Sprite:createWithSpriteFrameName(image_str)
-- 		:setPosition(prop_size.width * 0.5, prop_size.height * 0.5)
-- 		self:addChild(self.spr_tag, 100)
-- 	end 
-- end

-- function UIMenuItemSignIn:getSignInImage(image_str)
-- 	local prop_size = self:getContentSize()

-- 	if self.spr_tag then 
-- 		self.spr_tag:setVisible(false)
-- 	end

-- 	if not self.get_spr_tag then 
-- 		self.get_spr_tag = cc.Sprite:createWithSpriteFrameName(image_str)
-- 		:setPosition(prop_size.width * 0.5, prop_size.height * 0.5)
-- 		self:addChild(self.get_spr_tag, 100)
-- 	end 
-- end



-- function UIMenuItemSignIn:setState(state)
-- 	self.state = state

-- 	self.spr_signin_box:setVisible(state == 1)

-- 	-- 已签
-- 	-- if state == 0 then
-- 	-- 	self:addSignInTag()
-- 	-- 	self:setEnabled(false)
-- 	-- end

-- 	if state == 0 then --未签


-- 	elseif state == 1 then -- 一签
-- 		self:addSignInTag()
-- 		self:addSignInImage("promotion/spr-sign-3.png")

-- 	elseif state == 2 then  -- 已经充值未二签
-- 		self:addSignInTag()

-- 		self:getSignInImage("promotion/spr-sign-2.png")
-- 		self:setEnabled(false)
-- 	elseif state == 3 then
		
-- 	end


-- end

-- function UIMenuItemSignIn:onSignIn()
-- 	-- self:setEnabled(false)
-- 	-- self.spr_signin_box:setVisible(false)

-- 	-- self:addSignInTag()
-- 	self:setState(0)
-- end

local UIMenuItemSignIn = class("UIMenuItemSignIn", require("src.comp.menu.UIMenuItemBag"))

function UIMenuItemSignIn:virtualCreate(...)
    return UIMenuItemSignIn:create(...)
end

function UIMenuItemSignIn:onInit(item_type, item_num, item_id)
	self.super.onInit(self, item_type, item_num, item_id)

	local prop_size = self:getContentSize()
	-- 签到提示框
	self.spr_signin_box = cc.Sprite:createWithSpriteFrameName("promotion/sign-box.png")
	:setPosition(prop_size.width * 0.5, prop_size.height * 0.5)
	:setScale(1.1, 1.13)
	self:addChild(self.spr_signin_box, 100)
end


function UIMenuItemSignIn:addSignInTag()
	if not self.layer_color then 
		local prop_size = self:getContentSize()
		self.layer_color = cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, (prop_size.width - 20) * 1.1, (prop_size.height - 20) * 1.13)
		:setPosition(5, 5)
		self:addChild(self.layer_color, 99)
	end 
end

function UIMenuItemSignIn:addSignInImage(image_str)
	local prop_size = self:getContentSize()

	if not self.spr_tag then 
		self.spr_tag = cc.Sprite:createWithSpriteFrameName(image_str)
		:setPosition(prop_size.width * 0.5, prop_size.height * 0.5)
		self:addChild(self.spr_tag, 100)
	end 
end

function UIMenuItemSignIn:setState(state)
	self.state = state

	self.spr_signin_box:setVisible(state == 1)

	-- 已签
	-- if state == 0 then
	-- 	self:addSignInTag()
	-- 	self:setEnabled(false)
	-- end

	if state == 0 then --未签


	elseif state == 1 then -- 一签
		self:addSignInTag()
		self:addSignInImage("promotion/spr-sign-3.png")

	elseif state == 2 then  -- 已经充值未二签
		self:addSignInTag()

		self:getSignInImage("promotion/spr-sign-2.png")
		self:setEnabled(false)
	elseif state == 3 then
		
	end
end

function UIMenuItemSignIn:getSignInImage(image_str)
	local prop_size = self:getContentSize()

	if self.spr_tag then 
		self.spr_tag:setVisible(false)
	end

	if not self.get_spr_tag then 
		self.get_spr_tag = cc.Sprite:createWithSpriteFrameName(image_str)
		:setPosition(prop_size.width * 0.5, prop_size.height * 0.5)
		self:addChild(self.get_spr_tag, 100)
	end 
end

return UIMenuItemSignIn