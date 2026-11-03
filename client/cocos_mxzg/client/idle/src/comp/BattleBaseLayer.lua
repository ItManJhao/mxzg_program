
local BattleBaseLayer = class("BattleBaseLayer", function()
                                                    return cc.Layer:create()
                                                end)

local BattleRole = class("BattleRole")

function BattleRole:ctor()

end

local BattleHero = class("BattleHero")

function BattleHero:ctor()

end


function BattleBaseLayer:onCreate()
    -- 战斗id
    self.battle_id = 0

    -- 战斗状态
    self.battle_status = 0

    -- 技能系统
    self.skill_system = nil

    -- 当前回合
    self.battle_round = 0

    -- 初始节点
    self.node_scene = nil

    -- 只保存英雄的节点
    self.node_hero = nil

    -- 背景图节点
    self.node_bg = nil

    -- 定时器
    self.action_interval = nil

    -- 动作时间
    self.action_time = nil

    -- 时间倍数
    self.time_scale = nil

    -- 时间差
    self.time_diff = 0.0

    -- 地图大小。影响英雄站位
    self.map_size = cc.size(0, 0)

    -- 地图初始位置
    self.map_pos = cc.p(0,0)

    -- 战斗类型
    self.battle_type = nil

    -- 计时器和动作管理器
    self.scheduler_mgr = nil
    self.action_mgr = nil

    -- 所有英雄数据 {1:[{player_id,herolist:[id]}], } 1:队伍
    self.map_battle_role = {}

    -- 玩家速度数据
    self.vec_attack_speed = nil
end

function BattleBaseLayer:enter()
    if self.skill_system then
        self.skill_system:setRunAction(true)
        self.skill_system:setSceneBase(true)
    end
end

function BattleBaseLayer:addBattleRold(role_id, team)
    local iter_team = self.map_battle_role[team]
    if iter_team == nil then
        local battle_role = battle_role:new()
        battle_role.role_id = role_id

        table.insert(iter_team.role_list, battle_role)
    else
        print(ex.Tools:getLang(47675))
    end

    return nil
end

function BattleBaseLayer:getBattleRole(role_id)
    for k,v in pairs(self.map_battle_role) do
        for kr,vr in pairs(v.role_list) do
            if vr.role_id == role_id then
                return vr
            end
        end
    end

    return nil
end

function BattleBaseLayer:addBattleHero(role_id,
                                       hero_id,
                                       level,
                                       index,
                                       type,
                                       occupation,
                                       attack_elem,
                                       elem,
                                       hp_max,
                                       hp_add,
                                       round,
                                       attack,
                                       attack_add,
                                       defense,
                                       defense_add,
                                       speed,
                                       anger,
                                       attack_skill,
                                       attack_skill_level,
                                       active_skill,
                                       active_skill_level,
                                       skin,
                                       node_parent)

    local battle_role = self:getBattleRole(role_id)
    if not battle_role then
        return nil
    end

    local team = self:getTeamByRoleID(role_id)

    local hero_data = BattleHero:new()
    hero_data.hero_id = hero_id
    hero_data.role_id = battle_role.role_id
    hero_data.team = team
    hero_data.index = index
    hero_data.level = level
    hero_data.type = type
    hero_data.occupation = occupation
    hero_data.attack_elem = attack_elem
    hero_data.elem = elem
    hero_data:setHpMaxBase(hp_max * hp_add)
    hero_data:setHpMax(hero_data:getHpMaxBase())
    hero_data:setHp(hero_data:getHpMax())
    hero_data:setRound(round)
    hero_data:setAttackBase(attack * attack_add)
    hero_data:setDefenseBase(defense * defense_add)
    hero_data.speed = speed
    hero_data.attack_skill_type = attack_skill
    hero_data.attack_skill_level = attack_skill_level

    hero_data.active_skill_type = active_skill
    hero_data.active_skill_level = active_skill_level
    hero_data.anger = anger

    if node_parent then
        local hero = Hero:createWithData(hero_data.hero_id, battle_role.role_id, type, 1, 1, skin)
        hero:setBattleHero(hero_data)
        -- hero:setEnabled(false);
        hero:setFlippedX((team % 2) == 1)
        hero:setPosition(self:getHeroPosition(team, index))
        hero:setShowDamage(true)
        hero:updateZOrder(0)
        hero:setScale(0.65)
        hero:setScheduler(self.scheduler_mgr)
        hero:setActionManager(self.action_mgr)
        hero:resetTimeScale()
        hero:showHP()
        hero:showAnger()
        hero:showLevel(level)
        hero:showElem(elem)
        hero:startUpdateZOrder()
        node_parent:addChild(hero)

        hero_data:setHero(hero)
    end

    table.insert(battle_role.hero_list, hero_data)
    self:addHeroPriorAttackData(hero_data)
    return hero_data
