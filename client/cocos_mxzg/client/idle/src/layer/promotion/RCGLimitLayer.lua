local RCGLimitLayer = class("RCGLimitLayer", require("src.layer.promotion.PromotionBaseLayer"))

-------------------------------------RCGLimitLayer----------------------------------------------------
function RCGLimitLayer:onCreateDone()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local spr_banner = self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(102))

    self:resetScrollView(nil, cc.size(5, 5))

    local scale = ex.p.width / 640
    self.scroll_view:setViewSize(cc.size(ex.p.width - 20, self.scroll_view:getViewSize().height))
    self.scroll_view:setPositionX(10)
    self.scroll_view:setItemType(1)
    self.scroll_view:setCreateNum(10)
    self.scroll_view:setItemSize(cc.size(self.scroll_view:getViewSize().width, 170.0 * scale + 5))

    local win_size = cc.Director:getInstance():getWinSize()
    self.node_reward:setLocalZOrder(1)
    self.node_reward:setPosition(win_size.width * 0.89, spr_banner:getPositionY())

    self.btn_shop:getParent():setLocalZOrder(1)
    self.btn_shop:setPosition(65, spr_banner:getPositionY())
    self.btn_shop:setContentSize(100, 100)
    
    local spine_shop = sp.SkeletonAnimation:create("spine/yxsc.json","spine/yxsc.atlas", 1)
    spine_shop:setAnimation(0, "stand", true);
    spine_shop:setScale(1)
    spine_shop:setPosition(self.btn_shop:getContentSize().width / 2, self.btn_shop:getContentSize().height / 2)
    self.btn_shop:addChild(spine_shop, 10)

    self.node_banner:setPosition(self.spr_banner:getContentSize().width * 0.5 + 60,  self.spr_banner:getContentSize().height * 0.5)
    self:updateLayer()
    self:addHeroShopEffect()
    self:addEvent(EVENT.MAIN_CITY_RECHARGE.PROMATION_DAYLIMIT, handler(self, self.updateLayer))
    -- self.btn_reward:setVisible(false)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_CZ_XSLB_MRJL, self.btn_reward)
end

function RCGLimitLayer:addHeroShopEffect()
    ex.EffectCtr:playNormalEff(23, self.btn_shop:getContentSize().width / 2, self.btn_shop:getContentSize().height * 0.5+5, nil, self.btn_shop, 0)
end

function RCGLimitLayer:onExit()
    ex.RedDotManager:removeStickNode(RedDotType.ZCJ_DHZC_CZ_XSLB_MRJL, self.btn_reward)
end

function RCGLimitLayer:updateLayer()
    local RCGLimitCell = require("src.layer.promotion.RCGLimitCell")
    local sfc = cc.SpriteFrameCache:getInstance()

    local show_data = ex.Player.promotion_data:getRechargeList()
    local sort = function ( a,b )
        return a.idx<b.idx
    end
    table.sort( show_data, sort )

    self.scroll_view.createItemFunction = function(data, scale, index)
        local cell = RCGLimitCell:createWithCCBIFile("ccbi/RCGLimitCell.ccbi")
        cell:setScale(self.scroll_view.item_size.width / cell:getContentSize().width)
        cell:reset(data, self.scroll_view, index)
        cell.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))
        return cell
    end
    self.scroll_view:reloadData(show_data)

    self.btn_reward:setVisible(ex.Player.promotion_data.day_limit_reward == 0)
    self.spr_reward:setVisible(ex.Player.promotion_data.day_limit_reward ~= 0)
end

function RCGLimitLayer:onReward(tag, pSender)
    if ex.Player.promotion_data.day_limit_reward == true then
        return 
    end

    ex.Player.promotion_data.day_limit_reward = 1
    ex.Player.promotion_data:checkLimitRedDot()


    self.btn_reward:setVisible(ex.Player.promotion_data.day_limit_reward == 0)
    self.spr_reward:setVisible(ex.Player.promotion_data.day_limit_reward ~= 0)

    NetManager:sendMessage(ProtocolID.GReqDailyGiftReward)
end

function RCGLimitLayer:onShop(tag, pSender)
    cfg.funcopen["main_shop"].open(SHOP_TYPE.HERO)
end

function RCGLimitLayer:onBuy(tag, pSender)
    -- dump(pSender:getParent():getParent().data)
    -- if ex.Player.vip_level < pSender:getParent():getParent().data.vip_require then
    --     ex.MessageView:add(string.format(ex.Tools:getLang(47052), pSender:getParent():getParent().data.vip_require))
    --     return
    -- end
    
    print(pSender:getParent():getParent().data.id, tostring(pSender:getParent():getParent().data.rmb / 100))
    
    ex.Player:pay(pSender:getParent():getParent().data.production_id)
end

function RCGLimitLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

return RCGLimitLayer
