--[[
    func: 限时抢购
    author:徐东浩
    time:2020-01-09 14:49:56
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local PROMLimitBuyLayer = class("PROMLimitBuyLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMLimitBuyCell = class("PROMLimitBuyCell", require("src.comp.LuaLayerBase"))

function PROMLimitBuyCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

    self.lbl_desc = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 48)
    self.lbl_desc:setAnchorPoint(ex.a.left_center)
    self.lbl_desc:setScale(0.5)
    self.lbl_desc:setPosition(16, self.lbl_num:getPositionY())
    self.lbl_desc:enableOutline(cc.c4b(68, 32, 11, 255), 3)
    self:addChild(self.lbl_desc)

    self.scroll_view = cpp.UIScrollViewZoom:create(cc.size(438, 114))
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
    self.scroll_view:setPosition(10, 10)
    self.scroll_view:setBounceable(false)
    self.scroll_view:setSwallowsTouches(false)
    self:addChild(self.scroll_view)

    self.menu_reward = cpp.UIMenu:create()
    self.menu_reward:setIsTouchInsideNode(self.scroll_view)
    self.menu_reward:setSwallowsTouches(false)
    self.menu_reward:setPosition(cc.p(0, 0))
    self.scroll_view:addChild(self.menu_reward)
end

function PROMLimitBuyCell:initDone(data)
    self.data = data
    
    self.lbl_desc:setString(self.data.name)

    local limit_str = ""
    if self.data.config.limit_day == 1 then
        limit_str = string.format(ex.Tools:getLang(70802), tostring(self.data.config.limit_num))
    elseif self.data.config.limit_day == 7 then
        limit_str = string.format(ex.Tools:getLang(70801), tostring(self.data.config.limit_num))
    end
    self.lbl_num:setString(string.format("%s(%d/%d)", limit_str, self.data.bought_times, self.data.config.limit_num))
    
    self.lbl_origin_cost:setString(string.format(ex.Tools:getLang(70800), tostring(self.data.origin_cost)))

    if self.data.bought_times >= self.data.config.limit_num then
        self.btn_submit:setLabelText(ex.Tools:getLang(41153))
        self.btn_submit:setLabelColor(cc.c3b(200, 200, 200))
        self.btn_submit:setLabelOutLine(cc.c4b(100, 100, 100), 2)
        ex.Tools:setGrayAuto(self.btn_submit:getNormalImage(), true)
    else
        self.btn_submit:setLabelText(string.format(ex.Tools:getLang(2705), tostring(self.data.rmb)))
    end
    self.btn_submit:setEnabled(self.data.bought_times < self.data.config.limit_num)
	self.btn_submit:setTag(self.data.config.idx)

	if self.data.config.discount ~= nil and self.data.config.discount > 0 and self.data.config.discount < 100 then
		local discount = self.data.config.discount
		local spr_discount_bg = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
		spr_discount_bg:setPosition(self.btn_submit:getContentSize().width - 5, self.btn_submit:getContentSize().height)
		spr_discount_bg:setScale(0.8)
		self.btn_submit:addChild(spr_discount_bg, 100)

		if math.floor(discount / 10) == discount / 10 then
			discount = math.floor(discount / 10)
		end

		local lbl_discount_1 = cc.Label:createWithTTF(tostring(discount / 10.0), FONT_DEFAULT_NAME_BOLD, 38)
		lbl_discount_1:setScale(0.5)
		lbl_discount_1:setPosition(spr_discount_bg:getContentSize().width / 2 - 10, spr_discount_bg:getContentSize().height / 2 + 5)
		spr_discount_bg:addChild(lbl_discount_1)

		local lbl_discount_2 = cc.Label:createWithTTF(ex.Tools:getLang(47553), FONT_DEFAULT_NAME_BOLD, 36)
		lbl_discount_2:setScale(0.5)
		lbl_discount_2:setPosition(spr_discount_bg:getContentSize().width / 2 + 10, spr_discount_bg:getContentSize().height / 2 - 5)
		spr_discount_bg:addChild(lbl_discount_2)
	end

    local cell_padding = 4
    local scale = 0.85
    local start = cc.p(2, 50)
    local real_width = 0
	for i,v in ipairs(self.data.config.reward) do
		local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item:setScale(scale)
        item:setPosition(start.x + item:getContentSize().width * scale * (i - 0.5) + cell_padding * (i - 1), start.y)
        item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        self.menu_reward:addChild(item)
        real_width = item:getContentSize().width * scale
    end
    
    local view_size = cc.size(math.max(real_width * #self.data.config.reward + cell_padding * (#self.data.config.reward - 1) + start.x * 2, self.scroll_view:getViewSize().width), 114)
    self.scroll_view:setContentSize(view_size)
    self.scroll_view:setContentOffset(ex.p.zero)
end

function PROMLimitBuyCell:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


-----------------------------------------------------------------------
function PROMLimitBuyLayer:onCreateDone()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 数据
    self.promotion_id = 54
    self.data = {}
    self.cell_size = cc.size(634, 165)
    self.timer_name = "act_limit_buy_timer"

    self:addTimeProgress()
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(426))

    local top_y = self.layer_promotion:getTopY()
	top_y = top_y - 126 - 10
    self.scroll_view = cpp.UIScrollViewZoom:create(cc.size(ex.p.width, top_y - self.layer_promotion:getBottomY() - 20))
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setPosition(0, self.layer_promotion:getBottomY() + 20)
    self.scroll_view:setBounceable(false)
    self:addChild(self.scroll_view)

    local banner_pos_x, banner_pos_y = self.spr_banner:getPosition()
    local banner_size = self.spr_banner:getContentSize()
    self.time_node:setPosition(cc.p(banner_pos_x + banner_size.width * self.spr_banner:getScaleX() / 2, banner_pos_y + banner_size.height * self.spr_banner:getScaleY() / 2 - self.time_bg:getContentSize().height * self.time_bg:getScaleY() / 2 - 2))
    self.time_node:setLocalZOrder(100)

    self:updateView()

    -- 活动刷新时间
    self:addTimer(self.timer_name, 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()

    self:addEvent(EVENT.LIMIT_BUY_EVENT.REFRESH_UI_DATA, handler(self, self.updateView))
end

function PROMLimitBuyLayer:updateCDTime()
    local remain_time = self.data.info.end_time - ex.Game:getServerTime()

    if ex.Game:getServerTime()  <  self.data.info.start_time then 
		self.time_text:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
        self.time_text:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName(self.timer_name)
		return
    end

    if remain_time > 86400 then
    	-- 大于1天
    	-- 剩余时间：%d天
    	self.time_text:setXmlTextLua(string.format(ex.Tools:getLang(41130),
    		math.floor(remain_time / 86400)))
    else
        remain_time = math.max(0, remain_time)
    	-- 剩余时间：%d小时%d分%d秒
    	self.time_text:setXmlTextLua(string.format(ex.Tools:getLang(41129), 
        	math.floor(remain_time / 3600),
        	math.floor(remain_time / 60 % 60),
        	math.floor(remain_time % 60)))
    end
end

function PROMLimitBuyLayer:generateData()
    -- 生成数据并排序
    self.data = {}
    self.data.list = {}
    self.data.info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)

    local list = cfg.promotionflashsale.getConfigListByTurns(self.data.info.turns, ex.Player.level)

    for i,v in ipairs(list) do
        local data = {}
        data.config = v
        data.bought_times = ex.Player.promotion_data:getFlashSaleCountForIdx(v.idx)
        
        local buy_gem = cfg.buygem.buygem[v.production_id]
        if buy_gem ~= nil then
            data.name = ex.Tools:getLang(buy_gem.item_language)
            data.rmb = buy_gem.rmb / 100
            data.origin_cost = buy_gem.original_cost / 100
            data.sort = buy_gem.sort
        else
            data.name = "-"
            data.rmb = "-"
            data.origin_cost = "-"
            data.sort = i
        end

        table.insert(self.data.list, data)
    end

    table.sort(self.data.list, function(a, b)
        if a.bought_times >= a.config.limit_num then
            if b.bought_times >= b.config.limit_num then
                return a.sort < b.sort
            else
                return false
            end
        else
            if b.bought_times >= b.config.limit_num then
                return true
            else
                return a.sort < b.sort
            end
        end
    end)
end

function PROMLimitBuyLayer:updateView()
    -- 生成数据
    self:generateData()

    -- dump(self.data, "list=======")
	self.scroll_view:getContainer():removeAllChildren()

    local cell_padding = 8
	local viewSize = self.scroll_view:getViewSize()

	local cellLen = table.nums(self.data.list)
    local cont_height = math.max((self.cell_size.height * ex.s.global_scale + cell_padding) * cellLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    local start = cc.p(viewSize.width * 0.5, cont_height - self.cell_size.height * ex.s.global_scale * 0.5)
    for i,v in ipairs(self.data.list) do
    	local cell = self:createDailyCell(v)
    	cell:setPosition(start.x, start.y - (i - 1) * (self.cell_size.height * ex.s.global_scale + cell_padding))
    	self.scroll_view:getContainer():addChild(cell)
    end
end

function PROMLimitBuyLayer:createDailyCell(data)
	local cell = PROMLimitBuyCell:createWithCCBIFile("ccbi/PROMLimitBuyCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
	cell:setAnchorPoint(ex.a.center)
	cell:setScale(ex.s.global_scale)
   
    cell:initDone(data)

	cell.btn_submit:registerScriptTapHandler(handler(self, self.onBtnBuy))
	cell.menu:setIsTouchInsideNode(self.scroll_view)
    cell.menu:setSwallowsTouches(false)

    return cell
end

function PROMLimitBuyLayer:onBtnBuy(tag, pSender)
    local cell = pSender:getParent():getParent()

    if not ex.Player.promotion_data:getTimeIsOpen(self.promotion_id) then
        ex.MessageView:add(ex.Tools:getLang(47324))
        return
    end
    
    if cell.data.bought_times < cell.data.config.limit_num then
        ex.Player:pay(cell.data.config.production_id)
    else
        ex.MessageView:add(ex.Tools:getLang(47397))
        return
    end
end


return PROMLimitBuyLayer
