local ClanGvgLayer = class("ClanGvgLayer", require("src.comp.EventLayer"))

local ClanGvgStageType = {
    ST_MATCH = 1,           -- 匹配阶段
    ST_LINEUP_HERO = 2,     -- 编队阶段
    ST_LINEUP_MEMBER = 3,   -- 调整阶段
    ST_BATTLE = 4,          -- 开战阶段
    ST_FINISHED = 5,        -- 休战阶段
}

function ClanGvgLayer:getAsynImage()
    local vec_image = {
        {image_name = "ccbi-res/map-bg-clan-gvg-1.jpg", remove_type=1},
    }
    return vec_image
end

function ClanGvgLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/clan.plist")

    local last_content_size = self:getContentSize()
    local cur_content_size = cc.size(ex.p.width - 20, ex.p.height - 220)
    local offset = cc.p(cur_content_size.width - last_content_size.width, cur_content_size.height - last_content_size.height)

    self:setContentSize(cur_content_size)

    local scale_x = ex.p.width / self.spr_bg:getContentSize().width
    local scale_y = ex.p.height / self.spr_bg:getContentSize().height
    local scale_bg = scale_x > scale_y and scale_x or scale_y
    self.spr_bg:setScale(scale_bg)
    if scale_x / scale_y > 720 / 1280 then
        self.spr_bg:setScaleY(scale_y)
    end
    self.spr_bg:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)
    local notch_height = require("src.model.Game"):instance():getNotchHeight()
    self.btn_back:setPosition(self:getContentSize().width / 2 + ex.p.width / 2 / self:getScaleX() - 20 / self:getScaleX() - 60,
                              self:getContentSize().height / 2 + ex.p.height / 2 / self:getScaleY() - 100 / self:getScaleY() - 42 - notch_height)

    self.btn_info:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width / 2 - self.btn_info:getContentSize().width / 2, 
                              self.btn_back:getPositionY() - 60)
    self.btn_reward:setPosition(self.btn_back:getPositionX() + self.btn_back:getContentSize().width / 2 - self.btn_reward:getContentSize().width / 2, 
                                self.btn_back:getPositionY() - 130)

    self:reorderChild(self.node_clan_name, 100)
    self:reorderChild(self.node_center, 100)
    self:reorderChild(self.node_result, 100)
    self:reorderChild(self.node_battle_effect, 200)
    self:reorderChild(self.node_lineup, 100)
    self:reorderChild(self.node_bottom, 100)
    self:reorderChild(self.node_lineup_tip, 200)

    self:reorderChild(self.menu, 20)

    self:reorderChild(self.menu_tower, 10)
    self.menu_tower:setPosition(self:getContentSize().width / 2 - ex.p.cx, self:getContentSize().height / 2 - ex.p.cy * self.spr_bg:getScaleY())
    self.node_battle_effect:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2)

    self.btn_tower_2_2:setTag(999)

    local vec_pos = {}
    local scale_x = self.spr_bg:getScaleX()
    local scale_y = self.spr_bg:getScaleY()
    table.insert(vec_pos, cc.p(120 * scale_x, 900 * scale_y))
    table.insert(vec_pos, cc.p(320 * scale_x, 1000 * scale_y))
    table.insert(vec_pos, cc.p(510 * scale_x, 900 * scale_y))
    table.insert(vec_pos, cc.p(120 * scale_x, 400 * scale_y))
    table.insert(vec_pos, cc.p(320 * scale_x, 290 * scale_y))
    table.insert(vec_pos, cc.p(510 * scale_x, 400 * scale_y))
    for i=1,2 do
        for j=1,3 do
            local btn_tower = self["btn_tower_"..i.."_"..j]
            btn_tower:setName(tostring(j))
            btn_tower:setPosition(vec_pos[(i - 1) * 3 + j])
        end
    end

    self.node_clan_name:setPosition(self:getContentSize().width / 2, self.btn_tower_1_2:getPositionY() + self.menu_tower:getPositionY() + 160)
    self.node_lineup:setPosition(self:getContentSize().width / 2, self.btn_tower_2_2:getPositionY() + self.menu_tower:getPositionY() - 130)
    self.node_lineup_tip:setPosition(self:getContentSize().width / 2, self.btn_tower_2_2:getPositionY() + self.menu_tower:getPositionY() - 30)

    self.node_center:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2 + 50)
    self.node_result:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2 + 50)

    self.lbl_tip_bottom:setString(ex.Tools:getLang(70104).."\n"..ex.Tools:getLang(70105))
    self.lbl_lineup_hero_tip:setString(ex.Tools:getLang(70108))

    -- 添加三线塔各自的人数进度条显示
    for i=1,6 do
        local item = self["btn_tower_"..(math.floor((i - 1) / 3) + 1).."_"..((i - 1) % 3 + 1)]
        item:setEnableAction(false)
        item:setTag((math.floor((i - 1) / 3) + 1) * 100 + ((i - 1) % 3 + 1))

        item.spr_self = cc.Sprite:createWithSpriteFrameName("backpack/spr-selected.png")
        item.spr_self:setPosition(item:getContentSize().width / 2, item:getContentSize().height / 4 + 5)
        item:addChild(item.spr_self, 30)
        item.spr_self:setVisible(false)

        item.spr_icon = cc.Sprite:createWithSpriteFrameName("clan-gvg/spr-person.png")
        item.spr_icon:setPosition(item:getContentSize().width / 2 - 40, item:getContentSize().height * 2 / 4 + 5)
        item:addChild(item.spr_icon, 30)

        if math.floor((i - 1) % 3 % 2) == 0 then
            item.spr_icon:setPositionY(item:getContentSize().height * 3 / 4 + 5)
        end

        item.spr_progress_bg = cc.Sprite:createWithSpriteFrameName("clan-gvg/progress-person-bg.png")
        item.spr_progress_bg:setPosition(item:getContentSize().width / 2 + 10, item:getContentSize().height * 2 / 4)
        item:addChild(item.spr_progress_bg, 10)

		-- 进度条
    	item.progress_person = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("clan-gvg/progress-person.png"))
    	:setType(cc.PROGRESS_TIMER_TYPE_BAR)
        :setPosition(item.spr_progress_bg:getPosition())
    	:setMidpoint(cc.p(0, 0.5))
    	:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
    	item:addChild(item.progress_person, 20)

        item.progress_person:setPercentage(100)

        -- 文字
        item.lbl_person = cc.Label:createWithTTF("99", FONT_DEFAULT_NAME_BOLD, 42)
        :enableOutline(FONT_BLACK, 1)
        :setScale(0.5)
        :setPosition(item.spr_progress_bg:getPositionX(), item.spr_progress_bg:getPositionY() + 5)
        item:addChild(item.lbl_person, 40)
        
        if i == 1 or i == 3 or i == 4 or i == 6 then
            item.spr_self:setPositionY(60)
            item.spr_icon:setPositionY(105)
            item.spr_progress_bg:setPositionY(100)
            item.progress_person:setPositionY(100)
            item.lbl_person:setPositionY(105)
        end
    end

    self:initDone()
