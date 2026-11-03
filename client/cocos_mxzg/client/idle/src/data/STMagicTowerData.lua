-- 时空魔塔数据
local STMagicTowerData = class("STMagicTowerData")

function STMagicTowerData:ctor()
    self.mission_id = 1     -- 最后通过的关卡ID
    self.cur_lv = 0         -- 玩家当前层数
    self.accumulate_pass = 0    -- 本周累计通过
    self.max_pass = 0           -- 最高通过关数
    self.heart = 3              -- 当前心心数
    self.mission_condition_str = ""  -- 当前关卡通过要求描述
    self.my_rank = 0            -- 我的排名
    self.mission_mark = {}      -- 前三关的评分列表
    self.rank_list = {}    -- 时空魔塔排行榜列表
    self.startTime = 0      -- 赛季开始时间，时间为0时不做处理
    self.endTime = 0        -- 赛季结束时间，时间为0时不做处理
end

return STMagicTowerData