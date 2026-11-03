local DungeonShopListCtr = class("DungeonShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DungeonShopListLayer = class("DungeonShopListLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenu = require("src.comp.menu.UIMenu")
local UIItemShop = require("src.comp.menu.UIMenuItemShop")

local ExTimer = require("src.ex.ExTimer")

function DungeonShopListLayer:onCreate()
    self:addBlackBackground()
	--ex.log("ShopLayer:onCreate")
    -- self:setAutoClose(true)
     -- 奖品刷新时间
    self.reset_time = GetSystemResetTime()
    self.timer = ExTimer:new():bind(self)
    ex.AudioManager:playMusic("music/shop.mp3")
end

function DungeonShopListLayer:initDone()
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


function DungeonShopListLayer:updateShop(shop_list, is_init)
    local offset_y = 1
    if is_init == nil or is_init == false then
        offset_y = self.scroll_view:getContentOffset().y
    end
    self.scroll_view:getContainer():removeAllChildren()

    if shop_list == nil or table.nums(shop_list) <= 0 then
        return
    end

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

    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/promotion.plist")

    local index = 0
    for _,v in pairs(shop_list) do
        -- dump(v, "shop_item")

        -- if v.is_buy <= 0 then
            local x = index % col
            local y = math.floor(index / col)

            local goods = {}
            goods.item_type = v.item_type
            goods.item_num = v.item_num

            local need = {}
            need.item_type = v.cost_type
            need.item_num = v.cost_num

            local limit = {}
            limit.isLimit = 1
            limit.count = 1
            limit.times = v.is_buy

            -- dump(goods, "goods")
            -- dump(need, "need")

            local item = UIItemShop:createWithData(v.index, goods, need, limit)
            item:setPosition(start.x + x * self.item_size.width, start.y - y * self.item_size.height - 10)
            :setGoodsTouchInsideNode(self.scroll_view)
            :registerScriptTapHandler(handler(self, self.onBuyItem))
            menu:addChild(item)

            item.index = v.index

            if v.discount > 0 and v.discount < 100 then
                local discount = v.discount
                local spr_discount_bg = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
                spr_discount_bg:setPosition(25, item:getContentSize().height - 16)
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

    if offset_y <= 0 then
        self.scroll_view:setContentOffset(cc.p(0, offset_y))
    end
end

function DungeonShopListLayer:onBuyItem(tag, pSender)
	local goods = pSender.goods
    local need = pSender.need
    local limit = pSender.limit
    local hasNum = ex.Player:getItemNum(need.item_type)

    if limit.count <= limit.times then
        ex.MessageView:add(ex.Tools:getLang(41153))
        return
    end

	-- 背包数据不足
    if hasNum < need.item_num then
        ex.MessageView:add(string.format(ex.Tools:getLang(1108),
            ex.Tools:getLang(cfg.item.item[need.item_type].name)))
        return
    end

    --花费%d%s购买%d%s
    local content = string.format(ex.Tools:getLang(1104),
        need.item_num,
        ex.Tools:getLang(cfg.item.item[need.item_type].name),
        ex.Tools:getLang(cfg.item.item[goods.item_type].name),
        goods.item_num)

        ex.ConfirmCtr:openWindow(ex.Tools:getLang(41201), content, function()
            local index = pSender.index

            ex.Player.dungeon_data:shopBuy(index)
        end)
end

function DungeonShopListLayer:setItemNum()
    if self.shop_type == 0 then
       return
    end

	self.hasItemNum = ex.Player:getItemNum(self.shop_type)
    self.lbl_num:setString(tostring(self.hasItemNum))
end

function DungeonShopListCtr:onCreate()
	self:setCCBIPath("ccbi/DungeonShopListLayer.ccbi")
	self:setIsSingle(false)
end

function DungeonShopListCtr:getLayerClass()
	return DungeonShopListLayer
end

function DungeonShopListCtr:openWindow()
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData()
end

function DungeonShopListCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self.refresh_cost = {}

	-- 市 场
	self.layer:initDone(ex.Tools:getLang(41036), 0, ProtocolID.GReqMarketBuy, function(index)
		-- 购买回调
		ex.Player.shop_data:buyShopItem(index)
	end, time_callback)

	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

	self:updateLayer(true)
end

function DungeonShopListCtr:updateLayer(is_init)
	if not self:getLayer() then
		return
	end

	self.layer:updateShop(ex.Player.dungeon_data.shop_list, is_init)
end

return DungeonShopListCtr
