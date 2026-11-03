local BattleBuffInfo = require('src.entity.battle.BattleBuffInfo')

--[[
    战斗中的属性操作类型对应的功能函数。

    注意 : 所有的功能函数，都以<BattleUpdateContext>对象作为参数
]]
BattleAttrUpdateUtils = {}

local FRONT_ANCHOR = cc.p(1.0, 0.5)

local SHIELD_IMAGE_PATH = 'hero-beattack/spr-shield.png'
local SHIELD_SCALE = 1.0
local SHIELD_X_OFFSET = 0
local SHIELD_Y_OFFSET = 10*SHIELD_SCALE
local SHIELD_ACTION_DELAY = 1.2
local SHIELD_ACTION_FADE_TIME = 0.8

local PARRY_IMAGE_PATH = 'hero-beattack/spr-parry.png'
local PARRY_SCALE = 1.0
local PARRY_X_OFFSET = 50
local PARRY_Y_OFFSET = 10*PARRY_SCALE
local PARRY_ACTION_DELAY = 1.2
local PARRY_ACTION_FADE_TIME = 0.8

local CRITICAL_IMAGE_PATH = 'hero-beattack/spr-critical-bg.png'
local CRITICAL_SCALE = 1.5
local CRITICAL_X_OFFSET = 20*CRITICAL_SCALE
local CRITICAL_Y_OFFSET = 20*CRITICAL_SCALE
local CRIT_ACTION_DELAY = 0.9
local CRIT_ACTION_FADE_TIME = 0.7

local MISS_IMAGE_PATH = 'hero-beattack/shanbi.png'
local MISS_SCALE = 1.0
local MISS_X_OFFSET = 60*SHIELD_SCALE
local MISS_Y_OFFSET = 10*SHIELD_SCALE
local MISS_ACTION_DELAY = 0.9
local MISS_ACTION_FADE_TIME = 0.7

--[[
    属性更新函数列表
]]
BattleAttrUpdateUtils._updates = {}

BattleAttrUpdateUtils.update = function(updateType, ctx)
    local updateHandler = BattleAttrUpdateUtils._updates[updateType]
    if updateHandler then
        updateHandler(ctx)
    end
end

--[[
    属性更新类型110 : 影响角色的能量
]]
BattleAttrUpdateUtils._updates[110] = function(ctx)
    local update = ctx:getUpdate()
    local targetHeroData = update:getHeroData()

    targetHeroData:getBattleNode():setEnergy(targetHeroData:getBattleNode():getEnergy() + update:getValue())
end

--[[
    属性更新类型223 : 影响角色的血量
]]
BattleAttrUpdateUtils._updates[223] = function(ctx)
    local update = ctx:getUpdate()
    local targetHeroData = update:getHeroData()
    local battleNode = targetHeroData:getBattleNode()

    if battleNode.getHp then
        battleNode:setHp(battleNode:getHp() + update:getValue())
    end
    
    if ctx:getHit() == BattleBuffInfo.HitType.Parry then
        local bLabel = ActionNodeFactory.createTipsLabel('', targetHeroData, ctx:getEnabledPlaySpeed())
        BattleAttrUpdateUtils._appendFrontSprite(bLabel, ctx:getEnabledPlaySpeed(), {
            path = PARRY_IMAGE_PATH,
            scale = PARRY_SCALE,
            offset = cc.p(PARRY_X_OFFSET, PARRY_Y_OFFSET),
            delay = PARRY_ACTION_DELAY,
            fadeTime = PARRY_ACTION_FADE_TIME,
        })
        ctx:getLayer():addChild(bLabel)
    elseif update:getValue() < 0 then
        local bLabel = nil
        if ctx:getHit() == BattleBuffInfo.HitType.Miss then
            bLabel = ActionNodeFactory.createMissLabel(targetHeroData, update:getValue(), ctx:getEnabledPlaySpeed())
            BattleAttrUpdateUtils._appendFrontSprite(bLabel, ctx:getEnabledPlaySpeed(), {
                path = MISS_IMAGE_PATH,
                scale = MISS_SCALE,
                offset = cc.p(MISS_X_OFFSET, MISS_Y_OFFSET),
                delay = MISS_ACTION_DELAY,
                fadeTime = MISS_ACTION_FADE_TIME,
            })
        elseif ctx:getHit() == BattleBuffInfo.HitType.Crit then
            bLabel = ActionNodeFactory.createCirtDamageLabel(targetHeroData, update:getValue(), ctx:getEnabledPlaySpeed())
            BattleAttrUpdateUtils._appendFrontSprite(bLabel, ctx:getEnabledPlaySpeed(), {
                path = CRITICAL_IMAGE_PATH,
                scale = CRITICAL_SCALE,
                offset = cc.p(CRITICAL_X_OFFSET, CRITICAL_Y_OFFSET),
                delay = CRIT_ACTION_DELAY,
                fadeTime = CRIT_ACTION_FADE_TIME,
            })
        elseif ctx:isSkill() then
            bLabel = ActionNodeFactory.createSkillDamageLabel(targetHeroData, update:getValue(), ctx:getEnabledPlaySpeed())
        else
            bLabel = ActionNodeFactory.createDamageLabel(targetHeroData, update:getValue(), ctx:getEnabledPlaySpeed())
        end

        ctx:getLayer():addChild(bLabel)
    else
        local bLabel = ActionNodeFactory.createHealLabel(targetHeroData, update:getValue(), ctx:getEnabledPlaySpeed())
        ctx:getLayer():addChild(bLabel)
    end
end

--[[
    属性更新类型140 : 护盾
]]
BattleAttrUpdateUtils._updates[140] = function(ctx)
    local update = ctx:getUpdate()
    local targetHeroData = update:getHeroData()
    
    local bLabel = ActionNodeFactory.createFontTipsLabel(tostring(update:getValue()), 1, targetHeroData, ctx:getEnabledPlaySpeed())
    BattleAttrUpdateUtils._appendFrontSprite(bLabel, ctx:getEnabledPlaySpeed(), {
        path = SHIELD_IMAGE_PATH,
        scale = SHIELD_SCALE,
        offset = cc.p(SHIELD_X_OFFSET, SHIELD_Y_OFFSET),
        delay = SHIELD_ACTION_DELAY,
        fadeTime = SHIELD_ACTION_FADE_TIME,
    })
    ctx:getLayer():addChild(bLabel)
end

--[[
    添加属性更新前置图片

    options:
    {
        path     : <string> 前置图片路径
        scale    : <float>  缩放值
        offset   : <x,y>    位置偏移值
        delay    : <float>  延迟淡出时间
        fadeTime : <float>  淡出时间
    }
]]
BattleAttrUpdateUtils._appendFrontSprite = function(pnode, enabledPlaySpeed, options)
    local spr = cc.Sprite:createWithSpriteFrameName(options.path)
    if enabledPlaySpeed then
        GlobalBattleHelper.bindScheduler(spr)
    end
    spr:setScale(options.scale)
    
    local pnodeSize = pnode:getContentSize()
    local sprSize = spr:getContentSize()

    spr:setAnchorPoint(FRONT_ANCHOR)
    spr:setPosition(cc.p(
        options.offset.x,
        pnodeSize.height / 2 + options.offset.y
    ))

    pnode:addChild(spr)

    local action = cc.Sequence:create(
        cc.DelayTime:create(options.delay),
        cc.EaseSineIn:create(cc.FadeOut:create(options.fadeTime)),
        nil
    )

    spr:runAction(action)
end