end

function ClanGvgLayer:initDone()
    self:registerEvent()

    self:addRedDotNode(RedDotType.ZCJ_DHGH_ZCGHZAN_GHZ_ZGBX, self.btn_reward)
    self:addRedDotNode(RedDotType.ZCJ_DHGH_ZCGHZAN_GHZ_BM, self.btn_lineup)
end

-- 层切入时会被调用
function ClanGvgLayer:changeLayerIn()
    self:updateLayer()
    
    NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
end

function ClanGvgLayer:changeLayerOutEnd()
    ex.EventManager:fire(EVENT.BATTLE_EVENT.CHANGE_LAYER, self, false)
end

function ClanGvgLayer:registerEvent()
   self:addEvent(EVENT.CLAN_EVENT.CLAN_GVG_INFO, handler(self, self.updateLayer))
   self:addEvent(EVENT.CLAN_EVENT.CLAN_GVG_ON_BATTLE, handler(self, self.onBattle))
end

-- 是否匹配到公会
function ClanGvgLayer:isMatchClan()
    local gvg_info = ex.Player.clan_data.clan_gvg_info
    local now = ex.Game:getServerTime()
    if gvg_info.round_start_time > now or gvg_info.round_end_time < now then
        return false
    end

    if table.nums(gvg_info.war_infos) <= 1 then
        return false
    end

    return true
end

-- 是否活动开始并参与进入战斗流程
function ClanGvgLayer:isBattleStart()
    local gvg_info = ex.Player.clan_data.clan_gvg_info
    local now = ex.Game:getServerTime()
    return gvg_info.round_start_time < now and gvg_info.round_end_time > now and gvg_info.stage ~= ClanGvgStageType.ST_MATCH and self:isMatchClan()
end

