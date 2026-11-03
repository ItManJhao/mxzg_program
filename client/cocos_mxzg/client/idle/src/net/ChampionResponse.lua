local ChampionResponse = class("ChampionResponse")

function ChampionResponse:scanChampion(data)
    ex.Player.champion_data.worship_count = data.like
    ex.Player.champion_data.rank_max = data.his_rank
    ex.Player.champion_data.rank = data.rank
    ex.Player.champion_data.battle_start_time = data.battle_start_time
    ex.Player.champion_data.start_time = data.start_time
    ex.Player.champion_data.end_time = data.end_time
    ex.Player.champion_data.vec_rank = data.ranks
    ex.Player.champion_data.like_rank = data.like_rank
    ex.Player.champion_data.biu_cd = data.biu_cd
    ex.Player.champion_data.period = data.period
    ex.Player.champion_data.my_result = data.result
    ex.Player.champion_data.show_round = data.show_round

    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_SHOW_LAYER)

    -- dump(ex.Player.champion_data.my_result, "xxxx")
    if ex.Player.champion_data.my_result.rank ~= 0 then
        local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_champion")
        if isOpen == true and require("src.scene.MainSceneCtr"):instance():getMainScene() ~= nil then
            NetManager:sendMessage(ProtocolID.GReqChampionShowMyResult)
            require("src.layer.champion.ChampionPreRewardCtr"):instance():openWindow()
        end
    end

    if ex.Player.champion_data.my_result.rank == 0 and data.show_round ~= 0 then
        NetManager:sendMessage(ProtocolID.GReqChampionShowTop)
    end

    -- if data.show_round ~= 0 then
    --     NetManager:sendMessage(ProtocolID.GReqChampionShowTop)
    -- end

    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

function ChampionResponse:guessChampionBattle(data)
    ex.Player.champion_data.guess = data
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_GUESS)
    local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_champion")
    if isOpen and ex.Player.champion_data.guess.stage == 2 and require("src.scene.MainSceneCtr"):instance():getMainScene() ~= nil and ex.MainSceneCtr:getCurLayerType() ~= MainSceneType.MAINCITY_CHAMPIONSHIP then
        -- 提示
        require("src.layer.champion.ChampionGuessTipCtr"):instance():openWindow()
    end
end

function ChampionResponse:guessOneBattle(data)
    ex.Player.champion_data.guess.guess_coin = data.guess_coin
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_GUESS)
    NetManager:sendMessage(ProtocolID.GReqGuessChampionBattle)
end

function ChampionResponse:scanChampionKnockout(data)
    ex.Player.champion_data.guess_id = data.guess_id
    ex.Player.champion_data.battle_round = data.battle_round
    ex.Player.champion_data.battle_next_time = data.next_time
    ex.Player.champion_data.battle_stage = data.stage

    ex.Player.champion_data.knockout_data = {}
    for i, v in ipairs(data.battles) do
        if ex.Player.champion_data.knockout_data[v.battle_round] == nil then
            ex.Player.champion_data.knockout_data[v.battle_round] = {}
        end
        table.insert(ex.Player.champion_data.knockout_data[v.battle_round], v)
    end

    ex.Player.champion_data.knockout_block = {}
    -- 对战数据进行重新编队。方便界面显示.可能要迁移到champion_data中
    -- 生成4页32强数据每页包含 8个32强。4个16强。2个4强。1个2强
    for i=1, 4 do
        ex.Player.champion_data.knockout_block[i] = {}
        for idx,v in ipairs(ex.Player.champion_data.knockout_idx) do
            local num = 2 ^ (table.nums(ex.Player.champion_data.knockout_idx) - idx - 2)
            if num >= 1  then
                ex.Player.champion_data.knockout_block[i][num * 2] = {}
            end
            for j=1, num do
                local data = ex.Player.champion_data.knockout_data[v]
                if data then
                    data = data[(i - 1) * num + j]
                end
                table.insert(ex.Player.champion_data.knockout_block[i][num * 2], data)
            end
        end
    end

    -- 生成4强数据
    ex.Player.champion_data.knockout_block4 = {}
    for i=1, 2 do
        local num = i * 2
        ex.Player.champion_data.knockout_block4[i * 2] = {}
        local data = ex.Player.champion_data.knockout_data[num]
        if data then
            for ip,v in ipairs(data) do
                table.insert(ex.Player.champion_data.knockout_block4[i * 2], v)
            end
        end
    end

    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_KNOCKOUT)
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_MAIN)
end


function ChampionResponse:myChampionBattle(data)
    ex.Player.champion_data.my_champion = data
    if ex.Player.champion_data.my_old_battle_id == nil then
        ex.Player.champion_data.my_old_battle_id = ex.Player.champion_data.my_champion.battle_id
    end

    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_MY_CHAMPION)
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_MAIN)
end



