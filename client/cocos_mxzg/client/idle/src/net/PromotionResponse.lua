local PromotionResponse = class("PromotionResponse")

-------------------------活动新协议--------------------------------
function PromotionResponse:setRunningPromotionData(data)
    -- dump_pbmsg(data)
    ex.Player.promotion_data:setRunningPromotionData(data.promotions)
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.ACT_OPEN_TIME, data.promotions)

    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

------------------------------------后台活动配置------------------------------------
function PromotionResponse:serverActivityConfig(data)
    -- dump_pbmsg(data, "ServerActivityConfig")

    local ids = {}
    for i, v in ipairs(data.configs) do
        table.insert(ids, v.id)
        local config_name = ex.Player.promotion_data.server_promotion_name_map[v.id] or "promotion" .. v.id

        cfg[config_name] = {}
        cfg[config_name][config_name] = {}
        print("config_name = ", config_name)
        if v.config ~= nil and string.len(v.config) > 0 then
            local j_table = json.decode(v.config)
            for i2, v2 in ipairs(j_table) do
                cfg[config_name][config_name][v2.idx] = {}

                for key, value in pairs(v2) do
                    if type(value) == "string" and string.find(value, "%[") ~= nil then -- 是数组的话还需要再解一下
                        cfg[config_name][config_name][v2.idx][key] = json.decode(value)
                    else
                        cfg[config_name][config_name][v2.idx][key] = value
                    end
                end
            end
        end

        -- dump(cfg[config_name], config_name, 5)
    end
    -- 请求运行中的活动
    if data.is_hotfix == 0 then -- 加载时为0
        -- print("-------------------加载返回")
        ex.Player.promotion_data:reqRunningPromotion()
        ex.Player.promotion_data:reqDevelopGiftData()
        
    elseif data.is_hotfix == 1 then -- 热修复时为1
        -- 重新请求活动数据
        -- print("===================热更返回")
        -- dump(ids, "ids")
        if #ids > 0 then
            ex.Player.promotion_data:reqServerActicityData(ids)
        end
    end

    ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_CFG_INIT)

    if cfg.promotion097labordayreward then
        PromotionResponse:againSetConfigData()
    end
    -- 获得配置表后再请求活动数据
    -- 许愿池达标 -> reqRunningPromotion
    -- 占星阵任务 -> reqRunningPromotion
    -- 超值礼包 -> reqRunningPromotion
    -- 召唤达标 -> reqRunningPromotion
    -- 先知馈赠 -> reqRunningPromotion
    -- 祭坛兑换 -> reqRunningPromotion
    -- 召唤水晶 -> reqRunningPromotion
    -- 七彩华章 -> reqRunningPromotion
    -- 登录有礼 -> reqRunningPromotion
    -- 碎片进化 -> reqRunningPromotion
    -- 七天累充 -> reqRunningPromotion
    -- 节日豪礼 -> reqRunningPromotion
end

---------------重新排版五一奖励配置数据 start---------
function PromotionResponse:againSetConfigData(  )
    if not cfg.promotion097labordayreward or not cfg.promotion097labordayreward.promotion097labordayreward then
        return
    end
    local newRewardData = {}
    local isSendInitConfig = true
    for i, v in ipairs(cfg.promotion097labordayreward.promotion097labordayreward) do
        if v and v.round  then
            if not newRewardData[v.round] then
                newRewardData[v.round] = {}
            end
            table.insert(newRewardData[v.round], v)
        else
            isSendInitConfig = false
            break
        end
    end
    if isSendInitConfig then
        cfg.promotion097labordayreward.promotion097labordayreward = {}
        cfg.promotion097labordayreward.promotion097labordayreward = newRewardData
    end
end
---------------end--------------------------------
-------------------------签到--------------------------------
function PromotionResponse:signInList(data)
    -- TODO:签到重写
    ex.Player.promotion_data:clearSignIn(0)

    ex.Player.promotion_data:setSignIn(data)

    --ex.out(ex.Player.promotion_data.sign_in)
    ex.Player.promotion_data:checkSignInRedDot()
end

function PromotionResponse:signInAward(data)
    -- 设置签到

    local status = ex.Player.promotion_data.sign_in.is_sign + 1
    local day_data = {}
    day_data.days = data.days
    day_data.isSignIn = status
    day_data.month = ex.Player.promotion_data.sign_in.month
    day_data.newServer = ex.Player.promotion_data.sign_in.newServer
    day_data.charged = ex.Player.promotion_data.sign_in.charged
    ex.Player.promotion_data:setSignIn(day_data)
    ex.Player.promotion_data:checkSignInRedDot()

    -- ex.Player.promotion_data:checkSignInRedDot()
    -- local award_list = {}
    -- local award = {}
    -- award = {}
    -- award.item_id = data.data.award.id
    -- award.item_type = data.data.award.type
    -- award.item_num = data.data.award.num

    -- table.insert(award_list, award)

    -- -- 物品加入背包
    -- -- ex.Player:addItem(award.item_type, award.item_num, award.item_id)

    -- -- 展示签到奖励
    -- require("src.layer.ItemRewardCtr"):instance():openWindow(award_list)
end

--- 57
function PromotionResponse:getEveryDayLoginPromotion(data)
    ex.Player.promotion_data:saveEveryDayLogin(data)
end

function PromotionResponse:getEveryDayLoginReward(data)
    ex.Player.promotion_data:saveEveryDayLoginReward(data)
end

function PromotionResponse:getUpdateEveryDayLoginTarget(data)
    ex.Player.promotion_data:updateEveryDayLoginTarget(data.update_tasks)
end

-------------------------先知召唤--------------------------------
function PromotionResponse:getProphecyList(data)
    ex.Player.promotion_data:clearProphecyData()
    ex.Player.promotion_data:saveProphecyTime(data.nvalue, data.round)

    for k, v in ipairs(data.list) do
        ex.Player.promotion_data:setProphecyData(v.key, v.value)
    end

    ex.Player.promotion_data:checkProphecytimesRedDot()

    -- 通知界面刷新
    --ex.Player.promotion_data:checkProphecytimesRedDot()
    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
end

function PromotionResponse:getProphecyGift(data)
end

-------------------------好胜者--------------------------------

function PromotionResponse:getPvpwinsList(data)
    if ex.Player.promotion_data:getPvpwinsListTime() == false then
        return
    end

    ex.Player.promotion_data:clearPvpWinsData()
    ex.Player.promotion_data:savePvpWinsTime(data.nvalue)
    for k, v in ipairs(data.list) do
        ex.Player.promotion_data:setPvpWinsData(v.key, v.value)
    end

    ex.Player.promotion_data:checkPvpwinsRedDot()
end

function PromotionResponse:getPvpwinsGift(data)
end

-------------------------合成奖励--------------------------------

function PromotionResponse:getMarkHeroList(data)
    if ex.Player.promotion_data:getMarkHeroListTime() == false then
        return
    end

    ex.Player.promotion_data:clearMarkHeroData()

    ex.Player.promotion_data:saveMarkHeroTime()

    for k, v in ipairs(data.list) do
        ex.Player.promotion_data:setMarkHeroData(v.idx, v.combine_num, v.reward_num)
    end

    ex.Player.promotion_data:checkMakeHeroRedDot()
    --ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
end

function PromotionResponse:getMarkHeroGift(data)
end

-------------------------许愿池达标--------------------------------

function PromotionResponse:getBlessingPoolList(data)
    ex.Player.promotion_data:clearBlessingPoolData()

    ex.Player.promotion_data:saveBlessingPoolTime(data.nvalue, data.round)
    for k, v in ipairs(data.list) do
        ex.Player.promotion_data:setBlessingPoolData(v.key, v.value)
    end
    ex.Player.promotion_data:checkBlessingPoolRedDot()
    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
end

function PromotionResponse:getBlessingPoolGift(byte_array)
end

-------------------------召唤达标--------------------------------

function PromotionResponse:getSummonTimesList(data)
    ex.Player.promotion_data:clearSummonTimesData()
    ex.Player.promotion_data:saveSummonTimesTime(data.nvalue, data.round)
    for k, v in ipairs(data.list) do
        ex.Player.promotion_data:setSummonTimesData(v.key, v.value)
    end

    ex.Player.promotion_data:checkSummontimesRedDot()

    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
end

function PromotionResponse:getSummonTimesGift()
end

--------------------------酒馆常客----------------------------
function PromotionResponse:TavernWeeklyList(data)
    if ex.Player.promotion_data:getTavernWeeklyListTime() == false then
        return
    end

    ex.Player.promotion_data:clearTavernWeeklyList()
    ex.Player.promotion_data:setTavernWeeklyTime(data.count)

    for k, v in ipairs(data.list) do
        ex.Player.promotion_data:setTavernWeeklyData(v.key, v.value)
    end

    ex.Player.promotion_data:checkTavernWeeklyRedDot()

    ex.Player.promotion_data:reqTavernWeeklyRankList()
end

