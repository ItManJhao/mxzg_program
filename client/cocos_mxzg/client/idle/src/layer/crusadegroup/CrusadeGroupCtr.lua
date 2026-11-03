local CrusadeGroupCtr = class("CrusadeGroupCtr", require("src.ex.BaseCtr"))

function CrusadeGroupCtr:onInit()
    self.data = require("src.layer.crusadegroup.CrusadeGroupData"):create()
    -- 讨伐团
end

function CrusadeGroupCtr:registerResponse(response_ctr) -- 讨伐团信息
    response_ctr:addHandlerAuto(ProtocolID.GResCrusadeGroupInfo, CrusadeGroup_pb.GResCrusadeGroupInfo, handler(self, self.crusadeInfo))
    -- 推送讨伐团开启
    response_ctr:addHandlerAuto(ProtocolID.GCrusadeGroupOpen, CrusadeGroup_pb.GCrusadeGroupOpen, handler(self, self.crusadeOpen))
    -- 讨伐团主界面信息
    response_ctr:addHandlerAuto(ProtocolID.GResCrusadeGroupMain, CrusadeGroup_pb.GResCrusadeGroupMain, handler(self, self.crusadeMainInfo))
    -- 讨伐团阶段推送
    response_ctr:addHandlerAuto(ProtocolID.GPushStageChange, CrusadeGroup_pb.GPushStageChange, handler(self, self.handleStageChange))
    -- 保存上阵英雄
    response_ctr:addHandlerAuto(ProtocolID.GResSetHeroes, CrusadeGroup_pb.GResSetHeroes, handler(self, self.handleSetHero))
    -- 取消上阵英雄
    response_ctr:addHandlerAuto(ProtocolID.GResCancelHero, CrusadeGroup_pb.GResCancelHero, handler(self, self.handleUnloadHero))
    -- 刷新英雄
    response_ctr:addHandlerAuto(ProtocolID.GResRefreshHero, CrusadeGroup_pb.GResRefreshHero, handler(self, self.handleRefreshHero))
    -- 获取地图数据
    response_ctr:addHandlerAuto(ProtocolID.GResMapData, CrusadeGroup_pb.GResMapData, handler(self, self.mapData))
    -- 地图数据更新
    response_ctr:addHandlerAuto(ProtocolID.GPushTerritoryUpdate, CrusadeGroup_pb.GPushTerritoryUpdate, handler(self, self.mapDataUpdate))
    -- 标记地块
    response_ctr:addHandlerAuto(ProtocolID.GResMark, CrusadeGroup_pb.GResMark, handler(self, self.resMark))
    -- 取消标记地块
    response_ctr:addHandlerAuto(ProtocolID.GResUnmark, CrusadeGroup_pb.GResUnmark, handler(self, self.resUnmark))
    -- 获取指定领地战斗信息
    response_ctr:addHandlerAuto(ProtocolID.GResViewTerritory, CrusadeGroup_pb.GResViewTerritory, handler(self, self.townBattleInfo))
    -- 获得战斗双方阵容信息
    response_ctr:addHandlerAuto(ProtocolID.GResOccupiedTerritory, CrusadeGroup_pb.GResOccupiedTerritory, handler(self, self.townBattleHeroList))
    -- 战斗
    response_ctr:addHandlerAuto(ProtocolID.GResStartFighting, CrusadeGroup_pb.GResStartFighting, handler(self, self.townBattleReport))
    -- 開墾领地
    response_ctr:addHandlerAuto(ProtocolID.GResDevelopment, CrusadeGroup_pb.GResDevelopment, handler(self, self.handleDevelopTown))
    -- 取消開墾领地
    response_ctr:addHandlerAuto(ProtocolID.GResCancelDevelopment, CrusadeGroup_pb.GResCancelDevelopment, handler(self, self.handleCancelDevelopTown))
    -- 放弃领地
    response_ctr:addHandlerAuto(ProtocolID.GResGiveUpTerritory, CrusadeGroup_pb.GResGiveUpTerritory, handler(self, self.delTown))
    -- 推送资源产出
    response_ctr:addHandlerAuto(ProtocolID.GPushResourceOutput, CrusadeGroup_pb.GPushResourceOutput, handler(self, self.resOutput))
    -- 资源采集
    response_ctr:addHandlerAuto(ProtocolID.GResCollectResources, CrusadeGroup_pb.GResCollectResources, handler(self, self.resCollect))
    -- 查看小地图
    response_ctr:addHandlerAuto(ProtocolID.GResViewSmallMap, CrusadeGroup_pb.GResViewSmallMap, handler(self, self.viewSmallMap))
    -- 获取占领的领地列表
    response_ctr:addHandlerAuto(ProtocolID.GResTerritory, CrusadeGroup_pb.GResTerritory, handler(self, self.getTownList))
    -- 讨伐团报名
    response_ctr:addHandlerAuto(ProtocolID.GResRegistration, CrusadeGroup_pb.GResRegistration, handler(self, self.handleRegistration))
    -- 讨伐团报名
    response_ctr:addHandlerAuto(ProtocolID.GResGroupInfo, CrusadeGroup_pb.GResGroupInfo, handler(self, self.handleGroupInfo))
    -- boss挑戰記錄
    response_ctr:addHandlerAuto(ProtocolID.GResBossChallengeRecord, CrusadeGroup_pb.GResBossChallengeRecord, handler(self, self.handleBossChallengeRecord))
    -- 挑戰戰報
    response_ctr:addHandlerAuto(ProtocolID.GResBossReport, CrusadeGroup_pb.GResBossReport, handler(self, self.handleBossReport))
    -- 討伐團重命名
    response_ctr:addHandlerAuto(ProtocolID.GResGroupRename, CrusadeGroup_pb.GResGroupRename, handler(self, self.handleGroupRename))

    -- 职级信息回调处理
    response_ctr:addHandlerAuto(ProtocolID.GResGetOccupationInfo, CrusadeGroupOccupation_pb.GResGetOccupationInfo, handler(self, self.setOccupationInfo))
    -- 职级晋升
    response_ctr:addHandlerAuto(ProtocolID.GResOccupationUp, CrusadeGroupOccupation_pb.GResOccupationUp, handler(self, self.occupationUp))
    -- 职级信息推送
    response_ctr:addHandlerAuto(ProtocolID.GResSendOccupationTaskInfo, CrusadeGroupOccupation_pb.GResSendOccupationTaskInfo, handler(self, self.pushOccupationInfo))
    -- 职级任务完成
    response_ctr:addHandlerAuto(ProtocolID.GResOpreaOccupationTask, CrusadeGroupOccupation_pb.GResOpreaOccupationTask, handler(self, self.pushOccupationTaskComplete))

    -- 神兵信息
    response_ctr:addHandlerAuto(ProtocolID.GResShenBinInfo, CrusadeGroupShenBin_pb.GResShenBinInfo, handler(self, self.shenBinInfo))
    -- 神兵合成
    response_ctr:addHandlerAuto(ProtocolID.GResShenBinCompose, CrusadeGroupShenBin_pb.GResShenBinCompose, handler(self, self.shenBinCompose))
    -- 神兵装备
    response_ctr:addHandlerAuto(ProtocolID.GResShenBinEquip, CrusadeGroupShenBin_pb.GResShenBinEquip, handler(self, self.shenBinEquip))
    -- 神兵核心升级
    response_ctr:addHandlerAuto(ProtocolID.GResShenBinCoreUp, CrusadeGroupShenBin_pb.GResShenBinCoreUp, handler(self, self.shenBinCoreUp))
    -- 神兵分解
    response_ctr:addHandlerAuto(ProtocolID.GResShenBinResolve, CrusadeGroupShenBin_pb.GResShenBinResolve, handler(self, self.shenBinResolve))
    -- 神兵道具信息
    response_ctr:addHandlerAuto(ProtocolID.GResRoleShenBinInfo, CrusadeGroupShenBin_pb.GResRoleShenBinInfo, handler(self, self.roleShenBinInfo))
    -- 神兵战力
    response_ctr:addHandlerAuto(ProtocolID.GResShenBinFighting , CrusadeGroupShenBin_pb.GResShenBinFighting, handler(self, self.shenBinFighting))

    -- 讨伐团排行
    response_ctr:addHandlerAuto(ProtocolID.GResCrusadeGroupRank, CrusadeGroupRank_pb.GResCrusadeGroupRank, handler(self, self.updateCrusadeGroupRank))
    -- 讨伐团成员排行
    response_ctr:addHandlerAuto(ProtocolID.GResCrusadeGroupPRank, CrusadeGroupRank_pb.GResCrusadeGroupPRank, handler(self, self.updateCrusadeMemberRank))
