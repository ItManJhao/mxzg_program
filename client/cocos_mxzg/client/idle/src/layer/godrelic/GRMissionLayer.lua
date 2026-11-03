local GRMissionLayer = class("GRMissionLayer", require("src.comp.EventLayer"))

GRMissionLayer.ctr = ctr.god_relic

local box_image = {
    [10] = 1,
    [20] = 2,
    [30] = 4,
}

function GRMissionLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-god-relic-2.jpg", remove_type=1},
        {image_name = "ccbi-res/trial.pvr.ccz", plist_name = "ccbi-res/trial.plist", remove_type=2},
    }
    return vec_image
end

function GRMissionLayer:onCreate()
    self.selected_index = nil
    self.click_time = 0

    self.spr_bg:setLocalZOrder(-1)
    self.node_line:setLocalZOrder(-1)
    self.node_selected:setLocalZOrder(10)

    self.spr_bg:setScaleX(ex.s.global_scale)


    self.spr_info_bg:setContentSize(cc.size(ex.p.width, self.spr_info_bg:getContentSize().height))


    self.scroll_view:setItemSize(cc.size(70, 80))
    self.scroll_view:setViewSize(cc.size(self.spr_info_bg:getContentSize().width - 370, self.scroll_view:getViewSize().height))

    for i=1,3 do
        local spr_info_line = self["spr_info_line"..i]
        if spr_info_line then
            spr_info_line:setContentSize(cc.size(self.spr_info_bg:getContentSize().width - 250, spr_info_line:getContentSize().height))
        end
    end

    self.progress = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("god-relic/prog-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    :setAnchorPoint(cc.p(0.5, 0.5))
    :setPosition(self.spr_prog_bg:getContentSize().width * 0.5, self.spr_prog_bg:getContentSize().height * 0.5)
    -- :setContentSize(self.spr_prog_bg:getContentSize())
    self.spr_prog_bg:addChild(self.progress)


    self.menu = cpp.UIMenu:create()
    self.menu:setPosition(cc.p(0, 0))
    self.node_line:addChild(self.menu)

    self.spr_selected:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(1.6, cc.p(0, 50)), cc.MoveTo:create(1.6, cc.p(0, 0)))))

    self:updateLayer()

    self:addEvent(EVENT.GOD_RELIC.UPDATE, handler(self, self.updateLayer))
    self:addEvent(EVENT.GOD_RELIC.BUY_COUNT, handler(self, self.updateLayer))
    self:addEvent(EVENT.GOD_RELIC.STAR_REWARD, handler(self, self.updateStarProgress))
end

function GRMissionLayer:updateLayer(evt, is_refresh_all)
    local sfc = cc.SpriteFrameCache:getInstance() 
    sfc:addSpriteFrames("ccbi-res/trial.plist")

    local vec_chapter = cfg.godrelic.getChapterList()
    self.data = vec_chapter[ex.Player.god_relic_data.selected_chapter]
    if not self.data then
        return
    end

    if is_refresh_all then
        if self.menu then
            self.menu:removeAllChildren()
            self.menu = nil
        end

        self.menu = cpp.UIMenu:create()
        self.menu:setPosition(cc.p(0, 0))
        self.node_line:addChild(self.menu)

        self.selected_index = nil
    end

    self:updateStarProgress()
    self.lbl_chapter:setString(string.format(ex.Tools:getLang(54501), self.data[1].chapter))

        -- 更新挑战次数
    self.lbl_challenge_count:setString(string.format("%s/%s",
                                                     ex.Player.god_relic_data.can_challenge_count,
                                                     ex.Tools:getSysCfg("relic_daily_free_times")))
    self.lbl_buy_count:setString(string.format("%s",
                                                ex.Tools:getSysCfg("relic_daily_buy_times") -
                                                ex.Player.god_relic_data.buy_count))

    -- 推荐选中
    local recommend_index = 1
    -- 创建路径
    for i=1, 10 do
        local node_line = self["node_line"..i]        
        local data = self.data[i]
        if data and ex.Player.god_relic_data:isOpenMission(data.chapter, data.level) then
            local item = nil
            if self.menu:getChildByTag(i) == nil then
                item = cpp.UIMenuItemImage:create()
                item:setAnchorPoint(cc.p(0.5, 0.3))
                item:setContentSize(cc.size(104, 165))
                item:setPosition(cc.p(node_line:getPositionX(), node_line:getPositionY()))
                item:registerScriptTapHandler(handler(self, self.onSelected))
                item:setTag(i)
                self.menu:addChild(item, 100 - i)
                self["item_relic"..i] = item
    
                local cell = require("src.layer.godrelic.GRMissionCastleCell"):createWithCCBIFile("ccbi/GRMissionCastleCell.ccbi")
                cell:setPosition(cc.p(item:getContentSize().width * 0.5, item:getContentSize().height * 0.5))
                -- cell:reset(data)
                item.cell = cell
                item:addChild(cell)
            end

            if item then
                item.cell:reset(data)
                node_line:setVisible(true)
            end

            recommend_index = i
        else
            node_line:setVisible(false)
        end
    end

    self.selected_index = self.selected_index or recommend_index

    self.btn_left:setVisible(self.data[1].chapter > 1)
    self.btn_right:setVisible(self.data[1].chapter < table.nums(ex.Player.god_relic_data:getBattleChapterList()))

    -- 显示条件信息
    self:updateMissionInfo()
    self:updateSelected()
