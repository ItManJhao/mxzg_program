local BlackMarketCtr = class("BlackMarketCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BlackMarketLayer = class("BlackMarketLayer", require("src.comp.EventLayer"))

local UIMenu = require("src.comp.menu.UIMenu")
local UIItemShop = require("src.comp.menu.UIMenuItemShop")

local ExTimer = require("src.ex.ExTimer")

function BlackMarketLayer:onCreate()
	--ex.log("ShopLayer:onCreate")
    -- self:setAutoClose(true)
     -- 奖品刷新时间
    self.reset_time = GetSystemResetTime()
    self.timer = ExTimer:new():bind(self)
    ex.AudioManager:playMusic("music/shop.mp3")
    self:addBlackBackground()

    self.btn_tab1:setChecked(true)
    self.btn_tab1:setLabelText(ex.Tools:getLang(47359))
    self.btn_tab1:setLabelColor(FONT_BLACK)

    self.btn_tab2:setVisible(false)
    self.btn_tab3:setVisible(false)
    self.btn_tab4:setVisible(false)

    self:addEvent(EVENT.SHOP_EVENT.UPDATE,handler(self,self.onChangeView))
end

function BlackMarketLayer:onChangeView(event,data)
    self:updateShop()
end

function BlackMarketLayer:initDone()
    -- 刷新按钮节点
    self.item_size = cc.Sprite:createWithSpriteFrameName("win-bg/win-bg-17.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 6, self.item_size.height + 15)

    self.viewSize = self.spr_scroll_bg:getContentSize()
    self.viewSize.height = self.viewSize.height - 10

    -- 物品scroll_view
    self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_scroll_bg:getPositionX(), self.spr_scroll_bg:getPositionY() + 5)
    self:addChild(self.scroll_view)

    self.scroll_view:setLocalZOrder(10)
end

function BlackMarketLayer:updateShop()
	self.scroll_view:getContainer():removeAllChildren()

    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.scroll_view:addChild(menu)

    self.lbl_tip:setString(ex.Tools:getLang(41075))

    local shopLen = table.nums(cfg.shopstall.shopstall)

    local margin = 0
    local col = math.floor((self.viewSize.width - margin * 2) / self.item_size.width) -- 列数
    local row = math.ceil(1.0 * shopLen / col) -- 行数
    local cont_height = self.item_size.height * row + margin * 2
    cont_height = math.max(cont_height , self.viewSize.height)
    row = math.ceil((cont_height - margin * 2) / self.item_size.height) -- 总行数

    self.scroll_view:setContentSize(cc.size(self.viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, self.viewSize.height - cont_height))

    cont_height = cont_height - (self.item_size.height * 0.5 + margin * 0.5)

    local start = cc.p(self.viewSize.width * 0.5 - (self.item_size.width * col * 0.5), cont_height)
    start.x = start.x + self.item_size.width * 0.5

    --ex.log(string.format("shopLen=%d, col=%d, row=%d", shopLen, col, row))

    local index = 0

	for i, v in ipairs(cfg.shopstall.shopstall) do
        local buy_times = 0
        for i2, v2 in ipairs(ex.Player.shop_data.black_market_shop_list) do
            if v2.index == v.idx then
                buy_times = v2.times
            end
        end
		-- if config ~= nil then
			local x = index % col
			local y = math.floor(index / col)


            local item_data = ex.Player.market_data:getMarketDataByItem(SHOP_TYPE.STALL,v.idx)
			local limit = {}
			limit.count = v.buy_limit
			limit.times = item_data.buy_num

            local item = UIItemShop:createWithData(v.idx, v.item_type[1], v.need_item[1], limit)
            item:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height - 10)
            :setGoodsTouchInsideNode(self.scroll_view)
            :registerScriptTapHandler(handler(self, self.onBuyItem))
            menu:addChild(item)

            item.index = v.idx

   --          if ex.Player.vip_level < v.noble_require then
   --              -- 添加贵族等级需求限制提示
   --              item:setVipNeedTip(ex.Tools:getLang(47483)..v.noble_require..ex.Tools:getLang(47216))
			-- end

            if v.discount > 0 and v.discount < 100 then
                local discount = v.discount
                local spr_discount_bg = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
                spr_discount_bg:setPosition(-10, item:getContentSize().height - 16)
                spr_discount_bg:setScale(0.9)
                item:addChild(spr_discount_bg)
    
                if math.floor(discount / 10) == discount / 10 then
                    discount = math.floor(discount / 10)
                end
    
                local lbl_discount_1 = cc.Label:createWithTTF(tostring(discount), FONT_DEFAULT_NAME_BOLD, 48)
                lbl_discount_1:setScale(0.5)
                lbl_discount_1:setPosition(spr_discount_bg:getContentSize().width / 2 - 10, spr_discount_bg:getContentSize().height / 2 + 5)
                spr_discount_bg:addChild(lbl_discount_1)
    
                local lbl_discount_2 = cc.Label:createWithTTF(ex.Tools:getLang(47553), FONT_DEFAULT_NAME_BOLD, 40)
                lbl_discount_2:setScale(0.5)
                lbl_discount_2:setPosition(spr_discount_bg:getContentSize().width / 2 + 10, spr_discount_bg:getContentSize().height / 2 - 5)
                spr_discount_bg:addChild(lbl_discount_2)
            end
    
            index = index + 1
		-- end
	end
end

function BlackMarketLayer:onBuyItem(tag, pSender)
	local goods = pSender.goods
	local need = pSender.need
    local hasNum = ex.Player:getItemNum(need.item_type)

    if pSender.limit.times >= pSender.limit.count then 
        ex.MessageView:add(ex.Tools:getLang(41112)) 
        return 
    end
	-- 背包数据不足
    if hasNum < need.item_num then
        ex.Tools:showEnoughTip(need.item_type, true)
        return
    end
    
    --花费%d%s购买%d%s
    local content = string.format(ex.Tools:getLang(1104),
        need.item_num,
        -- ex.Tools:getLang(need.item_type),
        -- ex.Tools:getLang(goods.item_type),
        ex.Tools:getLang(cfg.item.item[need.item_type].name),
        ex.Tools:getLang(cfg.item.item[goods.item_type].name),
        goods.item_num)

        ex.ConfirmCtr:openWindow(ex.Tools:getLang(41201), content, function()
            local index = pSender.index

			-- local flag = ex.Player.shop_data:buyBlackMarketItem(index)
            local flag = ex.Player.market_data:buyBlackMarketItem(index)
			-- if flag == true then
			-- 	self:updateShop()
			-- end
        end)
end

function BlackMarketLayer:setItemNum()
    if self.shop_type == 0 then
       return
    end

	self.hasItemNum = ex.Player:getItemNum(self.shop_type)
    self.lbl_num:setString(tostring(self.hasItemNum))
end

function BlackMarketCtr:onCreate()
	self:setCCBIPath("ccbi/BlackMarketLayer.ccbi")
	self:setIsSingle(false)
end

function BlackMarketCtr:getLayerClass()
	return BlackMarketLayer
end

function BlackMarketCtr:openWindow()
	if self:isOpened() then
		return
	end
	self:loadLayer()
    self:open()
	self:initData()
end

function BlackMarketCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
    local data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.STALL)
    if not data then 
        ex.MessageView:add(ex.Tools:getLang(47239))
        return 
    end
    
	-- 市 场
	self.layer:initDone()
	self:updateLayer()
end

function BlackMarketCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	self.layer:updateShop()
end


return BlackMarketCtr