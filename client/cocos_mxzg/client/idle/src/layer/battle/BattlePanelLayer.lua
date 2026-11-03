local BattlePanelLayer = class("BattlePanelLayer", require("src.comp.EventLayer"))

function BattlePanelLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setAnchorPoint(cc.p(0,0))
    self:setIgnoreAnchorPointForPosition(false)
    
    self.panel_height = 300
    self.panel_scale = 1

    self.progress_AFK = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("main-scene/progress-AFK.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.menu:getParent():addChild(self.progress_AFK)

    self.progress_AFK:setPosition(self.spr_progress_AFK_bg:getPosition())
    self.progress_AFK:setPercentage(50)

    -- 领取挂机奖励按钮
    self.btn_harvest = cpp.UIMenuItemImage:create()
    self.btn_harvest:setName("btn_harvest")
    self.btn_harvest:setEnableAction(false)
    self.btn_harvest:registerScriptTapHandler(handler(self, self.goCoffeeCtr))
    self.btn_harvest:setAnchorPoint(0.5, 0)
    self.btn_harvest:setContentSize(cc.size(ex.p.width, 100))
    self.btn_harvest:setPosition(321 + 37 * ex.s.global_scale, 240)
    self.btn_harvest:setScale(1.0 / ex.s.global_scale)
    self.menu:addChild(self.btn_harvest)
    self.btn_harvest.status = -1

    self.btn_lineup:setName("btn_lineup")
    self.btn_speed_battle:setName("btn_speed_battle")
    self.btn_battle:setName("btn_battle")

    self.btn_map:setContentSize(cc.size(10, 10))
    self.btn_icon:setContentSize(cc.size(50, 50))

    self.spr_world_icon:removeFromParent(false)
    self.spr_world_icon:setPosition(self.btn_icon:getContentSize().width * 0.5, self.btn_icon:getContentSize().height * 0.5)
    self.btn_icon:addChild(self.spr_world_icon)

    self.spr_box:setLocalZOrder(1)
    self.spr_bubble:setLocalZOrder(1)
    self.lbl_progress_time:setLocalZOrder(1)
    self.lbl_progress_time2:setLocalZOrder(1)
    
    self:updateBtnHarvestSpineAction()
    self:updateMissionReward()

    self:addEvent(EVENT.BATTLE_EVENT.BATTLE_END, handler(self, self.updateMissionReward))
    self:addEvent(EVENT.BATTLE_EVENT.UPDATEREWARD, handler(self, self.updateReward))
    self:addEvent(EVENT.BATTLE_EVENT.STATUS_CHANGE, handler(self, self.updateMissionBtn))
    self:addEvent(EVENT.BACKPACK_RES_CHANGE.ROLE_LEVEL, handler(self, self.playerUplevel))
    self:addEvent(EVENT.BATTLE_EVENT.HANG_HERO_DEAD, function(evt, pos)
        self:runResCollectAction(pos.x, pos.y)
    end)

    self:addTimer("reward", 1000, handler(self, self.updateReward), true)
    -- self.scheduler_reward = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateReward), 1, false)
    self:updateReward()
    self:addRedDotNode(RedDotType.ZCJ_DHZD_KSZD, self.btn_speed_battle)
    -- ex.EventManager:fire(EVENT.BATTLE_EVENT.BATTLE_END, true, data.idx)
end

function BattlePanelLayer:onExit()
    self:removeTimerByName("reward")
	-- if self.scheduler_reward ~= nil then 
	-- 	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_reward)
	-- 	self.scheduler_reward = nil
	-- end
end

function BattlePanelLayer:getBattleHarvestProgress()
    local reward_time = ex.Player.chapter_data.res_reward_time
    if reward_time <= 0 then
        return 0
    end

    local now_time = ex.Game:getServerTime()
    local left_time = now_time - reward_time
    local max_time = ex.Player.chapter_data.max_reward_time

    local percentage = left_time / max_time * 100
    if percentage < 0 then
        percentage = 0
    elseif percentage > 100 then
        percentage = 100
    end
    percentage = math.floor(percentage)
    return percentage
end

