local BlessingPoolLayer = class("BlessingPoolLayer", require("src.comp.EventLayer"))

--local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

local ExTimer = require("src.ex.ExTimer")

local PoolType = {}
PoolType.common = 1
PoolType.senior = 2
local ATOM = "main_blessingpool"

local PreRad = 45.0

-----------------------------------------------------------------------------

function BlessingPoolLayer:getAsynImage()
    local vec_image = {
        -- {image_name = "ccbi-res/map-bg-blessing-pool-1.jpg", remove_type=1},
        {image_name = "ccbi-res/map-bg-blessing-pool-2.jpg", remove_type=1},
    }
    return vec_image
end

function BlessingPoolLayer:onCreate()
	--ex.log("BlessingPoolLayer:onCreate")
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.spr_bg = cc.Sprite:create("ccbi-res/map-bg-blessing-pool-2.jpg")
    self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width, ex.p.height / self.spr_bg:getContentSize().height)
    self.spr_bg:setPosition(ex.p.center().x - self:getPositionX(), ex.p.center().y - self:getPositionY())
    self:addChild(self.spr_bg, -1)
    
    self.spr_bg_bottom:setLocalZOrder(1000)
    self.spr_bg_bottom:setScaleX(self.spr_bg:getScaleX())
    self.spr_bg_bottom:setScaleY(self.spr_bg:getScaleY())
    self.spr_bg_bottom:setPosition(self:getContentSize().width / 2, -(ex.p.height - self:getContentSize().height) / 2 + 34)
    
    local spr_tmp = cc.Sprite:create()
    spr_tmp:setFlippedX(true)
    spr_tmp:setPosition(self.spr_bg_bottom:getContentSize().width * 0.63, self.spr_bg_bottom:getContentSize().height - 220)
    self.spr_bg_bottom:addChild(spr_tmp, -1)
    
    local spine_girl = sp.SkeletonAnimation:create("spine/act.json", "spine/act.atlas", 1)
    spine_girl:setAnimation(0, "act", true)
    spine_girl:setScaleX(-0.75);
    spine_girl:setScaleY(0.75)
    spine_girl:setPosition(0, 0)
    spr_tmp:addChild(spine_girl, -1)
    
    self.lbl_time:setLocalZOrder(10000)

    self.btn_common:registerScriptTapHandler(handler(self, self.onBtnChangePool))
    self.btn_senior:registerScriptTapHandler(handler(self, self.onBtnChangePool))

    self.btn_refresh:registerScriptTapHandler(handler(self, self.onBtnRefresh))

    self.btn_back:setPositionY(self.btn_back:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.btn_info:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width * 0.5 - self.btn_info:getContentSize().width * 0.5, self.btn_back:getPositionY() - 60)
    
    self.btn_one:setTag(1)
    self.btn_ten:setTag(10)
    self.btn_one:registerScriptTapHandler(handler(self, self.onBtnTurn))
    self.btn_ten:registerScriptTapHandler(handler(self, self.onBtnTurn))

    local spr_effect_one = ex.EffectFactory:createEffectWithNodeByName("eff_wishpool_btn_one")
    spr_effect_one:setPosition(self.btn_ten:getContentSize().width / 2, self.btn_ten:getContentSize().height / 2)
    self.btn_ten:addChild(spr_effect_one, 10)

    -- local spr_effect_ten = ex.EffectFactory:createEffectWithNodeByName("eff_wishpool_btn_ten")
    -- spr_effect_ten:setPosition(self.btn_ten:getContentSize().width / 2, self.btn_ten:getContentSize().height / 2)
    -- self.btn_ten:addChild(spr_effect_ten, 10)

    self.node_btn_refresh = cc.Node:create()
    self.node_btn_one = cc.Node:create()
    self.node_btn_ten = cc.Node:create()

    self.btn_refresh:addChild(self.node_btn_refresh)
    self.btn_one:addChild(self.node_btn_one)
    self.btn_ten:addChild(self.node_btn_ten)

    self.btn_size = self.btn_refresh:getContentSize()
    self.btn_size.width = self.btn_size.width / 2
    self.btn_size.height = self.btn_size.height / 2

    self.spr_rd2_2:setFlippedY(true)

    -- self.node_rd:setRotation(PreRad / 2)

    -- 设置幸运值节点
    self.progress_timer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("blessing-pool/spr-progress-fg2.png"))
    self.progress_timer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.progress_timer:setMidpoint(cc.p(0, 0.5))
	self.progress_timer:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.progress_timer:setPosition(self.lucky_progress_bg:getContentSize().width / 2 ,self.lucky_progress_bg:getContentSize().height / 2 )
    self.lucky_progress_bg:addChild(self.progress_timer)

    self.lucky_gift_menu:setLocalZOrder(10)

    self.lucky_gift_btns = {
        {
            btn = self.lucky_gift_1,
            lbl_lucky = self.lucky_lbl_1,
            icon = nil,
            lbl_num = nil
        },
        {
            btn = self.lucky_gift_2,
            lbl_lucky = self.lucky_lbl_2,
            icon = nil,
            lbl_num = nil
        },
        {
            btn = self.lucky_gift_3,
            lbl_lucky = self.lucky_lbl_3,
            icon = nil,
            lbl_num = nil
        },
        {
            btn = self.lucky_gift_4,
            lbl_lucky = self.lucky_lbl_4,
            icon = nil,
            lbl_num = nil
        },
        {
            btn = self.lucky_gift_5,
            lbl_lucky = self.lucky_lbl_5,
            icon = nil,
            lbl_num = nil
        }
    }
    self.cur_pool_type = PoolType.common

    self.lucky_gift_1:registerScriptTapHandler(handler(self, self.onLuckyReward))
    self.lucky_gift_2:registerScriptTapHandler(handler(self, self.onLuckyReward))
    self.lucky_gift_3:registerScriptTapHandler(handler(self, self.onLuckyReward))
    self.lucky_gift_4:registerScriptTapHandler(handler(self, self.onLuckyReward))
    self.lucky_gift_5:registerScriptTapHandler(handler(self, self.onLuckyReward))

    -- 加红点
    self:addRedDotNode(RedDotType.ZCJ_DHZC_XYC_PTXY, self.btn_common)
    self:addRedDotNode(RedDotType.ZCJ_DHZC_XYC_GJXY, self.btn_senior)

    -- 奖品刷新时间
    self.reset_time = GetSystemResetTime()

    -- self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
    -- self:updateCDTime()
    self.lbl_time:setVisible(false)
    self:updateCdTimeShow()

    self.turnTimer = ExTimer:new():bind(self)

    self:initSwallowLayer()

    self:initDone()

    -- 许愿球特效
    -- local ball_effect_path = "blessing-pool-effect/blessing-pool-ball-anim-%d.png"
    local ball_effect_sprite = ex.EffectFactory:createEffectWithNodeByName("eff_wishpool_ball_light")
    self.spr_bg_bottom:addChild(ball_effect_sprite)
    ball_effect_sprite:setPosition(cc.p(114, 205))
    ball_effect_sprite:setScale(1.3)

    -- 灯特效
    local light_effect_sprite = cc.Sprite:createWithSpriteFrameName("blessing-pool-effect/blessing-pool-light.png")
    self.spr_bg_bottom:addChild(light_effect_sprite)
    light_effect_sprite:setPosition(cc.p(526, 205))

    local fadeto = cc.FadeTo:create(2, 255)
    local fadeout = cc.FadeTo:create(2, 50)
    light_effect_sprite:runAction(cc.RepeatForever:create(cc.Sequence:create(fadeout, fadeto, nil)))
    self:registerBtnWithCondition()

    self.is_need_stopcallback = false

    self:addEvent(EVENT.BLESSINGPOOL_EVENT.UPDATE_CURRENCY,handler(self,self.onCurrency))
