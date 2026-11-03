local CrusadeGroupTileInfoLayer = class("CrusadeGroupTileInfoLayer", require("src.comp.EventLayer"))

function CrusadeGroupTileInfoLayer:onCreate()
    -- 当前处于哪一个格子
    self.showTilePosition = cc.p(-1, -1)
    self.tileSize = cc.size(0, 0)
    self.can_attack = false

    self.func_info = handler(self, self.onInfo)
    self.func_mark = handler(self, self.onMark)
    self.func_attack = handler(self, self.onAttack)

    self.guard_time = 0

    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0.5, 140 / self:getContentSize().height)

    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_MARK, handler(self, self.updateLayer))

    self:addEvent(EVENT.CRUSADE_GROUP.UPDATE_TOWN_BATTLE_INFO, handler(self, self.updateMosterNum))

    self:addEvent(EVENT.CRUSADE_GROUP.BATTLE_UPDATE_TIME, handler(self, self.updateShowTime))

    -- ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_TOWN_BATTLE_INFO, data)

end

function CrusadeGroupTileInfoLayer:setCanAttack(can_attack)
    self.can_attack = can_attack
end

function CrusadeGroupTileInfoLayer:setTileSize(size)
    self.tileSize = size
end

function CrusadeGroupTileInfoLayer:getTileId(pos)
    return pos.x + pos.y * self.tileSize.width + 1
end

function CrusadeGroupTileInfoLayer:isShow(x, y)
    if self.showTilePosition.x == x and self.showTilePosition.y == y then
        return false
    end
    return true
end

function CrusadeGroupTileInfoLayer:setShowTilePosition(x, y)
    self.showTilePosition.x = x
    self.showTilePosition.y = y
end

function CrusadeGroupTileInfoLayer:getShowTilePosition()
    return self.showTilePosition
end

function CrusadeGroupTileInfoLayer:updateCDTime( )
    local nowTime = ex.Game:getServerTime()
	self.protectTime:setString(string.format(ex.Tools:getLang(77961), ex.StringUtil.convertToTimeFormat(self.guard_time - nowTime)))
	if self.guard_time <= nowTime then 
        self:removeTimerByName("timer")
        self.protectTime:setString(" ")
        self.guard_time = 0
	end
end

function CrusadeGroupTileInfoLayer:setTimeNumShowFasle(  )
    self.protectTime:setString("")
end

function CrusadeGroupTileInfoLayer:updateShowTime(event, data)
    self.protectTime:setString("")
    local idx = self:getTileId(cc.p(self.showTilePosition.x, self.showTilePosition.y))
    if idx ~= data.territory_id then
        return
    end
    local nowTime = ex.Game:getServerTime()
    self.guard_time = data.guard_time
    if self.guard_time > nowTime then
        self:removeTimerByName("timer")
        self:addTimer("timer", 1000, handler(self, self.updateCDTime), true)
        self:updateCDTime()
    else
        self:removeTimerByName("timer")
    end
end

function CrusadeGroupTileInfoLayer:updateMosterNum(event, data)
    self.protectTime:setString("")
    local idx = self:getTileId(cc.p(self.showTilePosition.x, self.showTilePosition.y))
    if idx ~= data.territory_id then
        return
    end
    
    self.guard_time = data.guard_time
    local nowTime = ex.Game:getServerTime()
    if self.guard_time > nowTime and (ex.Player.nick == data.challenger_name) then
        self:removeTimerByName("timer")
        self:addTimer("timer", 1000, handler(self, self.updateCDTime), true)
        self:updateCDTime()
    else
        self:removeTimerByName("timer")
    end

    local moster_num = 0

    for i,v in ipairs(data.formation) do
        for i,v in ipairs(v.hero) do
            if v.hp > 0 then
                moster_num = moster_num + 1
                break
            end
        end
    end
    
    self.lbl_monster_num:setString(moster_num)
end

