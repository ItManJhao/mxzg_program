local ClanBossLayer = class("ClanBossLayer", require("src.comp.EventLayer"))
local ClanBossRankCell = class("ClanBossRankCell", require("src.comp.LuaLayerBase"))

local StageType = {
    ST_UNOPEN = 1,      -- 活动未开启
    ST_CHALLENGE = 2,   -- 战斗阶段
    ST_ROB = 3,         -- 抢夺阶段
    ST_REWARD = 4,      -- 奖励阶段
}

function ClanBossRankCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 0.5)

    self.lbl_rank:enableOutline(ex.c3b.BLACK, 1)
end

function ClanBossRankCell:reset(data)
    self.lbl_rank:setString(data.rank)
    self.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..(data.nick or data.clan_name))
    self.lbl_point:setString(ex.StringUtil.getScientificNumberG(data.point))

end

function ClanBossLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-clan-boss-1.jpg", remove_type=1},
    }
    return vec_image
end

function ClanBossLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")
    sfc:addSpriteFrames("ccbi-res/rank.plist")

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)

    local scale_x = ex.p.width / self.spr_bg:getContentSize().width
    local scale_y = ex.p.height / self.spr_bg:getContentSize().height
    self.spr_bg:setScale(scale_x > scale_y and scale_x or scale_y)
    self.spr_bg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    -- spr_bg:setCascadeOpacityEnabled(true)
    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)

    self.btn_info:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width / 2 - self.btn_info:getContentSize().width / 2, 
                              self.btn_back:getPositionY() - 60)
    self.btn_reward:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width / 2 - self.btn_reward:getContentSize().width / 2,
                                self.btn_back:getPositionY() - 130)
    self.btn_history:setPosition(ex.p.width - self.btn_info:getPositionX(), self.btn_back:getPositionY() - 30)
    self.btn_shop:setPosition(ex.p.width - self.btn_info:getPositionX(), self.btn_back:getPositionY() - 30)
    self.btn_shop:setVisible(false)

    self.node_boss_name:setPosition(ex.p.cx, self.btn_back:getPositionY() - 70)
    self.node_tip:setPosition(ex.p.cx, self.btn_back:getPositionY() - 400)
    self.node_battle:setPosition(ex.p.cx, self.btn_back:getPositionY() - 500)
    self.node_scroll_view:setPositionX(ex.p.cx)

    local scroll_height = self.node_battle:getPositionY() - self.node_scroll_view:getPositionY() - 100
    self.node_rank_title:setPosition(0, scroll_height - 60)
    self.menu_tab:setPositionY(scroll_height + 40)
    self.spr_scroll_bg:setContentSize(cc.size(self.spr_scroll_bg:getContentSize().width, scroll_height))
    self.spr_scroll_view_bg:setContentSize(cc.size(self.spr_scroll_view_bg:getContentSize().width, scroll_height - 75))

    self:reorderChild(self.node_boss_name, 20)
    self:reorderChild(self.node_tip, 20)
    self:reorderChild(self.spr_bg, -10)

    self.lbl_tip:setString(ex.Tools:getLang(52002))

    self.btn_plunder:setLabelText(ex.Tools:getLang(47154))
    self.btn_battle:setLabelText(ex.Tools:getLang(47604))

    self.lbl_limit_plunder:enableOutline(ex.c3b.BLACK, 1)
    self.lbl_limit_battle:enableOutline(ex.c3b.BLACK, 1)

    self.rank_type = 1
    self.btn_left:setChecked(true)
    self.btn_left:setLabelText(ex.Tools:getLang(52006))
    self.btn_left:setTag(1)
    self.btn_right:setLabelText(ex.Tools:getLang(52007))
    self.btn_right:setTag(2)

    self.lbl_title_1:setString(ex.Tools:getLang(52008))
    self.lbl_title_2:setString(ex.Tools:getLang(52009))
    self.lbl_title_3:setString(ex.Tools:getLang(52011))

    self.lbl_plunder_time:setVisible(false)
    self.lbl_battle_time:setVisible(false)

    self.lbl_limit_plunder:setVisible(false)
    self.lbl_limit_battle:setVisible(false)

    self.scroll_view:setItemType(1)
    self.scroll_view:setItemSize(cc.size(500, 40))
    self.scroll_view:setViewSize(cc.size(self.spr_scroll_view_bg:getContentSize().width, scroll_height - 135))

    self.my_rank = ClanBossRankCell:createWithCCBIFile("ccbi/ClanBossRankCell.ccbi")
    self.my_rank.spr_cell_bg:setVisible(false)
    self.my_rank:setAnchorPoint(0.5, 0)
    self.my_rank:setPosition(self.spr_self_rank_bg:getPositionX(), self.spr_self_rank_bg:getPositionY() + 5)
    self.node_scroll_view:addChild(self.my_rank)
    self.my_rank:setVisible(false)

    -- 播放背景光效
    self.spr_effect_bg_light = ex.EffectFactory:createEffectWithNodeByName("eff_clan_boss_bg")
    self.spr_effect_bg_light:setScale(2.5)
    self.spr_effect_bg_light:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2 + 280 * self.spr_bg:getScaleY())
    self:addChild(self.spr_effect_bg_light, -5)

    self.lbl_null:setPositionY(self.scroll_view:getPositionY() + self.scroll_view:getViewSize().height * 0.5)
    self:initDone()

    self:addRedDotNode(RedDotType.ZCJ_DHGH_ZCBOSSAN_SJBOSS_LD, self.btn_plunder)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_ZCBOSSAN_SJBOSS_ZD, self.btn_battle)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_ZCBOSSAN_SJBOSS_LS, self.btn_history)
