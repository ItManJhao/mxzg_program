-- 万圣节活动-惊喜扭蛋
local PROMHalloweenGachaLayer = class("PROMHalloweenGachaLayer", require("src.layer.promotion.PromotionBaseLayer"))
local PROMHalloweenGachaItem = class("PROMHalloweenGachaItem", require("src.comp.EventLayer"))
local UIMenuItemBag = require("src.comp.menu.UIMenuItemBag")

------------------------------------ PROMHalloweenGachaItem ------------------------------------
function PROMHalloweenGachaItem:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function PROMHalloweenGachaItem:resetData(data)
    self.data = data
    self.menu:removeAllChildren()
    local icon = string.format("backpack/%d.png", data.item_type)
    self.btn_icon = cpp.UIMenuItemImage:createWithSpriteFrameName(icon, nil, nil):setPosition(self.menu:getContentSize().width / 2, self.menu:getContentSize().height / 2)
    self.btn_icon:setScale(0.8)
    self.btn_icon.data = data
    self.btn_icon:registerScriptTapHandler(handler(self, self.onItemInfo))
    self.menu:addChild(self.btn_icon)

    self.spr_jp:setVisible(data.show_type == 1)
end

function PROMHalloweenGachaItem:onItemInfo(tag, pSender)
    if pSender.data.show_type == 1 then
        local cfg_data = cfg.promotion078lotteryreward.promotion078lotteryreward[1].show_hero_reward
        require("src.layer.promotion.PROMHalloweenGachaChooseCtr"):instance():openWindow(cfg_data)
    else
        ex.Tools:onClickItemInfo(pSender.data.item_type)
    end
end

------------------------------------ PROMHalloweenGachaLayer ------------------------------------
function PROMHalloweenGachaLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:initEventListen()
    self:addPlist()
end

function PROMHalloweenGachaLayer:onCreateDone()
    self:initView()
    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)
    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
end

function PROMHalloweenGachaLayer:onExit()
    self:removeTimerByName("timer")
    if self.will_get_reward and #self.will_get_reward > 0 then
        require("src.layer.ItemRewardCtr"):instance():openWindow(self.will_get_reward)
        self.will_get_reward = nil
    end
end

function PROMHalloweenGachaLayer:updateTimer()
    local is_open = cfg.funcopen["act_halloween_gacha"].isVisible()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion78Data()
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

function PROMHalloweenGachaLayer:initEventListen()
    self:addEvent(EVENT.HALLOWEEN.EVENT_UPDATE_GACHA, handler(self, self.updateLayer))
    self:addEvent(EVENT.HALLOWEEN.EVENT_GACHA_DRAW, handler(self, self.handleDrawResult))
    self:addEvent(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self, self.updateItemCount))
end

function PROMHalloweenGachaLayer:addPlist()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/promotion-78.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/promotion-secret-treasure-lang.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("ccbi-res/prom-dragonboat.plist")
end

function PROMHalloweenGachaLayer:initView()
    self.btn_game_info:registerScriptTapHandler(handler(self, self.onGameInfo))
    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(1201))

    local pos_y = self.spr_banner:getPositionY()
    self.spr_bg:setPositionY(pos_y - self.spr_banner:getContentSize().height / 2 + 5)
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height))

    self.tip_label = cpp.RichTextEx:createWithXMLLua("")
        :setFontSize(44)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setFontColor("#FFFFFF")
        :setAnchorTextShadow(true)
        :setScale(0.5)
        :setWrapMode(1)
        :setAnchorPoint(cc.p(0.5, 0.5))
        :setPosition(cc.p(self.spr_top_bg:getContentSize().width / 2, self.spr_top_bg:getContentSize().height / 2))
    self.spr_top_bg:addChild(self.tip_label)

    self.node_act_time:setPositionY(self.spr_banner:getPositionY() - self.spr_banner:getContentSize().height / 2 + 40)
    self.node_act_time:setLocalZOrder(99)

    self.original_pos_list = {}
    self.eff = {}
    self:updateLayer()
