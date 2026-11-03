local PROMWeekendGiftLayer = class("PROMWeekendGiftLayer", require("src.layer.promotion.PromotionBaseLayer"))


function PROMWeekendGiftLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.promotion_id = 55

	-- self.data = {}

	self.node_bg:setScale(ex.s.global_scale)
	self.node_bg:setPosition(0, self.layer_promotion:getTopY() - 10)

	local start_time_array = os.date("*t", ex.Player.promotion_data.weekend_gift_data.begin_time)
	local end_time_array = os.date("*t", ex.Player.promotion_data.weekend_gift_data.end_time - 1)

	self.lbl_time:setString(string.format(ex.Tools:getLang(41306), start_time_array["year"], start_time_array["month"], start_time_array["day"],
		end_time_array["year"], end_time_array["month"], end_time_array["day"]))
	self.lbl_time_desc:setString(ex.Tools:getLang(41307))

	self.lbl_time_desc:setPositionX(self.lbl_time_desc:getPositionX() + (self.lbl_time_desc:getContentSize().width * 0.5 - self.lbl_time:getContentSize().width * 0.5) / 2)

	self.reward_nodes = {
		{
			btn = self.btn_gift_1,
			node = self.node_gift_1,
			lbl_reward = self.lbl_gift_name_1
		},
		{
			btn = self.btn_gift_2,
			node = self.node_gift_2,
			lbl_reward = self.lbl_gift_name_2
		},
		{
			btn = self.btn_gift_3,
			node = self.node_gift_3,
			lbl_reward = self.lbl_gift_name_3
		}
	}

	self.btn_gift_1:setTag(1)
	self.btn_gift_2:setTag(2)
	self.btn_gift_3:setTag(3)
	self.btn_gift_1:registerScriptTapHandler(handler(self, self.onGet))
	self.btn_gift_2:registerScriptTapHandler(handler(self, self.onGet))
	self.btn_gift_3:registerScriptTapHandler(handler(self, self.onGet))
	
	self:addEvent(EVENT.MAIN_CITY_PROMOTION.WEEDEND_GIFT_REFRESH, handler(self, self.onEventRefresh))

	self:initDone()
end

function PROMWeekendGiftLayer:onEventRefresh(event, data)
	self:initDone()
end

function PROMWeekendGiftLayer:initDone()
	-- self.data = clone(ex.Player.promotion_data.weekend_gift_data.reward_status)

	self:updateRawardShow()
end

function PROMWeekendGiftLayer:updateRawardShow()
	for i,v in pairs(cfg.weekendgift.weekendgift) do
		local ui = self.reward_nodes[v.days]

		local idx = ui.btn:getTag()
		ui.btn:removeChildByTag(999)
		if ex.Player.promotion_data:WeedendGiftGetRewardStatusByIdx(idx) == 2 then
			local spr_get = cc.Sprite:createWithSpriteFrameName("other/spr-geted.png")
			spr_get:setAnchorPoint(ex.a.center)
			spr_get:setPosition(ui.btn:getContentSize().width / 2, ui.btn:getContentSize().height / 2)
			spr_get:setTag(999)
			ui.btn:addChild(spr_get, 10)
		end

		local str = ""
		for j = 1, #v.reward do
			local item_name = ex.Tools:getLang(cfg.item.item[v.reward[j].item_type].name)
			str = str..string.format("%s*%d", item_name, v.reward[j].item_num)

			if j < #v.reward then
				str = str.."\n"
			end
		end
		ui.lbl_reward:setString(str)
	end
end

function PROMWeekendGiftLayer:onGet(tag, pSender)
	local idx = tag

	if not ex.Player.promotion_data:WeedendGiftIsOpen() then
		-- 活动时间已过
		ex.MessageView:add(ex.Tools:getLang(41310))
		return
	end

	local status = ex.Player.promotion_data:WeedendGiftGetRewardStatusByIdx(idx)
	if status == 2 then
		-- 已领取，提示
		ex.MessageView:add(ex.Tools:getLang(41308))
		return
	elseif status == 1 then
		local req = WeekendGift_pb.GReqGetReward()
		req.idx = idx
		NetManager:sendMessage(ProtocolID.GReqGetReward, req)

		ex.AudioManager:playEffect("music/item-get.mp3")
	else
		-- 不可领取，提示
		ex.MessageView:add(ex.Tools:getLang(41309))
		return
	end
end

return PROMWeekendGiftLayer