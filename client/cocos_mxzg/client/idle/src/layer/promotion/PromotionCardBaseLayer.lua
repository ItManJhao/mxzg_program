local PromotionCardBaseLayer = class("PromotionCardBaseLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMMonthCardCell = class("PROMMonthCardCell", require("src.comp.EventLayer"))

function PROMMonthCardCell:onCreate()
	self:setAutoClose(false)

end


function PROMMonthCardCell:initDone(item_type, item_num, gain_days, over_time)
	self.gain_days = gain_days

	local size = self:getContentSize()

	local node = ex.Player.backpack_data:createWithData(item_type, item_num)
	node:setScale(0.7)
	node:setPosition(100, size.height / 2 + 10)
	node:registerScriptTapHandler(handler(self, self.onBtnInfo))
	self.btn_done:getParent():addChild(node)

	self.lbl_desc = cpp.RichTextEx:createWithXMLLua("")
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFFFFF")
	:setScale(0.5)
	:setAnchorTextShadow(true)
	:ignoreContentAdaptWithSize(false)
	:setWrapMode(1)
	:setContentSize(self:getContentSize().width, 20)
	:setPosition(self.lbl_time:getPositionX(), size.height - self.lbl_time:getPositionY() + 10)
	:setAnchorPoint(ex.a.left_center)
	self:addChild(self.lbl_desc)

	self.lbl_desc:setXmlTextLua(string.format(ex.Tools:getLang(2720), gain_days))

	local t_month = os.date("%m", over_time)
	local t_day = os.date("%d", over_time)
	self.lbl_time:setString(string.format(ex.Tools:getLang(2721), tonumber(t_month), tonumber(t_day)))
end

function PROMMonthCardCell:resetCentent( gain_days )
	self.lbl_desc:setXmlTextLua(string.format(ex.Tools:getLang(2720), gain_days))
end

function PROMMonthCardCell:setState(is_gain)
	local btn_size = self.btn_done:getContentSize()

	local lbl_btn_txt = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
	:setPosition(btn_size.width / 2, btn_size.height / 2)
	self.btn_done:addChild(lbl_btn_txt, 10, 10)

	if is_gain then
		self.btn_done:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-big-2.png"))
		lbl_btn_txt:setString(ex.Tools:getLang(2703)) -- 已领取
		lbl_btn_txt:enableOutline(FONT_GRAY, 2)
	else
		lbl_btn_txt:setString(ex.Tools:getLang(2214)) -- 领取
		lbl_btn_txt:enableOutline(FONT_RED, 2)
	end

	self.btn_done:setEnabled(not is_gain)
end

function PROMMonthCardCell:onGain()
	self.btn_done:getChildByTag(10):removeFromParent()
	self.btn_done:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-big-2.png"))
	self.btn_done:setEnabled(false)

	local btn_size = self.btn_done:getContentSize()

	-- 已领取
	local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(2703), FONT_DEFAULT_NAME_BOLD, 20)
	:enableOutline(FONT_GRAY, 2)
	:setPosition(btn_size.width / 2, btn_size.height / 2)
	self.btn_done:addChild(lbl_btn_txt, 10)
end

function PROMMonthCardCell:onBtnInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

---------------------------------------------------------------------------------------

function PromotionCardBaseLayer:addCompletedNode(completed, need)
	local pos = cc.p(self.spr_card:getPositionX(), self.spr_card:getPositionY() - 210)
	pos.y = pos.y - 20
	-- 进度条背景
	local spr_bg = cc.Sprite:createWithSpriteFrameName("promotion/prog-vip-bg.png")
	:setPosition(pos)
	self:addChild(spr_bg)
	-- 进度条
    local progressTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("promotion/prog-vip-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setPosition(pos)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self:addChild(progressTimer)

	pos.y = pos.y - 40
    -- 当前充值：%d/%d
    local lbl_completed = cc.Label:createWithTTF(string.format(ex.Tools:getLang(2716), completed / 100, need / 100), FONT_DEFAULT_NAME_BOLD, 20)
	:setPosition(pos)
	:enableOutline(cc.BLACK, 1)
	self:addChild(lbl_completed)

	if completed < need then
   		progressTimer:setPercentage(100.0 * completed / need)
   	else
   		progressTimer:setPercentage(100.0)
   	end

	pos.y = pos.y - 60

	local menu = cpp.UIMenu:create()
    menu:setPosition(cc.p(0, 0))
    self:addChild(menu)

    local btn_done = cpp.UIMenuItemImage:createWithSpriteFrameName("button/btn-blue-1.png", nil, nil)
    btn_done:setPosition(pos.x, pos.y)
    :registerScriptTapHandler(handler(self, self.onBtnDone))
    menu:addChild(btn_done)
     -- 充值激活
    local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(2714), FONT_DEFAULT_NAME_BOLD, 26)
   	:enableOutline(FONT_DARK_BLUE, 2)
   	:setPosition(btn_done:getContentSize().width / 2, btn_done:getContentSize().height / 2)
   	btn_done:addChild(lbl_btn_txt)
