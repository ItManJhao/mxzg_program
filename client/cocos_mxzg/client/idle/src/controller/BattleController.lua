local BattleController = class('BattleController')

local Promise = require('src.model.Promise')
local SkillController = require('src.controller.SkillController')

local BattleControlContext = require('src.context.BattleControlContext')
local BattleLayerContext = require('src.context.BattleLayerContext')
local BattleUpdateContext = require('src.context.BattleUpdateContext')

local BattleBuffInfo = require('src.entity.battle.BattleBuffInfo')

local BattleHeroNode = require('src.entity.battle.BattleHeroNode')
local BattleGoddessNode = require('src.entity.battle.BattleGoddessNode')
local BattleDragonNode = require('src.entity.battle.BattleDragonNode')
local BattleHeroData = require('src.entity.battle.BattleHeroData')

local FRAME_PLISTS = {
    'hero/hero-beattack.plist',
    'hero/hero.plist',
    'skill/hero-skill.plist',
    'skill-effect/skill-effect-slient.plist',
    'skill-effect/skill-effect-revive.plist',
    'skill-effect/skill-effect-shield.plist',
    'skill-effect/skill-effect-parry.plist',
    'skill-effect/skill-effect-contract.plist',
    'skill-effect/titan-skill-effect-contract.plist',
    'ccbi-res/fetters-effect.plist',
    'ccbi-res/skill-icon.plist',
    'ccbi-res/battle-appear-left.plist',
    'ccbi-res/battle-appear-right.plist',
}

--[[
    1 火
    2 水
    3 木
    4 光
    5 暗
]]
local HERO_SLAY_EFFECT_MAP = {
    [1] = {
        action = 'huo'
    },

    [2] = {
        action = 'shui'
    },

    [3] = {
        action = 'mu'
    },

    [4] = {
        action = 'guang'
    },

    [5] = {
        action = 'an'
    },
}

-- macros
local START_DELAY       = 1.0
local GODDES_DELAY_TIME = 2.0
local ENTER_DELAY_TIME  = 2.5
local ATTACK_DELAY_TIME = 0.5
local END_DELAY_TIME    = 1.0
local SLAY_MIN_STAR     = 5
local HERO_SLAY_DELAY   = 1.0
local BUFF_UPDATE_DELAY = 0.1
local BUFF_UPDATE_AFTER_DELAY = 2.0
local ROUND_READY_DELAY = 1.0
local DEBUG_COLOR_LAYER_TAG = 1000220

local APPEAR_LEFT_PATH_TPL  = 'battle-appear-left/%d.png'
local APPEAR_LEFT_DURATION  = 0.05
local APPEAR_LEFT_ANCHOR    = cc.p(0.5, 0.25)

local APPEAR_RIGHT_PATH_TPL = 'battle-appear-right/%d.png'
local APPEAR_RIGHT_DURATION = 0.05
local APPEAR_RIGHT_ANCHOR   = cc.p(0.5, 0.25)

local REVIVE_PATH_TPL = 'skill-effect-revive/%d.png'
local REVIVE_DURATION = 0.075
local REVIVE_ANCHOR = cc.p(0.5, 0.25)

local SLAY_AUDIO_PATH = 'music/slay.mp3'

--[[
战斗事件定义

说明:
RoundStart     : 回合开始时触发。listener({roundNumber: 当前回合数字, heroes: 正在战斗的英雄列表})
RoundReadyEnd  : 回合已经准备好，执行完准备阶段的动作后触发。listener({roundNumber: 当前回合数字})
RoundEnd       : 回合已经结束后触发。listener({roundNumber: 当前回合数字, heroes: 正在战斗的英雄列表})
BattleEnd      : 战斗结束后触发。listener({isWin: 是否胜利})
BattleForceEnd : 战斗被强制结束后触发。listener({isWin: 是否胜利})

HeroDead : 英雄死亡时触发。listener({heroData : <BattleHeroData>死亡的英雄})
]]
BattleController.Event = {
    RoundStart = 1,
    RoundReadyEnd = 2,
    RoundEnd = 3,
    BattleEnd = 4,
    BattleForceEnd = 5,

    HeroDead = 1001,
    ChangeWeather = 1002,
}

--[[
    battlefieldLayer类似于"黑板"，战斗的可视化会在这个layer上进行，
    所以，这个显示对象必须是一个"完备"的战场语义的显示对象。

    也就是说，battlefieldLayer必须设置正确的 content size 和 position，
    战斗对象会通过 content size 的值来确定显示位置。

    另外，一些战斗相关的场景展示对象，会被添加到battlefieldLayer中。而一些
    全屏特效动作会被添加到battlefieldLayer的`父对象`中，比如震动、暗屏等。
    所以，在传入battlefieldLayer的时候，可以自己设计层次关系，战斗模块只会
    使用到battlefieldLayer对象本身，以及它的父显示对象。

    options:
    {
        enabledPlaySpeed    : 是否受全局战斗速度的影响(默认 true)
        isFadeHeroes        : 开始战斗时英雄是否淡入(默认 true)
    }
]]
function BattleController:ctor( battlefieldLayer, options )
    if options == nil then options = {} end

    if options.enabledPlaySpeed == nil then options.enabledPlaySpeed = true end
    if options.isFadeHeroes == nil then options.isFadeHeroes = true end

    --[[
        战场显示对象。战斗的英雄会放到这个显示对象上
    ]]
    self._battlefieldLayer = battlefieldLayer

    --[[
        战斗结束后是否保留player方英雄
    ]]
    self._isRetainedPlayerHeroes = false

    --[[
        已保留的player方英雄列表
    ]]
    self._retainedHeroes = {}

    --[[
        <BattleInfo> 战斗详细信息对象
    ]]
    self._battleInfo = nil

    --[[
        战斗中基本信息，参考 BattleController:_initBattlingInfo()
    ]]
    self._battlingInfo = nil

    --[[
        使用promise的resolve收集列表

        用于在停止战斗的时候快速resolve还未完成的promise
    ]]
    self._promiseResolves = {}

    --[[
        战斗是否正在进行的状态
    ]]
    self._playing = false

    --[[
        是否启用全局战斗速度
    ]]
    self._enabledPlaySpeed = options.enabledPlaySpeed

    --[[
        是否淡入英雄
    ]]
    self._isFadeHeroes = options.isFadeHeroes

    --[[
        是否启用战斗log(默认为false)
    ]]
    self._isPrintLog = false

    --[[
        是否显示buff飘字(默认为true)
    ]]
    self._isShowBuffTip = true

    --[[
        是否需要强制停止战斗播放
    ]]
    self._forceStopping = false

    --[[
        是否启用英雄对话
    ]]
    self._heroTalkEnabled = false

    --[[
        英雄对话间隔
    ]]
    self._heroTalkInterval = cfg.system.hero_talk_cd

    --[[
        英雄对话间隔累加器
    ]]
    self._heroTalkIntervalAccum = self._heroTalkInterval

    self._playerLevel = nil
    self._heroTalks = {}

    --[[
        控制context
    ]]
    self._controlContext = BattleControlContext.new({
        isBackground = false,
        eventHandler = handler(self, self._emit)
    })

    --[[
        场景context
    ]]
    self._layerContext = self:_createLayerContext(self._battlefieldLayer, options)

    self._eventListener = {}
    self._skillController = SkillController.new(self._controlContext, self._layerContext, self._enabledPlaySpeed)

    self._skillController:setHeroDeadHandler(function(heroData)
        self:_triggerHeroData(heroData)
    end)

    self:_initSpriteFrames()

    self._battlefieldLayer:onUpdate(function(dt)
        self:_battleLayerUpdate(dt)
    end)