end

function PROMHalloweenGachaLayer:updateLayer()
    self.data = ex.Player.promotion_data.promotion78_data
    self:updateItemCount()
    local remain_times = self.data.lottery_best_remaining_count or 0
    local str = string.format(ex.Tools:getLang(91610), remain_times)
    self.tip_label:setXmlTextLua(str)

    local item_list = {}
    local configs = clone(cfg.promotion078lotteryreward.promotion078lotteryreward)
    table.insert(item_list, cfg.promotion078lotteryreward.promotion078lotteryreward[1])
    local len = #configs
    for i = 2, 10 do
        local rand = math.random(2, #configs)
        local config = table.remove(configs, rand)
        table.insert(item_list, config)
    end

    for i = 1, #item_list do
        local config = item_list[i]
        if config and config.show_reward and #config.show_reward > 0 then
            local item_data = config.show_reward[1]
            item_data.show_type = config.type
            if not self["item_" .. i] then
                self["item_" .. i] = PROMHalloweenGachaItem:createWithCCBIFile("ccbi/PROMHalloweenGachaItem.ccbi")
                self.spr_reward_region_bg:addChild(self["item_" .. i])
            end
            
            local pos = cc.p(self["node_item_" .. i]:getPositionX() - self["item_" .. i]:getContentSize().width / 2, self["node_item_" .. i]:getPositionY() - self["item_" .. i]:getContentSize().height / 2)
            if not self.original_pos_list[i] then
                self.original_pos_list[i] = pos
            end

            self["item_" .. i]:setPosition(pos)
            local rand = math.random(0, 1)
            if rand == 0 then
                rand = -1
            end

            self["item_" .. i]:stopAllActions()
            self["item_" .. i]:runAction(cc.RepeatForever:create(
                cc.Sequence:create(
                    cc.MoveTo:create(3, cc.p(pos.x, pos.y + rand * math.random(10, 20))),
                    cc.MoveTo:create(3, pos),
                    cc.MoveTo:create(3, cc.p(pos.x, pos.y - (-rand) * math.random(10, 20))),
                    cc.MoveTo:create(3, pos)
                )
            ))
            self["item_" .. i]:resetData(item_data)
        end
    end

    self:updateReward(self.data)

    if not self.progressTimer then
        self.progressTimer = require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("prom-dragonboat/spr-jdt2.png"))
            :setType(cc.PROGRESS_TIMER_TYPE_BAR)
            :setScaleX(self.spr_progress_bg:getScaleX())
            :setMidpoint(cc.p(0, 0.5))
            :setBarChangeRate(cc.p(1, 0))
        self.spr_progress_bg:addChild(self.progressTimer)
        self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 - 8 ,self.spr_progress_bg:getContentSize().height / 2 )
    end

    self:removeAllBoxEff()
    local total_open_times = self.data.lottery_count or 0
    self.lbl_total_open_times:setString(total_open_times)
    local open_config = cfg.promotion078lotterycountreward.promotion078lotterycountreward
    local vec_progress_data = {}
    for k, v in ipairs(open_config) do
        local lbl = self["lbl_progress_reward_" .. k]
        lbl:setString(string.format("%s%s", v.count, ex.Tools:getLang(47180)))
        lbl:setLocalZOrder(100)
        local node_reward = self["node_progress_reward_" .. k]
        node_reward:setZOrder(100)
        node_reward.idx = v.idx
        local percent = node_reward:getPositionX() / self.spr_progress_bg:getContentSize().width * 100

        local is_get_reward = self.data.box_reward_record[v.idx]
        local menu_reward = self["menu_progress_" .. k]
        menu_reward:removeAllChildren()
        local box_str
        if v.count <= total_open_times then
            if v.idx < 4 then
                box_str = "other/spr-box-open-" .. k .. ".png"
            end
        else
            if v.idx < 4 then
                box_str = "other/spr-box-" .. k .. ".png"
            end
        end

        local y = 20
        if v.idx == 4 then
            box_str = "promotion-secret-treasure-lang/btn-max-award.png"
            y = 6
        end

        local box = cpp.UIMenuItemImage:createWithSpriteFrameName(box_str, nil, nil)
        box.data = v
        box.can_get = v.count <= total_open_times and not is_get_reward
        box:registerScriptTapHandler(handler(self, self.onClickBox))
        box:setTag(v.idx)
        box:setAnchorPoint(0.5, 0)
        menu_reward:addChild(box, 1)
        box:setPosition(menu_reward:getContentSize().width / 2, y)
        if v.count <= total_open_times then
  
        else
     
        end
        self:createBoxEff(box, is_get_reward, v.idx, v.count, total_open_times)

        table.insert(vec_progress_data, {pos = percent, count = v.count} )
    end

    self.progressTimer:setPositionList(vec_progress_data)
    self.progressTimer:setPercentageCount(total_open_times)
