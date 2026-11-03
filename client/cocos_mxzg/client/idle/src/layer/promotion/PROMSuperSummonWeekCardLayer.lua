--[[
    func: 召唤周卡
    author:徐东浩
    time:2020-04-27 16:35:46
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local PROMSuperSummonWeekCardLayer = class("PROMSuperSummonWeekCardLayer", require("src.layer.promotion.PromotionBaseLayer"))

-- 奖励item位置
local ItemXPos = {-179, -60, 60, 179}

function PROMSuperSummonWeekCardLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.promotion_id = 58

	self.data = {}
	self.time_info = {}

	self.node_bg:setScale(ex.s.global_scale)
	self.node_bg:setPosition(0, self.layer_promotion:getTopY() - 10)

	self.lbl_time = cpp.RichTextEx:createWithXMLLua("")
	self.lbl_time:setFontSize(36)
	self.lbl_time:setScale(0.5)
	self.lbl_time:setFontFace(FONT_DEFAULT_NAME_BOLD)
	self.lbl_time:setFontColor("#ffffff")
	self.lbl_time:setAnchorTextShadow(false)
	self.lbl_time:setAnchorPoint(ex.a.center)
    self.lbl_time:setPosition(ex.Tools:getAbsolutePosition(cc.p(198, 0), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_BOTTOM, self.time_node))
    self.lbl_time:setLocalZOrder(10)
	self.time_node:addChild(self.lbl_time)

	self.menu:setLocalZOrder(10)
	self.btn_do:registerScriptTapHandler(handler(self, self.onBtnDone))

	self:addEvent(EVENT.MAIN_CITY_PROMOTION.SUPER_SUMMON_WEEK_CARD_REFRESH, handler(self, self.onEvent))

	self:refreshData( )
	self:initDone()
end

function PROMSuperSummonWeekCardLayer:refreshData()
	self.data = {}

	self.data.week_reward = {}
	self.data.week_reward.item_type = cfg.timelimititem.getRewardType(ItemType.SUPER_SUMMON_WEEK_CARD)
	self.data.week_reward.item_num = cfg.timelimititem.getTotalRewardNumType(ItemType.SUPER_SUMMON_WEEK_CARD)

	self.data.cur_reward = {}
	self.data.cur_reward.idx = ex.Player.promotion_data.super_summon_week_card_data.idx
	self.data.cur_reward.buy_times = ex.Player.promotion_data.super_summon_week_card_data.buy_times

	self.data.cur_config = ex.Player.promotion_data:getSuperSummonWeekCardConfig(self.data.cur_reward.idx)
	self.data.buy_gem_config = cfg.buygem.buygem[self.data.cur_config.product_id]

	self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
end

function PROMSuperSummonWeekCardLayer:onEvent(event, data)
	self:refreshData()
	
	self:updateInfo()
end

function PROMSuperSummonWeekCardLayer:updateCDTime()
	local remain_time = self.time_info.end_time - ex.Game:getServerTime()

	if ex.Game:getServerTime()  <  self.time_info.start_time then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
		self.lbl_time:setXmlTextLua(ex.Tools:getLang(41053));

		self:removeTimerByName("colorful_timer")
		return
	end

    if remain_time > 86400 then
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41130),
            math.floor(remain_time / 86400)))
    else
        self.lbl_time:setXmlTextLua(string.format(ex.Tools:getLang(41129), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
end

function PROMSuperSummonWeekCardLayer:initDone()
    self:updateCDTime()

	self:updateRawardShow()

	self:updateInfo()

	self:addTimer("colorful_timer", 1000, handler(self, self.updateCDTime), true)
end

function PROMSuperSummonWeekCardLayer:updateInfo()
	self.lbl_origin_cost:setString(string.format(ex.Tools:getLang(3901), tostring(self.data.buy_gem_config.original_cost / 100)))
	self.lbl_cur_cost:setString(string.format(ex.Tools:getLang(3902), tostring(self.data.buy_gem_config.rmb / 100)))

	self.lbl_limit_buy:setString(string.format(ex.Tools:getLang(3903), tonumber(self.data.cur_reward.buy_times), tonumber(self.data.cur_config.buy_limit)))

	local is_bought = self.data.cur_reward.buy_times >= self.data.cur_config.buy_limit
	self.btn_do:setEnabled(not is_bought)
	self.btn_do:setVisible(not is_bought)
	self.spr_bought:setVisible(is_bought)
end

function PROMSuperSummonWeekCardLayer:updateRawardShow()
	self.menu_reward:removeAllChildren()

	for i,v in ipairs(self.data.cur_config.reward) do
		local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
		item:setPosition(ItemXPos[i], 0)
		item:setScale(1)
		item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
		self.menu_reward:addChild(item)
	end
end

function PROMSuperSummonWeekCardLayer:onBtnDone(tag, pSender)
	if self.data.cur_reward.buy_times >= self.data.cur_config.buy_limit then
		ex.MessageView:add(ex.Tools:getLang(3904))
		return
	end

	if self.time_info.end_time < ex.Game:getServerTime() then
		ex.MessageView:add(ex.Tools:getLang(41053))
		return
	end

	-- 拉起支付页面
	if self.data.buy_gem_config then
		-- print(string.format("拉起购买 idx=%d, id=%s, rmb = %s", config.idx, config.id, config.rmb))
		ex.Player:pay(self.data.buy_gem_config.idx)
    end
end

return PROMSuperSummonWeekCardLayer