local ClanResponse = class("ClanResponse")

function ClanResponse:clanInfo(data, byte_array)
    cpp.ResponseManager:instance():response(byte_array)

    ex.Player.clan_id = data.clan_id
    ex.Player.clan_data.clan_id = data.clan_id
    ex.Player.clan_data.clan_photo = data.clan_photo
    ex.Player.clan_data.clan_level = data.clan_level
    ex.Player.clan_data.clan_exp = data.clan_exp
    ex.Player.clan_data.clan_notice = data.clan_desc
    ex.Player.clan_data.clan_name = data.clan_name

    ex.Player.clan_data.clan_member_list = data.list
    if ex.Player.clan_data.clan_member_list == nil then
        ex.Player.clan_data.clan_member_list = {}
    end

    ex.Player.clan_data:checkBossReddot()
    ex.Player.clan_data:checkGvgReddot()
    ex.Player.clan_data:checkMissionReddot()
    ex.Player.clan_data:checkClanSkillReddot()

    --  刷新公会显示，跳转到公会信息界面
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_INFO)
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_MEMBER)
end

function ClanResponse:clanLastQuitTime(data)
    ex.Player.clan_data.last_join_time = data.time
end

function ClanResponse:clanUpdateAllInfo(data)
    -- 刷新公会信息
    NetManager:sendMessage(ProtocolID.GReqClanInfo)

    -- 请求公会历史列表
    NetManager:sendMessage(ProtocolID.GReqClanMsgInfo)

    -- 请求公会申请列表
    NetManager:sendMessage(ProtocolID.GResClanReqMsgInfo)
end

function ClanResponse:clanCreate(data)
    -- local data = NetManager:resLuaData(ProtocolResponse.ResClanCreate, byte_array)

    -- 0：创建成功   1：已加入公会  2：公会名字为空  3： 公会名字含有敏感字符  4：公会公告含有特殊字符 5 :名字重复，6：宝石不够。7:贵族等级不够
    if tonumber(data.error_code) == 0 then
        --  刷新公会显示，跳转到公会信息界面
        -- ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_INFO)
        NetManager:sendMessage(ProtocolID.GReqClanInfo)

        -- 请求公会历史列表
        NetManager:sendMessage(ProtocolID.GReqClanMsgInfo)

        -- 请求公会申请列表
        NetManager:sendMessage(ProtocolID.GReqClanReqMsgInfo)

        -- 请求公会科技列表
        NetManager:sendMessage(ProtocolID.GReqClanSkillList)

        -- 请求公会捐献列表
        NetManager:sendMessage(ProtocolID.GReqClanDonateList)

        require("src.platform.SocialPlatform"):submitRoleInfoLua("join_clan")
    elseif tonumber(data.error_code) == 1 then
        ex.MessageView:add(ex.Tools:getLang(47660))
    elseif tonumber(data.error_code) == 2 then
        ex.MessageView:add(ex.Tools:getLang(47405))
    elseif tonumber(data.error_code) == 3 then
        ex.MessageView:add(ex.Tools:getLang(47416))
    elseif tonumber(data.error_code) == 4 then
        ex.MessageView:add(ex.Tools:getLang(47342))
    elseif tonumber(data.error_code) == 5 then
        ex.MessageView:add(ex.Tools:getLang(47764))
    elseif tonumber(data.error_code) == 6 then
        ex.MessageView:add(ex.Tools:getLang(47222))
    elseif tonumber(data.error_code) == 7 then
        ex.MessageView:add(ex.Tools:getLang(47349))
    else
        ex.MessageView:add(ex.Tools:getLang(47493))
    end
end

function ClanResponse:clanQuit(data)
    -- local data = NetManager:resLuaData(ProtocolResponse.ResClanQuit, byte_array)

    NetManager:sendMessage(ProtocolID.GReqClanInfo)

    -- 请求上次公会退出时间，用来限制公会创建间隔
    NetManager:sendMessage(ProtocolID.GReqQuitClanTime)

    ex.Player.clan_data.clan_id = 0
    ex.Player.clan_data.clan_photo = 1

    --  刷新公会显示，跳转到公会信息界面
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_QUIT)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_GHJX, false)

    ex.Player.chat_data:resetClanChatData()
