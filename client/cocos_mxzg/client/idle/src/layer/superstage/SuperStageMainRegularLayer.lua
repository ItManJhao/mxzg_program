local SuperStageMainRegularLayer = class("SuperStageMainRegularLayer", require("src.comp.EventLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function SuperStageMainRegularLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-super-stage.jpg", remove_type = 1},
    }
    return vec_image
end

function SuperStageMainRegularLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(true)

	-- 铺展到全屏
	ex.Tools:AdjustFullScreenExtend(self.spr_bg)
    
    -- 賽季時間提示
    self.lbl_season_time_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFDFB2")
    :setScale(0.5)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(0, -5)
    self.node_top:addChild(self.lbl_season_time_tip, 10001)

    self.lbl_season_time_tip_2 = require("src.comp.RichTextEx"):create()
	:setFontSize(36)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFDFB2")
    :setScale(0.5)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(0, -35)
    self.node_top:addChild(self.lbl_season_time_tip_2, 10001)

    -- 賽季獎勵提示
    self.lbl_reward_tip = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFDFB2")
    :setScale(0.5)
    :setAnchorPoint(0, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(10, 0)
    self.node_reward_tip:addChild(self.lbl_reward_tip, 10001)

    self.node_advance:setVisible(false)
    self.node_progress_stage:setVisible(false)

    self.progress_label:setLocalZOrder(50)

    -- 實際分進度條
	self.progress_stage_1 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("super-stage/progress-1-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 1))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    :setAnchorPoint(cc.p(0.5, 0.5))
    self.progress_stage_bg:addChild(self.progress_stage_1, 10)
    self.progress_stage_1:setPosition(self.progress_stage_bg:getContentSize().width / 2 ,self.progress_stage_bg:getContentSize().height / 2 + 2)

    -- 保護分進度條
	self.progress_stage_2 = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("super-stage/progress-1-1.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 1))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    :setAnchorPoint(cc.p(0.5, 0.5))
    self.progress_stage_bg:addChild(self.progress_stage_2, 20)
    self.progress_stage_2:setPosition(self.progress_stage_bg:getContentSize().width / 2 ,self.progress_stage_bg:getContentSize().height / 2 + 2)

    -- 當前不顯示保護分，ps：智睿說的
    self.progress_stage_2:setVisible(false)
    self.lbl_stage_tip:setVisible(false)

    self:initDone()
    self:updateLayer()

    self:addTimer("timer", 1000, handler(self, self.update), true)
    self:update(0)
end

function SuperStageMainRegularLayer:update(dt)
    local super_stage_data = ex.Player.super_stage_data
    local now = ex.Game:getServerTime()

    if super_stage_data.season_down_start_time > now then
        self.lbl_season_time_tip_2:setXmlTextLua(string.format(ex.Tools:getLang(76062),
                                                                ex.StringUtil.convertToTimeFormat(super_stage_data.season_down_start_time - now, 4)))
    else
        self.lbl_season_time_tip_2:setXmlTextLua(string.format(ex.Tools:getLang(76063),
                                                                ex.StringUtil.convertToTimeFormat(super_stage_data.match_end_time - now, 4)))
    end
    self.lbl_season_time_tip_2:formatText()
end

function SuperStageMainRegularLayer:initDone()
    self:addEvent(EVENT.SUPER_STAGE.UPDATE_INFO, handler(self, self.updateLayer))
    self:addEvent(EVENT.SUPER_STAGE.ADD_MATCH_TIMES, handler(self, self.addTimesDone))
    
    self:addEvent(EVENT.VIDEO_STUDIO_EVENT.VIDEO_PLAY_BACK_REQ,handler(self,self.onBattleReq))
    
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS_WZZL, self.btn_activity)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS_SDLJ, self.btn_result_reward)
    ex.RedDotManager:setStickNode(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS_KSPP, self.btn_match)

    -- 如果段位赛阵容为空，则将主线阵容保存进段位赛阵容里去
    local battle_type = BattleType.SUPER_STAGE
    local battle_config = cfg.battletype.battletype[battle_type]
    local vec_selected = ex.Player.lineup_data:getIdList(battle_config.line_up_type, {NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID})
    local is_lineup_empty = true
    for i,v in ipairs(vec_selected) do
        if v ~= NULL_ID then
            is_lineup_empty = false
            break
        end
    end
    if is_lineup_empty then
        local vec_selected, fetter_type, formation_id = ex.Player.lineup_data:getIdList(0, {NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID})
        ex.Player.lineup_data:setLineupById(battle_config.save_line_up_type, vec_selected, fetter_type, formation_id)
    end

    -- 請求刷新數據
	ex.Player.super_stage_data:reqInfo(true)
end

function SuperStageMainRegularLayer:updateLayer()
    local super_stage_data = ex.Player.super_stage_data
    local config_stage = cfg.superstage.superstage[super_stage_data.cur_stage_id]
    if config_stage == nil then
        return
    end

    -- 活動已結束，則直接跳轉會主城
    if not super_stage_data:isOpen() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
        return
    end

    local now = ex.Game:getServerTime()

    -- 赛季阶段时间显示刷新
    local time_start = os.date("*t", super_stage_data.season_start_time)
    local time_end = os.date("*t", super_stage_data.season_end_time)
    self.lbl_season_time_tip:setXmlTextLua(string.format(ex.Tools:getLang(74932),
                                                         super_stage_data.cur_season,
                                                         time_start.month, 
                                                         time_start.day, 
                                                         time_end.month, 
                                                         time_end.day))
    self.lbl_season_time_tip:formatText()

    self.lbl_tip_qualification:setVisible(super_stage_data.pinnacle_stage == 5 and super_stage_data.preliminary_qualification)

    -- 个人段位显示刷新
    ex.Tools:setSpriteFrame(self.spr_stage_icon, "super-stage-icon/rank-1-"..config_stage.icon_idx..".png")
    self.lbl_stage_name:setString(ex.Tools:getLang(config_stage.name_lang))

    local config_stage_next = cfg.superstage.superstage[super_stage_data.cur_stage_id + 1]
    if config_stage_next == nil then
        config_stage_next = config_stage
    end
    self.lbl_next_rank:setString(ex.Tools:getLang(74809)..ex.Tools:getLang(config_stage_next.name_lang))
    self.lbl_next_rank:setVisible(config_stage_next.idx ~= config_stage.idx)

    if super_stage_data.qualifying_match or super_stage_data.integral >= config_stage.integral_limit then
        -- 个人段位晋级赛阶段结果显示
        self.node_advance:setVisible(true)
        self.node_progress_stage:setVisible(false)
        self.node_advance:removeAllChildren()

        for i=1,config_stage.advance_num do
            local result = super_stage_data.vec_advance_result[i]

            local spr_bg = cc.Sprite:createWithSpriteFrameName("super-stage/spr-stat.png")
            spr_bg:setPosition((i - config_stage.advance_num / 2 - 0.5) * 60, 30)
            self.node_result:addChild(spr_bg)

            if result ~= nil then
                -- 顯示戰鬥結果
                local spr_result = cc.Sprite:createWithSpriteFrameName("super-stage/spr-"..(result > 0 and "yes" or "no")..".png")
                spr_result:setPosition(spr_bg:getContentSize().width / 2, spr_bg:getContentSize().height / 2)
                spr_bg:addChild(spr_result)
            end
        end
    else
        -- 当前段位进度显示
        self.node_advance:setVisible(false)
        self.node_progress_stage:setVisible(true)

        self.progress_label:setString(super_stage_data.integral.."/"..config_stage.integral_limit)

        self.progress_stage_1:setPercentage(super_stage_data.integral * 100 / config_stage.integral_limit)
        self.progress_stage_2:setPercentage(config_stage.protection_integral * 100 / config_stage.integral_limit)

        self.progress_stage_1:setLocalZOrder(super_stage_data.integral > config_stage.protection_integral and 10 or 30)
        self.progress_stage_2:setLocalZOrder(20)
    end

    -- 段位首達奖励显示
    local config_stage_reward = cfg.superstage.superstage[super_stage_data.reward_idx + 1]
    if config_stage_reward == nil then
        config_stage_reward = config_stage
    end
    self.lbl_reward_tip:setXmlTextLua(string.format(ex.Tools:getLang(74810), ex.Tools:getLang(config_stage_reward.name_lang)))
    self.lbl_reward_tip:formatText()

    local item_scale = 0.75
    self.menu_reward:removeAllChildren()
    for i,v in ipairs(config_stage_reward.first_reward) do
        local item_backpack = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item_backpack:registerScriptTapHandler(handler(self, self.onItemInfo))
        item_backpack:setPosition(120 * item_scale * (i - 0.5), 0)
        item_backpack:setScale(item_scale)
        self.menu_reward:addChild(item_backpack)
    end
    self.btn_result_reward:setEnabled(config_stage_reward.idx == super_stage_data.reward_idx + 1 and super_stage_data.cur_stage_id >= config_stage_reward.idx)

    -- 檢測是否顯示匹配按鈕
    local can_match = super_stage_data:canMatch()
    self.btn_match:setVisible(can_match)
    self.node_times:setVisible(can_match)
    self.lbl_match_tip:setVisible(not can_match)
    if not can_match then
        local now = ex.Game:getServerTime()
        if now >= super_stage_data.match_end_time then
            self.lbl_match_tip:setString(ex.Tools:getLang(74851))
        else
            self.lbl_match_tip:setString(ex.Tools:getLang(74850))
        end
    end

    -- 更新我的排名
    if super_stage_data.rank <= 0 then
        self.lbl_my_rank:setString(ex.Tools:getLang(74811)..ex.Tools:getLang(74812))
    else
        self.lbl_my_rank:setString(ex.Tools:getLang(74811)..super_stage_data.rank)
    end

    -- 更新匹配次数显示
    self.lbl_times:setString(string.format("%s/%s", super_stage_data.battle_times_left, ex.Tools:getSysCfg("super_stage_daily_matches")))
    self.lbl_times_buy:setString(super_stage_data.battle_times_buy_left)
    self.lbl_times_buy:setVisible(super_stage_data.battle_times_buy_left > 0)
    self.lbl_times_buy_title:setVisible(super_stage_data.battle_times_buy_left > 0)
end

-- 播放個人挑戰戰報
function SuperStageMainRegularLayer:onBattleReq(event,data)
	local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = data.battle_id
    req_battle.type = data.type
	NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    local battle_layer = self:addBattleLayer(BattleType.SUPER_STAGE,
                                            MainSceneType.MAINCITY_SUPER_STAGE_MAIN,
                                            "",
                                            data.type,
                                            function()
                                                return true, false
                                            end)
	battle_layer:showCloseBtn(true)
	battle_layer:showSpeedBtn(true,false)
    battle_layer:setScale(1.0 / self:getScaleX())
    battle_layer:setPosition(self:getContentSize().width * 0.5 - ex.p.width  * 0.5,
                             self:getContentSize().height * 0.5  - ex.p.height * 0.5)
                             
    require("src.layer.superstage.SuperStageHistoryCtr"):instance():closeWindow()
    require("src.layer.superstage.SuperStageHistoryVideoCtr"):instance():closeWindow()
end

function SuperStageMainRegularLayer:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 功能说明
function SuperStageMainRegularLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42090), ex.Tools:getLang(42091))
end

