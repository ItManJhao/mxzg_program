local FloatingIslandsBossLayer = class("FloatingIslandsBossLayer", require("src.comp.EventLayer"))

FloatingIslandsBossLayer.ctr = ctr.floating_islands

local stage_text = {
    -- ex.Tools:getLang(),
}

function FloatingIslandsBossLayer:onCreate()
    self.boss_type = cfg.floatingislandsheroshow.getConfig("boss_show")
    -- self.boss_type = 10305015
    self.skin = nil

    self.spr_bg:setScaleX(ex.p.width / self.spr_bg:getContentSize().width)

    self.node_boss_name:setPositionY(self.node_boss_name:getPositionY() - require("src.model.Game"):instance():getNotchHeight())
    self.node_rank:setPositionY(self.node_rank:getPositionY() - require("src.model.Game"):instance():getNotchHeight())

    self.node_bottom:setScale(math.min(ex.s.global_scale))
    self.spr_bottom_bg:setContentSize(cc.size(ex.p.width, self.spr_bottom_bg:getContentSize().height * self.node_bottom:getScale()))

    self.scroll_view_skill:setItemSize(cc.size(90, 90))
    self.scroll_view_skill:setAlignmentCenter(true)

	self.progress_hp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("prog/jdt2-3.png"))
	:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	:setMidpoint(cc.p(0, 0.5))
	:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	:setAnchorPoint(cc.p(0.5, 0.5))
	self.progress_hp:setPosition(cc.p(self.spr_hp_bg:getContentSize().width * 0.5,
									  self.spr_hp_bg:getContentSize().height * 0.5))
	self.progress_hp:setPercentage(0)
 	self.spr_hp_bg:addChild(self.progress_hp)

 	self.lbl_hp:setLocalZOrder(1)

    self:updateBoss()
    self:updateLayer()
    self:updateRank()
    
    self:addEvent(EVENT.RANK_EVENT.UPDATE_RANK_TOP_LAYER, handler(self, self.updateRank))
    self:addEvent(EVENT.FLOATING_ISLANDS.UPDATE_LAYER, handler(self, self.updateLayer))
    self:addEvent(EVENT.FLOATING_ISLANDS.UPDATE_TIME, handler(self, self.updateTimeStatus))

    NetManager:sendMessage(ProtocolID.GReqFloatingIslandsTime)
    NetManager:sendMessage(ProtocolID.GReqFloatingIslandsRank)

    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_FKD_KSTZ, self.btn_battle)
   
    self:addTimer("update", 1000, handler(self, self.updateStatus), true)
end

function FloatingIslandsBossLayer:updateStatus()
    ctr.floating_islands:updateStatus()   
end

function FloatingIslandsBossLayer:updateBoss()
    self.node_boss:removeAllChildren()
	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/hero-info.plist")
    sfc:addSpriteFrames("ccbi-res/skill-icon.plist")

    
    -- 创建 boss 骨骼
    self.sp_hero = require("src.person.Hero"):create("1", "1", self.boss_type, 250, 13, self.skin)
	self.sp_hero:setShadowVisible(false)
    self.sp_hero:setScale(1.5 * 1.42)
    self.sp_hero:setPosition(0, -10)
    self.node_boss:addChild(self.sp_hero)

    -- 创建技能
	local vec_skill = ex.Player.hero_data:getHeroSkillList(self.boss_type)
    self.scroll_view_skill.createItemFunction = function(data, scale)
        local item = require("src.comp.menu.UIMenuItemSkill"):createWithIcon(data, 1, true, handler(self, self.onSkillInfo))
        item:resetLblName()
        return item
    end
    self.scroll_view_skill:reloadData(vec_skill)
end

function FloatingIslandsBossLayer:updateRank()
    for i=1,3 do
        local rank_data = ex.Player.rank_data.rank_floating_islands_list[i]
        self["lbl_rank_damage_"..i]:setVisible(rank_data ~= nil)
        if rank_data == nil then
            self["lbl_rank_name_"..i]:setString(ex.Tools:getLang(54202))
        else
            self["lbl_rank_name_"..i]:setString(rank_data.name)
            self["lbl_rank_damage_"..i]:setString(string.format("[%s]", ex.StringUtil.getScientificNumber(rank_data.total_dmg)))
        end
    end
end

