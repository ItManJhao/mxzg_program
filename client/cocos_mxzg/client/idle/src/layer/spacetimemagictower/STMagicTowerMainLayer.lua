local STMagicTowerMainLayer = class("STMagicTowerMainLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

local HeroAnim = require("src.person.Hero")

-- function STMagicTowerMainLayer:getAsynImage()
--     local vec_image = {
--         {image_name = "ccbi-res/map-bg-super-stage.jpg", remove_type = 1}
--     }
--     return vec_image
-- end
local normal_lv_pos = {
    {x = 565, y = 316},
    {x = 65, y = 595},
    {x = 535, y = 850}
}

local fire_pos = {
    {x = 66, y = 687, scale_y = 0.5},
    {x = 220, y = 740, scale_y = 0.5},
    {x = 385, y = 700, scale_y = 1},
    {x = 614, y = 620, scale_y = 1}
}

local boss_lv_pos = {
    {x = 200, y = 500}
}

function STMagicTowerMainLayer:onCreate()
    -- ex.MainSceneCtr:addKeepLayer(MainSceneType.MAINCITY_SPACE_TIME_MAGIC_TOWER_MAIN)

    NetManager:sendMessage(ProtocolID.GReqTimeTowerInfo)

    self:setAutoClose(false)
    self:setSwallowTouches(true)
    self:initEventListen()
    self:initPlist()

    self.node_top:setZOrder(100)
    self.node_bottom:setZOrder(100)
    local pos_y = ex.p.height - 100 * ex.s.global_scale - require("src.model.Game"):instance():getNotchHeight()
    self.node_top:setPositionY(pos_y)
    self.node_bottom:setPositionY(ex.MainSceneCtr:getBottomHeight())
    self.btn_info:registerScriptTapHandler(handler(self, self.onClickInfo))

    self:addRedDotNode(RedDotType.ZCJ_DHZC_KFSK_SKMT_KSTZ, self.btn_challenge)

    self:updateLayer(true)
end

function STMagicTowerMainLayer:initEventListen()
    self:addEvent(EVENT.SPACE_TIME_MAGIC_TOWER.UPDATE_INFO, handler(self, self.handleUpdateInfo))
    self:addEvent(EVENT.SPACE_TIME_MAGIC_TOWER.BATTLE, handler(self, self.battleStart))
    self:addEvent(EVENT.SPACE_TIME_MAGIC_TOWER.BATTLE_END_CLOSE, handler(self, self.handleCloseBattelEnd))
    self:addEvent(EVENT.SPACE_TIME_MAGIC_TOWER.JUMP_CLOSE, handler(self, self.updateLayer))
end

function STMagicTowerMainLayer:initPlist()
    -- 加载需要的资源
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("hero/hero.plist")
    sfc:addSpriteFrames("ccbi-res/time-tower.plist")
end

function STMagicTowerMainLayer:getBgByType(type)
    if type == 2 then
        return "ccbi-res/time-tower-bg-2.jpg"
    else
        return "ccbi-res/time-tower-bg-1.jpg"
    end
end

function STMagicTowerMainLayer:updateLayer(is_refresh, is_force)
    local data = clone(ex.Player.space_time_magic_tower_data)
    self.data = data
    local cur_mission = data.mission_id + 1
    if not cfg.timetowermisson.getConfigByMission(cur_mission) then
        self.is_end = true
        cur_mission = data.mission_id
    else
        self.is_end = false
    end

    local cur_configs = cfg.timetowermisson.getConfigsByLevel(data.cur_lv)
    if not cur_configs or #cur_configs == 0 then
        return
    end

    local is_jump = false
    local is_run_to_top = false
    if (self.cur_mission and cur_mission - self.cur_mission > 1) or
    self.cur_lv and self.cur_lv < data.cur_lv then
        is_refresh = true
        is_jump = true
        if type(self.spr_bg.type) == "number" and self.spr_bg.type == 1 and cur_mission - self.cur_mission == 1 then
            is_run_to_top = true
        end
    end

    if self.is_end then
        self.btn_challenge:setVisible(false)
        self.btn_challenge:setEnabled(false)
        self.lbl_end_tip:setVisible(true)
    else
        self.btn_challenge:setVisible(true)
        self.btn_challenge:setEnabled(true)
        self.lbl_end_tip:setVisible(false)
    end

    if is_jump and not is_force then
        local dt = 0
        if is_run_to_top then
            dt = 1
            self.spr_hero:setAnimation(0, "run", true)
            self.spr_hero:runAction(cc.MoveBy:create(1, cc.p(-self.spr_hero:getContentSize().width / 2, self.spr_hero:getContentSize().height)))
            self:updateMonstersStatus(cur_mission, self.spr_bg, data.mission_mark)
        end

        self:runAction(cc.Sequence:create(
            cc.DelayTime:create(dt),
            cc.CallFunc:create(
                function ()
                    self:jumpMission()
                    self.spr_bg:setVisible(false)
                    self.spr_hero:setVisible(false)
                end
            ),
            cc.DelayTime:create(0.3),
            cc.CallFunc:create(
                function()
                    self:updateInfoUi(cur_mission, data.cur_lv, data.accumulate_pass, data.max_pass)
                    self:updateMap(data.cur_lv)
                    self:updateMonsters(cur_mission, cur_configs, is_refresh, data.mission_mark)
                    self:updateHero(cur_mission, data.cur_lv, data, true, is_jump)
                    self.spr_hero:setVisible(true)
                end
            ),
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function()
                self:jumpMissionDone()
            end)
        ))
    else
        self:updateInfoUi(cur_mission, data.cur_lv, data.accumulate_pass, data.max_pass)
        if is_refresh then
            self:updateMap(data.cur_lv)
        end
        self:updateMonsters(cur_mission, cur_configs, is_refresh, data.mission_mark)
        self:updateHero(cur_mission, data.cur_lv, data, is_refresh)
    end
