BattleInfoFactory = {}

local BattleHeroData = require('src.entity.battle.BattleHeroData')
local BattleGoddessData = require('src.entity.battle.BattleGoddessData')
local BattleDragonData = require('src.entity.battle.BattleDragonData')
local BattleInfo = require('src.entity.battle.BattleInfo')
local BattleRoundInfo = require('src.entity.battle.BattleRoundInfo')
local BattleGoddessAttackInfo = require('src.entity.battle.BattleGoddessAttackInfo')
local BattleDragonAttackInfo = require('src.entity.battle.BattleDragonAttackInfo')
local BattleAttackInfo = require('src.entity.battle.BattleAttackInfo')
local BattleEffectInfo = require('src.entity.battle.BattleEffectInfo')
local BattleBuffInfo = require('src.entity.battle.BattleBuffInfo')
local BattleAttributeUpdateInfo = require('src.entity.battle.BattleAttributeUpdateInfo')

BattleInfoFactory.BattleType = {
    Hang = 10
}

--[[
    根据后端的战报信息创建战斗信息完整结构

    battleReport : 由后端提供的战斗详细数据
    bfSize       : <{width, height}> 战场的大小
]]
BattleInfoFactory.create = function(battleReport, bfSize)
    local battleType = battleReport.battle_type
    
    local heroes = BattleInfoFactory._createHeroDatas(battleType, battleReport.attacker.heros, battleReport.defender.heros, bfSize)
    local goddess = BattleInfoFactory._createGoddessDatas(battleReport.attacker.goddess, battleReport.defender.goddess, bfSize)
    local dragon = BattleInfoFactory._createDragonDatas(battleReport.attacker.dragon, battleReport.defender.dragon, bfSize)
    for k,v in pairs(goddess) do
        heroes[k] = v
    end
    for k,v in pairs(dragon) do
        heroes[k] = v
    end
    
    local rounds = BattleInfoFactory._createRounds(battleReport.rounds, heroes)
    local isWin = battleReport.win_id == ex.Player.role_id
    
    local initData = {
        id = battleReport.battle_id,
        type = battleType,
        heroes = heroes,
        rounds = rounds,
        isWin = isWin,
    }

    return BattleInfo.new(initData)
end

BattleInfoFactory._createRounds = function(rounds, heroes)
    local roundInfos = {}

    for k,v in ipairs(rounds) do
        local buffs = BattleInfoFactory._createRoundBuffs(v.buffInfo, heroes)
        local goddessAttacks = BattleInfoFactory._createGoddessAttacks(v.goddess_attack, heroes)
        local dragonAttacks = BattleInfoFactory._createDragonAttacks(v.dragon_attack, heroes)
        local attacks = BattleInfoFactory._createAttacks(v.attack_info, heroes)
        local afterBuffs = BattleInfoFactory._createRoundBuffs(v.afterRoundBuffs, heroes)
        
        local initData = {
            round = v.round,
            buffs = buffs,
            goddessAttacks = goddessAttacks,
            dragonAttacks = dragonAttacks,
            attacks = attacks,
            afterBuffs = afterBuffs,
        }
        roundInfos[v.round] = BattleRoundInfo.new(initData)
    end

    return roundInfos
end

BattleInfoFactory._createGoddessAttacks = function(goddessAttacks, heroes)
    local attackInfos = {}

    for k,v in ipairs(goddessAttacks or {}) do
        local initData = {
            goddessData = heroes[v.unit_id],
            energy = v.energy
        }

        if v.attackInfo and v.attackInfo.unit_id ~= 0 then
            local attacks = BattleInfoFactory._createAttacks({v.attackInfo}, heroes)
            initData.attack = attacks[1]
        end

        local goddessAttack = BattleGoddessAttackInfo.new(initData)

        table.insert(attackInfos, goddessAttack)
    end

    return attackInfos
end

BattleInfoFactory._createDragonAttacks = function(dragonAttacks, heroes)
    local attackInfos = {}

    for k,v in ipairs(dragonAttacks or {}) do
        if v.attackInfo ~= nil and v.unit_id > 0 and v.attackInfo.skill.skill_id > 0 then
            local initData = {
                dragonData = heroes[v.attackInfo.unit_id],
                next_attack_round = v.next_attack_round
            }

            if v.attackInfo and v.attackInfo.unit_id ~= 0 then
                local attacks = BattleInfoFactory._createAttacks({v.attackInfo}, heroes)
                initData.attacks = attacks
                initData.skill_id = v.attackInfo.skill.skill_id
            end

            local dragonAttack = BattleDragonAttackInfo.new(initData)

            table.insert(attackInfos, dragonAttack)
        end
    end

    return attackInfos
end

BattleInfoFactory._createAttacks = function(attacks, heroes)
    local attackInfos = {}

    for k,v in ipairs(attacks or {}) do
        local effects = BattleInfoFactory._createEffects(v.skill, heroes)
        local initData = {
            id = v.unit_id,
            actionHeroData = heroes[v.unit_id],
            skillId = v.skill.skill_id,
            effects = effects,
            energyUpdate = v.skill.energyUpdate or 0,
            skillType = v.skill_type or 0
        }
        attackInfos[k] = BattleAttackInfo.new(initData)
    end

    return attackInfos
