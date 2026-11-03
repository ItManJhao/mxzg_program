local SuperStageResponse = class("SuperStageResponse")

----------------------------------常规赛-----------------------------------
-- 初始信息
function SuperStageResponse:superStageInfo(data)
	-- GResStageMatchData

	local super_stage_data = ex.Player.super_stage_data

	super_stage_data.cur_season = data.season
    super_stage_data.season_start_time = data.start_time
    super_stage_data.match_end_time = data.end_time
    super_stage_data.season_end_time = data.settlement_time
    super_stage_data.top1_start_time = data.preliminaries_time
    super_stage_data.top2_start_time = data.final_time
    super_stage_data.cur_stage_id = data.stage_id
    super_stage_data.integral = data.integral
    super_stage_data.elite_integral = data.elite_integral
    super_stage_data.battle_times_left = data.matches
    super_stage_data.battle_times_buy_left = data.remaining_purchases
    super_stage_data.rank = data.rank
    super_stage_data.reward_idx = data.received_id
    super_stage_data.qualifying_match = data.qualifying_match
	super_stage_data.vec_advance_result = data.record
	super_stage_data.is_matching = data.matching
    super_stage_data.pinnacle_stage = data.pinnacle_stage
    super_stage_data.preliminary_qualification = data.preliminary_qualification or false
    super_stage_data.season_down_start_time = data.second_start_time or 0
	
	ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_INFO)

	super_stage_data:checkReddot()
    super_stage_data:checkTopReddot()
    
    -- 涉及紅點，需要預加載預賽部分數據
    if super_stage_data.pinnacle_stage == 5 then
        NetManager:sendMessage(ProtocolID.GResPreliminaries)
    end
end

-- 战斗匹配成功，显示对手信息
function SuperStageResponse:superStageMatch(data)
	-- GResMatchOpponent

    if data.match_info ~= nil and data.match_info.stage_id > 0 then
		local super_stage_data = ex.Player.super_stage_data

		super_stage_data.battle_times_left = data.matches
		super_stage_data.battle_times_buy_left = data.remaining_purchases
		ex.EventManager:fire(EVENT.SUPER_STAGE.ADD_MATCH_TIMES)
	end

	if data.language_id > 0 then
		ex.MessageView:add(ex.Tools:getLang(data.language_id))

		ex.EventManager:fire(EVENT.SUPER_STAGE.MATCH_SUCCESS, nil)
	else
		ex.EventManager:fire(EVENT.SUPER_STAGE.MATCH_SUCCESS, data.match_info)
	end
end

-- 獲取刷新对手信息
function SuperStageResponse:superStageMatchPlayerInfo(data)
	-- GResMatchInfo
	
	ex.EventManager:fire(EVENT.SUPER_STAGE.MATCH_PLAYER_INFO, data.match_info)
end

-- 购买战斗匹配次数
function SuperStageResponse:superStageMatchAddTimes(data)
	-- GResPurchases

	local super_stage_data = ex.Player.super_stage_data

    super_stage_data.battle_times_left = data.matches
	super_stage_data.battle_times_buy_left = data.remaining_purchases

	ex.MessageView:add(ex.Tools:getLang(74942))
	
	ex.EventManager:fire(EVENT.SUPER_STAGE.ADD_MATCH_TIMES)

	ex.Player.super_stage_data:checkReddot()
end

-- 战斗开始
function SuperStageResponse:superStageMatchBattle(data)
	-- GResChallenge

	ex.EventManager:fire(EVENT.SUPER_STAGE.MATCH_BATTLE, data)
end

function SuperStageResponse:superStageFirstReward(data)
	-- GResReceiveAward

	ex.Player.super_stage_data.reward_idx = data.received_id
	
	ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_INFO)

	ex.Player.super_stage_data:checkReddot()
end

function SuperStageResponse:superStageRankInfo(data)
	-- GResRankInfo

	ex.Player.super_stage_data.rank_list = data.rankInfo
	ex.Player.super_stage_data.rank_self = data.selfRank

	ex.EventManager:fire(EVENT.SUPER_STAGE.RANK_INFO)
end

-- 我的战斗记录
function SuperStageResponse:superStageBattleLog(data)
	-- GResMyVideo
	-- 按时间排序， 时间大的排前面
	if data and data.log and #data.log > 1 then
		table.sort(data.log, function (a, b)
			return a.battle_time > b.battle_time
		end)
	end
	ex.Player.super_stage_data.vec_battle_log = data.log

	ex.EventManager:fire(EVENT.SUPER_STAGE.BATTLE_LOG)