function PromotionResponse:TavernWeeklyRankList(data)
    -- ex.Player.promotion_data:setTavernWeeklyRankData(data.list, data.my_rank)

    ex.Player.rank_data.rank_pub_task_list = data.list

    local my_rank = {}
    my_rank.head_id = ex.Player.head_id
    my_rank.border_id = ex.Player.border_id
    my_rank.name = ex.Player.nick
    my_rank.level = ex.Player.level
    my_rank.rank = data.my_rank
    my_rank.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id", -1)
    my_rank.score = ex.Player.promotion_data.tavern_weekly_data.nvalue
    ex.Player.rank_data.rank_pub_task_self = my_rank

    require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end

function PromotionResponse:TavernWeeklyGift(byte_array)
end

--------------------------快速战斗之路----------------------------
function PromotionResponse:SpeedFightList(data)
    if ex.Player.promotion_data:getSpeedFightListTime() == false then
        return
    end

    ex.Player.promotion_data:clearSpeedFightList()
    ex.Player.promotion_data:setSpeedFightTime(data.count)

    for k, v in ipairs(data.list) do
        ex.Player.promotion_data:setSpeedFightData(v.key, v.value)
    end

    ex.Player.promotion_data:checkSpeedFightRedDot()

    ex.Player.promotion_data:reqSpeedFightRankList()
end

function PromotionResponse:SpeedFightRankList(data)
    -- ex.Player.promotion_data:setSpeedFightRankData(data.list, data.my_rank)

    ex.Player.rank_data.rank_quick_battle_list = data.list

    local my_rank = {}
    my_rank.head_id = ex.Player.head_id
    my_rank.border_id = ex.Player.border_id
    my_rank.name = ex.Player.nick
    my_rank.level = ex.Player.level
    my_rank.rank = data.my_rank
    my_rank.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id", -1)
    my_rank.score = ex.Player.promotion_data.speed_fight_data.nvalue
    ex.Player.rank_data.rank_quick_battle_self = my_rank

    require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end

function PromotionResponse:SpeedFightGift(data)
end

--------------------------试炼之路----------------------------
function PromotionResponse:AdventureList(data)
    if ex.Player.promotion_data:getAdventureListListTime() == false then
        return
    end

    ex.Player.promotion_data:clearAdventureList()
    ex.Player.promotion_data:setAdventureTime(data.count)

    for k, v in ipairs(data.list) do
        ex.Player.promotion_data:setAdventureData(v.key, v.value)
    end

    ex.Player.promotion_data:checkAdventureRedDot()

    ex.Player.promotion_data:reqAdventureRankList()
end

function PromotionResponse:AdventureRankList(data)
    -- ex.Player.promotion_data:setAdventureRankData(data.list, data.my_rank)

    ex.Player.rank_data.rank_trial_list = data.list

    local my_rank = {}
    my_rank.head_id = ex.Player.head_id
    my_rank.border_id = ex.Player.border_id
    my_rank.name = ex.Player.nick
    my_rank.level = ex.Player.level
    my_rank.rank = data.my_rank
    my_rank.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id", -1)
    my_rank.score = ex.Player.promotion_data.adventure_data.nvalue
    ex.Player.rank_data.rank_trial_self = my_rank

    require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end

function PromotionResponse:AdventureGift(data)
end

--------------------------点金活动----------------------------
function PromotionResponse:buyGoldList(data)
    -- 清空数据
    if ex.Player.promotion_data:getbuyGoldListTime() == false then
        return
    end

    ex.Player.promotion_data:clearBuyGoldList()
    ex.Player.promotion_data:setBuyGoldTime(data.count)

    for k, v in ipairs(data.list) do
        ex.Player.promotion_data:setBuyGoldData(v.key, v.value)
    end

    ex.Player.promotion_data:checkBuyGoldRedDot()

    -- ex.Player.promotion_data:reqBuyGoldRankList()

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.BUYGOLD_REFRESH)
end

function PromotionResponse:buyGoldRankList(data)
    -- ex.Player.promotion_data:setBuyGoldRankData(data.list, data.my_rank)

    ex.Player.rank_data.rank_buy_gold_list = data.list

    local my_rank = {}
    my_rank.head_id = ex.Player.head_id
    my_rank.border_id = ex.Player.border_id
    my_rank.name = ex.Player.nick
    my_rank.level = ex.Player.level
    my_rank.rank = data.my_rank
    my_rank.server_id = cc.UserDefault:getInstance():getIntegerForKey("server_id", -1)
    my_rank.score = ex.Player.promotion_data.buy_gold_data.num
    ex.Player.rank_data.rank_buy_gold_self = my_rank

    require("src.layer.RankTopThreeCtr"):instance():updateTableView()
end

function PromotionResponse:getBuyGoldGift(data)
end

-------------------------邀请码--------------
function PromotionResponse:getInvitationList(data)
    ex.Player.promotion_data:clearInvitationList()

    ex.Player.promotion_data:setInvitationList(data.roleList, data.invite_code, data.used)

    for k, v in ipairs(data.reward_record) do
        ex.Player.promotion_data:setInvitationGidtList(v.idx, v.had_Reward_count, v.max_Reward_count)
    end
    ex.Player.promotion_data:checkInvitationGiftRedDot()
end

function PromotionResponse:useInvitationCode(data)
    local status = data.used_state
    if status ~= 1 then return end

    ex.MessageView:add(ex.Tools:getLang(47664))
    ex.Player.promotion_data:setInvitationStatus(status)
    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_CODE_REFRESH_DATA)
    -- elseif status == 2 then
    --     ex.MessageView:add(ex.Tools:getLang(47561))
    -- else
    --     ex.MessageView:add(ex.Tools:getLang(47117))
end

function PromotionResponse:getInvitationGift(data)
    ex.Player.promotion_data:setInvitationGidtList(data.idx, data.had_Reward_count, data.max_Reward_count)

    ex.Player.promotion_data:checkInvitationGiftRedDot()
end

-------------------------每周福利--------------------------------
function PromotionResponse:weekGiftList(data)
    ex.Player.promotion_data:clearWeekGift()
    for i, v in ipairs(data.list) do
        ex.Player.promotion_data:setWeekGiftNumData(v.key, v.value)
    end

    --ex.out(ex.Player.promotion_data.weekGift)
end

-------------------------祭坛活动礼包--------------------------------
function PromotionResponse:getAlterHeroList(data)
    ex.Player.promotion_data:clearAlterHeroList()

    for i, v in ipairs(data.list) do
        ex.Player.promotion_data:setAlterHeroData(v.key, v.value)
    end
end

-------------------------活动限时兑换礼包--------------------------------
function PromotionResponse:timeExchangeGiftList(data)
    ex.Player.promotion_data:cleartimeExchangeData()
    ex.Player.promotion_data:setTimeExchangeTime()

    for i, v in ipairs(data.list) do
        ex.Player.promotion_data:setTimeExchangeData(v.key, v.value)
    end
end

function PromotionResponse:getTimeExchangeGift(data)
    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_REFRESH_DATA)
end

function PromotionResponse:timeLImitGiftList(data)
    if ex.Player.promotion_data:checkPromotionLimitedtimeRechargeRewardIsOpen() == false then
        return
    end

    local rmb = data.rmb
    ex.Player.promotion_data:setTimeExchange(rmb)
    for i, v in ipairs(data.list) do
        ex.Player.promotion_data:SetExchangeList(v.key, v.value)
    end

    -- 检测红点
    ex.Player.promotion_data:checkExchangeRedDot()

    ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.LIMIT_GIFT)
end

function PromotionResponse:getExchangeGift(byte_array)
    local is_success = byte_array:readByte()

    if is_success == 1 then
        local list_count = byte_array:readInt()
        for i = 1, list_count do
            local item_id = byte_array:readInt64()
            local item_type = byte_array:readInt()
            local item_num = byte_array:readInt()
            -- ex.Player:addItem(item_type, item_num, item_id)
            ex.Tools:addBackpackMsg(item_type, item_num)
        end
    end

    -- 发送同志前段界面
    -- ex.Player.promotion_data:checkLevelUpAwardRedDot()
end

-------------------------等级升级礼包--------------------------------
function PromotionResponse:levelUpList(data)
    ex.Player.promotion_data:clearLevelUpData()

    ex.Player.promotion_data:setLevelUpETime()

    for i, v in ipairs(data.data) do
        ex.Player.promotion_data:setLevelUpData(v.idx, v.buyCount, v.is_obtain)
    end
end

--领起礼包返回
function PromotionResponse:obtainLevelUpGift(data)
    -- local is_success = data.is_success
    -- local idx = data.idx
    -- if is_success == 1 then
    -- 	for i,v in ipairs(data.list) do
    -- 		local item_id = v.id
    -- 		local item_type = v.type
    -- 		local item_num = v.num
    -- 		ex.Player:addItem(item_type, item_num, item_id)
    -- 		ex.Tools:addBackpackMsg(item_type, item_num)
    -- 	end
    -- end
    -- -- 发送同志前段界面
    -- -- ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
    -- ex.Player.promotion_data:checkLevelUpAwardRedDot()