end

-- 设置是否需要强制刷新出征列表
function CrusadeGroupCtr:setForceFresh(status)
    self.is_refresh_force = status
end

function CrusadeGroupCtr:setHeroBox(box_list)
    self.data.game_data.set_off_hero_list = {}
    self.data.game_data.hero_box_list = {}
    if not box_list or #box_list == 0 then
        return
    end

    for k, v in ipairs(box_list) do
        if v.hero and v.hero.hero_id > 0 then
            table.insert(self.data.game_data.set_off_hero_list, clone(v))
        end
        table.insert(self.data.game_data.hero_box_list, clone(v))
    end
end
-- 获取可以出征的英雄列表
function CrusadeGroupCtr:getCanSetOffHeroList()
    local can_set_off_list = {}
    local hero_list = ex.Player.hero_data:getHeroList()
    if not hero_list or #hero_list == 0 then
        return can_set_off_list
    end

    local temp_dict = {}
    for i, v in ipairs(hero_list) do
        if not self:checkHeroSetOff(v.hero_type, v.hero_id) then
            if v.star >= 6 then
                if not temp_dict[v.hero_type] or temp_dict[v.hero_type].star < v.star or (temp_dict[v.hero_type].star == v.star and temp_dict[v.hero_type].fighting < v.fighting) then
                    temp_dict[v.hero_type] = v
                end
            end
        end
    end

    for k, v in pairs(temp_dict) do
        local hero_data = clone(v)
        hero_data.level = cfg.system.crusade_group_hero_level
        table.insert(can_set_off_list, hero_data)
    end

    if #can_set_off_list > 1 then
        table.sort(
            can_set_off_list,
            function(a, b)
                local a_fighting = tonumber(a.fighting)
                local b_fighting = tonumber(b.fighting)
                if a_fighting == b_fighting then
                    if a.star == b.star then
                        return a.hero_type > b.hero_type
                    else
                        return a.star > b.star
                    end
                end
                return a_fighting > b_fighting
            end
        )
    end

    return can_set_off_list
