local GodRelicData = class("GodRelicData")

function GodRelicData:ctor()
    self.selected_chapter = nil

    self.vec_data = {}

    -- godrelicstarreward 对应的idx
    self.vec_star = {}

    self.can_challenge_count = 0

    self.buy_count = 0

    self.chapter_max_num = nil
end

-- 关卡是否可以攻打
function GodRelicData:isOpenMission(chapter, level)

    local config = cfg.godrelic.getMissionConfig(chapter, level)

    if not config then
        return false
    end

    -- 第一关默认开启
    local is_open_chapter = self:isOpenChapter(chapter)
    if is_open_chapter == false then
        return false
    end
    
    if config.level == 1 then
        return true
    end

    for i,v in ipairs(self.vec_data) do
        if v.chapter == config.chapter and v.level == config.level - 1 and table.nums(v.complete_id) > 0 then
            return true
        end
    end

    return false
end

-- 计算已获取的星数，如果chapter～=nil。则返回指定关卡的星数
function GodRelicData:getStarCount(chapter)
    local star = 0
    for i,v in ipairs(self.vec_data) do
        if chapter == nil or v.chapter == chapter then
            star = star + table.nums(v.complete_id)
        end
    end
    return star
end

-- 是否可以进去章节
function GodRelicData:isOpenChapter(chapter)
    -- local star = self:getStarCount()
    -- if cfg.godrelicunlock.godrelicunlock[chapter].unlock_need_star <= star then
    --     return true
    -- end
    -- return false
    if chapter == 1 then
        return true
    end

    for i,v in ipairs(cfg.godrelic.godrelic) do
        if v.chapter == chapter - 1 then
            local mission_data = self:getMissionData(v.chapter, v.level)
            if mission_data == nil  then
                return false
            end

            if table.nums(mission_data.complete_id) <= 0 then
                return false
            end
        end
    end

    return true
end

-- 计算已经开启的章节
function GodRelicData:getOpenChapterList()
    local vec_chapter = {}
    -- 优化遍历速度
    local tmp_chapter = nil
    -- for i,v in pairs(cfg.godrelic.godrelic) do
    --     if tmp_chapter ~= v.chapter then
    --         tmp_chapter = v.chapter
    --         if self:isOpenChapter(v.chapter) then
    --             local iter_find = TableEx.findValueFunction(vec_chapter, function(data)
    --                 return data[1].chapter == v.chapter
    --             end)
                
    --             if iter_find then
    --                 table.insert(iter_find, v)
    --             else
    --                 table.insert(vec_chapter, {v})
    --             end
    --         end
    --     end
    -- end
    for i,v in ipairs(cfg.godrelic.godrelic) do
        if tmp_chapter ~= v.chapter then
            tmp_chapter = v.chapter
            if self:isOpenChapter(v.chapter) then
                local iter_find = TableEx.findValueFunction(vec_chapter, function(data)
                    return data[1].chapter == v.chapter
                end)
                
                if iter_find then
                    table.insert(iter_find, v)
                else
                    table.insert(vec_chapter, {v})
                end
            end
        end
    end
	return vec_chapter
end

function GodRelicData:getBattleChapterList()
    local vec_battle = {}
    local vec_chapter = ex.Player.god_relic_data:getOpenChapterList()

    for i,v in ipairs(vec_chapter) do
        if self:isCanBattle(v[1].chapter) then
            table.insert(vec_battle, v)
        end
    end
    return vec_battle
end

function GodRelicData:isCanBattle(chapter)
    local star_count = ex.Player.god_relic_data:getStarCount()
    if cfg.godrelicunlock.godrelicunlock[chapter] and cfg.godrelicunlock.godrelicunlock[chapter].unlock_need_star <= star_count then
        return true
    end
    return false
end

-- 获取当前章节最多可以获取多少个星
function GodRelicData:getMaxStar(chapter)
    local max_star = 0
    for i,v in pairs(cfg.godrelicstarreward.godrelicstarreward) do
        if v.chapter == chapter then
            if v.star > max_star then
                max_star = v.star
            end
        end
    end
    return max_star
end

-- 章节是完美通关
function GodRelicData:isPerfect(chapter)
    return self:getMaxStar(chapter) <= self:getStarCount(chapter)
end

-- 关卡是否是满星
function GodRelicData:isMissionPerfect(chapter, level)
    local mission_data = self:getMissionData(chapter, level)
    return mission_data and table.nums(mission_data.complete_id) >= 3
end

-- 获取章节列表
function GodRelicData:getChapterData(chapter)
    local list = {}

    for i,v in ipairs(self.vec_data) do
        if v.chapter == chapter then
            table.insert(list, v)
        end
    end
    return list
end


function GodRelicData:getMaxChapter()
    if self.chapter_max_num then
        return self.chapter_max_num
    end
    
    local max_chapter = 0
    for i,v in pairs(cfg.godrelicstarreward.godrelicstarreward) do
        if v.chapter > max_chapter then
            max_chapter = v.star
        end
    end
    self.chapter_max_num = max_chapter
    return self.chapter_max_num
end


-- 获取已通关的关卡数据
function GodRelicData:getMissionData(chapter, level)
    for i,v in ipairs(self.vec_data) do
        if v.chapter == chapter and v.level == level then
            return v
        end
    end
    return nil
end

-- 更新关卡数据
function GodRelicData:updateMissionData(data)
    local mission_data = self:getMissionData(data.chapter, data.level)
    if mission_data then
        mission_data.complete_id = data.complete_id
    else
        table.insert(self.vec_data, data)
    end
end

-- 获取宝箱状态 -1 : 已经领取. 0 : 可以领取   1 : 不可领取
function GodRelicData:getStarStatu(idx)
    local data = TableEx.isInTable(self.vec_star, idx)
    if data then
        return -1
    end

    local conig = cfg.godrelicstarreward.godrelicstarreward[idx]
    if not conig then
        return -1
    end

    -- 判断是否可以领取星数奖励
    local now_star = self:getStarCount(conig.chapter)
    return now_star >= conig.star and 0 or 1
end

-- 有挑战次数和有奖励可以领取时
function GodRelicData:checkReddot()

    local is_open = ex.JumpManager:checkOpenConditionByAtomNoMsg("main_god_relic")
    local is_visible = self.can_challenge_count > 0 and is_open

    local has_star_reward = false
    if is_open then
        for k,v in pairs(cfg.godrelicstarreward.godrelicstarreward) do
            if self:getStarStatu(v.idx) == 0 then
                has_star_reward = true
                break
            end
        end
    end
    
    ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YGZC_ZSYJ, is_visible or has_star_reward)
end

return GodRelicData
