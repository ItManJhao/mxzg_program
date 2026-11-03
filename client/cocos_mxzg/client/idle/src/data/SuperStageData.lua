local SuperStageData = class("SuperStageData")

local TopTitle = {
    [128]= ex.Tools:getLang(76060), 
    [64]= ex.Tools:getLang(71102), 
    [32]=ex.Tools:getLang(47036), 
    [16] = ex.Tools:getLang(47399),
    [8] = ex.Tools:getLang(47166), 
    [4] = ex.Tools:getLang(47406),
    [2] = ex.Tools:getLang(47381), 
    [1] = ex.Tools:getLang(75971), 
    [0]= ex.Tools:getLang(47415)
}

function SuperStageData:ctor()
    -- 常规赛
    self.cur_season = 1         -- 赛季
    self.season_start_time = 0  -- 賽季开始时间
    self.season_end_time = 0    -- 賽季结束时间
    self.match_end_time = 0     -- 匹配結束时间
    self.season_down_start_time = 1 -- 赛季下半段开始时间

    self.preliminary_qualification = false  -- 巔峰賽預賽資格
    self.top1_start_time = 0    -- 巅峰赛预赛开始时间
    self.top2_start_time = 0    -- 巅峰赛决赛开始时间

    local str_match_time = ex.Tools:getSysCfg("superstage_day_open")
    local vec_str = string.split(str_match_time, "_")
    self.day_match_start_time = tonumber(vec_str[1])    -- 每天可以匹配的開始時間
    self.day_match_end_time = tonumber(vec_str[2])      -- 每天可以匹配的結束時間

    self.cur_stage_id = -1      -- 段位id stage表的idx
    self.integral = 0           -- 段位积分
    self.elite_integral = 0     -- 精英积分
    self.battle_times_left = 0  -- 剩余匹配次数
    self.battle_times_buy_left = 0  -- 剩余购买匹配次数
    self.rank = 0;              -- 排名 0为未上榜
    self.reward_idx = 1         -- 已经领取的首達獎勵idx
    self.qualifying_match = false   -- 是否是晋级赛
    self.vec_advance_result = {}    -- 晋级赛结果列表

    self.is_matching = false        -- 是否正在匹配
    self.is_battling = false        -- 是否正在匹配
    self.match_player_info = nil    -- 匹配到的玩家信息

    self.is_buy_token = false   -- 是否已购买战令

    self.vec_battle_log = {}    -- 我的挑战记录
    self.vec_super_battle_log = {}  -- 大神挑战记录

    self.vec_legend = {}        -- 赛季传奇列表

    self.rank_list = {}         -- 赛季排行榜列表
    self.rank_self = {}         -- 赛季排行榜列表

    -- 赛季记录实时获取，可以不用缓存
    -- self.season_log_total = {}  -- 总赛季记录
    -- self.season_log_list = {}   -- 赛季记录列表

    self.token_info = {}        -- 战令信息

    -- 巅峰赛
    self.pinnacle_stage = 0      -- 巔峰賽階段(0，未開啟；5，預賽；6，決賽)

    -- 巅峰赛预赛
    self.ladder_main_data = {
        rank = 0,
        defenders = {}
    }

    self.top_battle_times_left = 0  -- 剩余匹配次数
    self.top_battle_times_buy_left = 0  -- 剩余购买匹配次数

    self.vec_top_battle_log = {}        -- 我的挑战记录
    self.vec_top_super_battle_log = {}  -- 大神挑战记录

    -- 巅峰赛决赛
    self.battle_start_time = 0  -- 战斗开始时间
    
    self.battle_round = 0   -- 当前进行的轮次
    self.battle_stage = 0   -- 比赛阶段，0匹配、1准备、2竞猜、3战斗
    self.battle_next_time = 0   -- 下一阶段的时间

    self.guess_id = 0       -- 正在进行竞猜的比赛ID

    self.top_rank = 0       -- 我的排名
    self.top_rank_max = 0   -- 我最高的排名
    self.vec_top_rank = {}  -- 排名列表
    
    self.worship_count = 0  -- 自己被膜拜的次数
    
    self.like_rank = {}     -- 已经点赞过的玩家id列表

    self.vec_biu = {}       -- 弹幕列表
    self.biu_cd = 0         -- 弹幕冷却时间
    
    self.show_round = 0     -- 是否展示前三界面

    -- 是否展示我的战绩界面
    self.my_result = {}
    self.my_result.rank = 0

    -- 我的赛季数据
    self.my_champion = {}
    self.my_champion_battle = {}

    -- 战斗数据. 32强数据
    self.knockout_idx = {128, 64, 32, 16, 8, 4, 2}

    -- 具体的战斗数据 [32] = {} , [16] = {}, [8] = {}
    self.knockout_data = {}
    for i,v in ipairs(self.knockout_idx) do
        table.insert(self.knockout_data, {})
    end

    self.knockout_block1 = {}   -- 整理后的数据128强
    self.knockout_block2 = {}   -- 整理后的数据16强
    self.knockout_block3 = {}   -- 整理后的数据冠亚军
end

-- is_go_main 為是否進入主界面
function SuperStageData:reqInfo(is_go_main)
    if ex.JumpManager:checkOpenConditionByAtomNoMsg("main_super_stage") then
        local req_stage_rank = StageMatch_pb.GReqStageMatchData()
        req_stage_rank.role_request = is_go_main or false
        NetManager:sendMessage(ProtocolID.GReqStageMatchData, req_stage_rank)

        NetManager:sendMessage(ProtocolID.GReqStageToken)
    end
end

