--[[
* @Description: 端午节活动界面三：龙舟豪礼 
* @Author: 熊梦
* @Date: 2020-06-13 17:45:00
* ]]

local PROMDragonBoatGiftLayer = class("PROMDragonBoatGiftLayer", require("src.layer.promotion.PromotionBaseLayer"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
-----------------------------------------------------------------------

function PROMDragonBoatGiftLayer:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.node_tip:setPositionY(self.node_tip:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.spr_bg:setPositionY(self.spr_bg:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.spr_bg:setScaleX(ex.s.global_scale)

    self.gift_data = cfg.promotioneldragonboatprop.promotioneldragonboatprop[1]
 
    local buy_list = ex.Player.promotion_data.promotiondragonboattaskinfo_value.buy
    self.buy_num = 0
    for i,v in ipairs(buy_list) do
        if self.gift_data.idx == i then
            self.buy_num = v.value
        end
    end

    self.lbl_purchase_num:setString(string.format(ex.Tools:getLang(3903),self.buy_num,self.gift_data.buy_limit))
    self.spr_bought:setVisible(false)
    self.btn_purchase:setEnabled(true)

    if self.buy_num >= self.gift_data.buy_limit then
        ex.Tools:setAllGrayAuto(self.btn_purchase, true)
        self.btn_purchase:setEnabled(false)
        self.spr_bought:setVisible(true)
    end

    for i,v in ipairs(self.gift_data.reward) do
        local item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setPositionX(-165+110*(i-1))
        item:setScale(1)
        self.menu_item:addChild(item)
    end
   
    self.buy_gem_config = cfg.buygem.buygem[self.gift_data.product_id]

    self:addEvent(EVENT.PROMOTION_DRAGON_BOAT.GIFT_UPDATE,handler(self,self.updateLayer))

    self.promotion_id = 64
    self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
end

-- 购买成功后回调
function PROMDragonBoatGiftLayer:updateLayer(event, data)
    ex.Player.promotion_data.promotiondragonboattaskinfo_value.buy = data.buy
    local buy_list = data.buy
    for i,v in ipairs(buy_list) do
        if self.gift_data.idx == i then
            self.buy_num = v.value
        end
    end

    if self.buy_num >= self.gift_data.buy_limit then
        ex.Tools:setAllGrayAuto(self.btn_purchase, true)
        self.btn_purchase:setEnabled(false)
        self.spr_bought:setVisible(true)
    end 

    self.lbl_purchase_num:setString(string.format(ex.Tools:getLang(3903),self.buy_num,self.gift_data.buy_limit))
end

-- 道具点击回调
function PROMDragonBoatGiftLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMDragonBoatGiftLayer:onPurchase()
    if self.buy_num >= self.gift_data.buy_limit then
		ex.MessageView:add(ex.Tools:getLang(3904))
		return
	end
    
    if self.time_info.end_time < ex.Game:getServerTime() then
		ex.MessageView:add(ex.Tools:getLang(41053))
		return
	end

	-- 拉起支付页面
	if self.buy_gem_config then
		-- print(string.format("拉起购买 idx=%d, id=%s, rmb = %s", config.idx, config.id, config.rmb))
		ex.Player:pay(self.buy_gem_config.idx)
    end
end



return PROMDragonBoatGiftLayer
