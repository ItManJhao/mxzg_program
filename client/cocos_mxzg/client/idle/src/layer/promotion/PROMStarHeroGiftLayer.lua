local PROMStarHeroGiftLayer = class("PROMStarHeroGiftLayer", require("src.layer.promotion.PromotionBaseLayer"))

local ExTimer = require("src.ex.ExTimer")

function PROMStarHeroGiftLayer:onCreate()
    self.cur_gift_id = ""

    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.btn_buy:setPosition(ex.p.cx, ex.MainSceneCtr:getBottomHeight() + 140)
    self.remain_num:setPositionY(ex.MainSceneCtr:getBottomHeight() + 140)
	-- ￥%s元
	local lbl_btn_txt = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 30)
	:enableOutline(FONT_DARK_BLUE, 1)
	:setPosition(self.btn_buy:getContentSize().width / 2, self.btn_buy:getContentSize().height / 2)
	self.btn_buy:addChild(lbl_btn_txt, 10, 10)
	   
	self.remain_num:setPositionY(self.btn_buy:getPositionY() + 60)

   	-- 活动倒计时
   	self.timer = ExTimer:new():bind(self)

   	-- 礼包节点
   	self.gift_size = cc.Sprite:createWithSpriteFrameName("promotion/item-bg-2.png"):getContentSize()

   	self.node_gift = cc.Node:create()
   	:setPosition(ex.p.cx, self.btn_buy:getPositionY() + 120 + self.gift_size.height / 2)
    self:addChild(self.node_gift)
       
	-- 调整彩色背景大小
	self.spr_bg2:setPreferredSize(cc.size(ex.p.width, ex.p.height - 214 - 50))
	-- self.spr_bg2:setPositionY(self.layer_promotion:getTopY())
end

function PROMStarHeroGiftLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function PROMStarHeroGiftLayer:onCreateDone(gift_id)
    self.cur_gift_id = gift_id
    self.node_gift:removeAllChildren()

    local gitfData = ex.Player.promotion_data:getLimitGiftById(self.cur_gift_id)
	local config = cfg.buygem.buygem[gitfData.idx]
	self:setCurrentGift(gitfData.idx, gitfData.last_time, gitfData.num, config.rmb, config.item)
	
	self.spr_bg2:setPositionY(self.layer_promotion:getTopY())
end

function PROMStarHeroGiftLayer:updateCDTime()
    local remain_second = self.last_time - ex.Game:getServerTime()
    if remain_second <= 0 then
    	-- 时间到删除节点 if 节点为空 返回主城 else 自动选择第一个节点
    	self.timer:stop()
    	self:updateLayer()
    end
    -- 剩余时间：%d小时%d分%d秒
    self.lbl_time:setString(string.format('%02d：%02d：%02d', 
        math.floor(remain_second / 3600),
        math.floor(remain_second / 60 % 60),
        math.floor(remain_second % 60)))
end

function PROMStarHeroGiftLayer:setCurrentGift(idx, last_time, num, rmb, gift_list)
	self.btn_buy:getChildByTag(10):setString(string.format(ex.Tools:getLang(2705), tostring(rmb / 100)))
	self.btn_buy:setTag(idx)

    self.remain_num:setString(string.format(ex.Tools:getLang(2706), num))
	self.last_time = last_time
	self.timer:run(handler(self, self.updateCDTime), 1.0)
	self:updateCDTime()

	self.node_gift:removeAllChildren()

	local menu = cpp.UIMenu:create()
	menu:setPosition(0,0)
	self.node_gift:addChild(menu)

	local giftLen = table.nums(gift_list)
	local diff = self.gift_size.width + 20
	if giftLen > 4 then
		diff = diff - 5
    end
    
	local start = cc.p(diff * 0.5 * (1 - giftLen), 0)

	for i,v in ipairs(gift_list) do
		local btn = cpp.UIMenuItemImage:createWithSpriteFrameName("promotion/item-bg-2.png", nil, nil)
		btn:setPosition(start.x + (i - 1) * diff, start.y)
		btn:registerScriptTapHandler(handler(self, self.onBtnInfo))
		menu:addChild(btn)

		btn:setTag(v.item_type)

		-- icon
		local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", v.item_type))
		:setPosition(self.gift_size.width / 2, self.gift_size.height / 2)
		btn:addChild(spr_icon)

		-- num
		local lbl_num = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 48)
		:setScale(0.5)
		:enableOutline(ex.c3b.BLACK, 2)
		:setPosition(self.gift_size.width / 2, self.gift_size.height / 2 - spr_icon:getContentSize().height / 2)
		btn:addChild(lbl_num)

		-- if v.item_type == ItemType.IT_GEM then
        --     btn.icon_double = cc.Sprite:createWithSpriteFrameName("backpack/spr-double-1.png")
		-- 	btn.icon_double:setAnchorPoint(0, 1)
		-- 	btn.icon_double:setPosition(-10, btn:getContentSize().height + 10)
		-- 	btn:addChild(btn.icon_double, 100)
        -- end

		if v.item_num >= 100000 then
			lbl_num:setString(string.format(ex.Tools:getLang(47376), math.floor(v.item_num / 10000)))
		else
			lbl_num:setString(tostring(v.item_num))
		end
	end

end

function PROMStarHeroGiftLayer:onBtnInfo(tag, pSender)
	ex.Tools:onClickItemInfo(tag)
end

function PROMStarHeroGiftLayer:onBtnBuy(tag, pSender)
	--print("onBtnBuy...idx = "..tag)
    --print("onBtnBuy...cur_gift_id = "..self.cur_gift_id)
    if self.last_time < ex.Game:getServerTime() then
        ex.MessageView:add(ex.Tools:getLang(47740))
        return
    end
	-- 拉起支付页面
	local config = cfg.buygem.buygem[tag]
	if config then
		-- print(string.format("拉起购买 idx=%d, id=%s, rmb = %s", config.idx, config.id, config.rmb))
		ex.Player:pay(config.idx, self.cur_gift_id)
	end
	
	ex.Tools:setGray(pSender:getNormalImage())
	pSender:setEnabled(false)
    
    -- ex.Player.promotion_data:subLimitGiftOneById(self.cur_gift_id)
    
    -- local giftData = ex.Player.promotion_data:getLimitGiftById(self.cur_gift_id)
    -- if giftData == nil then
    --     if table.nums(ex.Player.promotion_data.limit_gift) ~= 0 then
    --         -- 客户端界面进度刷新
    --         local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_LIMIT_GIFT)
    --         if cur_layer then
    --             cur_layer:updateLayer()
    --         end
    --     else
    --         -- 没有礼包了 跳转主城
	-- 	    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
    --     end

    --     -- ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.LIMIT_GIFT)
    --     ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_limit_gift")
    -- -- else
    -- --     self.remain_num:setString(string.format(ex.Tools:getLang(2706), giftData.num))
    -- end
end

return PROMStarHeroGiftLayer