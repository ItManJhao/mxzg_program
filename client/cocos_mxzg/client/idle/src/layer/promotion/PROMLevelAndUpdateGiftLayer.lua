local PROMLevelAndUpdateGiftLayer = class("PROMLevelAndUpdateGiftLayer", require("src.layer.promotion.PromotionBaseLayer"))

function PROMLevelAndUpdateGiftLayer:onCreate()
    self.cur_gift_id = ""

    self.scroll_view_pos = {{0, 80.0, 500.0, 150.0},{0, 0, 500.0, 300.0}}

    self:setAutoClose(false)
    self:setSwallowTouches(false)
       
    self.node_reward:setPositionX((ex.p.width - self.node_reward:getContentSize().width) / 2)

    -- 调整彩色背景大小
    self.spr_bg:setPreferredSize(cc.size(ex.p.width, ex.p.height - 214))
    self.spr_bg:setPositionY(self.spr_bg:getPositionY() - require("src.model.Game"):instance():getNotchHeight())



    self.menu = cpp.UIMenu:create()
    self.menu:setIsTouchInsideNode(self.scroll_view)
    self.menu:setSwallowsTouches(false)
    self.menu:setPosition(0,0)
    self.scroll_view:getContainer():addChild(self.menu)
    self.scroll_view:setLocalZOrder(100)
    self.menu:setLocalZOrder(110)

    self.gift_menu:setLocalZOrder(200)

    self.btn_buy:registerScriptTapHandler(handler(self, self.onBtnBuy))
end

function PROMLevelAndUpdateGiftLayer:onCreateDone(gift_id)
    self.cur_gift_id = gift_id

    local giftData = ex.Player.promotion_data:getLimitGiftById(self.cur_gift_id)
	local config = cfg.buygem.buygem[giftData.idx]
	self:setCurrentGift(giftData.idx, giftData.last_time, giftData.num, config)
end

function PROMLevelAndUpdateGiftLayer:updateCDTime()
    local remain_second = self.last_time - ex.Game:getServerTime()
    if remain_second <= 0 then
    	-- 时间到删除节点 if 节点为空 返回主城 else 自动选择第一个节点
        self:removeTimerByName("level_and_update_timer")
    	self:updateLayer()
    end

    if remain_second > 86400 then
    	-- 大于1天
    	-- %d天
        self.remain:setString(string.format("%d%s", math.floor(remain_second / 86400), ex.Tools:getLang(31)))
        self.remain:setColor(cc.c4b(0, 255, 0, 255))
    else
    	-- %d小时%d分%d秒
        self.remain:setString(string.format("%d%s%d%s%d%s", math.floor(remain_second / 3600), ex.Tools:getLang(32), 
        math.floor(remain_second / 60 % 60), ex.Tools:getLang(33), 
        math.floor(remain_second % 60), ex.Tools:getLang(34)))
        self.remain:setColor(cc.c4b(255, 0, 0, 255))
    end
end

function PROMLevelAndUpdateGiftLayer:setCurrentGift(idx, last_time, num, config)
    local number = "0"
    if config.kind == RechargeKindType.UPGRADE_GIFT then
        local conf = cfg.promotionlimitedsetlevel.promotionlimitedsetlevel[config.idx]
        if conf ~= nil then
            number = tostring(conf.level)
        end
    else
        local conf = cfg.promotionlimitedsetchapter.promotionlimitedsetchapter[config.idx]
        if conf ~= nil then
            number = tostring(conf.chapter)
        end
    end

    self.label_num:setString(string.format(ex.Tools:getLang(2706), num))
    self.label_lv:setString(number)
    -- self.spr_txt:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("promotion/spr-txt-%d.png", config.kind)))
    ex.Tools:setSpriteFrame(self.spr_txt, string.format("promotion/spr-txt-%d.png", config.kind))
    
	self.btn_buy:setLabelText(string.format(ex.Tools:getLang(2705), tostring(config.rmb / 100)))
    self.btn_buy:setTag(idx)

	self.last_time = last_time
    self:addTimer("level_and_update_timer", 1000, handler(self, self.updateCDTime), true)
	self:updateCDTime()

    self.menu:removeAllChildren()
    
    local nums = table.nums(config.item)
    local count_line = math.floor((nums - 1) / 4) + 1
    local space = cc.size(8.0, 10.0)
    local cell_size = {}
    local item_scale = 1
    for i,v in ipairs(config.item) do
        local item = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item:setScale(item_scale)
        item:registerScriptTapHandler(handler(self, self.onBtnInfo))
        self.menu:addChild(item)
        
        local item_size = item:getContentSize()
        local bg = cc.Sprite:createWithSpriteFrameName("win-bg/cell-bg-7.png")
        bg:setAnchorPoint(ex.a.bottom_center)
		bg:setPosition(item_size.width / 2, -5)
        item:addChild(bg, -100)
        
        local line = count_line - math.floor((i - 1) / 4)
        local row = i % 4
        if row == 0 then
            row = 4
        end
        cell_size = bg:getContentSize()
        local pos_x = (row - 0.5) * cell_size.width * item_scale + (row - 1) * space.width
        local pos_y = (line - 0.5) * cell_size.height * item_scale + (line - 1) * space.height
        
        item:setPosition(pos_x, pos_y)
    end
    
    if nums > 0 then
        if nums > 4 then
            self.scroll_view:setViewSize(cc.size(self.scroll_view_pos[2][3], self.scroll_view_pos[2][4]))
            self.scroll_view:setPosition(cc.p(self.scroll_view_pos[2][1], self.scroll_view_pos[2][2]))
            self.scroll_view:setContentSize(cc.size(self.scroll_view_pos[2][3], count_line * (cell_size.height * item_scale + space.height) + space.height))
        else
            self.scroll_view:setViewSize(cc.size(self.scroll_view_pos[1][3], self.scroll_view_pos[1][4]))
            self.scroll_view:setPosition(cc.p(self.scroll_view_pos[1][1], self.scroll_view_pos[1][2]))
            self.scroll_view:setContentSize(cc.size(self.scroll_view_pos[1][3], count_line * (cell_size.height * item_scale + space.height) + space.height))
        end
    end

    self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset(), false)
end

function PROMLevelAndUpdateGiftLayer:onBtnInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type, pSender.item_num)
end

function PROMLevelAndUpdateGiftLayer:onBtnBuy(tag, pSender)
    if self.last_time < ex.Game:getServerTime() then
        ex.MessageView:add(ex.Tools:getLang(47740))
        return
    end

	--print("onBtnBuy...idx = "..tag)
	--print("onBtnBuy...cur_gift_id = "..self.cur_gift_id)
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
    -- --     self.label_num:setString(string.format(ex.Tools:getLang(2706), giftData.num))
    -- end
end

return PROMLevelAndUpdateGiftLayer