end

-- 大神战斗记录
function SuperStageResponse:superStageSuperBattleLog(data)
	-- GResGreatStyle
	-- 按时间排序， 时间大的排前面
	if data and data.log and #data.log > 1 then
		table.sort(
			data.log,
			function(a, b)
				return a.battle_time > b.battle_time
			end
		)
	end

	ex.Player.super_stage_data.vec_super_battle_log = data.log
	
	ex.EventManager:fire(EVENT.SUPER_STAGE.SUPER_BATTLE_LOG)
end

-- 赛季传奇
function SuperStageResponse:superStageLegendList(data)
	-- GResSeasonLegend

	ex.EventManager:fire(EVENT.SUPER_STAGE.LEGEND_LIST, data)
end

-- 战令信息
function SuperStageResponse:superStageTokenInfo(data)
	-- GResStageToken
	ex.Player.super_stage_data.token_info = data

	ex.EventManager:fire(EVENT.SUPER_STAGE.TOKEN_INFO)

	ex.Player.super_stage_data:checkReddot()
end

-- 战令领奖
function SuperStageResponse:superStageTokenGetReward(data)
	-- GResStageTokenGetReward

	NetManager:sendMessage(ProtocolID.GReqStageToken)
end

-- 赛季战报
function SuperStageResponse:superStageDetailSeason(data)
	-- GResDetailSeason

	ex.EventManager:fire(EVENT.SUPER_STAGE.SEASON_LOG, data.season, data.max_season_id)
end

----------------------------------巅峰赛预赛-----------------------------------
-- 巅峰赛预赛信息
function SuperStageResponse:topLadderInfo(data)
    -- GResPreliminaries

	local super_stage_data = ex.Player.super_stage_data

    super_stage_data.ladder_main_data.rank = data.rank
    super_stage_data.top_battle_times_left = data.remaining_times
    super_stage_data.top_battle_times_buy_left = data.remaining_purchases
    super_stage_data.like_rank = data.like_rank or {}

    super_stage_data:refreshVSPlayerData(data.opponent)

	super_stage_data:checkTopReddot()
    
    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_TOP_INFO)
end

-- 巅峰赛预赛刷新对手
function SuperStageResponse:topRefreshOpponent(data)
    -- GResRefreshOpponent

	local super_stage_data = ex.Player.super_stage_data

    super_stage_data:refreshVSPlayerData(data.opponent)

    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_TOP_INFO)
end

-- 巅峰赛预赛对手信息
function SuperStageResponse:topOpponentInfo(data)
    -- GResPinnacleLineData

    ex.EventManager:fire(EVENT.SUPER_STAGE.TOP_OPPONENT_INFO, data)
end

-- 巅峰赛预赛挑战对手
function SuperStageResponse:topLadderChallenge(data)
    -- GResChallengeOpponent

	ex.EventManager:fire(EVENT.SUPER_STAGE.CHALLENGE_BACK, data)
end

-- 巅峰赛预赛战报
function SuperStageResponse:topMyLadderBattleRecord(data)
    -- GResPreliminariesRecord
    
    ex.Player.super_stage_data.vec_top_battle_log = data.record
    table.sort(ex.Player.super_stage_data.vec_top_battle_log, function(a, b)
        return a.battle_time > b.battle_time
	end)
	
	ex.EventManager:fire(EVENT.SUPER_STAGE.TOP_BATTLE_LOG)
end

-- 巅峰赛预赛大神风采
function SuperStageResponse:topHighLadderBattleRecord(data)
    -- GResGreatDemeanor

    ex.Player.super_stage_data.vec_top_super_battle_log = data.demeanor
    table.sort(ex.Player.super_stage_data.vec_top_super_battle_log, function(a, b)
        return a.battle_time > b.battle_time
	end)
	
	ex.EventManager:fire(EVENT.SUPER_STAGE.TOP_SUPER_BATTLE_LOG)
end

-- 巅峰赛预赛购买挑战次数
function SuperStageResponse:topBuyTimes(data)
    -- GResPreliminariesPurchases

    local super_stage_data = ex.Player.super_stage_data
    
    super_stage_data.top_battle_times_left = data.remaining_times
    super_stage_data.top_battle_times_buy_left = data.remaining_purchases

	ex.EventManager:fire(EVENT.SUPER_STAGE.ADD_TOP_MATCH_TIMES)
end