-- 赛季传奇
function SuperStageMainRegularLayer:onLegend(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_LEGEND)
end

-- 队形调整
function SuperStageMainRegularLayer:onLineup(tag, pSender)
    require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47546),
                                                             ex.Tools:getLang(47396),
                                                             BattleType.SUPER_STAGE,
                                                             handler(self, self.onLineupDone))
end

-- 队形调整回调
function SuperStageMainRegularLayer:onLineupDone()
    
end

-- 段位说明
function SuperStageMainRegularLayer:onRankInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42092), ex.Tools:getLang(42093))
end

-- 个人记录
function SuperStageMainRegularLayer:onAcount(tag, pSender)
    require("src.layer.superstage.SuperStageAccountCtr"):instance():openWindow(ex.Player.role_id, cc.UserDefault:getInstance():getIntegerForKey("server_id", 1))
end

-- 挑战记录
function SuperStageMainRegularLayer:onHistory(tag, pSender)
    local super_stage_data = ex.Player.super_stage_data
    local config_stage = cfg.superstage.superstage[super_stage_data.cur_stage_id]
    if config_stage == nil then
        return
    end

    require("src.layer.superstage.SuperStageHistoryCtr"):instance():openWindow(function(tab_type)
        if tab_type == 1 then
            NetManager:sendMessage(ProtocolID.GReqMyVideo)
        else
            NetManager:sendMessage(ProtocolID.GReqGreatStyle)
        end
    end,
    function(select_type)
        if select_type == 1 then
            return ex.Player.super_stage_data.vec_battle_log
        else
            return ex.Player.super_stage_data.vec_super_battle_log
        end
    end,
    ex.Tools:getLang(74825),
    ex.Tools:getLang(config_stage.name_lang))
