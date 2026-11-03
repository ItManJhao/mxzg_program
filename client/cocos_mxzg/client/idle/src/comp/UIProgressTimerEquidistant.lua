
-- 用九宫格实现的伪进度条
-- type : 1 横向， type：2 纵向
local UIProgressTimerEquidistant = class("UIProgressTimerEquidistant", function(...)
    return cc.ProgressTimer:create(...)
end)

function UIProgressTimerEquidistant:ctor(...)
    self.type = 1
    self.percentage = 0
    self.size = cc.size(0, 0)

    self.max_count = 0

    -- [{pos:百分比距离, count:需要达到的点数}]
    self.vec_position = {}
end

function UIProgressTimerEquidistant:setPositionList(list)
    self.vec_position = list

    local max_count = 0
    for k,v in ipairs(self.vec_position) do
        if v.count >= max_count then
            max_count = v.count
        end
    end

    self.max_count = max_count
end

function UIProgressTimerEquidistant:addData(data, is_clear)
    if is_clear then
        self.vec_position = {}
    end

    table.insert(self.vec_position, data)

    local max_count = 0
    for k,v in ipairs(self.vec_position) do
        if v.count >= max_count then
            max_count = v.count
        end
    end

    self.max_count = max_count
end

function UIProgressTimerEquidistant:setPercentageCount(count)

    -- 上一段的进度
    local pre_percentage = 0
    local pre_count = 0

    local next_percentage = 0
    local next_count = 0

    for i,v in ipairs(self.vec_position) do
        if count > v.count then
            pre_percentage = v.pos
            pre_count = v.count
        else
            next_percentage = v.pos
            next_count = v.count
            break
        end
    end

    if (next_percentage == 0 or next_count == 0) and table.nums(self.vec_position) > 0 then
        next_percentage = self.vec_position[table.nums(self.vec_position)].pos
        next_count = self.vec_position[table.nums(self.vec_position)].count
    end
    
    -- 计算两个阶段的进度差
    local percentage_diff = next_percentage - pre_percentage
    local count_diff = next_count - pre_count

    -- 计算当前进度位置
    local cur_count = (count - pre_count) / count_diff
    local cur_percentage = pre_percentage + percentage_diff * cur_count

    self:setPercentage(cur_percentage)
end

return UIProgressTimerEquidistant
