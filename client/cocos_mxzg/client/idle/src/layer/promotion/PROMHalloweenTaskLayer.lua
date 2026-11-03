local PROMHalloweenTaskLayer = class("PROMHalloweenTaskLayer", require("src.layer.promotion.PromotionBaseLayer"))

function PROMHalloweenTaskLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)

    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(1203))

    self.menu:setLocalZOrder(1)

    self.progressTimer =
        require("src.comp.UIProgressTimerEquidistant"):create(cc.Sprite:createWithSpriteFrameName("prom-dragonboat/spr-jdt2.png")):setType(cc.PROGRESS_TIMER_TYPE_BAR):setScaleX(
        self.spr_progress_bg:getScaleX()
    ):setMidpoint(cc.p(0, 0.5)):setBarChangeRate(cc.p(1, 0))
    self.spr_progress_bg:addChild(self.progressTimer)
    self.progressTimer:setPosition(self.spr_progress_bg:getContentSize().width / 2 - 8, self.spr_progress_bg:getContentSize().height / 2)

    ex.Tools:setLabelOffset(self.lbl_time_tip, self.lbl_time)

    self.node_point:setPositionY(self.layer_promotion:getTopY() - 122 - 70)
    self.node_point:setScale(math.min(1, ex.p.width / 600))
    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)
    self.spr_bg:setScaleY(self.spr_bg:getPositionY() / (self.spr_bg:getContentSize().height))
    self.node_bg:setPositionY(self.node_point:getPositionY() - 50)
    self.spr_bg2:setContentSize(cc.size(ex.p.width - 12, self.node_bg:getPositionY() - ex.MainSceneCtr:getBottomHeight() - 30))
    self.scroll_view:setViewSize(cc.size(self.spr_bg2:getContentSize().width - 10, self.spr_bg2:getContentSize().height - 25))

    self.item_scale = math.min(1, self.scroll_view:getViewSize().width / 550)

    self.scroll_view:setItemSize(cc.size(550 * self.item_scale, 155 * self.item_scale))
    self.scroll_view:setItemType(1)

    local width = self.spr_progress_bg:getContentSize().width
    self.box_list = {}
    for i, v in ipairs(cfg.promotion080missionboxreward.promotion080missionboxreward) do
        local x = i / #cfg.promotion080missionboxreward.promotion080missionboxreward

        local box = cpp.UIMenuItemImage:createWithSpriteFrameName("other/spr-box-" .. i .. ".png", nil, nil)
        box.data = v
        box:registerScriptTapHandler(handler(self, self.onClickBox))
        box:setTag(i)
        box:setScale(0.95)
        self.menu:addChild(box, 1)
        box:setPosition(x * width, 10)

        local lbl = cc.Label:createWithTTF(string.format(ex.Tools:getLang(75103), v.count), FONT_DEFAULT_NAME_BOLD, 18)
        self.spr_progress_bg:addChild(lbl)
        lbl:setColor(cc.c3b(253, 228, 181, 255))
        lbl:enableOutline(cc.c3b(87, 56, 29), 2)
        lbl:setPosition(box:getPositionX(), box:getPositionY() - 27.5)
        lbl:setLocalZOrder(1)

        local box_data = {}
        box_data.box = box
        box_data.lbl = lbl
        table.insert(self.box_list, box_data)

        self.progressTimer:addData({pos = x * 100, count = v.count}, false)
    end

    self.node_act_time:setPositionY(self.spr_banner:getPositionY() - self.spr_banner:getContentSize().height / 2 + 40)
    self.node_act_time:setLocalZOrder(99)

    self:updateLayer()

    self:addEvent(EVENT.HALLOWEEN.EVENT_UPDATA_MISSION, handler(self, self.updateLayer))
    self:addEvent(EVENT.HALLOWEEN.EVENT_GET_MISSION, handler(self, self.updateLayer))
    self:addEvent(EVENT.HALLOWEEN.EVENT_GET_BOX, handler(self, self.updateLayer))

    self:addTimer("timer", 1000, handler(self, self.updateTimer), true)
    self:updateTimer()
end

function PROMHalloweenTaskLayer:onExit()
    self:removeTimerByName("timer")
end

function PROMHalloweenTaskLayer:updateTimer()
    local is_open = cfg.funcopen["act_halloween_task"].isVisible()
    if is_open ~= true then
        if self.layer_promotion then
            self.layer_promotion:resetTabView()
        end
        return
    end

    local data = ex.Player.promotion_data:getPromotion80Data()
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

function PROMHalloweenTaskLayer:updateLayer()
    -- 更新箱子状态
    for i, v in ipairs(self.box_list) do
        local box = v.box
        local status = ex.Player.promotion_data:getPromotion80BoxRewardStatus(box.data.idx)

        box:removeChildByName("box_effect")
        local node_eff = cc.Node:create()
        node_eff:setName("box_effect")
        box:addChild(node_eff)

        local image = status > 0 and ("other/spr-box-" .. i .. ".png") or ("other/spr-box-open-" .. i .. ".png")
        ex.Tools:setSpriteFrame(box:getNormalImage(), image)

        local effId = status == 0 and 11 or 10
        ex.EffectCtr:playNormalEff(effId, box:getContentSize().width * 0.5, box:getContentSize().height * 0.5, nil, node_eff, 10):setAnchorPoint(0.55, 0.12)
    end

    -- 更新宝箱进度条
    self.progressTimer:setPercentageCount(ex.Player.promotion_data:getPromotion80MissionRewardNum())

    self.scroll_view.createItemFunction = function(data, scale)
        local cell_layer = require("src.layer.promotion.PROMHalloweenTaskCell"):createWithCCBIFile("ccbi/PROMHalloweenTaskCell.ccbi")
        cell_layer:setIgnoreAnchorPointForPosition(false)
        cell_layer:setAnchorPoint(0.5, 0.5)
        cell_layer:initData(data)
        cell_layer:setScale(self.item_scale)
        return cell_layer
    end

    local day = ex.Player.promotion_data.promotion80_open_day

    local vec_task_data = {}
    for i, v in ipairs(cfg.promotion080mission.promotion080mission) do
        if v.day == day then
            table.insert(vec_task_data, clone(v))
        end
    end

    for k, v in pairs(vec_task_data) do
        local data = ex.Player.promotion_data.promotion80_mission[v.idx]
        if data then
            v.progress = data.process
            v.had_reward = data.had_reward == true and 1 or 0
        else
            v.progress = 0
            v.had_reward = 0
        end
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
end

function PROMHalloweenTaskLayer:onClickBox(tag, pSender)
    local data = clone(pSender.data)
    local can_get = ex.Player.promotion_data:getPromotion80BoxRewardStatus(data.idx) == 0
    local function callback()
        local req = Promotion080_pb.GReqHalloweenMissionGetMissionBox()
        req.idx = pSender.data.idx
        NetManager:sendMessage(ProtocolID.GReqHalloweenMissionGetMissionBox, req)
    end
    require("src.layer.SevenTargetRewardInfoCtr"):instance():openWindow(data, can_get, callback)
end

return PROMHalloweenTaskLayer
