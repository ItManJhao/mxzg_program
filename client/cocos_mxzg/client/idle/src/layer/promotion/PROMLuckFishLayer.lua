local PROMLuckFishLayer = class("PROMLuckFishLayer", require("src.layer.promotion.PromotionBaseLayer"))

function PROMLuckFishLayer:onCreateDone()
    self.layers = {}
    self.layers[1] = require("src.layer.promotion.PROMLuckFishBuyLayer"):createWithCCBIFile("ccbi/PROMLuckFishBuyLayer.ccbi")
    self.layers[2] = require("src.layer.promotion.PROMLuckFishPoolLayer"):createWithCCBIFile("ccbi/PROMLuckFishPoolLayer.ccbi")
    self:addChild(self.layers[1])
    self:addChild(self.layers[2])
    -- local buy_num = ex.Player.promotion_data.luck_fish_data:getLimitNum()
    -- local limit_num = cfg.promotionweekendkoi.promotionweekendkoi[1].buy_limit
    -- self.layer = buy_num >= limit_num and self.layers[2] or self.layers[1]

    -- self.layer = require("src.layer.promotion.PROMLuckFishBuyLayer"):createWithCCBIFile("ccbi/PROMLuckFishBuyLayer.ccbi")
    -- self:addChild(self.layer)

    self:layerVisible()
    local size = self:getContentSize()

    -- self.spr_bg:setPositionY(self.spr_bg:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    -- self.layer:setPositionY((self.layer:getContentSize().height - size.height))
    -- self.layer:setPositionY(require("src.model.Game"):instance():getNotchHeight())
    -- self.layer:setScale(ex.s.global_scale)
    -- dump(self.layer:getPositionY())
    -- self.layer:setPosition()
    self:addEvent(EVENT.LUCK_FISH.UPDATE_BUY_NUM,handler(self,self.layerVisible))
end

function PROMLuckFishLayer:layerVisible()
    local buy_num = ex.Player.promotion_data.luck_fish_data:getLimitNum()
    local limit_num = cfg.promotionweekendkoi.promotionweekendkoi[1].buy_limit
    self.layer = buy_num >= limit_num and self.layers[2] or self.layers[1]
    self.layers[1]:setVisible(buy_num < limit_num )
    self.layers[2]:setVisible(buy_num >= limit_num )
    -- self.layer:setPositionY(require("src.model.Game"):instance():getNotchHeight())
    -- local pos_y = self.layer.spr_bg:getPositionY() - (require("src.model.Game"):instance():getNotchHeight() + self.layer:getContentSize().height)
    -- self.layer:setPositionY(-require("src.model.Game"):instance():getNotchHeight())
    local size = self:getContentSize()
    local layer_size = self.layer:getContentSize()
    -- dump(self.layer_promotion:getTopY())
    self.layer:setPositionY(self.layer_promotion:getTopY() - layer_size.height)
    self.layer:setPositionX((size.width - layer_size.width) / 2)
    self.layer.spr_bg:setScaleX(ex.s.global_scale)
    self.layer.spr_line:setScaleX(ex.s.global_scale)
    -- self.layer:setScaleX(ex.s.global_scale)
    -- print(ex.s.global_scale,self.__cname)
    if buy_num >= limit_num then 
        self.layer:startRun()
        self.layer:updateRes()
    end
end

return PROMLuckFishLayer