end

function BlessingPoolLayer:onCurrency(event,data)
    local val_one = ex.Player.blessing_pool:getNeedItem(self.cur_pool_type, 1)
    local val_ten = ex.Player.blessing_pool:getNeedItem(self.cur_pool_type, 10)

    -- self.spr_icon:setSpriteFrame(string.format("backpack/%d.png", val_one.item_type))
    ex.Tools:setSpriteFrame(self.spr_icon, string.format("backpack/%d.png", val_one.item_type))

    self.hasItemNum = ex.Player:getItemNum(val_one.item_type)
    self.lbl_num:setString(tostring(self.hasItemNum))
end

function BlessingPoolLayer:registerBtnWithCondition()
    local system_data = ex.JumpManager:getSystemDataByAtom(ATOM)
    for i,v in pairs(PoolType) do
        local btn = self.menu:getChildByTag(v)
        if btn ~= nil then 
            local child_data = system_data[v]
            if child_data ~= nil then 
                btn:setName(child_data.atom)
            end
        end
    end
end

--触摸吞噬
function BlessingPoolLayer:initSwallowLayer()
    self.touch_layer = cc.Layer:create()
    self.touch_layer:setTouchEnabled(true)
    self.touch_layer:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    self.touch_layer:registerScriptTouchHandler(function(event)
        if event == "began" then
            return true
        end
    end)
    self:addChild(self.touch_layer, 100)