end

-- 段位商城
function SuperStageMainRegularLayer:onShop(tag, pSender)
    ex.JumpManager:jumpByAtom("main_black_market_stage")
end

-- 奖励一览
function SuperStageMainRegularLayer:onReward(tag, pSender)
    require("src.layer.superstage.SuperStageRewardCtr"):instance():openWindow()
end

-- 段位战令
function SuperStageMainRegularLayer:onActivity(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_TOKEN)
end

-- 排行
function SuperStageMainRegularLayer:onRank(tag, pSender)
    local now = ex.Game:getServerTime()

    local rank_visible_offset = ex.Tools:getSysCfg("super_stage_rank_show_time")
    rank_visible_offset = (rank_visible_offset == nil or rank_visible_offset == "") and 0 or tonumber(rank_visible_offset)

    if ex.Player.super_stage_data.season_start_time + rank_visible_offset > now then
        ex.MessageView:add(ex.Tools:getLang(74947))
        return
    end

    require("src.layer.superstage.SuperStageRankCtr"):instance():openWindow()
end

-- 首達獎勵领奖
function SuperStageMainRegularLayer:onResultReward(tag, pSender)
    NetManager:sendMessage(ProtocolID.GReqReceiveAward)
end

-- 战斗匹配
function SuperStageMainRegularLayer:onMatch(tag, pSender)
    -- 活動已結束，則直接跳轉會主城
    if not ex.Player.super_stage_data:isOpen() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
        return
    end
    if not ex.Player.super_stage_data:canMatch() then
        self:updateLayer()
        return
    end

    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_MATCH)