end

--[[
    驱动战斗播放
    
    该函数保证播放战斗之前会清空旧的战斗数据，包括由本对象创建的显示对象，战斗信息。
    **但是不会删除已经添加的事件监听器，也不会删除战场显示对象**

    options:
    {
        showedHeroPause : <boolean> 显示英雄之后是否暂停
        hasEnter        : <boolean> 是否延迟等待进场(默认 true)
    }
]]
function BattleController:play(battleReport, options)
    if options == nil then options = {} end

    if options.hasEnter == nil then options.hasEnter = true end
    
    self:_clear()
    self:_initLayersSize()
    self._forceStopping = false
    self._promiseResolves = {}

    local playBattle = function()
        self._battleInfo = BattleInfoFactory.create(battleReport, self._layerContext:getLayer():getContentSize())
        self:_setHeroDataFindHeroHandler()
        self:_initBattlingInfo()
        self:_initBattleHeroes()
        -- self:_initBattleGoddess()
        -- self:_initBattleDragon()

        if options.showedHeroPause then return end

        self:_play()
    end

    local enterDelayTime = 0
    if options.hasEnter then
        enterDelayTime = ENTER_DELAY_TIME

        local enterAction = cc.Sequence:create(
            cc.DelayTime:create(enterDelayTime),
            cc.CallFunc:create(playBattle),
            nil
        )
        self._layerContext:getActionLayer():runAction(enterAction)
    else
        playBattle()
    end
end

function BattleController:getHeroDataByHeroUnitId(unit_id)
    return self._battleInfo:getHero(unit_id)
end

--[[
    将战斗设置为后台播放模式
]]
function BattleController:setBackgroundPlay(isBackground)
    self._controlContext:setBackground(isBackground)
end

--[[
    继续播放战斗(只针对显示英雄之后的暂停有效，如果已经在战斗中了，则调用无效)
]]
function BattleController:continuePlay()
    if self._playing then return end
    self:_play()
end

function BattleController:isPlaying()
    return self._playing
end

--[[
    强制结束战斗播放
]]
function BattleController:forceStop()
    if self._playing then
        self._forceStopping = true
        self:_stopAllAction()
        self._skillController:stop()
        self:_resolveAll()
    end
end

--[[
    是否打印战斗log
]]
function BattleController:setIsPrintLog(isPrintLog)
    self._isPrintLog = isPrintLog
    self._skillController:setIsPrintLog(isPrintLog)
end

--[[
    是否显示buff飘字
]]
function BattleController:setIsShowBuffTip(visible)
    self._isShowBuffTip = visible
    if self._battleInfo == nil then return end
    for k,hero in pairs(self._battleInfo:getHeroes()) do
        hero:setIsShowBuffTip(visible)
    end
end

--[[
    是否保留我方英雄
]]
function BattleController:setRetainPlayerHeroes(isRetained)
    self._isRetainedPlayerHeroes = isRetained
end

function BattleController:addEventListener(event, listener)
    local listeners = self._eventListener[event]
    if self._eventListener[event] == nil then
        listeners = {}
        self._eventListener[event] = listeners
    end

    table.insert(listeners, listener)
end

function BattleController:removeEventListener(event, listener)
    if self._eventListener[event] == nil then return end
    TableEx.removeItem(self._eventListener[event], listener)
end

-- 让停留在场景中的英雄跑起来
function BattleController:runWithRretainedHeroes()
    for _, hero in pairs(self._retainedHeroes) do
        hero:actionRun()
    end
end

-- 是否显示攻击提示
function BattleController:setIsShowAttackingTips(isShow)
    self._skillController:setIsShowAttackingTips(isShow)
end

-- 让停留在场景中的英雄播放待机动画
function BattleController:standWithRretainedHeroes()
    for _, hero in pairs(self._retainedHeroes) do
        hero:actionStand()
    end
end

-- 是否启用英雄对话
function BattleController:setEnabledHeroTalk(isEnabled)
    self._heroTalkEnabled = isEnabled
end

function BattleController:changeWeather(weather_type)
    self:_emit(BattleController.Event.ChangeWeather, weather_type)
end

function BattleController:_setHeroDataFindHeroHandler()
    local heros = self._battleInfo:getHeroes()
    for _,hero_data in pairs(heros) do
        if hero_data.setFindHeroDataByUnitIdHandler ~= nil then
            hero_data:setFindHeroDataByUnitIdHandler(handler(self, self.getHeroDataByHeroUnitId))
        end
    end
end

function BattleController:_play()
    self._playing = true

    local startDelay = 0
    if self._isFadeHeroes then
        startDelay = START_DELAY
    end

    Promise.new(function(resolve)
        table.insert(self._promiseResolves, resolve)
        local action = cc.Sequence:create(
            cc.DelayTime:create(startDelay),
            cc.CallFunc:create(function()
                TableEx.removeItem(self._promiseResolves, resolve)
                resolve()
            end)
        )
        
        self._layerContext:getActionLayer():runAction(action)
    end):next(function()
        if self._forceStopping then
            self:_battleForceEnd()
            return
        end

        self:_playRound()
    end)