end

function PromotionCardBaseLayer:addGainCell(item_type, item_num, gain_days, over_time, is_gain)
	self.cell = PROMMonthCardCell:createWithCCBIFile("ccbi/PROMMonthCardCell.ccbi")
	self.cell:setSwallowTouches(false)
	self.cell:setIgnoreAnchorPointForPosition(false)
    self.cell:setAnchorPoint(ex.a.center)

    self.cell.btn_done:registerScriptTapHandler(handler(self, self.onBtnGain))

    self.cell:initDone(item_type, item_num, gain_days, over_time)
    self.cell:setState(is_gain)

    self.cell:setPosition(self.spr_card:getPositionX(),
    	self.spr_card:getPositionY() - 210 - self.cell:getContentSize().height * 0.6)

    self:addChild(self.cell)
end


function PromotionCardBaseLayer:updateDays(event,data)
	-- 充值6元后。 从在线奖励跳转过来时。会报错。  self.cell还没创建
	-- 有点疑问。月卡没激活，会调用当前函数。月卡激活了，反而不会调用。当前函数貌似是刷新领取天数？
	if self.cell == nil then
		return
	end

	local card_data = ex.Player.promotion_data:getMonthCardData(self.card_type)
	self.cell:resetCentent(card_data.gain_days)
end

function PromotionCardBaseLayer:onBtnDone(tag, pSender)
	
	local card_id = self.card_type
	local params = {}
	params.cur_id = 102
	params.backToLayer =  function ( layer )
		local 	select_index = 0
		if card_id == 1 then 
			select_index = 2
		else 
			select_index = 3
		end 

		local vec_idx = ex.Player.promotion_data:getPromotionByType(RechargeKindType.PROMOTION)
		layer:initWithTable(nil, vec_idx, 0)
		local items = layer.menu:getChildren()
		local cell 
		for k,v in pairs(items) do
			if v.idx == select_index then 
				cell = v 
			end
		end

		if not cell then return end
		layer:onSelect(cell:getTag(), cell)
	end

	ex.JumpManager:jumpByAtom("act_recharge_smart")
	-- ex.MainSceneCtr:changeToRechargePage(params)
	-- ex.MainSceneCtr:changeToRechargePage()
end

function PromotionCardBaseLayer:onBtnGain(tag, pSender)
	local cell = pSender:getParent():getParent()
	cell:onGain()

	local value = 0
	if self.card_type == 1 then
		value = 4
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_YK, false)
	elseif self.card_type == 2 then
		value = 5
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_ZZYK, false)
	end
	
	-- 发送领取协议
	local req_reward = Task1_pb.GReqMonthCardReward()
	-- req_reward.type = value --4月卡 5至尊月卡
	-- req_reward.index = cell.gain_days -- 已领天数
	req_reward.idx = self.card_type
	NetManager:sendMessage(ProtocolID.GReqMonthCardReward, req_reward)

	-- 设置数据
	ex.Player.promotion_data:gainMonthCard(self.card_type)

	--local card_data = ex.Player.promotion_data:getMonthCardData(self.card_type)
	--cell:resetCentent(card_data.gain_days)

	-- 发送协议
	ex.Player.promotion_data:reqMonthCard()


end

return PromotionCardBaseLayer