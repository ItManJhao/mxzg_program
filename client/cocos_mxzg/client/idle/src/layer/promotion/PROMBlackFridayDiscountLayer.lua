--[[
* @Description: 黑色星期五-超级打折
* @Author: 熊梦
* @Date: 2020-11-19 14:45:00
* ]]
local PROMBlackFridayDiscountLayer = class("PROMBlackFridayDiscountLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMBlackFridayDiscountGiftCell = class("PROMBlackFridayDiscountGiftCell", require("src.comp.LuaLayerBase"))



function PROMBlackFridayDiscountGiftCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function PROMBlackFridayDiscountGiftCell:initData(data)
    self.data = data

    self.lbl_price_now:setString(string.format(ex.Tools:getLang(91816),cfg.buygem.buygem[data.product_id].rmb / 100))
    self.lbl_price_low:setString(string.format(ex.Tools:getLang(91817),cfg.buygem.buygem[data.discount_product_id].rmb / 100))
    local discount = data.isPriceLow and data.complete_discount_rate or data.discount_rate

    local platform_id = cpp.SocialPlatform:instance():getPlatformId()
    if platform_id == "kor" or platform_id == "jpn" or platform_id == "vn" then
        discount = ex.Tools:getDiscountText(discount,true)
        self.lbl_price_num:setString(discount)
    else
        self.lbl_price_num:setString(string.format(ex.Tools:getLang(47728),discount / 10))
    end


    self.btn_itemInfo:setContentSize(cc.size(self.spr_price_low_bg:getContentSize().width, 80))

    ex.Tools:setSpriteFrame(self.spr_price_bg, string.format("prom-blackfriday/spr-prom-81-0%d-%d.png", data.idx,data.isPriceLow and 2 or 1))
  
    self.lbl_price_low_title:setVisible(data.isPriceLow)

    --v.isPriceLow = false  -- 是否为抄底折扣
    --v.isBuy = false       -- 是否已经购买  
    self.spr_bought:setVisible(data.isBuy)
    self.btn_price_buy:setVisible(not data.isBuy)

    if data.isPriceLow then
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_prom_81_get")
        self.node_effect:addChild(spr_effect)
    end

    -- 繁体适配注释 别的版本就解除掉
    --ex.Tools:setLimitWidth(self.lbl_price_now, 145)
    --ex.Tools:setLimitWidth(self.lbl_price_low, 145)
    --ex.Tools:setLimitWidth(self.lbl_price_num, 60)
    --------------------------------------
end

function PROMBlackFridayDiscountGiftCell:onGiftInfo(event, sender)
    require("src.layer.promotion.PROMBlackFridayDiscountGiftInfoCtr"):instance():openWindow(self.data.reward)
end


function PROMBlackFridayDiscountGiftCell:onBuy(event, sender)
    for index,value in pairs(ex.Player.promotion_data.promotion81_buy_record) do
        if self.data.idx == value.key and value.value >= self.data.buy_limit then
            ex.MessageView:add(ex.Tools:getLang(3904))
            return
        end
    end
   

	-- 拉起支付页面
	if self.data.product_id and self.data.discount_product_id then
		ex.Player:pay(self.data.isPriceLow and self.data.discount_product_id or self.data.product_id)
    end
end

-----------------------------------------------------------------------------
function PROMBlackFridayDiscountLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)
    self:addPlist()
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(1303))

    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)

    self.node_point:setPositionY(self.layer_promotion:getTopY() - 460)
    self.node_point:setScale(math.min(1, ex.p.width / 600))
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.menu_info:setPosition(ex.p.width-30,self.spr_banner:getPositionY() + 20 )
    self.menu_info:setLocalZOrder(100)

    self.node_bg:setPositionY(self.node_point:getPositionY() - 50)
    self.spr_bg2:setVisible(false)
    self.spr_bg2:setContentSize(cc.size(ex.p.width - 12, self.node_bg:getPositionY() - ex.MainSceneCtr:getBottomHeight() ))
    self.spr_bg3:setContentSize(cc.size(ex.p.width - 12, self.node_bg:getPositionY() - ex.MainSceneCtr:getBottomHeight() ))
    self.scroll_view:setViewSize(cc.size(self.spr_bg2:getContentSize().width - 10, self.spr_bg2:getContentSize().height - 25))

    self.node_upper:setPositionY(self.layer_promotion:getTopY() - 120)
    self.spr_bg4:setContentSize(cc.size(ex.p.width - 12, 285 ))
    self.scroll_view_upper:setViewSize(cc.size(self.spr_bg4:getContentSize().width - 10,260))

    self.item_scale = math.min(1, self.scroll_view:getViewSize().width / 550)

    self.scroll_view:setItemSize(cc.size(550 * self.item_scale, 155 * self.item_scale))
    self.scroll_view:setItemType(1)

    self.scroll_view_upper:setItemSize(cc.size(165 * self.item_scale, 255 * self.item_scale))
    self.scroll_view_upper:setItemType(1)
    self.scroll_view_upper:setAlignmentCenter(true)

    self.spr_progress_bg = ccui.Scale9Sprite:createWithSpriteFrameName("prom-dragonboat/spr-jdt1.png")
    :setCapInsets(cc.rect(50, 2, 50, 2))
    :setIgnoreAnchorPointForPosition(false)
    :setAnchorPoint(cc.p(0, 0.5))
    self.box_scroll_view:addChild(self.spr_progress_bg)
    self.box_scroll_view:setTouchEnabled(false)
    self.menu = cpp.UIMenu:create()
    self.menu:setLocalZOrder(1)
    self.menu:setPosition(0,0)
    self.spr_progress_bg:addChild(self.menu)
    local box_view_width = math.min(#cfg.promotion081reward.promotion081reward * 165 * self.item_scale - 80, self.spr_bg4:getContentSize().width)
    self.box_scroll_view:setViewSize(cc.size(box_view_width,100))
    self.progressTimer =
        require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("prom-dragonboat/spr-jdt2.png")):setType(cc.PROGRESS_TIMER_TYPE_BAR):setScaleX(
            (self.box_scroll_view:getViewSize().width  - 30) / self.spr_progress_bg:getContentSize().width
    ):setMidpoint(cc.p(0, 0.5)):setBarChangeRate(cc.p(1, 0))
    self.spr_progress_bg:addChild(self.progressTimer)

    self.spr_progress_bg:setContentSize(cc.size(self.box_scroll_view:getViewSize().width  - 30, self.spr_progress_bg:getContentSize().height))
    self.spr_progress_bg:setPosition(math.max(0, -((ex.p.width - 640)/4)), self.box_scroll_view:getViewSize().height / 2 - 16)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2, self.spr_progress_bg:getContentSize().height / 2)
    local width = self.spr_progress_bg:getContentSize().width
    self.box_list = {}
    for i, v in ipairs(cfg.promotion081missionboxreward.promotion081missionboxreward) do
        local x = i / #cfg.promotion081missionboxreward.promotion081missionboxreward
        if x < 1 then
            x = (160 * i - 82) / width
        end
        local box = cpp.UIMenuItemImage:createWithSpriteFrameName("other/spr-box-" .. i .. ".png", nil, nil)
        box.data = v
        box:registerScriptTapHandler(handler(self, self.onClickBox))
        box:setTag(i)
        box:setScale(0.95)
        self.menu:addChild(box, 1)
        box:setPosition(x * width, 10)

        local discountImg = cc.Sprite:createWithSpriteFrameName("prom-blackfriday-lang/discount_img.png")
        self.spr_progress_bg:addChild(discountImg)
        discountImg:setPosition(box:getPositionX(), box:getPositionY() + 38)
        discountImg:setLocalZOrder(1)

        local lbl = cc.Label:createWithTTF(math.min(ex.Player.promotion_data:getPromotion81MissionRewardNum(),v.count) .. "/" .. v.count, FONT_DEFAULT_NAME_BOLD, 18)
        self.spr_progress_bg:addChild(lbl)
        lbl:setColor(cc.c3b(253, 228, 181, 255))
        lbl:enableOutline(cc.c3b(87, 56, 29), 2)
        lbl:setPosition(box:getPositionX(), box:getPositionY() - 27.5)
        lbl:setLocalZOrder(1)

        local box_data = {}
        box_data.box = box
        box_data.lbl = lbl
        box_data.count = v.count
        table.insert(self.box_list, box_data)
        self.progressTimer:addData({pos = x * 100, count = v.count}, false)
    end

    self.node_act_time:setPositionY(self.spr_banner:getPositionY() - self.spr_banner:getContentSize().height / 2 + 30)
    self.node_act_time:setLocalZOrder(99)


    self:runAction(cc.CallFunc:create(function()
        self.scroll_view_upper:setOffsetLink(self.box_scroll_view, 1)
    end))


    self:updateLayer()

    self:addEvent(EVENT.BLACKFRIDAY.EVENT_UPDATA_MISSION, handler(self, self.updateLayer))
    self:addEvent(EVENT.BLACKFRIDAY.EVENT_GET_MISSION, handler(self, self.updateLayer))
    self:addEvent(EVENT.BLACKFRIDAY.EVENT_GET_BOX, handler(self, self.updateLayer))
    self:addEvent(EVENT.BLACKFRIDAY.EVENT_BUY_GIFT, handler(self, self.updateLayer))

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
end