end

--[[
    必须在启动战斗并且准备好战斗数据时调用，而不是在对象构造完成后就直接调用
]]
function BattleController:_initBattleHeroes()
    for k,hero in pairs(self._battleInfo:getHeroes()) do
        local heroNode = hero:getBattleNode()

        if heroNode.setIsShowBuffTip then
            heroNode:setIsShowBuffTip(self._isShowBuffTip)
        end

        if self._enabledPlaySpeed then
            heroNode:setCustomScheduler(GlobalBattleHelper.getScheduler())
            heroNode:setCustomActionManager(GlobalBattleHelper.getActionManager())
        end

        if hero:getTeam() == BattleHeroData.TeamType.Player and self._isRetainedPlayerHeroes then
            local key = self:_genRetainedHeroKey(hero)
            local retainedHeroNode = self._retainedHeroes[key]
            self._retainedHeroes[key] = nil

            if retainedHeroNode ~= nil then
                hero:setBattleNode(retainedHeroNode)
                retainedHeroNode:stopAllActions()
                retainedHeroNode:visible()
                if retainedHeroNode.getHp then
                    retainedHeroNode:setHp(heroNode:getHp())
                    retainedHeroNode:setMaxHp(heroNode:getMaxHp())
                end
                if retainedHeroNode.getEnergy then
                    retainedHeroNode:setEnergy(heroNode:getEnergy())
                    retainedHeroNode:setMaxEnergy(heroNode:getMaxEnergy())
                end
                retainedHeroNode:clearBuffIcons()
                heroNode = retainedHeroNode
            end
        else
            if self._isFadeHeroes then
                if hero._index == LineupIdxAssist or hero._index == LineupSeparation then
                    heroNode:invisible()
                else
                    heroNode:fadeIn(START_DELAY)
                end
            end
        end

        local effectSprite = nil
        if hero:getTeam() == BattleHeroData.TeamType.Player then
            if not self._isRetainedPlayerHeroes then
                effectSprite = EffectFactory.createSprite(APPEAR_LEFT_PATH_TPL, APPEAR_LEFT_DURATION, {
                    enabledPlaySpeed = self._enabledPlaySpeed
                })
                effectSprite:setAnchorPoint(APPEAR_LEFT_ANCHOR)
            end
        else
            effectSprite = EffectFactory.createSprite(APPEAR_RIGHT_PATH_TPL, APPEAR_RIGHT_DURATION, {
                enabledPlaySpeed = self._enabledPlaySpeed
            })
            effectSprite:setAnchorPoint(APPEAR_RIGHT_ANCHOR)
        end

        if effectSprite then
            effectSprite:setPosition(cc.p(
                heroNode:getContentSize().width / 2,
                0
            ))
            heroNode:addChild(effectSprite)
        end
        
        local btLayer = self._layerContext:getLayer()
        if heroNode:getParent() ~= btLayer then
            btLayer:addChild(heroNode)
        end

        if heroNode.getHp and heroNode:getHp() == 0 then
            heroNode:invisible()
        end

        heroNode:setPosition(clone(hero:getPosition()))
        heroNode:setLocalZOrder(GlobalBattleHelper.LayerZOrder.HeroBase - hero:getPosition().y)
    end

    if self._isRetainedPlayerHeroes then
        for k,v in pairs(self._retainedHeroes) do
            v:runAction(cc.RemoveSelf:create())
        end
        self._retainedHeroes = {}
    end
end

function BattleController:_initBattleGoddess()
    local btLayer = self._layerContext:getLayer()

    local battleGoddessNode = BattleGoddessNode.new({
        skillIds = {101040043, 102050075, 0},
        flipped = false,
    })
    battleGoddessNode:setPosition(0, 900)
    battleGoddessNode:setLocalZOrder(GlobalBattleHelper.LayerZOrder.Dragon)

    btLayer:addChild(battleGoddessNode)
end

function BattleController:_initBattleDragon()
    local btLayer = self._layerContext:getLayer()

    local battleDragonNode = BattleDragonNode.new({
        level = 1,
        skillIds = {101040043, 102050075, 0},
        flipped = false,
    })
    battleDragonNode:setPosition(BattleUtils.getDragonPosition(btLayer:getContentSize()))
    battleDragonNode:setLocalZOrder(GlobalBattleHelper.LayerZOrder.Dragon)

    btLayer:addChild(battleDragonNode)
end

function BattleController:_playRound()
    local roundData = self:_getCurrentRoundData()
    if roundData == nil then
        self:_battleEnd()
        return
    end
    
    self:_printLog('========== round start : ' .. roundData:getRound() .. ' ===========')
    self:_emit(BattleController.Event.RoundStart, {
        roundNumber = self._battlingInfo.roundCursor,
        heroes = self._battleInfo:getHeroes(),
    })

    local readyPromise = self:_playRoundReady(roundData:getGoddessAttacks(), roundData:getDragonAttacks(), roundData:getBuffs()):next(function()
        self:_printLog('========== round ready end : ' .. roundData:getRound() .. ' ===========')
        self:_emit(BattleController.Event.RoundReadyEnd, {
            roundNumber = self._battlingInfo.roundCursor
        })
        return Promise.resolve()
    end)
    
    local lastPromise = readyPromise
    for k,v in ipairs(roundData:getAttacks()) do
        local heroData = v:getActionHeroData()
        local heroNode = heroData:getBattleNode()

        lastPromise = lastPromise:next(function()
            if self._forceStopping then return Promise.resolve() end

            return self._skillController:play(v):next(function()
                return Promise.new(function(resolve)
                    table.insert(self._promiseResolves, resolve)

                    local action = cc.Sequence:create(
                        cc.DelayTime:create(ATTACK_DELAY_TIME),
                        cc.CallFunc:create(function()
                            TableEx.removeItem(self._promiseResolves, resolve)
                            resolve()
                        end)
                    )
                    v:getActionHeroData():getBattleNode():runAction(action)
                end)
            end)
        end)
    end
    
    lastPromise:next(function()
        self:_printLog('========== round end : ' .. roundData:getRound() .. ' ===========')
        self:_emit(BattleController.Event.RoundEnd, {
            roundNumber = self._battlingInfo.roundCursor,
            heroes = self._battleInfo:getHeroes(),
        })

        if self._forceStopping then
            self:_battleForceEnd()
            return
        end

        self:_playRoundAfter(roundData:getAfterBuffs()):next(function()
            self._battlingInfo.roundCursor = self._battlingInfo.roundCursor + 1
            self:_playRound()
        end):catch(function(err)
            print('Error: ', err)
        end)
    end):catch(function(err)
        print('Error: ', err)
    end)
