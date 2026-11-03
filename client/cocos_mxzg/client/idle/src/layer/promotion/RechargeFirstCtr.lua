local RechargeFirstCtr = class("RechargeFirstCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local RechargeFirstLayer = class("RechargeFirstLayer", require("src.comp.EventLayer"))
local RechargeFirstCell = class("RechargeFirstCell", require("src.comp.EventLayer"))

local LayerType = {}
LayerType.rmb6 = 1
LayerType.rmb100 = 2

local GiftType = {
	NotBuy = 1,		-- 未购买
	CanGet = 2,		-- 可领取
	Got = 3,		-- 已领取
}

function RechargeFirstCell:onCreate()
	self:setAutoClose(false)
end

function RechargeFirstCell:setAwardByDay(config, day)
	local award = {}
	-- if day == 1 then
	-- 	award = config.day_one
	-- elseif day == 2 then
	-- 	award = config.day_two
	-- elseif day == 3 then
	-- 	award = config.day_three
	-- end
	if not config then return end 
	award = config.reward

	self.menu = cpp.UIMenu:create()
	self.menu:setPosition(0, 0)
	self:addChild(self.menu)

	local item_size = cc.Sprite:createWithSpriteFrameName("promotion/item-bg-1.png"):getContentSize()

	for i,v in ipairs(award) do
		local btn = ex.Player.backpack_data:createWithData(v.item_type, v.item_num, "promotion/item-bg-1.png")
		btn:setPosition(45 + (i - 1) * 90, 85)
		btn:registerScriptTapHandler(handler(self, self.onBtnInfo))
		self.menu:addChild(btn)

		-- if btn.tag == ItemData.IT_EQUIP then 
			btn:setScaleX(item_size.width / btn:getContentSize().width)
			btn:setScaleY(item_size.height / btn:getContentSize().height)
		-- end
	end

	-- 第%d天免费领
	self.lbl_day:setString(string.format(ex.Tools:getLang(2723), day))
end



function RechargeFirstCell:setGray(bool)
	local items = self.menu:getChildren()
	for k,v in pairs(items) do
		v:setAllGray(bool)
	end
end



---------------------------------------------------------------------------------

function RechargeFirstLayer:onCreate()
	self:addBlackBackground()

	self.btn_rmb6:setLabelText(ex.Tools:getLang(5193))
	self.btn_rmb100:setLabelText(ex.Tools:getLang(5193))
	-- self.spr_light:setLocalZOrder(100)

	self.award_menu = cpp.UIMenu:create()
	self.award_menu:setPosition(0, 0)
	self:addChild(self.award_menu)
end

function RechargeFirstLayer:onExit()
    -- 超值首充 红点
    local reddot_manager = ex.RedDotManager
    reddot_manager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCZSC,
        ex.Player.promotion_data:hasRechargeFirstAward())

    --reddot_manager:setSpecialVisible(RedDotType.ZCJ_DHZC_ZCCZSC, true)
	-- ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.RECHARGE_FIRST,"act_recharge_first")
	ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_recharge_first")
end

function RechargeFirstLayer:updateLayer(cur_type)
	self.award_menu:removeAllChildren()
	
	local gift_type = GiftType.NotBuy
	if not ex.Player.promotion_data:isBoughtRechargeFirstForType(cur_type) then
		gift_type = GiftType.NotBuy
	elseif ex.Player.promotion_data:hasRechargeFirstAward(cur_type) then
		gift_type = GiftType.CanGet -- 可领取
	else
		gift_type = GiftType.Got 	-- 已领取
	end

	-- ex.Tools:setSpriteFrame(self.spr_gem, string.format("prom-recharge-first/spr-tip-%d.png", tonumber(cur_type)))
	self.spr_bg_1:setVisible(cur_type == LayerType.rmb6)
	self.spr_bg_2:setVisible(cur_type == LayerType.rmb100)

	self.btn_done:setEnabled(gift_type ~= GiftType.Got)
	self.btn_done:setTag(gift_type)
	self.btn_done:setNormalImage(cc.Sprite:createWithSpriteFrameName(string.format("prom-recharge-first-lang/btn-recharge-%d.png", gift_type)))
	self.btn_done:setSelectedImage(cc.Sprite:createWithSpriteFrameName(string.format("prom-recharge-first-lang/btn-recharge-%d.png", gift_type)))

	local data = ex.Player.promotion_data:getRechargeFirstType(cur_type)

	for i=1, #data do
		for j=1, 2 do
			local btn = ex.Player.backpack_data:createWithData(data[i].reward[j].item_type, data[i].reward[j].item_num)
			btn:setPosition(self["node_reward_"..i.."_"..j]:getPosition())
			btn:setScale(0.7)
			btn:registerScriptTapHandler(handler(self, self.onBtnInfo))
			self.award_menu:addChild(btn)

			btn:setAllGray(data[i].is_obtain == 1)
		end
	end
