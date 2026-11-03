local ClanMissionCtr = class("ClanMissionCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ClanMissionLayer = class("ClanMissionLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ClanMissionLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    self.spr_rank_1:setVisible(false)
    self.lbl_rank_name_1:setVisible(false)
    self.lbl_rank_damage_1:setVisible(false)
    self.spr_rank_2:setVisible(false)
    self.lbl_rank_name_2:setVisible(false)
    self.lbl_rank_damage_2:setVisible(false)
    self.spr_rank_3:setVisible(false)
    self.lbl_rank_name_3:setVisible(false)
    self.lbl_rank_damage_3:setVisible(false)

    -- 添加血量
    self.progress_hp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("clan/progress-hp.png"))
    self.progress_hp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    :setMidpoint(cc.p(0, 0.5))
    :setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    self.progress_hp:setPosition(self.spr_progress_bg:getPosition())
    self.node_boss_info:addChild(self.progress_hp, 20)

    self:reorderChild(self.spr_progress_bg, 10)
    self:reorderChild(self.node_progress_icon, 30)
    self:reorderChild(self.lbl_hp, 40)
    self:reorderChild(self.lbl_boss_name, 40)
    self:reorderChild(self.menu, 10)
    self:reorderChild(self.node_rank, 40)

    self:addRedDotNode(RedDotType.ZCJ_DHGH_GHFB_ZD, self.btn_battle)
end

function ClanMissionLayer:updateReward(play_reward, killer_reward, callback)
    self.menu_play:removeAllChildren()
    self.menu_kill:removeAllChildren()

    if play_reward ~= nil and #play_reward > 0 then
        for i,v in ipairs(play_reward) do
            local item = UIMenuItemBackpack:createWithData(v.item_type, 1)
            item.lbl_num:setString(string.format("%d", v.item_num))
            item:setScale(0.75)
            item:setPosition((i - 0.5) * (item:getContentSize().width * item:getScaleX() + 5), 0)
            item:registerScriptTapHandler(callback)
            self.menu_play:addChild(item)
        end
    end

    if killer_reward ~= nil and #killer_reward > 0 then
        for i,v in ipairs(killer_reward) do
            local item = UIMenuItemBackpack:createWithData(v.item_type, 1)
            item.lbl_num:setString(string.format("%d", v.item_num))
            item:setScale(0.75)
            item:setPosition((i - 0.5) * (item:getContentSize().width * item:getScaleX() + 5), 0)
            item:registerScriptTapHandler(callback)
            self.menu_kill:addChild(item)
        end
    end
end

-----------------------------------------------------------------------------
function ClanMissionCtr:onCreate()
    self:setCCBIPath("ccbi/ClanMissionLayer.ccbi")
    self:setIsSingle(false)
end

function ClanMissionCtr:getLayerClass()
    return ClanMissionLayer
end

function ClanMissionCtr:openWindow()
    if self:isOpened() then
        return
    end

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")

    self:loadLayer()
    self:open()
    self:initData()
end

function ClanMissionCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_info:registerScriptTapHandler(handler(self, self.onInfo))
    self.layer.btn_rank_preview:registerScriptTapHandler(handler(self, self.onRankRewardPreview))
    self.layer.btn_battle:registerScriptTapHandler(handler(self, self.onBattle))
    self.layer.btn_rank:registerScriptTapHandler(handler(self, self.onRank))

    self.layer:addEvent(EVENT.CLAN_EVENT.CLAN_MISSION_INFO, handler(self, self.updateLayer))
    self.layer:addEvent(EVENT.CLAN_EVENT.CLAN_MISSION_RANK, handler(self, self.updateMissionRank))
    self.layer:addEvent(EVENT.CLAN_EVENT.CLAN_MISSION_BUY_ACCOUNT_DONE, handler(self, self.onBuyAttackCountDone))

    -- 发送消息，请求刷新界面
    NetManager:sendMessage(ProtocolID.GReqClanMissionInfo)

    NetManager:sendMessage(ProtocolID.GReqClanRankDamage)

end