end

-- 刷新当前关卡信息UI
function STMagicTowerMainLayer:updateInfoUi(cur_mission, cur_lv, accumulate_pass, max_pass)
    self.lbl_mission:setString(string.format(ex.Tools:getLang(75620), cur_lv))
    local conditions = cfg.timetowermisson.getMissionCondition(cur_mission)
    if conditions and #conditions > 0 then
        local str = ""
        for i = 1, #conditions do
            local condition = conditions[i]
            if i > 1 then
                str = str + "\n"
            end

            str = string.format("%s%s", condition.str, condition.value_str)
        end

        self.lbl_condition:setString(str)
        self.lbl_condition:setVisible(true)
        self.lbl_condition_title:setVisible(true)
    else
        self.lbl_condition_title:setVisible(false)
        self.lbl_condition:setVisible(false)
    end

    self.lbl_pass:setString(string.format("%s：%s%s", ex.Tools:getLang(75616), accumulate_pass, ex.Tools:getLang(47267)))
    self.lbl_max_record:setString(string.format("%s：%s%s", ex.Tools:getLang(75617), max_pass, ex.Tools:getLang(47267)
))
end


-- 根据地图类型获取位置节点列表
function STMagicTowerMainLayer:addPosNodeToBg(type, bg)
    local pos_list
    if type == 1 then
        pos_list = normal_lv_pos
    else
        pos_list = boss_lv_pos
    end

    if not bg.pos_list or #bg.pos_list > 0 then
        bg.pos_list = {}
    end

    for i = 1, #pos_list do
        local pos = pos_list[i]
        local node_pos = cc.Node:create()
        node_pos:setPosition(pos.x, pos.y)
        local model = {}
        model.node_pos = node_pos

        table.insert(bg.pos_list, node_pos)
        bg:addChild(node_pos)
    end
end