function ChampionResponse:championLike(data)
    ex.Player.champion_data:addLike(data.rid)
    ex.Player.champion_data:addLikeCount(data.rid)
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_LIKE)
end


function ChampionResponse:championBiubiu(data)

    ex.MessageView:add(ex.Tools:getLang(70776))

    ex.Player.champion_data.biu_cd = data.biu_cd
end

function ChampionResponse:getChampionBattle(data)
    -- 战斗信息无效
    if data.battle_id == "" then
        return
    end

    local req_battle = Battle_pb.GReqBattleReport()
    req_battle.type = EVENT.CHAMPION_EVENT.BATTLE_REPORT
    req_battle.battle_id = data.battle_id
    NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)

    -- -- 伪造假的弹幕信息
    -- local xx_data = {}
    -- xx_data.content = {} 
    -- for i=1,4 do
    --     local mm = {}
    --     mm.content = "asjkdhaksjdhakshdjahs" .. i
    --     mm.rid = math.random(1, 2) == 1 and ex.Player.role_id or i
    --     table.insert(xx_data.content, mm)
    -- end
    -- ChampionResponse:championBiuList(xx_data)
end

function ChampionResponse:championBiuList(data)
    ex.Player.champion_data.vec_biu = {}
    for i,v in ipairs(data.content) do
        local tmp_data = {}
        tmp_data.is_my = v.rid == ex.Player.role_id
        tmp_data.content = v.content
        table.insert(ex.Player.champion_data.vec_biu, tmp_data)
    end

    ex.EventManager:fire(EVENT.CHAMPION_EVENT.START_BIU)
end

function ChampionResponse:championBiuChange(data)
    local tmp_data = {}
    tmp_data.is_my = data.content.rid == ex.Player.role_id
    tmp_data.content = data.content.content
    table.insert(ex.Player.champion_data.vec_biu, tmp_data)
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.ADD_BIU, tmp_data)
end

function ChampionResponse:championGuessList(data)
    ex.Player.champion_data.guess_record = TableEx.reverseTable(data.record)
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_GUESS_LIST)
end


function ChampionResponse:GResScanMyChampionBattle(data)
    ex.Player.champion_data.my_champion_battle = data.battles
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_MY_CHAMPION_BATTLE)
end


function ChampionResponse:championGuessWin(data)
    if require("src.scene.MainSceneCtr"):instance():getMainScene() == nil then
        return
    end

    local str_title = string.format(ex.Tools:getLang(47488), ex.Player.champion_data:getChampionTitle(data.period, data.battle_round))

    require("src.layer.champion.ChampionRewardCtr"):instance():openWindow(
                     str_title,
                     {{item_type=901302, item_num=data.gain_coin}})
end

function ChampionResponse:championStageChange(data)
    if ex.Player.champion_data.guess and ex.Player.champion_data.guess.stage == 2 and ex.MainSceneCtr:getCurLayerType() ~= MainSceneType.MAINCITY_CHAMPIONSHIP then
        -- NetManager:sendMessage(ProtocolID.GReqScanChampion)
        NetManager:sendMessage(ProtocolID.GReqGuessChampionBattle)
    else
        NetManager:sendMessage(ProtocolID.GReqScanChampion)
        NetManager:sendMessage(ProtocolID.GReqScanChampionKnockout)
        NetManager:sendMessage(ProtocolID.GReqGuessChampionBattle)
        NetManager:sendMessage(ProtocolID.GReqMyChampionBattle)
    end
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.STAGE_BECHANGE)
end

function ChampionResponse:championRank(data)
    ex.Player.champion_data.vec_champion_rank = data.ranks
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_CHAMPION_RANK_LIST)
end

function ChampionResponse:championShowTop(data)
    
	local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_champion")
	if isOpen ~= true or require("src.scene.MainSceneCtr"):instance():getMainScene() == nil then
		return
    end

    if table.nums(data.ranks) <= 0 then
        return
    end
    
    require("src.layer.champion.ChampionTop3Ctr"):instance():openWindow(data.ranks, data.time)
end

function ChampionResponse:championEnd(data)
    NetManager:sendMessage(ProtocolID.GReqScanChampion)
end


function ChampionResponse:championGuessBroadcast(data)
    if not ex.Player.champion_data.guess then
        return
    end
    if data.type == 1 then
        ex.Player.champion_data.guess.atk_coin = ex.Player.champion_data.guess.atk_coin + data.guess_coin
    else
        ex.Player.champion_data.guess.def_coin = ex.Player.champion_data.guess.def_coin + data.guess_coin
    end
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.UPDATE_GUESS)
end

function ChampionResponse:championSaveFormation(data)
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.SUB_REFRESH)
end

function ChampionResponse:championFormationChange(data)
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.SUB_REFRESH)
end

function ChampionResponse:championCleanBiu(data)
    ex.Player.champion_data.vec_biu = {}
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.CLEAN_BIU)
end

return ChampionResponse