end

function BlessingPoolLayer:touchSwallowTouches(is_lock)
    self.touch_layer:setSwallowsTouches(is_lock)
end

function BlessingPoolLayer:updateCDTime()
    local refresh_time = ex.Player.blessing_pool:getRefreshTime(self.cur_pool_type)
    local sys_time = ex.Game:getServerTime()
    local show_time = refresh_time - sys_time
    if show_time > 0 then
        self.lbl_time:setVisible(true)
        self.lbl_time:setString(string.format(ex.Tools:getLang(2304), 
        math.floor(show_time / 3600),
        math.floor(show_time / 60 % 60),
        math.floor(show_time % 60)))
    else
        self.lbl_time:setVisible(false)
        -- 发送更新许愿池协议
        if self.timer then
            self.timer:stop()
            self.timer = nil
        end
        NetManager:sendMessage(ProtocolID.GReqBlessingPoolList)
    end
end

function BlessingPoolLayer:setBtnNode(node, color, name, value, icon_type)
    node:removeAllChildren()

    -- 按钮文字
    local lbl_btn_txt= cc.Label:createWithTTF(name, FONT_DEFAULT_NAME_BOLD, 24)
    :setTextColor(color)
    :setPosition(self.btn_size.width, self.btn_size.height + 13)
    node:addChild(lbl_btn_txt)

    local lbl_value = cc.Label:createWithTTF(tostring(value), FONT_DEFAULT_NAME_BOLD, 40) -- 20
    :setTextColor(color)
    :setScale(0.5)
    :setPosition(self.btn_size.width + 4, self.btn_size.height - 14)
    node:addChild(lbl_value)

    local spr_icon = cc.Sprite:createWithSpriteFrameName(string.format("backpack/%d.png", icon_type))
    :setScale(0.25)
    :setPosition(self.btn_size.width - 30, self.btn_size.height - 14)
    node:addChild(spr_icon)
end

