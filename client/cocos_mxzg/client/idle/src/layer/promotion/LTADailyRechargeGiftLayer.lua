local LTADailyRechargeGiftLayer = class("LTADailyRechargeGiftLayer", require("src.layer.promotion.PromotionBaseLayer"))
local LTADailyRechargeGiftCell = require("src.layer.promotion.LTADailyRechargeGiftCell")

local ExTimer = require("src.ex.ExTimer")

function LTADailyRechargeGiftLayer:onCreateDone()
    self.data_list = {}

	self:setAutoClose(false)
	self:setSwallowTouches(false)

    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(401))
    
	local sub_size = cc.size(60, 60)
    self:resetScrollView(nil, sub_size)

	self.spr_box:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width, self.scroll_view:getViewSize().height + sub_size.height))
    self.spr_box:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.5, self.scroll_view:getPositionY() - sub_size.height * 0.5))

    self.spr_bg:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width * 0.5, self.scroll_view:getViewSize().height + sub_size.height * 0.5))
    self.spr_bg:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.25, self.scroll_view:getPositionY() - sub_size.height * 0.25))

    self.lbl_time:setPositionY(self.scroll_view:getPositionY() - sub_size.height * 0.5 - 30)
    
    -- 活动刷新时间
    self.reset_time = GetTodayRemainTime()
    self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    self:updateCDTime()

    self:updateTaskView()

    -- 注册刷新事件
    self:addEvent(EVENT.DAILY_TOTAL_RECHARGE.REFRESH,handler(self,self.updateTaskView))
end

function LTADailyRechargeGiftLayer:updateCDTime()
    self.reset_time = self.reset_time - 1
    if self.reset_time <= 0 then
        self.reset_time = self.reset_time + 86400

        -- 时间到
        ex.Player.promotion_data:reqDailyTotalRechargeList()
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

function LTADailyRechargeGiftLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function LTADailyRechargeGiftLayer:updateTaskView()
    -- 准备数据
    local day = cc.exports.GetAfterDaysForTime(ex.Player.server_create_time)
    self.data_list = ex.Player.promotion_data:getDailyTotalRechargeList(day)

	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()



	local cell_size = cc.size(540, 150)
    cell_size.height = cell_size.height + 6 -- 间距6
    
    local scale = self.scroll_view:getViewSize().width / cell_size.width
    cell_size.width = cell_size.width * scale
    cell_size.height = cell_size.height * scale


	local giftLen = table.nums(self.data_list)
    local cont_height = math.max(cell_size.height * giftLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    local start = cc.p(viewSize.width * 0.5, cont_height - cell_size.height * 0.5)

    local sort = function ( a,b )
        return a.idx < b.idx
    end
    table.sort( self.data_list, sort )
    
    for i,v in ipairs(self.data_list) do
    	local cell = self:createCell(v.idx, v.reward, v.rmb)
        :setPosition(start.x, start.y - (i - 1) * cell_size.height)
        :setScale(scale)
        -- cell:setScale(self.scroll_view:getViewSize().width / (cell:getContentSize().width + 2))

    	self.scroll_view:addChild(cell)
    end
end

function LTADailyRechargeGiftLayer:createCell(idx, award_list, need)
	local cell = LTADailyRechargeGiftCell:createWithCCBIFile("ccbi/LTADailyRechargeGiftCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)

    cell:initDone(idx, need, string.format(ex.Tools:getLang(2704), need / 100))

    cell.btn_done:registerScriptTapHandler(handler(self, self.onBtnDone))
    
    local completed = ex.Player.promotion_data.daily_total_recharge_money
    
    if completed < need then
    	cell:setState(completed, 1) -- 未完成
    else
        local data = ex.Player.promotion_data:getDailyTotalRechargeData(idx)
    	if data == true then
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

function LTADailyRechargeGiftLayer:onBtnDone(tag, pSender)
    local cell = pSender:getParent():getParent()
	if cell.state == 1 then
          
        local params = {}
        params.cur_id = 102
    
		ex.JumpManager:jumpByAtom("act_recharge_smart", params)
	elseif cell.state == 2 then
		cell:onGain()

        ex.Player.promotion_data:reqDailyTotalRechargeGet(cell.idx)
        
        ex.Player.promotion_data:reqDailyTotalRechargeList()
	end
end

function LTADailyRechargeGiftLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


return LTADailyRechargeGiftLayer