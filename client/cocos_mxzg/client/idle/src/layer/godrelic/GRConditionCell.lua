local GRConditionCell = class("GRConditionCell", require("src.comp.EventLayer"))

function GRConditionCell:onCreate()

    self.pre_round = 0
    self.round = 0
    self.heroes = {}

    self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:setIgnoreAnchorPointForPosition(false)
    self:setAnchorPoint(0, 1)

    self:addEvent(EVENT.GOD_RELIC.BATTLE_END, handler(self, self.updateCondition))
    self:addEvent(EVENT.GOD_RELIC.BATTLE_CONTINUE,handler(self,self.roundMark))
    self:addEvent(EVENT.BATTLE_EVENT.UPDATE_ROUND,handler(self,self.roundUpdate))

    self:addTimer("updateHp", 1000, handler(self, self.updateCondition), true)
end

function GRConditionCell:setBattleLayer(layer)
    self.battle_layer = layer
end

function GRConditionCell:reset(data)
    self.data = data
    if not data or table.nums(self.data) <= 0 then
        return
    end

    self:updateCondition()
end

function GRConditionCell:roundMark()
    self.pre_round =  self.round
end

function GRConditionCell:roundUpdate(evt, battle_layer, data)
    if self.battle_layer ~= battle_layer then
        return
    end

    self.round = self.pre_round + data.roundNumber
    self.heroes = data.heroes
    self:updateCondition()

    -- self.battle_layer.battle_info:setRound(nil, {cur_round = self.round, all = 15})
end

function GRConditionCell:updateCondition()
    local config = cfg.godrelic.getMissionConfig(self.data.starMap.chapter, self.data.starMap.level)
    local mission_data = self.data.starMap
    for i,v in ipairs(config.target) do
        self["lbl_condition"..i]:setString(ex.Tools:getLang(cfg.godrelictarget.godrelictarget[v].language))
        -- self["lbl_condition"..i]:setString(ex.Tools:getLang(cfg.godrelictarget.godrelictarget[v].language))
        local is_client_comp = self:isLight(v)
        if (is_client_comp ~= nil and is_client_comp == true) or (is_client_comp == nil and mission_data and TableEx.isInTable(mission_data.complete_id, v) ~= nil)  then
            ex.Tools:setSpriteFrame(self["spr_star"..i], "other/star-0.png")
        else
            ex.Tools:setSpriteFrame(self["spr_star"..i], "god-relic/xxwx.png")
        end
    end
end

function GRConditionCell:isLight(complete_id)
    -- 暂时由前端运算。到时候由后端计算，只精确到回合
    local config = cfg.godrelictarget.godrelictarget[complete_id]
    if not config then
        return
    end

    if config.target.type == "PASS" then
        return false 
    elseif config.target.type == "HERO_ALIVE_MORE"  then
        for _,v in pairs(self.heroes) do
            local hero = v:getBattleNode()
            if v._team == 1 and hero and hero.getHp and hero:getHeroId() ~= 0 and hero:getMaxHp() > 0 and hero:getHp() <= 0 then
                return false
            end 
         end
         return true
    elseif config.target.type == "HP_RATE_MORE"  then
        for _,v in pairs(self.heroes) do
            local hero = v:getBattleNode()
           if v._team == 1 and hero and hero.getHp and hero:getHeroId() ~= 0 and hero:getMaxHp() > 0 and hero:getHp() < hero:getMaxHp() * 0.5 then
               return false
           end 
        end
        return true
    elseif config.target.type == "ROUND_LESS" then
        return self.round <= config.target.condition1
    end
    return nil
end

return GRConditionCell