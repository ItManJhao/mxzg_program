local DungeonShopCtr = class("DungeonShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DungeonShopLayer = class("DungeonShopLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenu = require("src.comp.menu.UIMenu")
local UIItemShop = require("src.comp.menu.UIMenuItemShop")

local ExTimer = require("src.ex.ExTimer")

function DungeonShopLayer:onCreate()
	self:addBlackBackground()
	--ex.log("ShopLayer:onCreate")
    --self:setAutoClose(false)
     -- 奖品刷新时间
    self.reset_time = GetSystemResetTime()
    self.timer = ExTimer:new():bind(self)
    ex.AudioManager:playMusic("music/shop.mp3")
end

function DungeonShopLayer:showShopItem(vec_shop_item)
	local shop_ctr = require("src.layer.DungeonShopCtr"):instance()
	local item_size = cc.size(100,100)

	local item_num = table.nums(vec_shop_item)
	local start_pos = cc.p(self.spr_reward_bg:getPositionX() - (item_size.width + 70) * item_num / 2, self.spr_reward_bg:getPositionY())

	if self.menu_item == nil then
		self.menu_item = UIMenu:create();
		self.menu_item:setPosition(cc.p(0, 0));
		self.menu_item:setName("menu_item")
		self:addChild(self.menu_item, 10);
	end
	self.menu_item:removeAllChildren()

	if self.menu_buy == nil then
		self.menu_buy = UIMenu:create();
		self.menu_buy:setPosition(cc.p(0, 0));
		self.menu_buy:setName("menu_buy")
		self:addChild(self.menu_buy, 10);
	end
	self.menu_buy:removeAllChildren()

	for i, v in ipairs(vec_shop_item) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setPosition(start_pos.x + (item_size.width + 70) * (i - 0.5), start_pos.y + 25)
		:registerScriptTapHandler(handler(self, self.onItemInfo))
		self.menu_item:addChild(item)
		
		-- 	折扣显示
		if v.discount > 0 and v.discount < 100 then
			local discount = v.discount
			local spr_discount_bg = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
			spr_discount_bg:setPosition(-5, item:getContentSize().height)
			spr_discount_bg:setScale(0.9)
			item:addChild(spr_discount_bg, 100)

			if math.floor(discount / 10) == discount / 10 then
				discount = math.floor(discount / 10)
			end

			local lbl_discount_1 = cc.Label:createWithTTF(tostring(discount), FONT_DEFAULT_NAME_BOLD, 42)
			lbl_discount_1:setScale(0.5)
			lbl_discount_1:setPosition(spr_discount_bg:getContentSize().width / 2 - 10, spr_discount_bg:getContentSize().height / 2 + 5)
			spr_discount_bg:addChild(lbl_discount_1)

			local lbl_discount_2 = cc.Label:createWithTTF(ex.Tools:getLang(47553), FONT_DEFAULT_NAME_BOLD, 40)
			lbl_discount_2:setScale(0.5)
			lbl_discount_2:setPosition(spr_discount_bg:getContentSize().width / 2 + 10, spr_discount_bg:getContentSize().height / 2 - 5)
			spr_discount_bg:addChild(lbl_discount_2)
		end

        -- 创建购买按钮
        local btn = cpp.UIMenuItemLabel:create("button/btn-old-1.png", "button/btn-old-1.png", "", nil)
		btn:setPosition(item:getPositionX(), item:getPositionY() - 85)
		btn:registerScriptTapHandler(handler(shop_ctr, shop_ctr.onItemBuy))
		btn:setLabelText("")
		btn:setLabelColor(FONT_BROWN)
		btn:setTag(v.index)
		self.menu_buy:addChild(btn)

		if v.is_buy > 0 then
			btn:setLabelText(ex.Tools:getLang(41153))
			btn:setLabelSize(36)
			btn:setLabelColor(FONT_BROWN)
			btn:setEnabled(false)

			local spr_disabled = cc.Sprite:createWithSpriteFrameName("button/btn-old-1.png")
			ex.Tools:setGray(spr_disabled)
			btn:setDisabledImage(spr_disabled)
		else
			-- 添加购买所需资源显示
			local spr_cost = cc.Sprite:createWithSpriteFrameName("backpack/"..v.cost_type..".png")
			spr_cost:setScale(0.3)
			spr_cost:setName("spr_cost")
			spr_cost:setPosition(25, btn:getContentSize().height / 2)
			btn:addChild(spr_cost)

			local lbl_cost = cc.Label:createWithTTF(tostring(v.cost_num), FONT_DEFAULT_NAME_BOLD, 36)
			lbl_cost:setColor(FONT_BROWN)
			lbl_cost:setScale(0.5)
			lbl_cost:setName("lbl_cost")
			lbl_cost:setPosition(65, btn:getContentSize().height / 2)
			btn:addChild(lbl_cost)
		end
	end
end

function DungeonShopLayer:updateShopBuyStatue(vec_shop_item)
	local vec_child = self.menu_buy:getChildren()

	for i, v in ipairs(vec_shop_item) do
		for i2,v2 in ipairs(vec_child) do
			if v2:getTag() == v.index then
				if v.is_buy > 0 then
					if v2:getChildByName("spr_cost") ~= nil then
						v2:removeChildByName("spr_cost")
					end
					if v2:getChildByName("lbl_cost") ~= nil then
						v2:removeChildByName("lbl_cost")
					end

					v2:setLabelText(ex.Tools:getLang(41153))
					v2:setLabelSize(36)
					v2:setLabelColor(FONT_BROWN)
					v2:setEnabled(false)

					local spr_disabled = cc.Sprite:createWithSpriteFrameName("button/btn-old-1.png")
					ex.Tools:setGray(spr_disabled)
					v2:setDisabledImage(spr_disabled)
				else
					if v2:getChildByName("spr_cost") ~= nil then
						v2:removeChildByName("spr_cost")
					end
					if v2:getChildByName("lbl_cost") ~= nil then
						v2:removeChildByName("lbl_cost")
					end

					v2:setLabelText("")
					
					-- 添加购买所需资源显示
					local spr_cost = cc.Sprite:createWithSpriteFrameName("backpack/"..v.cost_type..".png")
					spr_cost:setScale(0.3)
					spr_cost:setName("spr_cost")
					spr_cost:setPosition(25, v2:getContentSize().height / 2)
					v2:addChild(spr_cost)

					local lbl_cost = cc.Label:createWithTTF(tostring(v.cost_num), FONT_DEFAULT_NAME_BOLD, 36)
					lbl_cost:setColor(FONT_BROWN)
					lbl_cost:setScale(0.5)
					lbl_cost:setName("lbl_cost")
					lbl_cost:setPosition(65, v2:getContentSize().height / 2)
					v2:addChild(lbl_cost)

					v2:setEnabled(true)
				end
			end
		end
	end
end

function DungeonShopLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function DungeonShopCtr:onCreate()
	self:setCCBIPath("ccbi/DungeonShopLayer.ccbi")
	self:setIsSingle(false)
end

function DungeonShopCtr:getLayerClass()
	return DungeonShopLayer
end

function DungeonShopCtr:openWindow(vec_shop_item)
	if self:isOpened() then
		return
	end

	if vec_shop_item == nil or table.nums(vec_shop_item) <= 0 then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(vec_shop_item)
end

function DungeonShopCtr:initData(vec_shop_item)
	self.vec_shop_item = vec_shop_item
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer:showShopItem(self.vec_shop_item)
end

function DungeonShopCtr:updateLayer(vec_shop_item)
	if not self:getLayer() then
		return
	end

	self.layer:updateShopBuyStatue(vec_shop_item)
end

function DungeonShopCtr:onItemBuy(tag, pSender)
	-- print("DungeonShopCtr:onItemBuy tag =", tag)
	local now = ex.Game:getServerMillisecond()
	if self.last_buy_time ~= nil and now - self.last_buy_time > 0 and now - self.last_buy_time < 300 then
		return
	end
	self.last_buy_time = now

	local is_have = false
    for k, v in pairs(self.vec_shop_item) do
        if v.index == tag then
            if v.is_buy == true then
                return
            end
            is_have = true
            break
        end
    end

    if is_have == false then
        return
    end

    local flag = ex.Player.dungeon_data:shopBuy(tag)
    if flag == true then
        for k, v in pairs(self.vec_shop_item) do
            if v.index == tag then
                v.is_buy = true
            end
        end
        self:updateLayer(self.vec_shop_item)
    end
end

return DungeonShopCtr