-- 賽季是否開放，否則如果在功能界面就返回主城界面
function SuperStageData:isOpen()
    local now = ex.Game:getServerTime()
    return now >= self.season_start_time and now < self.season_end_time
end

function SuperStageData:isTopOpen()
    local now = ex.Game:getServerTime()
    return now >= self.season_start_time and now < self.season_end_time and self.top1_start_time > 0 and now >= self.top1_start_time
end

-- 是否可匹配，否則不顯示匹配按鈕，如果在匹配界面則返回主界面
function SuperStageData:canMatch()
    local now = ex.Game:getServerTime()

    -- 賽季已結束
    if now >= self.season_end_time then
        return false
    end

    -- 賽季未開始
    if now < self.season_start_time then
        return false
    end

    -- 如果在賽季結算階段，則不可匹配
    if now >= self.match_end_time then
        return false
    end

    -- 如果在每天的結算階段，則不可匹配
    local time = os.date("*t", ex.Game:getServerTime())
    local cur_time = time.hour * 3600 + time.min * 60 + time.sec
    if cur_time >= self.day_match_end_time or cur_time < self.day_match_start_time then
        return false
    end

    return true
end

function SuperStageData:checkReddot()
    if not self:isOpen() or not ex.JumpManager:checkOpenConditionByAtomNoMsg("main_super_stage") or ex.Player.super_stage_data.cur_season <= 0 then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS_WZZL, false)
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS_SDLJ, false)
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS_KSPP, false)
        return
    end

    local config_stage_reward = cfg.superstage.superstage[self.reward_idx + 1]
    
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS_KSPP, self.battle_times_left > 0)
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS_SDLJ, config_stage_reward ~= nil and self.cur_stage_id > self.reward_idx)

    local can_token_reward = false
    local is_lock = not self.token_info.had_buy
    local win_count = self.token_info.win_count or 0
    for i,v in ipairs(cfg.superstagetokenreward.superstagetokenreward) do
        if win_count >= v.win_count then
            local vec_reward_idx = self.token_info.reward_id or {}
            local has_reward = false
            for _,v2 in pairs(vec_reward_idx) do
                if v2 == v.idx then
                    has_reward = true
                    break
                end
            end

            local has_token_reward = true
            if not is_lock and not has_reward then
                has_token_reward = false
                local vec_reward_idx = self.token_info.token_reward_id or {}
                for _,v2 in pairs(vec_reward_idx) do
                    if v2 == v.idx then
                        has_token_reward = true
                        break
                    end
                end
            end

            if not has_reward or not has_token_reward then
                can_token_reward = true
            end
        end

        if can_token_reward then
            break
        end
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_CGS_WZZL, can_token_reward)
end

function SuperStageData:checkTopReddot()
    -- 决赛部分没有红点
    local now = ex.Game:getServerTime()
    if not self:isTopOpen() or 
        not self.preliminary_qualification or
        not ex.JumpManager:checkOpenConditionByAtomNoMsg("main_super_stage") or 
        ex.Player.super_stage_data.cur_season <= 0 then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS_ZD, false)
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS_DZ, false)
        return
    end

    if now < self.top2_start_time then
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS_ZD, self.top_battle_times_left > 0)
    end

    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_KFSK_CFDWS_DFS_DZ, not self:isLimitLike())
end

function SuperStageData:refreshVSPlayerData(defenders)
    if defenders == nil then return end

    self.ladder_main_data.defenders = {}
    self.ladder_main_data.defenders = defenders

    table.sort(self.ladder_main_data.defenders, function(a, b)
        return a.ladder_rank < b.ladder_rank
    end)
end

function SuperStageData:getTopTitle(battle_round)
    local str_title = TopTitle[battle_round]

    return str_title or ""
end

function SuperStageData:isLike(rid)
    return TableEx.findValueFunction(self.like_rank, function(value)
        return value == rid
    end) ~= nil
end

function SuperStageData:isLimitLike()
    return self.like_rank == nil and true or table.nums(self.like_rank) >= ex.Tools:getSysCfg("topmatch_max_like")
end

function SuperStageData:addLike(rid)
    local data = TableEx.findValueFunction(self.like_rank, function(value)
        return value == rid
    end)

    if data == nil then
        table.insert(self.like_rank, rid)
    end
end

function SuperStageData:addLikeCount(rid)
    local rand_data = TableEx.findValueFunction(self.vec_top_rank, function(value)
        return value.rid ==  rid
    end)

    if rand_data then
        rand_data.like = rand_data.like + 1
    end
end

-- 总赔率
function SuperStageData:getOddsCoe()
    return 3.5
end

-- 获取红方或蓝方的赔率
function SuperStageData:getOdds(index)
-- A的赔率=math.round[(1.5+0.5*(A/(A+B)))*100]/100
-- A的赔率=max（A的赔率，1.51）
-- A的赔率=min（A的赔率，1.99）
-- B的赔率=3.5- A的赔率
-- 	Else
-- 		A的赔率=A的赔率
--         B的赔率=3.5-A的赔率
        
    if not self.guess then
        return self:getOddsCoe() / 2
    end

    local vec_coin = {ex.Player.super_stage_data.guess.atk_coin, ex.Player.super_stage_data.guess.def_coin}
    local max_coin = vec_coin[1] + vec_coin[2]
    
    local a = index == 1 and vec_coin[1] or vec_coin[2]
    local b = index == 1 and vec_coin[2] or vec_coin[1]

    if a + b <= 0 then
        return self:getOddsCoe() / 2
    end

    local odds = math.round((1.5 + 0.5 * (a/(a+b))) *100) / 100
    odds = math.max(odds, 1.5)
    odds = math.min(odds, 2)
    return self:getOddsCoe() - odds
end

return SuperStageData
