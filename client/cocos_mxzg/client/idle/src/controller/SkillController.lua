local SkillController = class('SkillController')

local Promise = require('src.model.Promise')
local BattleActionContext = require('src.context.BattleActionContext')
local BattleUpdateContext = require('src.context.BattleUpdateContext')

local BattleBuffInfo = require('src.entity.battle.BattleBuffInfo')
local BattleHeroData = require('src.entity.battle.BattleHeroData')

local SKILL_RES_PATH_TPL = 'skill/%s.plist'

local REVIVE_PATH_TPL = 'skill-effect-revive/%d.png'
local REVIVE_DURATION = 0.075
local REVIVE_ANCHOR = cc.p(0.5, 0.25)

local HERO_ICON_TPL = 'hero-icon/%s.png'

local REPEL_TIME       = 0.1
local REPEL_X_OFFSET   = 50
local REPEL_ACTION_TAG = 100080

--[[
    layerContext : 战斗场景层的上下文
]]
function SkillController:ctor(controlContext, layerContext, enabledPlaySpeed)
    self._controlContext = controlContext
    self._layerContext = layerContext
    self._stopping = false
    self._resolves = {}
    self._enabledPlaySpeed = enabledPlaySpeed
    self._isShowAttackingTips = true
    self._isPrintLog = false
    self._resurrectionBuffs = {}

    self._heroDeadHandler = nil
end

function SkillController:setHeroDeadHandler(handler)
    self._heroDeadHandler = handler
end

--[[
    开始播放指定的攻击模式

    attackInfo : <BattleAttackInfo>对象

    返回Promise对象。角色的攻击已经完成的承诺对象
]]
function SkillController:play(attackInfo)
    self._stopping = false

    local actionHeroData = attackInfo:getActionHeroData()
    local heroNode = actionHeroData:getBattleNode()
    
    heroNode:stopActionByTag(REPEL_ACTION_TAG)
    heroNode:setPosition(actionHeroData:getPosition())

    if heroNode.hideInfoNode then
        heroNode:hideInfoNode()
    end

    self:_printLog('---------- Action Hero ID : ' .. attackInfo:getId() .. ' ----------')
    self:_printLog('hero type : ' .. heroNode:getHeroId())
    self:_printLog('skill id  : ' .. (attackInfo:getSkillId() or ''))

    if self._isShowAttackingTips and attackInfo:getSkillType() == 1 then
        self:_playAttackingSkillInfo(attackInfo)
    end

    if heroNode.getEnergy then
        heroNode:setEnergy(heroNode:getEnergy() + attackInfo:getEnergyUpdate())
        self:_showEnergyLabelForDebug(actionHeroData, attackInfo:getEnergyUpdate())
    end

    local options = {
        isSkill = attackInfo:getSkillType() == 1
    }

    local allPromises = {Promise.resolve()}
    for k,v in ipairs(attackInfo:getEffects()) do
        local promise = self:playEffect(actionHeroData, v, options)
        table.insert(allPromises, promise)
    end

    return Promise.all(allPromises):next(function()
        if self._stopping then return Promise.resolve() end
        for k, buffInfo in ipairs(self._resurrectionBuffs) do
            local buff = buffInfo:getBuff()
            local heroNode = buffInfo:getHeroData():getBattleNode()
            
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

            self:_playUpdates(buffInfo, options)
        end
        self._resurrectionBuffs = {}

        if heroNode.showInfoNode then
            heroNode:showInfoNode()
        end

        return Promise.resolve()
    end):catch(function(err)
        print(err)
    end)
end

function SkillController:stop()
    self._stopping = true
    for k,v in ipairs(self._resolves) do
        v()
    end

    self._resolves = {}
    self._resurrectionBuffs = {}
end