end

-- 购买战斗次数
function SuperStageMainRegularLayer:onAddTimes(tag, pSender)
    local super_stage_data = ex.Player.super_stage_data
    local buy_times = tonumber(ex.Tools:getSysCfg("super_stage_buy_times")) - super_stage_data.battle_times_buy_left
    local res_need = cfg.superstagebuyconsume.consume[buy_times + 1]
    if res_need == nil then
        ex.MessageView:add(ex.Tools:getLang(74935))
        return
    end
    res_need = res_need.consume[1]

    -- 打开购买确认框
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), 
                             string.format(ex.Tools:getLang(74934), res_need.item_num), 
                             function()
                                 if res_need.item_num > ex.Player:getItemNum(res_need.item_type) then
                                    ex.Tools:showEnoughTip(res_need.item_type, true)
                                    return
                                 end
                                 NetManager:sendMessage(ProtocolID.GReqPurchases)
                             end)
end

function SuperStageMainRegularLayer:addTimesDone()
    local super_stage_data = ex.Player.super_stage_data
    self.lbl_times:setString(string.format("%s/%s", super_stage_data.battle_times_left, ex.Tools:getSysCfg("super_stage_daily_matches")))
    self.lbl_times_buy:setString(super_stage_data.battle_times_buy_left)
    self.lbl_times_buy:setVisible(super_stage_data.battle_times_buy_left > 0)
    self.lbl_times_buy_title:setVisible(super_stage_data.battle_times_buy_left > 0)
end

function SuperStageMainRegularLayer:onExit()

end

return SuperStageMainRegularLayer