end

-- 判定英雄是否出征
function CrusadeGroupCtr:checkHeroSetOff(hero_type, hero_id)
    for k, v in ipairs(self.data.game_data.set_off_hero_list) do
        if v.hero.hero_type == hero_type or v.hero.hero_id == hero_id then
            return true
        end
    end

    return false
end

-- 获取该建筑战斗英雄列表
function CrusadeGroupCtr:getBattleHeroList(dead_hero_list, cost_energy)
    local hero_list = {}
    local temp_hero_list = ex.Player.hero_data:getHeroList()

    for k, v in ipairs(self.data.game_data.set_off_hero_list) do
        local hero = v.hero
        local physical_strength = v.physical_strength
        local is_death = false
        if dead_hero_list and #dead_hero_list > 0 then
            for k1, v1 in ipairs(dead_hero_list) do
                if v1 == hero.hero_id then
                    is_death = true
                    break
                end
            end
        end

        local model = {
            box_id = v.box_id,
            hero = v.hero,
            physical_strength = physical_strength,
            is_energy_enough = physical_strength >= cost_energy,
            is_death = is_death
        }

        table.insert(hero_list, model)
    end

    return hero_list
end

function CrusadeGroupCtr:getStage()
    return self.data.stage
end

function CrusadeGroupCtr:startTimer()
    if self.is_ctr_start_time then
        return
    end

    -- 30秒
    self:addTimer("update", 30000, handler(self, self.updateStatus), true)
end

function CrusadeGroupCtr:updateStatus()
    local server_time = ex.Game:getServerTime()

    
    -- 刷新数据
    local collect_status = self.data.can_acquisition
    local time_diff = (server_time - self.data.last_acquisition_time)
    self.data.can_acquisition = time_diff > ex.Tools:getSysCfg("crusade_group_collect_interval_s")
    if collect_status ~= self.data.can_acquisition then
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATA_TILE_ALL, {}, false)
    end

end

----------------------- 请求协议 --------------------------
function CrusadeGroupCtr:requestGetInfo()
    local config = cfg.funcopen["main_crusade_group"]
    if config and config.isVisible and config.isVisible() then
        NetManager:sendMessage(ProtocolID.GReqCrusadeGroupInfo)
    end
end

function CrusadeGroupCtr:requestSignUp()
    NetManager:sendMessage(ProtocolID.GReqRegistration)
end

function CrusadeGroupCtr:requestSetHero(box_id, hero_id)
    local req = CrusadeGroup_pb.GReqSetHeroes()
    req.box_id = box_id
    req.hero_id = hero_id
    NetManager:sendMessage(ProtocolID.GReqSetHeroes, req)
end

function CrusadeGroupCtr:requestUnloadHero(box_id)
    local req = CrusadeGroup_pb.GReqCancelHero()
    req.box_id = box_id
    NetManager:sendMessage(ProtocolID.GReqCancelHero, req)
end

function CrusadeGroupCtr:requestRefreshHero(box_id)
    if not box_id then
        local curTime = ex.Game:getServerTime()
        if self.last_refresh_hero_time and curTime - self.last_refresh_hero_time < 600 and not self.is_refresh_force then
            return false
        end
    end

    self.is_refresh_force = false
    local req = CrusadeGroup_pb.GReqRefreshHero()
    if box_id then
        req.box_id = box_id
    end
    NetManager:sendMessage(ProtocolID.GReqRefreshHero, req)

    return true