function SkillController:playEffect(actionHeroData, effect, options)
    return Promise.new(
        function(resolve)
            table.insert(self._resolves, resolve)
            local buff = effect:getBuff()

            self:_printLog('playing buff - idx: ' .. buff.idx .. ' type: ' .. buff.type)
            
            local sfc = cc.SpriteFrameCache:getInstance()
            if type(buff.file) == 'table' then
                for k,v in ipairs(buff.file) do
                    local plistPath = string.format(SKILL_RES_PATH_TPL, v)
                    sfc:addSpriteFrames(plistPath)
                end
            end

            local initData = {
                enabledPlaySpeed = self._enabledPlaySpeed,
                controlContext = self._controlContext,
                layer = self._layerContext:getLayer(),
                layerContext = self._layerContext,
                actionHeroData = actionHeroData,
                effect = effect,
                isDelay = true,
                hitHandler = function(hitType)
                    for k,v in pairs(effect:getBuffs()) do
                        self:_playBuffUpdate(hitType, v, options)
                    end
                end,
                completedHandler = function()

                    for _,v in pairs(effect:getBuffs()) do
                        if v:getStatus() == BattleBuffInfo.Status.Dead then
                            local heroNode = v:getHeroData():getBattleNode()
                            heroNode:die()
                            if self._heroDeadHandler then
                                self._heroDeadHandler(v:getHeroData())
                            end
                        end
                    end

                    if self._stopping then return end
                    TableEx.removeItem(self._resolves, resolve)
                    resolve()
                end
            }
            local ctx = BattleActionContext.new(initData)
            BattleActionUtils.playBuff(ctx)
        end
    )
end

function SkillController:setIsShowAttackingTips(isShow)
    self._isShowAttackingTips = isShow or false
end

function SkillController:setIsPrintLog(isPrintLog)
    self._isPrintLog = isPrintLog
end

function SkillController:_playBuffUpdate(hitType, buffInfo, options)
    local heroNode = buffInfo:getHeroData():getBattleNode()
    if hitType == BattleActionContext.HitType.Harm then
        heroNode:actionHit()
        self:_beRepel(buffInfo:getHeroData())
    end

    -- if buffInfo:getStatus() == BattleBuffInfo.Status.Dead then
    --     heroNode:die()
    --     if self._heroDeadHandler then
    --         self._heroDeadHandler(buffInfo:getHeroData())
    --     end
    -- end

    local buff = buffInfo:getBuff()
    if buff.type == BattleActionUtils.ActionBuffType.Resurrection then
        if heroNode.addBuffTip then
            heroNode:addBuffTip(buff.buff_name_lang, buff.buff_name_color)
        end
    
        table.insert(self._resurrectionBuffs, buffInfo)
        return
    elseif buff.type == BattleActionUtils.ActionBuffType.ActionResurrection then
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

    self:_playUpdates(buffInfo, options)
end

function SkillController:_playUpdates(buffInfo, options)
    local attrUpdates = buffInfo:getUpdates()
    for k,v in pairs(attrUpdates) do
        local ctx = BattleUpdateContext.new({
            enabledPlaySpeed = self._enabledPlaySpeed,
            layer = self._layerContext:getLabelLayer(),
            update = v,
            isSkill = options.isSkill,
            hit = buffInfo:getHit()
        })
        BattleAttrUpdateUtils.update(v:getType(), ctx)
    end
end

function SkillController:_playAttackingHeroInfo(heroData)
    local heroNode = heroData:getBattleNode()

    local skillTipsLayer = cc.Layer:create()
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(skillTipsLayer) end
    local skillTips = sp.SkeletonAnimation:create("spine/yingxiongtiao.json","spine/yingxiongtiao.atlas", 1)
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(skillTips) end
    if heroData:getTeam() == BattleHeroData.TeamType.Player then
        skillTips:setAnimation(0, "lanse", false)
    else
        skillTips:setAnimation(0, "hongse", false)
    end
    skillTipsLayer:addChild(skillTips)
    self._layerContext:getTopEffectLayer():addChild(skillTipsLayer)

    local heroType = heroNode:getHeroId()
    local heroName = ex.Tools:getLang(heroType)

    local offsetX = #heroName * 3.5

    local heroNameLabel = cc.Label:createWithTTF(heroName, FONT_DEFAULT_NAME_BOLD, 24)
    heroNameLabel:enableOutline(FONT_BLACK_C4B, 2)
    heroNameLabel:setAnchorPoint(cc.p(0, 0.5))
    heroNameLabel:setPosition(cc.p(-offsetX+5, 0))
    skillTipsLayer:addChild(heroNameLabel)

    local heroIconId = ex.Tools:getHeroIconByStar(heroType, heroNode:getStar()) + 10000000
    local heroIconPath = string.format(HERO_ICON_TPL, heroIconId)
    local heroIconSprite = cc.Sprite:createWithSpriteFrameName(heroIconPath) or cc.Sprite:create()
    heroIconSprite:setScale(0.35)
    heroIconSprite:setAnchorPoint(cc.p(1.0, 0.5))
    heroIconSprite:setPosition(cc.p(-offsetX, 0))
    skillTipsLayer:addChild(heroIconSprite)

    local effectSize = self._layerContext:getTopEffectLayer():getContentSize()
    skillTipsLayer:setPosition(cc.p(
        0.5 * effectSize.width,
        0.5 * effectSize.height
    ))

    skillTipsLayer:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.8),
        cc.RemoveSelf:create(),
        nil
    ))