end

function GRMissionLayer:updateSelected()
    local item = self["item_relic"..self.selected_index]
    self.node_selected:setPosition(item:getPositionX(), item:getPositionY() + 100)
end

function GRMissionLayer:updateMissionInfo()
    local item = self["item_relic"..self.selected_index]
    local data = item.cell.data

    -- 关卡信息
    self.lbl_level:setString(string.format(ex.Tools:getLang(54505), data.level))
    self.lbl_fight:setString(data.require_fighting)

    -- 关卡信息
    local mission_data = ex.Player.god_relic_data:getMissionData(data.chapter, data.level)

    for i,v in ipairs(data.target) do
        self["lbl_condition"..i]:setString(ex.Tools:getLang(cfg.godrelictarget.godrelictarget[v].language))
        if mission_data and TableEx.isInTable(mission_data.complete_id, v) ~= nil then
            ex.Tools:setSpriteFrame(self["spr_star"..i], "other/star-0.png")
        else
            ex.Tools:setSpriteFrame(self["spr_star"..i], "god-relic/xxwx.png")
        end
    end

    -- 奖励信息
    self.scroll_view.createItemFunction = function(data, scale)
        local item = ex.Tools:createBackpackItem(data.item_type, data.item_num)
        item:setScale(0.6)
        item:registerScriptTapHandler(handler(ex.Tools, ex.Tools.showItemInfo))
        return item
    end

    -- 更新按钮信息
    if ex.Player.god_relic_data:isMissionPerfect(data.chapter, data.level) then
        self.btn_battle:setLabelText(ex.Tools:getLang(47040))
        -- self.scroll_view:reloadData(data.reward)
    else
        self.btn_battle:setLabelText(ex.Tools:getLang(47212))
        -- self.scroll_view:reloadData(data.first_reward)
    end

    self.scroll_view:reloadData( (mission_data and table.nums(mission_data.complete_id) > 0) and data.reward or data.first_reward)

    -- mission_data.complete_id



end

function GRMissionLayer:updateStarProgress()
    local chater = self.data[1].chapter
    local now_star = ex.Player.god_relic_data:getStarCount(chater)
    local max_star = ex.Player.god_relic_data:getMaxStar(chater)

    -- 更新星数和进度
    self.lbl_star_count:setString(string.format("%s/%s",
                                                now_star,
                                                max_star))
    self.progress:setPercentage(now_star / max_star * 100)

    -- 更新盒子特效
    for k,v in pairs(cfg.godrelicstarreward.godrelicstarreward) do
        if v.chapter == chater then
            local status = ex.Player.god_relic_data:getStarStatu(v.idx)
            local btn_star = self["btn_star"..v.star]
            if btn_star then
                btn_star:removeChildByName("box_effect")
                local node_eff = cc.Node:create()
                node_eff:setName("box_effect")
                btn_star:addChild(node_eff)

                local image = status > 0 and ("other/spr-box-" .. box_image[v.star] ..".png") or ("other/spr-box-open-" .. box_image[v.star] ..".png")
                ex.Tools:setSpriteFrame(btn_star:getNormalImage(), image)


                local effId = status == 0 and 11 or 10
                ex.EffectCtr:playNormalEff(effId, btn_star:getContentSize().width * 0.5, btn_star:getContentSize().height * 0.5, nil, node_eff, 10)
                :setAnchorPoint(0.55, 0.12)
            end
        end
    end