end

function BattleController:_playRoundReady(goddessAttacks, dragonAttacks, buffs)
    local lastPromise = Promise.resolve()
    -- 執行回合前buff
    local updateAfterTime = 0.0
    if #buffs > 0 then
        updateAfterTime = BUFF_UPDATE_AFTER_DELAY
    end

    lastPromise = lastPromise:next(function()
        return Promise.new(function(resolve)
            table.insert(self._promiseResolves, resolve)
            local action = cc.Sequence:create(
                cc.CallFunc:create(function()
                    self:_playBuffs(buffs):next(function()
                        -- if self._forceStopping then return end
                        -- TableEx.removeItem(self._promiseResolves, resolve)
                        -- resolve()
                    end)
                end),
                cc.DelayTime:create(ROUND_READY_DELAY),
                cc.CallFunc:create(function()
                    if self._forceStopping then return end
                    TableEx.removeItem(self._promiseResolves, resolve)
                    resolve()
                end),
                nil
            )
            
            self._layerContext:getActionLayer():runAction(action)
        end):next(function()
            return Promise.new(function(resolve)
                table.insert(self._promiseResolves, resolve)
                local action = cc.Sequence:create(
                    cc.DelayTime:create(updateAfterTime),
                    cc.CallFunc:create(function()
                        if self._forceStopping then return end
                        TableEx.removeItem(self._promiseResolves, resolve)
                        resolve()
                    end),
                    nil
                )

                self._layerContext:getActionLayer():runAction(action)
            end)
        end)
    end)

    -- 回合前buff執行後，執行羈絆技能
    for k,v in ipairs(goddessAttacks) do
        lastPromise = lastPromise:next(function()
            if self._forceStopping then return Promise.resolve() end

            local goddessData = v:getGoddessData()
            local goddessNode = goddessData:getBattleNode()
            goddessNode:setEnergy(goddessNode:getEnergy() + v:getEnergy())

            if v.getHeroData then
                self:_showEnergyLabelForDebug(v:getHeroData(), v:getEnergy())
            end

            if v:getAttack() == nil then return Promise.resolve() end
            
            return Promise.all({
                self._skillController:play(v:getAttack()),
                Promise.new(function(resolve)
                    table.insert(self._promiseResolves, resolve)
                    local goddessType = ex.Player.fetter_data:getSkinByLevel(goddessNode:getHeroId(), goddessNode:getLevel())
                    self:_playGoddessAttackEffect(goddessType, function()
                        TableEx.removeItem(self._promiseResolves, resolve)
                        resolve()
                    end)
                end)
            }):next(function()
                return Promise.new(function(resolve)
                    table.insert(self._promiseResolves, resolve)
                    local delayAction = cc.Sequence:create(
                        cc.DelayTime:create(GODDES_DELAY_TIME),
                        cc.CallFunc:create(function()
                            TableEx.removeItem(self._promiseResolves, resolve)
                            resolve()
                        end),
                        nil
                    )
                    goddessNode:runAction(delayAction)
                end)
            end)
        end)
    end

    -- 回合开始时，执行圣龙技能cd自减1操作
    for k,v in pairs(self._battleInfo:getHeroes()) do
        local battle_node = v:getBattleNode()
        if battle_node.setSkillCdNextRound then
            battle_node:setSkillCdNextRound(self._battlingInfo.roundCursor)
        end
    end
    
    -- 回合前buff執行後，執行聖龍技能
    for k,v in ipairs(dragonAttacks) do
        if v:getDragonData() ~= nil then
            lastPromise = lastPromise:next(function()
                if self._forceStopping then return Promise.resolve() end

                local dragonData = v:getDragonData()
                local dragonNode = dragonData:getBattleNode()

                -- 显示cd
                dragonNode:setSkillCd(self._battlingInfo.roundCursor, v:getSkillId(), v:getNextAttackRound())

                if v:getAttack() == nil then return Promise.resolve() end

                local vec_promise = {}
                for _,attack in ipairs(v:getAttack()) do
                    table.insert(vec_promise, self._skillController:play(attack))
                end
                table.insert(vec_promise, Promise.new(function(resolve)
                        table.insert(self._promiseResolves, resolve)
                        local dragonType = dragonNode:getDragonType()
                        self:_playDragonAttackEffect(dragonNode:getDragonType(), dragonData:getTeam() ~= dragonData.TeamType.Player, function()
                            TableEx.removeItem(self._promiseResolves, resolve)
                            resolve()
                        end)
                    end)
                )
                
                return Promise.all(vec_promise):next(function()
                    return Promise.new(function(resolve)
                        table.insert(self._promiseResolves, resolve)
                        local delayAction = cc.Sequence:create(
                            cc.DelayTime:create(GODDES_DELAY_TIME),
                            cc.CallFunc:create(function()
                                TableEx.removeItem(self._promiseResolves, resolve)
                                resolve()
                            end),
                            nil
                        )
                        dragonNode:runAction(delayAction)
                    end)
                end)
            end)
        else
            print("Error: dragonData is nil")
        end
    end

    return lastPromise
end

function BattleController:_playRoundAfter(buffs)
    return Promise.new(function(resolve)
        table.insert(self._promiseResolves, resolve)
        local action = cc.Sequence:create(
            cc.CallFunc:create(function()
                self:_playBuffs(buffs):next(function()
                    if self._forceStopping then return end
                    TableEx.removeItem(self._promiseResolves, resolve)
                    resolve()
                end)
            end),
            nil
        )

        self._layerContext:getActionLayer():runAction(action)
    end)
end