function CrusadeGroupTileInfoLayer:updateLayer()
    local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/crusade-group.plist")
    

    self.lbl_tile:setString(string.format("（%d,%d）", self.showTilePosition.x, self.showTilePosition.y))
    local idx = self:getTileId(cc.p(self.showTilePosition.x, self.showTilePosition.y))
    local tile_data = ctr.crusade_group.data:getMapDataByPos(self.showTilePosition.x, self.showTilePosition.y)
    local fight_type = cfg.crusadegrouptilelevel.getFightType(idx)

    local build_config = cfg.crusadegroupbuild.getConfig(idx)

    local is_open = tile_data == nil
    local is_self_tile = tile_data ~= nil and tile_data.occupied_id == ex.Player.role_id
    local is_farm = is_self_tile and build_config and build_config.defend_is == 1
    local is_farming = is_farm and tile_data.hero_id <= 0
    local is_belong = tile_data ~= nil
    local is_mark = ctr.crusade_group.data:isMark(idx)
    local is_can_attack = tile_data == nil or (tile_data.occupied_id <= 0 and fight_type >= 1)

    -- 155.0, 125.0

    local vec_btn = {
        {text="", img = "", func = self.func_info, v = true},
        {text="", img = "", func = self.func_mark, v = true},
        {text="", img = "", func = self.func_attack, v = true},
    }

    if is_self_tile then
        local is_giveuping = ctr.crusade_group.data.map_giveup[idx]
        if is_giveuping then
            vec_btn[1].text = ex.Tools:getLang(77629)
            vec_btn[1].img = "crusade-group/btn-giveup-2.png"
            vec_btn[1].func = handler(self, self.onQuickGiveup)

            vec_btn[2].text = is_mark and ex.Tools:getLang(77611) or ex.Tools:getLang(77610)
            vec_btn[2].img = string.format("crusade-group/btn-mark-%d.png", is_mark and 1 or 2) 
            vec_btn[2].func = self.func_mark

            vec_btn[3].img = "crusade-group/btn-giveup-3.png"
            vec_btn[3].text = ex.Tools:getLang(77630)
            vec_btn[3].func = handler(self, self.onRevoke)
        else
            if is_farm then
                -- 第一个按钮变成开垦
                vec_btn[1].text = ex.Tools:getLang(77613)
                vec_btn[1].img = "crusade-group/btn-farm-2.png"
                
                vec_btn[2].text = is_mark and ex.Tools:getLang(77611) or ex.Tools:getLang(77610)
                vec_btn[2].img = string.format("crusade-group/btn-mark-%d.png", is_mark and 1 or 2) 
                vec_btn[2].func = self.func_mark
            else
                vec_btn[1].text = is_mark and ex.Tools:getLang(77611) or ex.Tools:getLang(77610)
                vec_btn[1].img = string.format("crusade-group/btn-mark-%d.png", is_mark and 1 or 2) 
                vec_btn[1].func = self.func_mark

                vec_btn[2].v = false
            end
        
            vec_btn[3].img = "crusade-group/btn-giveup-2.png"
            vec_btn[3].text = ex.Tools:getLang(77614)
            vec_btn[3].func = handler(self, self.onGiveup)
        end
    elseif is_can_attack then
        -- 查看按钮
        vec_btn[1].text = ex.Tools:getLang(77941)
        vec_btn[1].img = "crusade-group/btn-detail.png"

        -- 隐藏查看按钮，第一个按钮变成标记
        vec_btn[2].text = is_mark and ex.Tools:getLang(77611) or ex.Tools:getLang(77610)
        vec_btn[2].img = string.format("crusade-group/btn-mark-%d.png", is_mark and 1 or 2)
        vec_btn[2].func = self.func_mark

        vec_btn[3].img = "crusade-group/btn-attack.png"
        vec_btn[3].text = ex.Tools:getLang(77612)
        vec_btn[3].func = handler(self, self.onAttack)
    elseif fight_type == 3 then
        -- 查看按钮
        vec_btn[1].text = ex.Tools:getLang(77941)
        vec_btn[1].img = "crusade-group/btn-detail.png"

        -- 隐藏查看按钮，第一个按钮变成标记
        vec_btn[3].text = is_mark and ex.Tools:getLang(77611) or ex.Tools:getLang(77610)
        vec_btn[3].img = string.format("crusade-group/btn-mark-%d.png", is_mark and 1 or 2)
        vec_btn[3].func = self.func_mark

        vec_btn[2].v = false
    else
        -- 隐藏查看按钮，第一个按钮变成标记
        vec_btn[2].text = is_mark and ex.Tools:getLang(77611) or ex.Tools:getLang(77610)
        vec_btn[2].img = string.format("crusade-group/btn-mark-%d.png", is_mark and 1 or 2)
        vec_btn[2].func = self.func_mark

        vec_btn[1].v = false
        vec_btn[3].v = false
    end

    for i,v in ipairs(vec_btn) do
        local btn = self["btn_"..i]
        local lbl = self["lbl_"..i]

        ex.Tools:setSpriteFrame(btn:getNormalImage(), v.img)
        lbl:setString(v.text)

        btn:registerScriptTapHandler(v.func)

        btn:setVisible(v.v)
        lbl:setVisible(v.v)
    end


    -- self.lbl_mark:setString(is_mark and ex.Tools:getLang(77611) or ex.Tools:getLang(77610))
    -- ex.Tools:setSpriteFrame(self.btn_mark:getNormalImage(), string.format("crusade-group/btn-mark-%d.png", is_mark and 1 or 2))

    -- self.btn_info:setVisible(is_open or is_self_tile or is_farm == true)
    -- self.lbl_check:setVisible(self.btn_info:isVisible())

    -- self.btn_battle:setVisible(self.btn_info:isVisible())
    -- self.lbl_battle:setVisible(self.btn_info:isVisible())

    -- self.btn_mark:setVisible(true)
    -- self.lbl_mark:setVisible(true)
    
    -- self.btn_info:setPosition(self.vec_btn_pos[1])
    -- self.btn_battle:setPosition(self.vec_btn_pos[2])
    -- self.btn_mark:setPosition(self.vec_btn_pos[3])


    -- if is_farm then
    --     -- 显示开垦
    --     ex.Tools:setMenuItemFrame(self.btn_info, "crusade-group/btn-farm-2.png")
    --     self.lbl_check:setString(ex.Tools:getLang(77613))
    -- else
    --     ex.Tools:setMenuItemFrame(self.btn_info, "crusade-group/btn-detail.png")
    --     self.lbl_check:setString(ex.Tools:getLang(77941))
    -- end

    -- if is_self_tile then
    --     local is_giveuping = ctr.crusade_group.data.map_giveup[idx]
    --     if is_giveuping then
    --         self.btn_mark:setVisible(false)
    --         self.lbl_mark:setVisible(false)

    --         self.btn_info:setVisible(true)
    --         self.lbl_check:setVisible(true)

    --         self.btn_battle:setVisible(true)
    --         self.lbl_battle:setVisible(true)

    --         self.lbl_check:setString(ex.Tools:getLang(77629))
    --         self.lbl_battle:setString(ex.Tools:getLang(77630))

    --         ex.Tools:setMenuItemFrame(self.btn_info, "crusade-group/btn-giveup-2.png")
    --         ex.Tools:setMenuItemFrame(self.btn_battle, "crusade-group/btn-giveup-3.png")
    --         self.btn_info:registerScriptTapHandler(handler(self, self.onQuickGiveup))
    --         self.btn_battle:registerScriptTapHandler(handler(self, self.onRevoke))
    --     else
    --         ex.Tools:setMenuItemFrame(self.btn_battle, "crusade-group/btn-giveup-2.png")

    --         self.lbl_battle:setString(ex.Tools:getLang(77614))
    --         self.btn_battle:registerScriptTapHandler(handler(self, self.onGiveup))
    --     end
    -- else
    --     self.btn_battle:registerScriptTapHandler(handler(self, self.onAttack))

    --     ex.Tools:setMenuItemFrame(self.btn_battle, "crusade-group/btn-attack.png")
    --     self.lbl_battle:setString(ex.Tools:getLang(77612))
    -- end

    if build_config == nil then
        print("build_config is not found", idx)
        return
    end

    self.lbl_monster_num:setString(build_config.mon_team)
    self.spr_monster_icon:setVisible(is_belong ~= true)
    self.lbl_monster_num:setVisible(is_belong ~= true)
    self.spr_monster_bg:setVisible(is_belong ~= true)