function BattlePanelLayer:getBattleHarvestStatus(percentage)
    -- print("BattleLayer:getBattleHarvestStatus: ", percentage, ex.Player.chapter_data.gold)
    local status = 0
    if percentage <= 2 then
        status = 1
    elseif percentage > 2 and percentage <= 5 then
        status = 2
    elseif percentage > 5 and percentage <= 10 then
        status = 3
    elseif percentage > 10 then
        status = 4
    end
    return status
end

function BattlePanelLayer:onIdleReward()
        local now_time = cpp.Game:instance():getServerTime()
        if now_time - ex.Player.chapter_data.res_reward_time < ex.Tools:getSysCfg("idle_drop_frequency") + 5 then
            ex.MessageView:add(ex.Tools:getLang(41160))
            return
        end
        
        local progress = self:getBattleHarvestProgress()
        local status = self:getBattleHarvestStatus(progress)
    
        ex.Player.chapter_data.res_reward_time = now_time
    
        ex.Player.chapter_data.exp = 0
        ex.Player.chapter_data.gold = 0
        ex.Player.chapter_data.hero_exp = 0
    
        local req = Battle_pb.GReqChapterItemReward()
        NetManager:sendMessage(ProtocolID.GReqChapterItemReward, req)
    
        self:updateReward()
        self:runBtnHarvestCollectSpineAction(status)
end

-- 点击快速战斗，挂机奖励，满足判断条件弹出二次确认窗口
function BattlePanelLayer:goCoffeeCtr(tag, pSender)
    local chapter_data = cfg.chapterreward.chapterreward[ex.Player.chapter_data.chapter_id]
    if chapter_data == nil then
        return
    end

    if ex.Player.pub_task.adventure_count >= chapter_data.tavern_point_max then
        -- require("src.layer.GoCoffeeCtr"):instance():openWindow(ex.Tools:getLang(3500),ex.Tools:getLang(2220), handler(self, self.onIdleReward)) 
        ex.ConfirmCtr:instance():openWindow(ex.Tools:getLang(3500),ex.Tools:getLang(2220),handler(self, self.onIdleReward))
    else
        self:onIdleReward()
    end
end

function BattlePanelLayer:updateReward()
    local config = cfg.chapterreward.chapterreward[Maths.clampf(ex.Player.chapter_data.chapter_id, 1, ex.Player.chapter_data.max_chapter_id)]
    if config then
        local reward_base = config.reward_base
        for i, v in ipairs(reward_base) do
            if v.item_type == ItemType.IT_GOLD then
                self.lbl_gold:setString(""..(v.item_num ).."/m")
            elseif v.item_type == ItemType.IT_ROLE_EXP then
                self.lbl_exp:setString(""..(v.item_num).."/m")
            elseif v.item_type == ItemType.IT_HERO_EXP then
                self.lbl_souls:setString(""..(v.item_num).."/m")
            end
        end
    end
    self:updateBtnHarvestSpineAction()

end

function BattlePanelLayer:updateBtnHarvestSpineAction()
    if self.collect_time ~= nil and self.collect_time + 2 > ex.Game:getServerTime() then
        return
    end

    local percentage = self:getBattleHarvestProgress()
    local status = self:getBattleHarvestStatus(percentage)

    local left_time = ex.Game:getServerTime() - ex.Player.chapter_data.res_reward_time
    local max_time = ex.Player.chapter_data.max_reward_time
    if status <= 0 or  left_time < 0 then
        left_time = 0
    elseif left_time > max_time then
        left_time = max_time 
    end
    self.progress_AFK:setPercentage(percentage)
    self.lbl_progress_time:setString(string.format("%02d:%02d", math.floor(left_time / 3600), math.floor((left_time - math.floor(left_time / 3600) * 3600) / 60)))
    self.lbl_progress_time2:setString(string.format("%02d:%02d", math.floor(left_time / 3600), math.floor((left_time - math.floor(left_time / 3600) * 3600) / 60)))

    -- 收益时间大于10分钟才显示气泡
    local show_time = ex.Tools:getSysCfg("battle_bubble_show_time")
    self.spr_bubble:setVisible(left_time > show_time)
    self.lbl_progress_time2:setVisible(left_time > show_time)


    if self.btn_harvest.status == status then
        return
    end

    self.btn_harvest.status = status

    if self.btn_harvest.spine_block ~= nil then
        self.btn_harvest.spine_block:removeFromParent()
        self.btn_harvest.spine_block = nil
    end

    if self.btn_harvest.spine_block == nil then
        self.btn_harvest.spine_block = sp.SkeletonAnimation:create("spine/res-block.json","spine/res-block.atlas", 1)
        self.btn_harvest.spine_block:setPosition(80, 0)
        self.btn_harvest.spine_block:setScale(ex.p.width / 600)
        self.btn_harvest:addChild(self.btn_harvest.spine_block, 20)
    end
    self.btn_harvest.spine_block:setVisible(true)
    self.btn_harvest.spine_block:setAnimation(0, "normal-"..status, true);