end

BattleInfoFactory._createEffects = function(skill, heroes)
    local effectInfos = {}

    local effects = skill.effect_info or {}
    for k,v in ipairs(effects) do
        local origBuffs = G_BATTLE_ACTIONS[v.buff_id]
        if origBuffs then
            BattleInfoFactory._pushActionEffect(v.buff_id, effectInfos, origBuffs, skill, v, heroes)
        else
            buff = cfg.buff['buff'][v.buff_id]
            if not buff then dump('not found buff id : ' .. v.buff_id) end
            
            local initData = {
                skillId = skill.skill_id,
                buff = buff,
                buffs = BattleInfoFactory._createBuffs(v.buff_info, heroes)
            }
            effectInfos[#effectInfos+1] = BattleEffectInfo.new(initData)
        end
    end

    return effectInfos
end

BattleInfoFactory._pushActionEffect = function(buffId, effectInfos, origBuffs, skill, effect, heroes)
    for _, origBuff in ipairs(origBuffs) do
        local buffInfos = {}
        
        -- 改成代码直接配置的模式之后，一个idx对应一个效果列表，所以这个列表里面的idx也是一样的。
        origBuff['idx'] = buffId
        
        for k, v in ipairs(effect.buff_info or {}) do
            local heroData = heroes[v.target_unitId]
            local initData = {
                unitId = v.unit_id,
                heroData = heroData,
                buff = origBuff,
                expiredRound = v.expired_round,
                hit = v.hit,
                status = v.status,
                resistances = v.resistances
            }
            buffInfos[k] = BattleBuffInfo.new(initData)
        end
        
        local initData = {
            skillId = skill.skill_id,
            buff = origBuff,
            buffs = buffInfos
        }
        effectInfos[#effectInfos+1] = BattleEffectInfo.new(initData)
    end
end

BattleInfoFactory._createBuffs = function(buffs, heroes)
    local buffInfos = {}
    for k,v in ipairs(buffs or {}) do
        local heroData = heroes[v.target_unitId]
        local buff = cfg.buff['buff'][v.buff_id]
        if not buff then dump('not found buff id : ' .. v.buff_id) end

        local updates = BattleInfoFactory._createAttributeUpdates(v.update, heroData)
        local initData = {
            target_unitId = v.target_unitId,
            unitId = v.unit_id,
            heroData = heroData,
            buff = buff,
            expiredRound = v.expired_round,
            hit = v.hit,
            status = v.status,
            updates = updates,
            resistances = v.resistances
        }
        buffInfos[k] = BattleBuffInfo.new(initData)
    end

    return buffInfos
end

BattleInfoFactory._createRoundBuffs = function(buffs, heroes)
    local buffInfos = {}

    for k,v in ipairs(buffs or {}) do
        local heroData = heroes[v.target_unitId]
        local buff = cfg.buff['buff'][v.buff_id]
        if not buff then dump('not found buff id : ' .. v.buff_id) end

        local updates = BattleInfoFactory._createAttributeUpdates(v.update, heroData)
        local initData = {
            unitId = v.unit_id,
            heroData = heroData,
            buff = buff,
            expiredRound = v.expired_round,
            hit = v.hit,
            status = v.status,
            updates = updates,
            resistances = v.resistances
        }

        if type(buffInfos[v.target_unitId]) ~= 'table' then
            buffInfos[v.target_unitId] = {}
        end
        table.insert(buffInfos[v.target_unitId], BattleBuffInfo.new(initData))
    end

    return buffInfos
end

BattleInfoFactory._createAttributeUpdates = function(updates, heroData)
    local updateInfos = {}

    for k,v in ipairs(updates or {}) do
        local initData = {
            heroData = heroData,
            type = v.type,
            value = v.value,
        }
        updateInfos[k] = BattleAttributeUpdateInfo.new(initData)
    end

    return updateInfos
end

BattleInfoFactory._createHeroDatas = function(battleType, playerHeroes, enemyHeroes, bfSize)
    local heroes = {}

    local cfg_hero_type = cfg.herotype.star
    for k,v in ipairs(playerHeroes) do
        v.kind = cfg_hero_type[v.hero_id].kind
        local heroData = nil
        if battleType == BattleInfoFactory.BattleType.Hang then
            v.position = k
            heroData = BattleInfoFactory._createInnerHero(battleType, BattleHeroData.TeamType.Player, v, bfSize)
        else
            heroData = BattleInfoFactory._createInnerHero(battleType, BattleHeroData.TeamType.Player, v, bfSize)
        end
        heroData:getBattleNode():faceToRight()
        heroes[v.unit_id] = heroData
    end

    for k,v in ipairs(enemyHeroes) do
        v.kind = cfg_hero_type[v.hero_id].kind
        local heroData = nil
        if battleType == BattleInfoFactory.BattleType.Hang then
            v.position = k
            heroData = BattleInfoFactory._createInnerHero(battleType, BattleHeroData.TeamType.Enemy, v, bfSize)
        else
            heroData = BattleInfoFactory._createInnerHero(battleType, BattleHeroData.TeamType.Enemy, v, bfSize)
        end
        heroData:getBattleNode():faceToLeft()
        heroes[v.unit_id] = heroData
    end

    return heroes
end

BattleInfoFactory._createGoddessDatas = function(playerGoddessData, enemyGoddessData, bfSize)
    local goddess = {}

    local playerGoddess = BattleInfoFactory._createGoddess(BattleGoddessData.TeamType.Player, playerGoddessData, bfSize)
    local enemyGoddess  = BattleInfoFactory._createGoddess(BattleGoddessData.TeamType.Enemy, enemyGoddessData, bfSize)

    if playerGoddess then
        goddess[playerGoddessData.unit_id] = playerGoddess
        playerGoddess:getBattleNode():faceToRight()
    end

    if enemyGoddess then
        goddess[enemyGoddessData.unit_id]  = enemyGoddess
        enemyGoddess:getBattleNode():faceToLeft()
    end

    return goddess
end

BattleInfoFactory._createGoddess = function(team, goddessData, bfSize)
    -- 因为protobuf会始终创建列表对象，所以这里需要判断unit_id = 0的情况
    if goddessData == nil or goddessData.unit_id == 0 then return nil end
    
    local goddessNode = BattleHeroFactory.createGoddess({
        hero_id = goddessData.goddess_id,
        energy = goddessData.energy,
        max_energy = goddessData.max_energy,
        level = goddessData.uplimit_level,
        fashion_id = goddessData.fashion_id,
    })
    goddessNode:actionStand()

    local position = BattleUtils.getGoddessPosition(bfSize)
    if team ~= BattleGoddessData.TeamType.Player then position.x = bfSize.width - position.x end
    
    goddessNode:setPosition(position)

    return BattleGoddessData.new({
        team = team,
        position = position,
        goddessNode = goddessNode,
    })
end

BattleInfoFactory._createDragonDatas = function(playerDragonData, enemyDragonData, bfSize)
    local dragon = {}

    local playerDragon = BattleInfoFactory._createDragon(BattleDragonData.TeamType.Player, playerDragonData, bfSize)
    local enemyDragon  = BattleInfoFactory._createDragon(BattleDragonData.TeamType.Enemy, enemyDragonData, bfSize)

    if playerDragon then
        dragon[playerDragonData.unit_id] = playerDragon
        -- playerDragon:getBattleNode():faceToRight()
    end

    if enemyDragon then
        dragon[enemyDragonData.unit_id]  = enemyDragon
        -- enemyDragon:getBattleNode():faceToLeft()
    end

    return dragon
end

BattleInfoFactory._createDragon = function(team, dragonData, bfSize)
    -- 因为protobuf会始终创建列表对象，所以这里需要判断unit_id = 0的情况
    if dragonData == nil or dragonData.unit_id == 0 then return nil end

    local vec_skill = {}
    for _,v in ipairs(dragonData.skillId) do
        table.insert(vec_skill, {
            skill_id = v,
            cd = 0
        })
    end
    
    local dragonNode = BattleHeroFactory.createDragon({
        hero_id = dragonData.unit_id,
        dragon_idx = dragonData.dragonId,
        skillIds = vec_skill,
        flipped = (team ~= BattleDragonData.TeamType.Player)
    })

    local position = BattleUtils.getDragonPosition(bfSize)
    if team ~= BattleDragonData.TeamType.Player then position.x = bfSize.width - position.x end
    
    dragonNode:setPosition(position)

    return BattleDragonData.new({
        team = team,
        position = position,
        dragonNode = dragonNode,
    })
end

BattleInfoFactory._createInnerHero = function(battleType, team, heroSrcData, bfSize)
    heroSrcData.isAssist = heroSrcData.position == LineupIdxAssist
    -- heroSrcData.isAssist = heroSrcData.position == LineupSeparation
    heroSrcData.isEnemy = (team == BattleHeroData.TeamType.Player)
    local heroNode = BattleHeroFactory.create(heroSrcData)
    heroNode:actionStand()
    
    local indexPosition = nil
    local heroPosition = nil
    if battleType == BattleInfoFactory.BattleType.Hang then
        heroPosition = BattleUtils.getHangHeroPosition(heroSrcData.position, bfSize, (team == BattleHeroData.TeamType.Player))
        indexPosition = clone(heroPosition)
        if team ~= BattleHeroData.TeamType.Player then
            indexPosition.x = bfSize.width - indexPosition.x
        end
    else
        indexPosition = BattleUtils.getHeroPosition(heroSrcData.position, bfSize)
        heroPosition = clone(indexPosition)
        if team ~= BattleHeroData.TeamType.Player then
            heroPosition.x = bfSize.width - heroPosition.x
        end
    end
    heroNode:setPosition(heroPosition)
    
    return BattleHeroData.new({
        id = heroSrcData.id,
        team = team,
        index = heroSrcData.position,
        indexPosition = indexPosition,
        bfSize = bfSize,
        position = heroPosition,
        heroNode = heroNode,
    })
end