end

-- 瓦片信息
function CrusadeGroupTileInfoLayer:onInfo(tag, pSender)
    -- 如果该瓦片城镇属于自己的领地，则打开自己的领地信息界面，否则访问地块城镇战斗信息界面
    local tile_id = self:getTileId(self.showTilePosition)
    local tile_data = ctr.crusade_group.data.map_data[tile_id]
    
    local fight_type = cfg.crusadegrouptilelevel.getFightType(tile_id)
    if tile_data ~= nil and tonumber(tile_data.occupied_id) > 0 then
        if tonumber(tile_data.occupied_id) == tonumber(ex.Player.role_id) then
            require("src.layer.crusadegroup.CrusadeGroupTownInfoCtr"):instance():openWindow(tile_id)
        else
            -- 不给查看其它玩家领地

        end
    elseif fight_type == 1 then
        local area_level = cfg.crusadegrouptilelevel.getAreaLevel(tile_id)
        local building_level = cfg.crusadegrouptilelevel.getBuildingLevel(tile_id)
        -- 查看敌方城镇
        require("src.layer.crusadegroup.CrusadeGroupTownBattleCtr"):instance():openWindow(tile_id, area_level, building_level, false)
    elseif fight_type == 2 or fight_type == 3 then
        -- 查看boss
        local boss_layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_BOSS_LAYER)
        boss_layer:setCanAttack(false)
        boss_layer:setTileId(tile_id)
    end
