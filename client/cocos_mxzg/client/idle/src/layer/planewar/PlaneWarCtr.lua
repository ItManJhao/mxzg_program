local PlaneWarCtr = class("PlaneWarCtr", require("src.ex.BaseCtr"))

local daystrs = {91316,91317,91318,91319,91320,91321,91322}

function PlaneWarCtr:onInit()
    self.data = require("src.layer.planewar.PlaneWarData"):create()
    self:initConfig()
    self:initEventListen()
end

function PlaneWarCtr:initConfig()
    local planewarhero
    if not cfg.planewarhero or not cfg.planewarhero.planewarhero then
        planewarhero = require("src.config.planewarhero")
    else
        planewarhero = cfg.planewarhero.planewarhero
    end
    
    self.planewar_boss_list = {}
    for k, v in ipairs(planewarhero) do
        local turn  = v.turn
        local level_idx = v.level_idx

        local boss_data = {
            hero_type = v.hero_type,
            hero_level = v.hero_level,
            hero_star = v.hero_star,
            hero_introduce = v.hero_introduce,
            hero_skillid = v.hero_skillid
        }

        if not self.planewar_boss_list[level_idx] then
            self.planewar_boss_list[level_idx] = {}
        end

        if not self.planewar_boss_list[level_idx][turn] then
            self.planewar_boss_list[level_idx][turn] = {}
            self.planewar_boss_list[level_idx][turn] = boss_data
        end
    end

    local planewarlevel
    if not cfg.planewarlevel or not cfg.planewarlevel.planewarlevel then
        planewarlevel = require("src.config.planewarlevel")
    else
        planewarlevel = cfg.planewarlevel.planewarlevel
    end
    
    self.planewar_level_dict = {}
    for k, v in ipairs(planewarlevel) do
        self.planewar_level_dict[v.idx] = v
    end
end

function PlaneWarCtr:registerResponse(response_ctr)
    response_ctr:addHandlerAuto(ProtocolID.GResPlaneWarData, PlaneWar_pb.GResPlaneWarData, handler(self, self.handlePlaneWarData))
    response_ctr:addHandlerAuto(ProtocolID.GResPlaneWarChallenge, PlaneWar_pb.GResPlaneWarChallenge, handler(self, self.handlePlaneWarChallenge))
    response_ctr:addHandlerAuto(ProtocolID.GResPlaneWarSweep, PlaneWar_pb.GResPlaneWarSweep, handler(self, self.handlePlaneWarSweep))
    response_ctr:addHandlerAuto(ProtocolID.GResPlaneWarBuyCount, PlaneWar_pb.GResPlaneWarBuyCount, handler(self, self.handlePlaneWarBuyCount))
    response_ctr:addHandlerAuto(ProtocolID.GResPlaneWarRank, PlaneWar_pb.GResPlaneWarRank, handler(self, self.handlePlaneWarRank))
end

function PlaneWarCtr:initEventListen()
    ex.EventManager:add(EVENT.MAIN_CITY_RECHARGE.PRIVILEGE_GIFT,handler(self,self.handlePrivilegeUpdate))
end

function PlaneWarCtr:selectInstance(element, turn)
    if element and turn then
        if self.select_instance and element == self.select_instance.element then
            return
        end

        self.select_instance = {
            element = element,
            turn = turn,
            select_time = ex.Game:getServerTime()
        }
    else
         self.select_instance = nil
    end
end

function PlaneWarCtr:requestPlaneWar()
    self:requestPlaneWarData()
    self:requestPlaneWarRank()
end

function PlaneWarCtr:requestPlaneWarData()
    NetManager:sendMessage(ProtocolID.GReqPlaneWarData)
end

function PlaneWarCtr:requestPlaneWarChallenge(idx)
    local req = PlaneWar_pb.GReqPlaneWarChallenge()
	req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqPlaneWarChallenge, req)
end

function PlaneWarCtr:requestPlaneWarSweep(idx)
    local req = PlaneWar_pb.GReqPlaneWarSweep()
    req.idx = idx
    NetManager:sendMessage(ProtocolID.GReqPlaneWarSweep, req)
end

function PlaneWarCtr:requestPlaneWarBuyCount()
    NetManager:sendMessage(ProtocolID.GReqPlaneWarBuyCount)
