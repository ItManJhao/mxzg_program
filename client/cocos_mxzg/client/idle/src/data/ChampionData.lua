local ChampionData = class("ChampionData")

ChampionType = {
    IDLE = 0,
    TRIALS = 1,
    KNOCKOUT = 2,
    NOT_START = 3,
    END = 4,
}

ChampionStageType = {
    MATCH = 0,
    READY = 1,
    GUESS = 2,
    BATTLE = 2,
}


local ChampionTitle = {
    {[0]= ex.Tools:getLang(70779)},
    {[0]= ex.Tools:getLang(47350)},
    {[32]=ex.Tools:getLang(47036), [16] = ex.Tools:getLang(47399), [8] = ex.Tools:getLang(47166), [4] = ex.Tools:getLang(47406), [2] = ex.Tools:getLang(47381), [1] = ex.Tools:getLang(47192), [0]= ex.Tools:getLang(47092)}
}


function ChampionData:ctor()
    -- 赛季开始时间
    self.start_time = 0

    -- 战斗开始时间
    self.battle_start_time = 0

    -- 赛季结束时间
    self.end_time = 0

    -- 我的排名
    self.rank = 0

    -- 我最高的排名
    self.rank_max = 0

    -- 排行榜数据
    self.vec_rank = {}
    
    -- 自己被膜拜的次数
    self.worship_count = 0

    -- 赛季进度0空闲，1选拔赛，2淘汰赛
    self.period = 0

    -- 已经点赞的名次
    self.like_rank = {}

    -- 弹幕冷却时间
    self.biu_cd = 0

    -- 是否展示前三界面
    self.show_round = 0

    -- 是否展示我的战绩界面
    self.my_result = {}
    self.my_result.rank = 0

    -- 我的赛季数据
    self.my_champion = {}
    self.my_champion_battle = {}

    -- 战斗数据. 32强数据
    self.knockout_idx = {32, 16, 8, 4, 2}

    -- 具体的战斗数据 [32] = {} , [16] = {}, [8] = {}
    self.knockout_data = {}
    for i,v in ipairs(self.knockout_idx) do
        table.insert(self.knockout_data, {})
    end

    -- 整理后的数据32强
    self.knockout_block = {}

    -- 整理后的数据4强
    self.knockout_block4 = {}


    -- 当前进行的轮次
    self.battle_round = 0

    -- 正在进行竞猜的比赛ID
    self.guess_id = 0

    -- 下一阶段的时间
    self.battle_next_time = 0

    -- 比赛阶段，0匹配、1准备、2竞猜、3战斗
    self.battle_stage = 0
    
    self.vec_biu = {}

    self.vec_champion_rank = {}
end

-- 是否处于赛季中
function ChampionData:isInSeason()
    local now_time = ex.Game:getServerTime()
    return self.start_time <= now_time and self.end_time > now_time
end

function ChampionData:isLike(rid)
    return TableEx.findValueFunction(self.like_rank, function(value)
        return value == rid
    end) ~= nil
end

function ChampionData:isLimitLike()
    return self.like_rank == nil and true or table.nums(self.like_rank) >= ex.Tools:getSysCfg("champion_max_like")
end

function ChampionData:addLike(rid)

    local data = TableEx.findValueFunction(self.like_rank, function(value)
        return value == rid
    end)

    if data == nil then
        table.insert(self.like_rank, rid)
    end
end

function ChampionData:addLikeCount(rid)
    local rand_data = TableEx.findValueFunction(self.vec_rank, function(value)
        return value.rid ==  rid
    end)

    if rand_data then
        rand_data.like = rand_data.like + 1
    end
end

-- 总赔率
function ChampionData:getOddsCoe()
    return 3.5
end

-- 获取红方或蓝方的赔率
function ChampionData:getOdds(index)

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

    local vec_coin = {ex.Player.champion_data.guess.atk_coin, ex.Player.champion_data.guess.def_coin}
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



function ChampionData:getChampionTitle(period, battle_round)
    local title_data = ChampionTitle[period + 1]
    local str_title = title_data[battle_round]
    if str_title then
        str_title = string.format(str_title, battle_round)
    else
        str_title = string.format(title_data[0], battle_round)
    end

    return str_title
end


function ChampionData:getBattleStatus()
    local now_day = Maths.getDays(cpp.Game:instance():getServerTime())
    local begin_day = Maths.getDays(self.battle_start_time)
    -- return now_day == begin_day
	if self.period == ChampionType.IDLE then
		if self.start_time < self.battle_start_time and now_day == begin_day then
            return ChampionType.NOT_START
        elseif self.battle_start_time < self.end_time then
            return ChampionType.END
        end
    end

	return self.period
end



return ChampionData