function ClanGvgLayer:updateLayer()
    local gvg_info = ex.Player.clan_data.clan_gvg_info
    local now = ex.Game:getServerTime()
    local flag = not self:isBattleStart()

    -- 更新活动时间显示
    self.node_center:setVisible(flag or (gvg_info.stage ~= ClanGvgStageType.ST_BATTLE and gvg_info.stage ~= ClanGvgStageType.ST_FINISHED))
    self.node_clan_name:setVisible(not flag)
    self.node_result:setVisible((not flag) and (gvg_info.stage == ClanGvgStageType.ST_FINISHED))
    self.node_bottom:setVisible((not flag) and (gvg_info.stage == ClanGvgStageType.ST_LINEUP_HERO or gvg_info.stage == ClanGvgStageType.ST_LINEUP_MEMBER))
    self.node_lineup:setVisible((not flag) and (gvg_info.stage == ClanGvgStageType.ST_LINEUP_HERO))
    self.node_lineup_tip:setVisible((not flag) and (gvg_info.stage == ClanGvgStageType.ST_LINEUP_HERO or gvg_info.stage == ClanGvgStageType.ST_LINEUP_MEMBER))

    local str_clan_name_enermy = ""
    for i,v in ipairs(gvg_info.war_infos) do
        if v.clan_id ~= ex.Player.clan_data.clan_id then
            str_clan_name_enermy = ex.StringUtil.getServerName(v.server_id)..v.name
        end
    end
    self.lbl_clan_name:setString(str_clan_name_enermy)

    self.node_bottom:setPosition(140, 60)

    if gvg_info.round_start_time > now or gvg_info.round_end_time < now then
    elseif gvg_info.stage == ClanGvgStageType.ST_MATCH then
    elseif not self:isMatchClan() then
    elseif gvg_info.stage == ClanGvgStageType.ST_LINEUP_HERO then
        self.node_bottom:setPosition(self:getContentSize().width / 2, self:getContentSize().height / 2 - 60)
    elseif gvg_info.stage == ClanGvgStageType.ST_LINEUP_MEMBER then
    elseif gvg_info.stage == ClanGvgStageType.ST_FINISHED then
        -- self.spr_gvg_result:setSpriteFrame((gvg_info.is_win == 1 and "clan-gvg-lang/spr-result-win.png" or "clan-gvg-lang/spr-result-fail.png"))
        ex.Tools:setSpriteFrame(self.spr_gvg_result, (gvg_info.is_win == 1 and "clan-gvg-lang/spr-result-win.png" or "clan-gvg-lang/spr-result-fail.png"))
    end

    self:updateTowerStatue()
    self:updateTowerSmoke()

    if not flag then
        -- 判断是否已经编队，已编队则提示已编队
        local is_lineup = false
        for k,v in pairs(ex.Player.clan_data.clan_gvg_team_list) do
            for i2,v2 in ipairs(v) do
                if v2.rid == ex.Player.role_id then
                    is_lineup = true
                    break
                end
            end
            if is_lineup then
                break
            end
        end
    end

    -- 添加定时器
    self:addTimer("timer_clan_gvg", 1000, handler(self, self.updateTimer), true)

    self:updateTimer()
end

function ClanGvgLayer:updateTimer()
    -- print("ClanGvgLayer:updateTimer")
    local gvg_info = ex.Player.clan_data.clan_gvg_info
    local now = ex.Game:getServerTime()

    -- 如果当前阶段结束，则向服务器请求刷新数据
    if self.last_req_refresh_time == nil then
        self.last_req_refresh_time = 0
    end
    if now - self.last_req_refresh_time > 1 then
        self.last_req_refresh_time = now
        if ex.Player.clan_data.clan_gvg_info.next_stage_time <= now then
            NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
        end
    end

    if gvg_info.round_start_time > now or gvg_info.round_end_time < now then
        local left_time = gvg_info.first_round_time - now
        if left_time <= 0 then
            self.lbl_tip_center:setString(ex.Tools:getLang(70101).."\n"..ex.Tools:getLang(70102))
        else
            local h = math.floor(left_time / 3600)
            local m = math.floor((left_time - h * 3600) / 60)
            local s = math.floor(left_time - h * 3600 - m * 60)
            self.lbl_tip_center:setString(string.format(ex.Tools:getLang(70157), string.format("%02d:%02d:%02d", h, m, s)))
        end
    elseif gvg_info.stage == ClanGvgStageType.ST_MATCH then
        self.lbl_tip_center:setString(string.format(ex.Tools:getLang(70103), ex.Tools:getLang(70145), ex.StringUtil.convertToTimeFormat(gvg_info.next_stage_time - now)).."\n"..ex.Tools:getLang(70102))
    elseif not self:isMatchClan() then
        self.lbl_tip_center:setString(ex.Tools:getLang(70151))
    elseif gvg_info.stage == ClanGvgStageType.ST_LINEUP_HERO then
        self.lbl_tip_center:setString(string.format(ex.Tools:getLang(70103), ex.Tools:getLang(70146), ex.StringUtil.convertToTimeFormat(gvg_info.next_stage_time - now)).."\n"..ex.Tools:getLang(70102))
        self.lbl_lineup_tip:setString(ex.Tools:getLang(70109))
    elseif gvg_info.stage == ClanGvgStageType.ST_LINEUP_MEMBER then
        self.lbl_tip_center:setString(string.format(ex.Tools:getLang(70103), ex.Tools:getLang(70147), ex.StringUtil.convertToTimeFormat(gvg_info.next_stage_time - now)).."\n"..ex.Tools:getLang(70102))
        self.lbl_lineup_tip:setString(ex.Tools:getLang(70111))
    end
