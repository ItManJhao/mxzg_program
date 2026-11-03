local ShopLayer = class("ShopLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIItemShop = require("src.comp.menu.UIMenuItemShop")

local ExTimer = require("src.ex.ExTimer")

function ShopLayer:onCreate()
	--ex.log("ShopLayer:onCreate")
    --self:setAutoClose(false)
     -- 奖品刷新时间
    self.reset_time = GetSystemResetTime()
    self.timer = ExTimer:new():bind(self)
    ex.AudioManager:playMusic("music/shop.mp3")
end

function ShopLayer:initDone(shop_name, shop_type, buy_protocol, buy_callback, time_callback)
	self.lbl_name:setString(shop_name)

	self.shop_type = shop_type
	self.buy_protocol = buy_protocol
	self.buy_callback = buy_callback
	self.time_callback = time_callback

	if self.time_callback then
		self.timer:run(handler(self, self.updateCDTime), 1.0)
    	self:updateCDTime()
    else
    	self.lbl_time:setVisible(false)
    	self.btn_refresh:setVisible(false)
	end

    if self.shop_type > 0 then
        self.spr_icon:setSpriteFrame(string.format("backpack/%d.png", self.shop_type))
        self:setItemNum()
    else
        self.res_node:setVisible(false)
    end

    -- 刷新按钮节点
    local btn_size = self.btn_refresh:getContentSize()
    self.refresh_node = cc.Node:create():move(btn_size.width / 2, btn_size.height / 2)
    self.btn_refresh:addChild(self.refresh_node)

    self.item_size = cc.Sprite:createWithSpriteFrameName("win-bg/win-bg-17.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 6, self.item_size.height + 15)

    self.viewSize = self.spr_bg:getContentSize()
    self.viewSize.height = self.viewSize.height - 14

    -- 物品scroll_view
    self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(self.spr_bg:getPositionX(), self.spr_bg:getPositionY() + 7)
    self:addChild(self.scroll_view, 20)

    self.spr_bg:setLocalZOrder(10)

end

function ShopLayer:updateCDTime()
    self.reset_time = self.reset_time - 1
    if self.reset_time <= 0 then
        self.reset_time = self.reset_time + 86400

        -- 时间到后要执行的回调
        self.time_callback()
    end
    -- 免费刷新 %d:%02d:%02d
    self.lbl_time:setString(string.format(ex.Tools:getLang(2605),
        math.floor(self.reset_time / 3600),
        math.floor(self.reset_time / 60 % 60),
        math.floor(self.reset_time % 60)))
end

function ShopLayer:updateShop(shop_list, discount_list)
	self.scroll_view:getContainer():removeAllChildren()

    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    self.scroll_view:addChild(menu)

    local shopLen = table.nums(shop_list)

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
    for _,v in pairs(shop_list) do
    	local x = index % col
        local y = math.floor(index / col)

        local item = UIItemShop:createWithData(v.index, v.goods, v.need, v.limit)
        item:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height - 5)
        :setGoodsTouchInsideNode(self.scroll_view)
        :registerScriptTapHandler(handler(self, self.onBuyItem))
        menu:addChild(item)

        if discount_list ~= nil and discount_list[v.index] ~= nil and discount_list[v.index].discount ~= nil then
            local discount = discount_list[v.index].discount
            if discount > 0 and discount < 100 then
                local spr_discount_bg = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
                spr_discount_bg:setPosition(-5, item:getContentSize().height - 16)
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
        end

        index = index + 1
    end

end

function ShopLayer:onBuyItem(tag, pSender)
    local goods = pSender.goods
    local goods_item_config = cfg.item.item[goods.item_type]
	local need = pSender.need
    local hasNum = ex.Player:getItemNum(need.item_type)
    local need_item_config = cfg.item.item[need.item_type]
	-- 背包数据不足
    if hasNum < need.item_num then
        ex.MessageView:add(string.format(ex.Tools:getLang(1108),
        need_item_config ~= nil and ex.Tools:getLang(need_item_config.name) or "-"))
        return
    end

    --花费%d%s购买%d%s
    local content = string.format(ex.Tools:getLang(1104),
        need.item_num,
        need_item_config ~= nil and ex.Tools:getLang(need_item_config.name) or "-",
        need_item_config ~= nil and ex.Tools:getLang(goods_item_config.name) or "-",
        goods.item_num)


        local buy_function = function()
            -- 设置购买限制
            pSender:setBuyLimit(true)

            if self.shop_type > 0 then
                self.hasItemNum = self.hasItemNum - need.item_num
                self.lbl_num:setString(tostring(self.hasItemNum))
            end

            -- 添加购买数据
            --ex.Player:addItem(goods.item_type, goods.item_num)

            local index = pSender.index

            if self.buy_callback then
                self.buy_callback(index)
            end
                        
            -- 发送购买协议
            -- local req_buy = cpp.ByteArray:create()
            -- req_buy:writeInt(self.buy_protocol)
            -- req_buy:writeInt(index)
            -- cpp.NetManager:instance():sendByteArray(req_buy)
        end

        -- 
        if GUIDE_STEP_CONTROL == "skip" then
            buy_function()
        else
            ex.ConfirmCtr:openWindow(ex.Tools:getLang(41201), content, buy_function)
        end
end

function ShopLayer:setRefreshNode(refresh_cost, cur_refresh, refresh_count, cur_free, free_count)
	self.refresh_node:removeAllChildren()

	local lbl_btn_txt = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 18)
    :enableOutline(FONT_DARK_BLUE, 1)
    self.refresh_node:addChild(lbl_btn_txt)

    local scale = 1.0

	if free_count == 0 or cur_free == 0 then
        lbl_btn_txt:setAnchorPoint(cc.p(0, 0.5))

        local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", refresh_cost.item_type))
        :setScale(0.4)
        self.refresh_node:addChild(spr_icon)
        
        if refresh_count > 0 then
            spr_icon:setPosition(-62, 0)

            lbl_btn_txt:setPosition(-45, 0)
            lbl_btn_txt:setString(string.format("%d %s(%d/%d)",
                refresh_cost.item_num,
                ex.Tools:getLang(2203), -- 刷新
                cur_refresh,
                refresh_count))

            --self.refresh_node:setScale(0.88)
            scale = 1.1
        else
            spr_icon:setPosition(-40, 0)

            lbl_btn_txt:setPosition(-20, 0)
            lbl_btn_txt:setString(string.format("%d %s",
                refresh_cost.item_num,
                ex.Tools:getLang(2203)))
        end
	else
		lbl_btn_txt:setPosition(0, 0)
        :setString(string.format(ex.Tools:getLang(2606),--ex.Tools:getLang(47135),
            cur_free, free_count))
	end

    self.refresh_node:setScale(1 / scale)
    self.btn_refresh:getNormalImage():setScaleX(scale)
    self.btn_refresh:getSelectedImage():setScaleX(scale)
end

function ShopLayer:setItemNum()
    if self.shop_type == 0 then
       return
    end

	self.hasItemNum = ex.Player:getItemNum(self.shop_type)
    self.lbl_num:setString(tostring(self.hasItemNum))
end

function ShopLayer:onExit()
    -- 停止计时器
    self.timer:stop()
    ex.Tools:autoPlaySceneMusic()
end

return ShopLayer