function BattleController:_playBuffs(buffsList)
    local allPromises = {Promise.resolve()}
    
    for unitId,buffs in pairs(buffsList) do
        local lastPromise = Promise.resolve()

        for k, v in ipairs(buffs) do
            if v:getExpiredRound() == -1 then
                self:_printLog('removing buff : ' .. v:getUnitId() .. ' - ' .. v:getBuff().idx)
                BattleActionUtils.clearBuff(v, handler(self, self._emit))
            else
                lastPromise = lastPromise:next(function()
                    return Promise.new(function(resolve)
                        table.insert(self._promiseResolves, resolve)

                        local heroNode = v:getHeroData():getBattleNode()
                        local action = cc.Sequence:create(
                            cc.DelayTime:create(BUFF_UPDATE_DELAY),
                            cc.CallFunc:create(function()
                                if self._forceStopping then return end
                                TableEx.removeItem(self._promiseResolves, resolve)
                                local buff = v:getBuff()
                                if v:getExpiredRound() ~= 0 then
                                    if buff.buff_icon ~= 0 and v:getHit() ~= BattleBuffInfo.HitType.Miss then
                                        heroNode:addBuffIcon(buff.idx, buff.buff_icon)
                                    end

                                    if heroNode.addBuffTip then
                                        heroNode:addBuffTip(buff.buff_name_lang, buff.buff_name_color)
                                    end

                                    -- 单独对护盾状态添加特效，挂机状态不显示
                                    if buff.type == 1008 and self._isShowBuffTip == true then
                                        local tmp_buff = clone(buff)
                                        if type(tmp_buff.ani_base) ~= 'table' then
                                            tmp_buff.ani_base = {}
                                        end
                                        tmp_buff.ani_base.format = 'skill-effect-shield/%d.png'
                                        if tmp_buff.ani_base.anchor_x == nil then
                                            tmp_buff.ani_base.anchor_x = 0.5
                                        end
                                        if tmp_buff.ani_base.anchor_y == nil then
                                            tmp_buff.ani_base.anchor_y = 0.8
                                        end
                                    
                                        tmp_buff.ani_base.scale_x = 2.0
                                        tmp_buff.ani_base.scale_y = 2.0
                                    
                                        tmp_buff.ani_base.duration = 0.15
                                        local buffSprite = BuffFactory.create(tmp_buff.type, tmp_buff.ani_base, self._enabledPlaySpeed)
                                        if buffSprite then
                                            print("addRoundBuffEffect with buff_type", v:getUnitId(), tmp_buff.type)
                                            heroNode:addRoundBuffEffect(v:getUnitId(), tmp_buff.type, buffSprite)
                                        end
                                    elseif buff.type == 351 then
                                        print("buff ready play buff 351");

                                        local tmp_buff = clone(buff)
                                        if type(tmp_buff.ani_base) ~= 'table' then
                                            tmp_buff.ani_base = {}
                                        end
                                        tmp_buff.ani_base.format = 'titan-skill-effect-contract/%d.png'
                                        if tmp_buff.ani_base.anchor_x == nil then
                                            tmp_buff.ani_base.anchor_x = 0.5
                                        end
                                        if tmp_buff.ani_base.anchor_y == nil then
                                            tmp_buff.ani_base.anchor_y = 0.7
                                        end
                                    
                                        tmp_buff.ani_base.scale_x = 2.0
                                        tmp_buff.ani_base.scale_y = 2.0
                                    
                                        tmp_buff.ani_base.duration = 0.15
                                        local buffSprite = BuffFactory.create(tmp_buff.type, tmp_buff.ani_base, self._enabledPlaySpeed)
                                        if buffSprite then
                                            print("addRoundBuffEffect with buff_type", v:getUnitId(), tmp_buff.type)
                                            heroNode:addRoundBuffEffect(v:getUnitId(), tmp_buff.type, buffSprite)
                                        end
                                    end
                                end
                                
                                self:_playBuffUpdate(v)
                                resolve()
                            end),
                            nil
                        )
            
                        heroNode:runAction(action)
                    end)
                end)
            end
        end

        table.insert(allPromises, lastPromise)
    end

    return Promise.all(allPromises)
end

function BattleController:_playBuffUpdate(buffInfo)
    if buffInfo:getHit() == BattleBuffInfo.HitType.Miss then
        -- TODO 攻击miss的情况处理
        return
    end

    local heroNode = buffInfo:getHeroData():getBattleNode()
    local buff = buffInfo:getBuff()
    if buff.type == BattleActionUtils.ActionBuffType.Resurrection then
        if heroNode.addBuffTip then
            heroNode:addBuffTip(buff.buff_name_lang, buff.buff_name_color)
        end    

        heroNode:revive()

        local effectSprite = EffectFactory.createSprite(REVIVE_PATH_TPL, REVIVE_DURATION, {
            enabledPlaySpeed = self._enabledPlaySpeed
        })
        effectSprite:setAnchorPoint(REVIVE_ANCHOR)
        effectSprite:setPosition(heroNode:getPosition())
        self._layerContext:getContainEffectLayer():addChild(effectSprite)
    elseif buff.type == BattleActionUtils.ActionBuffType.AssistInLine then
        if heroNode.addBuffTip then
            heroNode:addBuffTip(buff.buff_name_lang, buff.buff_name_color)
        end
    
        -- 设置好位置并设置可见
        heroNode:revive()

        local heroData = buffInfo:getHeroData()
        local position = buffInfo:getUpdates()[1]:getValue()
        local battleType = self._battleInfo:getType()
        local team = heroData:getTeam()
        local bfSize = heroData:getBfSize()
        local indexPosition = nil
        local heroPosition = nil
        if battleType == BattleInfoFactory.BattleType.Hang then
            heroPosition = BattleUtils.getHangHeroPosition(position, bfSize, (team == BattleHeroData.TeamType.Player))
            indexPosition = clone(heroPosition)
            if team ~= BattleHeroData.TeamType.Player then
                indexPosition.x = bfSize.width - indexPosition.x
            end
        else
            indexPosition = BattleUtils.getHeroPosition(position, bfSize)
            heroPosition = clone(indexPosition)
            if team ~= BattleHeroData.TeamType.Player then
                heroPosition.x = bfSize.width - heroPosition.x
            end
        end
        heroNode:setPosition(heroPosition)

        heroData:setIndex(position)
        heroData:setIndexPosition(indexPosition)
        heroData:setPosition(heroPosition)

        local effectSprite = EffectFactory.createSprite(REVIVE_PATH_TPL, REVIVE_DURATION, {
            enabledPlaySpeed = self._enabledPlaySpeed
        })
        effectSprite:setAnchorPoint(REVIVE_ANCHOR)
        effectSprite:setPosition(heroNode:getPosition())
        self._layerContext:getContainEffectLayer():addChild(effectSprite)
    elseif buff.type == BattleActionUtils.ActionBuffType.ForcedDeath then
        if heroNode.addBuffTip then
            heroNode:addBuffTip(buff.buff_name_lang, buff.buff_name_color)
        end
    end

    local attrUpdates = buffInfo:getUpdates()
    for k,v in pairs(attrUpdates) do
        local ctx = BattleUpdateContext.new({
            enabledPlaySpeed = self._enabledPlaySpeed,
            layer = self._layerContext:getLabelLayer(),
            update = v,
            hit = buffInfo:getHit()
        })
        BattleAttrUpdateUtils.update(v:getType(), ctx)
    end

    if buffInfo:getStatus() == BattleBuffInfo.Status.Dead then
        buffInfo:getHeroData():getBattleNode():die()
        self:_triggerHeroData(buffInfo:getHeroData())
    end