end

-- 更新塔的状态
function ClanGvgLayer:updateTowerStatue()
    local gvg_info = ex.Player.clan_data.clan_gvg_info
    local flag = self:isBattleStart()
    -- 如果是结算阶段和战斗状态时塔损毁了，则显示损毁状态，否则为正常状态
    if flag and 
        (gvg_info.stage == ClanGvgStageType.ST_LINEUP_HERO or 
        gvg_info.stage == ClanGvgStageType.ST_LINEUP_MEMBER or 
        gvg_info.stage == ClanGvgStageType.ST_BATTLE or 
        gvg_info.stage == ClanGvgStageType.ST_FINISHED) then

        for i = 1, 3 do
            local team_alive_self = 0
            local team_total_self = 0
            local team_alive_enermy = 0
            local team_total_enermy = 0
            for i2,v in ipairs(gvg_info.war_infos) do
                local team_road = v.roads[i]
                if team_road ~= nil then
                    if v.clan_id == ex.Player.clan_data.clan_id then
                        team_alive_self = team_road.alive
                        team_total_self = team_road.total
                    else
                        team_alive_enermy = team_road.alive
                        team_total_enermy = team_road.total
                    end
                end
            end

            -- 确定自己是否在此路
            local is_in_road = false
            local team_road = ex.Player.clan_data.clan_gvg_team_list[i]
            if team_road ~= nil then
                for i2,v2 in ipairs(team_road) do
                    if v2.rid == ex.Player.role_id then
                        is_in_road = true
                        break
                    end
                end
            end

            -- 更新己方塔状态
            local item_tower_self = self["btn_tower_2_"..i]
            local item_tower_enermy = self["btn_tower_1_"..i]
            if team_alive_self <= 0 and team_alive_enermy > 0 then
                item_tower_self:setNormalImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-broken-2-"..i..".png"))
                item_tower_self:setSelectedImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-broken-2-"..i..".png"))
                item_tower_self:removeChildByTag(800)
            else
                item_tower_self:setNormalImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-2-"..i..".png"))
                item_tower_self:setSelectedImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-2-"..i..".png"))

                if i == 1 or i == 3 then
                    local spr_effect = item_tower_self:getChildByTag(800)
                    if spr_effect == nil then
                        spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_clan_gvg_tower")
                        spr_effect:setScale(1.3)
                        spr_effect:setPosition(item_tower_self:getContentSize().width / 2, 70)
                        spr_effect:setTag(800)
                        item_tower_self:addChild(spr_effect, 1)
                    end
                end
            end
            item_tower_self.spr_progress_bg:setVisible(true)
            item_tower_self.progress_person:setVisible(true)
            item_tower_self.spr_icon:setVisible(true)
            item_tower_self.lbl_person:setVisible(true)
            item_tower_self.spr_self:setVisible(is_in_road)

            item_tower_self.lbl_person:setString(string.format("%d/%d", team_alive_self, team_total_self))
            if team_total_self > 0 then
                item_tower_self.progress_person:setPercentage(team_alive_self * 100 / team_total_self)
            elseif (gvg_info.stage == ClanGvgStageType.ST_BATTLE or 
                    gvg_info.stage == ClanGvgStageType.ST_FINISHED) and
                    team_alive_enermy > 0 then
                item_tower_self.progress_person:setPercentage(0)
            else
                item_tower_self.progress_person:setPercentage(100)
            end

            -- 更新敌方塔状态
            if gvg_info.stage == ClanGvgStageType.ST_BATTLE or 
                gvg_info.stage == ClanGvgStageType.ST_FINISHED then
                if team_alive_self > 0 and team_alive_enermy <= 0 then
                    item_tower_enermy:setNormalImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-broken-1-"..i..".png"))
                    item_tower_enermy:setSelectedImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-broken-1-"..i..".png"))
                    item_tower_enermy:removeChildByTag(800)
                else
                    item_tower_enermy:setNormalImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-1-"..i..".png"))
                    item_tower_enermy:setSelectedImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-1-"..i..".png"))

                    if i == 1 or i == 3 then
                        local spr_effect = item_tower_enermy:getChildByTag(800)
                        if spr_effect == nil then
                            spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_clan_gvg_tower")
                            spr_effect:setScale(1.3)
                            spr_effect:setPosition(item_tower_enermy:getContentSize().width / 2, 70)
                            spr_effect:setTag(800)
                            item_tower_enermy:addChild(spr_effect, 1)
                        end
                    end
                end

                item_tower_enermy.spr_progress_bg:setVisible(true)
                item_tower_enermy.progress_person:setVisible(true)
                item_tower_enermy.spr_icon:setVisible(true)
                item_tower_enermy.lbl_person:setVisible(true)

                item_tower_enermy.lbl_person:setString(string.format("%d/%d", team_alive_enermy, team_total_enermy))
                if team_total_enermy > 0 then
                    item_tower_enermy.progress_person:setPercentage(team_alive_enermy * 100 / team_total_enermy)
                else
                    item_tower_enermy.progress_person:setPercentage(team_total_self <= 0 and 100 or 0)
                end
            else
                item_tower_enermy:setNormalImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-1-"..i..".png"))
                item_tower_enermy:setSelectedImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-1-"..i..".png"))

                if i == 1 or i == 3 then
                    local spr_effect = item_tower_enermy:getChildByTag(800)
                    if spr_effect == nil then
                        spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_clan_gvg_tower")
                        spr_effect:setScale(1.3)
                        spr_effect:setPosition(item_tower_enermy:getContentSize().width / 2, 70)
                        spr_effect:setTag(800)
                        item_tower_enermy:addChild(spr_effect, 1)
                    end
                end

                item_tower_enermy.spr_progress_bg:setVisible(false)
                item_tower_enermy.progress_person:setVisible(false)
                item_tower_enermy.spr_icon:setVisible(false)
                item_tower_enermy.lbl_person:setVisible(false)
            end

            -- 刷新所有塔的子组件位置
            item_tower_self.spr_icon:setPosition(item_tower_self:getContentSize().width / 2 - 40, item_tower_self:getContentSize().height * 2 / 4 + 5)
            item_tower_self.spr_progress_bg:setPosition(item_tower_self:getContentSize().width / 2 + 10, item_tower_self:getContentSize().height * 2 / 4)
            item_tower_self.progress_person:setPosition(item_tower_self.spr_progress_bg:getPosition())
            item_tower_self.lbl_person:setPosition(item_tower_self.spr_progress_bg:getPositionX(), item_tower_self.spr_progress_bg:getPositionY() + 5)
            item_tower_self.spr_self:setPosition(item_tower_self:getContentSize().width / 2, item_tower_self.spr_progress_bg:getPositionY() - 30)

            item_tower_enermy.spr_icon:setPosition(item_tower_enermy:getContentSize().width / 2 - 40, item_tower_enermy:getContentSize().height * 2 / 4 + 5)
            item_tower_enermy.spr_progress_bg:setPosition(item_tower_enermy:getContentSize().width / 2 + 10, item_tower_enermy:getContentSize().height * 2 / 4)
            item_tower_enermy.progress_person:setPosition(item_tower_enermy.spr_progress_bg:getPosition())
            item_tower_enermy.lbl_person:setPosition(item_tower_enermy.spr_progress_bg:getPositionX(), item_tower_enermy.spr_progress_bg:getPositionY() + 5)

            if i == 1 or i == 3 then
                item_tower_self.spr_self:setPositionY(60)
                item_tower_self.spr_icon:setPositionY(105)
                item_tower_self.spr_progress_bg:setPositionY(100)
                item_tower_self.progress_person:setPositionY(100)
                item_tower_self.lbl_person:setPositionY(105)

                item_tower_enermy.spr_self:setPositionY(60)
                item_tower_enermy.spr_icon:setPositionY(105)
                item_tower_enermy.spr_progress_bg:setPositionY(100)
                item_tower_enermy.progress_person:setPositionY(100)
                item_tower_enermy.lbl_person:setPositionY(105)
            end
        end
    else
        for i=1,6 do
            local m = math.floor((i - 1) / 3) + 1
            local n = ((i - 1) % 3 + 1)
            local item_tower = self["btn_tower_"..m.."_"..n]

            item_tower:setNormalImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-"..m.."-"..n..".png"))
            item_tower:setSelectedImage(cc.Sprite:createWithSpriteFrameName("clan-gvg/clan-gvg-tower-"..m.."-"..n..".png"))
      
            if i == 1 or i == 3 or i == 4 or i == 6 then
                local spr_effect = item_tower:getChildByTag(800)
                if spr_effect == nil then
                    spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_clan_gvg_tower")
                    spr_effect:setScale(1.3)
                    spr_effect:setPosition(item_tower:getContentSize().width / 2, 70)
                    spr_effect:setTag(800)
                    item_tower:addChild(spr_effect, 1)
                end
            end

            item_tower.spr_progress_bg:setVisible(false)
            item_tower.progress_person:setVisible(false)
            item_tower.spr_icon:setVisible(false)
            item_tower.lbl_person:setVisible(false)
        end
    end