function ClanMissionCtr:updateLayer()
    local cur_idx = ex.Player.clan_data.clan_mission_cur_boss_idx
    local config = cfg.clanboss.clanboss[cur_idx]

    -- 更新奖励显示
    self.layer:updateReward(config.play_reward, config.killer_reward, handler(self, self.onItemInfo))

    local mission_max = table.nums(cfg.clanboss.clanboss)
    if cur_idx > mission_max then
        cur_idx = mission_max
    end
    local config = cfg.clanboss.clanboss[cur_idx]
    if config == nil then
        return
    end

    if self.layer.spine_boss then
        self.layer.spine_boss:removeFromParent()
        self.layer.spine_boss = nil
    end
    
    -- 设置boss骨骼动画
    local skin = ex.Tools:getHeroSkinByStar(config.hero_type, config.hero_star)
    self.layer.spine_boss = require("src.person.Hero"):create("1", "1", config.hero_type, config.hero_level, config.hero_star, skin)
    self.layer.spine_boss:setScale(1.42)
    self.layer.spine_boss:setPosition(self.layer.lbl_boss_name:getPositionX(), 150)
    self.layer.node_boss_info:addChild(self.layer.spine_boss)
    self.layer.spine_boss:stopUpdateZOrder(0)

    self.layer.progress_mission_icon:setSpriteFrame("head-icon/"..config.hero_type..".png")

    -- 设置boss血量
    local percentage = ex.Player.clan_data.clan_boss_cur_hp / 100.0

    self.layer.progress_hp:setPercentage(percentage)

    self.layer.lbl_hp:setString(string.format("%g%%", percentage))

    self.layer.lbl_boss_name:setString(ex.Tools:getLang(config.hero_type))

    local start_idx = 1
    if cur_idx > 5 then
        if cur_idx >= mission_max - 2 then
            start_idx = mission_max - 5
        else
            start_idx = cur_idx - 4
        end
    end

    if self.layer.spr_effect ~= nil then
        self.layer.spr_effect:removeFromParent()
        self.layer.spr_effect = nil
    end

    for i=1,6 do
        local config_mission = cfg.clanboss.clanboss[start_idx + i - 1]

        self.layer["lbl_mission_" .. i]:setString(string.format(ex.Tools:getLang(47515), config_mission.boss))
        self.layer["spr_mission_icon_"..i]:setSpriteFrame("head-icon/"..config_mission.hero_type..".png")
        if config_mission.boss < ex.Player.clan_data.clan_mission_cur_boss_idx then
            self.layer["spr_mission_lock_" .. i]:setVisible(false)
            self.layer["spr_mission_attack_" .. i]:setVisible(false)
            self.layer["lbl_mission_pass_" .. i]:setVisible(true)

            if config_mission.boss >= mission_max then
                self.layer.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_main_scene_scale")
                self.layer.spr_effect:setScale(0.75)
                self.layer.spr_effect:setPosition(self["spr_mission_bg_" .. i]:getContentSize().width / 2, self.layer["spr_mission_bg_" .. i]:getContentSize().height / 2 + 2)
                self.layer["spr_mission_bg_" .. i]:addChild(self.layer.spr_effect, 20)
            end
        else
            self.layer["lbl_mission_pass_" .. i]:setVisible(config_mission.boss < ex.Player.clan_data.clan_mission_cur_boss_idx)
            if config_mission.boss == ex.Player.clan_data.clan_mission_cur_boss_idx then
                self.layer["spr_mission_lock_" .. i]:setVisible(false)
                self.layer["spr_mission_attack_" .. i]:setVisible(true)

                self.layer.spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_main_scene_scale")
                self.layer.spr_effect:setScale(0.75)
                self.layer.spr_effect:setPosition(self.layer["spr_mission_bg_" .. i]:getContentSize().width / 2, self.layer["spr_mission_bg_" .. i]:getContentSize().height / 2 + 2)
                self.layer["spr_mission_bg_" .. i]:addChild(self.layer.spr_effect, 20)
            else
                self.layer["spr_mission_lock_" .. i]:setVisible(true)
                self.layer["spr_mission_attack_" .. i]:setVisible(false)
            end
        end

        -- start_idx = start_idx + 1
    end

    -- 更新次数
    local count = ex.Tools:getSysCfg("clan_boss_free_times") + ex.Tools:getSysCfg("clan_boss_times_buy_limit")
    local buy_count = math.min(ex.Tools:getSysCfg("clan_boss_times_buy_limit"), ex.Player.clan_data.buy_count)

    self.layer.lbl_left:setString(buy_count)
    self.layer.lbl_free:setString(ex.Player.clan_data.left_count)
