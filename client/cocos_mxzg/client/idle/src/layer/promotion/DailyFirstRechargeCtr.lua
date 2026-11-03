local DailyFirstRechargeCtr = class("DailyFirstRechargeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local DailyFirstRechargeLayer = class("DailyFirstRechargeLayer", require("src.comp.EventLayer"))

local DFRGiftType = {
	Gift_One = 1,	-- 18元礼包
	Gift_Two = 2,	-- 68元礼包
	Gift_Three = 3,	-- 6元礼包
}

function DailyFirstRechargeLayer:onCreate()
	self:addBlackBackground()

	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/lang-1.plist")
	
	self.promotion_id = 21

	local bg_size = self.spr_bg:getContentSize()
	-- self.spr_bg:setScaleX(ex.p.width / bg_size.width)

	local spr_close = cc.Sprite:createWithSpriteFrameName("lang-1/close-tips.png")
	:setPosition(self:getContentSize().width / 2, -35)
	self:addChild(spr_close)

	self.btn_gift_1:setLabelText(ex.Tools:getLang(41182))
	self.btn_gift_2:setLabelText(ex.Tools:getLang(41183))
	self.btn_gift_2:getLabel():setScaleX(-self.btn_gift_2:getLabel():getScaleX())
	self.btn_gift_3:setLabelText(ex.Tools:getLang(41318))

	self.menu:setLocalZOrder(10)

	self.item_menu = cpp.UIMenu:create()
    self.item_menu:setSwallowsTouches(false)
	self.item_menu:setPosition(cc.p(0, 0))
	self.item_menu:setLocalZOrder(10)
	self:addChild(self.item_menu)
	

	self.lbl_content1 = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(36)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FBFB96")
	-- :setScale(0.5)
	:setAnchorTextShadow(true)
	:setPosition(cc.p(320.0, 336.0))
	:setAnchorPoint(cc.p(0.5, 0.5))
	self:addChild(self.lbl_content1)


	self.lbl_content2 = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(28)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FBFB96")
	-- :setScale(0.5)
	:setAnchorTextShadow(true)
	:setPosition(cc.p(320.0, 292.0))
	:setAnchorPoint(cc.p(0.5, 0.5))
	self:addChild(self.lbl_content2)



end

function DailyFirstRechargeLayer:onExit()
	ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_day_first_recharge")
end

function DailyFirstRechargeLayer:switchTabBar(gift_type)
	self.btn_gift_1:setChecked(gift_type == DFRGiftType.Gift_One)
	self.btn_gift_2:setChecked(gift_type == DFRGiftType.Gift_Two)
	self.btn_gift_3:setChecked(gift_type == DFRGiftType.Gift_Three)

	local need = ex.Player.promotion_data:getDailyFirstRechargeNeedGem(DFRGiftType.Gift_One)
	local data = ex.Player.promotion_data:getDailyFirstRechargeDataByType(DFRGiftType.Gift_One)
	ex.Tools:addRedPoint(self.btn_gift_1, need <= 0 and data ~= nil and data.status == 0, ex.r.p9_1)

	need = ex.Player.promotion_data:getDailyFirstRechargeNeedGem(DFRGiftType.Gift_Two)
	data = ex.Player.promotion_data:getDailyFirstRechargeDataByType(DFRGiftType.Gift_Two)
	ex.Tools:addRedPoint(self.btn_gift_2, need <= 0 and data ~= nil and data.status == 0, cc.p(0.1, 0.9))

	need = ex.Player.promotion_data:getDailyFirstRechargeNeedGem(DFRGiftType.Gift_Three)
	data = ex.Player.promotion_data:getDailyFirstRechargeDataByType(DFRGiftType.Gift_Three)
	ex.Tools:addRedPoint(self.btn_gift_3, need <= 0 and data ~= nil and data.status == 0, ex.r.p9_1)
end

function DailyFirstRechargeLayer:refresh(gift_type)
	self:switchTabBar(gift_type)

	local turns = ex.Player.promotion_data:getPromotionTurns(self.promotion_id)
	local config = cfg.promotiondailyfirstrecharge.getConfigByTurnsAndType(turns, gift_type)
	
	-- 奖品
	if config ~= nil then
		self:setAward(config.item)
	end

	self:updateCompleted(gift_type)
end

function DailyFirstRechargeLayer:updateCompleted(gift_type)
	local need = ex.Player.promotion_data:getDailyFirstRechargeNeedMoney(gift_type)
	local data = ex.Player.promotion_data:getDailyFirstRechargeDataByType(gift_type)
	if need <= 0 then
		need = 0
		self:setBtnTxt("daily-first-recharge-lang/spr-txt-4.png", 0, data ~= nil and data.status == 0)
	else
		self:setBtnTxt("daily-first-recharge-lang/spr-txt-3.png", 1)
	end

	self.lbl_content1:setXmlTextLua(string.format(ex.Tools:getLang(41350), need / 100))
	self.lbl_content2:setXmlTextLua(string.format(ex.Tools:getLang(41351), need / 100))


	-- 需要充值
	-- print("v.item_num11", need)
	-- self.lbl_num:setString(tostring(need))
end

function DailyFirstRechargeLayer:setBtnTxt(path, tag, is_active)
	if is_active == nil then is_active = true end

	local btn_size = self.btn_done:getContentSize()

	local spr_btn_txt = self.btn_done:getChildByTag(100)
	if spr_btn_txt then
		spr_btn_txt:removeFromParent()
		spr_btn_txt = nil
	end

	spr_btn_txt = cc.Sprite:createWithSpriteFrameName(path)
	spr_btn_txt:setPosition(btn_size.width / 2, btn_size.height / 2 + 2)
	self.btn_done:addChild(spr_btn_txt, 10, 100)

	self.btn_done:setTag(tag)

	ex.Tools:setAllGrayAuto(self.btn_done, not is_active)
	self.btn_done:setEnabled(is_active)
end

function DailyFirstRechargeLayer:setAward(award_list)
	self.item_menu:removeAllChildren()
	local awardLen = table.nums(award_list)

	local tmp_pos = nil
	for i,v in ipairs(award_list) do
		tmp_pos = self["reward_bg_"..tostring(i)]

		local btn = cpp.UIMenuItemImage:createWithSpriteFrameName(string.format("backpack/%d.png", v.item_type), nil, nil)
		btn:setPosition(tmp_pos:getPosition())
		btn:registerScriptTapHandler(handler(self, self.onBtnInfo))
		self.item_menu:addChild(btn)

		btn:setTag(v.item_type)

		-- num
		local lbl_num = cc.Label:createWithTTF(ex.StringUtil.getScientificNumber(v.item_num), FONT_DEFAULT_NAME_BOLD, 40)
		lbl_num:setScale(0.5)
		lbl_num:setAnchorPoint(ex.a.right_center)
		lbl_num:enableOutline(FONT_BLACK, 2)
		lbl_num:setPosition(tmp_pos:getContentSize().width - 15, 13)
		btn:addChild(lbl_num)
	end
end

function DailyFirstRechargeLayer:onBtnInfo(tag, pSender)
	ex.Tools:onClickItemInfo(tag)
end

------------------------------------------------------

function DailyFirstRechargeCtr:onCreate()
	self:setCCBIPath("ccbi/DailyFirstRechargeLayer.ccbi")
	self:setIsSingle(false)

	self.gift_type = DFRGiftType.Gift_One
end

function DailyFirstRechargeCtr:getLayerClass()
	return DailyFirstRechargeLayer
end

function DailyFirstRechargeCtr:openWindow(gift_type)
	if self:isOpened() then
		return
	end

	ex.EventManager:add(EVENT.MAIN_CITY_RECHARGE.DAILY_FIRST_RECHARGE, handler(self, self.onEventShow))

	self.gift_type = (gift_type ~= nil and tonumber(gift_type) ~= 0) and tonumber(gift_type) or DFRGiftType.Gift_Three

	-- 判断档位领取
	local is_reward_all = function(gift_type)
		local data = ex.Player.promotion_data:getDailyFirstRechargeDataByType(gift_type)
		return data ~= nil and data.status == 1
	end

	self.gift_type = is_reward_all(DFRGiftType.Gift_Three) and DFRGiftType.Gift_One or DFRGiftType.Gift_Three
	if self.gift_type == DFRGiftType.Gift_One then self.gift_type = is_reward_all(DFRGiftType.Gift_One) == false and DFRGiftType.Gift_One or DFRGiftType.Gift_Two end
	if self.gift_type == DFRGiftType.Gift_Two then self.gift_type = is_reward_all(DFRGiftType.Gift_Two) == false and DFRGiftType.Gift_Two or DFRGiftType.Gift_Three end




	self:loadLayer()
	self:open()
	self:show(self.gift_type)

	self.layer.btn_done:registerScriptTapHandler(handler(self, self.onBtnDone))
	self.layer.btn_gift_1:registerScriptTapHandler(handler(self, self.onBtnDone))
	self.layer.btn_gift_2:registerScriptTapHandler(handler(self, self.onBtnDone))
	self.layer.btn_gift_3:registerScriptTapHandler(handler(self, self.onBtnDone))
end

function DailyFirstRechargeCtr:onEventShow(event, data)
	if not self:isOpened() then
		return
	end
	
	self.gift_type = self.gift_type or DFRGiftType.Gift_One

	self:show(self.gift_type)
end

function DailyFirstRechargeCtr:show(gift_type)
	self.gift_type = gift_type or self.gift_type

	self.layer:refresh(self.gift_type)
end

function DailyFirstRechargeCtr:onBtnDone(tag, pSender)
	if pSender == self.layer.btn_done then
		--print("onBtnDone..tag = "..tag)
		if tag == 1 then
			ex.JumpManager:jumpByAtom("act_recharge_smart", {})

			self:closeWindow(nil, self.layer)
		else
			-- 发送领奖协议
			local req = Promotion021_pb.GReqDailyChargeReward()
			req.type = self.gift_type
			NetManager:sendMessage(ProtocolID.GReqDailyChargeReward, req)
		end
	elseif pSender == self.layer.btn_gift_1 then
		self:show(DFRGiftType.Gift_One)
	elseif pSender == self.layer.btn_gift_2 then
		self:show(DFRGiftType.Gift_Two)
	elseif pSender == self.layer.btn_gift_3 then
		self:show(DFRGiftType.Gift_Three)
	end
end


return DailyFirstRechargeCtr