end

function BattleController:_battleEnd()
    self._playing = false
    
    -- DEBUG
    self:_printLog('########## battle win : ' .. tostring(self._battleInfo:isWin()))
    -- DEBUG end

    local endDelayTime = 0
    if not self._forceStopping then
        endDelayTime = END_DELAY_TIME
    end

    local btEndInfo = self:_createBattleEndInfo()
    local endAction = cc.Sequence:create(
        cc.DelayTime:create(endDelayTime),
        cc.CallFunc:create(function()
            self:_clear()
            self:_printLog('++++++++++ battle end! ++++++++++')
            self:_emit(BattleController.Event.BattleEnd, btEndInfo)
        end)
    )
    
    self._battlefieldLayer:runAction(endAction)
end

function BattleController:_battleForceEnd()
    local btEndInfo = self:_createBattleEndInfo()
    self:_printLog('++++++++++ battle force end! ++++++++++')
    self:_emit(BattleController.Event.BattleForceEnd, btEndInfo)
    self:_battleEnd()
end

function BattleController:_createBattleEndInfo()
    return {
        isWin = self._battleInfo:isWin()
    }
end

function BattleController:_initBattlingInfo()
    self._battlingInfo = {
        --[[
            当前回合的游标
        ]]
        roundCursor = 1,
    }
end

--[[
    女神特殊的攻击特效
]]
function BattleController:_playGoddessAttackEffect(heroType, handler)
    local layer = cc.Layer:create()
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(layer) end

    local bg = cc.LayerColor:create(cc.c4b(0,0,0,0), ex.p.width, ex.p.height)
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(bg) end
    
    bg:runAction(cc.FadeTo:create(0.1, 170))
    bg:runAction(cc.Sequence:create(
        cc.DelayTime:create(1.2),
        cc.FadeTo:create(0.1, 0),
        nil
    ))
    layer:addChild(bg)

    local timeScale = GlobalBattleHelper.getSchedulerTimeScale()
    -- local eff2 = ex.EffectCtr:playNormalEff(12, ex.p.width * 0.5, ex.p.height * 0.6, nil, layer, 10, nil, nil, nil, 1.0/timeScale)
    -- local scale = ex.p.width / (eff2.anim:getContentSize().width + 80)
    -- eff2:setScale(scale)

    local sp_ani1 = sp.SkeletonAnimation:create("spine/jiban.json","spine/jiban.atlas", 1)
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(sp_ani1) end
    sp_ani1:setAnimation(0, "stand", true)
    sp_ani1:setScale(ex.p.width / 640)

    sp_ani1:setPosition(ex.p.width * 0.5, ex.p.height * 0.6)
    sp_ani1:setAnchorPoint(cc.p(0.5, 0.5))
    layer:addChild(sp_ani1, 10)

    local spine = sp.SkeletonAnimation:create("spine/".. heroType ..".json","spine/".. heroType ..".atlas", 1)
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(spine) end
    spine:setAnimation(0, "stand", true)
    spine:setScale(1.1)
    spine:setPosition(-200, ex.p.height * 0.55)
    spine:runAction(cc.EaseExponentialOut:create(cc.MoveTo:create(0.3, cc.p(ex.p.width * 0.3, ex.p.height * 0.5))))
    layer:addChild(spine, 10)
    
    spine:runAction(cc.Sequence:create(
        cc.DelayTime:create(1.1),
        cc.EaseExponentialOut:create(cc.MoveTo:create(0.3,cc.p(-400, ex.p.height * 0.5))),
        nil
    ))
    layer:runAction(cc.Sequence:create(
        cc.DelayTime:create(1.2),
        cc.CallFunc:create(function()
            handler()
        end),
        cc.RemoveSelf:create(),
        nil
    ))

    local topEffectLayer = self._layerContext:getTopEffectLayer()
    
    local layerPos = topEffectLayer:convertToWorldSpace(cc.p(0, 0))
    layerPos.y = -layerPos.y
    layer:setPosition(layerPos)

    topEffectLayer:addChild(layer)
end

--[[
    神龙特殊的攻击特效
]]
function BattleController:_playDragonAttackEffect(dragonType, flipped, handler)
    local layer = cc.Layer:create()
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(layer) end

    local bg = cc.LayerColor:create(cc.c4b(0,0,0,0), ex.p.width, ex.p.height)
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(bg) end
    
    -- bg:runAction(cc.FadeTo:create(0.1, 170))
    -- bg:runAction(cc.Sequence:create(
    --     cc.DelayTime:create(2.5),
    --     cc.FadeTo:create(0.1, 0),
    --     nil
    -- ))
    layer:addChild(bg)

    local timeScale = GlobalBattleHelper.getSchedulerTimeScale()
    -- local eff2 = ex.EffectCtr:playNormalEff(12, ex.p.width * 0.5, ex.p.height * 0.6, nil, layer, 10, nil, nil, nil, 1.0/timeScale)
    -- local scale = ex.p.width / (eff2.anim:getContentSize().width + 80)
    -- eff2:setScale(scale)

    local spine = sp.SkeletonAnimation:create("spine/Dragon-".. dragonType ..".json","spine/Dragon-".. dragonType ..".atlas", 1)
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(spine) end
    spine:setAnimation(0, "attack2", false)
    spine:setScaleX(flipped and -0.75 or 0.75)
    spine:setScaleY(0.75)
    spine:setPosition(ex.p.width * (flipped and 0.78 or 0.22), ex.p.height * 0.7)
    layer:addChild(spine, 10)
    
    spine:runAction(cc.Sequence:create(
        cc.DelayTime:create(1.0),
        cc.CallFunc:create(function()
            ex.AudioManager:playEffect("music/dragon-atk.mp3")
        end),
        cc.DelayTime:create(0.5),
        cc.FadeOut:create(0.4),
        nil
    ))
    layer:runAction(cc.Sequence:create(
        cc.DelayTime:create(2.4),
        cc.CallFunc:create(function()
            handler()
        end),
        cc.DelayTime:create(0.8),
        cc.RemoveSelf:create(),
        nil
    ))

    local topEffectLayer = self._layerContext:getTopEffectLayer()
    
    local layerPos = topEffectLayer:convertToWorldSpace(cc.p(0, 0))
    layerPos.y = -layerPos.y
    layer:setPosition(layerPos)

    topEffectLayer:addChild(layer)
