local MidAutumnActivityLayer = class("MidAutumnActivityLayer", require("src.comp.EventLayer"))
local MidAutumnActivityCtrl = class("MidAutumnActivityCtrl", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

function MidAutumnActivityLayer:onCreate()
	self:addBlackBackground()
	self:setAutoClose(true)
	self:setSwallowTouches(true)

    self.config = ex.Player.shop_data:getRechargeList(RechargeKindType.MID_AUTUMN)[1]

    self:updateView()
    
	self:changeTimer()
    self:addTimer("timer",1000,handler(self,self.changeTimer),true)
    
    self.btn_buy:registerScriptTapHandler(handler(self, self.onClickBuy))
    self.spr_reward_1:registerScriptTapHandler(handler(self, self.onClickItem))
    self.spr_reward_2:registerScriptTapHandler(handler(self, self.onClickItem))
    self.spr_reward_3:registerScriptTapHandler(handler(self, self.onClickItem))
end

function MidAutumnActivityLayer:changeTimer()
	local time = ex.Player.promotion_data.mid_autumn_info.end_time - ex.Game:getServerTime()
	if time <= 0 then 
		self:removeTimerByName("timer")
        MidAutumnActivityCtrl:instance():closeWindow()
        return
    end
    
	local d,h,m,s = ex.Tools:formatTime(time)
    local str = string.format(ex.Tools:getLang(47533), d * 24 + h, m, s)
	-- print(time,self.__cname,str,ex.Game:getServerTime(), ex.Player.promotion_data.mid_autumn_info.end_time)
	self.lbl_time:setString(str)
end

function MidAutumnActivityLayer:updateView(event,data)
    self.btn_buy:setEnabled(not ex.Player.promotion_data.mid_autumn_info.is_bought)

    for i, v in ipairs(self.config.item) do
        if i > 3 then
            break
        end

        local reward_img = nil
        if v.item_type > 20000000 and v.item_type < 30000000 then -- 碎片
            reward_img = sfc:getSpriteFrame(string.format("hero-icon/%d.png", v.item_type - 10000000))
        else -- 特殊 装备 道具 其他
            reward_img = sfc:getSpriteFrame(string.format("backpack/%d.png", v.item_type))
        end

        self["spr_reward_"..i].item_type = v.item_type
        self["spr_reward_"..i]:setNormalSpriteFrame(reward_img)

        self["label_reward_"..i]:setString("X"..v.item_num)
    end

    local str_reward = ""
    local mail_reward_key = next(cfg.promotionmidautumn.promotionmidautumn)
    local mail_reward = cfg.promotionmidautumn.promotionmidautumn[mail_reward_key]
    if mail_reward ~= nil then
        for i, v in ipairs(mail_reward.reward) do
            str_reward = str_reward..ex.Tools:getLang(v.item_type).."x"..v.item_num.."\n"
        end
    end
    self.label_mail_reward:setString(str_reward)
end

function MidAutumnActivityLayer:onClickBuy(tag, pSender)
    local cur_time = ex.Game:getServerTime()
    if next(ex.Player.promotion_data.mid_autumn_info) == nil or 
        ex.Player.promotion_data.mid_autumn_info.begin_time > cur_time or 
        ex.Player.promotion_data.mid_autumn_info.end_time < cur_time then
        print(">>>>>MidAutumnActivityLayer:onClickBuy 没有活动数据或不在有效期,无法购买")
        return
    end

    if ex.Player.promotion_data.mid_autumn_info.is_bought then
        ex.MessageView:add(ex.Tools:getLang(47506))
        return 
    end

    ex.Player:pay(self.config.idx)

    pSender:setEnabled(false)
end

function MidAutumnActivityLayer:onClickItem(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function MidAutumnActivityLayer:onExit()
	
end

----------------------------------------------------------

function MidAutumnActivityCtrl:onCreate()
	self:setCCBIPath("ccbi/MidAutumnActivityLayer.ccbi")
	
	self:setIsSingle(false)
end

function MidAutumnActivityCtrl:getLayerClass()
	return MidAutumnActivityLayer
end

function MidAutumnActivityCtrl:getLayer()
	return self.layer
end

function MidAutumnActivityCtrl:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function MidAutumnActivityCtrl:initData(data)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
end


return MidAutumnActivityCtrl