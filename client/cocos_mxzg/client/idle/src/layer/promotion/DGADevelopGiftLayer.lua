local DGADevelopGiftLayer = class("DGADevelopGiftLayer", require("src.layer.promotion.PromotionBaseLayer"))
local DGADevelopGiftCell = class("DGADevelopGiftCell", require("src.comp.LuaLayerBase"))

local ActivityIdxTypeMap = {}
ActivityIdxTypeMap.id601 = 1
ActivityIdxTypeMap.id602 = 2
ActivityIdxTypeMap.id603 = 3

function DGADevelopGiftCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function DGADevelopGiftCell:initDone(data)
    self.data = data

	self.lbl_num:setString(string.format("x%s", ex.StringUtil.getScientificNumber(self.data.item_num)))

    self.name:setString(ex.Tools:getLang(cfg.item.item[self.data.item_type].name))
    self.desc:setString(ex.Tools:getLang(cfg.item.item[self.data.item_type].content))

    -- 商品
    self.menu = cpp.UIMenu:create()
    self.menu:setPosition(cc.p(0, 0))
    self:addChild(self.menu)

	local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width + 10

    local start = cc.p(36, self:getContentSize().height / 2)

    local item = ex.Player.backpack_data:createWithData(self.data.item_type)
    item:setPosition(start.x + goods_size.width / 2, start.y)
    item:setScale(1)
    item:registerScriptTapHandler(handler(self, self.onBtnInfo))
    self.menu:addChild(item)
end

function DGADevelopGiftCell:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end


-----------------------------------------------------------------------
function DGADevelopGiftLayer:onCreateDone(idx)
	self:setAutoClose(false)
    self:setSwallowTouches(false)

    -- 数据
    self.promotion_id = 52
    self.activity_idx = idx
    self.activity_type = ActivityIdxTypeMap["id"..self.activity_idx]
    self.timer_name = "act_develop_gift_timer"
    self.CellSize = cc.size(630, 144)
    self.reqCount = 0
    self.list = {}

    self:addTimeProgress()
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(self.activity_idx))

    self.scroll_view:setViewSize(cc.size(ex.p.width * self.CellSize.width / 640, self.layer_promotion:getTopY() - self.layer_promotion:getBottomY() - self.spr_banner:getContentSize().height - 10 - self.node_buy:getContentSize().height))
    self.scroll_view:setPosition(ex.p.width * 0.5 - self.scroll_view:getViewSize().width * 0.5, self.layer_promotion:getBottomY() + self.node_buy:getContentSize().height)

    -- 增加折扣标签
    self.discount_bg = cc.Sprite:createWithSpriteFrameName("promotion/discount.png")
    self.discount_bg:setAnchorPoint(ex.a.left_top)
    self.discount_bg:setPosition(0, self.spr_banner:getContentSize().height - 4)
    self.spr_banner:addChild(self.discount_bg)

    self.lbl_discount = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 26)
    self.lbl_discount:setAnchorPoint(ex.a.center)
	self.lbl_discount:setTextColor(ex.c3b.WHITE)
    self.lbl_discount:enableOutline(cc.c3b(154, 0, 0), 1)
    self.lbl_discount:setPosition(41, 66)
    self.lbl_discount:setRotation(-30)
    self.discount_bg:addChild(self.lbl_discount)

    ex.Tools:setGrayAuto(self.btn_bought:getNormalImage(), true)
    self.btn_bought:setEnabled(false)

    self.node_buy:setPositionY(self.layer_promotion:getBottomY())

    self.btn_buy:registerScriptTapHandler(handler(self, self.onBtnBuy))

    if not ex.Player.promotion_data.is_develop_gift_dirty then
        -- 数据不是旧的就直接显示
        self:updateView()
    end

    self:addEvent(EVENT.MAIN_CITY_PROMOTION.DEVELOP_GIFT_REFRESH, handler(self, self.updateView))
end