end

-- 物品介绍
function ClanMissionCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-- 伤害排行榜
function ClanMissionCtr:onRank()
    require("src.layer.clan.ClanDamageRankCtrl"):instance():openWindow()
end

-- 公会副本功能介绍
function ClanMissionCtr:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42036), ex.Tools:getLang(42037))
end

-- 伤害排行榜奖励预览
function ClanMissionCtr:onRankRewardPreview()
    require("src.layer.clan.ClanRankRewardPreviewCtr"):instance():openWindow()
end

-- 开始战斗
function ClanMissionCtr:onBattle()
    -- 判断次数
    local count = ex.Tools:getSysCfg("clan_boss_free_times") + ex.Tools:getSysCfg("clan_boss_times_buy_limit")
    if ex.Player.clan_data.left_count > 0 then
        self:onSelectHero()
    elseif ex.Player.clan_data.attack_count >= count then
        ex.MessageView:add(ex.Tools:getLang(47555))
    else
        local config = cfg.clanbossbuy.clanbossbuy[ex.Player.clan_data.attack_count - 1]
        if config ~= nil then
            local cost = config.cost[1]
            if ex.Player:getItemNum(cost.item_type) >= cost.item_num then
                --todo
                ex.ConfirmCtr:openWindow(ex.Tools:getLang(47442), 
                                        string.format(ex.Tools:getLang(47446),
                                                        cost.item_num, 
                                                        ex.Tools:getLang(cfg.item.item[cost.item_type].name)),
                                        handler(self, self.onBuyAttackCount))
            else
                ex.MessageView:add(string.format(ex.Tools:getLang(47428), ex.Tools:getLang(cfg.item.item[cost.item_type].name)))
            end
        else
            print("cfg.clanbossbuy.clanbossbuy times", ex.Player.clan_data.attack_count, "not found")
        end
    end
end

function ClanMissionCtr:onBuyAttackCount()
    -- 发送购买次数协议
    NetManager:sendMessage(ProtocolID.GReqClanMissionBuy)
end

function ClanMissionCtr:updateMissionRank(event, list)
    for i=1,3 do
        if #list > i - 1 then
            self.layer["spr_rank_"..i]:setVisible(true)
            self.layer["lbl_rank_name_"..i]:setVisible(true)
            self.layer["lbl_rank_damage_"..i]:setVisible(true)
            self.layer["lbl_rank_name_"..i]:setString(list[i].nick)
            self.layer["lbl_rank_damage_"..i]:setString(list[i].damage)--cpp.StringUtil:convertScientific(list[1].damage))
        else
            self.layer["spr_rank_"..i]:setVisible(false)
            self.layer["lbl_rank_name_"..i]:setVisible(false)
            self.layer["lbl_rank_damage_"..i]:setVisible(false)
        end
    end
end

function ClanMissionCtr:onBuyAttackCountDone(event)
    -- 发送刷新信息协议
    NetManager:sendMessage(ProtocolID.GReqClanMissionInfo)

    self:onSelectHero()
end

function ClanMissionCtr:onSelectHero()
    require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47524),
                                                            ex.Tools:getLang(47064),
                                                            BattleType.CLAN_MISSION,
                                                            handler(self, self.onBattleConfirm))
end

function ClanMissionCtr:onBattleConfirm(vec_battle, fetter_type)
    ctr.clan_battle:battle()

    self:closeWindow()
end

return ClanMissionCtr
