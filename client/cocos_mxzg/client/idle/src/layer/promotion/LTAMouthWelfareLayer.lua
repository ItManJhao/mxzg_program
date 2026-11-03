local LTAMouthWelfareLayer = class("LTAMouthWelfareLayer", require("src.layer.promotion.PromotionBaseLayer"))
local LTAMouthWelfareCell = class("LTAMouthWelfareCell", require("src.comp.LuaLayerBase"))

local ExTimer = require("src.ex.ExTimer")

function LTAMouthWelfareCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
end

function LTAMouthWelfareCell:initDone(idx,production_id, rmb, hasNum)
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
function LTAMouthWelfareLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(5))

	local sub_size = cc.size(60, 60)
    self:resetScrollView(nil, sub_size)

	self.spr_box:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width, self.scroll_view:getViewSize().height + sub_size.height))
    self.spr_box:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.5, self.scroll_view:getPositionY() - sub_size.height * 0.5))

    self.spr_bg:setContentSize(cc.size(self.scroll_view:getViewSize().width + sub_size.width * 0.5, self.scroll_view:getViewSize().height + sub_size.height * 0.5))
    self.spr_bg:setPosition(cc.p(self.scroll_view:getPositionX() - sub_size.width * 0.25, self.scroll_view:getPositionY() - sub_size.height * 0.25))

	self.lbl_time:setPositionY(self.scroll_view:getPositionY() - sub_size.height * 0.5 - 30)

    -- 活动刷新时间
	--self.reset_time = GetMouthResetTime()
	self.reset_time = ex.Player.promotion_data.mouth_welfare.ctime - ex.Game:getServerTime()
	self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    self:updateCDTime()

    self:updateStarView()
    self:addEvent(EVENT.MAIN_CITY_PROMOTION.MOUTH_WELFARE, handler(self, self.updateStarView))
end

function LTAMouthWelfareLayer:updateCDTime()
	self.reset_time = self.reset_time - 1
    if self.reset_time <= 0 then
        --self.reset_time = self.reset_time + 86400 * 30

        -- 时间到了，更新每月福利
		--ex.Player.promotion_data:reqMouthWelfare()
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

function LTAMouthWelfareLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function LTAMouthWelfareLayer:updateStarView()
	self.scroll_view:getContainer():removeAllChildren()

	local viewSize = self.scroll_view:getViewSize()

	local cell_size = cc.size(540, 130)
	cell_size.height = cell_size.height + 6

	-- 领取过了的排后面
	table.sort(ex.Player.promotion_data.mouth_welfare.list, function(a, b)
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

	local cellLen = table.nums(ex.Player.promotion_data.mouth_welfare.list)
    local cont_height = math.max(cell_size.height * cellLen, viewSize.height)

    self.scroll_view:setContentSize(cc.size(viewSize.width, cont_height))
    self.scroll_view:setContentOffset(cc.p(0, viewSize.height - cont_height))

    cont_height = cont_height - cell_size.height * 0.5

    local start = cc.p(viewSize.width * 0.5, cont_height)

    for i,v in ipairs(ex.Player.promotion_data.mouth_welfare.list) do
    	local cell = self:createMouthCell(v.idx,v.production_id, v.rmb, v.hasNum, v.goods, v.discount)
    	:setPosition(start.x, start.y - (i - 1) * cell_size.height)
    	self.scroll_view:addChild(cell)
    end
end

function LTAMouthWelfareLayer:createMouthCell(idx,production_id, rmb, hasNum, goods, discount)
	local cell = LTAMouthWelfareCell:createWithCCBIFile("ccbi/LTAMouthWelfareCell.ccbi")
	cell:setSwallowTouches(false)
	cell:setIgnoreAnchorPointForPosition(false)
	cell:setAnchorPoint(ex.a.center)
	cell:setScale(self.scroll_view:getViewSize().width / (cell:getContentSize().width + 2))
   
    cell:initDone(idx, production_id,tostring(rmb), hasNum)

	cell.btn_buy:registerScriptTapHandler(handler(self, self.onBtnBuy))
	cell.cell_menu:setIsTouchInsideNode(self.scroll_view)
    cell.cell_menu:setSwallowsTouches(false)

	if discount ~= nil and discount > 0 and discount < 100 then
		local discount = discount
		local spr_discount_bg = cc.Sprite:createWithSpriteFrameName("other/spr-discount-bg.png")
		spr_discount_bg:setPosition(cell.btn_buy:getContentSize().width - 5, cell.btn_buy:getContentSize().height)
		spr_discount_bg:setScale(0.8)
		cell.btn_buy:addChild(spr_discount_bg, 100)

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

    -- 商品
    local menu = cpp.UIMenu:create()
    menu:setIsTouchInsideNode(self.scroll_view)
    menu:setSwallowsTouches(false)
    menu:setPosition(cc.p(0, 0))
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
		
		if v.item_type == ItemType.IT_GEM then
			item:setDoubleIcon(true, 1)
		end
	end

    return cell
end

function LTAMouthWelfareLayer:onBtnInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function LTAMouthWelfareLayer:onBtnBuy(tag, pSender)
	local config = cfg.buygem.buygem[tag]
	if config then
		--print(string.format("拉起每月福利购买 idx=%d, id=%s, rmb = %s", config.idx, config.id, config.rmb))
		ex.Player:pay(config.idx)
	end

	ex.Tools:setGray(pSender:getNormalImage())
	pSender:setEnabled(false)
end


return LTAMouthWelfareLayer