end

-- 标记
function CrusadeGroupTileInfoLayer:onMark(tag, pSender)
    -- 标记瓦片，如果已标记则取消标记
    local idx = self:getTileId(self.showTilePosition)
    local is_mark = ctr.crusade_group.data:isMark(idx)
    if is_mark then

        local req = CrusadeGroup_pb.GReqUnmark()
        req.territory_id = idx
        NetManager:sendMessage(ProtocolID.GReqUnmark, req)
    else

        if #ctr.crusade_group.data.game_data.territory_mark >= ex.Tools:getSysCfg("crusade_group_coordinate") then
            ex.MessageView:add(ex.Tools:getLang(77631))
            return
        end

        require("src.layer.crusadegroup.CrusadeGroupMapMarkCtr"):instance():openWindow(idx)

        -- local req = CrusadeGroup_pb.GReqMark()
        -- req.territory_id = idx
        -- NetManager:sendMessage(ProtocolID.GReqMark, req)
    end

    -- ex.EventManager:fire(EVENT.CRUSADE_GROUP.RUN_COLLECT_EFFECT)
    -- ex.EventManager:fire(EVENT.CRUSADE_GROUP.RUN_OCCUPY_EFFECT, 22663)
end



-- 攻击
function CrusadeGroupTileInfoLayer:onAttack(tag, pSender)
    local tile_id = self:getTileId(self.showTilePosition)
    local fight_type = cfg.crusadegrouptilelevel.getFightType(tile_id)

    -- 如果是己方领地则弹出提示
    for i,v in ipairs(ctr.crusade_group.data.game_data.occupied_list) do
        if v.town_id == tile_id then
            ex.MessageView:add(ex.Tools:getLang(77718))
            return
        end
    end

    -- 如果出征英雄数不够，则弹出提示框
    if ctr.crusade_group.data.game_data.set_off_hero_list == nil or #ctr.crusade_group.data.game_data.set_off_hero_list <= 0 then
        ex.ConfirmCtr:openWindow(ex.Tools:getLang(77502), ex.Tools:getLang(77501), function()
            if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER then
                ex.MainSceneCtr:getCurLayer():onHeroList()
            end
        end, ex.Tools:getLang(77502))
        return
    end

    -- 不相鄰的領地無法攻擊
    if not self.can_attack then
        ex.MessageView:add(ex.Tools:getLang(77722))

        ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATA_TILE_SELECT, self.showTilePosition.x, self.showTilePosition.y)
        return
    end

    -- 領地已滿無法攻擊
    local config_occupation = TableEx.findValueFunction(cfg.crusadegroupoccupation.crusadegroupoccupation, function(value)
        return ctr.crusade_group.data.game_data.self_occupation_id == value.id
    end)
    if config_occupation == nil or config_occupation.landNum <= #ctr.crusade_group.data.game_data.occupied_list then
        ex.MessageView:add(ex.Tools:getLang(77749))
        return
    end

    if fight_type == 1 then
        local area_level = cfg.crusadegrouptilelevel.getAreaLevel(tile_id)
        local building_level = cfg.crusadegrouptilelevel.getBuildingLevel(tile_id)
        -- 访问地块城镇战斗信息界面，并显示攻击按钮
        require("src.layer.crusadegroup.CrusadeGroupTownBattleCtr"):instance():openWindow(tile_id, area_level, building_level, true)
    else
        -- 查看boss
        local boss_layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_BOSS_LAYER)
        boss_layer:setCanAttack(true)
        boss_layer:setTileId(tile_id)
    end