end

-------------------------- 处理协议回调 -------------------------

----------------------------------CrusadeGroup.proto-----------------------------------
-- 讨伐团信息
function CrusadeGroupCtr:crusadeInfo(null, data)
    -- GResCrusadeGroupInfo

    local crusade_data = self.data
    crusade_data.stage = data.stage
    crusade_data.sign_up_status = data.registration
    crusade_data.sign_up_start_time = data.registration_start_time or 0
    crusade_data.sign_up_end_time = data.registration_end_time or 0
    crusade_data.battle_start_time = data.battle_start_time or 0
    crusade_data.game_end_time = data.battle_end_time or 0

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.INFO)

    if self.data:isOpen() then
        NetManager:sendMessage(ProtocolID.GReqCrusadeGroupMain)
    end
end

-- 讨伐团报名
function CrusadeGroupCtr:handleRegistration()
    local crusade_data = self.data
    crusade_data.sign_up_status = true
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.SIGN_UP)
end

-- 讨伐团阶段推送
function CrusadeGroupCtr:handleStageChange(null, data)
    local crusade_data = self.data

    -- 修复讨伐团换届报名问题(在活动之前处于未开启并当前进入报名阶段时请求讨伐团信息)
    if crusade_data.stage == CRUSADE_GROUP_STATE.NONE and 
    data.stage == CRUSADE_GROUP_STATE.SIGN_UP then
        self.requestGetInfo()
    end

    crusade_data.stage = data.stage

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.STAGE_UPDATE)
end

-- 讨伐团信息
function CrusadeGroupCtr:handleGroupInfo(null, data)
    -- GResGroupInfo

    local crusade_data = self.data.game_data
    crusade_data.crusade_group_info.group_id = data.group_id
    crusade_data.crusade_group_info.group_name = data.name
    crusade_data.crusade_group_info.group_badge_id = data.emblem
    crusade_data.crusade_group_info.rename_number = data.rename_number
    crusade_data.crusade_group_list = data.crusaders

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.MEMBER)
end

-- boss挑戰記錄
function CrusadeGroupCtr:handleBossChallengeRecord(null, data)
    -- GResBossChallengeRecord
    
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_BOSS_BATTLE_LOG, data)
end

-- 挑戰戰報
function CrusadeGroupCtr:handleBossReport(null, data)
    -- GResBossReport

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.BATTLE, data.report)
end

-- 討伐團重命名
function CrusadeGroupCtr:handleGroupRename(null, data)
    -- GResGroupRename

    self.data.game_data.crusade_group_info.group_name = data.name

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.GROUP_RENAME)
end

-- 推送讨伐团开启
function CrusadeGroupCtr:crusadeOpen(null, data)
    -- GCrusadeGroupOpen
    -- 写死收到开启推送, stage写死为3
    self.data.stage = 3
    
    ctr.crusade_group:requestGetInfo()

    require("src.layer.crusadegroup.CrusadeGroupTipCtr"):instance():openWindow()
end

-- 讨伐团主界面信息
function CrusadeGroupCtr:crusadeMainInfo(null, data)
    -- GResCrusadeGroupMain

    self.data.last_acquisition_time = data.last_acquisition_time

    local crusade_info = self.data.game_data
    crusade_info.crusade_group_info.group_id = data.group_id
    crusade_info.self_occupation_id = data.knighthood_id
    crusade_info.energy = data.force_nature
    crusade_info.refuse_energy_rate = data.productivity
    crusade_info.territory_mark = data.territory_mark
    crusade_info.last_occupation_id = data.last_occupation_id
    self:updateStatus()
    self:setHeroBox(data.hero)

    self:startTimer()
    
    -- 请求领地列表
    NetManager:sendMessage(ProtocolID.GReqTerritory)
    -- 請求成員列表
    NetManager:sendMessage(ProtocolID.GReqGroupInfo)
    -- 请求任务列表
    NetManager:sendMessage(ProtocolID.GReqGetOccupationInfo)
    
    --神兵信息
	NetManager:sendMessage(ProtocolID.GReqShenBinInfo)
	--神兵道具信息
	NetManager:sendMessage(ProtocolID.GReqRoleShenBinInfo)

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_MEMBER_LIST)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.MAIN_INFO)
end