end

function ClanResponse:clanSearch(data)
    -- local data = NetManager:resLuaData(ProtocolResponse.ResClanSearch, byte_array)

    -- 获取列表
    ex.Player.clan_data.clan_search_list = {}
    local search_type = data.search_type
    local list_count = data.list_count
    print("res clan search list count: ", list_count)

    -- 刷新显示
    if search_type == 1 then
        ex.Player.clan_data.clan_recommend_list = data.list
        ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_RECOMMEND)
    else
        ex.Player.clan_data.clan_search_list = data.list
        ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_SEARCH)
    end
end

-- 申请加入成功
function ClanResponse:clanJoin(data)
    --  local data = NetManager:resLuaData(ProtocolResponse.ResClanJoin, byte_array)

    --  ex.MessageView:add(ex.Tools:getLang(47337))

    -- join_type = 2;	//0：加入成功， 1：待审核， 2：申请失败 3:公会人数已满
    if data.join_type >= 2 then
        -- 加入失败，服务端会报错
    else
        ex.MessageView:add(ex.Tools:getLang(1446))
        if data.join_type == 0 then
            NetManager:sendMessage(ProtocolID.GReqClanInfo)

            -- 请求公会科技列表
            NetManager:sendMessage(ProtocolID.GReqClanSkillList)

            -- 请求公会捐献列表
            NetManager:sendMessage(ProtocolID.GReqClanDonateList)

            -- 记录vip等级
            -- local save_key = string.format("%s-join_clan", ex.Player.role_id)
            -- if cc.UserDefault:getInstance():getIntegerForKey(save_key, 0) == 0 then
            require("src.platform.SocialPlatform"):submitRoleInfoLua("join_clan")
        -- cc.UserDefault:getInstance():setIntegerForKey(save_key, 1)
        -- end
        end
    end

    --  刷新公会显示，跳转到公会信息界面
    -- ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_INFO)
end

-- 接收操作军团消息提示响应
function ClanResponse:clanHistoryList(data)
    ex.Player.clan_data.clan_history_list = data.list

    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_HISTORY)
end

-- 响应成员入团请求
function ClanResponse:clanApplyList(data)
    ex.Player.clan_data.clan_apply_list = data.list

    -- 刷新申请界面
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_RANK_APPLY, data.list)

    local data_self = ex.Player.clan_data:getMemberByRoleId(ex.Player.role_id)
    if data_self and data_self.position ~= ClanPositionType.NORMAL then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_SQLB, #data.list > 0)
    end
end

-- 同意申请加入公会成功
function ClanResponse:clanApplyAgreeSucceed(data)
    if data.status == 1 then
        ex.MessageView:add(string.format(ex.Tools:getLang(47765), data.nick), 0)
    else
        ex.MessageView:add(string.format(ex.Tools:getLang(47512), data.nick), 0)
    end
end

-- 同意成员入团请求
function ClanResponse:clanMemberAgree(data)
    --  local data = NetManager:resLuaData(ProtocolResponse.ResClanMemberAgree, byte_array)

    ex.MessageView:add(ex.Tools:getLang(47337))

    -- 刷新申请界面
    NetManager:sendMessage(ProtocolID.GReqClanInfo)

    -- 请求公会科技列表
    NetManager:sendMessage(ProtocolID.GReqClanSkillList)

    -- 请求公会捐献列表
    NetManager:sendMessage(ProtocolID.GReqClanDonateList)
end

