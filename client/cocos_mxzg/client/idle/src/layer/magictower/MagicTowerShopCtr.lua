local MagicTowerShopCtr = class('MagicTowerShopCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MagicTowerShopLayer = class('MagicTowerShopLayer', require("src.layer.ui.UI_MagicTowerShopLayer"))
local MagicTowerShopCell = class("MagicTowerShopCell", require("src.layer.ui.UI_MagicTowerShopCell"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function MagicTowerShopCell:onCreate()
    self.super.onCreate(self)
	self:setName("MagicTowerShopCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)

    -- self.spr_stage_bg:setLocalZOrder(1)
    -- self.lbl_stage:setLocalZOrder(1)
end

function MagicTowerShopCell:resetData(data, scroll_view)
    self.data = data

    local item_data = data.config.item_type[1]
    local item_need = data.config.need_item[1]
    self.lbl_name:setString(ex.Tools:getLang(cfg.item.item[item_data.item_type].name))
    self.btn_item:refreshData(item_data.item_type, item_data.item_num, 0)

    self.spr_res = cc.Sprite:createWithSpriteFrameName("backpack/"..item_need.item_type..".png")
    self.spr_res:setScale(0.4)
    self.spr_res:setPosition(33, 30)
    self.btn_buy:addChild(self.spr_res)
    self.btn_buy:setLabelOffset(cc.p(15, -2))
    self.btn_buy:setLabelText(ex.StringUtil.getScientificNumber(item_need.item_num))

    if data.cur_star_num < data.config.star then
        self.lbl_limit:setVisible(false)
        self.lbl_tip:setString(string.format(ex.Tools:getLang(57542), data.config.star))
    else
        self.lbl_tip:setVisible(false)
        self.lbl_limit:setString(string.format(ex.Tools:getLang(57518), data.buy_num, data.config.buy_limit))
    end
    ex.Tools:setLimitWidth(self.lbl_tip, 150)
    self.menu_item:setIsTouchInsideNode(scroll_view)
end

-- 奖励物品按钮回调
function MagicTowerShopCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function MagicTowerShopCell:onBuy(tag, pSender)
    if self.data.callback ~= nil then
        self.data.callback(self.data)
    end
end

-----------------------------------------------------------------------------
function MagicTowerShopLayer:onCreate()
	self.super.onCreate(self)
	self:setName("MagicTowerShopLayer")

    self:setAutoClose(false)
    self:addBlackBackground()

    local win_size = cc.Director:getInstance():getWinSize()

    self.spr_bg = cc.Sprite:create("ccbi-res/map-bg-magic-tower-shop.jpg")
    local scale_x = win_size.width / self.spr_bg:getContentSize().width / self:getScaleX()
    local scale_y = win_size.height / self.spr_bg:getContentSize().height / self:getScaleY()
    self.spr_bg:setScale(scale_x > scale_y and scale_x or scale_y)
    self.spr_bg:setPosition(cc.p(self:getContentSize().width * 0.5, self:getContentSize().height * 0.5))
    self:addChild(self.spr_bg, -2)

    self.scroll_view.createItemFunction = function(data, scale)
		local item = MagicTowerShopCell:create()
		item:resetData(data, self.scroll_view)
		return item
	end

    self.layer_type = -1

    self:addEvent(EVENT.SHOP_EVENT.UPDATE, handler(self, self.updateLayer))
end

function MagicTowerShopLayer:onTab(tag, pSender)
    if (self.layer_type == tag) then return end

    self.layer_type = tag

    self:updateLayer()
end

function MagicTowerShopLayer:updateLayer()
    self.btn_tab_1:setChecked(self.layer_type == 1)
    self.btn_tab_2:setChecked(self.layer_type == 2)

    local star_num = ex.Player.magic_tower_data:getStarTotalNum()
    local item_list = {}
    if self.layer_type == 1 then
        local data = ex.Player.market_data.market_list[SHOP_TYPE.MAGIC_TOWER_DAILY_SHOP]
        if data == nil then
            return
        end

        for _,item in ipairs(data) do
            local item_data = clone(item)
            item_data.cur_star_num = star_num
            item_data.config = cfg.magictowerdailyshop.magictowerdailyshop[item_data.idx]
            item_data.callback = handler(self, self.onCellConfirm)

            table.insert(item_list, item_data)
        end
    else
        local data = ex.Player.market_data.market_list[SHOP_TYPE.MAGIC_TOWER_LIFE_SHOP]
        if data == nil then
            return
        end

        for _,item in ipairs(data) do
            local item_data = clone(item)
            item_data.cur_star_num = star_num
            item_data.config = cfg.magictowerlifeshop.magictowerlifeshop[item_data.idx]
            item_data.callback = handler(self, self.onCellConfirm)

            table.insert(item_list, item_data)
        end
    end

    table.sort(item_list, function(a, b)
        local can_buy_a = a.buy_num < a.config.buy_limit
        local can_buy_b = b.buy_num < b.config.buy_limit
        if can_buy_a ~= can_buy_b then
            return can_buy_a
        end

        return a.idx < b.idx
    end)
    
    self.scroll_view:reloadData(item_list)
end

-- 点击cell按钮的回调
function MagicTowerShopLayer:onCellConfirm(data)
    if data.cur_star_num < data.config.star then
        return
    elseif data.buy_num >= data.config.buy_limit then
        ex.MessageView:add(ex.Tools:getLang(5271))
        return
    end

    local res_buy = Shop_pb.GReqShopBuy()
    res_buy.idx = data.idx 
    res_buy.type = data.type 
    res_buy.buy_times = 1
    NetManager:sendMessage(ProtocolID.GReqShopBuy,res_buy)
end

-----------------------------------------------------------------------------
function MagicTowerShopCtr:loadLayer()
	local tmp_layer = MagicTowerShopLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function MagicTowerShopCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function MagicTowerShopCtr:initData()
    self.layer:onTab(1)
end

return MagicTowerShopCtr
