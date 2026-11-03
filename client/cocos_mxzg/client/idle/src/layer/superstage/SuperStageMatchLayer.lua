local SuperStageMatchLayer = class("SuperStageMatchLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemHero = require("src.comp.menu.UIMenuItemHero")

function SuperStageMatchLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    self.spr_vs:setVisible(false)

    self.node_stage_self:setLocalZOrder(100)
    self.node_stage_enermy:setLocalZOrder(100)
    
    if self.spr_bg:getContentSize().width * self:getScaleX() < ex.p.width then
        self.spr_bg:setScale(ex.p.width / self.spr_bg:getContentSize().width / self:getScaleX())
        self.spr_bg_self:setScaleX(ex.p.width / self.spr_bg_self:getContentSize().width / self:getScaleX())
        self.spr_bg_enermy:setScaleX(ex.p.width / self.spr_bg_enermy:getContentSize().width / self:getScaleX())
    end

    -- 匹配時間提示
    self.lbl_left_time = require("src.comp.RichTextEx"):create()
	:setFontSize(40)
	:setFontFace(FONT_DEFAULT_NAME_BOLD)
	:setFontColor("#FFDFB2")
    :setScale(0.5)
    :setAnchorPoint(0.5, 0.5)
	:setAnchorTextShadow(true)
	:setWrapMode(1)
    :setPosition(0, -40)
    self.node_bottom:addChild(self.lbl_left_time, 10001)

    self:initDone()
    self:updateLayer()
end

function SuperStageMatchLayer:onExit()

end

function SuperStageMatchLayer:initDone()
    self:addEvent(EVENT.SUPER_STAGE.MATCH_SUCCESS, handler(self, self.matchInfo))
    self:addEvent(EVENT.SUPER_STAGE.MATCH_PLAYER_INFO, handler(self, self.matchInfo))
    self:addEvent(EVENT.SUPER_STAGE.MATCH_BATTLE, handler(self, self.battleStart))
    self:addEvent(EVENT.SUPER_STAGE.ADD_MATCH_TIMES, handler(self, self.addTimesDone))
    self:addEvent(EVENT.SUPER_STAGE.FIGHT, handler(self,self.reqLineupFightingDone))

    self:addTimer("timer", 300, handler(self, self.update), true)

    self:reqLineupFighting()
end

function SuperStageMatchLayer:changeLayerIn()
    ex.Player.super_stage_data:reqInfo()

    -- 如果正在匹配中，则立马请求匹配的敌人数据
    if ex.Player.super_stage_data.is_matching then
        NetManager:sendMessage(ProtocolID.GReqMatchInfo)
    end
end

function SuperStageMatchLayer:update(dt)
    local super_stage_data = ex.Player.super_stage_data
    -- 刷新匹配时间显示
    if not super_stage_data.is_matching or super_stage_data.match_player_info == nil or self.spine_vs == nil then
        return
    end
    if super_stage_data.match_player_info.countdown == nil or super_stage_data.match_player_info.countdown <= 0 then
        return
    end
    local now = ex.Game:getServerTime()
    if super_stage_data.match_player_info.countdown < now then
        self:updateLayer()
        return
    end
    self.lbl_left_time:setXmlTextLua(string.format(ex.Tools:getLang(74848), super_stage_data.match_player_info.countdown - now))
    self.lbl_left_time:formatText()
end

function SuperStageMatchLayer:updateLayer()
    local super_stage_data = ex.Player.super_stage_data
    local config_stage_self = cfg.superstage.superstage[super_stage_data.cur_stage_id]
    if config_stage_self == nil then
        return
    end

    -- 活動已結束，則直接跳轉會主城
    if not super_stage_data:isOpen() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
        return
    end

    -- 如果匹配時間結束，則返回功能主界面
    if ex.Game:getServerTime() > super_stage_data.match_end_time then
        self:onBack()
        return
    end

    -- 刷新己方阵容显示
    self:updateHeroListInfoForSelf()

    -- 刷新敌方阵容显示
    local is_pass_lineup = cc.UserDefault:getInstance():getBoolForKey("super_stage_pass_lineup", false)
    if not super_stage_data.is_matching or super_stage_data.match_player_info == nil then
        -- 如果匹配成功前则只显示默认英雄图片
        self.node_enermy:setVisible(false)
        self.spr_default_hero:setVisible(true)
        self.node_lineup_pass:setVisible(not super_stage_data.is_matching)
        self.btn_match:setVisible(true)
        self.btn_lineup:setVisible(not super_stage_data.is_matching or not is_pass_lineup)
        self.btn_start:setVisible(false)
        self.spr_default_hero:setVisible(true)

        if self.spine_vs ~= nil then
            self.spine_vs:removeFromParent()
            self.spine_vs = nil
        end
        
        if self.spine_match ~= nil then
            self.spine_match:removeFromParent()
            self.spine_match = nil
        end
        
        self.lbl_left_time:setVisible(false)

        self.btn_lineup_pass:setChecked(is_pass_lineup)
    else
        local now = ex.Game:getServerTime()
        if super_stage_data.match_player_info.countdown > 0 and super_stage_data.match_player_info.countdown < now then
            -- NetManager:sendMessage(ProtocolID.GReqChallenge)
            super_stage_data.match_player_info.countdown = -1
        end
    
        -- 如果匹配成功后则显示敵方阵容
        self.node_enermy:setVisible(true)
        self.spr_default_hero:setVisible(false)
        self.node_lineup_pass:setVisible(false)
        -- 如果勾選了跳過調整陣容，則不顯示調整陣容按鈕
        self.btn_match:setVisible(false)
        self.btn_lineup:setVisible(not is_pass_lineup)
        self.btn_start:setVisible(not is_pass_lineup)

        self:updateHeroListInfoForEnermy()

        self.lbl_left_time:setVisible(true)
    end

    -- 更新匹配次数显示
    self.lbl_times:setString(string.format("%s/%s", super_stage_data.battle_times_left, ex.Tools:getSysCfg("super_stage_daily_matches")))
    self.lbl_times_buy:setString(super_stage_data.battle_times_buy_left)
    self.lbl_times_buy:setVisible(super_stage_data.battle_times_buy_left > 0)
    self.lbl_times_buy_title:setVisible(super_stage_data.battle_times_buy_left > 0)
end

function SuperStageMatchLayer:updateHeroListInfoForSelf()
    local super_stage_data = ex.Player.super_stage_data
    local config_stage_self = cfg.superstage.superstage[super_stage_data.cur_stage_id]
    if config_stage_self == nil then
        return
    end

    local server_id = tonumber(cc.UserDefault:getInstance():getStringForKey("server_id" or 0))
    local vec_selected, fetter_type, formation_id = ex.Player.lineup_data:getIdList(BattleType.SUPER_STAGE, {NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID, NULL_ID})

    self.lbl_player_self:setString(ex.StringUtil.getServerName(server_id)..ex.Player.nick)
    ex.Tools:setSpriteFrame(self.spr_matrix_self, string.format("hero-select/spr-matrix-2-%d.png", formation_id))

    ex.Tools:setSpriteFrame(self.spr_stage_self, "super-stage-icon/rank-2-"..config_stage_self.icon_idx..".png")
    self.lbl_stage_name_self:setString(ex.Tools:getLang(config_stage_self.name_lang))

    for i=1,LineupNum do
        self["spr_lock_self_"..i]:setVisible(true)
    end
    for _,v in pairs(cfg.battlematrixaddition.battlematrixaddition) do
        if v.type == formation_id and self["spr_lock_self_"..v.position] ~= nil then
            self["spr_lock_self_"..v.position]:setVisible(v.is_open <= 0)
        end
    end

    local show_spine_hero_data = nil
    for i=1,LineupNum do
        local node_hero = self["node_item_self_"..i]
        if node_hero ~= nil then
            node_hero:removeAllChildren()
        end
    end
    for i=1,LineupNum do
        local hero_data = vec_selected[i] > 0 and ex.Player.hero_data:getHeroDataById(vec_selected[i]) or nil

        if hero_data ~= nil then
            local node_hero = self["node_item_self_"..i]
            local fashion_id = ex.Player.hero_data.fashion:getWearByID(hero_data.hero_id) or 0
            local item_hero = UIMenuItemHero:createWithData(hero_data.hero_id, hero_data.hero_type, nil, hero_data.level, hero_data.star, nil, nil, fashion_id)
            item_hero:setScale(0.75)
            node_hero:addChild(item_hero, 100)

            if show_spine_hero_data == nil or show_spine_hero_data.fighting < hero_data.fighting then
                show_spine_hero_data = hero_data
            end
        end
    end

    if show_spine_hero_data ~= nil then
        if self.spine_hero_self == nil or show_spine_hero_data.hero_type ~= self.spine_hero_self.hero_type or show_spine_hero_data.star ~= self.spine_hero_self.star then
            if self.spine_hero_self ~= nil then
                self.spine_hero_self:removeFromParent()
                self.spine_hero_self = nil
            end
            local fashion_id = ex.Player.hero_data.fashion:getWearByID(show_spine_hero_data.hero_id) or 0
            if fashion_id <= 0 then
            local skin = ex.Tools:getHeroSkinByStar(show_spine_hero_data.hero_type, show_spine_hero_data.star,show_spine_hero_data.evolve)
                self.spine_hero_self = require("src.person.Hero"):create("1", "1", show_spine_hero_data.hero_type, show_spine_hero_data.level, show_spine_hero_data.star, skin)
            else
                self.spine_hero_self = require("src.person.Hero"):create("1", "1", 1, 1, 1, fashion_id)
            end
            -- self.spine_hero_self:setShadowVisible(false)
            self.spine_hero_self:setScaleX(-2.1)
            self.spine_hero_self:setScaleY(2.1)
            self.spine_hero_self:registerScriptTapHandler(function()
                self.spine_hero_self:attack()
            end)
            self.node_hero_self_show:addChild(self.spine_hero_self)

            self.spine_hero_self.hero_type = show_spine_hero_data.hero_type
            self.spine_hero_self.star = show_spine_hero_data.star
        end
    end
end

function SuperStageMatchLayer:updateHeroListInfoForEnermy()
    local super_stage_data = ex.Player.super_stage_data
    local config_stage_enermy = cfg.superstage.superstage[super_stage_data.match_player_info.stage_id]

        self.lbl_player_enermy:setString(ex.StringUtil.getServerName(tonumber(super_stage_data.match_player_info.server_id))..super_stage_data.match_player_info.name)
        self.lbl_battle_count_enermy:setString(super_stage_data.match_player_info.fighting)
        ex.Tools:setSpriteFrame(self.spr_matrix_enermy, string.format("hero-select/spr-matrix-2-%d.png", super_stage_data.match_player_info.formation_id))

        ex.Tools:setSpriteFrame(self.spr_stage_enermy, "super-stage-icon/rank-2-"..config_stage_enermy.icon_idx..".png")
        self.lbl_stage_name_enermy:setString(ex.Tools:getLang(config_stage_enermy.name_lang))
    
        for i=1,LineupNum do
            self["spr_lock_enermy_"..i]:setVisible(true)
        end
        for _,v in ipairs(cfg.battlematrixaddition.battlematrixaddition) do
            if v.type == super_stage_data.match_player_info.formation_id and self["spr_lock_enermy_"..v.position] ~= nil then
                self["spr_lock_enermy_"..v.position]:setVisible(v.is_open <= 0)
            end
        end

        local show_spine_hero_data = nil
        for i=1,LineupNum do
            local node_hero = self["node_item_enermy_"..i]
            if node_hero ~= nil then
                node_hero:removeAllChildren()
            end
        end
        for i=1,LineupNum do
            local hero_data = nil
            for _,tmp_hero_data in ipairs(super_stage_data.match_player_info.hero) do
                if tmp_hero_data.pos == i then
                    hero_data = tmp_hero_data
                    break
                end
            end
    
            if hero_data ~= nil then
                local node_hero = self["node_item_enermy_"..i]
                local item_hero = UIMenuItemHero:createWithData("1", hero_data.hero_id, nil, hero_data.level, hero_data.star)
                if hero_data.fashion_id > 0 then
                    item_hero:setIcon(hero_data.hero_id, true, hero_data.fashion_id, true)
                end
                item_hero:setScale(0.75)
                node_hero:addChild(item_hero, 100)

                if show_spine_hero_data == nil or show_spine_hero_data.fighting < hero_data.fighting then
                    show_spine_hero_data = hero_data
                end
            end
        end

        if show_spine_hero_data ~= nil and self.spine_hero_enermy == nil then
            if self.spine_hero_enermy == nil or show_spine_hero_data.hero_id ~= self.spine_hero_enermy.hero_type or show_spine_hero_data.star ~= self.spine_hero_enermy.star then
                if self.spine_hero_enermy ~= nil then
                    self.spine_hero_enermy:removeFromParent()
                    self.spine_hero_enermy = nil
                end
                if show_spine_hero_data.fashion_id <= 0 then
                    local skin = ex.Tools:getHeroSkinByStar(show_spine_hero_data.hero_id, show_spine_hero_data.star,show_spine_hero_data.evolve)
                    self.spine_hero_enermy = require("src.person.Hero"):create("1", "1", show_spine_hero_data.hero_id, show_spine_hero_data.level, show_spine_hero_data.star, skin)
                else
                    self.spine_hero_enermy = require("src.person.Hero"):create("1", "1", 1, 1, 1, show_spine_hero_data.fashion_id)
                end
                -- self.spine_hero_enermy:setShadowVisible(false)
                self.spine_hero_enermy:setScale(2.1)
                self.spine_hero_enermy:registerScriptTapHandler(function()
                    self.spine_hero_enermy:attack()
                end)
                self.node_hero_enermy_show:addChild(self.spine_hero_enermy)

                self.node_hero_enermy_show.hero_type = show_spine_hero_data.hero_id
                self.node_hero_enermy_show.star = show_spine_hero_data.star
            end
        end
end

-- 請求陣容戰力
function SuperStageMatchLayer:reqLineupFighting()
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
        self:reqLineupFightingDone(EVENT.SUPER_STAGE.FIGHT, 0)
        return
    end

    local req_compute = Battle_pb.GReqPreComputeStrength()
    req_compute.type = EVENT.SUPER_STAGE.FIGHT
    req_compute.line_up_type = battle_config.line_up_type

    for i,v in ipairs(vec_selected) do
		if v ~= NULL_ID then
            table.insert(req_compute.hero_ids, v)
        end
    end
    NetManager:sendMessage(ProtocolID.GReqPreComputeStrength, req_compute)
end

-- 請求陣容戰力回調
function SuperStageMatchLayer:reqLineupFightingDone(event, fighting)
    self.lbl_battle_count_self:setString(fighting)
end

-- 选择是否跳过布阵
function SuperStageMatchLayer:onPassLineup(tag, pSender)
    cc.UserDefault:getInstance():setBoolForKey("super_stage_pass_lineup", pSender:isChecked())
end

-- 购买战斗次数
function SuperStageMatchLayer:onAddTimes(tag, pSender)
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

-- 购买战斗次数成功，更新相关显示
function SuperStageMatchLayer:addTimesDone()
    local super_stage_data = ex.Player.super_stage_data
    self.lbl_times:setString(string.format("%s/%s", super_stage_data.battle_times_left, ex.Tools:getSysCfg("super_stage_daily_matches")))
    self.lbl_times_buy:setString(super_stage_data.battle_times_buy_left)
    self.lbl_times_buy:setVisible(super_stage_data.battle_times_buy_left > 0)
    self.lbl_times_buy_title:setVisible(super_stage_data.battle_times_buy_left > 0)
end

function SuperStageMatchLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_MAIN)
end

