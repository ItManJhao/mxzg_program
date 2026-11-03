local HeroAstrolabeData = class("HeroAstrolabeData")

function HeroAstrolabeData:ctor(parent)
    self.parent = parent

    self.is_enabled = false     -- 是否激活星盘
    
    self.actived_elem = {}      -- 已激活元素

    self.max_star = 0           -- 最大星级
    self.astrolabe_skill = {}   -- 星盘技能列表

    ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.CHANGE_ITEM, handler(self, self.checkRedPoint))
end

function HeroAstrolabeData:setEnabled(is_enabled)
    self.is_enabled = is_enabled

    self:checkRedPoint()
end

function HeroAstrolabeData:isEnabled()
    return self.is_enabled
end

function HeroAstrolabeData:setMaxStar(star)
    self.max_star = star

    self:checkStarPanelRedPoint()
end

function HeroAstrolabeData:updateActivedElem(list)
    self.actived_elem = {}

    for i, v in ipairs(list) do
        table.insert(self.actived_elem, v)
    end

    table.sort(self.actived_elem, handler(self, self.sortActivedElem))

    self:checkUnlockPanelRedPoint()
end

function HeroAstrolabeData:addActivedElem(elem)
    if elem == nil then return end

    for i, v in ipairs(self.actived_elem) do
        if v == elem then
            return
        end
    end

    table.insert(self.actived_elem, elem)

    table.sort(self.actived_elem, handler(self, self.sortActivedElem))

    self:checkUnlockPanelRedPoint()
end

function HeroAstrolabeData:sortActivedElem(a, b)
    return a < b
end

function HeroAstrolabeData:updateAstrolabeSkill(k_v_list)
    self.astrolabe_skill = {}

    for i, v in ipairs(k_v_list) do
        local data = {}
        data.idx = v.key
        data.skill_id = v.value

        table.insert(self.astrolabe_skill, data)
    end

    self:checkStarPanelRedPoint()
end

--------------------------------TOOLS--------------------------------
-- 元素是否已激活
function HeroAstrolabeData:isActivedByElem(elem)
    for i, v in ipairs(self.actived_elem) do
        if v == elem then
            return true
        end
    end

    return false
end

-- 元素盘是否全激活
function HeroAstrolabeData:isAllElemActived()
    local elems = cfg.astrolabeelement.getSetForIdx()

    for i, v in ipairs(elems) do
        if not self:isActivedByElem(v) then
            return false
        end
    end

    return true
end

-- 获取星座技能
function HeroAstrolabeData:getSkillByIdx(idx)
    for i, v in ipairs(self.astrolabe_skill) do
        if v.idx == idx then
            return v.skill_id
        end
    end

    return nil
end

-- 星座是否已激活
function HeroAstrolabeData:isActivedByStar(idx)
    for i, v in ipairs(self.astrolabe_skill) do
        if v.idx == idx then
            return true
        end
    end

    return false
end

-- 获取下一个可激活星座
function HeroAstrolabeData:getNextStarActionable()
    local star_set = cfg.astrolabe.getSetForStar()

    for i,v in ipairs(star_set) do
        if not self:isActivedByStar(v) then
            return v
        end
    end

    return -1   -- 全部激活
end

--------------------------------红点--------------------------------
function HeroAstrolabeData:checkRedPoint()
    if not ex.JumpManager:checkOpenConditionByAtomNoMsg("hero_astrolabe") then
        return
    end

    -- 资源有改变，检查红点
    self:checkStarPanelRedPoint()

    self:checkUnlockPanelRedPoint()
end

function HeroAstrolabeData:checkUnlockPanelRedPoint()
    if not ex.JumpManager:checkOpenConditionByAtomNoMsg("hero_astrolabe") then
        return
    end

    if self:isEnabled() then    -- 已激活元素星盘
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_XP_JSXP, false)
        return
    end

    if self:isAllElemActived() then -- 星盘可以解锁
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_XP_JSXP, true)
        return
    end

    if ex.Tools:hasItemList(cfg.system.astrolabe_active_elem_cost, false) then  -- 可以激活星盘元素
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_XP_JSXP, true)
        return
    else    -- 资源不够
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_XP_JSXP, false)
    end
end

function HeroAstrolabeData:checkStarPanelRedPoint()
    if not ex.JumpManager:checkOpenConditionByAtomNoMsg("hero_astrolabe") then
        return
    end

    if not self:isEnabled() then
        return
    end

    local idx = self:getNextStarActionable()
    if idx == -1 then   -- 全部激活
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_XP_XPXZJM, false)
        return
    end

    local config = cfg.astrolabe.getConfigByIdx(idx)
    if config then
        if cfg.astrolabe.isSkillByIdx(idx) then
            -- 是技能星座的话，判断消耗
            if self.max_star >= config.star and ex.Tools:hasItemList(config.cost, false) then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_XP_XPXZJM, true)
                return
            end
        else
            -- 不是技能星座的话，判断星级
            if self.max_star >= config.star then
                ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_XP_XPXZJM, true)
                return
            end
        end

        -- 不满足条件
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_XP_XPXZJM, false)
        return
    else    -- 缺省，无配置
        ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_XP_XPXZJM, false)
        return
    end
end

return HeroAstrolabeData