function BlessingPoolLayer:updateBtnNode()
    if self.cur_pool_type == PoolType.common then
       self.refresh_cost = ex.Tools:getSysCfg("wishpool_normal_refresh_cost_gem")
       self.gain_item_key = "wishpool_normal_gain_item_each_play"
       self.free_refresh_times = ex.Tools:getSysCfg("blessing_pool_normal_daily_free_times")
    elseif self.cur_pool_type == PoolType.senior then
       self.refresh_cost = ex.Tools:getSysCfg("wishpool_advance_refresh_cost_gem")
       self.gain_item_key = "wishpool_advance_gain_item_each_play"
       self.free_refresh_times = ex.Tools:getSysCfg("blessing_pool_advance_daily_free_times")
    end

    ex.Player.blessing_pool.gain_item_key = self.gain_item_key

    local val_one = ex.Player.blessing_pool:getNeedItem(self.cur_pool_type, 1)
    local val_ten = ex.Player.blessing_pool:getNeedItem(self.cur_pool_type, 10)

    -- self.spr_icon:setSpriteFrame(string.format("backpack/%d.png", val_one.item_type))
    ex.Tools:setSpriteFrame(self.spr_icon, string.format("backpack/%d.png", val_one.item_type))

    self.hasItemNum = ex.Player:getItemNum(val_one.item_type)
    self.lbl_num:setString(tostring(self.hasItemNum))
    
    local refresh_times = ex.Player.blessing_pool.refresh_times[self.cur_pool_type]
    if refresh_times == nil or refresh_times < self.free_refresh_times then
        self.node_btn_refresh:removeAllChildren()
        
        -- 免费刷新
        local lbl_free = cc.Label:createWithTTF(ex.Tools:getLang(47095), FONT_DEFAULT_NAME_BOLD, 40)
        :setTextColor(cc.c3b(67,22,17))
        :setScale(0.5)
        :setPosition(self.btn_size.width, self.btn_size.height)
        self.node_btn_refresh:addChild(lbl_free)
    else
        self:setBtnNode(self.node_btn_refresh, cc.c3b(67,22,17), ex.Tools:getLang(2203),
            self.refresh_cost, ItemType.IT_GEM)
    end

    self:setBtnNode(self.node_btn_one, cc.c3b(67,22,17), ex.Tools:getLang(2302),
        val_one.item_num, val_one.item_type)
    self:setBtnNode(self.node_btn_ten, cc.c3b(67,22,17), ex.Tools:getLang(2303),
        val_ten.item_num, val_ten.item_type)
end

function BlessingPoolLayer:initDone()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/blessing-pool.plist")
    sfc:addSpriteFrames("ccbi-res/blessing-pool-effect-1.plist")
    sfc:addSpriteFrames("ccbi-res/blessing-pool-effect-2.plist")

    local poolPos = cc.p(self.node_rd_1:getPositionX(), self.node_rd_1:getPositionY())

    -- 奖品节点
    self.poolMenu = cpp.UIMenu:create()
    :setPosition(poolPos)
    self:addChild(self.poolMenu)

    -- 指针
    -- self.spr_pointer = cc.Sprite:createWithSpriteFrameName("blessing-pool/pointer.png")
    -- :setAnchorPoint(0.5, 24.5 / 153.0)
    -- :setScale(self.node_rd:getScale())
    -- :setPosition(poolPos)
    -- self:addChild(self.spr_pointer)
    -- 随机指针初始位置
    math.randomseed(ex.Game:getServerMillisecond())
    self.spr_pointer:setRotation(math.random(360))
    self.spr_pointer:setLocalZOrder(100)

    -- 特效
    self.spr_effect = nil

    self.cur_pool_type = 0
    self:changePool(PoolType.common)
end

function BlessingPoolLayer:removeEffect()
    if self.spr_effect then
        self.spr_effect:removeFromParent()
        self.spr_effect = nil
    end
end

function BlessingPoolLayer:onExit()
    -- 跳到中奖界面
    self:stopRotateCallback()

    -- 停止计时器
    if self.timer then
        self.timer:stop()
        self.timer = nil
    end

    self.turnTimer:stop()

    self:unscheduleUpdate()
end

function BlessingPoolLayer:setPointerSleep()
    self.spr_pointer:stopAllActions()
    self.spr_pointer:runAction(cc.RepeatForever:create(cc.RotateBy:create(1.0, 5)))
end

function BlessingPoolLayer:setPointerStart()
    self.spr_pointer:stopAllActions()
    self.turnRad = self.spr_pointer:getRotation()
    self.fDeltaRad = 0
    self.turnState = 0

    -- 特效
    self:removeEffect()

    self.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_wishpool_circle_light")
    self.spr_effect:setPosition(self.node_rd_1:getPositionX(), self.node_rd_1:getPositionY())
    self.spr_effect:setScale(1.2 * self.node_rd_1:getScale())
    self:addChild(self.spr_effect)

    self.turnSndDelta = 0
    ex.AudioManager:playEffect(string.format("music/bless-start.mp3", false))
