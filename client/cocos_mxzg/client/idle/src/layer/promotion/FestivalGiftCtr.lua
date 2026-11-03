local FestivalGiftCtr = class("FestivalGiftCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FestivalGiftLayer = class("FestivalGiftLayer", require("src.comp.EventLayer"))

function FestivalGiftLayer:onCreate()
    self:addBlackBackground()

    self.btn_close:setVisible(false)

    -- local item_size = cc.Sprite:createWithSpriteFrameName("other/rare-0.png"):getContentSize()
    local item_size = cc.size(self.scroll_view:getViewSize().width / 4 - 2, self.scroll_view:getViewSize().height - 10)
    self.scroll_view:setItemSize(cc.size(item_size.width, item_size.height + 10))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self.scroll_view:setAutoOffset(true)
    self.scroll_view:setAutoScale(false)

    self.layer_type = 1
    self:updateLayer()

    self:addEvent(EVENT.MAIN_CITY_PROMOTION.FESTIVAL_OVERVALUE_GIFT, handler(self, self.updateLayer))

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()

    self:addRedDotNode(RedDotType.ZCJ_DHZC_JRHL_CZL, self.btn_gift1)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_JRHL_HHL, self.btn_gift2)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_JRHL_CZL_LQJL, self.btn_done)
end

function FestivalGiftLayer:onExit()
    self:removeTimerByName("timer")
	ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_festival_gift")
end

function FestivalGiftLayer:updateTimer()

	local time =  ex.Player.promotion_data:getFestivalOvervalueGiftTimeData().end_time - ex.Game:getServerTime()
	if time <= 0 then 
        FestivalGiftCtr:instance():closeWindow()
        return
    end
    
    local str = nil
    local d,h,m,s = ex.Tools:formatTime(time)
    if d >= 1 then
        str = string.format(ex.Tools:getLang(47050), d , h, m, s)
    else
        str = string.format(ex.Tools:getLang(47533), d * 24 + h, m, s)
    end
    self.lbl_time:setString(str)
    
    -- 居中显示
    local width = self.lbl_time_tips:getContentSize().width + self.lbl_time:getContentSize().width + 5
    self.lbl_time_tips:setPositionX(self:getContentSize().width * 0.5 - width * 0.5)
    self.lbl_time:setPositionX(self.lbl_time_tips:getPositionX()  + 5 + self.lbl_time_tips:getContentSize().width)
end
-- 16	act_festival_gift	1008700		main-city/icon-act_clan_gvg.png	圣诞-节日豪礼	16	3	6

