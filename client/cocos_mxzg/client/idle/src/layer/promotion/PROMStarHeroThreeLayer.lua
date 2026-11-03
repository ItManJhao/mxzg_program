local PROMStarHeroThreeLayer = class("PROMStarHeroThreeLayer", require("src.layer.promotion.PromotionBaseLayer"))

local ExTimer = require("src.ex.ExTimer")

function PROMStarHeroThreeLayer:onCreate()
    self.cur_gift_id = ""

    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    -- self.btn_buy:setPosition(ex.p.cx, ex.MainSceneCtr:getBottomHeight() + 140)
    -- self.remain_num:setPositionY(ex.MainSceneCtr:getBottomHeight() + 140)
    -- ￥%s元
    

	local lbl_btn_txt = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 42)
	:enableOutline(cc.c3b(255, 0, 0), 2)
	:setPosition(self.btn_buy:getContentSize().width / 2, self.btn_buy:getContentSize().height / 2 - 3)
	self.btn_buy:addChild(lbl_btn_txt, 10, 10)
	-- self.remain_num:setPositionY(self.btn_buy:getPositionY() + 60)
	self.spr_bg2:setScaleX(ex.p.width / self.spr_bg2:getContentSize().width)

    self.spr_bg2:setPositionY(self.spr_bg2:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_btn:setPositionY(self.node_btn:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.remain_num:setPositionY(self.remain_num:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.spr_remain_num:setPositionY(self.spr_remain_num:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.spr_time:setPositionY(self.spr_time:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.lbl_time:setPositionY(self.lbl_time:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.spr_time_bg:setPositionY(self.spr_time_bg:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.scroll_view:setPositionY(self.scroll_view:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

   	-- 活动倒计时
   	self.timer = ExTimer:new():bind(self)


	self.scroll_view:setItemSize(cc.size(130, 119))
	local eff2 = ex.EffectCtr:playNormalEff(32, self.btn_buy:getContentSize().width * 0.5, self.btn_buy:getContentSize().height * 0.5, nil, self.btn_buy, 11, nil, nil, nil, 1)
	-- 礼包节点
   	-- self.gift_size = cc.Sprite:createWithSpriteFrameName("promotion/item-bg-2.png"):getContentSize()

   	-- self.node_gift = cc.Node:create()
   	-- :setPosition(ex.p.cx, self.btn_buy:getPositionY() + 310 + self.gift_size.height / 2)
    -- self.spr_bg2:getParent():addChild(self.node_gift)
    
	-- 调整彩色背景大小
	-- self.spr_bg2:setPreferredSize(cc.size(ex.p.width, ex.p.height - 214 - 50))
	-- self.spr_bg2:setPositionY(self.layer_promotion:getTopY())
end

function PROMStarHeroThreeLayer:onExit()
    -- 停止计时器
    self.timer:stop()
end

function PROMStarHeroThreeLayer:onCreateDone(gift_id)
    self.cur_gift_id = gift_id
    -- self.node_gift:removeAllChildren()

    local gitfData = ex.Player.promotion_data:getLimitGiftById(self.cur_gift_id)
	local config = cfg.buygem.buygem[gitfData.idx]
	self:setCurrentGift(gitfData.idx, gitfData.last_time, gitfData.num, config.rmb, config.item)
	
	-- self.spr_bg2:setPositionY(self.layer_promotion:getTopY())
end

function PROMStarHeroThreeLayer:updateCDTime()
    local remain_second = self.last_time - ex.Game:getServerTime()
    if remain_second <= 0 then
    	-- 时间到删除节点 if 节点为空 返回主城 else 自动选择第一个节点
    	self.timer:stop()
    	self:updateLayer()
    end
    -- 剩余时间：%d小时%d分%d秒
    self.lbl_time:setString(string.format("%02d：%02d：%02d", 
        math.floor(remain_second / 3600),
        math.floor(remain_second / 60 % 60),
        math.floor(remain_second % 60)))
end

function PROMStarHeroThreeLayer:setCurrentGift(idx, last_time, num, rmb, gift_list)
	self.btn_buy:getChildByTag(10):setString(string.format(ex.Tools:getLang(2705), tostring(rmb / 100)))
	self.btn_buy:setTag(idx)

    self.remain_num:setString(string.format("%s", num))
	self.last_time = last_time
	self.timer:run(handler(self, self.updateCDTime), 1.0)
	self:updateCDTime()

    local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")
    self.scroll_view.createItemFunction = function(item_data)
        local item = UIMenuItemBag:createWithData(item_data.item_type, item_data.item_num)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
		-- item:setFrameImage("festival-gift/item-bg.png")
		-- if item_data.item_type == ItemType.IT_GEM then
        --     item.icon_double = cc.Sprite:createWithSpriteFrameName("backpack/spr-double-1.png")
		-- 	item.icon_double:setAnchorPoint(0, 1)
		-- 	item.icon_double:setPosition(-20, item:getContentSize().height + 20)
		-- 	item:addChild(item.icon_double, 100)
        -- end
        return item
    end
	self.scroll_view:reloadData(gift_list)
end

function PROMStarHeroThreeLayer:onBtnInfo(tag, pSender)
	ex.Tools:onClickItemInfo(tag)
end

function PROMStarHeroThreeLayer:onBtnBuy(tag, pSender)
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

return PROMStarHeroThreeLayer