function STMagicTowerMainLayer:updateMap(cur_lv)
    local cur_type = cfg.timetowermisson.getTypeByLevel(cur_lv)

    local cur_texture = self:getBgByType(cur_type)
    self.spr_bg = cc.Sprite:create(cur_texture)
    self.spr_bg:setAnchorPoint(0.5, 0.5)
    self.spr_bg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    self:addChild(self.spr_bg, 10)
    self.spr_bg.type = cur_type
    self.spr_bg.level = cur_lv
    self.spr_bg:removeAllChildren()
    self.spr_bg.monsters = {}
    self.spr_bg.swords = {}
    ex.Tools:AdjustFullScreenExtend(self.spr_bg)
    self:addPosNodeToBg(cur_type, self.spr_bg)

    if cur_type == 2 then
        for k, v in ipairs(fire_pos) do
            local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_time_tower_fire")
            spr_effect:setAnchorPoint(cc.p(0.5, 0))
            spr_effect:setScaleY(v.scale_y)
            spr_effect:setPosition(v.x, v.y)
            self.spr_bg:addChild(spr_effect)
        end
    end
end

function STMagicTowerMainLayer:updateMonsters(cur_mission, configs, is_refresh, mission_mark)
    if is_refresh then
        if not self.spr_bg.monsters or #self.spr_bg.monsters == 0 then
            self:addMonsters(cur_mission, configs, self.spr_bg)
        end
    end

    self:updateMonstersStatus(cur_mission, self.spr_bg, mission_mark)
end

function STMagicTowerMainLayer:updateMonstersStatus(cur_mission, bg)
    if bg.monsters and #bg.monsters then
        for i = 1, #bg.monsters do
            local monster = bg.monsters[i]
            if monster then
                if monster.mission < cur_mission then
                    monster:setVisible(false)
                    if bg.swords then
                        local sword_icon = bg.swords[i]
                        if sword_icon then
                            sword_icon:setVisible(true)
                        end
                    end
                elseif monster.mission == cur_mission then
                    self.next_monsetr = monster
                    if self.is_end then
                        monster:setVisible(false)
                        if bg.swords then
                            local sword_icon = bg.swords[i]
                            if sword_icon then
                                sword_icon:setVisible(true)
                            end
                        end
                    end
                end
            end 
        end
    end
end

function STMagicTowerMainLayer:addMonsters(cur_mission, configs, bg)
    if bg.monsters and #bg.monsters > 0 then
        for i = 1, #bg.monsters do
            local monster = bg.monsters[i]
            monster:removeFromParent()
        end
    end

    if bg.swords and #bg.swords > 0 then
       for i = 1, #bg.swords do
            local sword = bg.swords[i]
            sword:removeFromParent()
        end
    end

    bg.monsters = {}
    bg.swords = {}

    if configs and #configs > 0 then
        for i = 1, #configs do
            local config = configs[i]
            if bg.pos_list and bg.pos_list[i] then
                local node_pos = bg.pos_list[i]
                local is_flipped_x = false
                local offset_x = -50
                local offset_sword_x = -60
                if node_pos:getPositionX() < bg:getContentSize().width / 2 then
                    is_flipped_x = true
                    offset_x = 50
                    offset_sword_x = 60
                end

                local hero_skin = ex.Tools:getHeroSkinByStar(config.hero_type, config.hero_star)
                local monster = self:createHero(config.hero_type, config.hero_star, hero_skin, nil, config.mission)
                monster:setPosition(node_pos:getPositionX() + offset_x, node_pos:getPositionY() + monster:getContentSize().height / 2)
                monster.mission = config.mission
             
                monster:setFlippedX(is_flipped_x)
                monster:setVisible(false)
                bg:addChild(monster)
                table.insert(bg.monsters, monster)

                local spine_sword = sp.SkeletonAnimation:create("spine/battle-sword.json", "spine/battle-sword.atlas", 1)
                spine_sword:setAnimation(0, "stand", true)
                spine_sword:setPosition(monster:getContentSize().width / 2, monster:getContentSize().height + spine_sword:getContentSize().height * 0.5 / 2)
                spine_sword:setScale(0.5)
                spine_sword:setName("spine_sword")
                spine_sword:setVisible(false)
                monster:addChild(spine_sword, 10)

                local sword_icon = cc.Sprite:createWithSpriteFrameName("time-tower/sword-icon.png")
                sword_icon:setPosition(node_pos:getPositionX() + offset_sword_x, node_pos:getPositionY() + sword_icon:getContentSize().height / 2 - 30)
                sword_icon:setVisible(false)
                bg:addChild(sword_icon)
                table.insert(bg.swords, sword_icon)

                if cur_mission > config.mission then
                    sword_icon:setVisible(true)
                else
                    monster:setVisible(true)
                    if cur_mission == config.mission then
                        spine_sword:setVisible(true)
                    end
                end
            end
        end
    end