end

function BattlePanelLayer:runBtnHarvestCollectSpineAction(status)
    self.btn_harvest.status = -1

    if self.btn_harvest.spine_block ~= nil then
        self.btn_harvest.spine_block:removeFromParent()
        self.btn_harvest.spine_block = nil
    end

    if self.btn_harvest.spine_block == nil then
        self.btn_harvest.spine_block = sp.SkeletonAnimation:create("spine/res-block.json","spine/res-block.atlas", 1)
        self.btn_harvest.spine_block:setPosition(80, 0)
        self.btn_harvest.spine_block:setScale(ex.p.width / 600)
        self.btn_harvest:addChild(self.btn_harvest.spine_block, 20)
    end
    self.btn_harvest.spine_block:setVisible(true)
    self.btn_harvest.spine_block:setAnimation(0, "collect-"..status, true);
    self.btn_harvest.spine_block:addAnimation(0, "normal-"..0, true, 1.5);

    self.collect_time = ex.Game:getServerTime()
end


function BattlePanelLayer:runResCollectAction(start_pos_x, start_pos_y)
    local vec_res_type = {}
    table.insert(vec_res_type, 900001)
    table.insert(vec_res_type, 900002)
    table.insert(vec_res_type, 900003)
    table.insert(vec_res_type, 900101)
    table.insert(vec_res_type, 900102)

    local res_type_num = table.nums(vec_res_type)
    local total_num_rand = math.random(8, 12)
    for i = 1, total_num_rand do
        local res_rand = math.random(1, 4)
        local spr_res = cc.Sprite:createWithSpriteFrameName("backpack/"..vec_res_type[res_rand]..".png")
        spr_res:setLocalZOrder(math.random(1000, 10000))
        spr_res:setScale(0.6 + math.random(1, 40) / 200)
        spr_res:setPosition(cc.p(start_pos_x - 50 + math.random(1, 100), start_pos_y - 50 + math.random(1, 100)))
        self:addChild(spr_res)

        local act_move = cc.MoveTo:create(1, cc.p(80, self.btn_harvest:getPositionY() + 30))
        local act_scale = cc.ScaleTo:create(0.9 + math.random(1, 20) / 200, 0.6)
        local act_seq = cc.Sequence:create(act_move, cc.RemoveSelf:create(), nil)
        spr_res:runAction(act_seq)
        spr_res:runAction(act_scale)
    end
end

-- 点击了世界选择
function BattlePanelLayer:onWorld()
    -- require("src.layer.ChapterSelectCtr"):instance():openWindow(handler(self, self.onWorldSelect))
end

function BattlePanelLayer:onRewardInfo(tag, pSender)
    require("src.layer.MissionRewardInfoCtr"):instance():openWindow()
end

function BattlePanelLayer:onBattle()
    local now_idx = ex.Player.chapter_data.chapter_id + 1
	local status = ex.Player.chapter_data:getBattleStatus(now_idx, ex.Player.level)
	local chapter_config = cfg.chapterreward.chapterreward[now_idx]

	if status == -3 then
		ex.MessageView:add(string.format(ex.Tools:getLang(47214), chapter_config.level))
		return
    end
    
    if status == -4 then
        ex.MessageView:add(ex.Tools:getLang(41202))
        return
    end

    if self.creator:getLayerType() ~= 0 then
        ex.MessageView:add(ex.Tools:getLang(47303))
        return
    end
    
	require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47524),
										 				     ex.Tools:getLang(47064),
										 					 BattleType.CHAPTER,
										 					 handler(self, self.onBattleDone))