end

function ClanBossLayer:initDone()
    print("ClanBossLayer:initDone")

    self:registerEvent()
end

-- 层切入时会被调用
function ClanBossLayer:changeLayerIn()
    self:updateLayer()
    self:updateTimer()
    
    -- 进入界面时刷新数据
    NetManager:sendMessage(ProtocolID.GReqScanWorldBoss)
    NetManager:sendMessage(ProtocolID.GReqScanClanRank)
    NetManager:sendMessage(ProtocolID.GReqScanRoleRank)

    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function ClanBossLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

function ClanBossLayer:updateLayer()
    local boss_info = ex.Player.clan_data.clan_boss_info
    local config = cfg.clanworldboss.clanworldboss[boss_info.boss_id]
    if config == nil then
        print("ClanBossLayer:updateLayer cfg.clanworldboss "..boss_info.boss_id.." is nil")
        if self.spine_boss then
            self.spine_boss:removeFromParent()
            self.spine_boss = nil
        end
        return
    end
    
    -- 设置掠夺和战斗剩余次数显示
    -- 判断当前是否处于相互抢夺阶段：
    --  是，显示剩余次数“次数：剩余次数 / 每日抢夺次数上限”
    --      判断当前是否处于抢夺冷却阶段：
    --       是，显示冷却时间倒计时“XX s”
    --  否，不显示剩余次数
    -- self.lbl_limit_plunder:setString("")

    -- 判断当前是否处于相互挑战阶段：
    --  是，显示剩余次数“次数：剩余次数 / 每日挑战次数上限”
    --      判断当前是否处于挑战冷却阶段：
    --       是，显示冷却时间倒计时“XX s”
    --  否，不显示剩余次数
    -- self.lbl_limit_battle:setString("")

    -- 刷新排行榜
    self:updateTableView()

    local now = ex.Game:getServerTime()
    -- 如果活动开始，则不显示提示节点
    print("clan boss time:", boss_info.round_start_time, boss_info.round_end_time, now, boss_info.stage)
    if boss_info.round_start_time <= now and boss_info.round_end_time > now then 
        ex.Tools:setGrayAuto(self.btn_plunder:getNormalImage(), boss_info.stage ~= StageType.ST_ROB)
        ex.Tools:setGrayAuto(self.btn_battle:getNormalImage(), boss_info.stage ~= StageType.ST_CHALLENGE)
    
        self.node_tip:setScale(1)
        self.node_tip:setPositionY(self.btn_back:getPositionY() - 400)

        self.node_boss_name:setVisible(true)
        self.lbl_boss_name:setString(ex.Tools:getLang(config.boss_type))

        -- 设置boss骨骼动画
        if self.spine_boss == nil then
            local skin = ex.Tools:getHeroSkinByStar(config.boss_type, config.star)
            self.spine_boss = require("src.person.Hero"):create("1", "1", config.boss_type, config.level, config.star, skin)
            self.spine_boss:setScale(1.5 * 1.42)
            self.spine_boss:setPosition(ex.p.cx, self.node_boss_name:getPositionY() - 170)
            self:addChild(self.spine_boss)
            self.spine_boss:stopUpdateZOrder(0)
        end

        if boss_info.stage == StageType.ST_REWARD then
            self.lbl_tip:setString(ex.Tools:getLang(41053))
        else
            -- 添加定时器
            self:addTimer("timer_clan_boss", 1000, handler(self, self.updateTimer), true)
        end
    else
        ex.Tools:setGrayAuto(self.btn_plunder:getNormalImage(), false)
        ex.Tools:setGrayAuto(self.btn_battle:getNormalImage(), false)
    
        if self.spine_boss ~= nil then
            self.spine_boss:removeFromParent()
            self.spine_boss = nil
        end

        self.lbl_tip:setString(ex.Tools:getLang(52002))
        self.node_tip:setScale(1.5)
        self.node_tip:setPositionY(self.btn_back:getPositionY() - 255)
        self.node_boss_name:setVisible(false)
    end

    self:updateCount()
