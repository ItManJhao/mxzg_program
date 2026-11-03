local UIMenuItemShop = class("UIMenuItemShop", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)

UIMenuItemShop.specialSetting =
{
	time_exchange = 1
}


function UIMenuItemShop:onInit(index, goods, need, limit)
	self.index = index
	self.goods = goods
	self.need = need
	self.limit = limit

	self.lbl_tips = nil
end

function UIMenuItemShop:initDone()
	self:setEnableAction(false)

	self.menu = cpp.UIMenu:create():move(0, 0)
    self:addChild(self.menu)

    -- 物品
    self.btn_goods = ex.Player.backpack_data:createWithData(self.goods.item_type, self.goods.item_num)
	self.btn_goods:setPosition(55, 56)
	:setScale(0.75)
	:registerScriptTapHandler(handler(self, self.onShowInfo))
	self.menu:addChild(self.btn_goods)

	-- 名称
	local lbl_name = cc.Label:createWithTTF(ex.Tools:getLang(cfg.item.item[self.goods.item_type].name), FONT_DEFAULT_NAME_BOLD, 16)
    :setTextColor(FONT_LIGHT_YELLOW)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(108, 90)
    self:addChild(lbl_name)

    -- 付费部分
    local spr_need_bg = cc.Sprite:createWithSpriteFrameName("win-bg/num-bg.png")
    :setScale(0.9)
    :setPosition(176, 56)
    self:addChild(spr_need_bg)

    local spr_need_icon = cc.Sprite:createWithSpriteFrameName(string.format("%s.png", cfg.item.item[self.need.item_type].icon))
    :setScale(0.38)
    :setPosition(120, 56)
    self:addChild(spr_need_icon)

    local lbl_need_num = cc.Label:createWithTTF(tostring(self.need.item_num), FONT_DEFAULT_NAME_BOLD, 40)
    :setScale(0.5)
    :setAnchorPoint(cc.p(0, 0.5))
    :setPosition(140, 56)
    self:addChild(lbl_need_num)

	-- if self.limit ~= nil and self.limit.isLimit and self.limit.isLimit == 1 then
		-- local is_limit_bg = cc.Sprite:createWithSpriteFrameName("backpack/spr-edge-1.png")

	self:setBuyLimit(false)
	
	if self.limit ~= nil and self.limit.isLimit and self.limit.isLimit == 1 then
		local is_limit_bg = cc.Sprite:createWithSpriteFrameName("promotion/spr-edge-1.png")
		:setScale(0.5)
		:setPosition(210, 86)
		self:addChild(is_limit_bg)


		local is_limit_text = cc.Label:createWithTTF(ex.Tools:getLang(41085), FONT_DEFAULT_NAME_BOLD, 40)
		:setScale(0.8)
		:setAnchorPoint(cc.p(0.5, 0.5))
		:setPosition(60, 57)
		:setRotation(45)
		:setTextColor(cc.c3b(255, 227, 183))
		is_limit_bg:addChild(is_limit_text)

	end

end


-- 针对有另外的可以做特殊处理
function UIMenuItemShop:SetForSetting( index )
	
	if specialSetting.time_exchange == index  then 
		-- 活动限时兑换商城，还有一个超值的渣渣


	end

end

function UIMenuItemShop:setBuyLimit(isAdd)
	if self.limit == nil or self.limit.count < 1 then
		return
	end

	if self.lbl_tips == nil then
		self.lbl_tips = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)
    	:setScale(0.5)
    	:setAnchorPoint(cc.p(0, 0.5))
    	:setPosition(108, 28)
    	self:addChild(self.lbl_tips)
	end
	self.lbl_tips:setColor(cc.WHITE)

	if isAdd then
		self.limit.times = self.limit.times + 1
	end

	if self.limit.times >= self.limit.count then
		self.limit.times = self.limit.count

		-- self:setEnabled(false)

		self.btn_goods:setGrayed()

		-- 已售完
		local spr_sold_out = cc.Sprite:createWithSpriteFrameName("backpack/spr-sold-out.png")
    	:setPosition(55, 56)
    	self:addChild(spr_sold_out)
	end

	self.lbl_tips:setString(string.format(ex.Tools:getLang(47737),self.limit.times, self.limit.count))
end

function UIMenuItemShop:setVipNeedTip(str_tip)
	if self.lbl_tips == nil then
		self.lbl_tips = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)
    	:setScale(0.5)
    	:setAnchorPoint(cc.p(0, 0.5))
    	:setPosition(108, 28)
    	self:addChild(self.lbl_tips)
	end
	self.lbl_tips:setString(str_tip)
	self.lbl_tips:setColor(cc.c3b(233, 91, 72))
	-- self.lbl_tips:setColor(FONT_RED)
end

function UIMenuItemShop:setGoodsTouchInsideNode(node)
	self.menu:setIsTouchInsideNode(node)
	return self
end

function UIMenuItemShop:createWithData(index, goods, need, limit)
	local pRet = UIMenuItemShop:create("win-bg/win-bg-17.png", nil, nil)
	if pRet then
		pRet:onInit(index, goods, need, limit)
		pRet:initDone()
		return pRet
	end
	pRet = nil
	return nil
end

function UIMenuItemShop:onShowInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

return UIMenuItemShop