function FestivalGiftLayer:updateLayer()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/festival-gift.plist")
    
    self.btn_gift1:setChecked(self.layer_type == 1)
    self.btn_gift2:setChecked(self.layer_type == 2)
    self.lbl_tip2:setVisible(self.layer_type == 1)
    ex.RedDotManager:setSpecialVisible(RedDotType.ZCJ_DHZC_JRHL_CZL_LQJL, self.layer_type == 1)

    local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")
    self.scroll_view.createItemFunction = function(item_data)
        local item = UIMenuItemBag:createWithData(item_data.item_type, item_data.item_num)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        item:setFrameImage("festival-gift/item-bg.png")
        
        if self.layer_type == 1 and item.lbl_num ~= nil then
            item.lbl_num:setString(ex.StringUtil.getScientificNumber(item_data.item_num).."*7")
        end

        return item
    end
    self.scroll_view:reloadData(cfg.festivalovervaluegift.festivalovervaluegift[self.layer_type].gift_reward)

    local gray_buy = true
    if self.layer_type == 1 then
        self.lbl_tip1:setString(ex.Tools:getLang(70201))
        -- 没有购买超值礼包
        if ex.Player.promotion_data:isBuyFestivalOvervalueGift(cfg.festivalovervaluegift.festivalovervaluegift[1].idx) == false then
            gray_buy = false
            ex.Tools:setSpriteFrame(self.btn_done:getNormalImage(), "festival-gift-lang/btn-text-1.png")
            ex.Tools:setSpriteFrame(self.btn_done:getSelectedImage(), "festival-gift-lang/btn-text-1.png")

            local time_data = ex.Player.promotion_data:getFestivalOvervalueGiftTimeData()
            
            -- 计算两个时间戳相隔多少天
            local day_diff = Maths.getDays(ex.Game:getServerTime()) - Maths.getDays(time_data.start_time)
            self.lbl_tip2:setString(string.format(ex.Tools:getLang(70202), day_diff))
            self.lbl_tip2:setVisible(day_diff > 0)
        else
            gray_buy= ex.Player.promotion_data.festival_overvalue_gift.receive_day >= ex.Player.promotion_data.festival_overvalue_gift.day
            ex.Tools:setSpriteFrame(self.btn_done:getNormalImage(), "festival-gift-lang/btn-text-0.png")
            ex.Tools:setSpriteFrame(self.btn_done:getSelectedImage(), "festival-gift-lang/btn-text-0.png")
            self.lbl_tip2:setVisible(false)
        end
    elseif self.layer_type == 2 then
        self.lbl_tip1:setString(ex.Tools:getLang(70203))
        gray_buy = ex.Player.promotion_data:isBuyFestivalOvervalueGift(cfg.festivalovervaluegift.festivalovervaluegift[2].idx)
        ex.Tools:setSpriteFrame(self.btn_done:getNormalImage(), "festival-gift-lang/btn-text-2.png")
        ex.Tools:setSpriteFrame(self.btn_done:getSelectedImage(), "festival-gift-lang/btn-text-2.png")
    end

    ex.Tools:setGrayAuto(self.btn_done:getNormalImage(), gray_buy)
    ex.Tools:setGrayAuto(self.btn_done:getSelectedImage(), gray_buy)
end

function FestivalGiftLayer:onChangeLayer(tag)
    if self.layer_type == tag then
        return
    end

    self.layer_type = tag
    self:updateLayer()
end

-- 购买
function FestivalGiftLayer:onBuy()
    if self.layer_type == nil or self.layer_type <= 0 then
        return
    end
    

    -- 没有活动数据
    if table.nums(ex.Player.promotion_data.festival_overvalue_gift) <= 0 then
        return
    end

    -- 豪华礼包
    if self.layer_type == 2 then
        if ex.Player.promotion_data:isBuyFestivalOvervalueGift(cfg.festivalovervaluegift.festivalovervaluegift[2].idx) then
            ex.MessageView:add(ex.Tools:getLang(47228))
            return
        end
        ex.Player:pay(cfg.festivalovervaluegift.festivalovervaluegift[2].production_id)
        return
    end

    -- 超值礼包，可以7天连续领取
    -- 判断是否购买了
    if ex.Player.promotion_data:isBuyFestivalOvervalueGift(cfg.festivalovervaluegift.festivalovervaluegift[1].idx) == false then
        ex.Player:pay(cfg.festivalovervaluegift.festivalovervaluegift[1].production_id)
        return
    end

    -- 已经购买了。判断是否可以领取
    if ex.Player.promotion_data.festival_overvalue_gift.receive_day < ex.Player.promotion_data.festival_overvalue_gift.day then
        local req_receive = Promotion050_pb.GReqFestivalGiftReceive()
        req_receive.idx = 1
        NetManager:sendMessage(ProtocolID.GReqFestivalGiftReceive, req_receive)
        return
    end
end

-----------------------------------------------------------------------------
function FestivalGiftCtr:onCreate()
	self:setCCBIPath("ccbi/FestivalGiftLayer.ccbi")
	self:setIsSingle(false)
end

function FestivalGiftCtr:getLayerClass()
	return FestivalGiftLayer
end

function FestivalGiftCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function FestivalGiftCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return FestivalGiftCtr