-- 响应升职操作
function ClanResponse:clanChangePos(data)
    -- local data = NetManager:resLuaData(ProtocolResponse.ResClanChangePos, byte_array)

    if data.status == 0 then
        ex.MessageView:add(ex.Tools:getLang(1453))
        return
    end
    -- 自己被踢
    if data.status == 2 then
        ex.MessageView:add(ex.Tools:getLang(47109))

        NetManager:sendMessage(ProtocolID.GReqClanInfo)

        ex.Player.clan_data.clan_id = 0
        ex.Player.clan_data.clan_photo = 1

        --  刷新公会显示，跳转到公会信息界面
        ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_QUIT)
    elseif data.status == 3 then
        -- 公会该职位成员数量已达上限
        ex.MessageView:add(ex.Tools:getLang(47122))
        return
    else
        NetManager:sendMessage(ProtocolID.GReqClanInfo)
    end
end

-- 公会技能
function ClanResponse:clanSkillList(data)
    ex.Player.clan_data.clan_skill_next_reset_times = data.next_refresh_times
    ex.Player.clan_data.clan_skill_list = {}
    for i, v in ipairs(data.list) do
        ex.Player.clan_data.clan_skill_list[v.profession_type] = v
    end

    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_SKILL_INFO)

    ex.Player.clan_data:checkClanSkillReddot()
end

-- 公会点亮
function ClanResponse:clanSkillLight(data)
    NetManager:sendMessage(ProtocolID.GReqClanSkillList)
end

function ClanResponse:clanSkillReset(data)
    NetManager:sendMessage(ProtocolID.GReqClanSkillList)
end

-- 公会捐献
function ClanResponse:clanDonateList(data)
    ex.Player.clan_data.donate_things = data.donate_thing
    if ex.Player.clan_data.donate_things == nil then
        ex.Player.clan_data.donate_things = 0
    end

    ex.Player.clan_data.total_donate_num = data.total_donate_num
    ex.Player.clan_data.clan_total_donate_list = data.total_donate_list
    if ex.Player.clan_data.clan_total_donate_list == nil then
        ex.Player.clan_data.clan_total_donate_list = {}
    end

    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_DONATE_INFO)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHGH_GHJX, ex.Player.clan_data:checkClanDonate())
end

-- 公会捐献分数奖励领奖
function ClanResponse:clanDonatePointReward(data)
    NetManager:sendMessage(ProtocolID.GReqClanDonateList)
end

-- 公会副本信息
function ClanResponse:clanMissionInfo(data)
    ex.Player.clan_data.clan_mission_cur_boss_idx = data.boss_idx
    ex.Player.clan_data.clan_boss_cur_hp = data.boss_hp
    ex.Player.clan_data.left_count = data.left_count or 0 -- 剩余攻击次数
    ex.Player.clan_data.attack_count = data.attack_count or 0 -- 已攻击次数
    ex.Player.clan_data.buy_count = data.buy_count or 0 -- 剩余可购买次数

    ex.Player.clan_data:checkMissionReddot()
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_MISSION_INFO)
end

-- 公会副本购买战斗次数
function ClanResponse:clanMissionBuyAccountDone(data)
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_MISSION_BUY_ACCOUNT_DONE)
end

-- 公会副本伤害排行
function ClanResponse:clanRankDamage(data)
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_RANK_DAMAGE, data.list)
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_MISSION_RANK, data.list)
end

function ClanResponse:clanMissionEnd(data)
    -- 刷新公会信息(主要为公会经验)
    NetManager:sendMessage(ProtocolID.GReqClanInfo)

    -- 刷新boss血量
    NetManager:sendMessage(ProtocolID.GReqClanMissionInfo)

    -- 刷新副本排行榜
    NetManager:sendMessage(ProtocolID.GReqClanRankDamage)

    -- 记录公会副本战斗奖励
    -- ex.Player.clan_data.clan_mission_battle_reward = data.list

    -- 播放战斗
    ctr.clan_battle:addBattleLayer()
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_MISSION_BATTLE, data.report, ex.Tools:convertRewardList(data.list), {report = data.report, isAwarded = data.isAwarded})
    ctr.clan_battle:showBattleLayer()
end

