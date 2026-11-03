--[[
    func: 98元累充奖励
    author:徐东浩
    time:2020-05-08 21:09:19
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local PROMRechargeAward2Layer = class("PROMRechargeAward2Layer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMRechargeAward2Cell = require("src.layer.promotion.PROMRechargeAwardCell")

function PROMRechargeAward2Layer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
    
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(8))

    local sub_size = cc.size(60, 60)
    self:resetScrollView(nil, sub_size)

	self.spr_box:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width, self.scroll_view:getViewSize().height + sub_size.height))
    self.spr_box:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.5, self.scroll_view:getPositionY() - sub_size.height * 0.5))

    self.spr_bg:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width * 0.5, self.scroll_view:getViewSize().height + sub_size.height * 0.5))
    self.spr_bg:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.25, self.scroll_view:getPositionY() - sub_size.height * 0.25))

    self:updateTaskView()
end

function PROMRechargeAward2Layer:updateTaskView()
	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()

	local cell_size = cc.size(540, 155)
	cell_size.height = cell_size.height + 6

	local giftLen = table.nums(ex.Player.promotion_data.recharge_reward.data)
    local cont_height = math.max(cell_size.height * giftLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    cont_height = cont_height - cell_size.height * 0.5

    local start = cc.p(viewSize.width * 0.5, cont_height)

    local need = ex.Tools:getSysCfg("higher_recharge_days_at_least_rmb")

    local sort= function ( a,b )
        if a.has_reward ~= b.has_reward then 
            return a.has_reward < b.has_reward
        else 
            return a.day < b.day
        end 
    end
    table.sort( ex.Player.promotion_data.recharge_reward.data , sort)

    for i,v in ipairs(ex.Player.promotion_data.recharge_reward.data) do
    	local cell = self:createCell(v, need)
    	:setPosition(start.x, start.y - (i - 1) * cell_size.height)
    	self.scroll_view:addChild(cell)
    end
end

function PROMRechargeAward2Layer:createCell(item_data, need)
	local cell = PROMRechargeAward2Cell:createWithCCBIFile("ccbi/PROMRechargeAward2Cell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)

    local scale = self.scroll_view:getViewSize().width / cell:getContentSize().width
	cell:setScale(scale)

    cell:initDone(item_data.day, need, string.format(ex.Tools:getLang(2701), item_data.day))

    cell.btn_done:registerScriptTapHandler(handler(self, self.onBtnDone))

    local cur_days = item_data.day
    local completed = item_data.money
    local to_day = ex.Player.promotion_data.recharge_reward.days 
    
    if cur_days < to_day  then 
        -- cell:setState(need, 3) -- 已完成
        if item_data.has_reward == 0 then 
            if completed < need then
                cell:setState(completed, 1) -- 当天未完成
            else
                cell:setState(completed, 2) -- 当前已完成
            end
        else
            cell:setState(completed, 3) -- 已完成
        end 


    elseif cur_days == to_day then 
        if item_data.has_reward == 0 then 
            if completed < need then
                cell:setState(completed, 1) -- 当天未完成
            else
                cell:setState(completed, 2) -- 当前已完成
            end
        else
            cell:setState(completed, 3) -- 已完成
        end 
    else 
        cell:setState(0, 0) -- 未开启
    end 


    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    cell:addChild(menu)

    local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local start = cc.p(-20, cell.btn_done:getPositionY())

    for i,v in ipairs(item_data.item) do
    	local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item:setPosition(start.x + goods_size.width * i, start.y)
        item:setScale(0.75)
        item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        menu:addChild(item)
    end

    return cell
end

function PROMRechargeAward2Layer:onBtnDone(tag, pSender)
    local cell = pSender:getParent():getParent()
	if cell.state == 1 then
          ex.JumpManager:jumpByAtom("act_recharge_smart")
	elseif cell.state == 2 then
		--print(ex.Tools:getLang(47444))
		cell:onGain()
        
        -- 发送领取协议
        ex.Player.promotion_data:getRechargeReward(cell.idx)
        
        self:updateTaskView()

        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_HD_LCFL, false)

	end
end

function PROMRechargeAward2Layer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

return PROMRechargeAward2Layer