end

function PROMHalloweenGachaLayer:updateReward(data)
    if not data.last_lottery_id or data.last_lottery_id == 0 then
        if self.btn_reward_icon then
            self.btn_reward_icon:setVisible(false)
            self.btn_reward_icon:setEnabled(false)
        end
        ex.Tools:setSpriteFrame(self.spr_award_bg, "promotion-78/spr-award-none-bg.png")
    else
        ex.Tools:setSpriteFrame(self.spr_award_bg, "promotion-78/spr-award-bg.png")
        local config = cfg.promotion078lotteryreward.promotion078lotteryreward[data.last_lottery_id]
        if config and config.show_reward and #config.show_reward > 0 then
            local icon = string.format("backpack/%d.png", config.show_reward[1].item_type)
            if not self.btn_reward_icon then
                self.btn_reward_icon = cpp.UIMenuItemImage:createWithSpriteFrameName(icon, nil, nil):setPosition(self.menu_reward:getContentSize().width / 2, self.menu_reward:getContentSize().height / 2)
                self.menu_reward:addChild(self.btn_reward_icon)
                self.btn_reward_icon:registerScriptTapHandler(handler(self, self.onItemInfo))
            else
                ex.Tools:setSpriteFrame(self.btn_reward_icon:getNormalImage(), icon)
            end

            self.btn_reward_icon.data = config.show_reward[1]
            self.btn_reward_icon:setVisible(true)
            self.btn_reward_icon:setEnabled(true)
        end
        
    end
end

function PROMHalloweenGachaLayer:updateItemCount()
    if self.lbl_num then
        self.lbl_num:setString(ex.Player:getItemNum(902052))
    end 
end

function PROMHalloweenGachaLayer:createBoxEff(box, is_get, idx, count, open_time)
    if self.eff[idx] then
        return
    end

    if idx == 4 then
        if not is_get and count <= open_time then
            self.eff[idx] = ex.EffectCtr:playNormalEff(17, box:getContentSize().width * 0.5, box:getContentSize().height * 0.5, nil, box, 1000)
            self.eff[idx]:setAnchorPoint(0.5, 0.5)
        end
    elseif count <= open_time then
        local effId = not is_get and 11 or 10
        local x = not is_get and box:getContentSize().width / 2 - 3 or box:getContentSize().width / 2
        local y = not is_get and box:getContentSize().height / 2 - 12 or box:getContentSize().height / 2

        self.eff[idx] = ex.EffectCtr:playNormalEff(effId, x, y, nil, box, 10)
        self.eff[idx]:setAnchorPoint(0.5, 0)
    end
end

function PROMHalloweenGachaLayer:removeAllBoxEff()
    local open_config = cfg.promotion078lotterycountreward.promotion078lotterycountreward
    for k, v in ipairs(open_config) do
        local idx = v.idx
        if self.eff[idx] ~= nil then
            self.eff[idx]:remove()
            self.eff[idx] = nil
        end
    end