end

function GRMissionLayer:battleStart(evt, data)

end

function GRMissionLayer:onBattle()
    if ex.Player.god_relic_data.can_challenge_count <= 0 then

        if ex.Tools:getSysCfg("relic_daily_buy_times") - ex.Player.god_relic_data.buy_count > 0 then
            self:onBuy()
        else
            ex.MessageView:add(ex.Tools:getLang(54513))
        end
        return
    end

    if ex.Game:getServerTime() - self.click_time < 5 then
        -- ex.MessageView:add("")
        return
    end

    local data = self["item_relic"..self.selected_index].cell.data
    if ex.Player.god_relic_data:isMissionPerfect(data.chapter, data.level) then
        -- 扫荡
        local req_sweep = GodRelic_pb.GReqGodRelicSweep()
        req_sweep.idx = data.idx
        NetManager:sendMessage(ProtocolID.GReqGodRelicSweep, req_sweep)
    else
        -- 打开布阵界面
        require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47524),
                                                                ex.Tools:getLang(47064),
                                                                LineupType.GOD_RELIC,
                                                                handler(self, self.onBattleDone))
    end
end

function GRMissionLayer:onBattleDone()

    self.click_time = ex.Game:getServerTime()


    local data = self["item_relic"..self.selected_index].cell.data
    local req_challenge = GodRelic_pb.GReqGodRelicChallenge()
    req_challenge.idx = data.idx
    NetManager:sendMessage(ProtocolID.GReqGodRelicChallenge, req_challenge)
end

function GRMissionLayer:onSelected(tag, pSender)
    self.selected_index = tag
    self:updateLayer()
    -- self:updateSelected()
end

function GRMissionLayer:onBuy()
    if ex.Tools:getSysCfg("relic_daily_buy_times") - ex.Player.god_relic_data.buy_count <= 0 then
       ex.MessageView:add(ex.Tools:getLang(54510))
        return
    end

    -- if ex.Tools:getSysCfg("relic_daily_free_times") - ex.Player.god_relic_data.can_challenge_count <= 0 then
    --     ex.MessageView:add(ex.Tools:getLang(54510))
    --     return
    -- end

    local buy_need = ex.Tools:getSysCfg("relic_daily_buy_need")
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(41301), string.format(ex.Tools:getLang(54509), buy_need[1].item_type, buy_need[1].item_num), function()
        NetManager:sendMessage(ProtocolID.GReqGodRelicBuyCount)
    end)
end

function GRMissionLayer:onStar(tag, pSender)
    local chapter = self.data[1].chapter
    local config = TableEx.findValueFunction(cfg.godrelicstarreward.godrelicstarreward, function(value)
        return value.chapter == chapter and value.star == tag
    end)

    if not config then
        return
    end
    local status = ex.Player.god_relic_data:getStarStatu(config.idx)
    if status == 0 then
        -- 领取
        local req_reward = GodRelic_pb.GReqGodRelicGetStarReward()
        req_reward.idx = config.idx
        NetManager:sendMessage(ProtocolID.GReqGodRelicGetStarReward, req_reward)
    else
        -- 打开预览
        require("src.layer.RewardPreviewCtr"):instance():openWindow(pSender:getParent():convertToWorldSpace(cc.p(pSender:getPositionX(), pSender:getPositionY())), config.reward)
    end
end


function GRMissionLayer:onBack()
    ex.JumpManager:jumpByAtom("main_god_relic_list")
end


function GRMissionLayer:onLeft()
    local select_index = ex.Player.god_relic_data.selected_chapter
    ex.Player.god_relic_data.selected_chapter = math.max(1, select_index - 1)
    self:updateLayer(nil, true)
end

function GRMissionLayer:onRight()
    local select_index = ex.Player.god_relic_data.selected_chapter
    
    select_index = math.min(select_index + 1, ex.Player.god_relic_data:getMaxChapter())
    select_index = cc.clampf(select_index, 1, table.nums(ex.Player.god_relic_data:getBattleChapterList()) )

    ex.Player.god_relic_data.selected_chapter = select_index
    self:updateLayer(nil, true)
end

function GRMissionLayer:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(42068), ex.Tools:getLang(42069))
end

return GRMissionLayer