end

function BlessingPoolLayer:changeStyle(pool_type)
    self.node_rd_1:setVisible(pool_type == PoolType.common)
    self.node_rd_2:setVisible(pool_type == PoolType.senior)

    -- local filename = pool_type == PoolType.common and "ccbi-res/map-bg-blessing-pool-1.jpg" or "ccbi-res/map-bg-blessing-pool-2.jpg"
    -- local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(filename)
    -- if texture then
    --     self.spr_bg:setTexture(texture)
    -- end
end

function BlessingPoolLayer:refreshTabRedDot()
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_XYC_PTXY, self.cur_pool_type ~= PoolType.common and ex.Player.blessing_pool:isRedDotForPoolType(PoolType.common))
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_XYC_GJXY, self.cur_pool_type ~= PoolType.senior and ex.Player.blessing_pool:isRedDotForPoolType(PoolType.senior))
end

function BlessingPoolLayer:refreshLuckyInfoPanel()
    local data = ex.Player.blessing_pool.lucky_info[self.cur_pool_type]
    if data ~= nil then
        local max = ex.Player.blessing_pool:getLuckyMax(self.cur_pool_type)
        self.lucky_precent_lbl:setString(tostring(data.lucky_value).."/"..tostring(max))

        local percent = math.min(data.lucky_value / max, 1) * 100
        self.progress_timer:setPercentage(percent)

        local config_table = {}
        for k,v in pairs(cfg.wishpoolluckyreward.wishpoolluckyreward) do
            if self.cur_pool_type == v.type then table.insert(config_table, v) end
        end
        table.sort(config_table, function(a, b)
            return a.lucky_value_need < b.lucky_value_need
        end)

        for i,v in ipairs(self.lucky_gift_btns) do
            local config = config_table[i]
            if config ~= nil then
                local file_name = ex.Tools:getItemImageName(config.reward[1].item_type) or ""

                local btn_size = v.btn:getContentSize()

                if v.icon == nil then
                    v.icon = cc.Sprite:createWithSpriteFrameName(file_name)
                    v.btn:addChild(v.icon, 1)

                    v.icon:setScale(0.3)
                    v.icon:setPosition(cc.p(btn_size.width / 2, btn_size.height / 2))
                else
                    ex.Tools:setSpriteFrame(v.icon, file_name)
                end

                if v.lbl_num == nil then
                    v.lbl_num = cc.Label:createWithTTF(tostring(config.reward[1].item_num), FONT_DEFAULT_NAME_BOLD, 32)
                    v.lbl_num:setScale(0.5)
                    v.lbl_num:setAnchorPoint(ex.a.right_bottom)
                    v.lbl_num:enableOutline(ex.c3b.BLACK, 1)
                    v.lbl_num:setPosition(btn_size.width, 0)
                    v.btn:addChild(v.lbl_num, 2)
                else
                    v.lbl_num:setString(tostring(config.reward[1].item_num))
                end
            end

            v.btn.config = config
            local bg = cc.Sprite:createWithSpriteFrameName("blessing-pool/spr-bg-1"..tostring(config.icon_bg)..".png")
            if bg ~= nil then v.btn:setNormalImage(bg) end
            v.lbl_lucky:setString(tostring(config.lucky_value_need))

            local is_gray = ex.Player.blessing_pool:isGotLockyRewardForIdx(self.cur_pool_type, config.idx)
            ex.Tools:setGrayAuto(v.btn:getNormalImage(), is_gray)
            ex.Tools:setGrayAuto(v.icon, is_gray)

            local can_get = data.lucky_value >= config.lucky_value_need and not is_gray
            ex.Tools:addRedPoint(v.btn, can_get)
        end
    end
end

