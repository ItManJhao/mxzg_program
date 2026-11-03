local RCGVipLayer = class("RCGVipLayer", require("src.layer.promotion.PromotionBaseLayer"))

-------------------------------------RCGVipLayer--------------------------------------------------
function RCGVipLayer:onCreateDone()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local top_y = self.layer_promotion:getTopY()
    local cell = self:addVipExpCell()
    
    -- self.node_banner:setPositionY(top_y - 20)
    local win_size = cc.Director:getInstance():getWinSize()
    self.spr_bg1:setPositionY(cell:getPositionY())
    self.spr_bg1:setContentSize(cc.size(self.spr_bg1:getContentSize().width, self.spr_bg1:getPositionY() - self.layer_promotion:getBottomY() - 40))

    --self.spr_bg1:setContentSize(self.spr_rcg_bg:getContentSize().width, win_size.height * 0.45)
    self.spr_vip_bg:setPosition(self.spr_bg1:getPositionX() - self.spr_bg1:getContentSize().width * 0.5 + 5 + self.spr_vip_bg:getContentSize().width * 0.5,
                                self.spr_bg1:getPositionY() - 5);
    self.spr_vip_bg:setContentSize(self.spr_vip_bg:getContentSize().width, self.spr_bg1:getContentSize().height - 10)
    self.scroll_view_vip:setPosition(self.spr_vip_bg:getPositionX(), self.spr_vip_bg:getPositionY() - 3.5)
    self.scroll_view_vip:setViewSize(cc.size(self.spr_vip_bg:getContentSize().width - 7, self.spr_vip_bg:getContentSize().height - 7))
    --self.scroll_view_vip:addChild(cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, 1000, 1000))

    -- 适配月卡
    self.node_monthly:setPosition(self.spr_vip_bg:getPositionX() + 60 + 5, self.spr_bg1:getPositionY() - 5)
    self.node_monthly:setScale( (self.spr_bg1:getPositionX() + self.spr_bg1:getContentSize().width * 0.5 - self.node_monthly:getPositionX() - 5) /  self.spr_monthly_bg:getContentSize().width)

    -- 适配特权背景
    self.spr_level_bg:setPositionX(self.spr_vip_bg:getPositionX() + 60 + 5)
    self.spr_level_bg:setPositionY(self.node_monthly:getPositionY() - self.spr_monthly_bg:getContentSize().height * self.node_monthly:getScale() - 5)
    self.spr_level_bg:setContentSize(self.spr_bg1:getPositionX() + self.spr_bg1:getContentSize().width * 0.5 - self.spr_level_bg:getPositionX() - 5,
                                    self.spr_bg1:getContentSize().height - 250 - self.spr_monthly_bg:getContentSize().height * self.node_monthly:getScale() - 5)
    --self.scroll_view_privilege:addChild(cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, 1000, 1000))
    self.spr_level:setPosition(self.spr_level_bg:getPositionX() - 4, self.spr_level_bg:getPositionY() - 8)
    self.scroll_view_privilege:setPosition(self.spr_level_bg:getPositionX() + 20,
                                           self.spr_level:getPositionY() - 45)
    self.scroll_view_privilege:setViewSize(cc.size(self.spr_level_bg:getContentSize().width * 0.9, self.spr_level_bg:getContentSize().height - 45 - 20))


    -- 适配礼包背景
    self.spr_reward_bg:setPosition(self.spr_level_bg:getPositionX(), self.spr_bg1:getPositionY() - self.spr_bg1:getContentSize().height + self.spr_reward_bg:getContentSize().height + 5)
    self.spr_reward_bg:setContentSize(self.spr_level_bg:getContentSize().width, self.spr_reward_bg:getContentSize().height)
    self.spr_reward:setPosition(self.spr_reward_bg:getPositionX() - 4, self.spr_reward_bg:getPositionY() - 8)
    self.scroll_view_reward:setPosition(self.spr_reward_bg:getPositionX() + 20, self.spr_reward_bg:getPositionY() - 50)
    self.scroll_view_reward:setViewSize(cc.size(self.scroll_view_privilege:getViewSize().width, self.scroll_view_reward:getViewSize().height))
    --self.scroll_view_reward:addChild(cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, 1000, 1000))

    ex.Tools:setGray(self.btn_buy:getDisabledImage())
    self.btn_buy:setPosition(self.spr_reward_bg:getPositionX() + self.spr_reward_bg:getContentSize().width - 90, self.spr_reward_bg:getPositionY() - self.spr_reward_bg:getContentSize().height + 45)

    -- 创建vip按钮
    self.scroll_view_vip:getContainer():removeAllChildren()


    local vec_vip = {}
    local index = 0
    local num = table.nums(cfg.vip.vip)
    for i=1,num do
        print("i", i)
        if ex.Player.vip_level >= cfg.vip.vip[index].vip_show_level then
            table.insert(vec_vip, cfg.vip.vip[index])
        end
        index = index + 1
    end



    local menu = cpp.UIMenu:create()
    menu:setSwallowsTouches(false)
    menu:setPosition(0, 0)
    menu:setIsTouchInsideNode(self.scroll_view_vip)
    self.scroll_view_vip:getContainer():addChild(menu)
    local btn_size = cc.size(0, 60)
    local height = table.nums(cfg.vip.vip) * btn_size.height
    height = math.max(height , self.scroll_view_vip:getViewSize().height)
    self.scroll_view_vip:setContentSize(cc.size(self.scroll_view_vip:getViewSize().width, height))

    index = 0
    num = table.nums(vec_vip)

    -- 创建vip按钮
    -- for i=1,num do
    for i,v in ipairs(vec_vip) do
        local config = vec_vip[i]
        local item_vip = cpp.UIMenuItemTab:create("button/btn-yellow-1.png",
                                                  "button/btn-yellow-2.png",
                                                   string.format(ex.Tools:getLang(47393), config.vip_level),
                                                   1,
                                                   nil)
        item_vip:setLabelColor(FONT_BLACK)
        item_vip:setPosition(self.scroll_view_vip:getViewSize().width * 0.5, height - (i - 0.5) * btn_size.height)
        item_vip:registerScriptTapHandler(handler(self, self.updateReward))
        item_vip:setTag(config.vip_level)
        menu:addChild(item_vip)
        self["item_vip"..config.vip_level] = item_vip
        -- index = index + 1
    end

    -- 选中当前VIP按钮
    local max_vip_level = table.nums(cfg.vip.vip) 
    local now_level = math.min(max_vip_level, ex.Player.vip_level)
    if self["item_vip"..now_level] then
        self["item_vip"..now_level]:setChecked(true)
        local y = Maths.clampf(-(self["item_vip"..now_level]:getPositionY() - self.scroll_view_vip:getViewSize().height * 0.5),
                         0,
                         self.scroll_view_vip:getViewSize().height - self.scroll_view_vip:getContentSize().height)
        self.scroll_view_vip:setContentOffset(cc.p(0, y))
    end
    
    self:updateLayer()

    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_CZ_HYTQ_ZZMRJL, self.btn_monthly)
    -- self:updateReward(now_level)