end

function BattlePanelLayer:onBattleDone(vec_hero, fetter_type)
    if self.creator:getLayerType() ~= 0 then
        ex.MessageView:add(ex.Tools:getLang(47303))
        return
    end
    
    self.creator:onBattle()
end

function BattlePanelLayer:onLineup()
    require("src.layer.heroinfo.HeroSuggestCtr"):instance():openWindow()
end

function BattlePanelLayer:onLineupDone(vec_hero, fetter_type)
    
end

-- 快速战斗
function BattlePanelLayer:onSpeedBattle(tag, pSender)
    require("src.layer.QuickBattleCtr"):instance():openWindow()
end

-- 显示关卡奖励
function BattlePanelLayer:updateMissionReward(tag, pSender)

    local chapter_id = Maths.clampf(ex.Player.chapter_data.chapter_id + 1, 1, ex.Player.chapter_data.max_chapter_id)
    self.lbl_mission_name:setString(chapter_id)
    local config = cfg.chapterreward.chapterreward[chapter_id]

    ex.Tools:try(function()
        if config then
            self.lbl_map:setString(ex.Tools:getLang(config.name))
            local texture = cc.Director:getInstance():getTextureCache():getTextureForKey(string.format("ccbi-res/chapter/chapter-world/%s.png", config.map))
            if texture then
                self.spr_world:setTexture(texture)
            end
        end

        -- ex.Tools:setSpriteFrame(self.spr_world_icon, string.format("backpack/%s.png", config.icon))
        -- self.spr_world_icon:setScale(50 / self.spr_world_icon:getContentSize().width)
    end)
end

function BattlePanelLayer:playerUplevel(evt, level)
    ex.EventManager:fire(EVENT.BATTLE_EVENT.STATUS_CHANGE, self.creator:getLayerType(), level)
end

function BattlePanelLayer:updateMissionBtn(evt, type, level)
    local now_idx = ex.Player.chapter_data.chapter_id + 1
	local status = ex.Player.chapter_data:getBattleStatus(now_idx, level or ex.Player.level)
    local chapter_config = cfg.chapterreward.chapterreward[now_idx]

    if self.btn_battle.spr_effect ~= nil then
        self.btn_battle.spr_effect:removeFromParent()
        self.btn_battle.spr_effect = nil
    end

    self.btn_battle:setLabelSize(60)
    self.btn_battle:setLabelOutLine(cc.c3b(70,6,255), 2)
    ex.Tools:setSpriteFrame(self.btn_battle:getNormalImage(), "button/btn-buy-5.png")

    if status == -3 then
        -- ex.MessageView:add(string.format(ex.Tools:getLang(47214), chapter_config.level))
        self.btn_battle:setLabelSize(47)
        self.btn_battle:setLabelText(string.format(ex.Tools:getLang(47425), chapter_config.level))
		return
	end

    if status == -4 then
        self.btn_battle:setLabelText(ex.Tools:getLang(47369))
        return
    end

    if type ~= 0 then
        self.btn_battle:setLabelText(ex.Tools:getLang(47706))
        self.btn_battle:setLabelOutLine(cc.c3b(215,27,71), 2)
        ex.Tools:setSpriteFrame(self.btn_battle:getNormalImage(), "button/btn-buy-6.png")
        return
    end

    self.btn_battle:setLabelText(ex.Tools:getLang(1003))
    -- self.btn_battle:setLabelText(ex.Tools:getLang(5415))
    local eff2 = ex.EffectCtr:playNormalEff(18, self.btn_battle:getContentSize().width * 0.5, self.btn_battle:getContentSize().height * 0.5, nil, self.btn_battle, 11, nil, nil, nil, 1)
    -- eff2:setScale(scale)
    self.btn_battle.spr_effect = eff2.anim.anim

end

return BattlePanelLayer