end

--[[
    英雄技能必杀特效
]]
function BattleController:_createHeroSlayEffect(heroData, handler)
    local HERO_START_OFFSET_X = -500
    local HERO_END_OFFSET_X = -200
    local HERO_OFFSET_Y = -160
    local HERO_MOVE_DELAY = 0.1
    local HERO_SCALE = 1.0

    local layer = cc.Layer:create()
    if self._enabledPlaySpeed then
        GlobalBattleHelper.bindScheduler(layer)
    end

    local heroNode = heroData:getBattleNode()
    local slayInfo = HERO_SLAY_EFFECT_MAP[heroNode:getElement()]
    if slayInfo == nil then
        handler()
        return
    end

    local effectSpine = sp.SkeletonAnimation:create("spine/bisha.json","spine/bisha.atlas", 1)
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(effectSpine) end
    effectSpine:setAnimation(0, slayInfo.action, false)
    layer:addChild(effectSpine)

    local scale = ex.p.width / 640
    layer:setScale(scale)

    local heroResName = ex.Tools:getHeroSkinByStar(heroNode:getHeroType(), heroNode:getStar(), heroNode:getEvolve())
    local heroSpine = HeroSpineFactory.create(heroResName, HERO_SCALE)
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(heroSpine) end
    heroSpine:setAnimation(0, BattleHeroNode.Action.Stand, true)
    local heroSize = heroSpine:getContentSize()
    heroSpine:setPosition(cc.p(
        HERO_START_OFFSET_X * scale,
        HERO_OFFSET_Y * scale
    ))
    layer:addChild(heroSpine)
    local moveAction = cc.Sequence:create(
        cc.MoveTo:create(HERO_MOVE_DELAY, cc.p(
            HERO_END_OFFSET_X * scale,
            HERO_OFFSET_Y * scale
        )),
        nil
    )
    heroSpine:runAction(moveAction)

    local action = cc.Sequence:create(
        cc.DelayTime:create(HERO_SLAY_DELAY),
        cc.CallFunc:create(function()
            handler()
        end),
        cc.RemoveSelf:create(),
        nil
    )
    layer:runAction(action)
    
    return layer
end

function BattleController:_battleLayerUpdate(dt)
    if self._heroTalkEnabled then
        self:_updateHeroTalk(dt)
    end
end

