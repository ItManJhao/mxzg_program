local ChampionCrossResponse = class("ChampionCrossResponse")

function ChampionCrossResponse:scanChampionCross(data)
    ex.Player.championcross_data.worship_count = data.like
    ex.Player.championcross_data.rank_max = data.his_rank
    ex.Player.championcross_data.rank = data.rank
    ex.Player.championcross_data.battle_start_time = data.battle_start_time
    ex.Player.championcross_data.start_time = data.start_time
    ex.Player.championcross_data.end_time = data.end_time
    ex.Player.championcross_data.vec_rank = data.ranks
    ex.Player.championcross_data.like_rank = data.like_rank
    ex.Player.championcross_data.biu_cd = data.biu_cd
    ex.Player.championcross_data.period = data.period
    ex.Player.championcross_data.my_result = data.result
    ex.Player.championcross_data.show_round = data.show_round
    ex.Player.championcross_data.battle_round = data.battle_round

    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_SHOW_LAYER)

    -- dump(ex.Player.championcross_data.my_result, "xxxx")
    if ex.Player.championcross_data.my_result.rank ~= 0 then
        local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_champion_cross")
        if isOpen == true and require("src.scene.MainSceneCtr"):instance():getMainScene() ~= nil then
            NetManager:sendMessage(ProtocolID.GReqChampionCrossShowMyResult)
            require("src.layer.championcross.ChampionCrossPreRewardCtr"):instance():openWindow()
        end
    end

    if ex.Player.championcross_data.my_result.rank == 0 and data.show_round ~= 0 then
        NetManager:sendMessage(ProtocolID.GReqChampionCrossShowTop)
    end

    -- if data.show_round ~= 0 then
    --     NetManager:sendMessage(ProtocolID.GReqChampionCrossShowTop)
    -- end

    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

function ChampionCrossResponse:guessChampionCrossBattle(data)
    ex.Player.championcross_data.guess = data
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_GUESS)
    local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_champion_cross")

    print("ex.MainSceneCtr:getCurLayerType()", ex.MainSceneCtr:getCurLayerType(), MainSceneType.MAINCITY_CHAMPIONCROSS)
    if isOpen and ex.Player.championcross_data.guess.stage == 2 and require("src.scene.MainSceneCtr"):instance():getMainScene() ~= nil and ex.MainSceneCtr:getCurLayerType() ~= MainSceneType.MAINCITY_CHAMPIONCROSS then
        -- 提示
        require("src.layer.championcross.ChampionCrossGuessTipCtr"):instance():openWindow()
    end
end

function ChampionCrossResponse:guessCrossOneBattle(data)
    ex.Player.championcross_data.guess.guess_coin = data.guess_coin
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_GUESS)
    NetManager:sendMessage(ProtocolID.GReqGuessChampionCrossBattle)
end

function ChampionCrossResponse:scanChampionCrossKnockout(data)
    ex.Player.championcross_data.guess_id = data.guess_id
    -- ex.Player.championcross_data.battle_round = data.battle_round
    ex.Player.championcross_data.battle_next_time = data.next_time
    ex.Player.championcross_data.battle_stage = data.stage

    ex.Player.championcross_data.knockout_data = {}
    for i, v in ipairs(data.battles) do
        if ex.Player.championcross_data.knockout_data[v.battle_round] == nil then
            ex.Player.championcross_data.knockout_data[v.battle_round] = {}
        end
        table.insert(ex.Player.championcross_data.knockout_data[v.battle_round], v)
    end

    ex.Player.championcross_data.knockout_block = {}
    -- 对战数据进行重新编队。方便界面显示.可能要迁移到ChampionCross_data中
    -- 生成4页32强数据每页包含 8个32强。4个16强。2个4强。1个2强
    for i=1, 8 do
        ex.Player.championcross_data.knockout_block[i] = {}
        for idx,v in ipairs(ex.Player.championcross_data.knockout_idx) do
            -- local num = 2 ^ (table.nums(ex.Player.championcross_data.knockout_idx) - idx - 2)
            local num = 2 ^ (5 - idx - 2)
            if num >= 1  then
                ex.Player.championcross_data.knockout_block[i][num * 2] = {}
            end
            for j=1, num do
                local data = ex.Player.championcross_data.knockout_data[v]
                if data then
                    data = data[(i - 1) * num + j]
                end
                table.insert(ex.Player.championcross_data.knockout_block[i][num * 2], data)
            end
        end
    end

    -- 生成4强数据
    ex.Player.championcross_data.knockout_block4 = {}
    for i=1, 3 do
        local num = (2 ^ i)
        ex.Player.championcross_data.knockout_block4[num] = {}
        local data = ex.Player.championcross_data.knockout_data[num]
        if data then
            for ip,v in ipairs(data) do
                table.insert(ex.Player.championcross_data.knockout_block4[num], v)
            end
        end
    end

    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_KNOCKOUT)
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_MAIN)
end


function ChampionCrossResponse:myChampionCrossBattle(data)
    ex.Player.championcross_data.my_champion = data
    if ex.Player.championcross_data.my_old_battle_id == nil then
        ex.Player.championcross_data.my_old_battle_id = ex.Player.championcross_data.my_champion.battle_id
    end

    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_MY_CHAMPION)
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_MAIN)
end