------------------------------公会战-----------------------------
-- 查看公会战信息
function ClanResponse:clanGvgInfo(data)
    -- GResScanWarInfo
    -- {round_start_time, round_end_time, stage, next_stage_time, war_infos{clan_id, name, server_id, roads{road, battling, total, alive}}}

    local now = ex.Game:getServerTime()

    ex.Player.clan_data.clan_gvg_info = clone(data)
    for i, v in ipairs(data.war_infos) do
        ex.Player.clan_data.clan_gvg_info.war_infos[i].roads = {}
        for i2, v2 in ipairs(v.roads) do
            ex.Player.clan_data.clan_gvg_info.war_infos[i].roads[v2.road] = v2
        end
    end

    if ex.Player.clan_data.clan_gvg_info.round_start_time > now or ex.Player.clan_data.clan_gvg_info.round_end_time < now then
    elseif ex.Player.clan_data.clan_gvg_info.stage == 1 then
    elseif ex.Player.clan_data.clan_gvg_info.stage == 5 then
        if table.nums(ex.Player.clan_data.clan_gvg_info.war_infos) >= 2 then
            NetManager:sendMessage(ProtocolID.GReqScanWarBox)
        end
    else
        if table.nums(ex.Player.clan_data.clan_gvg_info.war_infos) >= 2 then
            NetManager:sendMessage(ProtocolID.GReqScanRoadInfo)
        end
    end

    -- 更新场景显示
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_GVG_INFO)
    ex.Player.clan_data:checkGvgReddot()
end

-- 查看路况信息
function ClanResponse:clanGvgRoadInfo(data)
    -- GResScanRoadInfo
    -- details{road, teams{rid, name, hero_type, hero_level, hero_star, fighting}}

    -- dump(data, "ClanResponse:clanGvgRoadInfo")

    ex.Player.clan_data.clan_gvg_team_list = {}
    for i, v in ipairs(data.details) do
        ex.Player.clan_data.clan_gvg_team_list[v.road] = v.teams
    end

    -- 更新布阵界面
    require("src.layer.clan.ClanGvgLineupMemberCtr"):instance():updateScrollView()
    ex.Player.clan_data:checkGvgReddot()
end

-- 保存布阵数据
function ClanResponse:clanGvgRoadLineup(data)
    -- GResSaveRoadFormation
    -- {}

    -- 更新分路数据
    NetManager:sendMessage(ProtocolID.GReqScanRoadInfo)
    -- 更新场景数据
    NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
end

-- 保存布阵数据
function ClanResponse:clanGvgMemberInfo(data)
    -- GResScanMemberRoadInfo
    -- {}

    require("src.layer.RoleInfoCtr"):instance():openWindow(data)
end

-- 调整队伍出战分路与出战顺序
function ClanResponse:clanGvgRoadSort(data)
    -- GResAdjustRoadSort
    -- {road, sort}

    -- 更新分路数据
    NetManager:sendMessage(ProtocolID.GReqScanRoadInfo)
    -- 更新场景数据
    NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
end

-- 公会战路线信息改变的推送回调
function ClanResponse:clanGvgRoadInfoChange(data)
    -- GResRoadInfoChange
    if data.rid == ex.Player.role_id then
        return
    end

    -- 更新分路数据
    NetManager:sendMessage(ProtocolID.GReqScanRoadInfo)
    -- 更新场景数据
    NetManager:sendMessage(ProtocolID.GReqScanWarInfo)
end

-- 查看某一路的当前战况
function ClanResponse:clanGvgBattleInfo(data)
    -- GResScanBattlingInfo
    -- {battling{clan_id, teams{rid, name, hero_type, hero_level, hero_star, fighting}}, detail{}}

    -- dump(data, "ClanResponse:clanGvgBattleInfo")

    ex.Player.clan_data.clan_gvg_cur_history_list = data

    require("src.layer.clan.ClanGvgHistoryCtr"):instance():updateLayer()
end