end

function STMagicTowerMainLayer:updateHero(cur_mission, cur_lv, data, is_refresh, is_jump)    
    if not self.spr_hero then
        local hero_type, star = ex.Player:getImageId()
        local hero_skin = ex.Tools:getHeroSkinByStar(hero_type, star)
        self.spr_hero = self:createHero(hero_type, star, hero_skin, true)
        if self.spr_hero then
            self:addChild(self.spr_hero, 50)
        end
    end

    self.spr_hero:stopAllActions()
    self:setHeroHeart(data.heart)

    if self.cur_mission == cur_mission then
        return
    end
    
    if is_refresh then
        local index = self:getHeroPosNode(cur_mission)
        local bg = self.spr_bg
        
        local node_pos = bg.pos_list[index]
        if node_pos then
            local world_pos = node_pos:getParent():convertToWorldSpace(cc.p(node_pos:getPositionX(), node_pos:getPositionY()))
            local pos = self:convertToNodeSpace(world_pos)

            local is_flipped_x = true
            local offset_x = -self.spr_hero:getContentSize().width - 90
            if node_pos:getPositionX() < 320 then
                is_flipped_x = false
                offset_x = self.spr_hero:getContentSize().width + 90
            end


            local offset_y = -self.spr_hero:getContentSize().height / 2 + 30
            if self.spr_bg.type == 2 then
                offset_y = self.spr_hero:getContentSize().height / 2
                offset_x = self.spr_hero:getContentSize().width + 90
            end

            self.spr_hero:setFlippedX(is_flipped_x)
            self.spr_hero.pos_index = index

            if not is_jump then
                self.spr_hero:setPosition(pos.x + offset_x, pos.y + offset_y)
            else
                if self.spr_bg.type == 1 and index == 1 then
                    self.spr_hero:setAnimation(0, "run", true)
                    self.spr_hero:setPosition(pos.x + offset_x - self.spr_hero:getContentSize().width, pos.y + offset_y - self.spr_hero:getContentSize().height)
                    self.spr_hero:runAction(cc.Sequence:create(
                        cc.MoveTo:create(1, cc.p(pos.x + offset_x, pos.y + offset_y)),
                        cc.CallFunc:create(function ()
                            self.spr_hero:setAnimation(0, "stand", true)
                        end)
                    ))
                elseif self.spr_bg.type == 2 then
                    self.spr_hero:setAnimation(0, "run", true)
                    self.spr_hero:setPosition(pos.x + offset_x + self.spr_hero:getContentSize().width, pos.y + offset_y)
                    self.spr_hero:runAction(cc.Sequence:create(
                        cc.MoveTo:create(1, cc.p(pos.x + offset_x, pos.y + offset_y)),
                        cc.CallFunc:create(function ()
                            self.spr_hero:setAnimation(0, "stand", true)
                        end)
                    ))
                else
                    self.spr_hero:setPosition(pos.x + offset_x, pos.y + offset_y)
                end
            end
        end

        self.cur_mission = cur_mission
        self.cur_lv = cur_lv
    else
        self:playGoNext(cur_mission, cur_lv, data)
    end