end

function PlaneWarCtr:requestPlaneWarRank()
    NetManager:sendMessage(ProtocolID.GReqPlaneWarRank)
end

function PlaneWarCtr:handlePlaneWarData(suibian, data)
    self:initData()
    self:setChallengeCount(data.challenge_count)
    self.data.remaining_buy_count = data.remaining_buy_count
    self.data.max_challenge_count = data.max_challenge_count
    self.data.turn = data.turn
    self.data.had_buy_count = data.had_buy_count
    self.data.last_get_info_time = ex.Game:getServerTime()
    
    if data.privilege_expire_time and data.privilege_expire_time > 0 then
        self.privilege_expire_time = data.privilege_expire_time     
    end

    self:updatePassLevel(data.pass_level_info)

    ex.EventManager:fire(EVENT.PLANE_WAR.UPDATE_DATA)
end

function PlaneWarCtr:updatePassLevel(pass_level_info)
    self.data.instance_list = {}
    if pass_level_info then
        for i = 1, 5 do
            local planewar_info_config = cfg.planewarinformation.planewarinformation[i]
            local instance_data = {
                element = i,
                open_day = {},
                open_day_str = "暂不开放",
                name = "",
                level = 0,
                is_open = false,
                turn = self.data.turn,
                boss = nil
            }

            if planewar_info_config then
                instance_data.element = planewar_info_config.element
                instance_data.open_day = planewar_info_config.open_day
                local open_day_str = ""
                if #planewar_info_config.open_day == 0 then
                    open_day_str = ex.Tools:getLang(91324)
                end

                for k, v in ipairs(planewar_info_config.open_day) do
                    if k > 1 then
                        open_day_str = open_day_str .. "，"
                    end

                    open_day_str = open_day_str .. ex.Tools:getLang(daystrs[v])
                    if k == #planewar_info_config.open_day then
                        open_day_str = open_day_str .. ex.Tools:getLang(91323)
                    end
                end

                instance_data.open_day_str = open_day_str

                local is_open = false
                local level = 0
                for k, v in ipairs(pass_level_info) do
                    if v.key == i then
                        is_open = true
                        level = v.value
                        break
                    end
                end

                instance_data.is_open = is_open
                instance_data.level = level
                if planewar_info_config.name then
                    instance_data.name = ex.Tools:getLang(planewar_info_config.name)
                end
                
                self.mission_pass[i] = level
                
                local boss

                if is_open then
                    for k, v in ipairs(cfg.planewarlevel.planewarlevel) do
                        if v.element == i then
                            local pass_level = self.mission_pass[v.element] or 0
                            local status = -1   -- -1为未解锁，0为当前未通且可挑战，1为已通关
                            if v.level - pass_level == 1 then
                                status = 0
                            elseif v.level - pass_level < 1 then
                                status = 1
                            end

                            if status == 0 or status == 1 then
                                boss = self.planewar_boss_list[v.idx][self.data.turn]
                            end
                        end
                    end
                end

                instance_data.boss = boss
            end

            table.insert(self.data.instance_list, instance_data)
        end
    end
end

function PlaneWarCtr:handlePlaneWarChallenge(suibian, data)
    if self.data.challenge_count > 0 then
        self:setChallengeCount(self.data.challenge_count - 1)
    end

    self:updatePassLevel(data.pass_level_info)

    local elem = 1
    local battle_type = BattleType.PLANE_WAR_1
    
    local level_config = self.planewar_level_dict[data.idx]
    if level_config then
        for k, v in ipairs(cfg.planewarinformation.planewarinformation) do
            if v.element == level_config.element then
                elem = v.element
                battle_type = v.battle_type
                break
            end
        end
    end

    local battle_layer = ex.Tools:addBattleLayerAuto(
        self.layer,
        battle_type,
        MainSceneType.MAINCITY_PLANE_WAR_MISSION_LAYER,
        MainSceneType.MAINCITY_PLANE_WAR_MISSION_BATTLE_LAYER,
        "", 
        EVENT.PLANE_WAR.BATTLE_BOSS_BATTLE,
        function(layer, data, vec_reward, ext)
            require("src.layer.chapterend.ChapterEndCtr"):instance():openWindow({
                battle_type = layer.battle_type,
                is_win = layer.report.win_id == ex.Player.role_id,
                vec_reward = layer.vec_reward,
                detail = layer.report.log,
                data = layer.ext,
            })

            ex.EventManager:fire(EVENT.PLANE_WAR.CHALLENGE)
            return true, false
        end
    )

    ex.EventManager:fire(EVENT.PLANE_WAR.BATTLE_BOSS_BATTLE, data.report, ex.Tools:convertRewardList(data.reward), data)