end

-------------------------诸神之战--------------------------------
function PromotionResponse:setPromotionPveMonsterData(data)
    ex.Player.promotion_data:clearMonsterList()
    ex.Player.promotion_data:setPveMonsterTimes()

    for i, v in ipairs(data.levelData) do
        ex.Player.promotion_data:setPveMonsterList(v.type, v.level, v.hp)
    end
end

function PromotionResponse:buyPromotionItem()
    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
end

function PromotionResponse:setUpdataPromotionPveMonsterData(data)
    ex.Player.promotion_data:setPveMonsterList(data.type, data.level, data.hp)
end

function PromotionResponse:setPromotionPveMonsterBattleData(data)
    ex.Player.promotion_data:setPveMonsterList(data.levelData.type, data.levelData.level, data.levelData.hp)

    -- 检测是否进入下一关
    if data.levelData.hp <= 0 then
        ex.Player.promotion_data:setNextPveMonster(data.levelData.type, data.levelData.level)
        ex.Player.promotion_data:sendGReqZhuShenData()
    end

    local item_data = {}
    for i, v in ipairs(data.rewards) do
        local ndata = {}
        ndata.item_type = v.type
        ndata.item_num = v.num
        table.insert(item_data, ndata)
    end

    if data.sweep_count > 0 then
        -- 扫荡次数。直接弹框

        local result_data = {}
        result_data.is_win = data.total_hp <= 0 and 1 or 0
        result_data.damage_value = data.damage_value
        result_data.vec_reward = item_data
        result_data.vec_battle_detail = data.report.log

        require("src.layer.promotion.PROMPveMonsterEndCtr"):instance():openWindow(result_data, true)
    else
        -- 播放战斗
        local result_data = {}
        result_data.is_win = data.total_hp <= 0 and 1 or 0
        result_data.damage_value = data.damage_value
        result_data.vec_reward = item_data
        result_data.report = data.report

        result_data.type = data.levelData.type
        result_data.level = data.levelData.level

        ex.EventManager:fire(EVENT.ACTIVE_BATTLE.START_ACTIVE_BATTLE_START, data.report, result_data.vec_reward, result_data)
    end

    -- damage_value  -- 伤害
    -- rewards  -- 奖励
    -- sweep_count  -- 扫荡次数
    -- total_hp  -- 剩余血量

    -- report  -- 战报
    -- 刷新道具

    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_IS_SUCCESS)
end

-------------------------积天豪礼--------------------------------
function PromotionResponse:rechargeDaysList(data)
    local save_data = {}
    local recharge_day = 1
    for i, v in ipairs(data.list) do
        local ndata = {}
        recharge_day = v.day
        ndata.day = v.day
        ndata.has_reward = v.has_reward
        ndata.money = v.money
        save_data[ndata.day] = ndata
    end

    ex.Player.promotion_data:setRechargeDays(save_data, recharge_day)

    ex.Player.promotion_data:checkRechargeDaysAwardRedDot()
end

function PromotionResponse:rechargeDaysAward(byte_array)
end

-------------------------周累计充值奖励--------------------------------
function PromotionResponse:rechargeWeekList(data)
    ex.Player.promotion_data:clearRechargeWeek(data.completed)

    for i, v in ipairs(data.list) do
        ex.Player.promotion_data:setRechargeWeekIsAward(v.idx, v.is_award > 0)
    end
end

function PromotionResponse:rechargeWeekAward(byte_array)
    ex.Player.promotion_data:setRechargeWeekIsAward(byte_array:readInt(), true)

    local list_count = byte_array:readInt()
    for i = 1, list_count do
        local item_id = byte_array:readInt64()
        local item_type = byte_array:readInt()
        local item_num = byte_array:readInt()
        -- ex.Player:addItem(item_type, item_num, item_id)
        ex.Tools:addBackpackMsg(item_type, item_num)
    end

    -- 红点检查
    ex.Player.promotion_data:checkRechargeAwardRedDot()
end

-------------------------月卡--------------------------------

function PromotionResponse:getMonthCardReward(data)
    -- 设置领取
end

function PromotionResponse:monthCardList(data)
    ex.Player.promotion_data:clearMonthCard()

    for i, v in ipairs(data.award) do
        local mc_data = {}
        mc_data.card_type = v.card_type
        mc_data.completed = v.completed
        mc_data.gain_days = v.gain_days
        mc_data.over_time = v.end_time
        mc_data.is_gain = v.is_gain > 0
        mc_data.is_gain_vip = v.is_gain_vip > 0
        ex.Player.promotion_data:addMonthCardData(mc_data)
    end

    ex.Player.promotion_data:checkVipRedDot()
    ex.EventManager:fire(EVENT.PROMOTION_EVENT.MONTH_CARD_GETED)
    --ex.out(ex.Player.promotion_data.month_card)

    ex.Player.promotion_data:checkMonthCardRedDot()

    ex.Player.promotion_data:checkSuperMonthCardRedDot()

    ex.EventManager:fire(EVENT.MAIN_PROMOTION_CARD.UPDATE_DAY)
end

function PromotionResponse:monthCardGain(data)
    local config = cfg.promotioncard.card[data.idx]
    if config then
        ex.Player.promotion_data:gainMonthCard(config.type)

        local cost = config.item[1]
        -- ex.Player:addItem(cost.item_type, cost.item_num)
        ex.Tools:addBackpackMsg(cost.item_type, cost.item_num)
    end
    ex.Player.promotion_data:checkVipRedDot()
    ex.EventManager:fire(EVENT.PROMOTION_EVENT.MONTH_CARD_GETED)
end

-------------------------圣诞活动--------------------------------
function PromotionResponse:festivalLoginInfo(data)
    local save_data = {}
    save_data.day = data.day
    save_data.list = {}
    for i, v in ipairs(data.reward_list) do
        table.insert(save_data.list, v)
    end

    ex.Player.promotion_data:setFestivalLoginInfo(save_data)

    -- 检测红点
    ex.Player.promotion_data:checkfestivanewRedDot()

    ex.EventManager:fire(EVENT.SEVEN_FESTIVANEW_DATA_EVENT.REWARD_RESULT)
    ex.EventManager:fire(EVENT.SEVEN_FESTIVANEW_DATA_EVENT.UPDATE_SEVEN_DAY_DATA)
end

function PromotionResponse:festivalLoginReward(data)
    -- ex.EventManager:fire(EVENT.SEVEN_FESTIVANEW_DATA_EVENT.REWARD_RESULT)
    -- -- 检测红点
    -- ex.Player.promotion_data:checkfestivanewRedDot()

    ex.Player.promotion_data:gReqFestivalLoginInfo()
end

function PromotionResponse:festivalLoginUpdat(data)
    -- 主动推送
    local save_day = data.day
    ex.Player.promotion_data:setFestivalLoginDays(save_day)
    ex.EventManager:fire(EVENT.SEVEN_FESTIVANEW_DATA_EVENT.UPDATE_SEVEN_DAY_DATA)

    -- 检测红点
    ex.Player.promotion_data:checkfestivanewRedDot()
end


-------------------------限时英雄升级礼包--------------------------------
function PromotionResponse:limitGiftList(data)
    ex.Player.promotion_data:clearLimitGift()

    for i, v in ipairs(data.list) do
        local data = {}
        data.gift_id = v.gift_id
        data.idx = v.idx
        data.num = v.num
        data.last_time = v.end_time
        ex.Player.promotion_data:addLimitGiftData(data)
    end

    -- 按时间排序
    ex.Player.promotion_data:sortLimitGift()

    --ex.out(ex.Player.promotion_data.limit_gift)

    -- 客户端界面进度刷新
    ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.LIMIT_GIFT, true)

    ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_limit_gift")
    ex.Player.promotion_data:startLimitGiftTimer()
end

function PromotionResponse:gainNewLimitGift(data)
    ex.Player.promotion_data:addLimitGiftData(data)

    --ex.out(data)

    -- 按时间排序
    ex.Player.promotion_data:sortLimitGift()

    ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.LIMIT_GIFT, true)
    ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_limit_gift")
    ex.Player.promotion_data:startLimitGiftTimer()
end

-------------------------超值首充--------------------------------
function PromotionResponse:rechargeFirstList(data)
    ex.Player.promotion_data:clearRechargeFirst(data.recharge)

    local idx_list = {}
    for i, v in ipairs(data.list) do
        table.insert(idx_list, v)
    end

    local is_day_can = {}
    for i, v in ipairs(data.can_reward) do
        local data = {}
        data.type = v.key
        data.is_gain = v.value
        table.insert(is_day_can, data)
    end

    ex.Player.promotion_data:addRechargeFirstData(idx_list, is_day_can)

    local reddot_manager = ex.RedDotManager
    reddot_manager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCZSC, ex.Player.promotion_data:hasRechargeFirstAward())

    ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.RECHARGE_FIRST)
