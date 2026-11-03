local PROMExchangeGiftLayer = class("PROMExchangeGiftLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMExchangeGiftCell = require("src.layer.promotion.PROMExchangeGiftCell")
local string_format = string.format
local ExTimer = require("src.ex.ExTimer")

function PROMExchangeGiftLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
    
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(410))

    local sub_size = cc.size(60, 60)
    self:resetScrollView(nil, sub_size)

	self.spr_box:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width, self.scroll_view:getViewSize().height + sub_size.height))
    self.spr_box:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.5, self.scroll_view:getPositionY() - sub_size.height * 0.5))

    self.spr_bg:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width * 0.5, self.scroll_view:getViewSize().height + sub_size.height * 0.5))
    self.spr_bg:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.25, self.scroll_view:getPositionY() - sub_size.height * 0.25))

    self.lbl_time:setPositionY(self.scroll_view:getPositionY() - sub_size.height * 0.5 - 30)
    
    -- 活动刷新时间
    self.reset_time = ex.Player.promotion_data.time_exchange_data.etime1 - ex.Game:getServerTime()
    self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    self:updateCDTime()
    self.lbl_time:setString("")
    self:updateTaskView()

end


function PROMExchangeGiftLayer:updateCDTime()
    self.reset_time = self.reset_time - 1

    local show_msg = ""
        --表示倒计是结束，进入清算时间
    if self.reset_time > 86400 then
        show_msg = string_format(ex.Tools:getLang(48011),math.floor(self.reset_time / 86400))
    elseif self.reset_time > 0 and self.reset_time < 86400 then 
        show_msg = string_format(ex.Tools:getLang(48010), 
            math.floor(self.reset_time / 3600),
            math.floor(self.reset_time / 60 % 60),
            math.floor(self.reset_time % 60))
    else
        show_msg = ex.Tools:getLang(41053)
    end
    self.lbl_time:setString(show_msg)
end



function PROMExchangeGiftLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function PROMExchangeGiftLayer:updateTaskView()
	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()

	local cell_size = cc.size(540, 155)
	cell_size.height = cell_size.height + 6

	local giftLen = table.nums(ex.Player.promotion_data.time_exchange_data.change_list)
    local cont_height = math.max(cell_size.height * giftLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    cont_height = cont_height - cell_size.height * 0.5

    local start = cc.p(viewSize.width * 0.5, cont_height)

    for i,v in ipairs(self:sor(ex.Player.promotion_data.time_exchange_data.change_list))  do
    	local cell = self:createCell(v.idx, v.reward, v.count , v.is_obtain)
    	:setPosition(start.x, start.y - (i - 1) * cell_size.height)
    	self.scroll_view:addChild(cell)
    end
end


function  PROMExchangeGiftLayer:sor( data )
    if #data < 1 then return {} end
 
    local function sort_table (a,b)
        
        return a.idx < b.idx
 
    end 
     table.sort( data, sort_table )
     return data
 end




function PROMExchangeGiftLayer:createCell(idx, award_list, need, is_obtain)
	local cell = PROMExchangeGiftCell:createWithCCBIFile("ccbi/PROMExchangeGiftCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
    cell:setAnchorPoint(ex.a.center)
    cell:setScale(self.scroll_view:getViewSize().width / (cell:getContentSize().width + 2))

    cell:initDone(idx, need, string.format(ex.Tools:getLang(2704), need / 100))

    cell.btn_done:registerScriptTapHandler(handler(self, self.onBtnDone))

    local completed = ex.Player.promotion_data.time_exchange_data.nvalue

	if completed < need then
    	cell:setState(completed, 1) -- 未完成
    else
    	-- if ex.Player.promotion_data:getRechargeWeekIsAward(idx) then
    	-- 	cell:setState(need, 3) -- 已领
    	-- else
    	-- 	cell:setState(need, 2) -- 可领取
		-- end
		if is_obtain == 1 then 
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

function PROMExchangeGiftLayer:onBtnDone(tag, pSender)
	
    local cell = pSender:getParent():getParent()
	if cell.state == 1 then
		  ex.MainSceneCtr:changeToRechargePage()
	elseif cell.state == 2 then
		cell:onGain()
		
		ex.Player.promotion_data:reqExchangeGift(cell.idx)

        ex.Player.promotion_data:SetExchangeList(cell.idx, 1)

        ex.Player.promotion_data:checkExchangeRedDot()
	end
end

function PROMExchangeGiftLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


return PROMExchangeGiftLayer