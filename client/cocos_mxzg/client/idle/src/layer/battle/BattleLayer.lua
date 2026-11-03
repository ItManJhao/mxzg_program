local BattleLayer = class("BattleLayer", require("src.comp.EventLayer"))

--[[
    界面由以下几个部分组成
    BattlePanel （底部的战斗按钮、挂机、关卡奖励显示）
    BattleMissionLayer （展示战斗开始部分）
    BattleIdleLayer（展示挂机部分）

    在线奖励、通关奖励等顶部按钮由自身生成
]]

BattleLayer.BattleType = {
    BT_IDLE = 0,
    BT_BATTLE = 1,
}

function BattleLayer:onExit()
    self:removeTimerByName("battle_end")
    if self.callback_update then
      cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.callback_update)
      self.callback_update = nil
  	end

    cpp.Game:stopBackgroundMusic()

    local reddot_manager = ex.RedDotManager
    reddot_manager:removeStickNode(RedDotType.ZCJ_DHZD_TGJL, self.btn_chapter_reward)
    reddot_manager:removeStickNode(RedDotType.ZCJ_DHZD_ZXZD, self.btn_battle)
    reddot_manager:removeStickNode(RedDotType.ZCJ_DHZD_KSZD, self.btn_speed_battle)
end

function BattleLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    
    self.start_battle_time = 0

	local win_size = cc.Director:getInstance():getWinSize()
	self:setContentSize(win_size)
	local main_ctr = require("src.scene.MainSceneCtr"):instance()
	local top_height = win_size.height - require("src.model.Game"):instance():getNotchHeight() - 122 - 42
    local bottom_height = ex.MainSceneCtr:getBottomHeight()

    self.node_panel = require("src.layer.battle.BattlePanelLayer"):createWithCCBIFile("ccbi/BattlePanelLayer.ccbi")
    self.node_panel.creator = self
    self.node_panel:setScale(ex.p.width / self.node_panel:getContentSize().width)
    self.node_panel:setPosition(0, bottom_height - 45 * self.node_panel:getScale())
    self:addChild(self.node_panel)

    -- 通关收益
    self.passChapter = require("src.layer.PassChapterTipsCtr"):createWithCCBIFile("ccbi/PassChapterTipsLayer.ccbi")
    self.passChapter:setScale(0.8)
    self:addChild(self.passChapter)

    local posX = win_size.width/2 - self.passChapter:getContentSize().width / 2
    local posY = win_size.height/2 - self.passChapter:getContentSize().height / 2
    self.passChapter:setPosition(posX, posY + win_size.height * 0.1)


    self.btn_task_progress_bg = cpp.UIMenuItemImage:createWithSpriteFrameName("other/spr-pubtask-3.png", nil, nil)
    self:addChild(self.btn_task_progress_bg)
    self.btn_task_progress_bg:setPosition(win_size.width - 70, top_height - 180)

    self.progressEndTimer = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("other/spr-pubtask-2.png"))
    :setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    :setPosition(win_size.width - 70, top_height - 180)
    --:setMidpoint(cc.p(0, 0.5))
    :setReverseDirection(true) 
    --:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化

    self:addChild(self.progressEndTimer)

    self.progressEndTimer:setPercentage(0)


    local menu_scene = cpp.UIMenu:create()
    menu_scene:setPosition(0,0)
    self:addChild(menu_scene)
    
    -- 关卡奖励
    self.btn_chapter_reward = cpp.UIMenuItemImage:createWithSpriteFrameName("main-scene-lang/btn-reward-1.png", nil, nil)
    self.btn_chapter_reward:registerScriptTapHandler(handler(self, self.onChapterReward))
    -- self.btn_chapter_reward:setScale(0.85)
    self.btn_chapter_reward:setPosition(win_size.width - 70, top_height)
    menu_scene:addChild(self.btn_chapter_reward)

    -- 任务奖励
    self.btn_task = cpp.UIMenuItemImage:createWithSpriteFrameName("main-city/icon-act_achievement.png", nil, nil)
    self.btn_task:setPosition(win_size.width - 160, top_height)
    self.btn_task:registerScriptTapHandler(handler(self, self.onTask))
    self.btn_task:setName("act_achievement_battle")
    menu_scene:addChild(self.btn_task)
    self.btn_task:setTag(4)
    

    -- 酒馆
    self.btn_pubtask = cpp.UIMenuItemImage:createWithSpriteFrameName("other/spr-pubtask-1.png", nil, nil)
    self.btn_pubtask:setPosition(win_size.width - 68, top_height - 180)
    self.btn_pubtask:registerScriptTapHandler(handler(self, self.onPubTask))
    menu_scene:addChild(self.btn_pubtask)

    self.pub_text_bg = cpp.UIMenuItemImage:createWithSpriteFrameName("other/spr-pubtask-k.png", nil, nil)
    self:addChild(self.pub_text_bg)
    self.pub_text_bg:setPosition(win_size.width - 70, top_height - 228)

    self.task_item_nums = cc.Label:createWithTTF(ex.Tools:getLang(2201), FONT_DEFAULT_NAME_BOLD, 40)
    :setTextColor(FONT_WHITLE)
    :setScale(0.5)
    :setPosition(self.pub_text_bg:getContentSize().width * 0.5, self.pub_text_bg:getContentSize().height* 0.5)
    self.pub_text_bg:addChild(self.task_item_nums)

    self.task_item_nums:setString(ex.Player.pub_task.adventure_count)

    -- 世界等级
    self.btn_world_level = cpp.UIMenuItemImage:createWithSpriteFrameName("button/btn-world-level.png", nil, nil)
    self.btn_world_level:setPosition(self.btn_task:getPositionX() - 80, self.btn_task:getPositionY())
    self.btn_world_level:registerScriptTapHandler(function()
        local pos_x, pos_y = self.btn_world_level:getPosition()
        
        local world_level_ctr = require("src.layer.WorldLevelCtr"):instance()
        world_level_ctr:setPosition(cc.p(pos_x + 20, pos_y), 30)
        world_level_ctr:openWindow(ex.Player.world_level)
    end)
    self.btn_world_level:setName("act_world_level")
    menu_scene:addChild(self.btn_world_level)
    self.btn_world_level:setTag(4)
    
    local createIcon = function()
        -- 在线奖励
        if ex.Player.onlineReward_data:isOpen() then 
            self.btn_online_reward = require("src.layer.onlinereward.OnlineRewardIcon"):createWithData("")
            menu_scene:addChild(self.btn_online_reward)
            self.btn_online_reward:setPosition(80,self.btn_chapter_reward:getPositionY() - 10)
            self.btn_online_reward:setName("act_online_reward")
            self.btn_online_reward:registerScriptTapHandler(handler(self, self.onOnlineReward))
            self:addEvent(EVENT.ONLINE_REWARD.CLOSE_OTHER, handler(self, self.onlineRewardRemove))
        end

        -- if ex.Player.fetter_data:isUnlockAll() ~= true then 
        --     self.btn_fetter_reward = require("src.layer.fetters.FetterBattleIcon"):createWithData("")
        --     menu_scene:addChild(self.btn_fetter_reward)
        --     self.btn_fetter_reward:setPosition(80, self.btn_chapter_reward:getPositionY() - 150)
        --     self.btn_fetter_reward:registerScriptTapHandler(handler(self, self.onFetter))
        --     self.btn_fetter_reward:setName("btn_fetter_reward")
        -- end

        if ex.Player.chapter_data:isExtraRewardAll() ~= true then
            -- local pos_y = ex.Player.fetter_data:isUnlockAll() ~= true and 320 or 190
            -- local pos_y = 180
            local pos_y = ex.Player.onlineReward_data:isOpen() and 200 or 70
            local item = cpp.UIMenuItemImage:createWithSpriteFrameName(nil, nil, nil)
            item:setPosition(80, self.btn_chapter_reward:getPositionY() - pos_y)
            item:registerScriptTapHandler(handler(self, self.onExtraReward))
            menu_scene:addChild(item)

            self.extra_reward_cell = require("src.layer.battle.ChapterExtraRewardCell"):createWithCCBIFile("ccbi/ChapterExtraRewardCell.ccbi")
            self.extra_reward_cell:setPosition(0, 0)
            self.extra_reward_cell:reset()
            self.extra_reward_cell:showBubble()
            item:addChild(self.extra_reward_cell)
            item:setContentSize(self.extra_reward_cell:getContentSize())
            self:addEvent(EVENT.BATTLE_EVENT.EXTRA_REMOVE, handler(self, self.onExtraRemove))
            -- self:addChild(self.extra_reward_cell)
        end
    end

    ex.Tools:try(createIcon, function()
        -- 创建失败。关闭定时器
        self.btn_online_reward:removeTimer()
    end)

    self.vec_keep_layer = {}
    local MainCityLayer = require("src.layer.MainCityLayer")
	self.addKeepLayer = MainCityLayer.addKeepLayer
	self.getKeepLayer = MainCityLayer.getKeepLayer
    self.removeKeepLayer = MainCityLayer.removeKeepLayer

    self.battle_type = BattleLayer.BattleType.BT_IDLE

    
    self:addEvent(EVENT.PUB_TASK_EVENT.PUB_POINTS, handler(self, self.updatePubTaskEndTimer))
    -- self:addEvent(EVENT.BATTLE_EVENT.BATTLE_START, handler(self, self.onBattleDone))
    self:addEvent(EVENT.BATTLE_EVENT.BATTLE_END, handler(self, self.battleMissionEnd))
    self:addEvent(EVENT.BATTLE_EVENT.BATTLE_END, handler(self, self.battleEnd))

    if cpp.SocialPlatform:instance():isDebug() == true then
        self.btn_battle = cpp.UIMenuItemLabel:create("button/btn-orange-4.png",
                                                    "button/btn-orange-4.png",
                                                    ex.Tools:getLang(47182),
                                                    nil)
        self.btn_battle:setLabelColor(cc.c3b(255, 255, 255))
        self.btn_battle:setLabelShadow(cc.c4b(177, 84, 0, 255), cc.size(0, -1), 10)
        self.btn_battle:setLabelOutLine(cc.c4b(177, 84, 0, 255))
        self.btn_battle:setLabelOffset(cc.p(0, -0))
        self.btn_battle:setLabelSize(65)
        self.btn_battle:setLabelScale(0.5)
        self.btn_battle:setPosition(ex.p.width * 0.5,ex.p.height * 0.84)
        self.btn_battle:registerScriptTapHandler(handler(self, self.onTestBattle))
        menu_scene:addChild(self.btn_battle)
    end

    self:battleMissionEnd(nil, nil, nil)
    self:addRedDotNode(RedDotType.ZCJ_DHZD_TGJL, self.btn_chapter_reward)
    self:addRedDotNode(RedDotType.ZCJ_DHZD_RCCJ, self.btn_task)

    -- 战斗胜利。发送领取奖励
    NetManager:sendMessage(ProtocolID.GReqChapterEnd)

    -- dump(cc.Director:getInstance():getTextureCache():getCachedTextureInfo())
    -- ex.EventManager:fire(EVENT.MISSION_EVENT.BATTLE_START, data.report, data.list)
    -- self:startPubTaskEndTimer()
    self:updatePubTaskEndTimer()