end

function PromotionResponse:rechargeFirstAward(data)
    ex.Player.promotion_data:reqRechargeFirst()
    -- 超值首充 红点
    local reddot_manager = ex.RedDotManager
    reddot_manager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCZSC, ex.Player.promotion_data:hasRechargeFirstAward())

    ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_recharge_first")
end

    -- 周向阳
    -- time:2020-08-10 20:41:40
----------------------------超值赠礼------------------------------
function PromotionResponse:supreGiftReward(data)

    NetManager:sendMessage(ProtocolID.GReqRechargeGiftInfo)

end

function PromotionResponse:supreGiftInfo(data)
    ex.Player.promotion_data:getSupreGiftData(data) 
    ex.EventManager:fire(EVENT.SUPER_GIFT.UPDATA)  
end

-------------------------月度回馈(计划)--------------------------------
function PromotionResponse:monthInvestList(ydata)
    ex.Player.promotion_data:clearMonthInvest()

    ex.Player.promotion_data:setMonthInvestTimeInfo(ydata.start_time, ydata.end_time, ydata.status)

    for i, v in ipairs(ydata.list) do
        local data = {}
        data.invest_type = v.type
        data.receive_day = v.receive_day
        data.reach_day = v.reach_day
        data.is_today_got = v.is_today_got

        ex.Player.promotion_data:addMonthInvest(data)

        ex.Player.promotion_data:checkMonthInvesRedDot(data.invest_type)
    end

    --ex.out(ex.Player.promotion_data.month_invest)

    -- 客户端界面进度刷新
    local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_MONTH_INVEST)
    if cur_layer then
        cur_layer:updateCompleted()
    end

    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_TIMER)
end

function PromotionResponse:monthInvestGain(ytdata)
    local sdata = {}
    sdata.invest_type = ytdata.type
    sdata.receive_day = ytdata.receive_day
    sdata.reach_day = ytdata.reach_day
    sdata.is_today_got = ytdata.is_today_got
    ex.Player.promotion_data:setMonthInvest(sdata)

    ex.Player.promotion_data:checkMonthInvesRedDot(sdata.invest_type)

    -- 客户端界面进度刷新
    local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_MONTH_INVEST)
    if cur_layer then
        cur_layer:updateCompleted()
    end
end

-------------------------充值奖励--------------------------------

function PromotionResponse:promotionList(data)
    ex.Player.promotion_data.is_buy_foundation = data.is_buy_foundation > 0
    ex.Player.promotion_data.foundation_list = {}
    for i, v in ipairs(data.foundation_reward_record) do
        if v.value == 1 then
            table.insert(ex.Player.promotion_data.foundation_list, v.key)
        end
    end
    ex.Player.promotion_data:checkRCGGrowthRedDot()

    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

-------------------------成长基金--------------------------------

function PromotionResponse:promotionRewardList(data)
    ex.Player.promotion_data.foundation_list = {}
    for i, v in ipairs(data.list) do
        table.insert(ex.Player.promotion_data.foundation_list, v.index)
    end
    ex.Player.promotion_data:checkRCGGrowthRedDot()
end

-- function PromotionResponse:vipRewardBuy(data)
-- 	print("PromotionResponse:vipRewardBuy")
-- 	dump_pbmsg(data)
-- 	-- for k,v in ipairs(data.list) do
-- 	-- 	-- ex.Player:addItem(v.type, v.num, v.id)
-- 	-- 	-- ex.Player:addItem(v.item_type, v.item_num, v.item_id, v.ex_attr_idx, v.skill_type_1, v.skill_num_1, v.skill_type_2, v.skill_num_2)
-- 	-- 	ex.Tools:addBackpackMsg(v.type, v.num)
-- 	-- end
-- 	-- require("src.layer.ItemRewardCtr"):instance():openWindow(data.list)
-- 	ex.Player.promotion_data:checkVipRedDot()

-- 	ex.EventManager:fire(EVENT.PROMOTION_EVENT.VIP_REWARD_BUY)
-- end

function PromotionResponse:dayLimitLog(data)
    ex.Player.promotion_data.day_limit_reward = data.has_reward

    local save_data = {}
    for i, v in ipairs(data.data) do
        local udata = {}
        udata.idx = v.key
        udata.num = v.value
        table.insert(save_data, udata)
    end

    ex.Player.promotion_data.day_limit_list = save_data
    ex.Player.promotion_data:checkLimitRedDot()
    -- dump(data, "dayLimitLog")
end

-------------------------特权礼包--------------------------------
function PromotionResponse:handlePrivilegeGiftAddOrUpdate(data)
    ex.Player.promotion_data:addOrUpdatePrivilegeGift(data.list)
end

function PromotionResponse:updatePrivilegeGift(data)
    ex.Player.promotion_data:updatePrivilegeGift(data.data)
end

-------------------------每月福利--------------------------------
function PromotionResponse:mouthWelfareList(data)
    ex.Player.promotion_data:clearMouthWelfare()

    for i, v in ipairs(data.list) do
        ex.Player.promotion_data:setMouthWelfareNum(v.key, v.value)
    end

    -- 刷新页面
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.MOUTH_WELFARE)
end

-------------------------每日福利--------------------------------
function PromotionResponse:dailyWelfareList(data)
    ex.Player.promotion_data:clearDailyWelfare()

    for i, v in ipairs(data.list) do
        ex.Player.promotion_data:setDailyWelfareNum(v.key, v.value)
    end

    -- 刷新页面
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.DAILY_WELFARE)
end

-- 每日首充
function PromotionResponse:dailyChargeData(data)
    ex.Player.promotion_data:cleanDailyFirstRecharge()

    for i, v in ipairs(data.list) do
        ex.Player.promotion_data:setDailyFirstRecharge(v.type, v.status, v.money)
    end

    -- 每日首充 红点
    ex.Player.promotion_data:checkDailyFirstRechargeRedDot()

    ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.DAILY_FIRST_RECHARGE)
end

function PromotionResponse:getDailyChargeData(data)
    ex.Player.promotion_data:setDailyFirstRecharge(data.type, 1)

    ex.Player.promotion_data:checkDailyFirstRechargeRedDot()

    ex.EventManager:fire(EVENT.MAIN_CITY_RECHARGE.DAILY_FIRST_RECHARGE)
    ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END, "act_day_first_recharge")
end

--每日累冲
function PromotionResponse:dailyTotalChargeData(data)
    ex.Player.promotion_data:updateDailyTotalRechargeList(data.list, data.money)
end

-------------------------新服限购--------------------------------
function PromotionResponse:newServerLimitList(data)
    ex.Player.promotion_data:addOrUpdateNewServerLimitList(data.data)
end

function PromotionResponse:midAutumnInfo(data)
    local data = {}
    data.begin_time = data.begin_time
    data.end_time = data.end_time
    data.is_bought = data.is_bought > 0

    ex.Player.promotion_data:setMidAutumnInfo(data)
end

-----------------------------召唤水晶----------------------------
function PromotionResponse:summonCrystalInfo(data)
    -- dump(data, "PromotionResponse:summonCrystalInfo")
    local info = {}
    info.list = {}
    for i, v in ipairs(data.list) do
        local item = {
            idx = v.idx,
            progress = v.progress,
            is_bought = v.is_bought == 1
        }
        table.insert(info.list, item)
    end
    ex.Player.promotion_data:setSummonCrystalInfo(info)

    ex.Player.promotion_data:checkSummonCrystalRedDot()
end

-----------------------------占星阵任务----------------------------
function PromotionResponse:AstrologyTaskInfo(data)
    -- dump(data, "PromotionResponse:AstrologyTaskInfo")
    local info = {}
    info.list = {}
    for i, v in ipairs(data.list) do
        local item = {}
        item.idx = v.idx
        item.is_over = v.status ~= 0
        table.insert(info.list, item)
    end

    ex.Player.promotion_data:setAstrologyTaskInfo(info)
end

function PromotionResponse:AstrologyTaskSubmit(data)
    local item = {}
    item.idx = data.idx
    item.is_over = data.is_over ~= 0

    ex.Player.promotion_data:handleAstrologyTaskSubmit(item)
end

-----------------------------超值礼包----------------------------
function PromotionResponse:OverValueData(data)
    local tab = {}
    tab.list = {}
    for i, v in ipairs(data.list) do
        table.insert(tab.list, {idx = v.key, buy_times = v.value})
    end

    ex.Player.promotion_data:setOverValueData(tab)

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.SUPER_WELFARE)
end

-----------------------------酒馆达标----------------------------
function PromotionResponse:pubArriveInfo(data)
    if ex.Player.promotion_data:getPubArriveTimesIsOpen() == false then
        return
    end
    -- dump(data, "PromotionResponse:pubArriveInfo")

    ex.Player.promotion_data:setPubArriveInfo(data)

    ex.Player.promotion_data:checkPubArriveRedDot()
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION)
end