-- 保存上阵英雄
function CrusadeGroupCtr:handleSetHero(null, data)
    for k, v in ipairs(self.data.game_data.hero_box_list) do
        if v.box_id == data.hero.box_id then
            v.hero = clone(data.hero.hero)
            v.physical_strength = data.hero.physical_strength
        end
    end

    if #self.data.game_data.hero_box_list > 1 then
        table.sort(
            self.data.game_data.hero_box_list,
            function(a, b)
                return a.box_id < b.box_id
            end
        )
    end

    table.insert(self.data.game_data.set_off_hero_list, data.hero)
    if #self.data.game_data.set_off_hero_list > 1 then
        table.sort(
            self.data.game_data.set_off_hero_list,
            function(a, b)
                return a.box_id < b.box_id
            end
        )
    end

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_SET_OFF)
end

-- 取消上阵英雄
function CrusadeGroupCtr:handleUnloadHero(null, data)
    -- GResCancelHero

    local hero_id
    for k, v in ipairs(self.data.game_data.hero_box_list) do
        if v.box_id == data.hero.box_id then
            hero_id = v.hero.hero_id
            v.hero = data.hero.hero
            v.physical_strength = data.physical_strength
            break
        end
    end

    if hero_id then
        for k, v in ipairs(self.data.game_data.set_off_hero_list) do
            if v.hero.hero_id == hero_id then
                table.remove(self.data.game_data.set_off_hero_list, k)
                break
            end
        end
    end

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_SET_OFF)
end

function CrusadeGroupCtr:handleRefreshHero(null, data)
    if not data or not data.hero_box or #data.hero_box == 0 then
        return
    end

    self:setHeroBox(data.hero_box)
    self.last_refresh_hero_time = ex.Game:getServerTime()
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_SET_OFF)
end

-- 获取地图数据
function CrusadeGroupCtr:mapData(null, data)
    -- GResMapData

    local role_id = ex.Player.role_id

    for k, v in pairs(data.territory) do
        self.data.map_data[v.id] = v
    end

    -- 优化性能。不在讨伐团界面不再刷新这个数据.如果有bug。请尝试注释掉判断
    if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER then
        self.data:updateLinkPath()
    end
    
    local can_ship = ctr.crusade_group.data.map_refresh_page_recorder[data.mark_id] == nil
    ctr.crusade_group.data.map_refresh_page_recorder[data.mark_id] = {is_recv = true, time = ex.Game:getServerTime()}
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATA_TILE_ALL, data.territory, can_ship)
end

function CrusadeGroupCtr:mapDataUpdate(null, data)
    -- GPushTerritoryUpdate
    if data.territory.occupied_id == 0 then
        self.data.map_data[data.territory.id] = nil
    else
        self.data.map_data[data.territory.id] = data.territory
    end

    local is_about_me = false
    -- 优化性能。不在讨伐团界面不再刷新这个数据.如果有bug。请尝试注释掉判断
    if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER then
        local old_data = self.data.map_link_path[data.territory.id]
        self.data:updateLinkPath()
        is_about_me = (old_data ~= nil) == (self.data.map_link_path[data.territory.id] ~= nil)
    end
    
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATA_TILE_ALL, {data.territory}, is_about_me == false)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_MARK)
end


-- 获取标记的领地id列表
function CrusadeGroupCtr:resMark(null, data)
    -- GResMark
    local crusade_data = self.data.game_data
    table.insert(crusade_data.territory_mark, data.mark)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_MARK)

    ex.MessageView:add(ex.Tools:getLang(77944))
end
-- MARK: - Comment
-- 取消标记
function CrusadeGroupCtr:resUnmark(null, data)
    -- GResUnmark
    local crusade_data = self.data.game_data
    TableEx.removeTableData(crusade_data.territory_mark,function(value)
        return value.territory_id == data.territory_id
    end)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_MARK)

    ex.MessageView:add(ex.Tools:getLang(77945))
end

-- 获取指定领地战斗信息
function CrusadeGroupCtr:townBattleInfo(null, data)
    -- GResViewTerritory
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_TOWN_BATTLE_INFO, data)
end

-- 获得战斗双方阵容信息
function CrusadeGroupCtr:townBattleHeroList(null, data)
    -- GResAttackTerritory
end