end

-- 更新战斗烟雾效果
function ClanGvgLayer:updateTowerSmoke()
    local gvg_info = ex.Player.clan_data.clan_gvg_info
    local flag = self:isBattleStart()
    -- 如果是结算阶段和战斗状态时塔损毁了，则显示损毁状态，否则为正常状态
    if flag and 
        (gvg_info.stage == ClanGvgStageType.ST_LINEUP_HERO or 
        gvg_info.stage == ClanGvgStageType.ST_LINEUP_MEMBER or 
        gvg_info.stage == ClanGvgStageType.ST_BATTLE or 
        gvg_info.stage == ClanGvgStageType.ST_FINISHED) then
        for i = 1, 3 do
            local team_alive_self = 0
            local team_total_self = 0
            local team_alive_enermy = 0
            local team_total_enermy = 0
            for i2,v in ipairs(gvg_info.war_infos) do
                local team_road = v.roads[i]
                if team_road ~= nil then
                    if v.clan_id == ex.Player.clan_data.clan_id then
                        team_alive_self = team_road.alive
                        team_total_self = team_road.total
                    else
                        team_alive_enermy = team_road.alive
                        team_total_enermy = team_road.total
                    end
                end
            end

            -- 更新对应路线的战斗烟雾
            if gvg_info.stage == ClanGvgStageType.ST_BATTLE and team_alive_self > 0 and team_alive_enermy > 0 then
                local spr_effect = self.node_battle_effect:getChildByTag(990 + i)
                if spr_effect == nil then
                    spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_clan_gvg_battle")
                    spr_effect:setScale(1.5)
                    spr_effect:setPosition((i - 2) * 200, 0)
                    spr_effect:setTag(990 + i)
                    self.node_battle_effect:addChild(spr_effect, 0)
                end
                -- 根据存活队伍数量来算位置
                local tower_offset = self["btn_tower_1_"..i]:getPositionY() - self["btn_tower_2_"..i]:getPositionY()
                spr_effect:setPositionY(tower_offset * (team_alive_self / (team_alive_self + team_alive_enermy) - 0.5) + 50)
            else
                self.node_battle_effect:removeChildByTag(990 + i)
            end
        end
    else

    end

    if not flag or gvg_info.stage ~= ClanGvgStageType.ST_BATTLE then
        self.node_battle_effect:removeAllChildren()
    end