end

function BattleLayer:updatePubTaskEndTimer()
    self.task_item_nums:setString(ex.Player.pub_task.adventure_count)


    local  chapter_data = cfg.chapterreward.chapterreward[ex.Player.chapter_data.chapter_id]
    if not chapter_data then 
        return end 
        
    self.progressEndTimer:setPercentage(ex.Player.pub_task.adventure_count / chapter_data.tavern_point_max * 100)
end 

-- function BattleLayer:startPubTaskEndTimer()
--     self:addTimer("pub_task",1000,handler(self,self.updatePubTaskEndTimer)
--         , true 
--     )
-- end



function BattleLayer:onChapterReward(tag, pSender)
    ex.Player.chapter_data:sortReward()
    require("src.layer.ChapterRewardCtr"):instance():openWindow(ex.Player.chapter_data.vec_chapter_reward_status,
                                                                require("src.layer.battle.ChapterRewardCell"))
end


function BattleLayer:onTestBattle(tag,pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MLT_BATTLE_TEST)
end

-- 点击在线奖励
function BattleLayer:onOnlineReward(tag,pSender)
    local atom = pSender:getName()
    ex.JumpManager:jumpByAtom(atom)
end

-- vip任务
function BattleLayer:onFetter(tag,pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.FETTER_MAIN_VIEW)
end