end

function PROMHalloweenGachaLayer:onDrawOnce(tag, pSender)
    if not self.data.select_info or self.data.select_info.value == 0 then
        local cfg_data = cfg.promotion078lotteryreward.promotion078lotteryreward[1].show_hero_reward
        require("src.layer.promotion.PROMHalloweenGachaChooseCtr"):instance():openWindow(cfg_data)
        return
    end

    if ex.Player:getItemNum(902052) < 1 then
        ex.Tools:showEnoughTip(902052, true)
        return
    end

    if self.is_drawing then
        return
    end

    local req = Promotion078_pb.GReqHalloweenLotteryLottery()
    req.num = 1
    NetManager:sendMessage(ProtocolID.GReqHalloweenLotteryLottery, req)
    self.is_drawing = true
end

function PROMHalloweenGachaLayer:onDrawTen(tag, pSender)
    if not self.data.select_info or self.data.select_info.value == 0 then
        local cfg_data = cfg.promotion078lotteryreward.promotion078lotteryreward[1].show_hero_reward
        require("src.layer.promotion.PROMHalloweenGachaChooseCtr"):instance():openWindow(cfg_data)
        return
    end

    if ex.Player:getItemNum(902052) < 10 then
        ex.Tools:showEnoughTip(902052, true)
        return
    end

    if self.is_drawing then
        return
    end

    local req = Promotion078_pb.GReqHalloweenLotteryLottery()
    req.num = 10
    NetManager:sendMessage(ProtocolID.GReqHalloweenLotteryLottery, req)
    
    self.is_drawing = true
end

function PROMHalloweenGachaLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.data.item_type)
end

function PROMHalloweenGachaLayer:onReward(tag, pSender)
    local cfg_data = cfg.promotion078lotteryreward.promotion078lotteryreward[1].show_hero_reward
    require("src.layer.promotion.PROMHalloweenGachaChooseCtr"):instance():openWindow(cfg_data)
end

function PROMHalloweenGachaLayer:onClickAdd(tag, pSender)
    require("src.layer.BackpackSrcCtr"):instance():openWindow(902052)
end

function PROMHalloweenGachaLayer:onClickBox(tag, pSender)
    local data = clone(pSender.data)
    local can_get = pSender.can_get
    local function callback()
        local req = Promotion078_pb.GReqHalloweenLotteryGetLotteryCountReward()
        req.idx = data.idx
        NetManager:sendMessage(ProtocolID.GReqHalloweenLotteryGetLotteryCountReward, req)
    end
    require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(data, can_get, callback)
end

function PROMHalloweenGachaLayer:onGameInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(91612), ex.Tools:getLang(91611))
end

function PROMHalloweenGachaLayer:handleDrawResult(event, data)
    self.will_get_reward = data
    for i = 1, 10 do
        local item = self["item_" .. i]
        item:stopAllActions()
        local x, y = item:getPosition()
        item:runAction(cc.Sequence:create(
            cc.MoveTo:create(0.5, cc.p(self.spr_reward_region_bg:getContentSize().width / 2 - 50, 0)),
            cc.Hide:create(),
            cc.DelayTime:create(0.5),
            cc.CallFunc:create(function ()
                item:setPosition(cc.p(x, y))
            end),
            cc.Show:create()
        ))
    end

    self.spr_award_bg:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function ( )
            local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_prom_78")
                spr_effect:setPosition(self.spr_award_bg:getContentSize().width / 2, self.spr_award_bg:getContentSize().height / 2 + 20)
                spr_effect:setScale(1)
                self.spr_award_bg:addChild(spr_effect, 0, 10)	
        end),
        cc.DelayTime:create(0.5),
        cc.CallFunc:create(function ()
            require("src.layer.ItemRewardCtr"):instance():openWindow(data)
            self.will_get_reward = nil
            self:updateLayer()
            self.is_drawing = false
        end)
    ))
end


return PROMHalloweenGachaLayer