end

function PlaneWarCtr:handlePlaneWarSweep(suibian, data)
    if self.data.challenge_count > 0 then
        self:setChallengeCount(self.data.challenge_count - 1)
    end

    ex.EventManager:fire(EVENT.PLANE_WAR.SWEEP)
end

function PlaneWarCtr:handlePlaneWarBuyCount(suibian, data)
    self:setChallengeCount(data.challenge_count)
    self.data.remaining_buy_count = data.remaining_buy_count or 0
    self.data.had_buy_count = data.had_buy_count or 0
    ex.EventManager:fire(EVENT.PLANE_WAR.UPDATE_TIMES)
end

function PlaneWarCtr:handlePlaneWarRank(suibian, data)
    if data.list then
        self.data.rank_list = clone(data.list)
    end

    if data.self_data then
        self.data.self_rank_data = clone(data.self_data)
    end

    ex.EventManager:fire(EVENT.PLANE_WAR.UPDATE_RANK)
end

function PlaneWarCtr:handlePrivilegeUpdate()
    if self.data.last_get_info_time == 0 then
        return
    end

    local privilege_data = ex.Player.promotion_data:getPrivilegeGiftByIdx(101000)
    local curtime = ex.Game:getServerTime()
    if privilege_data and privilege_data.end_time > 0 and privilege_data.end_time > self.data.privilege_expire_time then
        self:requestPlaneWarData()
    end
end

function PlaneWarCtr:getBuyConsume()
    local consume_config = cfg.planewarconsume.planewarconsume
    local buy_times = self.data.had_buy_count + 1
    local last_config = {}
    for k, v in ipairs(consume_config) do
        if buy_times == v.idx then
            return v.consume
        end
    end

    return nil
end

function PlaneWarCtr:getMissionsData(element, turn)
    local data = {}
    local missions = {}
    local boss_data = nil
    local battle_type = BattleType.PLANE_WAR_1

    local planewar_info_config = cfg.planewarinformation.planewarinformation[element]
    if planewar_info_config then
        battle_type = planewar_info_config.battle_type
    end

    for k, v in ipairs(cfg.planewarlevel.planewarlevel) do
        if element == v.element then
            if self.planewar_boss_list[v.idx][turn] then
                local pass_level = self.mission_pass[v.element] or 0
                local status = -1   -- -1为未解锁，0为当前未通且可挑战，1为已通关
                if v.level - pass_level == 1 then
                    status = 0
                elseif v.level - pass_level < 1 then
                    status = 1
                end

                local mission = {
                    idx = v.idx,
                    element = v.element,
                    boss_data = self.planewar_boss_list[v.idx][turn],
                    mission = v.level,
                    reward = v.reward,
                    status = status,
                    battle_type = battle_type
                }
                table.insert(missions, mission)
                if status == 0 or status == 1 then
                    boss_data = mission.boss_data
                end
            end
        end
    end
    
    data.missions = missions
    data.boss_data = boss_data
    data.element = element
    data.turn = turn
    return data
end

function PlaneWarCtr:setChallengeCount(count)
    self.data.challenge_count = count or 0
    if cfg.opencondition.condition["main_plane_war"].condition_value <= ex.Player.level and 
    ex.Player.world_level >= cfg.opencondition.condition["main_plane_war"].world_level then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YGZC_WMZZ, self.data.challenge_count > 0)
    end
end

function PlaneWarCtr:initData()
    self.data.challenge_count = 0
    self.data.remaining_buy_count = 0
    self.data.max_challenge_count = 0
    self.data.turn = 0
    self.data.instance_list = {}
    self.data.privilege_expire_time = -1
    self.data.had_buy_count = 0
    self.mission_pass = {}
end

return PlaneWarCtr