function BlessingPoolLayer:onLuckyReward(tag, pSender)
    local config = pSender.config

    local max = ex.Player.blessing_pool:getLuckyMax(self.cur_pool_type)
    local data = ex.Player.blessing_pool.lucky_info[self.cur_pool_type]
    
    local is_got = ex.Player.blessing_pool:isGotLockyRewardForIdx(self.cur_pool_type, config.idx)

    local can_get = data.lucky_value >= config.lucky_value_need and not is_got

    if can_get then
        local req = BlessingPool_pb.GReqBlessingPoolLuckyReward()
        req.idx = config.idx
        NetManager:sendMessage(ProtocolID.GReqBlessingPoolLuckyReward, req)
    else
         ex.Tools:onClickItemInfo(config.reward[1].item_type)
    end
end

function BlessingPoolLayer:updateBlessingPool()
    self.poolMenu:removeAllChildren()

    self.pool_list = {}

    local radius = 140.0
    local start = 180

    local awardList = {}
    if self.cur_pool_type == PoolType.common then
        awardList = ex.Player.blessing_pool.common_list
    elseif self.cur_pool_type == PoolType.senior then
        awardList = ex.Player.blessing_pool.senior_list
    end

    for _,v in pairs(awardList) do
        local angle = start + (v.index - 1) * PreRad
        local x = - radius * math.sin(math.rad(angle))
        local y = - radius * math.cos(math.rad(angle))

        local item = {}
        item.index = v.index

        item.node = ex.Player.backpack_data:createWithData(v.item_type, v.item_num)
        item.node:setPosition(x, y)
        item.node:setScale(0.6)
        item.node:registerScriptTapHandler(handler(self, self.onShowInfo))
        self.poolMenu:addChild(item.node)

        local times_max = ex.Player.blessing_pool:getTimesByPosition(self.cur_pool_type, item.index)
        if times_max > 0 and v.times >= times_max then
            item.node:setGrayed()
        end

        table.insert(self.pool_list, item)
    end

    self:setPointerSleep()

    self:touchSwallowTouches(false)
end

function BlessingPoolLayer:startTurn(index)
    -- 得到中奖位置 开始转动
    self.is_need_stopcallback = true

    local diffRad =  math.random(-6, 6)
    self.isSlowdown = false
    self.resultIndex = index - 1 --0--7
    self.resultRad = self.resultIndex * PreRad + diffRad
    if self.resultRad < 1 then
        self.resultRad = 1
    end

    self.stopIndex = self.resultIndex + 1
    if self.stopIndex > 7 then
        self.stopIndex = 0
    end
    self.stopRad = self.stopIndex * PreRad + diffRad

    -- 转动5秒后 开始减速
    -- self.turnTimer:runOnce(function()
    --     self.isSlowdown = true
    -- end, 0.5)

    -- 开始转动
    self:setPointerStart()
    
    local angle = 360 * 8 + (360 - (self.spr_pointer:getRotation() % 360))
    local action = cc.Sequence:create(cc.CallFunc:create(function()
            ex.AudioManager:playEffect(string.format("music/bless-run.mp3", false))
        end), cc.EaseCubicActionIn:create(cc.RotateBy:create(1.5, angle)), cc.RotateBy:create(0.65, 360 * 8 + self.resultRad - 180),
        cc.EaseCubicActionOut:create(cc.RotateBy:create(1, 180)), cc.CallFunc:create(function()
            self:stopAward(self.resultIndex + 1)
        end), nil)
    
    self.spr_pointer:runAction(action)
    -- self:scheduleUpdateWithPriorityLua(function(dt)
    --     -- 时间倍数
    --     dt = dt * 5

    --     if self.turnState == 0 then
    --         -- 加速阶段
    --         self.fDeltaRad = self.fDeltaRad + 360 * dt
    --         if self.fDeltaRad >= 360 then
    --             self.fDeltaRad = 360
    --             self.turnState = 1
    --         end
    --     elseif self.turnState == 1 then
    --         -- 匀速阶段
    --         if self.isSlowdown then
    --             self.turnState = 2
    --         end
    --     elseif self.turnState == 2 then
    --         -- 减速阶段
    --         self.fDeltaRad = (self.fDeltaRad + 360 * dt) % 360
    --         if self.fDeltaRad < 180 then
    --             self.fDeltaRad = 180
    --             self.turnState = 3
    --         end
    --     elseif self.turnState == 3 then
    --         if math.abs(self.stopRad - self.turnRad) < 10 then
    --             --print("--- stopRad ---")
    --             self.turnState = 4
    --         end
    --     elseif self.turnState == 4 then
    --         -- 停止
    --         self.fDeltaRad = self.fDeltaRad - 50 * dt
    --         if self.fDeltaRad < 10 then
    --             self.fDeltaRad = 10
    --         end

    --         if math.abs(self.resultRad - self.turnRad) < 1 then
    --             --print("stop fDeltaRad = "..self.fDeltaRad)
    --             self:unscheduleUpdate()
    --             self:stopAward(self.resultIndex + 1)
    --             return
    --         end
    --     end
        
    --     --每帧角度变化啊
    --     self.turnRad = self.turnRad + self.fDeltaRad * dt
    --     if self.turnRad >= 360 then
    --         self.turnRad = 0
    --     end

    --     self.turnSndDelta = self.turnSndDelta + self.fDeltaRad * dt
    --     if self.turnSndDelta > 45 then
    --         self.turnSndDelta = 0
    --         ex.AudioManager:playEffect(string.format("music/bless-run.mp3", false))
    --     end

    --     self.spr_pointer:setRotation(self.turnRad)
    -- end, 0)