end

function ClanBossLayer:updateCount()
    local boss_info = ex.Player.clan_data.clan_boss_info
    local challenge_count = boss_info.challenge_count
    local challenge_time = ex.Tools:getSysCfg("clan_world_boss_challenge_times")
    self.lbl_limit_battle:setString(ex.Tools:getLang(1311) .. (challenge_time - challenge_count) .. "/" .. challenge_time)
    ex.Tools:setCostColor(self.lbl_limit_battle, challenge_count < challenge_time)

    local rob_count = boss_info.rob_count
    local rob_time = ex.Tools:getSysCfg("clan_world_boss_rob_times")
    self.lbl_limit_plunder:setString(ex.Tools:getLang(1311) .. (rob_time - rob_count) .. "/" .. rob_time)
    ex.Tools:setCostColor(self.lbl_limit_plunder, rob_count < rob_time)
end

function ClanBossLayer:updateTimer()
    local boss_info = ex.Player.clan_data.clan_boss_info
    local now = ex.Game:getServerTime()

    if boss_info.round_start_time > now or boss_info.round_end_time <= now then
        -- 如果活动未开始，或者已经结束，则刷新界面并停止定时器
        self:updateLayer()
        -- self:updateTimer()
        self:removeTimerByName("timer_clan_boss")
        return
    end

    -- 如果活动进入第4阶段，也算活动结束，则刷新界面并停止定时器
    if boss_info.stage == StageType.ST_REWARD then
        self:updateLayer()
        -- self:updateTimer()
        self:removeTimerByName("timer_clan_boss")
        return
    end

    if self.last_req_refresh_time == nil then
        self.last_req_refresh_time = 0
    end

    local stage_left_time = boss_info.next_stage_time - now

    if now - self.last_req_refresh_time > 1 then
        if stage_left_time <= 0 then
            stage_left_time = 0
            -- 这里要判断对应阶段的刷新接口

            -- 阶段结束时，刷新基本信息
            NetManager:sendMessage(ProtocolID.GReqScanWorldBoss)
            -- 刷新掠夺列表

            -- 10秒刷新一次排行榜
            if self["rank_time"..self.rank_type] == nil or self["rank_time"..self.rank_type] + 10 < now then
                self["rank_time"..self.rank_type] = now
                if self.rank_type == 1 then
                    NetManager:sendMessage(ProtocolID.GReqScanClanRank)
                else
                    NetManager:sendMessage(ProtocolID.GReqScanRoleRank)
                end
            end
        end
    end

    -- 刷新阶段定时器显示
    if boss_info.stage == StageType.ST_UNOPEN then
        -- 提示活动将开启
        self.lbl_tip:setString(string.format(ex.Tools:getLang(52110), 
                                                            ex.StringUtil.convertToTimeFormat(stage_left_time, 5)))
    elseif boss_info.stage == StageType.ST_CHALLENGE then
        self.lbl_tip:setString(string.format(ex.Tools:getLang(52106 + boss_info.stage), 
                                                            ex.StringUtil.convertToTimeFormat(stage_left_time, 5)))
    elseif boss_info.stage == StageType.ST_ROB then
        self.lbl_tip:setString(string.format(ex.Tools:getLang(52106 + boss_info.stage), 
                                                            ex.StringUtil.convertToTimeFormat(stage_left_time, 5)))
    elseif boss_info.stage == StageType.ST_REWARD then
        -- 提示活动已结束
        self.lbl_tip:setString(ex.Tools:getLang(41053))
    else
        self.lbl_tip:setString("")
    end

    self.lbl_battle_time:setVisible(false)
    self.lbl_limit_battle:setVisible(false)
    self.lbl_plunder_time:setVisible(false)
    self.lbl_limit_plunder:setVisible(false)

    if boss_info.stage == StageType.ST_CHALLENGE then
        self.lbl_battle_time:setVisible(true)
        self.lbl_limit_battle:setVisible(true)

        local challenge_count = boss_info.challenge_count
        local challenge_time = ex.Tools:getSysCfg("clan_world_boss_challenge_times")

        self.lbl_battle_time:setVisible(boss_info.challenge_cd > now and challenge_count < challenge_time)
        self.lbl_battle_time:setString(string.format("%ds", math.max(boss_info.challenge_cd - now, 0)))
    elseif boss_info.stage == StageType.ST_ROB then
        self.lbl_plunder_time:setVisible(true)
        self.lbl_limit_plunder:setVisible(true)

        local rob_count = boss_info.rob_count
        local rob_time = ex.Tools:getSysCfg("clan_world_boss_rob_times")

        self.lbl_plunder_time:setVisible(boss_info.rob_cd > now and rob_count < rob_time)
        self.lbl_plunder_time:setString(string.format("%ds", math.max(boss_info.rob_cd - now, 0)))
    end