end

-- 点击界面的塔，如果是己方的塔，并且时间正确，则显示界面，否则显示提示
-- 如果是布阵阶段，则点击进入调整阵容界面，如果是战斗阶段，则点击进入战况界面
function ClanGvgLayer:onTower(tag, pSender)
    if not self:isBattleStart() then
        return
    end

    local gvg_info = ex.Player.clan_data.clan_gvg_info
    local now = ex.Game:getServerTime()
    if gvg_info.round_start_time > now then
        ex.MessageView:add(ex.Tools:getLang(70139))
        return
    elseif gvg_info.round_end_time < now then
        ex.MessageView:add(ex.Tools:getLang(70140))
        return
    end

    if gvg_info.stage == ClanGvgStageType.ST_LINEUP_HERO then
        if math.floor(tag / 100) <= 1 then
            ex.MessageView:add(ex.Tools:getLang(70153))
            return
        end
        -- 备战阶段，可以打开调整阵容路线，但是只能调整自己的
        require("src.layer.clan.ClanGvgLineupMemberCtr"):instance():openWindow(2)
    elseif gvg_info.stage == ClanGvgStageType.ST_LINEUP_MEMBER then
        if math.floor(tag / 100) <= 1 then
            ex.MessageView:add(ex.Tools:getLang(70153))
            return
        end
        -- 调整阶段，可以打开调整阵容路线，但是只有会长拥有调整权限
        -- 判断是否为会长，是则打开界面，否则弹出提示
        local self_data = ex.Player.clan_data:getMemberByRoleId(ex.Player.role_id)
        if self_data == nil then
            return
        end
        if self_data.position == ClanPositionType.HEAD or self_data.position == ClanPositionType.VICE_HEAD then
            require("src.layer.clan.ClanGvgLineupMemberCtr"):instance():openWindow(1)
        else
            require("src.layer.clan.ClanGvgLineupMemberCtr"):instance():openWindow(3)
        end
    elseif (gvg_info.stage == ClanGvgStageType.ST_BATTLE or gvg_info.stage == ClanGvgStageType.ST_FINISHED) then
        -- 开战和休战阶段，可以打开对应路线公会战历史
        require("src.layer.clan.ClanGvgHistoryCtr"):instance():openWindow(tonumber(pSender:getName()))
    else
        dump(gvg_info, "ClanGvgLayer:onTower "..now)
    end