-- 战斗
function CrusadeGroupCtr:townBattleReport(null, data)
    -- GResStartFighting

    if data.guard_time > 0 then
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.BATTLE_UPDATE_TIME, data)
    end

    if data.language_id ~= nil and data.language_id > 0 then
        ex.MessageView:add(ex.Tools:getLang(data.language_id))
        return
    end

    if data.occupied == true then
        self.data.game_data.last_occupation_id = data.territory_id

        -- 佔領成功後刷新領地列表
        NetManager:sendMessage(ProtocolID.GReqTerritory)
    end

    -- 通知更新英雄列表狀態
    self:setForceFresh(true)
    
    if data.boss_total_damage > 0 then
        if ex.MainSceneCtr:getCurLayerType() ~= MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER then
            ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER)
        end
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.START_BATTLE, BattleType.CRUSADE_GROUP_AREA)
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.BATTLE, data.report, nil, data)
    else
        if ex.MainSceneCtr:getCurLayerType() ~= MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER then
            ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER)
        end
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.START_BATTLE, BattleType.CRUSADE_GROUP_BOSS)
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.BATTLE, data.report, nil, data)
    end

end

-- 開墾领地
function CrusadeGroupCtr:handleDevelopTown(null, data)
    -- GResDevelopment

    local crusade_info = self.data.game_data
    
    for i,v in ipairs(crusade_info.occupied_list) do
        if v.hero_id == data.territory.hero_id then
            v.hero_id = 0
            break
        end
    end

    for i,v in ipairs(crusade_info.occupied_list) do
        if v.id == data.territory.id then
            v.hero_id = data.territory.hero_id
            break
        end
    end

    -- 通知更新英雄列表狀態
    self:setForceFresh(true)

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_TOWN_LIST)
end

-- 取消開墾领地
function CrusadeGroupCtr:handleCancelDevelopTown(null, data)
    -- GReqCancelDevelopment

    local crusade_info = self.data.game_data
    
    for i,v in ipairs(crusade_info.occupied_list) do
        if v.id == data.territory.id then
            v.hero_id = 0
            break
        end
    end

    -- 通知更新英雄列表狀態
    self:setForceFresh(true)

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_TOWN_LIST)
end

-- 放弃领地
function CrusadeGroupCtr:delTown(null, data)
    -- GResGiveUpTerritory

    local crusade_info = self.data.game_data

    for i, v in ipairs(crusade_info.occupied_list) do
        if v.id == data.territory_id then
            table.remove(crusade_info.occupied_list, i)
            break
        end
    end

    -- 通知更新英雄列表狀態
    self:setForceFresh(true)
    
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_TOWN_LIST)
end

-- 推送资源产出
function CrusadeGroupCtr:resOutput(null, data)
    -- GPushResourceOutput
end

-- 资源采集
function CrusadeGroupCtr:resCollect(null, data)
    -- GResCollectResources
    require("src.layer.crusadegroup.CrusadeGroupAcquisitionCtr"):instance():openWindow(data)

    self.data.last_acquisition_time = data.last_acquisition_time
    self:updateStatus()

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.RUN_COLLECT_EFFECT)
    -- local data = {territory = self.data.game_data.occupied_list}
    -- ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATA_TILE, data)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATA_TILE_ALL, {}, false)

    --采集资源后刷新神兵
    NetManager:sendMessage(ProtocolID.GReqRoleShenBinInfo)
    -- self.data.energy = self.data.energy + data.force_nature
end

function CrusadeGroupCtr:reqViewSmallMap()
    self.data.map_thumbnail_data = {}

    local req_map = CrusadeGroup_pb.GReqViewSmallMap()
    req_map.page = 0
    NetManager:sendMessage(ProtocolID.GReqViewSmallMap, req_map)

    local req_map = CrusadeGroup_pb.GReqViewSmallMap()
    req_map.page = 1
    NetManager:sendMessage(ProtocolID.GReqViewSmallMap, req_map)
end

-- 查看小地图
function CrusadeGroupCtr:viewSmallMap(null, data)
    -- GResViewSmallMap
    local map_thumbnail_data = {}
    for k,v in pairs(data.territory_id) do
        local thumbnail_data = {}
        thumbnail_data.id = data.page == 0 and ex.Player.role_id or 2
        map_thumbnail_data[v] = thumbnail_data
        self.data.map_thumbnail_data[v] = thumbnail_data
    end
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_THUMBNAIL_DRAW, map_thumbnail_data)

    if data.page ~= 0 and data.page < data.total_page then
        local req_map = CrusadeGroup_pb.GReqViewSmallMap()
        req_map.page = data.page + 1
        NetManager:sendMessage(ProtocolID.GReqViewSmallMap, req_map)
    end
end