end

function ClanBossLayer:registerEvent()
   self:addEvent(EVENT.CLAN_EVENT.CLAN_BOSS_INFO, handler(self, self.updateLayer))
   self:addEvent(EVENT.CLAN_EVENT.CLAN_BOSS_RANK, handler(self, self.updateTableView))
   self:addEvent(EVENT.CLAN_EVENT.CLAN_BOSS_BATTLE_ROB, handler(self, self.plunder))
   self:addEvent(EVENT.CLAN_EVENT.CLAN_BOSS_ON_BATTLE, handler(self, self.onPlunderReport))
end

function ClanBossLayer:updateTableView()
    if self.rank_type == 1 then
        self.lbl_title_2:setString(ex.Tools:getLang(52009))
    else
        self.lbl_title_2:setString(ex.Tools:getLang(52010))
    end

    -- 设置自己的排行榜信息
    self.my_rank:setVisible(true)
    if self.rank_type == 1 then
        local rank = ex.Player.clan_data.clan_boss_rank_clan.my_rank.rank ~= nil and ex.Player.clan_data.clan_boss_rank_clan.my_rank.rank or 0
        if rank > ex.Tools:getSysCfg("clan_world_person_max_rank") or rank <= 0 then
            self.my_rank.lbl_rank:setString(ex.Tools:getLang(47749))
        else
            self.my_rank.lbl_rank:setString(ex.Player.clan_data.clan_boss_rank_clan.my_rank.rank ~= nil and tostring(ex.Player.clan_data.clan_boss_rank_clan.my_rank.rank) or "")
        end 
        self.my_rank.lbl_name:setString(ex.Player.clan_data.clan_boss_rank_clan.my_rank.clan_name or "")
        self.my_rank.lbl_point:setString(ex.Player.clan_data.clan_boss_rank_clan.my_rank.point ~= nil and ex.StringUtil.getScientificNumberG(ex.Player.clan_data.clan_boss_rank_clan.my_rank.point) or "")
    else
        local rank = ex.Player.clan_data.clan_boss_rank_player.my_rank.rank ~= nil and ex.Player.clan_data.clan_boss_rank_player.my_rank.rank or 0
        if rank > ex.Tools:getSysCfg("clan_world_clan_max_rank") or rank <= 0 then
            self.my_rank.lbl_rank:setString(ex.Tools:getLang(47749))
        else
            self.my_rank.lbl_rank:setString(ex.Player.clan_data.clan_boss_rank_player.my_rank.rank ~= nil and tostring(ex.Player.clan_data.clan_boss_rank_player.my_rank.rank) or "")
        end 
        -- self.my_rank.lbl_rank:setString(ex.Player.clan_data.clan_boss_rank_player.my_rank.rank ~= nil and tostring(ex.Player.clan_data.clan_boss_rank_player.my_rank.rank) or "")
        self.my_rank.lbl_name:setString(ex.Player.clan_data.clan_boss_rank_player.my_rank.nick or "")
        self.my_rank.lbl_point:setString(ex.Player.clan_data.clan_boss_rank_player.my_rank.point ~= nil and ex.StringUtil.getScientificNumberG(ex.Player.clan_data.clan_boss_rank_player.my_rank.point) or "")
    end
    self.scroll_view.createItemFunction = function(data, scale)
        local cell_rank = ClanBossRankCell:createWithCCBIFile("ccbi/ClanBossRankCell.ccbi")
        cell_rank.rank_type = self.rank_type
        cell_rank.data = data
        cell_rank.lbl_rank:setString(data.rank)
        cell_rank.lbl_point:setString(ex.StringUtil.getScientificNumberG(data.point))
        cell_rank.lbl_name:setString(ex.StringUtil.getServerName(data.server_id)..(data.clan_name or data.nick))
        return cell_rank
    end
    
    local data = self.rank_type == 1 and ex.Player.clan_data.clan_boss_rank_clan.ranks or ex.Player.clan_data.clan_boss_rank_player.ranks

    self.lbl_null:setVisible((#data) <= 0)
    self.scroll_view:reloadData(data)
end

function ClanBossLayer:onBack()
    ex.MainSceneCtr:backLastLayer()
end

function ClanBossLayer:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(42038), ex.Tools:getLang(42039))
end

function ClanBossLayer:onReward()
    require("src.layer.clan.ClanBossRewardCtr"):instance():openWindow()
end

function ClanBossLayer:onShop()
    cfg.funcopen.main_shop.open(SHOP_TYPE.CLAN_BOSS)
end

function ClanBossLayer:onHistory()
    require("src.layer.clan.ClanBossHistoryCtr"):instance():openWindow()
end

function ClanBossLayer:onPlunder()
    -- 如果剩余次数不足，则弹出提示
    -- 判断当前是否处于相互抢夺阶段：
    --  否，显示灰色按钮，点击弹出飘字提示“12:00-15:00为抢夺阶段”
    --  是，显示彩色按钮，如果剩余次数不为0则显示小红点提示，点击打开[抢夺窗口]

    local now = ex.Game:getServerTime()
    if ex.Player.clan_data.clan_boss_info.round_start_time > now or ex.Player.clan_data.clan_boss_info.round_end_time < now then 
        ex.MessageView:add(ex.Tools:getLang(52004))
        return
    end

    --  or ex.Player.clan_data.clan_boss_info.next_stage_time <= now
    if ex.Player.clan_data.clan_boss_info.stage ~= 3 then
        ex.MessageView:add(ex.Tools:getLang(52004))
        return
    end

    if ex.Player.clan_data.clan_boss_info.rob_count >= ex.Tools:getSysCfg("clan_world_boss_rob_times") then
        ex.MessageView:add(ex.Tools:getLang(52113))
        return
    end

    if now < ex.Player.clan_data.clan_boss_info.rob_cd then
        ex.MessageView:add(ex.Tools:getLang(52015))
        return
    end

    require("src.layer.clan.ClanBossPlunderCtr"):instance():openWindow()
end

function ClanBossLayer:onBattle()
    -- 如果剩余次数不足，则弹出提示
    -- 判断当前是否处于相互挑战阶段：
    --  否，显示灰色按钮，点击弹出飘字提示“9:00-12:00为挑战阶段”
    --  是，显示彩色按钮，如果剩余次数不为0则显示小红点提示，点击打开[通用出战窗口]
    local now = ex.Game:getServerTime()

    if ex.Player.clan_data.clan_boss_info.round_start_time > now or ex.Player.clan_data.clan_boss_info.round_end_time < now then 
        ex.MessageView:add(ex.Tools:getLang(52003))
        return
    end

    if ex.Player.clan_data.clan_boss_info.stage ~= StageType.ST_CHALLENGE then
        ex.MessageView:add(ex.Tools:getLang(52003))
        return
    end

    if ex.Player.clan_data.clan_boss_info.challenge_count >= ex.Tools:getSysCfg("clan_world_boss_challenge_times") then
        ex.MessageView:add(ex.Tools:getLang(52112))
        return
    end

    if now < ex.Player.clan_data.clan_boss_info.challenge_cd then
        ex.MessageView:add(ex.Tools:getLang(52014))
        return
    end

    require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47524),
                                                             ex.Tools:getLang(47064),
                                                             BattleType.CLAN_BOSS,
                                                             handler(self, self.onBattleConfirm))