function SuperStageMatchLayer:onInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42084), ex.Tools:getLang(42085))
end

-- 队形调整
function SuperStageMatchLayer:onLineup(tag, pSender)
    require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47546),
                                                             ex.Tools:getLang(47396),
                                                             BattleType.SUPER_STAGE,
                                                             handler(self, self.onLineupDone))
end

-- 队形调整回调
function SuperStageMatchLayer:onLineupDone()
    self:updateLayer()

    self:reqLineupFighting()
end

-- 开始匹配
function SuperStageMatchLayer:onMatch(tag, pSender)
    local super_stage_data = ex.Player.super_stage_data
    -- 活動已結束，則直接跳轉會主城
    if not super_stage_data:isOpen() then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
        return
    end

    -- 如果匹配時間結束，則返回功能主界面
    if ex.Game:getServerTime() > super_stage_data.match_end_time then
        self:onBack()
        return
    end

    -- 匹配次數不夠則返回
    if super_stage_data.battle_times_left <= 0 then
        ex.MessageView:add(ex.Tools:getLang(74846))
        return
    end

    -- 如果匹配中，则不做反应
    if super_stage_data.is_matching then
        print("數據錯誤，無法匹配對手，需刷新界面")
        self:updateLayer()
        return
    end

    local is_pass_lineup = cc.UserDefault:getInstance():getBoolForKey("super_stage_pass_lineup", false)
    -- 请求匹配对手
    local req = StageMatch_pb.GReqMatchOpponent()
    req.skip_array = is_pass_lineup
    NetManager:sendMessage(ProtocolID.GReqMatchOpponent, req)

    self.spr_default_hero:setVisible(false)

    if self.spine_match == nil then
        self.spine_match = sp.SkeletonAnimation:create("spine/hytx.json", "spine/hytx.atlas", 1)
        self.spine_match:setAnimation(0, "stand", true)
        self.spine_match:setPosition(self.spr_bg_enermy:getContentSize().width / 2, self.spr_bg_enermy:getContentSize().height / 2)
        self.spr_bg_enermy:addChild(self.spine_match)

        -- 骨骼動畫回調
        self.spine_match:registerSpineEventHandler(function(e)
            if self.spine_vs == nil and super_stage_data.match_player_info ~= nil then
                self.spine_vs = sp.SkeletonAnimation:create("spine/dwvs.json", "spine/dwvs.atlas", 1)
                self.spine_vs:setAnimation(0, "stand", false)
                self.spine_vs:setPosition(self.spr_vs:getPositionX() - 15, self.spr_vs:getPositionY() - 35)
                self.spr_vs:getParent():addChild(self.spine_vs)
        
                if self.spine_match ~= nil then
                    self.spine_match:runAction(cc.Sequence:create(cc.FadeOut:create(0.1),
                                                                  cc.RemoveSelf:create(),
                                                                  nil))
                    self.spine_match = nil
                end

                -- 骨骼動畫
                self.spine_vs:registerSpineEventHandler(function(e)

                    self:updateLayer()
                end, sp.EventType.ANIMATION_COMPLETE)
        
                -- 敵方信息顯示動畫
                -- local offset = self.node_enermy:getParent():getContentSize().width
                -- self.node_enermy:setPositionX(offset * (-0.5))
                -- self.node_enermy:runAction(cc.MoveBy:create(0.5, cc.p(offset, 0)))
            end
        end, sp.EventType.ANIMATION_COMPLETE)
    end
