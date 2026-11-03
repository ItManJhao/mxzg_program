local HexagramData = class("HexagramData")

function HexagramData:ctor(parent)
    self.parent = parent

    self._hexagram_list = {}
end

function HexagramData:initData(data)
    if data == nil then
        return
    end

    for k,v in pairs(data) do
        self._hexagram_list[k] = v
    end

    ex.EventManager:fire(EVENT.HERO_HEXAGRAM_EVENT.UPDATE)
end

function HexagramData:getHexagramData(hero_id, type)
    for k,v in pairs(self._hexagram_list) do
        if k == hero_id then
            for k2,v2 in pairs(v) do
                if k2 == type then
                    return v2
                end
            end
        end
    end

    return nil
end

function HexagramData:getHexagramConfig(type, level)
    for i,v in ipairs(cfg.herohexagram.herohexagram) do
        if v.type == type and v.level == level then
            return v
        end
    end

    return nil
end

function HexagramData:getHexagramSkillLevelNeed(hexagram_type, skill_type)
    for i,v in ipairs(cfg.herohexagram.herohexagram) do
        if v.type == hexagram_type then
            for i2,v2 in ipairs(v.skill) do
                if v2.id == skill_type and v2.lv > 0 then
                    return v.level
                end
            end
            for i2,v2 in ipairs(v.skill2) do
                if v2.id == skill_type and v2.lv > 0 then
                    return v.level
                end
            end
        end
    end

    return -1
end

function HexagramData:setHexagramData(hero_id, type, level)
    for k,v in pairs(self._hexagram_list) do
        if k == hero_id then
            for k2,v2 in pairs(v) do
                if k2 == type then
                    v2.level = level
                    return
                end
            end

            v[type] = {hero_id = hero_id, type = type, level = level}
            return
        end
    end

    if self._hexagram_list[hero_id] == nil then
        self._hexagram_list[hero_id] = {}
    end
    self._hexagram_list[hero_id][type] = {hero_id = hero_id, type = type, level = level}
end

function HexagramData:isVisibleHexagram(hero_id)
    local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
    if not hero_data then return false end 
    return ex.Tools:getSysCfg("open_hexagram_hero_star") <= hero_data.star
end

function HexagramData:isOpenHexagram(hero_id)
    local hero_data = ex.Player.hero_data:getHeroDataById(hero_id)
    if not hero_data then return false end 
    return ex.JumpManager:checkOpenConditionByAtomNoMsg("hero_hexagram") and ex.Tools:getSysCfg("open_hexagram_hero_star") <= hero_data.star
end

function HexagramData:checkReddot(hero_id)
    if ctr.country_war.data:getStage() ~= COUNTRY_WAR_STATE.BATTLE then
		return false
	end

    local hexagram_type = ctr.country_war.data.type > 0 and ctr.country_war.data.type or 1
    local hexagram_data = self:getHexagramData(hero_id, hexagram_type)
    return self:canUpgrade(hero_id, hexagram_type) <= 0
end

-- 重置
function HexagramData:reset(hero_id, type)
    local hexagram_data = self:getHexagramData(hero_id, type)
    if hexagram_data == nil or hexagram_data.level <= 0 then
        return false
    end

    local req = HeroHexagram_pb.GReqHeroHexagramReset()
    req.hero_id = hero_id
    req.type = type
    NetManager:sendMessage(ProtocolID.GReqHeroHexagramReset, req)

    return true
end

function HexagramData:resetDone(hero_id, type)
    self:setHexagramData(hero_id, type, 0)

    ex.EventManager:fire(EVENT.HERO_HEXAGRAM_EVENT.RESET)
end

-- 是否可强化/突破
-- @return 1：等级不大于当前等级；2：等级已达上限；3：材料不足
function HexagramData:canUpgrade(hero_id, type)
    local hexagrame_data = self:getHexagramData(hero_id, type)
    local cur_level = hexagrame_data and hexagrame_data.level or 0

    -- 判断等级是否达到上限
    if self:getHexagramConfig(type, cur_level + 1) == nil then
        return 2
    end

    -- 判断材料是否足够
	local config = self:getHexagramConfig(type, cur_level)
    for i,v in ipairs(config.cost) do
        if ex.Player:getItemNum(v.item_type) < v.item_num then
            return 3
        end
    end

    return -1
end

-- 强化/突破
function HexagramData:upgrade(hero_id, type)
    local hexagrame_data = self:getHexagramData(hero_id, type)
    local cur_level = hexagrame_data and hexagrame_data.level or 0

    local flag = self:canUpgrade(hero_id, type)
    if flag <= 0 then
        local req = HeroHexagram_pb.GReqHeroHexagramUpgrade()
        req.hero_id = hero_id
        req.type = type
        req.level = cur_level + 1
        NetManager:sendMessage(ProtocolID.GReqHeroHexagramUpgrade, req)
    end

    return flag
end

function HexagramData:upgradeDone(hero_id, type, level)
    self:setHexagramData(hero_id, type, level)

    ex.EventManager:fire(EVENT.HERO_HEXAGRAM_EVENT.UPGRADE)
end

function HexagramData:clear()
    self._hexagram_list = {}
end

return HexagramData 