function PromotionResponse:pubArriveGot(data)
    NetManager:sendMessage(ProtocolID.GReqPubArriveInfo)
end

-----------------------------成长礼包---------------------------
function PromotionResponse:growUpList(data)
    -- dump(data)
    -- print("PromotionResponse:growUpList")
    -- dump_pbmsg(data)
    ex.Player.promotion_data:setGrowUpList(data)
    ex.Player.promotion_data:checkVipRedDot()
    -- ex.EventManager:fire(EVENT.PROMOTION_EVENT.VIP_REWARD_GET)
end

function PromotionResponse:privilegeReward(data)
    print("PromotionResponse:privilegeReward")
    dump_pbmsg(data)
    ex.Player.promotion_data.growUpList[data.idx] = 1
    local flag = ex.Player.promotion_data:getGrowUpByLevel(data.idx) == 1
    local is_buy =
        TableEx.findFunction(
        ex.Player.promotion_data.vip_list,
        function(value)
            if value == data.idx then
                return true
            end
        end
    )

    local save_pos = not (flag and is_buy)

    ex.Player.promotion_data:checkVipRedDot()
    ex.EventManager:fire(EVENT.PROMOTION_EVENT.VIP_REWARD_GET, save_pos)
    -- for i,v in ipairs(data.list) do
    -- 	ex.Player.promotion_data.vip_list[i] = v
    -- end
end

function PromotionResponse:vipRewardBuy(data)
    print("PromotionResponse:vipRewardBuy")
    dump_pbmsg(data)

    ex.Player.promotion_data.vip_list[data.vip_level] = data.vip_level
    ex.Player.promotion_data:checkVipRedDot()
    local flag = ex.Player.promotion_data:getGrowUpByLevel(data.vip_level) == 1
    local is_buy =
        TableEx.findFunction(
        ex.Player.promotion_data.vip_list,
        function(value)
            if value == data.vip_level then
                return true
            end
        end
    )

    local save_pos = not (flag and is_buy)
    ex.EventManager:fire(EVENT.PROMOTION_EVENT.VIP_REWARD_BUY, save_pos)
end

function PromotionResponse:vipRewardLog(data)
    -- print("PromotionResponse:vipRewardLog")
    -- dump_pbmsg(data)
    -- ex.Player.promotion_data.vip_list = data.list
    for i, v in ipairs(data.list) do
        ex.Player.promotion_data.vip_list[i] = v
    end

    ex.Player.promotion_data:checkVipRedDot()

    ex.EventManager:fire(EVENT.PROMOTION_EVENT.VIP_REWARD_BUY)

    -- dump(ex.Player.promotion_data.vip_list, "vipRewardLog")
end

function PromotionResponse:updateRecharge(data)
    local recharge = data.chargeCount
    ex.Player.total_charge = recharge
    ex.EventManager:fire(EVENT.ROLE_RESOURCE_EVENT.UPDATE_GEM)

    -- 累计充值数变更时通知其他依赖累充的活动更新数据
    ex.Player.promotion_data:reqRechargeFirst()
end
-- ex.Player.promotion_data:checkVipLevelGrowUpRedPoint()
-- ex.Player.promotion_data:checkVipRedDot()
-----------------------------通用模板活动信息---------------------------
function PromotionResponse:CommonActivityInfo(pbdata)
    -- dump_pbmsg(pbdata, "PromotionResponse:CommonActivityInfo", 5)

    for i, v in ipairs(pbdata.list) do
        local activity_data = {}
        activity_data.id = v.idx
        activity_data.start_time = v.start_time
        activity_data.end_time = v.end_time
        activity_data.clear_time = v.clear_time
        activity_data.turns = v.turns

        if v.ext_info ~= nil and string.len(v.ext_info) > 0 then
            activity_data.ext_info = json.decode(v.ext_info)
        else
            activity_data.ext_info = {}
        end

        activity_data.list = {}
        for i2, v2 in ipairs(v.list) do
            local item_data = {
                idx = v2.idx,
                progress = v2.progress,
                is_got = v2.is_got == 1
            }

            if v2.ext_info ~= nil and string.len(v2.ext_info) > 0 then
                item_data.ext_info = json.decode(v2.ext_info)
            else
                item_data.ext_info = {}
            end

            table.insert(activity_data.list, item_data)
        end

        ex.Player.promotion_data:setCommonActivityData(activity_data, true)
    end

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.COMMON_ACTIVITY_EVENT.REFRESH)
end

function PromotionResponse:ActivityItemGet(pbdata)
    local data = {
        id = pbdata.activity_idx,
        list = {
            {
                idx = pbdata.unit.idx,
                progress = pbdata.unit.progress,
                is_got = pbdata.unit.is_got
            }
        }
    }

    if pbdata.unit.ext_info ~= nil and string.len(pbdata.unit.ext_info) > 0 then
        data.list[1].ext_info = json.decode(pbdata.unit.ext_info)
    else
        data.list[1].ext_info = {}
    end

    ex.Player.promotion_data:setCommonActivityData(data)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.COMMON_ACTIVITY_EVENT.REFRESH)
end

-----------------------------冒险日记---------------------------
function PromotionResponse:AdventureNoteInfo(pbdata)
    -- dump_pbmsg(pbdata, "PromotionResponse:AdventureNoteInfo", 5)

    local activity_data = {}
    activity_data.id = pbdata.idx
    activity_data.start_time = pbdata.start_time
    activity_data.end_time = pbdata.end_time
    activity_data.clear_time = pbdata.clear_time
    activity_data.turns = pbdata.turns

    activity_data.ext_info = {}
    activity_data.ext_info.curr_day = pbdata.curr_day
    activity_data.ext_info.total_recharge = pbdata.total_recharge
    activity_data.ext_info.idx_recharge_reward = {}
    for i, v in ipairs(pbdata.idx_recharge_reward) do
        table.insert(activity_data.ext_info.idx_recharge_reward, v)
    end
    activity_data.ext_info.exp = pbdata.exp
    activity_data.ext_info.lv_rewards = {}
    for i, v in ipairs(pbdata.lv_rewards) do
        table.insert(activity_data.ext_info.lv_rewards, v)
    end

    activity_data.list = {}
    for i, v in ipairs(pbdata.list) do
        local item_data = {
            idx = v.idx,
            progress = v.progress,
            is_got = v.is_got == 1
        }

        if v.ext_info ~= nil and string.len(v.ext_info) > 0 then
            item_data.ext_info = json.decode(v.ext_info)
        else
            item_data.ext_info = {}
        end

        table.insert(activity_data.list, item_data)
    end

    ex.Player.promotion_data:setCommonActivityData(activity_data, true)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.ADVENTURE_NOTE, EVENT.UI.REFRESH_ALL)

    ex.Player.promotion_data:checkAdvNoteRedDot()
end

function PromotionResponse:AdventureNoteGet(pbdata)
    local data = {
        id = 29,
        list = {
            {
                idx = pbdata.unit.idx,
                progress = pbdata.unit.progress,
                is_got = pbdata.unit.is_got
            }
        }
    }

    if pbdata.unit.ext_info ~= nil and string.len(pbdata.unit.ext_info) > 0 then
        data.list[1].ext_info = json.decode(pbdata.unit.ext_info)
    else
        data.list[1].ext_info = {}
    end

    ex.Player.promotion_data:setCommonActivityData(data)

    -- 增加经验
    ex.Player.promotion_data:setAdventureExp(pbdata.unit.idx, pbdata.exp)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.ADVENTURE_NOTE, EVENT.UI.REFRESH_ALL)

    ex.Player.promotion_data:checkAdvNoteRedDot()
end

function PromotionResponse:AdventureNoteRechargeGet(pbdata)
    ex.Player.promotion_data:setAdventureNoteRechargeGet(pbdata.idx)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.ADVENTURE_NOTE, EVENT.UI.REFRESH_RECHARGE)

    ex.Player.promotion_data:checkAdvNoteRedDot()
end

function PromotionResponse:AdventureNoteAdvGet(pbdata)
    ex.Player.promotion_data:setAdventureNoteAdvGet(pbdata.idx)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.ADVENTURE_NOTE, EVENT.UI.REFRESH_BANNER)

    ex.Player.promotion_data:checkAdvNoteRedDot()
end

function PromotionResponse:AdventureNoteRechargeUpdate(pbdata)
    ex.Player.promotion_data:setAdventureNoteRechargeUpdate(pbdata.total_recharge)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.ADVENTURE_NOTE, EVENT.UI.REFRESH_RECHARGE)

    ex.Player.promotion_data:checkAdvNoteRedDot()
end