end

-- 匹配成功，执行特效，并显示敌方玩家信息
function SuperStageMatchLayer:matchInfo(event, data)
    if data == nil or data.stage_id <= 0 then
        -- 未找到對手，取消匹配狀態
        ex.Player.super_stage_data.is_matching = false
        ex.Player.super_stage_data.is_battling = false
        ex.Player.super_stage_data.match_player_info = nil

        self:updateLayer()
		return
    end

    ex.MainSceneCtr:addKeepLayer(MainSceneType.MAINCITY_SUPER_STAGE_MATCH)
    
    ex.Player.super_stage_data.is_matching = true

    ex.Player.super_stage_data.match_player_info = data

    local is_pass_lineup = cc.UserDefault:getInstance():getBoolForKey("super_stage_pass_lineup", false)
    -- 如果勾選了跳過調整陣容，則不顯示調整陣容按鈕
    self.btn_match:setVisible(false)
    self.btn_lineup:setVisible(not is_pass_lineup)
    self.btn_start:setVisible(not is_pass_lineup)
    self.node_lineup_pass:setVisible(false)
end

function SuperStageMatchLayer:onBattleStart(tag, pSender)
    local super_stage_data = ex.Player.super_stage_data
    local is_pass_lineup = cc.UserDefault:getInstance():getBoolForKey("super_stage_pass_lineup", false)
    if super_stage_data.is_matching and super_stage_data.match_player_info ~= nil and not is_pass_lineup then
        NetManager:sendMessage(ProtocolID.GReqChallenge)
    end