end

function RCGVipLayer:onExit()
    ex.RedDotManager:removeStickNode(RedDotType.ZCJ_DHZC_CZ_HYTQ_ZZMRJL, self.btn_monthly)
end

function RCGVipLayer:updateLayer()
    ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.PROMATION_VIP_EXP)
    -- 更新VIP特权
    self:updateReward(ex.Player.vip_level)
end


function RCGVipLayer:updateReward(level)
    -- print("level", level)

    -- 更新等级特权
    local vec_text = {}
    local max_vip_level = table.nums(cfg.vip.vip) - 1
    local now_level = level
    local pre_level = level - 1
    local config_now = cfg.vip.vip[now_level]
    local config_pre = cfg.vip.vip[pre_level]
    if not config_pre then
        config_pre = {}
        config_pre.point_summon_unlock = 0
        config_pre.battle_speed_2x = 0
        config_pre.battle_skip = 0
        config_pre.tavern = 5
        config_pre.charater_exp_bonus = 0
        config_pre.gold_bonus = 0
        config_pre.heroes_exp_bonus = 0
        config_pre.extra_idle_time = 0
        config_pre.buy_gold_bonus = 0
        config_pre.extra_bag_space = 0
        config_pre.extra_resource_times = 0
    end


    local vec_key = {}
    for k,v in pairs(cfg.viptext.viptext) do
        -- v.index 为显示的顺序
        vec_key[v.index] = k
    end


    for i,v in ipairs(vec_key) do
        -- table.insert(vec_text, string.format(ex.Tools:getLang(47219), config_now.extra_bag_space))
        local config_text = cfg.viptext.viptext[v]
        -- 如果上一级跟当前等级的属性不符合时。则显示对应的权益
        if config_now[v] ~= config_pre[v] then
            table.insert(vec_text, string.format(ex.Tools:getLang(config_text.text), config_now[v] / config_text.divisor))
        end
    end

    -- 如果所有的权益都为空时。添加假的权益
    if table.nums(vec_text) <= 0 then
        table.insert(vec_text, string.format(ex.Tools:getLang(47574), 150))
        table.insert(vec_text, string.format(ex.Tools:getLang(47274), 10))
        table.insert(vec_text, string.format(ex.Tools:getLang(47356), 2))
        table.insert(vec_text, string.format(ex.Tools:getLang(47455), 3))
    end


    -- -- 战斗2倍速度解锁
    -- if config_now.battle_speed_2x ~= config_pre.battle_speed_2x then
    --     table.insert(vec_text, ex.Tools:getLang(47552))
    -- end

    -- -- 战斗跳过功能解锁
    -- if config_now.battle_skip ~= config_pre.battle_skip then
    --     table.insert(vec_text, ex.Tools:getLang(47626))
    -- end
    
    -- -- 召唤法阵开启积分召唤
    -- if config_now.point_summon_unlock ~= config_pre.point_summon_unlock then
    --     table.insert(vec_text, ex.Tools:getLang(47017))
    -- end
    
    -- -- 酒馆任务数量变更
    -- if config_now.tavern ~= config_pre.tavern then
    --     table.insert(vec_text, string.format(ex.Tools:getLang(47268), config_now.tavern))
    -- end

    -- -- 背包额外上限
    -- if config_now.extra_bag_space ~= config_pre.extra_bag_space then
    --     table.insert(vec_text, string.format(ex.Tools:getLang(47219), config_now.extra_bag_space))
    -- end

    -- -- 日常副本购买次数
    -- if config_now.extra_resource_times ~= config_pre.extra_resource_times then
    --     table.insert(vec_text, string.format(ex.Tools:getLang(47750), config_now.extra_resource_times))
    -- end

    -- -- 点金额外加成
    -- if config_now.buy_gold_bonus ~= config_pre.buy_gold_bonus then
    --     table.insert(vec_text, string.format(ex.Tools:getLang(47348), config_now.buy_gold_bonus))
    -- end

    -- -- 角色挂机经验
    -- if config_now.charater_exp_bonus ~= config_pre.charater_exp_bonus then
    --     table.insert(vec_text, string.format(ex.Tools:getLang(47027), config_now.charater_exp_bonus))
    -- end

    -- -- 金币挂机收益
    -- if config_now.gold_bonus ~= config_pre.gold_bonus then
    --     table.insert(vec_text, string.format(ex.Tools:getLang(47437), config_now.gold_bonus))
    -- end

    -- -- 英雄经验挂机收益
    -- if config_now.heroes_exp_bonus ~= config_pre.heroes_exp_bonus then
    --     table.insert(vec_text, string.format(ex.Tools:getLang(47535), config_now.heroes_exp_bonus))
    -- end

    -- -- 额外挂机时间
    -- if config_now.extra_idle_time ~= config_pre.extra_idle_time then
    --     table.insert(vec_text, string.format(ex.Tools:getLang(47477), config_now.extra_idle_time / 3600))
    -- end

    local text_size = cc.size(0, 30)
    local height = table.nums(vec_text) * text_size.height
    height = math.max(height , self.scroll_view_privilege:getViewSize().height)
    self.scroll_view_privilege:getContainer():removeAllChildren()
    self.scroll_view_privilege:setContentSize(cc.size(self.scroll_view_privilege:getViewSize().width, height))
    self.scroll_view_privilege:setContentOffset(cc.p(0, self.scroll_view_privilege:getViewSize().height - height))

    for i,v in ipairs(vec_text) do
        local lbl_content = cpp.RichTextEx:createWithXMLLua("")
        :setFontSize(42)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#653F1D")
        :setScale(0.5)
        :setAnchorTextShadow(true)
        :ignoreContentAdaptWithSize(false)
        :setWrapMode(1)
        :setContentSize(cc.size(1000, 50))
        :setPosition(cc.p(0, height - (i - 0.5) * text_size.height))
        :setAnchorPoint(cc.p(0, 0.5))
        -- lbl_content:enableShadow(FONT_BLACK_C4B, cc.size(1, -1), 0)
        -- lbl_content:enableOutline(FONT_BLACK_C4B, 0)
        self.scroll_view_privilege:getContainer():addChild(lbl_content)
        lbl_content:setXmlTextLua(vec_text[i])
    end

    -- 更新特权礼包
    local vec_item = config_now.vip_pack
    local item_size = cc.size(90, self.scroll_view_reward:getViewSize().height)
    local width = table.nums(vec_item) * item_size.width
    width = math.max(width , self.scroll_view_reward:getViewSize().width)
    self.scroll_view_reward:setContentSize(cc.size(width, 0))
    -- self.scroll_view_reward:setContentOffset(cc.p(self.scroll_view_reward:getViewSize().width - width, 0))
    self.scroll_view_reward:setContentOffset(cc.p(0, 0))

    self.scroll_view_reward:getContainer():removeAllChildren()
    local menu = cpp.UIMenu:create()
    menu:setSwallowsTouches(false)
    menu:setPosition(0, 0)
    menu:setIsTouchInsideNode(self.scroll_view_reward)
    self.scroll_view_reward:getContainer():addChild(menu)

    local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
    local UIMenuItemHeroPiece = require("src.comp.menu.UIMenuItemHeroPiece")
    local index = 1
    for i,v in ipairs(vec_item) do
        local item = nil
        if ex.Player.backpack_data:isPiece(v.item_type) then
            item = UIMenuItemHeroPiece:createWithData(v.item_type)
            item:setNum(v.item_num)
        else
            item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
            item:setFrame(2)
        end

        item:setPosition((index - 0.5) * item_size.width, item_size.height * 0.5)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setScale(0.7)
        menu:addChild(item)
        index = index + 1
    end

    -- 更新购买按钮
    self.btn_buy.data = config_now

    local is_buy = TableEx.findFunction(ex.Player.promotion_data.vip_list, function(value)
        if value == self.btn_buy.data.vip_level then
            return true
        end
    end)

    if is_buy then
        self.btn_buy:setLabelText(ex.Tools:getLang(47247))
        self.btn_buy:setLabelOffset(cc.p(0, 0))
        if self.btn_buy.spr_res ~= nil then
            self.btn_buy.spr_res:removeFromParent()
            self.btn_buy.spr_res = nil
        end
        self.btn_buy:setEnabled(false)
    else
        self.btn_buy:setLabelText(string.format("%d", config_now.pack_cost[1].item_num))
        ex.Tools:addImgToUIMenuItemLabel(self.btn_buy, nil, "backpack/900002.png", 0.5, 0)
        self.btn_buy:setEnabled(true)
    end


    -- 月卡奖励
    self.menu_reward:removeAllChildren()
    index = 1
    item_size = cc.size(50, 0)

    local gift_every_day = config_now.gift_every_day == "" and {} or config_now.gift_every_day
    for i,v in ipairs(gift_every_day) do
        local item = nil
        if ex.Player.backpack_data:isPiece(v.item_type) then
            item = UIMenuItemHeroPiece:createWithData(v.item_type)
            item:setNum(v.item_num)
        else
            item = UIMenuItemBackpack:createWithData(v.item_type, v.item_num)
            item:setFrame(2)
        end
        item:setPosition(135 + (index - 0.5) * item_size.width, -70.0)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        item:setScale(0.4)
        self.menu_reward:addChild(item)
        index = index + 1
    end

    self.btn_monthly:setVisible(self.btn_buy.data.vip_level == ex.Player.vip_level)
    self.btn_monthly:registerScriptTapHandler(handler(self, self.onRewardMonthly))
    if ex.Player.promotion_data:hasSuperCard() == false then
        self.btn_monthly:setLabelText(ex.Tools:getLang(47464))
        self.btn_monthly:setVisible(true)
        -- self.btn_monthly:setEnabled(false)
        self.btn_monthly:registerScriptTapHandler(handler(self, self.onSuperCard))
    elseif ex.Player.promotion_data:isRewardSuperCard() then
        self.btn_monthly:setLabelText(ex.Tools:getLang(47677))
        self.btn_monthly:setEnabled(false)
    else
        self.btn_monthly:setLabelText(ex.Tools:getLang(47695))
        self.btn_monthly:setEnabled(true)
    end
    self.btn_monthly:setLabelOutLine(FONT_BLACK_C4B)