end

function BlessingPoolLayer:stopAward(index)
    -- 特效
    self:removeEffect()

    self.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_wishpool_boomb_light", cc.CallFunc:create(handler(self, self.removeEffect)))
    self.spr_effect:setScale(2.0)
    self.spr_effect:setPosition(self.node_rd_1:getPositionX(), self.node_rd_1:getPositionY())
    self:addChild(self.spr_effect)

    ex.AudioManager:playEffect(string.format("music/bless-stop.mp3", false))

    for _,v in pairs(self.pool_list) do
        if v.index == index then
            v.node:setScale(0.7)
            v.node:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15, 0.5),
                                        cc.ScaleTo:create(0.15, 0.7),
                                        cc.ScaleTo:create(0.15, 0.5),
                                        cc.ScaleTo:create(0.15, 0.7),
                                        cc.ScaleTo:create(0.15, 0.5),
                                        cc.ScaleTo:create(0.15, 0.7),
                                        cc.ScaleTo:create(0.1, 0.6),
                                        cc.CallFunc:create(function()
                                            -- 刷新变灰
                                            self:updateBlessingPool()
                                            self:touchSwallowTouches(false)
                                            self:setPointerSleep()
                                            self:stopRotateCallback()
                                        end)
                ))
           return
        end
    end
end

function BlessingPoolLayer:stopRotateCallback()
    if self.is_need_stopcallback == false then
        return 
    end
    ex.Player.promotion_data:reqBlessingPoolLists()
    self.is_need_stopcallback = false

    -- 跳到中奖界面
    -- require("src.layer.ItemRewardCtr"):instance():openWindow(ex.Player.blessing_pool.award_list)
    local btn_content = {}
    btn_content.item = ex.Player.blessing_pool:getNeedItem(self.cur_pool_type, ex.Player.blessing_pool.tag)
    btn_content.count = ex.Player.blessing_pool.tag % 10 == 0 and 10 or 1
    local callback = function ()
        if ex.Player.blessing_pool:runTurn() then
            self.lbl_num:setString(tostring(self.hasItemNum))
        
            self:touchSwallowTouches(true)
        end
    end
    require("src.layer.LuckRewardCtr"):instance():openWindow(ex.Player.blessing_pool.award_list,btn_content,callback)
end

function BlessingPoolLayer:onBtnChangePool(tag, pSender)
    local atom = pSender:getName()
    local isOpen = ex.JumpManager:checkOpenConditionByAtom(atom)
    if not isOpen then 
        self:changeTabBtn(PoolType.common)
        return 
    end
    self:changePool(tag)