----------------------------------巅峰赛决赛-----------------------------------
-- 巅峰赛决赛信息
function SuperStageResponse:top2Info(data)
    -- GResScanPinnacle
    
	local super_stage_data = ex.Player.super_stage_data

    super_stage_data.worship_count = data.like
    super_stage_data.top_rank_max = data.his_rank
    super_stage_data.top_rank = data.rank
    super_stage_data.battle_start_time = data.battle_start_time
    super_stage_data.start_time = data.start_time
    super_stage_data.end_time = data.end_time
    super_stage_data.like_rank = data.like_rank
    super_stage_data.biu_cd = data.biu_cd
    super_stage_data.my_result = data.result
    super_stage_data.show_round = data.show_round
    super_stage_data.battle_round = data.battle_round

    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_SHOW_LAYER)

    if super_stage_data.my_result.rank ~= 0 then
        local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_super_stage")
        if isOpen == true and require("src.scene.MainSceneCtr"):instance():getMainScene() ~= nil then
            NetManager:sendMessage(ProtocolID.GReqPinnacleShowMyResult)

            require("src.layer.superstage.SuperStageTopPreRewardCtr"):instance():openWindow(super_stage_data.my_result.rank,
                                                                                            super_stage_data.my_result.battle_num,
                                                                                            super_stage_data.my_result.win_num,
                                                                                            ex.Player.nick,
                                                                                            function()
                                                                                                if super_stage_data.show_round ~= 0 then
                                                                                                    NetManager:sendMessage(ProtocolID.GReqPinnacleShowTop)
                                                                                                end
                                                                                            end)
        end
    else
        if data.show_round ~= 0 then
            NetManager:sendMessage(ProtocolID.GReqPinnacleShowTop)
        end
    end

    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

-- 巅峰赛决赛竞猜
function SuperStageResponse:guessTop2Battle(data)
    -- GResGuessPinnacleBattle
    
    ex.Player.super_stage_data.guess = data
    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_GUESS)
    local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_super_stage")

    print("ex.MainSceneCtr:getCurLayerType()", ex.MainSceneCtr:getCurLayerType(), MainSceneType.MAINCITY_SUPER_STAGE_TOP)
    if isOpen and ex.Player.super_stage_data.guess.stage == 2 and require("src.scene.MainSceneCtr"):instance():getMainScene() ~= nil and ex.MainSceneCtr:getCurLayerType() ~= MainSceneType.MAINCITY_SUPER_STAGE_TOP then
        -- 提示
        require("src.layer.BetTipCtr"):instance():openWindow(ex.Tools:getSysCfg("topmatch_jump_show"), 
                                                             ex.Tools:getLang(75994),
                                                             tonumber(ex.Tools:getSysCfg("topmatch_jump_last")),
                                                             function()
                                                                local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_SUPER_STAGE_TOP)
                                                                if layer then
                                                                    layer.selected_type = 2
                                                                    layer:updateLayerType()
                                                                    layer:updateTitle()
                                                                    return true
                                                                end
                                                                return false
                                                            end)
    end
end

-- 巅峰赛决赛竞猜
function SuperStageResponse:guessTop2OneBattle(data)
    -- GResGuess

    ex.Player.super_stage_data.guess.guess_coin = data.guess_coin
    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_GUESS)
    NetManager:sendMessage(ProtocolID.GReqGuessPinnacleBattle)
end