-----------------------------神秘魔盒---------------------------
function PromotionResponse:MysteryBoxInfo(pbdata)
    -- dump_pbmsg(pbdata, "PromotionResponse:MysteryBoxInfo", 5)

    local activity_data = {}
    activity_data.id = pbdata.idx
    activity_data.start_time = pbdata.start_time
    activity_data.end_time = pbdata.end_time
    activity_data.clear_time = pbdata.clear_time
    activity_data.turns = pbdata.turns

    activity_data.ext_info = {}
    activity_data.ext_info.curr_day = pbdata.curr_day
    activity_data.ext_info.total_recharge = pbdata.total_recharge
    activity_data.ext_info.idx_recharge_reward = {}
    for i, v in ipairs(pbdata.idx_recharge_reward) do
        table.insert(activity_data.ext_info.idx_recharge_reward, v)
    end
    activity_data.ext_info.exp = pbdata.exp
    activity_data.ext_info.lv_rewards = {}
    for i, v in ipairs(pbdata.lv_rewards) do
        table.insert(activity_data.ext_info.lv_rewards, v)
    end

    activity_data.list = {}
    for i, v in ipairs(pbdata.list) do
        local item_data = {
            idx = v.idx,
            progress = v.progress,
            is_got = v.is_got == 1
        }

        if v.ext_info ~= nil and string.len(v.ext_info) > 0 then
            item_data.ext_info = json.decode(v.ext_info)
        else
            item_data.ext_info = {}
        end

        table.insert(activity_data.list, item_data)
    end

    ex.Player.promotion_data:setCommonActivityData(activity_data, true)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.MYSTERY_BOX, EVENT.UI.REFRESH_ALL)

    ex.Player.promotion_data:checkMysteryBoxRedDot()
end

function PromotionResponse:MysteryBoxGet(pbdata)
    local data = {
        id = 30,
        list = {
            {
                idx = pbdata.unit.idx,
                progress = pbdata.unit.progress,
                is_got = pbdata.unit.is_got
            }
        }
    }

    if pbdata.unit.ext_info ~= nil and string.len(pbdata.unit.ext_info) > 0 then
        data.list[1].ext_info = json.decode(pbdata.unit.ext_info)
    else
        data.list[1].ext_info = {}
    end

    ex.Player.promotion_data:setCommonActivityData(data)

    -- 增加经验
    ex.Player.promotion_data:setMysteryBoxExp(pbdata.unit.idx, pbdata.exp)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.MYSTERY_BOX, EVENT.UI.REFRESH_ALL)

    ex.Player.promotion_data:checkMysteryBoxRedDot()
end

function PromotionResponse:MysteryBoxRechargeGet(pbdata)
    ex.Player.promotion_data:setMysteryBoxRechargeGet(pbdata.idx)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.MYSTERY_BOX, EVENT.UI.REFRESH_RECHARGE)

    ex.Player.promotion_data:checkMysteryBoxRedDot()
end

function PromotionResponse:MysteryBoxExpGet(pbdata)
    ex.Player.promotion_data:setMysteryBoxExpGet(pbdata.idx)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.MYSTERY_BOX, EVENT.UI.REFRESH_BANNER)

    ex.Player.promotion_data:checkMysteryBoxRedDot()
end

function PromotionResponse:MysteryBoxRechargeUpdate(pbdata)
    ex.Player.promotion_data:setMysteryBoxRechargeUpdate(pbdata.total_recharge)

    -- 发送UI刷新事件
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.MYSTERY_BOX, EVENT.UI.REFRESH_RECHARGE)

    ex.Player.promotion_data:checkMysteryBoxRedDot()
end

function PromotionResponse:HandleActivityConfigHadUpdate(data)
    local ids = data.ids
    -- dump(ids, "hot fix ids:")
    local req = PromotionNew_pb.GReqActivityBaseInfoUpdate()
    for i, v in ipairs(ids) do
        table.insert(req.ids, v)
    end
    NetManager:sendMessage(ProtocolID.GReqActivityBaseInfoUpdate, req)
end

function PromotionResponse:HandleActivityBaseInfoUpdate(data)
    local ids = {}
    for i, v in ipairs(data.promotions) do
        local data = {}
        data.id = v.id
        data.start_time = v.start_time
        data.end_time = v.end_time
        data.clear_time = v.clear_time
        data.turns = v.turns
        -- dump(data, "hot fix ActivityBaseInfoUpdate")
        ex.Player.promotion_data:addOrUpdateRunningPromotionData(data)

        table.insert(ids, data.id)
    end

    ex.Player.promotion_data:reqServerActicityConfig(ids, 1)
end

------------------------------------七彩华章------------------------------------
function PromotionResponse:ColourfulShopData(data)
    local tab = {}
    for i, v in ipairs(data.buy_info) do
        table.insert(tab, {idx = v.key, bought_num = v.value})
    end

    ex.Player.promotion_data:setColorfulShopTable(tab)

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.COLORFUL, EVENT.UI.REFRESH_ALL)
end

function PromotionResponse:ColourfulShopReward(data)
    ex.Player.promotion_data:ColorfulShopBoughtOne({idx = data.idx, bought_num = data.num})

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.COLORFUL, EVENT.UI.REFRESH_ALL)

    ex.EventManager:fire(EVENT.MAIN_CITY_LEVEL_UP.ACTIVITY_REFRESH_DATA)
end

------------------------------------登录有礼------------------------------------
function PromotionResponse:LoginGiftData(data)
    local tab = {}
    tab.days = data.days
    tab.reward_ids = {}
    for i, v in ipairs(data.reward_ids) do
        table.insert(tab.reward_ids, v)
    end

    ex.Player.promotion_data:setLoginGiftTable(tab)

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.LOGINGIFT, EVENT.UI.REFRESH_ALL)

    ex.Player.promotion_data:checkLoginGiftRedDot()
end

function PromotionResponse:LoginGiftReward(data)
    ex.Player.promotion_data:LoginGiftBoughtOne(data.idx)

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.LOGINGIFT, EVENT.UI.REFRESH_ALL)

    ex.Player.promotion_data:checkLoginGiftRedDot()
end

------------------------------------碎片进化------------------------------------
function PromotionResponse:ExchangeShopData(data)
    local tab = {}
    for i, v in ipairs(data.exchange_record) do
        table.insert(tab, {idx = v.key, bought_num = v.value})
    end

    ex.Player.promotion_data:setExchangeShopTable(tab)

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.EXCHANGE_SHOP, EVENT.UI.REFRESH_ALL)
end

function PromotionResponse:ExchangeShopReward(data)
    ex.Player.promotion_data:ExchangeShopBoughtOne({idx = data.idx, bought_num = 1})

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.EXCHANGE_SHOP, EVENT.UI.REFRESH_ALL)
end

------------------------------------七天累充------------------------------------
function PromotionResponse:WeeklyRechargeData(data)
end

------------------------------------节日豪礼------------------------------------
function PromotionResponse:festivalOvervalueGift(data)
    ex.Player.promotion_data.festival_overvalue_gift = data
    ex.Player.promotion_data:checkFestivalOvervalueGiftReddot()

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.FESTIVAL_OVERVALUE_GIFT)
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

function PromotionResponse:festivalGiftReceive(data)
    ex.Player.promotion_data.festival_overvalue_gift.receive_day = data.receive_day
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.FESTIVAL_OVERVALUE_GIFT)
    ex.Player.promotion_data:checkFestivalOvervalueGiftReddot()
end

function PromotionResponse:festivalReceiveDay(data)
    ex.Player.promotion_data.festival_overvalue_gift.day = data.day
    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.FESTIVAL_OVERVALUE_GIFT)
    ex.Player.promotion_data:checkFestivalOvervalueGiftReddot()
end

------------------------------------超值养成------------------------------------
function PromotionResponse:handleDevelopGiftList(data)
    ex.Player.promotion_data:refreshDevelopGiftData(data)

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.DEVELOP_GIFT_REFRESH)
end

function PromotionResponse:handleBuyDevelopGift(data)
    ex.Player.promotion_data:addDevelopGiftItem(data.data)

    ex.EventManager:fire(EVENT.MAIN_CITY_PROMOTION.DEVELOP_GIFT_REFRESH)
end

------------------------------------限时购买------------------------------------
function PromotionResponse:handleFlashSaleData(data)
    ex.Player.promotion_data:refreshFlashSaleData(data)
end

function PromotionResponse:handleGetReward(data)
    dump(data, "PromotionResponse:handleGetReward")
    ex.Player.promotion_data:WeedendGiftSetRewardStatus(data.reward_status)
end

------------------------------------周末福利------------------------------------
function PromotionResponse:handleWeekendGiftData(data)
    -- dump(data, "PromotionResponse:handleWeekendGiftData")
    ex.Player.promotion_data:WeedendGiftSetTime(data.start_time, data.end_time)

    ex.Player.promotion_data:WeedendGiftSetRewardStatus(data.reward_status)
end

------------------------------------购买皮肤------------------------------------
function PromotionResponse:getBuySkinRewardList(data)
    ex.Player.promotion_data:setBuySkinRewardList(data.reward_count)
end

------------------------------------召唤周卡------------------------------------
function PromotionResponse:handleSummonWeeksCardsInfo(data)
    ex.Player.promotion_data:updateSummonWeekCardData(data)
end