end

function STMagicTowerMainLayer:playGoNext(cur_mission, cur_lv, data)
    local temp_data = clone(data)
    local pos_list = self.spr_bg.pos_list
    local index = self.spr_hero.pos_index or 1
    if not pos_list or #pos_list < index + 1 then
        return
    end

    self.spr_hero:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.2),
        cc.CallFunc:create(function ()
            self.spr_hero:setAnimation(0, "run", true)
        end),
        cc.CallFunc:create(function ()
            local node_pos = pos_list[index + 1]
            if node_pos then
                self:playHeroMove(node_pos, index, function (index)
                    self.spr_hero:setAnimation(0, "stand", true)
                    self.cur_mission = cur_mission
                    self.cur_lv = cur_lv
                    self.spr_hero.pos_index = index
                    if self.next_monsetr then
                        local spine_sword = self.next_monsetr:getChildByName("spine_sword")
                        if spine_sword then
                            spine_sword:setVisible(true)
                        end
                    end
                end)
            end
        end)
    ))
end

function STMagicTowerMainLayer:playHeroMove(node_pos, index, cb)
    local world_pos = node_pos:getParent():convertToWorldSpace(cc.p(node_pos:getPositionX(), node_pos:getPositionY()))
    local pos = self:convertToNodeSpace(world_pos)

    local is_flipped_x = self.spr_hero:isFlippedX()
    local offset_x = -self.spr_hero:getContentSize().width - 90
    if not is_flipped_x then
        offset_x = self.spr_hero:getContentSize().width + 90
    end

    local offset_y = -self.spr_hero:getContentSize().height / 2 + 30
    if self.spr_bg.type == 2 then
        offset_y = self.spr_hero:getContentSize().height / 2
        offset_x = self.spr_hero:getContentSize().width + 90
    end


    self.spr_hero:runAction(cc.Sequence:create(
        cc.MoveTo:create(1, cc.p(pos.x + offset_x, pos.y + offset_y)),
        cc.CallFunc:create(function ()
            if cb then
                cb(index + 1)
            end
        end)
    ))
end

function STMagicTowerMainLayer:getHeroPosNode(cur_mission)
    local monsters = self.spr_bg.monsters
    if monsters and #monsters > 0 then
        for i = 1, #monsters do
            local monster = monsters[i]
            if cur_mission == monster.mission then
                return i
            end
        end
    end

    return 1
end

function STMagicTowerMainLayer:createHero(hero_type, star, hero_skin, has_heart, mission)
    local heroAnim = HeroAnim:create("1", "1", hero_type, 1, star, hero_skin)
    heroAnim:setShadowVisible(true)
    heroAnim:setAnimation(0, "idle", true)

    if type(mission) == "number" and mission > 0 then
        local mission_bg = cc.Sprite:createWithSpriteFrameName("time-tower/mission-bg.png")
        mission_bg:setPosition(heroAnim:getContentSize().width / 2, -mission_bg:getContentSize().height / 2)
        heroAnim:addChild(mission_bg)
        local lbl_mission_text = cc.Label:createWithTTF(string.format(ex.Tools:getLang(47375), mission), FONT_DEFAULT_NAME_BOLD, 36)
        lbl_mission_text:setScale(0.5)
        lbl_mission_text:setPosition(mission_bg:getContentSize().width / 2, mission_bg:getContentSize().height / 2)
        lbl_mission_text:setColor(cc.c3b(253, 245, 215))
        mission_bg:addChild(lbl_mission_text)
    end

    if not has_heart then
        return heroAnim
    end

    local height = heroAnim:getContentSize().height
    local offsetX = -5
    local heartY = height + 10
    for i = 1, 3 do
        local spr_heart_gray = cc.Sprite:createWithSpriteFrameName("time-tower/heart-gray.png")
        local x = heroAnim:getContentSize().width / 2 - offsetX - spr_heart_gray:getContentSize().width + (i - 1) * (offsetX + spr_heart_gray:getContentSize().width)
        spr_heart_gray:setPosition(x, heartY)
        heroAnim:addChild(spr_heart_gray)
    end

    heroAnim.heartList = {}
    for i = 1, 3 do
        local spr_heart_red = cc.Sprite:createWithSpriteFrameName("time-tower/heart-red.png")
        local x = heroAnim:getContentSize().width / 2 - offsetX - spr_heart_red:getContentSize().width + (i - 1) * (offsetX + spr_heart_red:getContentSize().width)
        spr_heart_red:setPosition(x, heartY)
        spr_heart_red:setVisible(false)
        heroAnim:addChild(spr_heart_red)
        table.insert(heroAnim.heartList, spr_heart_red)
    end

    return heroAnim
