local LeagueData = class("LeagueData")

function LeagueData:ctor()
    self.ladder_main_data_is_dirty = true
    self.ladder_main_data = {
        my_rank = 0,
        vs_times = 0,
        buy_cur_times = 0,
        buy_remain_times = 0,
        defenders = {}
    }

    self.history_my = {}
    self.history_high = {}
end

function LeagueData:getRankRewardConfigByRank(rank)
    for i,v in ipairs(cfg.serverladderrankreward.reward) do
        if v.rank_up >= rank and v.rank_low <= rank then
            return v
        end
    end
    return nil
end

function LeagueData:receiveLadderInfo()
    self.ladder_main_data_is_dirty = false
end

function LeagueData:changeSelfRank(rank)
    self.ladder_main_data.my_rank = rank

    ex.EventManager:fire(EVENT.LADDER_EVENT.REFRESH_MY_RANK)
end

function LeagueData:refreshVSTimes(times)
    self.ladder_main_data.vs_times = times

    ex.EventManager:fire(EVENT.LADDER_EVENT.REFRESH_VS_TIMES)
    
    local is_open = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_ladder_war")
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_TTZB, times > 0 and self:isOpenLadderWar() and is_open)
end

function LeagueData:refreshBuyTimes(cur_times, remain_times)
    self.ladder_main_data.buy_cur_times = cur_times
    self.ladder_main_data.buy_remain_times = remain_times

    ex.EventManager:fire(EVENT.LADDER_EVENT.REFRESH_BUY_TIMES)
end

function LeagueData:refreshVSPlayerData(defenders)
    if defenders == nil then return end

    self.ladder_main_data.defenders = {}
    self.ladder_main_data.defenders = defenders

    table.sort(self.ladder_main_data.defenders, function(a, b)
        return a.rank < b.rank
    end)

    ex.EventManager:fire(EVENT.LADDER_EVENT.REFRESH_VS_PLAYER)
end

function LeagueData:isOpenLadderWar()
    return self:getRemainStartTimeForLadder() <= 0 and self:getRemainEndTimeForLadder() > 0
end

function LeagueData:getRemainStartTimeForLadder()
    local passed_time = ex.Tools:getWeekPassedTime()

    local times = string.split(cfg.system.cross_server_ladder_open_time, "_")

    return tonumber(times[1]) - passed_time
end

function LeagueData:getRemainEndTimeForLadder()
    local passed_time = ex.Tools:getWeekPassedTime()

    local times = string.split(cfg.system.cross_server_ladder_open_time, "_")

    return tonumber(times[2]) - passed_time
end


------------------------------------请求协议------------------------------
-- 请求挑战
function LeagueData:reqChallenge(player_id)
    local req = Ladder_pb.GReqLadderChallenge()
    req.defend_id = player_id
    NetManager:sendMessage(ProtocolID.GReqLadderChallenge, req)
end

-- 请求购买挑战次数
function LeagueData:reqBuyVSTimes()
    NetManager:sendMessage(ProtocolID.GReqBuyTimes)
end

-- 请求天梯信息
function LeagueData:reqLadderInfo()
    local req = Ladder_pb.GReqLadderInfo()
    NetManager:sendMessage(ProtocolID.GReqLadderInfo, req)

    self.ladder_main_data_is_dirty = true
end

-- 请求刷新可挑战
function LeagueData:reqRefreshDefends()
    NetManager:sendMessage(ProtocolID.GReqRefreshDefends)

    self.ladder_main_data_is_dirty = true
end

-- 请求一键挑战
function LeagueData:reqLadderOneKeyChallenge()
    NetManager:sendMessage(ProtocolID.GReqLadderOneKeyChallenge)
end

-- 请求玩家阵容数据
function LeagueData:reqLadderLineUpData(rid)
    local req = Ladder_pb.GReqLadderLineUpData()
    req.rid = rid
    
    NetManager:sendMessage(ProtocolID.GReqLadderLineUpData, req)
end

function LeagueData:checkReportRedDot()
    local has_unread = false
    for i,v in ipairs(self.history_my) do
        if v.is_read <= 0 then
            has_unread = true
            break
        end
    end
    
    local is_open = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_ladder_war")
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_TTZB_ZB, has_unread and is_open)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_TTZB_ZB_WDJL, has_unread and is_open)
end

return LeagueData