end

function BattleBaseLayer:getBattleRoleByTeam(team)
    return self.map_battle_role[team]
end

function BattleBaseLayer:getTeamByRoleID(role_id)
    for k,v in pairs(self.map_battle_role) do
        for kr,vr in pairs(v.role_list) do
            if vr.role_id == role_id then
                return k
            end
        end
    end
    return 0
end

function BattleBaseLayer:getBattleRoleByRoleID(role_id)
    for k,v in pairs(self.map_battle_role) do
        for kr,vr in pairs(v.role_list) do
            if vr.role_id == role_id then
                return vr
            end
        end
    end
    return nil
end


function BattleBaseLayer:getBattleHeroByHeroID(hero_id)
    for k,v in pairs(self.map_battle_role) do
        for kr,vr in pairs(v.role_list) do
            for kh,vh in pairs(vr.hero_list) do
                if vh.hero_id == hero_id then
                    return vh
                end
            end
        end
    end
    return nil
end

function BattleBaseLayer:getAllHero(role_id)
    if not self.node_scene then
        return {}
    end
    -- 暂时不写
end

function BattleBaseLayer:getHeroPosition(team, index)
    -- 左右
    local bg_size = self:getMapSize();
    bg_size.height = bg_size.height * 0.7
    
    local coe_x = team == 1 and -1 or 1
    -- 列间隔
    local index_x = index < 2 and 0 or bg_size.width * 0.2
    
    -- 第一列距离地图中间的长度
    local offset_x = bg_size.width * 0.15
    local x = bg_size.width * 0.5 + offset_x * coe_x + index_x * coe_x
    
    local num_y = index < 2 and 2 or 4
    local index_y = index < 2 and index or index - 2
    
    -- 英雄上下距离..总占据距离
    local offset_y = index < 2 and bg_size.height * 0.4 or bg_size.height * 0.8
    local y = bg_size.height * 0.5 - offset_y * 0.5 + (index_y + 0.5) * (offset_y / num_y)
    
    return cc.p(self:getMapPos().x + x, self:getMapPos().y + y)
end

function BattleBaseLayer:getHeroBeattackPosition(team, index, offset_pos)
    local beattack_pos = self:getHeroPosition(team, index)
    -- 避免英雄坐标一样，导致画面闪烁
    beattack_pos.y = beattack_pos.y - 1
    
    local coe_x = team == 1 and -1 or 1
    return beattack_pos + offset_pos * coe_x
end


function BattleBaseLayer:getHeroZOder(team, index)
    local win_size = cc.Director:getInstance():getWinSize()
    local pos = self:getHeroPosition(team, index);
    return win_size.height - pos.y;
end

function BattleBaseLayer:addHeroPriorAttackData(battle_hero)
    -- 废弃
end

function BattleBaseLayer:removeHeroPriorAttackData(battle_hero)
    -- 废弃
end

function BattleBaseLayer:updateHeroPriorAttackData(battle_hero, is_clear)
    -- 废弃
end
function BattleBaseLayer:updateHeroPriorSpeed()
    -- 废弃
end

function BattleBaseLayer:getPriorAttackHero()
    -- 废弃
end
function BattleBaseLayer:sortPriorSpeed()
    -- 废弃
end

function BattleBaseLayer:getRound(team)
    local role_data = self.map_battle_role[team]
    if role_data == nil then
        return 0
    end

    local round_max = 0
    for kr,vr in pairs(role_data.role_list) do
        for kh,vh in pairs(vr.hero_list) do
            if (vh:isDie() == false) and vh:getRound() > round_max then
                round_max = vh:getRound()
            end
        end
    end

    return math.max(round_max - 1, 0)
end

function BattleBaseLayer:getTotalRound()
    local round_max = 0
    for k,v in pairs(self.map_battle_role) do
        local round = self:getRound(k)
        if round > round_max then
            round_max = round
        end
    end

    return round_max
end

