local ItemSelectCtr = class("ItemSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ItemSelectLayer = class("ItemSelectLayer", require("src.comp.EventLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIMenuItemHeroPiece = require("src.comp.menu.UIMenuItemHeroPiece")

function ItemSelectLayer:onCreate()
    self:addBlackBackground()

    self.lbl_select_num_tip:setString(ex.Tools:getLang(41230))
    self.lbl_total_num_tip:setString(ex.Tools:getLang(41231))

    self.btn_confirm:setLabelText(ex.Tools:getLang(2401))
    self.btn_cancel:setLabelText(ex.Tools:getLang(2402))

    self.item_type = 0
    self.select_num = 1
    self.total_num = 0
    self.item_price = nil

    self.node_price:setVisible(false)

    self.lbl_select_num_tip:setString(ex.Tools:getLang(41230))
    self.lbl_select_num:setPositionX(self.lbl_select_num_tip:getPositionX() + self.lbl_select_num_tip:getContentSize().width * self.lbl_select_num_tip:getScaleX() + 5)
    
    self.lbl_total_num_tip:setString(ex.Tools:getLang(5013))
    self.lbl_total_num:setPositionX(self.lbl_total_num_tip:getPositionX() + self.lbl_total_num_tip:getContentSize().width * self.lbl_total_num_tip:getScaleX() + 5)
    
	self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("item-select/progress.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.prog_bg:addChild(self.progress)
    self.progress:setPosition(self.prog_bg:getContentSize().width / 2 ,self.prog_bg:getContentSize().height * 0.5 + 1 )

    self.progress:setPercentage(0)
    self.slider_select = ccui.Slider:create()
    -- :loadBarTexture("buy/prog-1.png", 1)
    self.slider_select:setScale9Enabled(true)
    :loadSlidBallTextures("item-select/spr-slider-1.png", "item-select/spr-slider-1.png", "item-select/spr-slider-1.png", 1)
    :setPosition(self.prog_bg:getPositionX(), self.prog_bg:getPositionY())
    :setContentSize(self.prog_bg:getContentSize().width, self.prog_bg:getContentSize().height)
    :setPercent(0)
    :addTo(self)
    :addEventListener(function(ref, eventType)
        self.progress:setPercentage(ref:getPercent())

        local can_buy_num = self:getCanBuyNum() - 1
        local num = math.min(math.floor(can_buy_num * ref:getPercent() / 100), can_buy_num)
        if num + 1 == self.select_num then
            return
        end

        self.select_num = num + 1
        self:updateSelectNum()
    end)
end

function ItemSelectLayer:updateSelectNum()
    self.lbl_select_num:setString(tostring(self.select_num))
    self.lbl_total_num:setString(ex.StringUtil.getScientificNumber(self.select_num * self.item_price.item_num))
end

function ItemSelectLayer:getCanBuyNum()
    if self.total_num >= 0 then
        return math.min(self.total_num, math.floor(ex.Player:getItemNum(self.item_price.item_type) / self.item_price.item_num))
    else
        return math.min(9999, math.floor(ex.Player:getItemNum(self.item_price.item_type) / self.item_price.item_num))
    end
end

function ItemSelectLayer:onSub(tag, pSender)
    self.select_num = self.select_num - 1
    if self.select_num < 1 then
        self.select_num = 1
    end

    local can_buy_num = self:getCanBuyNum() - 1
    local percentage = (self.select_num - 1) * 100.0 / can_buy_num
    if can_buy_num <= 0 then
        percentage = 100
    end
    
    self.progress:setPercentage(percentage)
    self.slider_select:setPercent(percentage)

    self:updateSelectNum()
end

function ItemSelectLayer:onAdd(tag, pSender)
    local can_buy_num = self:getCanBuyNum()
    self.select_num = self.select_num + 1
    if self.select_num > can_buy_num then
        self.select_num = can_buy_num
    end
    if self.select_num < 1 then
        self.select_num = 1
    end
    
    can_buy_num = can_buy_num - 1
    local percentage = (self.select_num - 1) * 100.0 / can_buy_num
    if can_buy_num <= 0 then
        percentage = 100
    end
    
    self.progress:setPercentage(percentage)
    self.slider_select:setPercent(percentage)

    self:updateSelectNum()
end

function ItemSelectLayer:onMax(tag, pSender)
    local can_buy_num = self:getCanBuyNum()
    self.select_num = can_buy_num
    if self.select_num < 1 then
        self.select_num = 1
    end
    
    self.progress:setPercentage(100)
    self.slider_select:setPercent(100)

    self:updateSelectNum()
end

-----------------------------------------------------------------------------
function ItemSelectCtr:onCreate()
	self:setCCBIPath("ccbi/ItemSelectLayer.ccbi")
	self:setIsSingle(false)
end

function ItemSelectCtr:getLayerClass()
	return ItemSelectLayer
end

--[[ 限制：可购买数量必须大于0，否则无法打开界面
    @param str_title: 界面标题文字
    @param item: 被购买的商品的类型及数量 {item_type, item_num}
    @param callback: 确定购买的回调，返回购买的数量
    @param item_price: 被购买商品的单价，用来显示单价及计算已购买商品的总价
    @param item_limit_num: 被购买商品的可购买数量上限，-1表示不限购
]]
function ItemSelectCtr:openWindow(str_title, item, callback, item_price, item_limit_num, cur_buy_num, shop_type, pass_warning)
	if self:isOpened() then
		return
    end
    
    -- 限制：可购买数量必须大于0，否则无法打开界面
    if item_limit_num ~= nil and item_limit_num == 0 then
        return
    end

    if pass_warning ~= true and item_price ~= nil and math.floor(ex.Player:getItemNum(item_price.item_type) / item_price.item_num) <= 0 then
        local config = cfg.item.item[item_price.item_type]
        ex.MessageView:add(ex.Tools:getLang(config.name)..ex.Tools:getLang(47042))
        return
    end

	self:loadLayer()
	self:open()
	self:initData(str_title, item, callback, item_price, item_limit_num, cur_buy_num, shop_type)
end

function ItemSelectCtr:initData(str_title, item, callback, item_price, item_limit_num, cur_buy_num, shop_type)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onSelectDone))

    self.callback = callback
    self.item_price = item_price
    self.limit = item_limit_num
    self.cur_buy_num = cur_buy_num or 0
    self.layer.item_price = item_price and item_price or {item_type=900002,item_num=0}
    self.layer.total_num = item_limit_num and item_limit_num or -1
    if self.cur_buy_num > 0 and self.layer.total_num > 0 then
        self.layer.total_num = self.layer.total_num - self.cur_buy_num
    end

    self.shop_type = shop_type

    self.layer.lbl_title:setString(str_title)

    self:setItem(item)
    self:updateItemPrice()
    self:updateItemLimit()

    self.layer:updateSelectNum()

    if self.layer:getCanBuyNum() <= 1 then
        self.layer.progress:setPercentage(100)
        self.layer.slider_select:setPercent(100)

        self.layer.slider_select:setEnabled(false)
    end