end

function STMagicTowerMainLayer:setHeroHeart(heart)
    if not self.spr_hero or not self.spr_hero.heartList or #self.spr_hero.heartList < 3 then
        return
    end

    for i = 1, 3 do
        local spr_heart = self.spr_hero.heartList[i]
        if spr_heart then
            spr_heart:setVisible(i <= heart)
        end
    end
end

function STMagicTowerMainLayer:jumpMission()
    self.spr_jump_bg = cc.Sprite:createWithSpriteFrameName("time-tower/jump-bg.png")
    self.spr_jump_bg:setAnchorPoint(cc.p(0.5, 0.5))
    self.spr_jump_bg:setScaleX(ex.p.width / self.spr_jump_bg:getContentSize().width)
    self.spr_jump_bg:setScaleY(ex.p.height / self.spr_jump_bg:getContentSize().height)
    self.spr_jump_bg:setPosition(ex.p.cx, -ex.p.height *1.5)
    self:addChild(self.spr_jump_bg, 9999)

    local action = cc.MoveTo:create(0.3, cc.p(ex.p.cx, ex.p.cy))
    action:setTag(1000)
    self.spr_jump_bg:runAction(action)
end

function STMagicTowerMainLayer:jumpMissionDone()
    if not self.spr_jump_bg then
        return
    end

    local action = cc.Sequence:create(cc.FadeOut:create(0.3), cc.RemoveSelf:create(), nil)
    self.spr_jump_bg:runAction(action)

    self.spr_jump_bg = nil
end

------------------------------- 点击事件 -------------------------------


-- 返回
function STMagicTowerMainLayer:onBack(tag, pSender)
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
end

-- 队形调整
function STMagicTowerMainLayer:onLineup(tag, pSender)
    require("src.layer.HeroSelectCtr"):instance():openWindow(ex.Tools:getLang(47546), ex.Tools:getLang(47396), BattleType.SPACE_TIME_MAGIC_TOWER, handler(self, self.onLineupDone))
end

function STMagicTowerMainLayer:onLineupDone()
end

function STMagicTowerMainLayer:onChallenge()
    local startChallenge = function ()
        require("src.layer.HeroSelectCtr"):instance():openWindow(
            ex.Tools:getLang(47524),
            ex.Tools:getLang(47064),
            BattleType.SPACE_TIME_MAGIC_TOWER,
            function()
                NetManager:sendMessage(ProtocolID.GReqTimeTowerChallenge)
            end
        )
    end
    
    if not self.data then
        ex.MessageView:add(ex.Tools:getLang(32201))
        return
    end

    if not self.data.startTime or not self.data.endTime or 
    self.data.startTime == 0 or self.data.endTime == 0 then
        startChallenge()
        return
    end

    local now = cpp.Game:instance():getServerTime()

    if now < self.data.startTime then
        ex.MessageView:add(ex.Tools:getLang(32201))
        return
    end

    if now > self.data.endTime then
        ex.MessageView:add(ex.Tools:getLang(75629))
        return
    end
    
    startChallenge()