function BattleController:_updateHeroTalk(dt)
    self._heroTalkIntervalAccum = self._heroTalkIntervalAccum + dt
    if self._heroTalkIntervalAccum >= self._heroTalkInterval then
        self._heroTalkIntervalAccum = self._heroTalkInterval
        
        local heroes = self:_selectPlayerHeroes()
        local heroLen = #heroes
        if heroLen == 0 then return end

        self:_updateHeroTalks()
        if #self._heroTalks == 0 then return end
        
        local randTalkIndex = math.random(#self._heroTalks)
        local talkLang = self._heroTalks[randTalkIndex]
        
        local randIndex = math.random(heroLen)
        local hero = heroes[randIndex]

        local talkLayerTag = 20001
        local oldTalkLayer = hero:getChildByTag(talkLayerTag)
        if oldTalkLayer then return end
        
        local talkLayer = self:_createHeroTalkLayer(talkLang)
        talkLayer:setTag(talkLayerTag)
        talkLayer:runAction(cc.Sequence:create(
            cc.DelayTime:create(cfg.system.hero_talk_last),
            cc.RemoveSelf:create(),
            nil
        ))
        hero:addChild(talkLayer)

        self._heroTalkIntervalAccum = 0
    end
end

function BattleController:_createHeroTalkLayer(lang)
    local str = ex.Tools:getLang(lang)
    local layer = cc.Layer:create()

    local label = cpp.RichTextEx:createWithXMLLua("")
    label:setFontSize(16)
    label:setFontFace(FONT_DEFAULT_NAME_BOLD)
    label:setFontColor("#431611")
    label:setAnchorTextShadow(true)
    label:setAnchorPoint(cc.p(0.5, 0.5))
    label:ignoreContentAdaptWithSize(false)
    label:setContentSize(230, 0)
    label:setPosition(cc.p(0, 8))
    label:setWrapMode(1)

    label:setXmlTextLua(str)
    label:formatText()
    
    local tipsHeight = label:getContentSize().height+30

    local talkTips = ccui.Scale9Sprite:createWithSpriteFrameName('hero/talk-tips.png', cc.rect(70, 10, 22, 28))
    talkTips:setContentSize(cc.size(250, tipsHeight))
    
    layer:addChild(talkTips)
    layer:addChild(label)

    layer:setScale(1.53)
    layer:setAnchorPoint(cc.p(0,0))
    layer:setPosition(cc.p(230, 0.5*tipsHeight + 150))

    return layer
end

function BattleController:_updateHeroTalks()
    if self._playerLevel == ex.Player.level then return end

    self._playerLevel = ex.Player.level

    self._heroTalks = {}
    for i,v in pairs(cfg.herotalk.herotalk) do
        if self._playerLevel > v.level_min and self._playerLevel < v.level_max then
            table.insert(self._heroTalks, v.lan)
        end
    end
end

function BattleController:_selectPlayerHeroes()
    local heroes = {}

    if self._battleInfo == nil then
        for i, heroNode in pairs(self._retainedHeroes) do
            table.insert(heroes, heroNode)
        end
    else
        for i, hero in pairs(self._battleInfo:getHeroes()) do
            if hero:getTeam() == BattleHeroData.TeamType.Player then
                table.insert(heroes, hero:getBattleNode())
            end
        end
    end

    return heroes
end

function BattleController:_emit(event, data)
    if self._eventListener[event] == nil then return end

    for k,v in ipairs(self._eventListener[event]) do
        v(data)
    end
end

function BattleController:_triggerHeroData(heroData)
    self:_emit(BattleController.Event.HeroDead, {
        heroData = heroData
    })
end

function BattleController:_getCurrentRoundData()
    return self._battleInfo:getRound(self._battlingInfo.roundCursor)
end

function BattleController:_initSpriteFrames()
    local sfc = cc.SpriteFrameCache:getInstance()
    for k,v in ipairs(FRAME_PLISTS) do
        sfc:addSpriteFrames(v)
    end
end

function BattleController:_createLayerContext(btfLayer, options)
    local innerLayer = cc.Node:create()
    btfLayer:addChild(innerLayer)

    local actionLayer = cc.Node:create()
    if options.enabledPlaySpeed then
        GlobalBattleHelper.bindScheduler(actionLayer)
    end
    btfLayer:addChild(actionLayer)

    local fullEffectLayer = cc.Node:create()
    fullEffectLayer:setLocalZOrder(GlobalBattleHelper.LayerZOrder.FullEffect)
    fullEffectLayer:setContentSize(cc.size(ex.p.width, ex.p.height))
    innerLayer:addChild(fullEffectLayer)

    local effectLayer = cc.Node:create()
    effectLayer:setLocalZOrder(GlobalBattleHelper.LayerZOrder.HeroEffect)
    innerLayer:addChild(effectLayer)

    local containEffectLayer = cc.Node:create()
    effectLayer:addChild(containEffectLayer)

    local rightEffectLayer = cc.Node:create()
    effectLayer:addChild(rightEffectLayer)
    
    local leftEffectLayer = cc.Node:create()
    leftEffectLayer:setScaleX(-1)
    effectLayer:addChild(leftEffectLayer)

    local labelLayer = cc.Node:create()
    labelLayer:setLocalZOrder(GlobalBattleHelper.LayerZOrder.LabelLayer)
    innerLayer:addChild(labelLayer)

    local topEffectLayer = cc.Node:create()
    topEffectLayer:setLocalZOrder(GlobalBattleHelper.LayerZOrder.TopEffect)
    innerLayer:addChild(topEffectLayer)
    
    return BattleLayerContext.new({
        layer = innerLayer,
        actionLayer = actionLayer,
        fullEffectLayer = fullEffectLayer,
        containEffectLayer = containEffectLayer,
        leftEffectLayer = leftEffectLayer,
        rightEffectLayer = rightEffectLayer,
        labelLayer = labelLayer,
        topEffectLayer = topEffectLayer,
    })
end

function BattleController:_initLayersSize()
    local size = self._battlefieldLayer:getContentSize()
    
    self._layerContext:getLayer():setContentSize(size)
    self._layerContext:getActionLayer():setContentSize(size)
    self._layerContext:getContainEffectLayer():setContentSize(size)
    self._layerContext:getLeftEffectLayer():setContentSize(size)
    self._layerContext:getRightEffectLayer():setContentSize(size)
    self._layerContext:getLabelLayer():setContentSize(size)
    self._layerContext:getTopEffectLayer():setContentSize(size)

    self._layerContext:getLeftEffectLayer():setPositionX(size.width)
    
    local fullEffectLayer = self._layerContext:getFullEffectLayer()
    local worldPos = fullEffectLayer:convertToWorldSpace(cc.p(0, 0))
    local fullLayerPos = cc.p(0, -worldPos.y)
    fullEffectLayer:setPosition(fullLayerPos)
end

function BattleController:_resolveAll()
    for k,v in ipairs(self._promiseResolves) do
        v()
    end
    self._promiseResolves = {}
end

function BattleController:_stopAllAction()
    if self._battleInfo == nil then return end

    self._layerContext:getActionLayer():stopAllActions()
    for k,hero in pairs(self._battleInfo:getHeroes()) do
        hero:getBattleNode():stopAllActions()
    end
end

function BattleController:_clear()
    self:_collectRetainedHeroes()
    self:_clearAllChildrenInLayer()
    self._battleInfo = nil
    self._battlingInfo = nil
end

function BattleController:_clearAllChildrenInLayer()
    if self._battleInfo == nil then return end

    for i,v in pairs(self._battleInfo:getHeroes()) do
        if self._isRetainedPlayerHeroes and v:getTeam() == BattleHeroData.TeamType.Player then
            self:_addRetainedHero(v)
        else
            v:getBattleNode():removeFromParent()
        end
    end

    self._layerContext:getActionLayer():removeAllChildren()
    self._layerContext:getFullEffectLayer():removeAllChildren()
    self._layerContext:getLeftEffectLayer():removeAllChildren()
    self._layerContext:getRightEffectLayer():removeAllChildren()
    self._layerContext:getLabelLayer():removeAllChildren()
end

function BattleController:_collectRetainedHeroes()
    if self._battleInfo == nil then return end
    
    for k,hero in pairs(self._battleInfo:getHeroes()) do
        if hero:getTeam() == BattleHeroData.TeamType.Player and self._isRetainedPlayerHeroes then
            self:_addRetainedHero(hero)
        end
    end
end

function BattleController:_showEnergyLabelForDebug(heroData, v)
    if cpp.SocialPlatform:instance():isDebug() then
        if v >= 0 then
            v = '+' .. tostring(v)
        end
        local utLabel = ActionNodeFactory.createTipsLabel(
            '能量 ' .. v,
            heroData,
            self._enabledPlaySpeed
        )
        self._layerContext:getLabelLayer():addChild(utLabel)
    end
end

function BattleController:_addRetainedHero(hero)
    local key = self:_genRetainedHeroKey(hero)
    self._retainedHeroes[key] = hero:getBattleNode()
end

function BattleController:_genRetainedHeroKey(hero)
    local index = "0"
    if hero.getIndex then
        index = hero:getIndex()
    end
    return tostring(hero:getId() or '' .. '.' .. index) .. '.' .. tostring(hero:getBattleNode():getHeroId())
end

function BattleController:_printLog(str)
    if self._isPrintLog then
        GlobalBattleHelper.println(str)
    end
end

return BattleController
