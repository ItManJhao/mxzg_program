local PROMWeekCheckLayer = class("PROMWeekCheckLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMWeekCheckCell = class("PROMWeekCheckCell", require("src.comp.LuaLayerBase"))

local ExTimer = require("src.ex.ExTimer")

function PROMWeekCheckCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function PROMWeekCheckCell:initDone(idx, production_id,rmb, hasNum)
	self.idx = idx or 0
	self.rmb = rmb or "0"
	self.hasNum = hasNum or 0

	self.lbl_num:setString(string.format(ex.Tools:getLang(2706), self.hasNum)) -- ex.Tools:getLang(47573)

	-- ex.Tools:getLang(47713)
	local lbl_btn_txt = cc.Label:createWithTTF(string.format(ex.Tools:getLang(2705), tonumber(self.rmb) / 100), FONT_DEFAULT_NAME_BOLD, 36)
	:setScale(0.5)
  	:setPosition(self.btn_buy:getContentSize().width / 2, self.btn_buy:getContentSize().height / 2)
	self.btn_buy:addChild(lbl_btn_txt, 10)

	self.btn_buy:setTag(production_id)
    self.btn_buy:setScale(1.2)

	if self.hasNum <= 0 then
		self.hasNum = 0
		self.btn_buy:setEnabled(false)
		self.btn_buy:setNormalImage(cc.Sprite:createWithSpriteFrameName("button/btn-orange-3.png"))
	else
		lbl_btn_txt:setTextColor(FONT_BROWN)
	end
end


-----------------------------------------------------------------------
function PROMWeekCheckLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(3))

	local sub_size = cc.size(60, 60)
    self:resetScrollView(nil, sub_size)


	self.spr_box:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width, self.scroll_view:getViewSize().height + sub_size.height))
    self.spr_box:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.5, self.scroll_view:getPositionY() - sub_size.height * 0.5))

    self.spr_bg:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width * 0.5, self.scroll_view:getViewSize().height + sub_size.height * 0.5))
    self.spr_bg:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.25, self.scroll_view:getPositionY() - sub_size.height * 0.25))

	self.lbl_time:setPositionY(self.scroll_view:getPositionY() - sub_size.height * 0.5 - 30)
	
    -- 活动刷新时间
	--self.reset_time = GetWeekResetTime()
	self.reset_time = ex.Player.promotion_data.week_gift.ctime - ex.Game:getServerTime()
    self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    self:updateCDTime()

    self:updateStarView()
    self:addEvent(EVENT.MAIN_CITY_PROMOTION.WEEK_GIFT, handler(self, self.updateStarView))
end

function PROMWeekCheckLayer:updateCDTime()
	self.reset_time = self.reset_time - 1
    if self.reset_time <= 0 then
        --self.reset_time = self.reset_time + 86400 * 7
		
        -- 时间到
        -- 周累计充值
		--ex.Player.promotion_data:reqRechargeWeek()
		self.lbl_time:setString("")
		return 
    end

    if self.reset_time > 86400 then
    	-- 大于1天
    	-- 剩余时间：%d天
    	self.lbl_time:setString(string.format(ex.Tools:getLang(48011),
    		math.floor(self.reset_time / 86400)))
    	-- self.lbl_time:setString(string.format(ex.Tools:getLang(47454), 
    	-- 	math.floor(self.reset_time / 86400),
     --    	math.floor(self.reset_time / 3600 % 24),
     --    	math.floor(self.reset_time / 60 % 60),
     --    	math.floor(self.reset_time % 60)))
    else
    	-- 剩余时间：%d小时%d分%d秒
    	self.lbl_time:setString(string.format(ex.Tools:getLang(48010), 
        	math.floor(self.reset_time / 3600),
        	math.floor(self.reset_time / 60 % 60),
        	math.floor(self.reset_time % 60)))
    end
end

function PROMWeekCheckLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function PROMWeekCheckLayer:updateStarView()
	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()

	local cell_size = cc.size(540, 130)
	cell_size.height = cell_size.height + 6

	-- 领取过了的排后面
	table.sort(ex.Player.promotion_data.week_gift.list, function(a, b)
		if a.hasNum == 0 then
      		if b.hasNum == 0 then
        		return a.idx < b.idx
      		end
      		return false
    	else
      		if b.hasNum ~= 0 then
        		return a.idx < b.idx
      		end
      		return true
    	end
	end)

	local giftLen = table.nums(ex.Player.promotion_data.week_gift.list)
    local cont_height = math.max(cell_size.height * giftLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    cont_height = cont_height - cell_size.height * 0.5

    local start = cc.p(viewSize.width * 0.5, cont_height)

    for i,v in ipairs(ex.Player.promotion_data.week_gift.list) do
    	local cell = self:createWeekCell(v.idx,v.production_id, v.rmb, v.hasNum, v.goods)
    	:setPosition(start.x, start.y - (i - 1) * cell_size.height)
    	self.scroll_view:addChild(cell)
    end
end

function PROMWeekCheckLayer:createWeekCell(idx,production_id, rmb, hasNum, goods)
	local cell = PROMWeekCheckCell:createWithCCBIFile("ccbi/PROMWeekCheckCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
	cell:setAnchorPoint(ex.a.center)
	
	local scale = self.scroll_view:getViewSize().width / cell:getContentSize().width
	cell:setScale(scale)

    cell:initDone(idx,production_id, tostring(rmb), hasNum)

    cell.btn_buy:registerScriptTapHandler(handler(self, self.onBtnBuy))

    -- 商品
    local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(self.scroll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    cell:addChild(menu)

	local goods_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    goods_size.width = goods_size.width * 0.75 + 10

    local start = cc.p(-20, cell:getContentSize().height / 2)
    
	for i,v in ipairs(goods) do
		local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item:setPosition(start.x + goods_size.width * i, start.y)
        item:setScale(0.75)
        item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        menu:addChild(item)
		
		-- if v.item_type == ItemType.IT_GEM then
		-- 	item:setDoubleIcon(true, 1)
		-- end
	end

    return cell
end

function PROMWeekCheckLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function PROMWeekCheckLayer:onBtnBuy(tag, pSender)
	local config = cfg.buygem.buygem[tag]
	if config then
		--print(string.format("拉起购买 idx=%d, id=%s, rmb = %s", config.idx, config.id, config.rmb))
		ex.Player:pay(config.idx)
	end
end


return PROMWeekCheckLayer