end

function ItemSelectCtr:setItem(item)
    local config = cfg.item.item[item.item_type]

    self.layer.item_type = item.item_type

    if self.layer.item == nil then
        if config.mode == ItemData.IT_SPECIAL_ELITE then
            self.layer.item = UIMenuItemHeroPiece:createWithData(item.item_type)
            self.layer.item:setNum(item.item_num)
        else
            self.layer.item = UIMenuItemBackpack:createWithData(item.item_type, item.item_num)
        end
        self.layer.node_item:addChild(self.layer.item)
    else
        self.layer.item:setNum(item.item_num)
    end

    self.layer.lbl_item_name:setString(ex.Tools:getLang(config.name))
end

function ItemSelectCtr:updateItemPrice()
    if not self.layer.lbl_res_need then
        return
    end
    if self.item_price == nil or self.item_price.item_num <= 0 then
        self.layer.node_price:setVisible(false)
        self.layer.lbl_total_num_tip:setVisible(false)
        self.layer.lbl_total_num:setVisible(false)
        return
    end

    self.layer.node_price:setVisible(true)
    self.layer.lbl_total_num_tip:setVisible(true)
    self.layer.lbl_total_num:setVisible(true)

    local config = cfg.item.item[self.item_price.item_type]
    self.layer.price = self.item_price.item_num

    self.layer.spr_res_need:setSpriteFrame(config.icon..".png")
    self.layer.lbl_res_need:setString(ex.StringUtil.getScientificNumber(self.item_price.item_num))
    self.layer.lbl_total_num:setString(tostring(self.layer.price * self.layer.select_num))
end

function ItemSelectCtr:updateItemLimit()
    if not self.layer.lbl_limit then
        return
    end
    if self.limit == nil or self.limit <= 0 then
        self.layer.lbl_limit:setVisible(false)
        return
    end

    self.layer.lbl_limit:setVisible(true)

    if self.shop_type ~= nil and self.shop_type == SHOP_TYPE.DAY then
        self.layer.lbl_limit:setAnchorPoint(cc.p(1, 0))
        self.layer.lbl_limit:setPosition(435, 220)
        self.layer.lbl_limit:setString(string.format(ex.Tools:getLang(74600), self.cur_buy_num, tostring(self.limit)))
    else
        self.layer.lbl_limit:setString(string.format(ex.Tools:getLang(41229), tostring(self.limit)))
    end
end

function ItemSelectCtr:onSelectDone(tag, pSender)
    -- 数量限制是否合法
    if self.layer.select_num <= 0 or (self.limit > 0 and self.layer.select_num > self.limit) then
        return
    end

    -- 资源需求限制是否合法
    if self.item_price ~= nil then
        local cur_num = ex.Player:getItemNum(self.item_price.item_type)
        if self.item_price.item_num * self.layer.select_num > cur_num then
            local config = cfg.item.item[self.item_price.item_type]
            ex.MessageView:add(ex.Tools:getLang(config.name)..ex.Tools:getLang(47042))
            return
        end
    end

    if self.callback ~= nil then
        self.callback(self.layer.select_num)
    end

    self:closeWindow(0, nil)
end

return ItemSelectCtr