end

function ClanBossLayer:onBattleConfirm(vec_battle, fetter_type)
    -- 发送副本战斗请求
    local config = cfg.clanworldboss.clanworldboss[ex.Player.clan_data.clan_boss_info.boss_id]
    NetManager:sendMessage(ProtocolID.GReqChallengeBoss)
    local battle_layer = self:addBattleLayer(BattleType.CLAN_BOSS,
                                             MainSceneType.CLAN_BOSS,
                                             config.map or "map_adventure", 
                                             EVENT.CLAN_EVENT.CLAN_BOSS_BATTLE,
                                             function(layer, data, vec_reward, ext)
                                                -- 只有胜利
                                                 require("src.layer.clan.ClanBossEndCtr"):instance():openWindow(true,
                                                                                                                vec_reward,
                                                                                                                "src.layer.clan.ClanBossEndCell",
                                                                                                                ext)
                                                 return true, false
                                             end)
    battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5  / battle_layer:getScale() - ex.p.width  * 0.5,
                             self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
end

function ClanBossLayer:onBattleEnd(data)
    print("ClanMissionLayer:onBattleEnd", data.isWin)
    if self.layer_battle ~= nil then
        self.layer_battle:removeFromParent()
        self.layer_battle = nil
    end
    ex.MainSceneCtr:removeKeepLayer(MainSceneType.CLAN_BOSS)
    ex.Tools:autoPlaySceneMusic()

    -- 显示战斗结算界面

    -- 显示奖励
    require("src.layer.ItemRewardCtr"):instance():openWindow(ex.Player.clan_data.clan_mission_battle_reward)
