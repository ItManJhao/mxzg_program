local LeagueResponse = class("LeagueResponse")


function LeagueResponse:handleLadderInfo(data)
    ex.Player.league_data:receiveLadderInfo()

    ex.Player.league_data:changeSelfRank(data.my_rank)
    
    ex.Player.league_data:refreshVSTimes(data.battle_times)

    ex.Player.league_data:refreshBuyTimes(data.had_buy_times, data.buy_times)

    ex.Player.league_data:refreshVSPlayerData(data.defends)
end

function LeagueResponse:handleRefreshDefends(data)
    ex.Player.league_data:receiveLadderInfo()

	ex.Player.league_data:refreshVSPlayerData(data.defends)
end

function LeagueResponse:handleLadderChallenge(data)
    ex.EventManager:fire(EVENT.LADDER_EVENT.BATTLE_RESULT, data)

    ex.Player.league_data:receiveLadderInfo()
    
    ex.Player.league_data:changeSelfRank(data.self_rank)

    ex.Player.league_data:refreshVSPlayerData(data.defends)

    ex.Player.league_data:refreshVSTimes(data.battle_times)
end

function LeagueResponse:handleLadderOneKeyChallenge(data)
	ex.Player.league_data:refreshVSTimes(data.battle_times)
end

function LeagueResponse:handleMyLadderBattleRecord(data)
    ex.Player.league_data.history_my = data.battle_defend_info
    table.sort(ex.Player.league_data.history_my, function(a, b)
        return a.battle_time > b.battle_time
    end)
	require("src.layer.LadderHistoryCtr"):instance():updateLayer(1)
end

function LeagueResponse:handleMyLadderBattleRecordRead(data)
	for i,v in ipairs(ex.Player.league_data.history_my) do
        v.is_read = 1
    end

    ex.Player.league_data:checkReportRedDot()
end

function LeagueResponse:handleHighLadderBattleRecord(data)
    ex.Player.league_data.history_high = data.battle_defend_info
    table.sort(ex.Player.league_data.history_high, function(a, b)
        return a.battle_time > b.battle_time
    end)
	require("src.layer.LadderHistoryCtr"):instance():updateLayer(2)
end

function LeagueResponse:handleBuyTimes(data)
    ex.Player.league_data:receiveLadderInfo()

    ex.Player.league_data:refreshVSTimes(data.battle_times)

    ex.Player.league_data:refreshBuyTimes(data.had_buy_times, data.buy_times)
end

function LeagueResponse:rankLadderList(data)
    ex.Player.rank_data.rank_ladder_self = data.self_data
    
    if data.page <= 1 then
        ex.Player.rank_data.rank_ladder_list = {}
    end

    for i,v in ipairs(data.list) do
        table.insert(ex.Player.rank_data.rank_ladder_list, v)
    end

    if data.send_status < 1 then
        local req = Ladder_pb.GReqLadderRank()
		req.page = data.page + 1
        NetManager:sendMessage(ProtocolID.GReqLadderRank, req)
        return
    end

	require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end

function LeagueResponse:likeList(data)
    ex.Player.rank_data.rank_ladder_like_list = data.like_data

    ex.Player.rank_data:checkLadderHeroTempleRedDot()
    
    ex.EventManager:fire(EVENT.LADDER_EVENT.REFRESH_HERO_TEMPLE)
end

function LeagueResponse:handleLadderLineUpData(data)
    require("src.layer.LadderChallengeCtrl"):instance():refreshTeam(data)
end

function LeagueResponse:handleRedDotList(data)
	for k,v in pairs(data.red_list) do
        ex.RedDotManager:setRedNodeVisible(v, true)
        print(ex.Tools:getLang(47321)..tostring(v))
    end
end

function LeagueResponse:beLikeSuperior(data)
    -- 后端不愿意添加通用的点赞列表。我只能这样了
    table.insert(ex.Player.rank_data.worship_list,{type=99, nick=data.like_name})
end


return LeagueResponse