-- 获取占领的领地列表
function CrusadeGroupCtr:getTownList(null, data)
    -- GResTerritory
    self.data.game_data.occupied_list = data.territory
    
    -- 优化性能。不在讨伐团界面不再刷新这个数据.如果有bug。请尝试注释掉判断
    if ex.MainSceneCtr:getCurLayerType() == MainSceneType.MAINCITY_CRUSADE_GROUP_LAYER then
        self.data:updateLinkPath()
    end

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_TOWN_LIST)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATA_TILE_ALL, {}, false)
end
-- mark
----------------------------------CrusadeGroupOccupation.proto-----------------------------------
-- 职级信息回调处理
function CrusadeGroupCtr:setOccupationInfo(null, data)
    -- GResGetOccupationInfo

    local crusade_info = self.data.game_data

    crusade_info.self_occupation_id = data.occupationInfo.oc_id
    crusade_info.tasklist = data.occupationInfo.taskInfos

    self.data:checkNobilityReddot()

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_TASK_LIST)
end

-- 职级晋升
function CrusadeGroupCtr:occupationUp(null, data)
    -- GResOccupationUp

    local crusade_info = self.data.game_data

    crusade_info.self_occupation_id = data.oc_id

    self.data:checkNobilityReddot()

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_OCCUPATION)
end

-- 职级信息推送
function CrusadeGroupCtr:pushOccupationInfo(null, data)
    -- GResSendOccupationTaskInfo

    local crusade_info = self.data.game_data
    crusade_info.tasklist = data.taskInfo
    
    self.data:checkNobilityReddot()

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_TASK_LIST)
end

-- 职级任务完成
function CrusadeGroupCtr:pushOccupationTaskComplete(null, data)
    -- GResOpreaOccupationTask

    local crusade_info = self.data.game_data

    for i, v in ipairs(crusade_info.tasklist) do
        if v.taskId == data.taskInfo.taskId then
            v.targetCount = data.taskInfo.targetCount
            v.condition = data.taskInfo.condition
            v.complete_type = data.taskInfo.complete_type
        end
    end

    self.data:checkNobilityReddot()

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_TASK_LIST)
end

----------------------------------CrusadeGroupShenBin.proto-----------------------------------
-- 神兵信息
function CrusadeGroupCtr:shenBinInfo(null, data)
    -- GResShenBinInfo
    self.data:setGodArmsInfo(data)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS)
    -- ctr.crusade_group.data:checkShenBinRedot()
end

-- 神兵合成
function CrusadeGroupCtr:shenBinCompose(null, data)
    -- GResShenBinCompose
    --合成后刷新玩家道具信息————即背包
    NetManager:sendMessage(ProtocolID.GReqRoleShenBinInfo)
     --合成后刷新神兵界面
    NetManager:sendMessage(ProtocolID.GReqShenBinInfo)
    --关闭合成界面
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS_CLOSE)
    ctr.crusade_group.data:checkShenBinRedot()
end

-- 神兵装备
function CrusadeGroupCtr:shenBinEquip(null, data)
    -- GResShenBinEquip
    NetManager:sendMessage(ProtocolID.GReqShenBinInfo)
    NetManager:sendMessage(ProtocolID.GReqRoleShenBinInfo)
end

-- 神兵核心升级
function CrusadeGroupCtr:shenBinCoreUp(null, data)
    -- GResShenBinCoreUp
    self.data:setGodArmsCoreUp(data)
    NetManager:sendMessage(ProtocolID.GReqShenBinInfo)
    -- ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS)
    ctr.crusade_group.data:checkShenBinRedot()
end

-- 神兵分解
function CrusadeGroupCtr:shenBinResolve(null, data)
    -- GResShenBinResolve
    --分解后刷新玩家道具信息————即背包
    NetManager:sendMessage(ProtocolID.GReqRoleShenBinInfo)
    --分解后刷新神兵界面
    NetManager:sendMessage(ProtocolID.GReqShenBinInfo)
    ctr.crusade_group.data:checkShenBinRedot()
end

-- 玩家的神兵道具信息
function CrusadeGroupCtr:roleShenBinInfo(null, data)
    -- GResRoleShenBinInfo
    self.data:setRoleGodArmsInfo(data)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS_BACKPACK)
    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS)
    ctr.crusade_group.data:checkShenBinRedot()
end

--神兵战力
function CrusadeGroupCtr:shenBinFighting(null, data)
    -- GResShenBinFighting
    self.data:setShenBinFighting(data)
    -- ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS)
end

----------------------------------CrusadeGroupRank.proto-----------------------------------
-- 讨伐团排行
function CrusadeGroupCtr:updateCrusadeGroupRank(null, data)
    -- GResCrusadeGroupRank

    if data.type == 1 then
        ex.Player.rank_data.rank_crusade_group_res_list = data.ranks
        ex.Player.rank_data.rank_crusade_group_res_self = data.self
    else
        ex.Player.rank_data.rank_crusade_group_damage_list = data.ranks
        ex.Player.rank_data.rank_crusade_group_damage_self = data.self
    end

    ex.EventManager:fire(EVENT.RANK_EVENT.UPDATE_RANK_TOP_LAYER)
