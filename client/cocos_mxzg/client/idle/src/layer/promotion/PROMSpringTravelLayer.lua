--[[
* @Description: 春日活动-活动三：春游记
* @Author: 熊梦
* @Date: 2020-3-23 18:26:00
* ]]
local PROMSpringTravelLayer = class("PROMSpringTravelLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMSpringTravelCell = class("PROMSpringTravelCell", require("src.comp.EventLayer"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

------------------------------------ PROMSpringTravelCell ------------------------------------
function PROMSpringTravelCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function PROMSpringTravelCell:resetData(data)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-spring-outing.plist")
    self.data = data
    local icon = string.format("prom-spring-outing/spr-spring-95-gift-%02d.png", data.idx)
    self.btn_icon = cpp.UIMenuItemImage:createWithSpriteFrameName(icon, nil, nil)
        :setPosition(self.menu:getContentSize().width / 2, self.menu:getContentSize().height - self.menu:getContentSize().height / 3)
    self.menu:addChild(self.btn_icon)
    self.lbl_name:setString(data.name)
    ex.Tools:setLimitWidth(self.lbl_name, 300)
end

function PROMSpringTravelCell:setSelect(is_select)
    self.spr_choose:setVisible(is_select)
    self.is_select = is_select
end

------------------------------------ PROMSpringTravelLayer ------------------------------------
function PROMSpringTravelLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:initEventListen()
    self:addPlist()
    
    -- local width = self.spr_desk_bg:getContentSize().width
    -- if ex.p.width > width then
    --     self.spr_desk_bg:setScaleX(ex.p.width / width)
    -- end
end

function PROMSpringTravelLayer:onCreateDone()
    self.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
    self:initView()
    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
end

function PROMSpringTravelLayer:onExit()
    self:removeTimerByName("timer")
end

function PROMSpringTravelLayer:updateTimer()
    local is_open = cfg.funcopen["act_spring"].isVisible()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion95Data()
    if data == nil then
         if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local cur_time = ex.Game:getServerTime()
    if cur_time > data.end_time then
         if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    self.lbl_time:setString(ex.Tools:formatTime5(data.end_time - ex.Game:getServerTime()))
end


function PROMSpringTravelLayer:initEventListen()
    self:addEvent(EVENT.SPRING.EVENT_BUY_GOODS, handler(self, self.updateLayer))
end

function PROMSpringTravelLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-spring-outing.plist")
end

function PROMSpringTravelLayer:initView()
    self.spr_bg:setPositionY(self.layer_promotion:getTopY())
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height))
    self.spr_title:setPositionY(self.spr_title:getParent():getPositionY() + 490)
    self.spr_santa_claus:setVisible(false)
    self:updateLayer()
end

function PROMSpringTravelLayer:updateLayer()
    local goods_list = ex.Player.promotion_data:getPromotion95Info()
    if not goods_list or #goods_list == 0 then
        return
    end

    if not self.select_idx then
        self.select_idx = goods_list[1].idx
    end

    local view_size = cc.size(520, 134)
    self.goods_scroll_view:setItemType(1)
    self.goods_scroll_view:setCreateNum(1)
    self.goods_scroll_view:setViewSize(view_size)
    self.goods_scroll_view:setItemSize(cc.size(134, 118))
    self.goods_scroll_view:setSwallowsTouches(false)

    self.goods_scroll_view.createItemFunction = function(item_data, scale)
        local cell = PROMSpringTravelCell:createWithCCBIFile("ccbi/PROMSpringTravelCell.ccbi")
        cell.menu:setSwallowsTouches(false)
        cell.menu:setIsTouchInsideNode(self.goods_scroll_view)
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(cc.p(0.5, 0.5))
        cell:resetData(item_data)
        if item_data.idx == self.select_idx then
            cell:setSelect(true)
            self.select_item = cell
            self:selectGoods(item_data)
        end
        cell.btn_icon:registerScriptTapHandler(handler(self, self.onSelect))
        return cell
    end

    local con_width = view_size.width
    if #goods_list * 134 > con_width then
        con_width = #goods_list * 118
    else
        self.goods_scroll_view:setTouchEnabled(false)
    end

    self.goods_scroll_view:setContentSize(cc.size(con_width, view_size.height))
    self.goods_scroll_view:reloadData(goods_list)

    local offset_x = self.goods_scroll_view:getContentOffset().x
    local pos_x = self.select_item:getPositionX() + self.select_item:getContentSize().width / 2
    if pos_x + offset_x > view_size.width then
        self.goods_scroll_view:setContentOffset(cc.p(view_size.width - pos_x,0))
    end
end

function PROMSpringTravelLayer:selectGoods(data)
    self.lbl_limit_num:setString(string.format("%s%s/%s", ex.Tools:getLang(73503), data.buy_times, data.buy_limit))
    local buy_gem_config = cfg.buygem.buygem[data.product_id]
    
    self.lbl_original_cost:setString(string.format(ex.Tools:getLang(70800), buy_gem_config.original_cost / 100))

    if data.buy_limit <= data.buy_times then
        self.btn_buy:setLabelText(ex.Tools:getLang(77010))
        self.btn_buy:setEnabled(false)
        ex.Tools:setGrayAuto(self.btn_buy:getNormalImage(), true)
    else
        self.btn_buy:setLabelText((buy_gem_config.rmb / 100) .. ex.Tools:getLang(47224) .. ex.Tools:getLang(52306))
        self.btn_buy:setEnabled(true)
        ex.Tools:setGrayAuto(self.btn_buy:getNormalImage(), false)
    end
    local ttfcon = self.btn_buy:getLabel()
    ex.Tools:setLimitWidth(ttfcon, 140)

    local view_size = cc.size(460, 120)
    self.rewards_scroll_view:setItemType(0)
    self.rewards_scroll_view:setCreateNum(1)
    self.rewards_scroll_view:setViewSize(view_size)
    self.rewards_scroll_view:setItemSize(cc.size(120, 120))

    self.rewards_scroll_view.createItemFunction = function(item_data, scale)
        local item_type = item_data.item_type
        local item_num = item_data.item_num

       local item = ex.Player.backpack_data:createWithData(item_type, item_num)
		item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setIgnoreAnchorPointForPosition(false)
        item:setAnchorPoint(cc.p(0.5, 0.5))
        return item
    end

    local con_width = view_size.width
    if #data.reward * 120 > con_width then
        con_width = #data.reward * 120
    else
        self.rewards_scroll_view:setTouchEnabled(false)
    end

    self.rewards_scroll_view:setContentSize(cc.size(con_width, view_size.height))
    self.rewards_scroll_view:reloadData(data.reward)
end

function PROMSpringTravelLayer:onSelect(tag, pSender)
    local item = pSender:getParent():getParent()
    if not item then
        return
    end

    if self.select_item == item then
        return
    end

    if self.select_item and self.select_item.setSelect then
        self.select_item:setSelect(false)
    end
    
    item:setSelect(true)
    self.select_item = item
    local data = item.data
    self.select_idx = data.idx
    self:selectGoods(data)
end

function PROMSpringTravelLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMSpringTravelLayer:onBuy()
    if not self.select_item or not self.select_item.data then
        return
    end

    local data = self.select_item.data
    if data.buy_times >= data.buy_limit then
        return
    end
    ex.Player:pay(data.product_id)
end


return PROMSpringTravelLayer
