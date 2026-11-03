local RCGRechargeLayer = class("RCGRechargeLayer", require("src.layer.promotion.PromotionBaseLayer"))
--------------------------------------RCGRechargeLayer-------------------------------------------------
function RCGRechargeLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(103))
    self.spr_banner:setVisible(false)

    self.node_all:setScale(1)
    self.node_all:setPositionY(self.spr_banner:getPositionY() + self.spr_banner:getContentSize().height * self.spr_banner:getScaleY() / 2)
    self.node_all:setContentSize(cc.size(ex.p.width, self.node_all:getContentSize().height))

    self.exp_progressbar = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("promotion-3/prog-1.png"))
    self.exp_progressbar:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.exp_progressbar:setMidpoint(cc.p(0, 0.5))
    self.exp_progressbar:setAnchorPoint(ex.a.center)
    self.exp_progressbar:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.node_progressbar:addChild(self.exp_progressbar, 10)
    self.exp_progressbar:setPosition(ex.p.zero)

    self:reorderChild(self.lbl_progressbar, 20)
    
    -- self:addVipExpCell()
    self:resetScrollView()
    self.scroll_view_item:setPositionX(self:getContentSize().width / 2)
    -- self.scroll_view_item:setViewSize(cc.size(ex.p.width - 20, self.scroll_view_item:getViewSize().height + 126))
    self.scroll_view_item:setItemType(1)
    self.scroll_view_item.nodeTouched = handler(self, self.onTouchCell)
    self:updateLayer()
    self:addEvent(EVENT.MAIN_CITY_RECHARGE.RECHARGE_GEM, handler(self, self.updateLayer))
    self:addEvent(EVENT.MAIN_CITY_PROMOTION.CLERGY_REFRESH, handler(self, self.updateLayer))
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
end

function RCGRechargeLayer:onExit()
    self:removeTimerByName("timer")
end

function RCGRechargeLayer:updateTimer()
    local data = ex.Player.promotion_data:getPromotionDatas(73)
    if data == nil then
        self:removeTimerByName("timer")
        return
    end

    local cur_time = ex.Game:getServerTime()
    if data.start_time and data.start_time < cur_time and not ex.Player.promotion_data:getPromotion73Status() then
        NetManager:sendMessage(ProtocolID.GReqShopRechargeCheck)
        ex.Player.promotion_data:setPromotion73Status(true)
        self:removeTimerByName("timer")
        return
    end
end


function RCGRechargeLayer:refreshData()
    self.cur_info = nil
    self.next_info = nil

    local sort_list = cfg.clergyprivilege.getSortConfigs()
    for i, v in ipairs(sort_list) do
        if v.unlock_need_exp <= ex.Player.clergy_exp then
            if self.cur_info == nil or self.cur_info.clergy_level < v.clergy_level then
                self.cur_info = v
            end
        end

        if v.unlock_need_exp > ex.Player.clergy_exp then
            if self.next_info == nil or self.next_info.clergy_level > v.clergy_level then
                self.next_info = v
            end
        end
    end
end

function RCGRechargeLayer:updateLayer()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/shop.plist")

    self:refreshData()

    if self.cur_info.clergy_level <= 0 then
        self.node_clergy_title:setVisible(false)
    else
        self.node_clergy_title:setVisible(true)
        ex.Tools:setSpriteFrame(self.spr_clergy_title, string.format("promotion-3/clergy-title-%d.png", self.cur_info.clergy_level))
    end
    if self.next_info ~= nil then
        self.exp_progressbar:setPercentage(100.0 * ex.Player.clergy_exp / self.next_info.unlock_need_exp)
        self.lbl_progressbar:setString(string.format("%d/%d", ex.Player.clergy_exp, self.next_info.unlock_need_exp))
    
        ex.Tools:setSpriteFrame(self.spr_next_clergy_title, string.format("promotion-3/clergy-title-10%d.png", self.next_info.clergy_level))

        local need_gem = (self.next_info.unlock_need_exp - ex.Player.clergy_exp) / 10
        self.lbl_gem:setString(tostring(need_gem))
    else
        -- self.exp_progressbar:setPercentage(100.0 * ex.Player.clergy_exp / self.cur_info.unlock_need_exp)
        -- self.lbl_progressbar:setString(string.format("%d/%d", ex.Player.clergy_exp, self.cur_info.unlock_need_exp))
        self.node_progressbar:setVisible(false)
    
        self.node_title:removeAllChildren()
        local spr_top_level_tip = cc.Sprite:createWithSpriteFrameName("promotion-3/lbl-recharge-tip-2.png")
        spr_top_level_tip:setPosition(self.node_title:getContentSize().width / 2, -60)
        self.node_title:addChild(spr_top_level_tip)

        self.node_clergy_title:setScale(1)
        self.node_clergy_title:setPositionY(60)
    end

	local item_size = cc.size(200, 220)
    item_size = cc.size(item_size.width + 10, item_size.height + 10)

    local vec_recharge = ex.Player.shop_data:getRechargeList(RechargeKindType.RECHARGE)

    local scale = (self.scroll_view_item:getViewSize().width / 3) / 200
    self.scroll_view_item:setItemSize(cc.size(200 * scale, 220 * scale))
    self.scroll_view_item.createItemFunction = function(data)
        local item = require("src.layer.promotion.RCGRechargeCell"):createWithCCBIFile("ccbi/RCGRechargeCell.ccbi")
        item:setIgnoreAnchorPointForPosition(false)
        item:setAnchorPoint(cc.p(0.5, 0.5))
        item:setScale(scale * 0.9)
        item.config = data

        -- item.spr_buy:setSpriteFrame("shop/item-1.png")
        ex.Tools:setSpriteFrame(item.spr_buy, "shop/item-1.png")
        -- ex.Tools:setSpriteFrame(item.spr_buy, string.format("backpack/%d.png", data.item[1].item_type))
        -- item.spr_buy:setSpriteFrame(sfc:getSpriteFrame(string.format("backpack/%d.png", data.item[1].item_type)))
        item.lbl_price:setString(string.format(ex.Tools:getLang(47776), data.rmb / 100))
        item.lbl_buy_num:setString(string.format("x%d", data.item[1].item_num))

        ex.Tools:setSpriteFrame(item.spr_reward, string.format("backpack/%d.png", data.first_buy_reward[1].item_type))
        item.lbl_reward_num:setString(string.format("%d", data.first_buy_reward[1].item_num))

        if ex.Player.shop_data:isPurchased(data.idx) then
        	item.spr_buy_tip1:setVisible(false)
			item.spr_buy_tip2:setVisible(false)
        end

        return item
    end
    self.scroll_view_item:reloadData(vec_recharge)


    -- ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.PROMATION_VIP_EXP)
end

function RCGRechargeLayer:onTouchCell(tag, pSender)
	local config = pSender.config

    ex.Player:pay(config.idx)
end

return RCGRechargeLayer