end

function ClanGvgLayer:onBack()
    ex.MainSceneCtr:changeLayer(MainSceneType.CLAN)
end

function ClanGvgLayer:onInfo()
    ex.InfoCtr:openWindow(ex.Tools:getLang(42040), ex.Tools:getLang(42041))
end

-- 打开公会战奖励界面
function ClanGvgLayer:onReward()
    -- 判断阶段，如果非备战阶段，则不需打开
    local now = ex.Game:getServerTime()
    if ex.Player.clan_data.clan_gvg_info.round_start_time > now then
        ex.MessageView:add(ex.Tools:getLang(70139))
        return
    elseif ex.Player.clan_data.clan_gvg_info.round_end_time < now then
        ex.MessageView:add(ex.Tools:getLang(70140))
        return
    end
    if ex.Player.clan_data.clan_gvg_info.stage ~= ClanGvgStageType.ST_FINISHED or ex.Player.clan_data.clan_gvg_info.next_stage_time < now then
        -- 只有结算阶段才能打开领奖界面
        ex.MessageView:add(ex.Tools:getLang(70156))
        return
    end

    require("src.layer.clan.ClanGvgRewardCtr"):instance():openWindow()
end

-- 打开布阵界面
function ClanGvgLayer:onLineup()
    if not self:isBattleStart() then
        return
    end

    -- 判断阶段，如果非备战阶段，则不需打开
    local now = ex.Game:getServerTime()
    if ex.Player.clan_data.clan_gvg_info.round_start_time > now then
        ex.MessageView:add(ex.Tools:getLang(70139))
        return
    elseif ex.Player.clan_data.clan_gvg_info.round_end_time < now then
        ex.MessageView:add(ex.Tools:getLang(70140))
        return
    end
    if ex.Player.clan_data.clan_gvg_info.stage ~= ClanGvgStageType.ST_LINEUP_HERO or ex.Player.clan_data.clan_gvg_info.next_stage_time < now then
        -- 只有在备战阶段才可以编队
        ex.MessageView:add(ex.Tools:getLang(70142))
        return
    end

    -- 判断是否已经编队，已编队则编队界面默认选中已编队路线，并找到队列成员最少的路线作为默认路线
    local select_road = 1
    local road_team_count = 99
    for i=1,3 do
        local road_data = ex.Player.clan_data.clan_gvg_team_list[4 - i]
        if road_data ~= nil then
            if road_team_count >= table.nums(road_data) then
                road_team_count = table.nums(road_data)
                select_road = 4 - i
            end

            local is_lineup = false
            for i2,v2 in ipairs(road_data) do
                if v2.rid == ex.Player.role_id then
                    select_road = 4 - i
                    is_lineup = true
                    break
                end
            end
            if is_lineup then break end
        else
            road_team_count = 0
            select_road = 4 - i
        end
    end

    require('src.layer.HeroSelectCtr'):instance():openWindow(ex.Tools:getLang(47546),
                                                             ex.Tools:getLang(47396),
                                                             BattleType.CLAN_GVG,
                                                             handler(self, self.onLineupDone))
    require("src.layer.HeroSelectCtr"):instance():showRoadSelect(select_road)
