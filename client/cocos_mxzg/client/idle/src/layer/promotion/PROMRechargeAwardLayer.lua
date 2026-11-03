local PROMRechargeAwardLayer = class("PROMRechargeAwardLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMRechargeAwardCell = require("src.layer.promotion.PROMRechargeAwardCell")

local ExTimer = require("src.ex.ExTimer")

function PROMRechargeAwardLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
    
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(7))

    local sub_size = cc.size(60, 60)
    self:resetScrollView(nil, sub_size)

	self.spr_box:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width, self.scroll_view:getViewSize().height + sub_size.height))
    self.spr_box:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.5, self.scroll_view:getPositionY() - sub_size.height * 0.5))

    self.spr_bg:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width * 0.5, self.scroll_view:getViewSize().height + sub_size.height * 0.5))
    self.spr_bg:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.25, self.scroll_view:getPositionY() - sub_size.height * 0.25))

	self.lbl_time:setPositionY(self.scroll_view:getPositionY() - sub_size.height * 0.5 - 30)
	
    -- 活动刷新时间
    self.reset_time = GetWeekResetTime()
    self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    self:updateCDTime()

    self:updateTaskView()

end

function PROMRechargeAwardLayer:updateCDTime()
    self.reset_time = self.reset_time - 1
    if self.reset_time <= 0 then
        self.reset_time = self.reset_time + 86400 * 7

        -- 时间到
        -- 周累计充值
        ex.Player.promotion_data:reqRechargeWeek()
    end

    if self.reset_time > 86400 then
        -- 大于1天
        -- 剩余时间：%d天
        self.lbl_time:setString(string.format(ex.Tools:getLang(48011),
            math.floor(self.reset_time / 86400)))
        -- self.lbl_time:setString(string.format(ex.Tools:getLang(47454), 
        --  math.floor(self.reset_time / 86400),
     --     math.floor(self.reset_time / 3600 % 24),
     --     math.floor(self.reset_time / 60 % 60),
     --     math.floor(self.reset_time % 60)))
    else
        -- 剩余时间：%d小时%d分%d秒
        self.lbl_time:setString(string.format(ex.Tools:getLang(48010), 
            math.floor(self.reset_time / 3600),
            math.floor(self.reset_time / 60 % 60),
            math.floor(self.reset_time % 60)))
    end
end

function PROMRechargeAwardLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function PROMRechargeAwardLayer:updateTaskView()
	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()

	local cell_size = cc.size(540, 155)
	cell_size.height = cell_size.height + 6

	local giftLen = table.nums(cfg.promotionweeklytotalrecharge.week)
    local cont_height = math.max(cell_size.height * giftLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    cont_height = cont_height - cell_size.height * 0.5

    local start = cc.p(viewSize.width * 0.5, cont_height)

    for i,v in ipairs(cfg.promotionweeklytotalrecharge.week) do
    	local cell = self:createCell(v.idx, v.item, v.rmb)
    	:setPosition(start.x, start.y - (i - 1) * cell_size.height)
    	self.scroll_view:addChild(cell)
    end
end

function PROMRechargeAwardLayer:createCell(idx, award_list, need)
	local cell = PROMRechargeAwardCell:createWithCCBIFile("ccbi/PROMRechargeAwardCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)

    local scale = self.scroll_view:getViewSize().width / cell:getContentSize().width
	cell:setScale(scale)

    cell:initDone(idx, need, string.format(ex.Tools:getLang(2704), need / 100))

    cell.btn_done:registerScriptTapHandler(handler(self, self.onBtnDone))

    local completed = ex.Player.promotion_data.recharge_week.completed

    if completed < need then
    	cell:setState(completed, 1) -- 未完成
    else
    	if ex.Player.promotion_data:getRechargeWeekIsAward(idx) then
    		cell:setState(need, 3) -- 已领
    	else
    		cell:setState(need, 2) -- 可领取
    	end
    end

    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    cell:addChild(menu)

    local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local start = cc.p(-20, cell.btn_done:getPositionY())

    for i,v in ipairs(award_list) do
    	local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item:setPosition(start.x + goods_size.width * i, start.y)
        item:setScale(0.75)
        item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        menu:addChild(item)
    end

    return cell
end

function PROMRechargeAwardLayer:onBtnDone(tag, pSender)
    local cell = pSender:getParent():getParent()
	if cell.state == 1 then
		  ex.MainSceneCtr:changeToRechargePage()
	elseif cell.state == 2 then
		cell:onGain()

        -- 发送领取协议
        local req_reward = Promotion_pb.GReqPromotionReward()
        req_reward.type = 3     --4月卡 5至尊月卡
        req_reward.index = cell.idx -- 已领天数
        NetManager:sendMessage(ProtocolID.GReqPromotionReward, req_reward)
	end
end

function PROMRechargeAwardLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


return PROMRechargeAwardLayer