function DGADevelopGiftLayer:updateCDTime()
    local remain_time = ex.Player.promotion_data.develop_gift.refresh_date_time - ex.Game:getServerTime()

	if remain_time < 0 then 
        self.time_text:setXmlTextLua(ex.Tools:getLang(41053));
        
        self:removeTimerByName(self.timer_name)

        if self.reqCount < 5 then
            ex.Player.promotion_data:reqDevelopGiftData()
            self.reqCount = self.reqCount + 1
        end

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

function DGADevelopGiftLayer:generateData()
    -- 生成数据并排序
    self.list = {}

    local config, isBought = ex.Player.promotion_data:DevelopGiftCurShow(self.activity_type)
    self.list.isBought = isBought
    self.list.config = config
end

function DGADevelopGiftLayer:updateView()
    -- 生成数据
    self:generateData()

    -- 活动刷新时间
    if self.timerList == nil or self.timerList[self.timer_name] == nil then
        self:addTimer(self.timer_name, 1000, handler(self, self.updateCDTime), true)
    end

    self:updateCDTime()

    self.lbl_discount:setString(string.format(ex.Tools:getLang(47728), self.list.config.discount / 10))

    self:setOriginCost(self.list.config.value[1].item_type, self.list.config.value[1].item_num)
    self:setNewCost(self.list.config.cost[1].item_type, self.list.config.cost[1].item_num, self.list.isBought)

    -- dump(self.list, "list=======")
	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()
    local cell_size = cc.size(self.CellSize.width, self.CellSize.height)
    local cell_scale = viewSize.width / (cell_size.width + 2)
    cell_size.height = cell_size.height * cell_scale + 10
    
	local cellLen = table.nums(self.list)
    local cont_height = math.max(cell_size.height * cellLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    local start = cc.p(viewSize.width * 0.5, cont_height - cell_size.height * 0.5)
    for i,v in ipairs(self.list.config.reward) do
        local cell = self:createDailyCell(v)
        cell:setScale(cell_scale)
    	cell:setPosition(start.x, start.y - (i - 1) * cell_size.height)
    	self.scroll_view:addChild(cell)
    end
end

function DGADevelopGiftLayer:createDailyCell(data)
	local cell = DGADevelopGiftCell:createWithCCBIFile("ccbi/DGADevelopGiftCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
	cell:setAnchorPoint(ex.a.center)
	-- cell:setScale(self.scroll_view:getViewSize().width / (cell:getContentSize().width + 2))
   
    cell:initDone(data)

	cell.menu:setIsTouchInsideNode(self.scroll_view)
    cell.menu:setSwallowsTouches(false)

    return cell
end

function DGADevelopGiftLayer:setOriginCost(item_type, item_num)
    if item_type ~= nil then
        self.need_icon_origin:setSpriteFrame(string.format("backpack/%d.png", item_type))
    end

    if item_num ~= nil then
        self.lbl_origin_cost:setString(tostring(item_num))
    end
end

function DGADevelopGiftLayer:setNewCost(item_type, item_num, isBought)
    self.btn_bought:setVisible(isBought)

    self.btn_buy:setVisible(not isBought)
    self.btn_buy:setEnabled(not isBought)

    self.btn_buy:setLabelText(tostring(item_num))

    ex.Tools:addRedPoint(self.btn_buy, item_num <= 0, ex.r.p92)

    ex.Tools:addImgToUIMenuItemLabel(self.btn_buy, nil, "backpack/"..item_type..".png", 0.4)
end

function DGADevelopGiftLayer:onBtnBuy(tag, pSender)
    if ex.Player.promotion_data.develop_gift.refresh_date_time < ex.Game:getServerTime() or ex.Player.promotion_data.is_develop_gift_dirty then
        ex.MessageView:add(ex.Tools:getLang(47324))
        return
    end

    if ex.Player:getItemNum(self.list.config.cost[1].item_type) < self.list.config.cost[1].item_num then
        ex.MessageView:add(ex.Tools:getLang(41004))
        return
    end

    ex.Player.promotion_data:reqDevelopGiftBuy(self.list.config.type, self.list.config.level)

    pSender:setEnabled(false)
end


return DGADevelopGiftLayer