end

-- 布阵完成后的回调
function ClanGvgLayer:onLineupDone(vec_battle, fetter_type, road)
    -- 判断阶段，如果非备战阶段，则不需打开
    -- local now = ex.Game:getServerTime()
    -- if ex.Player.clan_data.clan_gvg_info.stage ~= ClanGvgStageType.ST_LINEUP_HERO or ex.Player.clan_data.clan_gvg_info.next_stage_time < now then
    --     -- 只有在备战阶段才可以编队
    --     ex.MessageView:add(ex.Tools:getLang(70142))
    --     return
    -- end

    if road == nil then
        road = 1
    end

    local req_lineup = ClanWar_pb.GReqSaveRoadFormation()
    req_lineup.road = road
    NetManager:sendMessage(ProtocolID.GReqSaveRoadFormation, req_lineup)
end

-- -- 打开调整队列界面
-- function ClanGvgLayer:onLineupMember()
--     require("src.layer.clan.ClanGvgLineupMemberCtr"):instance():openWindow()
-- end

function ClanGvgLayer:onBattle(event, battle_id) 
    local req_battle = Battle_pb.GReqBattleReport()
    req_battle.battle_id = battle_id
    req_battle.type = EVENT.CLAN_EVENT.CLAN_GVG_BATTLE
    NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    local battle_layer = self:addBattleLayer(BattleType.CLAN_GVG,
                                            MainSceneType.CLAN_GVG,
                                            "map_clanwar",
                                            EVENT.CLAN_EVENT.CLAN_GVG_BATTLE,
                                            function(battle_layer, report_data, vec_ward, ext)
                                                -- local is_win = false
                                                -- for i,v in ipairs(ex.Player.clan_data.clan_gvg_cur_history_list) do
                                                --     if v.clan_id == ex.Player.clan_data.clan_id then
                                                --         for i2,v2 in ipairs(v.team) do
                                                --             if v2.rid == ext.report.win_id then
                                                --                 is_win = true
                                                --                 break
                                                --             end
                                                --         end
                                                --         break
                                                --     end
                                                -- end
                                                -- if is_win == false then
                                                --     for i,v in ipairs(ex.Player.clan_data.clan_gvg_history_list) do
                                                --         for i2,v2 in ipairs(v.players) do
                                                --             if v2.clan_id == ex.Player.clan_data.clan_id and v2.rid == ext.report.win_id then
                                                --                 is_win = true
                                                --                 break
                                                --             end
                                                --         end
                                                --     end
                                                -- end

                                                -- self:runBattleEndAction(is_win)

                                                return true, false
                                            end)
    battle_layer:showCloseBtn(true)
    battle_layer:setScale(1.0 / self:getParent():getScale())
    battle_layer:setPosition(self:getContentSize().width * 0.5  / battle_layer:getScale() - ex.p.width  * 0.5,
                            self:getContentSize().height * 0.5 / battle_layer:getScale() - ex.p.height * 0.5)
end

function ClanGvgLayer:runBattleEndAction(is_win)
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/battle-end-1.plist")

    local result = 0
    if is_win == true then
        result = 1
    end

    local spr_result_bg = cc.Sprite:createWithSpriteFrameName("battle-end/spr-wing-"..result..".png")
    spr_result_bg.spr_result = cc.Sprite:createWithSpriteFrameName("battle-end-lang/lbl-result-"..result..".png")
    spr_result_bg.spr_result:setPosition(spr_result_bg:getContentSize().width / 2, spr_result_bg:getContentSize().height / 2)
    spr_result_bg:addChild(spr_result_bg.spr_result)
    spr_result_bg:setPosition(ex.p.cx, ex.p.height * 0.6)
    self:addChild(spr_result_bg, 10000)

    spr_result_bg:runAction(cc.Sequence:create(cc.FadeIn:create(0.3), cc.DelayTime:create(0.7), cc.FadeOut:create(0.5), cc.RemoveSelf:create(), nil))
    spr_result_bg.spr_result:runAction(cc.Sequence:create(cc.FadeIn:create(0.3), cc.DelayTime:create(0.7), cc.FadeOut:create(0.5), nil))

    if is_win == true then
        local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_battle_end")
        spr_effect:setPosition(spr_result_bg:getContentSize().width / 2, spr_result_bg:getContentSize().height / 2)
        spr_result_bg:addChild(spr_effect)
    end
end

return ClanGvgLayer