function BattleBaseLayer:getRoundCount()
    local round_max = 0

    for k,v in pairs(self.map_battle_role) do
        local round = 0
        for kr,vr in pairs(v.role_list) do
            for kh,vh in pairs(vr.hero_list) do
                round = round + vh:getRound()
            end
        end
        round_max = round_max + round
    end
    return round_max
end

function BattleBaseLayer:setRunAction(b)
    if self.skill_system then
        self.skill_system:setRunAction(b)
    end

    local vec_hero = self:getAllHero()
    for k,v in pairs(vec_hero) do
        v:setRunAction(b)
    end
end

function BattleBaseLayer:clearBattleData()
    self.battle_status = BST_READY;
    if self.skill_system then
        self.skill_system:clear()
    end

    self.pre_oper_hero = nil
    self.vec_attack_speed = {}
    self.map_battle_role = {}
end

function BattleBaseLayer:isBattleEnd()
    -- 废弃
end

function BattleBaseLayer:battleStart()

end

function BattleBaseLayer:effectPassive()

end

function BattleBaseLayer:effectHalo()

end


function BattleBaseLayer:heroReplenishHp(caster, beneficiary, replenish, replenish_type, buff_type, active_type)
    beneficiary:setHp(math.min(beneficiary:getHpMax(), beneficiary:getHp() + replenish))
    if beneficiary.hero then
        beneficiary.hero:beattack(caster:getHeroID(),
        buff_type,
        -replenish,
        replenish_type, 
        beneficiary:getHp(),
        caster:getAttackElem(),
        false,
        0)
    end
end


function BattleBaseLayer:heroBeattack(attacker, beattacker, damage_type, buff_type, active_type)
    attacker:setDamage(damage);
    if self.skill_system then
        if attacker:isCritical() then
            self.skill_system:heroCritical(attacker, beattacker, damage_type, active_type)
        end

        self.skill_system:attack(attacker, beattacker, damage_type, active_type)
        self.skill_system:beattack(attacker, beattacker, damage_type, active_type)
    end

    beattacker:setHp(math.max(0, beattacker:getHp() - attacker:getDamage()))

    if damage_type == 0 and (attacker:isArtifact() == false) then
        local anger = Maths.clampf(beattacker:getAnger() + 10, 0, 100);
        beattacker:setAnger(anger)
    end

    if beattacker.hero then
        beattacker.hero:beattack(attacker:getHeroID(),
                                 buff_type,
                                 attacker:getDamage(),
                                 damage_type,
                                 beattacker:getHp(),
                                 attacker:getAttackElem(),
                                 attacker:isCritical(),
                                 0)
        beattacker.hero:showAnger()
    end

    if beattacker:getHp() <= 0 and (beattacker:isDie() == false) then
        beattacker:setDie(true)
        self.skill_system:heroDeath(beattacker)
    end
end

function BattleBaseLayer:battleReady()
    self.battle_status = BST_READY
end

function BattleBaseLayer:battleEnd()
    self.battle_status = BST_END
end

function BattleBaseLayer:isWin(team)
    -- 废弃
end

function BattleBaseLayer:battleUpdate(dt)
    -- 暂时不写
end

function BattleBaseLayer:heroActionEnd()
    self.battle_round = self:getTotalRound()
end

function BattleBaseLayer:shake(range, times, slow_down)
    if not self.node_scene then
        return
    end

    local act_shake = cpp.ActionFactory:createShakeAction(range, times, slow_down)
    act_shake:setTag(30)
    node_scene:stopActionByTag(30)
    node_scene:runAction(act_shake)
end

function BattleBaseLayer:dimly(time_in, time_out, time_delay)
    if not self.node_bg then
        return
    end

    local act_dark = cc.EaseExponentialOut:create(cc.TintTo:create(time_in, 120, 120, 120))
    local act_delay = cc.DelayTime:create(time_delay)
    local act_light = cc.EaseExponentialOut:create(cc.TintTo:create(time_out, 255, 255, 255))
    local act_sequ = cc.Sequence:create(act_dark, act_delay, act_light)
    act_sequ:setTag(40)

    ex.Tools:ergodicAllNode(self.node_bg, function(node)
        node:stopActionByTag(40)
        local act = act_sequ:clone()
        act:setTag(40)
        node:runAction(act)
    end)
end

function BattleBaseLayer:isInVisible()
    return false
end

function BattleBaseLayer:artifactSkill(artifact)

end

function BattleBaseLayer:artifactActionEnd(artifact)

end

return BattleBaseLayer