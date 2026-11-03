-- 七神器-礼包
local PROMShangYueJiaYaoLayer = class("PROMShangYueJiaYaoLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMShangYueJiaYaoItem = class("PROMShangYueJiaYaoItem", require("src.comp.EventLayer"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

------------------------------------ PROMShangYueJiaYaoItem ------------------------------------
function PROMShangYueJiaYaoItem:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function PROMShangYueJiaYaoItem:resetData(data)
    self.data = data
    local icon = string.format("prom-zhongqiu-2/%d.png", data.idx)
    print(self.__cname,icon,"i>>>>>>>>>.")
    self.btn_icon = cpp.UIMenuItemImage:createWithSpriteFrameName(icon, nil, nil)
        :setPosition(self.menu:getContentSize().width / 2, self.menu:getContentSize().height / 2)
    self.menu:addChild(self.btn_icon)
    self.lbl_name:setString(data.name)
end

function PROMShangYueJiaYaoItem:setSelect(is_select)
    self.spr_choose:setVisible(is_select)
    self.is_select = is_select
end

------------------------------------ PROMShangYueJiaYaoLayer ------------------------------------
function PROMShangYueJiaYaoLayer:onCreate()


    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:initEventListen()
    self:addPlist()
end

function PROMShangYueJiaYaoLayer:onCreateDone()
    self.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
    self:initView()
    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
end

function PROMShangYueJiaYaoLayer:onExit()
    self:removeTimerByName("timer")
end

function PROMShangYueJiaYaoLayer:updateTimer()
    local is_open = cfg.funcopen["act_appreciate_moon"].isVisible()
    if is_open ~= true then
        --if self.layer_promotion then
            --self.layer_promotion:resetTabView()
        --end
        return
    end

    local data = ex.Player.promotion_data:getPromotionDatas(75)
    if data == nil then
         --if self.layer_promotion then
            --self.layer_promotion:resetTabView()
        --end
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


function PROMShangYueJiaYaoLayer:initEventListen()
    self:addEvent(EVENT.ZHONG_QIU.UPDATE_JIA_YAO_BUY, handler(self, self.updateLayer))
end

function PROMShangYueJiaYaoLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/promotion-71.plist")
end

function PROMShangYueJiaYaoLayer:initView()
    self.spr_bg:setPositionY(self.layer_promotion:getTopY())
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height))

    self:updateLayer()
end

function PROMShangYueJiaYaoLayer:updateLayer()
    local goods_list = ex.Player.promotion_data.zhongqiu_data:getJiaYaoCfg()
    if not goods_list or #goods_list == 0 then
        return
    end

    if not self.select_idx then
        self.select_idx = goods_list[1].idx
    end

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/prom-zhongqiu-2.plist")

    local view_size = cc.size(520, 134)
    self.goods_scroll_view:setItemType(1)
    self.goods_scroll_view:setCreateNum(1)
    self.goods_scroll_view:setViewSize(view_size)
    self.goods_scroll_view:setItemSize(cc.size(134, 118))
    self.goods_scroll_view:setSwallowsTouches(false)

    self.goods_scroll_view.createItemFunction = function(item_data, scale)
        local cell = PROMShangYueJiaYaoItem:createWithCCBIFile("ccbi/PROMShangYueJiaYaoItem.ccbi")
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

function PROMShangYueJiaYaoLayer:selectGoods(data)
    self.lbl_limit_num:setString(string.format("%s%s/%s", ex.Tools:getLang(73503), data.buy_times, data.buy_limit))
    local buy_gem_config = cfg.buygem.buygem[data.product_id]

    self.lbl_original_cost:setString(string.format(ex.Tools:getLang(70800), buy_gem_config.original_cost / 100))

    if data.buy_limit <= data.buy_times then
        self.btn_buy:setLabelText(ex.Tools:getLang(77010))
        self.btn_buy:setEnabled(false)
        ex.Tools:setGrayAuto(self.btn_buy:getNormalImage(), true)

    else
        self.btn_buy:setLabelText((ex.Tools:getLang(47224) .. buy_gem_config.rmb / 100) .. ex.Tools:getLang(52306))
        self.btn_buy:setEnabled(true)
        ex.Tools:setGrayAuto(self.btn_buy:getNormalImage(), false)
    end

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

function PROMShangYueJiaYaoLayer:onSelect(tag, pSender)
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

function PROMShangYueJiaYaoLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMShangYueJiaYaoLayer:onBuy()
    if not self.select_item or not self.select_item.data then
        return
    end

    local data = self.select_item.data
    if data.buy_times >= data.buy_limit then
        return
    end
    ex.Player:pay(data.product_id)
end


return PROMShangYueJiaYaoLayer