function FloatingIslandsBossLayer:updateLayer()
    self.lbl_boss_name:setString(ex.Tools:getLang(cfg.floatingislandsheroshow.getConfig("name")))
    self.btn_anecdotes:setPositionY(self.lbl_boss_name2:getPositionY() - self.lbl_boss_name2:getContentSize().height * 0.5 - 40)
    self.lbl_boss_name2:setString(ex.Tools:getLang(cfg.floatingislandsheroshow.getConfig("name")))
    
    local hp_max = 0
    local cur_hp = tonumber(ctr.floating_islands.data.total_dmg)

    local dmg_num = table.nums(cfg.floatingislandsdmgreward.floatingislandsdmgreward)
    for i=dmg_num,1, -1 do
        local v = cfg.floatingislandsdmgreward.floatingislandsdmgreward[i]
        if v.dmg_value > cur_hp then
            hp_max = v.dmg_value
            break
        end
    end

    -- 血量超出。做特殊处理
    if hp_max == 0 then
        hp_max = cfg.floatingislandsdmgreward.floatingislandsdmgreward[1].dmg_value
        self.lbl_hp:setString(string.format("%s/%s", ctr.floating_islands.data.total_dmg, hp_max))
        self.progress_hp:setPercentage(100)
    else
        local percentage = (cur_hp / hp_max) * 100
        self.progress_hp:setPercentage(percentage)
        self.lbl_hp:setString(string.format("%s/%s", cur_hp, hp_max))
    end

    self.lbl_damage:setString(string.format(ex.Tools:getLang(75403),  ctr.floating_islands.data.self_max_dmg))
    self.lbl_challenge_count:setString(string.format("%s/%s", ctr.floating_islands.data.challenge_count, ex.Tools:getSysCfg("floating_islands_init_challenge_count")))
    self.lbl_buy_count:setString(ctr.floating_islands.data.can_buy_count)

    ex.Tools:setLimitWidth(self.lbl_challenge_count_text, 110)
    ex.Tools:setLabelOffsetRight(self.lbl_buy_count_text, self.lbl_buy_count, 2.5)

    self:updateTimeStatus()
end

function FloatingIslandsBossLayer:updateTimeStatus()
    -- 未开放
    if ctr.floating_islands.data.stage == 2 then
        self.btn_battle:setLabelText(ex.Tools:getLang(75404))
    elseif ctr.floating_islands.data.stage >= 3 then
        self.btn_battle:setLabelText(ex.Tools:getLang(41159))
    end
end

function FloatingIslandsBossLayer:onSkillInfo(tag, pSender)
    require("src.layer.HeroSkillInfoCtr"):instance():openWindow(pSender.skill_type, pSender.skill_level, nil)
end

function FloatingIslandsBossLayer:onBack()
    -- ex.JumpManager:jumpByAtom("")
    -- if not ex.MainSceneCtr:backLastLayer() then
        -- ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
        ex.JumpManager:jumpByAtom("main_fantasy_land")
    -- end
end

function FloatingIslandsBossLayer:onReward()
    require("src.layer.floatingislands.FloatingIslandsRewardCtr"):instance():openWindow()
end

function FloatingIslandsBossLayer:onDamageReward()
    require("src.layer.floatingislands.FloatingIslandsDamageCtr"):instance():openWindow({title=ex.Tools:getLang(47370),
                                                                    class=require("src.layer.floatingislands.FloatingIslandsDamageCell"),
                                                                    file="ccbi/FloatingIslandsDamageCell.ccbi",
                                                                    data_func=function()
                                                                        local vec_reward = clone(cfg.floatingislandsdmgreward.floatingislandsdmgreward)
                                                                        table.sort(vec_reward, function (a, b)
                                                                            return a.dmg_value > b.dmg_value
                                                                        end)
                                                                        return vec_reward
                                                                    end,
                                                                    ""})
end

function FloatingIslandsBossLayer:onRank()
    require("src.layer.RankTopThreeCtr"):instance():openWindow(RankTopThreeLayerType.FLOATING_ISLANDS_BOSS)
end

function FloatingIslandsBossLayer:onShop()
    cfg.funcopen.main_shop.open(SHOP_TYPE.FLOATING_ISLANDS)
end

function FloatingIslandsBossLayer:onBattle()
    -- self:onBattleDone()
    if ctr.floating_islands.data.challenge_count <= 0 then
        ex.MessageView:add(ex.Tools:getLang(47441))
        return
    end

    if ctr.floating_islands.data.stage ~= 2 then
        ex.MessageView:add(ex.Tools:getLang(31923))
        return
    end


    require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47524),
                                                            ex.Tools:getLang(75404),
                                                            BattleType.FLOATING_ISLANDS,
                                                            handler(self, self.onBattleDone))
end

function FloatingIslandsBossLayer:onBattleDone()
    if ctr.floating_islands.data.stage ~= 2 then
        return
    end

    NetManager:sendMessage(ProtocolID.GResFloatingIslandsChallenge)
end

function FloatingIslandsBossLayer:onBuy()
    if ctr.floating_islands.data.can_buy_count <= 0 then
        ex.MessageView:add(ex.Tools:getLang(74935))
        return 
    end

    if ctr.floating_islands.data.stage ~= 2 then
        ex.MessageView:add(ex.Tools:getLang(31923))
        return
    end

    -- 47446
    -- local buy_need = ex.Tools:getSysCfg("floating_islands_buy_cost")
    local buy_need = {item_type=ItemType.IT_GEM, item_num=0}
    local config = cfg.floatingislandsbuyconsume.floatingislandsbuyconsume[table.nums(cfg.floatingislandsbuyconsume.floatingislandsbuyconsume) - ctr.floating_islands.data.can_buy_count + 1]  
    if config then
        buy_need = config.consume
    end

    ex.ConfirmCtr:openWindow(ex.Tools:getLang(41301), string.format(ex.Tools:getLang(75417), buy_need[1].item_type, buy_need[1].item_num), function()
        NetManager:sendMessage(ProtocolID.GReqFloatingIslandsBuyCount)
    end) 
end

function FloatingIslandsBossLayer:onAnecdotes()
    require("src.layer.StrategyCtr"):instance():openWindow("floatingislandsanecdotes")
end

function FloatingIslandsBossLayer:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(75411), ex.Tools:getLang(75412))    
end

return FloatingIslandsBossLayer