-- 巅峰赛决赛挑战队列
function SuperStageResponse:top2Knockout(data)
    -- GResScanPinnacleKnockout
    
	local super_stage_data = ex.Player.super_stage_data

    super_stage_data.guess_id = data.guess_id
    -- super_stage_data.battle_round = data.battle_round
    super_stage_data.battle_next_time = data.next_time
    super_stage_data.battle_stage = data.stage
    super_stage_data.battle_round = data.battle_round

    super_stage_data.knockout_data = {}
    for i, v in ipairs(data.battles) do
        if super_stage_data.knockout_data[v.battle_round] == nil then
            super_stage_data.knockout_data[v.battle_round] = {}
        end
        table.insert(super_stage_data.knockout_data[v.battle_round], v)
    end

    super_stage_data.knockout_block1 = {}
    -- 对战数据进行重新编队。方便界面显示.可能要迁移到super_stage_data中
    -- 生成16页128强数据每页包含 16个32强。8个16强。4个4强。2个2强
    for i=1, 16 do
        super_stage_data.knockout_block1[i] = {}
        for idx,v in ipairs(super_stage_data.knockout_idx) do
            -- local num = 2 ^ (table.nums(super_stage_data.knockout_idx) - idx - 2)
            local num = 2 ^ (5 - idx - 2)
            if num >= 1  then
                super_stage_data.knockout_block1[i][num * 2] = {}
            end
            for j=1, num do
                local tmp_data = super_stage_data.knockout_data[v]
                if tmp_data then
                    tmp_data = tmp_data[(i - 1) * num + j]
                end
                table.insert(super_stage_data.knockout_block1[i][num * 2], tmp_data)
            end
        end
    end

    -- 生成2页16强数据
    super_stage_data.knockout_block2 = {}
    super_stage_data.knockout_block2[1] = {}
    super_stage_data.knockout_block2[2] = {}
    for i=1, 3 do
        local num = (2 ^ i)
        super_stage_data.knockout_block2[1][num] = {}
        super_stage_data.knockout_block2[2][num] = {}
        local tmp_data = super_stage_data.knockout_data[num * 2]
        if tmp_data then
            for ip,v in ipairs(tmp_data) do
                if math.floor((ip - 1) / (num / 2)) + 1 <= 2 then
                    table.insert(super_stage_data.knockout_block2[math.floor((ip - 1) / (num / 2)) + 1][num], v)
                end
            end
        end
    end

    -- 生成2页16强数据
    super_stage_data.knockout_block3 = {}
    local num = 2
    super_stage_data.knockout_block3[num] = {}
    local tmp_data = super_stage_data.knockout_data[num]
    if tmp_data then
        for ip,v in ipairs(tmp_data) do
            table.insert(super_stage_data.knockout_block3[num], v)
        end
    end

    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_KNOCKOUT)
    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_MAIN)
end

-- 巅峰赛决赛个人挑战历史
function SuperStageResponse:myTop2Battle(data)
    -- GResMyPinnacleBattle

	local super_stage_data = ex.Player.super_stage_data

    super_stage_data.my_champion = data
    if super_stage_data.my_old_battle_id == nil then
        super_stage_data.my_old_battle_id = super_stage_data.my_champion.battle_id
    end

    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_MY_CHAMPION)
    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_MAIN)
end

-- 巅峰赛預賽赛点赞
function SuperStageResponse:topLike(data)
    -- GResPreliminariesLike

    ex.Player.super_stage_data:addLike(data.rid)
    ex.Player.super_stage_data:addLikeCount(data.rid)

    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_LIKE)
end

-- 巅峰赛决赛点赞
function SuperStageResponse:top2Like(data)
    -- GResPinnacleLike

    ex.Player.super_stage_data:addLike(data.rid)
    ex.Player.super_stage_data:addLikeCount(data.rid)

    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_LIKE)
end

-- 巅峰赛决赛弹幕cd
function SuperStageResponse:top2Biubiu(data)
    -- GResPinnacleBiubiu

    ex.MessageView:add(ex.Tools:getLang(70776))

    ex.Player.super_stage_data.biu_cd = data.biu_cd
end

-- 巅峰赛决赛获取战报信息
function SuperStageResponse:getTop2Battle(data)
    -- GResGetPinnacleBattle
    
    -- 战斗信息无效
    if data.battle_id == "" then
        return
    end

    local req_battle = Battle_pb.GReqBattleReport()
    req_battle.type = EVENT.SUPER_STAGE.BATTLE_REPORT
    req_battle.battle_id = data.battle_id
    NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)
end

-- 巅峰赛决赛弹幕列表
function SuperStageResponse:top2BiuList(data)
    -- GResPinnacleBiuList

    ex.Player.super_stage_data.vec_biu = {}
    for i,v in ipairs(data.content) do
        local tmp_data = {}
        tmp_data.is_my = v.rid == ex.Player.role_id
        tmp_data.content = v.content
        table.insert(ex.Player.super_stage_data.vec_biu, tmp_data)
    end

    ex.EventManager:fire(EVENT.SUPER_STAGE.START_BIU)
end

-- 巅峰赛决赛添加弹幕
function SuperStageResponse:top2BiuChange(data)
    -- GResPinnacleBiuChange

    local tmp_data = {}
    tmp_data.is_my = data.content.rid == ex.Player.role_id
    tmp_data.content = data.content.content
    table.insert(ex.Player.super_stage_data.vec_biu, tmp_data)

    ex.EventManager:fire(EVENT.SUPER_STAGE.ADD_BIU, tmp_data)
end

-- 巅峰赛决赛清楚弹幕推送
function SuperStageResponse:top2CleanBiu(data)
    -- GResPinnacleCleanBiu

    ex.Player.super_stage_data.vec_biu = {}
    ex.EventManager:fire(EVENT.SUPER_STAGE.CLEAN_BIU)
end