end

function ClanBossLayer:onTab(tag, pSender)
    print("ClanBossLayer:onTab", tag)
    if self.rank_type == tag then
        return
    end

    if self.rank_type == 1 then
        NetManager:sendMessage(ProtocolID.GReqScanClanRank)
    else
        NetManager:sendMessage(ProtocolID.GReqScanRoleRank)
    end

    self.rank_type = tag
    self:updateTableView()
end

function ClanBossLayer:plunder(evt, data)

    -- 发送副本战斗请求
    local req_battle = ClanWorldBoss_pb.GReqRobOtherRole()
    req_battle.rid = data.rid
    NetManager:sendMessage(ProtocolID.GReqRobOtherRole, req_battle)

    local battle_layer = self:addBattleLayer(BattleType.CLAN_BOSS,
                                             MainSceneType.CLAN_BOSS,
                                             "map_adventure", 
                                             EVENT.CLAN_EVENT.CLAN_BOSS_BATTLE_ROB_REPORT,
                                            function(layer, data, vec_reward, ext)
                                             require("src.layer.clan.ClanBossEndCtr"):instance():openWindow(data.isWin,
                                                                                                            vec_reward,
                                                                                                            "src.layer.clan.ClanBossEndCell",
                                                                                                            ext)
                                             return true, false
                                         end)
    battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5 / battle_layer:getScale()  - ex.p.width * 0.5,
                             self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
end

function ClanBossLayer:onPlunderReport(event, battle_id)
    local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = battle_id
    req_battle.type = EVENT.CLAN_EVENT.CLAN_BOSS_BATTLE
    NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    local battle_layer = self:addBattleLayer(BattleType.CLAN_BOSS,
                                            MainSceneType.CLAN_BOSS,
                                            "map_adventure",
                                            EVENT.CLAN_EVENT.CLAN_BOSS_BATTLE,
                                            function()
                                                return true, false
                                            end)
    battle_layer:showCloseBtn(true)
    battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5  / battle_layer:getScale() - ex.p.width  * 0.5,
                            self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
end

return ClanBossLayer