end

function BlessingPoolLayer:changeTabBtn(pool_type)
    self.btn_common:setChecked(PoolType.common == pool_type)
    self.btn_senior:setChecked(PoolType.senior == pool_type)

    self.btn_common:setLabelColor(PoolType.common == pool_type and ex.c3b.TAB_SLT or ex.c3b.TAB_USLT)
    self.btn_senior:setLabelColor(PoolType.senior == pool_type and ex.c3b.TAB_SLT or ex.c3b.TAB_USLT)
end

function BlessingPoolLayer:onShowInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

function BlessingPoolLayer:onBtnInfo(tag, pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(2301), ex.Tools:getLang(2307))
end

function BlessingPoolLayer:onBtnShop(tag, pSender)
    cfg.funcopen.main_shop.open(SHOP_TYPE.WISHPOOL)
end

function BlessingPoolLayer:onBtnBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end

function BlessingPoolLayer:onBtnRefresh(tag, pSender)
    local refresh_times = ex.Player.blessing_pool.refresh_times[self.cur_pool_type]
    if refresh_times ~= nil and refresh_times >= self.free_refresh_times and ex.Player.gem < self.refresh_cost then
        ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
        return
    end

    if refresh_times == nil or refresh_times < self.free_refresh_times then
        if refresh_times == nil then
            refresh_times = 0
        end
        refresh_times = refresh_times + 1
        -- 设置刷新价值
        self:setBtnNode(self.node_btn_refresh, FONT_BROWN, ex.Tools:getLang(2203),
            self.refresh_cost, ItemType.IT_GEM)
    else
        -- 扣除钻石
        -- ex.Player:addGem(-self.refresh_cost)
    end
    
    self:touchSwallowTouches(true)

    -- 发送刷新许愿池协议
    local req_refresh = BlessingPool_pb.GReqBlessingPoolRefresh()
    req_refresh.type = self.cur_pool_type
    NetManager:sendMessage(ProtocolID.GReqBlessingPoolRefresh, req_refresh)
end

function BlessingPoolLayer:onBtnTurn(tag, pSender)
    --普通1 2 高级10 20
    local done_index = self.cur_pool_type * tag
    ex.Player.blessing_pool.done_index = done_index
    ex.Player.blessing_pool.tag = tag

    if ex.Player.blessing_pool:runTurn() then
        self.lbl_num:setString(tostring(self.hasItemNum))
    
        self:touchSwallowTouches(true)
    end
end

function BlessingPoolLayer:changePool(pool_type)
    if self.cur_pool_type == pool_type then
        return
    end
    NetManager:sendMessage(ProtocolID.GReqBlessingPoolList)
    self.lbl_time:setVisible(false)
    self:changeTabBtn(pool_type)
    self:changeStyle(pool_type)

    self.cur_pool_type = pool_type
    ex.Player.blessing_pool.cur_pool_type = self.cur_pool_type

    self:updateCdTimeShow()

    self:updateBtnNode()
    
    self:updateBlessingPool()

    self:refreshLuckyInfoPanel()

    self:refreshTabRedDot()
end

function BlessingPoolLayer:updateCdTimeShow()
    local refresh_times = ex.Player.blessing_pool.refresh_times[self.cur_pool_type]
    local free_refresh_times = self.cur_pool_type == PoolType.common and ex.Tools:getSysCfg("blessing_pool_normal_daily_free_times") or ex.Tools:getSysCfg("blessing_pool_advance_daily_free_times")
    local isEnough = refresh_times == nil or refresh_times < free_refresh_times

    local refresh_time = ex.Player.blessing_pool:getRefreshTime(self.cur_pool_type)
    local sys_time = ex.Game:getServerTime()
    local show_time = refresh_time - sys_time

    if not self.timer and not isEnough and show_time > 0 then
        self.timer = ExTimer:new():bind(self):run(handler(self, self.updateCDTime), 1.0)
        self:updateCDTime()
    end
    self:updateBtnNode()
end

return BlessingPoolLayer