------------------------------------高级召唤周卡------------------------------------
function PromotionResponse:handleHighWeeksCardsInfo(data)
    ex.Player.promotion_data:updateSuperSummonWeekCardData(data)
end
------------------------------------精灵周卡------------------------------------
function PromotionResponse:handleSpiritWeekCardInfo(data)
    ex.Player.promotion_data:updateSpiritWeekCardData(data)
end
------------------------------------三天礼包------------------------------------
function PromotionResponse:handleThreeDayInfo(data)
    ex.Player.promotion_data:updateThreeDayGigtData(data)
end

function PromotionResponse:handleUpdateThreeDayTask(data)
    ex.Player.promotion_data:updateThreeDayTask(data)
end

------------------------------------龙舟活动------------------------------------
-- 龙舟活动总数据
function PromotionResponse:handleDragonBoatTaskInfo(data)
    ex.Player.promotion_data:setDragonBoatTaskInfo(data)
    ex.Player.promotion_data:checkDragonBoatRedDot()
end

-- 翻牌数据返回
function PromotionResponse:updateDragonBoatGameInfo(data)
    ex.EventManager:fire(EVENT.PROMOTION_DRAGON_BOAT.GAME_UPDATE, data)
end

-- 下一轮的翻牌消息
function PromotionResponse:updateDragonBoatNextGameInfo(data)
    ex.EventManager:fire(EVENT.PROMOTION_DRAGON_BOAT.NEXT_GAME_UPDATE, data)
end

-- 选择大奖数据
function PromotionResponse:updateDragonBoatUltimateReward(data)
    ex.EventManager:fire(EVENT.PROMOTION_DRAGON_BOAT.ULTIMATE_UPDATE, data)
end

-- 成功购买锦鲤消息返回
function PromotionResponse:updateDragonBoatBuyInfo(data)
    ex.EventManager:fire(EVENT.PROMOTION_DRAGON_BOAT.GIFT_UPDATE, data)
end

-- 领取任务奖励
function PromotionResponse:updateDragonBoatTaskReward(data)
    ex.EventManager:fire(EVENT.PROMOTION_DRAGON_BOAT.RECEIVE_TASK_REWARD, data)
    ex.Player.promotion_data:checkDragonBoatRedDot()
end

-- 领取宝箱 宝箱刷新
function PromotionResponse:updateDragonBoatBoxReward(data)
    ex.EventManager:fire(EVENT.PROMOTION_DRAGON_BOAT.BOX_REWARD_UPDATE, data)
    ex.Player.promotion_data:checkDragonBoatRedDot()
end

-- 任務進度刷新
function PromotionResponse:updateDragonBoatTaskInfo(data)
    ex.Player.promotion_data:setDragonBoatTaskProgress(data)
    ex.Player.promotion_data:checkDragonBoatRedDot()
    ex.EventManager:fire(EVENT.PROMOTION_DRAGON_BOAT.TASK_UPDAYTE)
end

-------------------------奇珍异宝------------------------------------
function PromotionResponse:handleTimeTreasureInfo(data)
    ex.Player.promotion_data:setTimeTreasureInfo(data)
end

function PromotionResponse:updataTimeTreasureInfo(data)
    ex.Player.promotion_data:updataTimeTreasureInfo(data)
end

--------------------------------------------------------------------

-------------------------98元累充奖励--------------------------------
function PromotionResponse:handleRechargeDaysBList(data)
    local save_data = {}
    local recharge_day = 1
    for i, v in ipairs(data.list) do
        local ndata = {}
        recharge_day = v.day
        ndata.day = v.day
        ndata.has_reward = v.has_reward
        ndata.money = v.money
        save_data[ndata.day] = ndata
    end

    ex.Player.promotion_data:setRechargeReward(save_data, recharge_day)

    ex.Player.promotion_data:checkRechargeAward2RedDot()
end

function PromotionResponse:handleRechargeDaysBReward(data)
end

----------------------------功能预告----------------------------
function PromotionResponse:handlePromotion66GetInfo(data)
    ex.Player.promotion_data:setPromotion66Info(data)
end

function PromotionResponse:handlePromotion66GetReward(data)
    ex.Player.promotion_data:setPromotion66ReceiveTime(data)
end

----------------------------梦境秘宝----------------------------
-- 获取梦境秘宝活动信息
function PromotionResponse:handlePromotion70GetInfo(data)
    ex.Player.promotion_data:setPromotion70Info(data)
    ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

-- 选择档位奖励
function PromotionResponse:handlePromotion70RewardSelect(data)
    ex.Player.promotion_data:selectPromotion70Reward(data)
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_REWARD_SELECT)
end

-- 梦境秘宝翻开格子
function PromotionResponse:handlePromotion70GameOpen(data)
    ex.Player.promotion_data:openPromotion70Item(data)
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_ITEM_OPEN, data.this_open_record)
end

-- 梦境秘宝领取次数奖励
function PromotionResponse:handlePromotion70getReward(data)
    ex.Player.promotion_data:getPromotion70CounrReward(data)
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_COUNT_REWARD_GET)
end

-- 梦境秘宝选择重置
function PromotionResponse:handlePromotion70SelectReset(data)
    ex.Player.promotion_data:resetPromotion70Select()
    ex.EventManager:fire(EVENT.SECRET_TREASURE.EVENT_GAME_RESET)
end

-- 梦境秘宝任务领取奖励
function PromotionResponse:handlePromotion70MissiongetReward(data)
    ex.Player.promotion_data:getPromotion70MissionReward(data)
end

-- 梦境秘宝任务更新推送
function PromotionResponse:handlePromotion70MissionUpdate(data)
    ex.Player.promotion_data:updatePromotion70Mission(data)
end

-- 宝箱领取推送
function PromotionResponse:handlePromotion70GetMissionBox(data)
    ex.Player.promotion_data:updatePromotion70GetMissionBox(data)
end

----------------------------七神器----------------------------
function PromotionResponse:handlePromotion71GetInfo(data)
    ex.Player.promotion_data:setPromotion71GetInfo(data.buy)
end

function PromotionResponse:handlePromotion71BuyGoods(data)
    ex.Player.promotion_data:updatePromotion71BuyRecord(data.buy)
    ex.EventManager:fire(EVENT.SEVEN_ARTIFACT.EVENT_BUY_GOODS)
end

---------------------------国庆活动-皮肤活动--------------------------------
function PromotionResponse:setMidFashionGetDataInfo(data)
    ex.Player.promotion_data:setMidFashionGetDataInfo(data)
end

function PromotionResponse:setMidFashionFashionCount(data)
    ex.Player.promotion_data:setMidFashionFashionCount(data)
end

function PromotionResponse:setMidFashionExchangeFashion(data)
    ex.Player.promotion_data:setMidFashionExchangeFashion(data)
end

--------------------------- 赏月任务 ---------------------------
function PromotionResponse:handleGetProm77Data(data)
    ex.Player.promotion_data:handleGetProm77Data(data)
end

function PromotionResponse:handleGetProm77MissionDone(data)
    ex.Player.promotion_data:handleGetProm77MissionDone(data)
end

function PromotionResponse:handleUpdateProm77Mission(data)
    ex.Player.promotion_data:handleUpdateProm77Mission(data)
end

function PromotionResponse:handlegetProm77BoxAward(data)
    ex.Player.promotion_data:handlegetProm77BoxAward(data)
end

-------------------------- 惊喜扭蛋 --------------------------
function PromotionResponse:setPromotion78GetInfo(data)
    ex.Player.promotion_data:setPromotion78GetInfo(data)
end

function PromotionResponse:handlePromotion78Select(data)
    ex.Player.promotion_data:handlePromotion78Select(data)
end

function PromotionResponse:handlePromotion78Draw(data)
    ex.Player.promotion_data:handlePromotion78Draw(data)
end

function PromotionResponse:handlePromotion78BoxReward(data)
    ex.Player.promotion_data:handlePromotion78BoxReward(data)
end

-------------------------- 鬼怪巡游会 --------------------------
function PromotionResponse:handlePromotion79GetInfo(data)
    ex.Player.promotion_data:setPromotion79GetInfo(data.buy)
end

function PromotionResponse:handlePromotion79BuyGoods(data)
    ex.Player.promotion_data:updatePromotion79BuyRecord(data.buy)
    ex.EventManager:fire(EVENT.HALLOWEEN.EVENT_BUY_GOODS)
end

-------------------------- 万圣任务 --------------------------
function PromotionResponse:handleGetProm80Data(data)
    ex.Player.promotion_data:handleGetProm80Data(data)
end

function PromotionResponse:handleGetProm80MissionDone(data)
    ex.Player.promotion_data:handleGetProm80MissionDone(data)
end

function PromotionResponse:handleUpdateProm80Mission(data)
    ex.Player.promotion_data:handleUpdateProm80Mission(data)
end

function PromotionResponse:handlegetProm80BoxAward(data)
    ex.Player.promotion_data:handlegetProm80BoxAward(data)