function ChampionCrossResponse:championCrossLike(data)
    ex.Player.championcross_data:addLike(data.rid)
    ex.Player.championcross_data:addLikeCount(data.rid)
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_LIKE)
end


function ChampionCrossResponse:championCrossBiubiu(data)
    
    ex.MessageView:add(ex.Tools:getLang(70776))

    ex.Player.championcross_data.biu_cd = data.biu_cd
end

function ChampionCrossResponse:getChampionCrossBattle(data)
    -- 战斗信息无效
    if data.battle_id == "" then
        return
    end

    local req_battle = Battle_pb.GReqBattleReport()
    req_battle.type = EVENT.CHAMPIONCROSS_EVENT.BATTLE_REPORT
    req_battle.battle_id = data.battle_id
    NetManager:sendMessage(ProtocolID.GReqBattleReport, req_battle)
end

function ChampionCrossResponse:championCrossBiuList(data)
    ex.Player.championcross_data.vec_biu = {}
    for i,v in ipairs(data.content) do
        local tmp_data = {}
        tmp_data.is_my = v.rid == ex.Player.role_id
        tmp_data.content = v.content
        table.insert(ex.Player.championcross_data.vec_biu, tmp_data)
    end

    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.START_BIU)
end

function ChampionCrossResponse:championCrossBiuChange(data)
    local tmp_data = {}
    tmp_data.is_my = data.content.rid == ex.Player.role_id
    tmp_data.content = data.content.content
    table.insert(ex.Player.championcross_data.vec_biu, tmp_data)
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.ADD_BIU, tmp_data)
end

function ChampionCrossResponse:championCrossGuessList(data)
    ex.Player.championcross_data.guess_record = TableEx.reverseTable(data.record)
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_GUESS_LIST)
end


function ChampionCrossResponse:GResScanMyChampionCrossBattle(data)
    ex.Player.championcross_data.my_champion_battle = data.battles
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_MY_CHAMPION_BATTLE)
end


function ChampionCrossResponse:championCrossGuessWin(data)
    if require("src.scene.MainSceneCtr"):instance():getMainScene() == nil then
        return
    end
    local str_title = string.format(ex.Tools:getLang(47488), ex.Player.championcross_data:getChampionTitle(data.period, data.battle_round))

    require("src.layer.championcross.ChampionCrossRewardCtr"):instance():openWindow(
                     str_title,
                     {{item_type=901302, item_num=data.gain_coin}})
end

function ChampionCrossResponse:championCrossStageChange(data)
    if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_champion_cross") ~= true then
        return
    end
    
    if ex.Player.championcross_data.guess and ex.Player.championcross_data.guess.stage == 2 and ex.MainSceneCtr:getCurLayerType() ~= MainSceneType.MAINCITY_CHAMPIONCROSS then
        -- NetManager:sendMessage(ProtocolID.GReqScanChampionCross)
        NetManager:sendMessage(ProtocolID.GReqGuessChampionCrossBattle)
    else
        NetManager:sendMessage(ProtocolID.GReqScanChampionCross)
        NetManager:sendMessage(ProtocolID.GReqScanChampionCrossKnockout)
        NetManager:sendMessage(ProtocolID.GReqGuessChampionCrossBattle)
        NetManager:sendMessage(ProtocolID.GReqMyChampionCrossBattle)
    end
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.STAGE_BECHANGE)
end

function ChampionCrossResponse:championCrossRank(data)
    ex.Player.championcross_data.vec_champion_rank = data.ranks
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_CHAMPION_RANK_LIST)
end

function ChampionCrossResponse:championCrossShowTop(data)
	local isOpen = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_champion_cross")
	if isOpen ~= true or require("src.scene.MainSceneCtr"):instance():getMainScene() == nil then
		return
    end

    -- 跨服冠军赛后端在17级之前打开界面会有问题
    if table.nums(data.ranks) <= 0 then
        return
    end
    
    require("src.layer.championcross.ChampionCrossTop3Ctr"):instance():openWindow(data.ranks, data.time)
end

function ChampionCrossResponse:championCrossEnd(data)
    NetManager:sendMessage(ProtocolID.GReqScanChampionCross)
end


function ChampionCrossResponse:championCrossGuessBroadcast(data)
    if not ex.Player.championcross_data.guess then
        return
    end
    if data.type == 1 then
        ex.Player.championcross_data.guess.atk_coin = ex.Player.championcross_data.guess.atk_coin + data.guess_coin
    else
        ex.Player.championcross_data.guess.def_coin = ex.Player.championcross_data.guess.def_coin + data.guess_coin
    end
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.UPDATE_GUESS)
end

function ChampionCrossResponse:championCrossSaveFormation(data)
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.SUB_REFRESH)
end

function ChampionCrossResponse:championCrossFormationChange(data)
    ex.EventManager:fire(EVENT.CHAMPIONCROSS_EVENT.SUB_REFRESH)
end

function ChampionCrossResponse:championCrossCleanBiu(data)
    ex.Player.champion_data.vec_biu = {}
    ex.EventManager:fire(EVENT.CHAMPION_EVENT.CLEAN_BIU)
end

return ChampionCrossResponse