-- 更新在线奖励
function BattleLayer:onOnlineRewardResult(event,data)
    self.btn_online_reward:reset()
end

function BattleLayer:getLayerType()
    return self.battle_type
end

function BattleLayer:onBattle()
    if self:getLayerType() ~= BattleLayer.BattleType.BT_IDLE then
        return
    end

    local now_time = ex.Game:getServerTime()
    if now_time - self.start_battle_time < 5 then
        return
    end
    self.start_battle_time = now_time


    self.battle_type = BattleLayer.BattleType.BT_BATTLE

    self.passChapter:setVisible(false)
    self:setOtherUIVisible(false)


    if self.battle_layer then
        self.battle_layer:runAction(cc.RemoveSelf:create())
        self.battle_layer = nil
    end

    local map_pos = cc.p(0, self.node_panel.panel_height * self.node_panel:getScale())
    local map_size = cc.size(ex.p.width, 637 * self.node_panel.panel_scale * (ex.p.height / 1280))

    self.battle_layer = require("src.layer.battle.BattleMissionLayer"):create()
    self.battle_layer:initData(nil, map_pos, map_size)
    self.battle_layer:setInfoLayer(self)
    self:addChild(self.battle_layer, -1)

    -- self.node_panel:updateMissionBtn()
    NetManager:sendMessage(ProtocolID.GReqBattleMatch)
    ex.EventManager:fire(EVENT.BATTLE_EVENT.STATUS_CHANGE, self.battle_type)

    ex.Tools:autoPlaySceneMusic()