function PROMBlackFridayDiscountLayer:onExit()
    self:removeTimerByName("timer")
end

function PROMBlackFridayDiscountLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-dragonboat.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-blackfriday.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-blackfriday-lang.plist")
end

function PROMBlackFridayDiscountLayer:updateTimer()
    local is_open = cfg.funcopen["act_black_friday"].isVisible()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion81Data()
    if data == nil then
         if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local cur_time = ex.Game:getServerTime()
    if cur_time > data.end_time then
         if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    self.lbl_time:setString(ex.Tools:formatTime5(data.end_time - ex.Game:getServerTime()))
end

function PROMBlackFridayDiscountLayer:updateLayer()
    -- 更新箱子状态
    for i, v in ipairs(self.box_list) do
        local box = v.box
        local status = ex.Player.promotion_data:getPromotion81BoxRewardStatus(box.data.idx)

        box:removeChildByName("box_effect")
        local node_eff = cc.Node:create()
        node_eff:setName("box_effect")
        box:addChild(node_eff)

        local image = status > 0 and ("other/spr-box-" .. i .. ".png") or ("other/spr-box-open-" .. i .. ".png")
        ex.Tools:setSpriteFrame(box:getNormalImage(), image)

        local effId = status == 0 and 11 or 10
        ex.EffectCtr:playNormalEff(effId, box:getContentSize().width * 0.5, box:getContentSize().height * 0.5, nil, node_eff, 10):setAnchorPoint(0.55, 0.12)
        
        v.lbl:setString(math.min(ex.Player.promotion_data:getPromotion81MissionRewardNum(),v.count) .. "/" .. v.count)
    end
    -- 更新宝箱进度条
    self.progressTimer:setPercentageCount(ex.Player.promotion_data:getPromotion81MissionRewardNum())

    self.scroll_view.createItemFunction = function(data, scale)
        local cell_layer = require("src.layer.promotion.PROMBlackFridayDiscountCell"):createWithCCBIFile("ccbi/PROMBlackFridayDiscountCell.ccbi")
        cell_layer:setIgnoreAnchorPointForPosition(false)
        cell_layer:setAnchorPoint(0.5, 0.5)
        cell_layer:initData(data)
        cell_layer:setScale(self.item_scale)
        return cell_layer
    end


    local vec_task_data = {}
    for i, v in ipairs(cfg.promotion081mission.promotion081mission) do
        table.insert(vec_task_data, clone(v))
    end

    for k, v in pairs(vec_task_data) do
        local data = ex.Player.promotion_data.promotion81_mission[v.idx]
        if data then
            v.progress = data.process
            v.had_reward = data.had_reward == true and 1 or 0
        else
            v.progress = 0
            v.had_reward = 0
        end
        
		-- if v.target.type == 'TOTAL_RECHARGE' then 
		-- 	v.progress =  v.progress * 0.01
		-- 	v.target.target = v.target.target * 0.01
		-- else 
			v.target.target = v.target.target
		-- end 
    end

    local function sort_table(a, b)
        local astatus = a.had_reward
        local bstatus = b.had_reward
     
        local aprogress = a.progress >= a.target.target and 0 or 1
        local bsprogress = b.progress >= b.target.target and 0 or 1

        if astatus == bstatus then
            if aprogress == bsprogress then
                return a.idx < b.idx
            else
                return aprogress < bsprogress
            end
        else
            return astatus < bstatus
        end
    end

    table.sort(vec_task_data, sort_table)
    self.scroll_view:reloadData(vec_task_data)

    ---------- 礼包
    local vec_gift_data = cfg.promotion081reward.promotion081reward
    for k,v in pairs(vec_gift_data) do
        v.isPriceLow = false  -- 是否为抄底折扣
        v.isBuy = false       -- 是否已经购买                   
        if ex.Player.promotion_data.promotion81_mission_reward_count >= v.need_count then
            v.isPriceLow = true
        end
        for index,value in pairs(ex.Player.promotion_data.promotion81_buy_record) do
            if v.idx == value.key and value.value >= v.buy_limit then
                v.isBuy = true
            end
        end
    end
    self.scroll_view_upper.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell_layer = PROMBlackFridayDiscountGiftCell:createWithCCBIFile("ccbi/PROMBlackFridayDiscountGiftCell.ccbi")
        cell_layer:setIgnoreAnchorPointForPosition(false)
        cell_layer:setAnchorPoint(0.5, 0.5)
        cell_layer:initData(data)

        return cell_layer
    end

    self.scroll_view_upper:reloadData(vec_gift_data)

end

function PROMBlackFridayDiscountLayer:onClickBox(tag, pSender)
    local data = clone(pSender.data)
    local can_get = ex.Player.promotion_data:getPromotion81BoxRewardStatus(data.idx) == 0
    local function callback()
        local req = Promotion081_pb.GReqBlackFiveMissionGetMissionBox()
        req.idx = pSender.data.idx
        NetManager:sendMessage(ProtocolID.GReqBlackFiveMissionGetMissionBox, req)
    end
    require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(data, can_get, callback)
end

function PROMBlackFridayDiscountLayer:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(91819), ex.Tools:getLang(91820))
end

return PROMBlackFridayDiscountLayer