end

function SkillController:_playAttackingSkillInfo(attackInfo)
    local heroData = attackInfo:getActionHeroData()
    local heroNode = heroData:getBattleNode()

    local skillTipsLayer = cc.Layer:create()
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(skillTipsLayer) end
    local skillTips = sp.SkeletonAnimation:create("spine/yingxiongtiao.json","spine/yingxiongtiao.atlas", 1)
    if self._enabledPlaySpeed then GlobalBattleHelper.bindScheduler(skillTips) end
    if heroData:getTeam() == BattleHeroData.TeamType.Player then
        skillTips:setAnimation(0, "lanse", false)
    else
        skillTips:setAnimation(0, "hongse", false)
    end
    skillTipsLayer:addChild(skillTips)
    self._layerContext:getTopEffectLayer():addChild(skillTipsLayer)

    local skillName = ex.Player.hero_data:getSkillName(attackInfo:getSkillId())
    
    local offsetX = #skillName * 3.5

    local skillNameLabel = cc.Label:createWithTTF(skillName, FONT_DEFAULT_NAME_BOLD, 24)
    skillNameLabel:enableOutline(FONT_BLACK_C4B, 2)
    skillNameLabel:setAnchorPoint(cc.p(0, 0.5))
    skillNameLabel:setPosition(cc.p(-offsetX+5, 0))
    skillTipsLayer:addChild(skillNameLabel)

    if heroNode.getStar then
        local heroType = heroNode:getHeroId()
        local heroIconId = ex.Tools:getHeroIconByStar(heroType, heroNode:getStar()) + 10000000
        local heroIconPath = string.format(HERO_ICON_TPL, heroIconId)
        local heroIconSprite = cc.Sprite:createWithSpriteFrameName(heroIconPath) or cc.Sprite:create()
        heroIconSprite:setScale(0.35)
        heroIconSprite:setAnchorPoint(cc.p(1.0, 0.5))
        heroIconSprite:setPosition(cc.p(-offsetX, 0))
        skillTipsLayer:addChild(heroIconSprite)
    end

    local effectSize = self._layerContext:getTopEffectLayer():getContentSize()
    skillTipsLayer:setPosition(cc.p(
        0.5 * effectSize.width,
        0.5 * effectSize.height
    ))

    skillTipsLayer:runAction(cc.Sequence:create(
        cc.DelayTime:create(0.8),
        cc.RemoveSelf:create(),
        nil
    ))
end

function SkillController:_beRepel(heroData)
    local oldAction = heroData:getBattleNode():getActionByTag(REPEL_ACTION_TAG)
    if oldAction then return end

    local xFactor = heroData:getTeam() == BattleHeroData.TeamType.Player and -1 or 1
    local repelAction = cc.Sequence:create(
        cc.MoveBy:create(REPEL_TIME, cc.p(xFactor * REPEL_X_OFFSET, 0)),
        cc.MoveTo:create(REPEL_TIME, heroData:getPosition()),
        nil
    )
    repelAction:setTag(REPEL_ACTION_TAG)

    heroData:getBattleNode():runAction(repelAction)
end

function SkillController:_showEnergyLabelForDebug(heroData, v)
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

function SkillController:_printLog(str)
    if self._isPrintLog then
        GlobalBattleHelper.println(str)
    end
end

return SkillController