end

function STMagicTowerMainLayer:onRankInfo()
    ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SPACE_TIME_MAGIC_TOWER_RANK)
end

function STMagicTowerMainLayer:onMissionRewardPreview()
    local data = ex.Player.space_time_magic_tower_data or {}
    require("src.layer.spacetimemagictower.STMagicTowerMissionRewardCtr"):instance():openWindow(data.cur_lv)
end

function STMagicTowerMainLayer:onRankRewardPreview()
    require("src.layer.spacetimemagictower.STMagicTowerRankRewardCtr"):instance():openWindow()
end

function STMagicTowerMainLayer:onShop()
    ex.JumpManager:jumpByAtom("main_black_market_time_tower")
end

function STMagicTowerMainLayer:onClickInfo(tag, pSender)
    ex.InfoCtr:openWindow(ex.Tools:getLang(42098), ex.Tools:getLang(42099))
end

------------------------------- 战斗处理 -------------------------------
function STMagicTowerMainLayer:battleStart(event, data)
    local info = clone(ex.Player.space_time_magic_tower_data)
    self.data = info
    -- 收到战报就请求塔的信息，用于刷新
    NetManager:sendMessage(ProtocolID.GReqTimeTowerInfo)

    local battle_layer =
        self:addBattleLayer(
        BattleType.SPACE_TIME_MAGIC_TOWER,
        MainSceneType.MAINCITY_SPACE_TIME_MAGIC_TOWER_MAIN,
        "",
        nil,
        function(layer, data, vec_reward, ext)
            self:battleEnd(info, ext)
            return true, false
        end
    )
    battle_layer:setPosition(battle_layer:getPositionX() + self:getContentSize().width / 2 - ex.p.width / 2, battle_layer:getPositionY() + self:getContentSize().height / 2 - ex.p.height / 2)
    battle_layer:setScale(1 / self:getScale())

    battle_layer:battleStart(nil, data.report, data.reward, data)
end

function STMagicTowerMainLayer:handleUpdateInfo(event)
    local data = clone(ex.Player.space_time_magic_tower_data)
    if self.data.mission_id ~= data.mission_id then
        self:updateLayer(true, true)
    end
end

function STMagicTowerMainLayer:battleEnd(info, settle_data)
    if info.mission_id + 1 - self.cur_mission == 1 and self.spr_bg.type == 1 then
        local hero_flipped_x = self.spr_hero:isFlippedX()
        local pre_x = self.spr_hero:getPositionX()
        local pre_y = self.spr_hero:getPositionY()

        self.spr_hero:setFlippedX(not hero_flipped_x)
        if hero_flipped_x then
            self.spr_hero:setPosition(pre_x, pre_y + self.spr_hero:getContentSize().height + 10)
        else
            self.spr_hero:setPosition(pre_x, pre_y + self.spr_hero:getContentSize().height + 10)
        end
    end

    local is_jump = info.mission_id + 1 - self.cur_mission > 1
    local model = {
        is_jump = is_jump,
        settle_data = settle_data,
        info = info,
    }
    require("src.layer.spacetimemagictower.STMagicTowerBattleEndCtr"):instance():openWindow(BattleType.SPACE_TIME_MAGIC_TOWER, model)
end

function STMagicTowerMainLayer:handleCloseBattelEnd(event, data)
    if data.is_jump and data.settle_data.jump_reward and 
    #data.settle_data.jump_reward > 0 and 
    ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_SPACE_TIME_MAGIC_TOWER_MAIN then
        require("src.layer.spacetimemagictower.STMagicTowerJumpCtr"):instance():openWindow(data)
    else
        self:updateLayer()
    end
end

-- 层切入时会被调用
function STMagicTowerMainLayer:changeLayerIn()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, true)
end

function STMagicTowerMainLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

return STMagicTowerMainLayer