-- 查看某一路的历史战况
function ClanResponse:clanGvgHistory(data)
    -- GResScanHisBattlingInfo
    -- his_info{battle_id, players{name, clan_id, rid, heros{ResHeroData}, win}}

    -- dump(data, "ClanResponse:clanGvgHistory")

    ex.Player.clan_data.clan_gvg_history_list = data.his_info

    require("src.layer.clan.ClanGvgHistoryCtr"):instance():updateLayer()
end

-- 公会历史状况有变化时，服务器向客户端的推送消息
function ClanResponse:clanGvgHistoryUpdate(data)
    -- GResWarBattleNext
    -- {}

    -- 根据当前打开的是那一路战况，请求更新对应数据
    require("src.layer.clan.ClanGvgHistoryCtr"):instance():reqRefresh()
end

-- 查看公会战宝箱
function ClanResponse:clanGvgBoxList(data)
    -- GResScanWarBox
    -- {box_number, box_type, box{position, name, item_type, item_num}}

    ex.Player.clan_data.clan_gvg_reward_info = clone(data)
    ex.Player.clan_data.clan_gvg_reward_info.box = {}
    for i, v in ipairs(data.box) do
        ex.Player.clan_data.clan_gvg_reward_info.box[v.position] = v
    end

    require("src.layer.clan.ClanGvgRewardCtr"):instance():updateTableView()
    ex.Player.clan_data:checkGvgReddot()
end

-- 打开公会战宝箱
function ClanResponse:clanGvgOpenBox(data)
    -- GResOpenWarBox
    -- {box_number, box{position, name, item_type, item_num}}

    -- NetManager:sendMessage(ProtocolID.GReqScanWarBox)

    ex.Player.clan_data.clan_gvg_reward_info.box_number = data.box_number
    ex.Player.clan_data.clan_gvg_reward_info.box = {}
    for i, v in ipairs(data.box) do
        ex.Player.clan_data.clan_gvg_reward_info.box[v.position] = v
    end

    require("src.layer.clan.ClanGvgRewardCtr"):instance():updateCell()
    ex.Player.clan_data:checkGvgReddot()
end

-- 公会其他成员打开宝箱的回调
function ClanResponse:clanGvgMemberOpenBox(data)
    -- GResMemberOpenBox
    -- {}

    if require("src.layer.clan.ClanGvgRewardCtr"):instance().layer ~= nil then
        NetManager:sendMessage(ProtocolID.GReqScanWarBox)
    end
end

------------------------------公会BOSS战-----------------------------

-- 查看公会世界BOSS信息
function ClanResponse:clanBossInfo(data)
    -- GResScanWorldBoss
    -- {boss_id, challenge_count, challenge_cd, rob_count, rob_cd, stage, next_stage_time, round_start_time, round_end_time}

    -- dump(data, "ClanResponse:clanBossInfo")

    ex.Player.clan_data.clan_boss_info = data
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_INFO)

    if ex.Player.clan_data.clan_boss_info.stage == 1 then
    elseif ex.Player.clan_data.clan_boss_info.stage == 3 and ex.Player.clan_data.clan_id > 0 then
        NetManager:sendMessage(ProtocolID.GReqGetRobableRole)
    end

    ex.Player.clan_data:checkBossReddot()
end

-- 挑战公会世界BOSS
function ClanResponse:clanBossChallenge(data)
    -- GResChallengeBoss
    -- {challenge_count, challenge_cd}

    local boss_name = ""
    local boss_info = ex.Player.clan_data.clan_boss_info
    local config = cfg.clanworldboss.clanworldboss[boss_info.boss_id]
    if config then
        data.report.defender.name = ex.Tools:getLang(config.boss_type)
    end

    ex.Player.clan_data.clan_boss_info.challenge_count = data.challenge_count
    ex.Player.clan_data.clan_boss_info.challenge_cd = data.challenge_cd
    ex.Player.clan_data:checkBossReddot()

    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_BATTLE, data.report, {add_point = data.addPoint, damage = data.damage}, data.report)

    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_INFO)

    NetManager:sendMessage(ProtocolID.GReqScanClanRank)
    NetManager:sendMessage(ProtocolID.GReqScanRoleRank)
