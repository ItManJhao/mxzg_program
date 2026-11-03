local BuyGoldCtr = class("BuyGoldCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BuyGoldLayer = class("BuyGoldLayer", require("src.comp.EventLayerAdaptiveWidth"))

function BuyGoldLayer:onCreate()
	self:addBlackBackground()

	self.send_time = 0;

	local scheduler = cc.Director:getInstance():getScheduler()
	self.scheduler_id = scheduler:scheduleScriptFunc(handler(self, self.updateLayer), 1, false)
	self:updateLayer()

	self:addEvent(EVENT.BATTLE_EVENT.BATTLE_END, function(  )
		BuyGoldCtr:instance():updateLayer()
	end)
	
	self:addRedDotNode(RedDotType.ZCJ_DJ_MFDJ, self.btn_gold1)
end

function BuyGoldLayer:updateLayer()
	local now_time = ex.Game:getServerTime()
	-- local time_diff = (ex.Player.shop_data.buy_gold_time + time_loop) - now_time
	local time_diff = (ex.Player.shop_data.buy_gold_time) - now_time
	if time_diff < 0 then
		-- 应该要刷新界面了
		if  math.abs(now_time - self.send_time) > 1 then
			-- 点金
			-- local req_buy_gold = ProtocolRequest.ReqBuyGoldLog
			-- NetManager:sendLuaData(req_buy_gold)
			NetManager:sendMessage(ProtocolID.GReqBuyGoldLog)

			self.send_time = now_time
		end
	end

	self.lbl_time:setString(ex.StringUtil.convertToTimeFormat(math.max(time_diff, 1)))
end

function BuyGoldLayer:onExit()
	if self.scheduler_id then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
		self.scheduler_id = nil
	end
end

-----------------------------------------------------------------------------
function BuyGoldCtr:onCreate()
	self:setCCBIPath("ccbi/BuyGoldLayer.ccbi")
	self:setIsSingle(false)
end

function BuyGoldCtr:getLayerClass()
	return BuyGoldLayer
end

function BuyGoldCtr:getBuyGoldLayer()
	return self.layer
end

function BuyGoldCtr:openWindow()
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData()
end

function BuyGoldCtr:initData()
	-- 请求刷新点金数据
	-- local req_buy_gold = ProtocolRequest.ReqBuyGoldLog
	-- NetManager:sendLuaData(req_buy_gold)
	NetManager:sendMessage(ProtocolID.GReqBuyGoldLog)

	self.layer.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
	
    self.layer.btn_gold1:registerScriptTapHandler(handler(self, self.onBuy))
    self.layer.btn_gold2:registerScriptTapHandler(handler(self, self.onBuy))
    self.layer.btn_gold3:registerScriptTapHandler(handler(self, self.onBuy))

	-- ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DJ_MFDJ, is_visible)

	self:updateLayer()
end

function BuyGoldCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	local layer = self.layer
	local config = cfg.buygold.buygold[math.max(1, ex.Player.chapter_data.chapter_id)]
	if config == nil then
		return
	end

	-- dump(config)
	-- print("ex.Player.shop_data.buy_gold_status", ex.Player.shop_data.buy_gold_status)

	for i = 1, 3 do
		local config_cost = cfg.buygoldcost.buygoldcost[i]
		local num = ex.Player.shop_data:getBuyGoldNum(config_cost.type)
		local key = ex.Player.shop_data.buy_gold_status ~= 0 and "promotion_limit" or "limit"
		local is_visible = num < config_cost[key]

		layer["btn_gold"..i].data = config_cost
		-- layer["lbl_gold"..i]:setVisible(is_visible)

		layer["btn_gold"..i]:setVisible(is_visible)
		if layer["spr_gem"..i] then
			layer["spr_gem"..i]:setVisible(is_visible)
		end

		if layer["lbl_get_text"..i] then
			layer["lbl_get_text"..i]:setVisible(is_visible)
		end

		if layer["lbl_gem"..i] then
			if config_cost.prize ~= 0 then
				layer["lbl_gem"..i]:setString(tostring(config_cost.prize))
			end
			
			layer["lbl_gem"..i]:setVisible(is_visible)
		end

		-- 有贵族加成
		local vip_bonus = 100 -- 100 + cfg.vip.vip[ex.Player.vip_level].buy_gold_bonus
		-- layer["lbl_gold"..i]:setString(config["gold_"..i] * vip_bonus / 100)
		layer["lbl_gold"..i]:setString(config["gold_"..i] * vip_bonus / 100)
		layer["lbl_left"..i]:setString(ex.Tools:getLang(47201) .. tostring(config_cost[key] - num))
	end
end

function BuyGoldCtr:onBuy(tag, pSender)
	local num = ex.Player.shop_data:getBuyGoldNum(pSender.data.type)
	local key = ex.Player.shop_data.buy_gold_status ~= 0 and "promotion_limit" or "limit"
	if num >= pSender.data[key] then
		ex.MessageView:add(ex.Tools:getLang(47738))
		self:updateLayer()
		return 
	end

	if ex.Player.gem < pSender.data.prize then
		ex.MessageView:add(ex.Tools:getLang(47428))
		return
	end

	-- local req_buy = ProtocolRequest.ReqBuyGoldBuy
	-- req_buy.idx.value = pSender.data.type
	-- NetManager:sendLuaData(req_buy)

	local req_buy = BugGold_pb.GReqBuyGold()
	req_buy.idx = pSender.data.type
    NetManager:sendMessage(ProtocolID.GReqBuyGold, req_buy)
    

	ex.Player.shop_data:addBuyGoldNum(pSender.data.type, 1)

	self:updateLayer()
end

	-- local config = cfg.buygold.buygold[data.idx]
	-- ex.Player:addGem(-config.gem)

return BuyGoldCtr