end

-- 开垦
function CrusadeGroupTileInfoLayer:onFarm(tag, pSender)
    require("src.layer.crusadegroup.CrusadeGroupTownInfoCtr"):instance():openWindow()
end

-- 放弃
function CrusadeGroupTileInfoLayer:onGiveup(tag, pSender)
    local tile_id = self:getTileId(self.showTilePosition)

    -- 放弃领地，如果正在放弃中，则取消放弃
    ex.ConfirmCtr:openWindow(ex.Tools:getLang(77635), ex.Tools:getLang(77636), function()
        ctr.crusade_group:addGiveupData(tile_id)
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_MARK)
    end, ex.Tools:getLang(77637))
end

-- 分享坐标
function CrusadeGroupTileInfoLayer:onShare(tag, pSender)
    local tile_id = self:getTileId(self.showTilePosition)
    local config_build = cfg.crusadegroupbuild.getConfig(tile_id)

    local str_content = string.format(ex.Tools:getLang(77721), ex.Tools:getLang(config_build.name), "("..self.showTilePosition.x..", "..self.showTilePosition.y..")")

    ex.ConfirmCtr:openWindow(ex.Tools:getLang(16), str_content, function()
        local req = CrusadeGroupShenBin_pb.GReqShareCityPosit()
        req.group_id = tile_id
        NetManager:sendMessage(ProtocolID.GReqShareCityPosit, req)
    end)
end

function CrusadeGroupTileInfoLayer:onQuickGiveup()
    local tile_id = self:getTileId(self.showTilePosition)
    ctr.crusade_group:setGiveupData(tile_id, ex.Game:getServerTime() - 1)
    ctr.crusade_group:updateGiveup()
end

function CrusadeGroupTileInfoLayer:onRevoke()
    local tile_id = self:getTileId(self.showTilePosition)
    ctr.crusade_group:removeGiveupData(tile_id)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GIVEUP_REVOKE, tile_id)
    self:updateLayer()
end


return CrusadeGroupTileInfoLayer