end

-- 查看可掠夺的玩家列表
function ClanResponse:clanBossRobList(data)
    -- GResGetRobableRole
    -- roles{rid, nick, fighting, clan_name, heros{}, point, rank}
    ex.Player.clan_data.clan_boss_plunder_list = data.roles
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_BATTLE_ROB_LIST)
end

-- 查看掠夺战报
function ClanResponse:clanBossRobHistory(data)
    -- GResScanRobHis
    -- roles{rid, nick, fighting, clan_name, heros{}, point, rank}
    ex.Player.clan_data.clan_boss_history_list = data.records

    require("src.layer.clan.ClanBossHistoryCtr"):instance():updateLayer()
end

-- 掠夺战报已读
function ClanResponse:clanBossRobHistoryRead(data)
    -- GResReadNewRecord

    -- 请求刷新红点
    NetManager:sendMessage(ProtocolID.GReqScanWorldBoss)
end

-- 掠夺公会世界BOSS的玩家积分
function ClanResponse:clanBossRobRole(data)
    -- GResRobOtherRole
    -- {rob_count, rob_cd}

    ex.Player.clan_data.clan_boss_info.rob_count = data.rob_count
    ex.Player.clan_data.clan_boss_info.rob_cd = data.rob_cd
    ex.Player.clan_data:checkBossReddot()

    -- ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_INFO)
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_BATTLE_ROB_REPORT, data.report, {add_point = data.addPoint or 0, damage = data.damage or 0}, data.report)

    -- 刷新红点
    NetManager:sendMessage(ProtocolID.GReqScanWorldBoss)
    -- 刷新排行榜
    NetManager:sendMessage(ProtocolID.GReqScanClanRank)
    NetManager:sendMessage(ProtocolID.GReqScanRoleRank)
    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_INFO)
end

-- 玩家被抢夺推送回调
function ClanResponse:clanBossRobByOther(data)
    -- GResRobByOtherRole

    if ex.Player.clan_data.clan_id ~= NULL_ID then
        -- 刷新红点
        NetManager:sendMessage(ProtocolID.GReqScanWorldBoss)
        -- 刷新历史列表
        NetManager:sendMessage(ProtocolID.GReqGetRobableRole)
    end
end

-- 查看公会排名
function ClanResponse:clanBossRankClan(data)
    -- GResScanClanRank
    -- {my_clan{clan_id, clan_name, rank, point}, ranks{clan_id, clan_name, rank, point}}

    -- dump(data, "ClanResponse:clanBossRankClan")

    ex.Player.clan_data.clan_boss_rank_clan.my_rank = data.my_clan
    ex.Player.clan_data.clan_boss_rank_clan.ranks = {}

    for i, v in ipairs(data.ranks) do
        ex.Player.clan_data.clan_boss_rank_clan.ranks[v.rank] = v
    end

    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_RANK)
end

-- 查看玩家排名
function ClanResponse:clanBossRankPlayer(data)
    -- GResScanRoleRank
    -- {my_rank{rid, nick, rank, point}, ranks{rid, nick, rank, point}}

    -- dump(data, "ClanResponse:clanBossRankPlayer")

    ex.Player.clan_data.clan_boss_rank_player.my_rank = data.my_rank
    ex.Player.clan_data.clan_boss_rank_player.ranks = {}

    for i, v in ipairs(data.ranks) do
        ex.Player.clan_data.clan_boss_rank_player.ranks[v.rank] = v
    end

    ex.EventManager:fire(EVENT.CLAN_EVENT.CLAN_BOSS_RANK)
end

-- 玩家排名改变推送回调
function ClanResponse:clanBossRankChange(data)
    -- GResBossPointChange

    if ex.Player.clan_data.clan_id ~= NULL_ID then
        NetManager:sendMessage(ProtocolID.GReqScanClanRank)
        NetManager:sendMessage(ProtocolID.GReqScanRoleRank)
    end
end

return ClanResponse