-- 巅峰赛决赛竞猜列表
function SuperStageResponse:top2GuessList(data)
    -- GResPinnacleGuessList

    ex.Player.super_stage_data.guess_record = TableEx.reverseTable(data.record)

    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_GUESS_LIST)
end

-- 巅峰赛决赛我的比赛记录
function SuperStageResponse:myTop2BattleInfo(data)
    -- GResScanMyPinnacleBattle

    ex.Player.super_stage_data.my_champion_battle = data.battles

    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_MY_CHAMPION_BATTLE)
end

-- 巅峰赛决赛竞猜奖励推送
function SuperStageResponse:top2GuessWin(data)
    -- GResPinnacleGuessWin

    if require("src.scene.MainSceneCtr"):instance():getMainScene() == nil then
        return
    end

    local str_title = string.format(ex.Tools:getLang(47488), ex.Player.super_stage_data:getTopTitle(data.battle_round))

    require("src.layer.superstage.SuperStageTopRewardCtr"):instance():openWindow(
                     str_title,
                     {{item_type=901302, item_num=data.gain_coin}})
end

-- 巅峰赛决赛阶段改变推送
function SuperStageResponse:top2StageChange(data)
    -- GResPinnacleStageChange

    if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_super_stage") ~= true then
        return
    end
    
	if ex.Player.super_stage_data.guess and 
		ex.Player.super_stage_data.guess.stage == 2 and 
		ex.MainSceneCtr:getCurLayerType() ~= MainSceneType.MAINCITY_SUPER_STAGE_TOP then
        -- NetManager:sendMessage(ProtocolID.GReqScanPinnacle)
        NetManager:sendMessage(ProtocolID.GReqGuessPinnacleBattle)
    else
        NetManager:sendMessage(ProtocolID.GReqScanPinnacle)
        NetManager:sendMessage(ProtocolID.GReqScanPinnacleKnockout)
        NetManager:sendMessage(ProtocolID.GReqGuessPinnacleBattle)
        NetManager:sendMessage(ProtocolID.GReqMyPinnacleBattle)
    end
    ex.EventManager:fire(EVENT.SUPER_STAGE.STAGE_BECHANGE)
end

-- 巅峰赛預賽排行榜
function SuperStageResponse:topRank(data)
    -- GResPreliminariesRank

    ex.Player.super_stage_data.vec_top_rank = data.ranks

    ex.EventManager:fire(EVENT.SUPER_STAGE.RANK_INFO, data)
end

-- 巅峰赛决赛排行榜
function SuperStageResponse:top2Rank(data)
    -- GResPinnacleRank

    ex.Player.super_stage_data.vec_top_rank = data.ranks

    ex.EventManager:fire(EVENT.SUPER_STAGE.RANK_INFO, data)
end

-- 巅峰赛决赛显示头三名推送
function SuperStageResponse:top2ShowTop(data)
    -- GResPinnacleShowTop

	local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_super_stage")
	if isOpen ~= true or require("src.scene.MainSceneCtr"):instance():getMainScene() == nil then
		return
    end

    -- 跨服冠军赛后端在17级之前打开界面会有问题
    if table.nums(data.ranks) <= 0 then
        return
    end
    
    require("src.layer.superstage.SuperStageTop3Ctr"):instance():openWindow(data.ranks, data.time)
end

-- 巅峰赛决赛结束推送
function SuperStageResponse:top2End(data)
    -- GResPinnacleEnd

    NetManager:sendMessage(ProtocolID.GReqScanPinnacle)
end

-- 巅峰赛决赛竞猜广播推送
function SuperStageResponse:top2GuessBroadcast(data)
    -- GResPinnacleGuessBroadcast

	local super_stage_data = ex.Player.super_stage_data

    if not super_stage_data.guess then
        return
    end
    if data.type == 1 then
        super_stage_data.guess.atk_coin = super_stage_data.guess.atk_coin + data.guess_coin
    else
        super_stage_data.guess.def_coin = super_stage_data.guess.def_coin + data.guess_coin
    end

    ex.EventManager:fire(EVENT.SUPER_STAGE.UPDATE_GUESS)
end

function SuperStageResponse:top2SaveFormation(data)
    -- GResPinnacleSaveFormation

    ex.EventManager:fire(EVENT.SUPER_STAGE.SUB_REFRESH)
end

function SuperStageResponse:top2FormationChange(data)
    -- GResPinnacleFormationChange

    ex.EventManager:fire(EVENT.SUPER_STAGE.SUB_REFRESH)
end

return SuperStageResponse