end

-- 关卡战斗开始
function BattleLayer:onBattleDone(evt, data)
    if self.battle_type ~= BattleLayer.BattleType.BT_IDLE then
        return
    end

    -- if self.battle_type ~= BattleLayer.BattleType.BT_IDLE then
    --     return
    -- end
    -- -- 隐藏挂机界面UI
    -- self.node_panel.btn_harvest:setVisible(false)
    -- if self.btn_fetter_reward then self.btn_fetter_reward:setVisible(false)  end
    -- if self.extra_reward_cell then self.extra_reward_cell:setVisible(false)  end

    -- self.battle_type = BattleLayer.BattleType.BT_BATTLE
    -- if self.battle_layer then
    --     self.battle_layer:runAction(cc.RemoveSelf:create())
    --     self.battle_layer = nil
    -- end

    -- local map_pos = cc.p(0, self.node_panel.panel_height * self.node_panel:getScale())
    -- local map_size = cc.size(ex.p.width, 637 * self.node_panel.panel_scale * (ex.p.height / 1280))

    -- self.battle_layer = require("src.layer.battle.BattleMissionLayer"):create()
    -- self.battle_layer:initData(data, map_pos, map_size)
    -- self.battle_layer:setInfoLayer(self)
    -- self:addChild(self.battle_layer, -1)

    -- -- self.node_panel:updateMissionBtn()
    -- ex.EventManager:fire(EVENT.BATTLE_EVENT.STATUS_CHANGE, self.battle_type)

    -- ex.Tools:autoPlaySceneMusic()
