local PROMSecretTreasureBuyLayer = class("PROMSecretTreasureBuyLayer", require("src.layer.promotion.PromotionBaseLayer"))


function PROMSecretTreasureBuyLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)
    
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(802))  

    self.buy_config = cfg.buygem.buygem[1002]
    self.buy_max_count = self.buy_config.limit_times
    
    self.spr_bg:setPositionY(self.layer_promotion:getTopY() - 126)
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height - 59.5))

    self.spr_bg_gift:setPositionY(self.layer_promotion:getTopY() - 126)
    self.spr_bg_gift:setScaleX(ex.p.width / self.spr_bg_gift:getContentSize().width)
    self.spr_bg_gift:setScaleY(self.spr_bg_gift:getPositionY() / (self.spr_bg_gift:getContentSize().height - 59.5))

    self.spr_price_tip:setPositionY(self.spr_price_tip:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_info:setPositionY(self.node_info:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)

    self.node_buy:setPositionY(self.layer_promotion:getMainSceneBottomY() + 80)
    self.scroll_view:setItemSize(cc.size(115, 100))
    self.scroll_view:setAlignmentCenter(true)
    
    self:updateLayer()
    self:addEvent(EVENT.SECRET_TREASURE.EVENT_BUY, handler(self, self.updateLayer))
end


function PROMSecretTreasureBuyLayer:updateLayer()    
    self.lbl_limit_num:setString(string.format(ex.Tools:getLang(3254), ex.Player.promotion_data.promotion70_good_buy_count, self.buy_max_count))
    
    self.btn_purchase:setVisible(ex.Player.promotion_data.promotion70_good_buy_count < self.buy_max_count)
    self.spr_bought:setVisible(self.btn_purchase:isVisible() == false and true or false)

    -- 更新奖励
    self.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:setScale(0.93)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end
    self.scroll_view:reloadData(self.buy_config.item)
end


function PROMSecretTreasureBuyLayer:onInfo()
    ex.InfoCtr:openWindow("策划还没配语言id", "策划配好语言id了再开始测试")
end

function PROMSecretTreasureBuyLayer:onPurchase()
    if ex.Player.promotion_data.promotion70_good_buy_count >= self.buy_max_count then
        self:updateLayer()
        return
    end
    ex.Player:pay(self.buy_config.idx)
end

return PROMSecretTreasureBuyLayer

