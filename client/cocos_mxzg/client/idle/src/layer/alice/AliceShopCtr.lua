local AliceShopCtr = class('AliceShopCtr', require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local AliceShopLayer = class('AliceShopLayer', require("src.layer.ui.UI_AliceShopLayer"))
local AliceShopCell = class("AliceShopCell", require("src.layer.ui.UI_AliceShopCell"))

local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function AliceShopCell:onCreate()
    self.super.onCreate(self)
	self:setName("AliceShopCell")

    self:setAnchorPoint(cc.p(0.5, 0.5))
    self:setIgnoreAnchorPointForPosition(false)

    -- self.spr_stage_bg:setLocalZOrder(1)
    -- self.lbl_stage:setLocalZOrder(1)
end

function AliceShopCell:resetData(data, scroll_view)
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

    self.lbl_tip:setVisible(false)
    self.lbl_limit:setString(string.format(ex.Tools:getLang(580090), data.buy_num, data.config.buy_limit))
    if data.buy_num >= data.config.buy_limit then
        ex.Tools:setAllGrayAuto(self.btn_item:getNormalImage(),true)
        self.spr_sell_out:setVisible(true)
        ex.Tools:setAllGrayAuto(self.btn_buy:getNormalImage(),true)
        self.btn_buy:setEnabled(false)
    end
   
    ex.Tools:setLimitWidth(self.lbl_tip, 150)
    self.menu_item:setIsTouchInsideNode(scroll_view)
end

-- 奖励物品按钮回调
function AliceShopCell:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function AliceShopCell:onBuy(tag, pSender)
    if self.data.callback ~= nil then
        self.data.callback(self.data)
    end
end

-----------------------------------------------------------------------------
function AliceShopLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceShopLayer")

    self:setAutoClose(false)
    self:addBlackBackground()

    self.scroll_view.createItemFunction = function(data, scale)
		local item = AliceShopCell:create()
		item:resetData(data, self.scroll_view)
		return item
	end

    self:addEvent(EVENT.SHOP_EVENT.UPDATE, handler(self, self.updateLayer))
end

function AliceShopLayer:updateLayer()
    local data = ex.Player.market_data.market_list[SHOP_TYPE.ALICE_SHOP]
    if data == nil then
        return
    end

    local item_list = {}
    for _,item in ipairs(data) do
        local item_data = clone(item)
        item_data.config = cfg.shopalice.shopalice[item_data.idx]
        item_data.callback = handler(self, self.onCellConfirm)

        table.insert(item_list, item_data)
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

    local res_need_item_type = ex.Tools:getSysCfg("alice_shop_item_type")
    ex.Tools:setSpriteFrameAsyn(self.btn_res:getNormalImage(), "backpack/"..res_need_item_type..".png", "backpack-4")
    self.btn_res.item_type = res_need_item_type
    self.lbl_res:setString(ex.Player:getItemNum(res_need_item_type))
end

function AliceShopLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 点击cell按钮的回调
function AliceShopLayer:onCellConfirm(data)
    if data.buy_num >= data.config.buy_limit then
        ex.MessageView:add(ex.Tools:getLang(5271))
        return
    end

    if data.config.need_item[1].item_num > ex.Player:getItemNum(data.config.need_item[1].item_type) then
        ex.Tools:showEnoughTip(data.config.need_item[1].item_type, true)
        return
    end

    local function callback(num)
    
        local res_buy = Shop_pb.GReqShopBuy()
        res_buy.idx = data.idx 
        res_buy.type = data.type 
        res_buy.buy_times = num or 1
        NetManager:sendMessage(ProtocolID.GReqShopBuy,res_buy)
    end
   
    local item = {}
    item.item_type = data.config.item_type[1].item_type
    item.item_num = data.config.item_type[1].item_num
    local item_price = {}
    item_price.item_type = data.config.need_item[1].item_type
    item_price.item_num = data.config.need_item[1].item_num
    local limit_num = -1
    if data.config.buy_limit > 0 then
        limit_num = data.config.buy_limit - data.buy_num
    end
    require("src.layer.ItemSelectCtr"):instance():openWindow(ex.Tools:getLang(41228), item, callback, item_price, limit_num)
end

-----------------------------------------------------------------------------
function AliceShopCtr:loadLayer()
	local tmp_layer = AliceShopLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceShopCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function AliceShopCtr:initData()
    self.layer:updateLayer()
end

return AliceShopCtr