end

function SuperStageMatchLayer:battleStart(event, data)
    if self.spine_match ~= nil then
        self.spine_match:removeFromParent()
        self.spine_match = nil
    end

    if self.spine_vs ~= nil then
        self.spine_vs:removeFromParent()
        self.spine_vs = nil
    end

    require("src.layer.HeroSelectCtr"):instance():closeWindow(0, nil)

    ex.Player.super_stage_data:reqInfo()

    ex.Player.super_stage_data.is_matching = false
    ex.Player.super_stage_data.match_player_info = nil
    ex.Player.super_stage_data.is_battling = true

    local battle_layer = self:addBattleLayer(BattleType.SUPER_STAGE,
                                            MainSceneType.MAINCITY_SUPER_STAGE_MATCH,
                                            "",
                                            nil, 
                                            function(layer, data, vec_reward, ext)
                                                ex.Player.super_stage_data.is_battling = false

                                                local config_stage = cfg.superstage.superstage[ext.new_stage_id]
                                                local config_stage_old = cfg.superstage.superstage[ext.old_stage_id]

                                                local data_battle_end = {}
                                                data_battle_end.result = ext
                                                data_battle_end.config_stage = config_stage
                                                data_battle_end.config_stage_old = config_stage_old

                                                local battle_end_ctr = require("src.layer.superstage.SuperStageBattleEndCtr"):instance()
                                                battle_end_ctr:openWindow(BattleType.SUPER_STAGE, data_battle_end)

                                                -- ex.MainSceneCtr:removeKeepLayer(MainSceneType.MAINCITY_SUPER_STAGE_MATCH)
                                                if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_SUPER_STAGE_MATCH then
                                                    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_MAIN)
                                                end

                                                return true, false
                                            end)
    battle_layer:setPosition(battle_layer:getPositionX() + self:getContentSize().width / 2 - ex.p.width / 2,
                            battle_layer:getPositionY() + self:getContentSize().height / 2 - ex.p.height / 2)
    battle_layer:setScale(1 / self:getScale())

    battle_layer:battleStart(nil, data.report, data.reward, data)

    -- 如果在功能主界面或者戰令界面，則跳轉回此界面
    local cur_layer_type = ex.MainSceneCtr:getCurLayerType()
    if cur_layer_type == MainSceneType.MAINCITY_SUPER_STAGE_MAIN or
       cur_layer_type == MainSceneType.MAINCITY_SUPER_STAGE_LEGEND or
       cur_layer_type == MainSceneType.MAINCITY_SUPER_STAGE_TOKEN then
        ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_MATCH)
    end
end

-- 层切入时会被调用
function SuperStageMatchLayer:changeLayerIn()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function SuperStageMatchLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

return SuperStageMatchLayer
