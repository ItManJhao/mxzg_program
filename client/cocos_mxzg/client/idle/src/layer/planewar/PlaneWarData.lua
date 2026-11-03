-- 位面之战数据
local PlaneWarData = class("PlaneWarData")

function PlaneWarData:ctor()
    self.challenge_count = 0            -- 挑战次数
    self.remaining_buy_count = 0        -- 剩余购买次数
    self.max_challenge_count = 0        -- 最大挑战次数
    self.turn = 0                       -- 轮次
    self.instance_list = {}             -- 副本列表
    self.privilege_expire_time = -1     -- 特权过期时间
    self.rank_list = {}                 -- 排行列表
    self.self_rank_data = {}            -- 自己的排行数据
    self.last_get_info_time = 0         -- 上次获取数据时间戳
    self.had_buy_count = 0              -- 已购买次数
end

return PlaneWarData