end

-- 讨伐团成员排行
function CrusadeGroupCtr:updateCrusadeMemberRank(null, data)
    -- GResCrusadeGroupPRank

    if data.type == 1 then
        ex.Player.rank_data.rank_crusade_member_res_list = data.ranks
        ex.Player.rank_data.rank_crusade_member_res_self = data.self
    else
        ex.Player.rank_data.rank_crusade_member_damage_list = data.ranks
        ex.Player.rank_data.rank_crusade_member_damage_self = data.self
    end

    ex.EventManager:fire(EVENT.RANK_EVENT.UPDATE_RANK_TOP_LAYER)
end


function CrusadeGroupCtr:startGiveupTimer()
    self:updateGiveup()
    if self:getTimerByName("update_giveup") then
        return
    end

    self:addTimer("update_giveup", 1000, handler(self, self.updateGiveup), true)
end

function CrusadeGroupCtr:updateGiveup()
    local time = ex.Game:getServerTime()

    local is_change = false

    ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GIVEUP)

    for k,v in pairs(self.data.map_giveup) do
        if v.time < time then
            local req = CrusadeGroup_pb.GReqGiveUpTerritory()
            req.territory_id = v.id
            NetManager:sendMessage(ProtocolID.GReqGiveUpTerritory, req)

            is_change = true

            self:removeGiveupData(v.id)
        end
    end

    if is_change then
        ex.EventManager:fire(EVENT.CRUSADE_GROUP.UPDATE_GIVEUP_VIEW)
    end

    if table.nums(self.data.map_giveup) <= 0 then
        self:removeTimerByName("update_giveup")
    end
end


function CrusadeGroupCtr:refreshAllMapData()
    local time = ex.Game:getServerTime()

    -- 计算需要刷多少页的数据
    local max_col = math.ceil(self.data.map_size.width / self.data.map_refresh_page_size.width)
    local max_row = math.ceil(self.data.map_size.height / self.data.map_refresh_page_size.height)
    for i=1,max_col do
        for j=1,max_row do
            local page_idx = j * self.data.map_refresh_page_range.width + i

            local refresh_data = ctr.crusade_group.data.map_refresh_page_recorder[page_idx]

            -- 没有刷新过。或者上一次刷新没有回复并超过了5秒
            if refresh_data == nil or (refresh_data.is_recv ~= true and time - refresh_data.time > 5) then
                ctr.crusade_group.data.map_refresh_page_recorder[page_idx] = {is_recv = false, time = time}

                -- 出血
                local beg_x = (i - 1) * self.data.map_refresh_page_size.width - 5
                local end_x = (i - 1) * self.data.map_refresh_page_size.width + self.data.map_refresh_page_size.width + 5

                local beg_y = (j - 1) * self.data.map_refresh_page_size.height - 5
                local end_y = (j - 1) * self.data.map_refresh_page_size.height + self.data.map_refresh_page_size.height + 5

                beg_x = Maths.clampf(beg_x, 0, self.data.map_size.width - 1)
                end_x = Maths.clampf(end_x, 0, self.data.map_size.height - 1)
                beg_y = Maths.clampf(beg_y, 0, self.data.map_size.width - 1)
                end_y = Maths.clampf(end_y, 0, self.data.map_size.height - 1)

                local req_map = CrusadeGroup_pb.GReqMapData()
                req_map.mark_id = page_idx
                req_map.bottom_left.x = beg_x
                req_map.bottom_left.y = beg_y
                req_map.upper_right.x = end_x
                req_map.upper_right.y = end_y
                NetManager:sendMessage(ProtocolID.GReqMapData, req_map)

                if is_game_controller then
                    ex.MessageView:add(string.format("测试-刷新范围: %d-%d, %d-%d", beg_x, beg_y, end_x, end_y))
                end

            end
        end
    end

end

function CrusadeGroupCtr:addGiveupData(idx)
    local giveup_data = self.data.map_giveup[idx]
    local time = ex.Game:getServerTime() + ex.Tools:getSysCfg("crusade_group_giveup_interval_s")
    if giveup_data == nil then
        self.data.map_giveup[idx] = {id=idx, time=time}
    else
        giveup_data.time = time
    end
    self:startGiveupTimer()
end

function CrusadeGroupCtr:removeGiveupData(idx)
    self.data.map_giveup[idx] = nil
end

function CrusadeGroupCtr:setGiveupData(idx, time)
    local giveup_data = self.data.map_giveup[idx]
    if giveup_data ~= nil then
        self.data.map_giveup[idx] = {id=idx, time=time}
    end
end

return CrusadeGroupCtr