end

function BattleLayer:battleMissionEnd(evt, data)
    if self.battle_layer then
        self.battle_layer:runAction(cc.RemoveSelf:create())
        self.battle_layer = nil
    end


    -- ex.Player.chapter_data.chapter_id
    self.node_panel:updateReward()
    self:setOtherUIVisible(true)

    local map_pos = cc.p(0, self.node_panel.panel_height)
    local map_size = cc.size(ex.p.width, 637 * self.node_panel.panel_scale * (ex.p.height / 1280))

    self.battle_type = BattleLayer.BattleType.BT_IDLE
    self.battle_layer = require("src.layer.battle.BattleIdleLayer"):create()
    self.battle_layer:initData(data, map_pos, map_size)
    self:addChild(self.battle_layer, -1)

    ex.EventManager:fire(EVENT.BATTLE_EVENT.STATUS_CHANGE, self.battle_type)
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self.battle_layer, ex.Tools:isInVisible(self))

    ex.Tools:autoPlaySceneMusic()
end


-- 挂机战斗开始
function BattleLayer:onIdleDone(evt, data)

end

function BattleLayer:onExtraRemove(evt)
    self.extra_reward_cell = nil
end



function BattleLayer:onPubTask(tag, pSender)

    ex.JumpManager:jumpByAtom("main_pub_task")


    -- require("src.layer.MainTaskCtr"):instance():openWindow()
end


function BattleLayer:onTask(tag, pSender)
    -- local atom = pSender:getName()
    ex.JumpManager:jumpByAtom("act_achievement")
    -- require("src.layer.AchievementCtr"):instance():openWindow()
end

function BattleLayer:createBattlePreview()
    if self.battle_type ~= BattleLayer.BattleType.BT_IDLE then
        return
    end

    self:createBattlePreviewDone()
    -- self:addEvent(EVENT.BATTLE_EVENT.GUIDE_BATTLE_CREATE, handler(self, self.createBattlePreviewDone))
    -- NetManager:sendMessage(ProtocolID.GReqGuideBattle)
end

function BattleLayer:createBattlePreviewDone(evt, data)
    if self.battle_type ~= BattleLayer.BattleType.BT_IDLE then
        return
    end

    self:setOtherUIVisible(false)

    self.battle_type = BattleLayer.BattleType.BT_BATTLE
    if self.battle_layer then
        self.battle_layer:runAction(cc.RemoveSelf:create())
        self.battle_layer = nil
    end

    local map_pos = cc.p(0, self.node_panel.panel_height)
    local map_size = cc.size(ex.p.width, 637 * self.node_panel.panel_scale * (ex.p.height / 1280))

    self.battle_layer = require("src.layer.battle.BattleGuideLayer"):create()
    self.battle_layer:initData(data, map_pos, map_size)
    self:addChild(self.battle_layer, -1)
end

function BattleLayer:changeLayerIn()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function BattleLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
    if self.extra_reward_cell then self.extra_reward_cell:hideBubble() end
end


function BattleLayer:startBattleEndTimer(idx)
    self:addTimer("battle_end",500,function (idx)
        local role_upgrade = require("src.layer.RoleUpgradeCtr"):instance()
        if role_upgrade:isOpened() then return end

        local reward = require("src.layer.chapterend.ChapterEndCtr"):instance()
        if reward:isOpened() then return end

        self.passChapter:reset(idx)
        self:removeTimerByName("battle_end")
    end,true,idx)
end

function BattleLayer:battleEnd(event,is_win,idx)

            -- -- test
            -- self:showRewardOnScene()

    if not is_win then return end
    self:startBattleEndTimer(idx)
end