end

function RCGVipLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function RCGVipLayer:onBuyPrivilege(tag, pSender)
    --print(ex.Tools:getLang(47363))
    local need_gem = self.btn_buy.data.pack_cost[1].item_num
    if ex.Player.gem < need_gem then
        ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
        return
    end

    if ex.Player.vip_level < self.btn_buy.data.vip_level then
        ex.MessageView:add(string.format(ex.Tools:getLang(47052), self.btn_buy.data.vip_level), 0)
        return
    end

    local is_buy = TableEx.findFunction(ex.Player.promotion_data.vip_list, function(value)
        if value == self.btn_buy.data.vip_level then
            return true
        end
    end)

    if is_buy then
        ex.MessageView:add(ex.Tools:getLang(47563))
        return
    end
    
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(47590), string.format(ex.Tools:getLang(47630), need_gem), handler(self, self.onBuyPrivilegeDone))

end

function RCGVipLayer:onBuyPrivilegeDone(tag, pSender)
    if ex.Player.vip_level < self.btn_buy.data.vip_level  then
        ex.MessageView:add(string.format(ex.Tools:getLang(47052), self.btn_buy.data.vip_level), 0)
        return
    end

    local is_buy = TableEx.findFunction(ex.Player.promotion_data.vip_list, function(value)
        if value == self.btn_buy.data.vip_level then
            return true
        end
    end)

    if is_buy then
        ex.MessageView:add(ex.Tools:getLang(47563))
        return
    end
    
    -- for k,v in pairs(self.btn_buy.data.pack_cost) do
        -- ex.Player:addItem(v.item_type, -v.item_num)
    -- end

    table.insert(ex.Player.promotion_data.vip_list, self.btn_buy.data.vip_level)
    
    local req_vip_buy = Promotion_pb.GReqVipRewardBuy()
	req_vip_buy.vip_level = self.btn_buy.data.vip_level
	NetManager:sendMessage(ProtocolID.GReqVipRewardBuy, req_vip_buy)
    
    self:updateReward(self.btn_buy.data.vip_level)
end

function RCGVipLayer:onRewardMonthly(tag, pSender)
    if ex.Player.promotion_data:hasSuperCard() == false then
        ex.MessageView:add(ex.Tools:getLang(47024))
        return
    end
    
    -- 至尊月卡奖励
    NetManager:sendMessage(ProtocolID.GReqMonthVipReward)

    -- 发送协议
    ex.Player.promotion_data:rewardSuperCard()
    self:updateReward(self.btn_buy.data.vip_level)
end

function RCGVipLayer:onSuperCard(tag, pSender)
    -- 跳转到至尊月卡界面
    local vec_idx = ex.Player.promotion_data:getPromotionByType(RechargeKindType.PROMOTION)
    local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_DAILY_CHECK)
    layer:initWithTable(nil, vec_idx, 3)

end

return RCGVipLayer