end

function RechargeFirstLayer:onBtnInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

---------------------------------------------------------------------------------

function RechargeFirstCtr:onCreate()
	self:setCCBIPath("ccbi/RechargeFirstLayer.ccbi")
	self:setIsSingle(false)
	
	self.event_data = nil
	self.cur_layer_type = LayerType.rmb6
end

function RechargeFirstCtr:getLayerClass()
	return RechargeFirstLayer
end

function RechargeFirstCtr:openWindow(layer_type)
	if self:isOpened() then
		return
	end

	self.cur_layer_type = (layer_type ~= nil and tonumber(layer_type) ~= 0) and tonumber(layer_type) or LayerType.rmb6
	self.event_data = ex.EventManager:add(EVENT.MAIN_CITY_RECHARGE.RECHARGE_FIRST, handler(self, self.refreshForce))

	self:loadLayer()
	self:open()
	self:initDone()
end

function RechargeFirstCtr:closeWindow()
	if self.event_data ~= nil then
		ex.EventManager:remove(self.event_data)
	end
	self.event_data = nil

	self:close(nil, self.layer)
end

function RechargeFirstCtr:initDone()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
	self.layer.btn_rmb6:setTag(LayerType.rmb6)
    self.layer.btn_rmb6:registerScriptTapHandler(handler(self, self.onBtnChangeLayer))

    self.layer.btn_rmb100:setTag(LayerType.rmb100)
    self.layer.btn_rmb100:registerScriptTapHandler(handler(self, self.onBtnChangeLayer))

    self.layer.btn_done:registerScriptTapHandler(handler(self, self.onBtnDone))

    self:changeLayer(self.cur_layer_type, true)
end

function RechargeFirstCtr:refreshForce()
	if not self:isOpened() then
		return
	end

	self:changeLayer(self.cur_layer_type or LayerType.rmb6, true)
end

function RechargeFirstCtr:changeLayer(cur_type, is_force)
	self.layer.btn_rmb6:setChecked(LayerType.rmb6 == cur_type)
    self.layer.btn_rmb100:setChecked(LayerType.rmb100 == cur_type)

	if not is_force and self.cur_layer_type == cur_type then
		return
	end

	-- ex.Tools:addRedPoint(self.layer.btn_rmb6, LayerType.rmb100 == cur_type and 
	-- 	ex.Player.promotion_data:hasRechargeFirstAward(LayerType.rmb6))

	-- ex.Tools:addRedPoint(self.layer.btn_rmb100, LayerType.rmb6 == cur_type and 
	-- 	ex.Player.promotion_data:hasRechargeFirstAward(LayerType.rmb100))

	ex.Tools:addRedPoint(self.layer.btn_rmb6, ex.Player.promotion_data:hasRechargeFirstAward(LayerType.rmb6), ex.r.p9)

	ex.Tools:addRedPoint(self.layer.btn_rmb100,ex.Player.promotion_data:hasRechargeFirstAward(LayerType.rmb100), ex.r.p9)

	self.cur_layer_type = cur_type

	self.layer:updateLayer(cur_type)
end

function RechargeFirstCtr:onBtnChangeLayer(tag, pSender)
	self:changeLayer(tag)
end

function RechargeFirstCtr:onBtnDone(tag, pSender)
	if tag == 1 then
		-- 转跳每日礼包
		ex.JumpManager:jumpByAtom("act_recharge_smart")
		self:closeWindow()
	elseif tag == 2 then
		-- 获取超值奖励协议
		local req = FirstRecharge_pb.GReqFirstRechargeReward()
		req.idx = self.cur_layer_type
		NetManager:sendMessage(ProtocolID.GReqFirstRechargeReward, req)
	end
end


return RechargeFirstCtr