end

 -------------------------- 黑色星期五 -------------------------
function PromotionResponse:handlePromotion82GetInfo(data)
    ex.Player.promotion_data:setPromotion82GetInfo(data.buy)
end

function PromotionResponse:handlePromotion82BuyGoods(data)
    ex.Player.promotion_data:updatePromotion82BuyRecord(data.buy)
    ex.EventManager:fire(EVENT.BLACKFRIDAY.EVENT_BUY_GOODS)
end

-- 黑色通缉
function PromotionResponse:getBlackFiveLotteryGetDataInfo(data)
    ex.Player.promotion_data:getBlackFiveLotteryGetDataInfo(data)
end

function PromotionResponse:UpdateBlackFiveLotterySelectInfo(data)
    ex.Player.promotion_data:UpdateBlackFiveLotterySelectInfo(data)
end

function PromotionResponse:onBlackFiveLotterySummon(data)
    ex.Player.promotion_data:setBlackFiveLotteryRemainingCount(data.lottery_best_remaining_count)
    ex.Player.promotion_data:setBlackFiveLotterySummonCount(data.lottery_count)
    ex.Player.promotion_data:RedPointBlackFiveLottery()
    ex.EventManager:fire(EVENT.BLACKFRIDAY.SUMMON,data)
end

function PromotionResponse:onBlackFiveLotteryBoxReward(data)
    ex.Player.promotion_data:setBlackFiveLotteryRewardCord(data.idx)
    ex.Player.promotion_data:RedPointBlackFiveLottery()
    ex.EventManager:fire(EVENT.BLACKFRIDAY.BOX_REWARD)
end

function PromotionResponse:handleGetProm81MissionDone(data)
    ex.Player.promotion_data:handleGetProm81MissionDone(data)
end

function PromotionResponse:handleUpdateProm81Mission(data)
    ex.Player.promotion_data:handleUpdateProm81Mission(data)
end

function PromotionResponse:handlegetProm81BoxAward(data)
    ex.Player.promotion_data:handlegetProm81BoxAward(data)
end

function PromotionResponse:handleGetProm81Data(data)
    ex.Player.promotion_data:handleGetProm81Data(data)
end

function PromotionResponse:handlegetProm81Giftbuy(data)
    ex.Player.promotion_data:handlegetProm81Giftbuy(data.buy)
end

function PromotionResponse:handleGetProm92Data(data)
    ex.Player.promotion_data:handleGetProm92Data(data)
end

function PromotionResponse:handleGetSelectHero(data)
    ex.Player.promotion_data:handleGetSelectHero(data)
end

function PromotionResponse:handleGetDeliverFlower(data)
    ex.Player.promotion_data:handleGetDeliverFlower(data)
end

function PromotionResponse:handleGetDeliverCountRank(data)
    ex.Player.promotion_data:handleGetDeliverCountRank(data)
end

function PromotionResponse:handleGetDeliverFlowerCountReward(data)
    ex.Player.promotion_data:handleGetDeliverFlowerCountReward(data)
end

function PromotionResponse:handleGetDeliverHeroScoreRank(data)
    ex.Player.promotion_data:handleGetDeliverHeroScoreRank(data)
end

function PromotionResponse:handleGetDeliverBuyFlower(data)
    ex.Player.promotion_data:handleGetDeliverBuyFlower(data)
end

-------------------------------- 三日累充 --------------------------------
function PromotionResponse:handleGetProm84Data(data)
    ex.Player.promotion_data:handleGetProm84Data(data)
end

-- 领取奖励返回
function PromotionResponse:handleGetProm84ThreeDayGet(data)
    ex.Player.promotion_data:handleGetProm84ThreeDayGet(data)
end

-- 更新奖励
function PromotionResponse:UpdataProm84Recharge(data)
    ex.Player.promotion_data:UpdataProm84Recharge(data)
end

--------------------------- 圣诞活动 ---------------------------
-- 圣诞活动 圣诞连线
function PromotionResponse:handleGetProm85Data(data)
    ex.Player.promotion_data:handleGetProm85Data(data)
end

function PromotionResponse:handleGetProm85MissionDone(data)
    ex.Player.promotion_data:handleGetProm85MissionDone(data)
end

function PromotionResponse:handleUpdateProm85Mission(data)
    ex.Player.promotion_data:handleUpdateProm85Mission(data)
end

function PromotionResponse:handlegetProm85BoxAward(data)
    ex.Player.promotion_data:handlegetProm85BoxAward(data)
end

--圣诞活动 约惠圣诞
function PromotionResponse:handlePromotion86GetInfo(data)
    ex.Player.promotion_data:setPromotion86GetInfo(data.buy)
end

function PromotionResponse:handlePromotion86BuyGoods(data)
    ex.Player.promotion_data:updatePromotion86BuyRecord(data.buy)
    ex.EventManager:fire(EVENT.CHRISTMAS.EVENT_BUY_GOODS)
end

--圣诞活动 嗨翻圣诞
function PromotionResponse:handleGetProm87Data(data)
    ex.Player.promotion_data:handleGetProm87Data(data)
end

function PromotionResponse:handlePromotion87Draw(data)
    ex.Player.promotion_data:handlePromotion87Draw(data)
end

--圣诞活动 圣诞礼盒
function PromotionResponse:handleGetProm88Data(data)
    ex.Player.promotion_data:handleGetProm88Data(data)
end

function PromotionResponse:handleGetProm88ExchangeScore(data)
    ex.Player.promotion_data:handleGetProm88ExchangeScore(data)
end

function PromotionResponse:handleGetProm88Box(data)
    ex.Player.promotion_data:handleGetProm88Box(data)
end

--圣诞活动 感谢信
function PromotionResponse:handleGetProm89Data(data)
    ex.Player.promotion_data:handleGetProm89Data(data)
end

function PromotionResponse:handlegetProm89Reward(data)
    ex.Player.promotion_data:handleGetProm89Data(data)
end

--春节活动 惊喜盲盒
function PromotionResponse:setPromotion91BreakEggTurnsData(data)
    ex.Player.promotion_data:handleGetPromotion91BreakEggTurnsData(data)
end

--春节活动 惊喜盲盒-砸蛋
function PromotionResponse:setPromotion91EggReward(data)
    ex.Player.promotion_data:handleGetPromotion91EggReward(data)
   
end

--春节活动 惊喜盲盒-盲盒
function PromotionResponse:setPromotion91BlindBoxReward(data)
    ex.Player.promotion_data:handleGetPromotion91BlindBoxReward(data)
end


--春日活动
-- 活动一：春日踏青
function PromotionResponse:handleGetProm93Data(data)
    ex.Player.promotion_data:handleGetProm93Data(data)
end

function PromotionResponse:getProm93GridDiceData(data)
    ex.Player.promotion_data:getProm93GridDiceData(data)
end

function PromotionResponse:getProm93GridScenicRewardData(data)
    ex.Player.promotion_data:getProm93GridScenicRewardData(data)
end

-- 活动二：制作彩蛋
function PromotionResponse:handleGetProm94Data(data)
    ex.Player.promotion_data:handleGetProm94Data(data)
end

function PromotionResponse:handleGetProm94ExchangeScore(data)
    ex.Player.promotion_data:handleGetProm94ExchangeScore(data)
end

function PromotionResponse:handleGetProm94Box(data)
    ex.Player.promotion_data:handleGetProm94Box(data)
end

-- 活动三：春游记
function PromotionResponse:handlePromotion95GetInfo(data)
    ex.Player.promotion_data:setPromotion95GetInfo(data.buy)
end

function PromotionResponse:handlePromotion95BuyGoods(data)
    ex.Player.promotion_data:updatePromotion95BuyRecord(data.buy)
    ex.EventManager:fire(EVENT.SPRING.EVENT_BUY_GOODS)
end

-- 活动四：出游寻春
function PromotionResponse:handleGetProm96Data(data)
    ex.Player.promotion_data:handleGetProm96Data(data)
end

function PromotionResponse:handleGetProm96MissionDone(data)
    ex.Player.promotion_data:handleGetProm96MissionDone(data)
end

function PromotionResponse:handleUpdateProm96Mission(data)
    ex.Player.promotion_data:handleUpdateProm96Mission(data)
end

function PromotionResponse:handlegetProm96BoxAward(data)
    ex.Player.promotion_data:handlegetProm96BoxAward(data)
end

----------五一活动 start---------------
function PromotionResponse:handleGetProm97Data(data)
    ex.Player.promotion_data:handleGetProm97Data(data)
end

function PromotionResponse:handleGetProm97ResetData(data)
    ex.Player.promotion_data:handleGetProm97ResetData(data)
end

function PromotionResponse:handleGetProm97Record(data)
    ex.Player.promotion_data:handleGetProm97Record(data)
end

function PromotionResponse:handleGetProm97Choice(data)
    ex.Player.promotion_data:handleGetProm97Choice(data)
end
----------------- end ---------------

return PromotionResponse