function BattleLayer:showRewardOnScene()
    -- 获取当前奖励的物品
    local now_idx = ex.Player.chapter_data:getNowExtraReward()
    local chapter_id = ex.Player.chapter_data.chapter_id
    if now_idx == nil or self:getParent() == nil or self.extra_reward_cell == nil then
        return 
    end

    local extra_config = cfg.chapterextrareward.chapterextrareward[now_idx]
    -- 更新物品形象
        -- self.spr_reward_bg:removeAllChildren()
        self.extra_reward_item_show = nil
        self:removeChildByTag(9998)
        local item_mode = cfg.item.item[extra_config.show_model].mode
        local item = nil
        if item_mode == ItemData.IT_HERO then
            item = require("src.person.Hero"):create("1", "1",extra_config.show_model, 1, 1, 0)
            item:setScale(2)
        else
            item =  cpp.UIMenuItemImage:createWithSpriteFrameName(string.format("%s.png", cfg.item.item[extra_config.show_model].icon), nil, nil)
            item:setScale(1.5)
        end
        self.extra_reward_cell:setVisible(false)
        
        local cell_pos = cc.p(self.extra_reward_cell:getParent():getPositionX(), self.extra_reward_cell:getParent():getPositionY())
        item:setPosition(ex.p.width * 0.5, ex.p.height * 0.5)
        item:setTag(9998)
        self:addChild(item, 999)

        self.extra_reward_item_show = item

        local layerColor = cc.LayerColor:create(FONT_LIGHT_GRAY_C4B, ex.p.width, ex.p.height)
        self:addChild(layerColor, 998, 9997)

end

function BattleLayer:hideRewardOnScene()
    if self.extra_reward_item_show == nil then
        return
    end
    local cell_pos = cc.p(self.extra_reward_cell:getParent():getPositionX(), self.extra_reward_cell:getParent():getPositionY())
    local act_ms = cc.Spawn:create(cc.EaseExponentialInOut:create(cc.MoveTo:create(2, cc.p(cell_pos.x, cell_pos.y))), cc.EaseExponentialInOut:create(cc.ScaleTo:create(2, 0.5)))
    local act_remove = cc.Sequence:create(cc.DelayTime:create(0.5), act_ms, cc.CallFunc:create(function()
        local layerColor = self:getChildByTag(9997)
        if layerColor then
            layerColor:removeFromParent()
        end
        self.extra_reward_cell:setVisible(true)
        self.extra_reward_cell:reset()
    end),cc.RemoveSelf:create())
    
    self.extra_reward_item_show:runAction(act_remove)
end

function BattleLayer:onExtraReward()
    if self.extra_reward_cell then self.extra_reward_cell:hideBubble() end
end

function BattleLayer:setOtherUIVisible(visible)
    -- 隐藏挂机界面UI
    local chapter_id = ex.Player.chapter_data.chapter_id
    self.node_panel.btn_harvest:setVisible(visible)
    self.node_panel.lbl_map:setVisible(visible)
    self.node_panel.node_bubble:setVisible(visible and chapter_id > 0)
    self.btn_task:setVisible(chapter_id > 0)
    self.btn_pubtask:setVisible(chapter_id > 0)
    self.btn_task_progress_bg:setVisible(chapter_id > 0)
    self.pub_text_bg:setVisible(chapter_id > 0)
    self.task_item_nums:setVisible(chapter_id > 0)
    self.progressEndTimer:setVisible(chapter_id > 0)
    
    self.btn_world_level:setVisible(chapter_id > 0)
    self.btn_chapter_reward:setVisible(chapter_id > 0)

    if self.btn_online_reward then self.btn_online_reward:setVisible(chapter_id > 0) end
    if self.btn_fetter_reward then self.btn_fetter_reward:setVisible(visible and chapter_id > 0)  end
    if self.extra_reward_cell then self.extra_reward_cell:setVisible(visible and ex.Player.guide_serial >= 1850 and chapter_id > 0)  end
end


function BattleLayer:onlineRewardRemove()
    self.btn_online_reward = nil
end

return BattleLayer