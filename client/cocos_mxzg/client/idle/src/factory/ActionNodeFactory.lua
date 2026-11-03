--[[
    动作节点工厂，创建战斗相关的显示对象

    在创建战斗相关的对象时要注意添加战斗专属的调度器和动作管理器，
    否则对象无法兼容战斗速度

    请参考: GlobalBattleHelper.bindScheduler
]]
ActionNodeFactory = {}

--[[
    buff类型对应的飘动文字索引表
]]
ActionNodeFactory._updateStatusText = {}
ActionNodeFactory._updateStatusText[150]  = ex.Tools:getLang(5757) -- '复活'
ActionNodeFactory._updateStatusText[1001] = ex.Tools:getLang(5758) -- '沉默'
ActionNodeFactory._updateStatusText[1002] = ex.Tools:getLang(5759) -- '缴械'
ActionNodeFactory._updateStatusText[1003] = ex.Tools:getLang(5760) -- '定身'
ActionNodeFactory._updateStatusText[1004] = ex.Tools:getLang(5761) -- '冰冻'
ActionNodeFactory._updateStatusText[1005] = ex.Tools:getLang(5762) -- '眩晕'
ActionNodeFactory._updateStatusText[1006] = ex.Tools:getLang(5763) -- '石化'
ActionNodeFactory._updateStatusText[1008] = ex.Tools:getLang(5764) -- '护盾'
ActionNodeFactory._updateStatusText[1201] = ex.Tools:getLang(5765) -- '灼烧'
ActionNodeFactory._updateStatusText[1202] = ex.Tools:getLang(5766) -- '霜冻'
ActionNodeFactory._updateStatusText[1203] = ex.Tools:getLang(5767) -- '中毒'
ActionNodeFactory._updateStatusText[1204] = ex.Tools:getLang(5768) -- '感电'
ActionNodeFactory._updateStatusText[1205] = ex.Tools:getLang(5769) -- '流血'
ActionNodeFactory._updateStatusText[1206] = ex.Tools:getLang(5770) -- '烈火'
ActionNodeFactory._updateStatusText[1207] = ex.Tools:getLang(5771) -- '诅咒'
ActionNodeFactory._updateStatusText[1208] = ex.Tools:getLang(5772) -- '瘟疫'
ActionNodeFactory._updateStatusText[1301] = ex.Tools:getLang(5773) -- '反击！'
ActionNodeFactory._updateStatusText[1302] = ex.Tools:getLang(5774) -- '反击！'

local BattleHeroData = require('src.entity.battle.BattleHeroData')

local ACTION_NODE_ZORDER = 10000
local BOUNCE_FONT_SCALE = 0.5
local FLUTTER_FONT_SCALE   = 0.6

-- flutter
local FLUTTER_FONT_SIZE = 30
local FLUTTER_HEIGHT = 100
local FLUTTER_TIME = 3.0

local FONT_FLUTTER_TIME = 2.0

local DAMAGE_FONT_NAME = 'font/yellow-73.fnt'
local CIRT_FONT_NAME   = 'font/red-73.fnt'
local SKILL_FONT_NAME  = 'font/blue-73.fnt'
local HEAL_FONT_NAME   = 'font/green-73.fnt'

local FontMap = {
    [1] = DAMAGE_FONT_NAME,
}

--[[
    创建闪避弹跳文字label
]]
ActionNodeFactory.createMissLabel = function(heroData, enabledPlaySpeed)
    if enabledPlaySpeed == nil then enabledPlaySpeed = true end
    local bLabel = ActionNodeFactory._createBounceLabel(
        '',
        DAMAGE_FONT_NAME,
        ActionNodeFactory._getHeroDirection(heroData:getTeam()),
        enabledPlaySpeed
    )
    ActionNodeFactory._setHeaderParams(bLabel, heroData)

    return bLabel
end

--[[
    创建伤害弹跳文字label
]]
ActionNodeFactory.createDamageLabel = function(heroData, num, enabledPlaySpeed)
    if enabledPlaySpeed == nil then enabledPlaySpeed = true end
    local bLabel = ActionNodeFactory._createBounceLabel(
        tostring(num),
        DAMAGE_FONT_NAME,
        ActionNodeFactory._getHeroDirection(heroData:getTeam()),
        enabledPlaySpeed
    )
    ActionNodeFactory._setHeaderParams(bLabel, heroData)

    return bLabel
end

--[[
    创建暴击伤害弹跳文字label
]]
ActionNodeFactory.createCirtDamageLabel = function(heroData, num, enabledPlaySpeed)
    if enabledPlaySpeed == nil then enabledPlaySpeed = true end
    local bLabel = ActionNodeFactory._createBounceLabel(
        tostring(num),
        CIRT_FONT_NAME,
        ActionNodeFactory._getHeroDirection(heroData:getTeam()),
        enabledPlaySpeed
    )
    ActionNodeFactory._setHeaderParams(bLabel, heroData)

    return bLabel
end

--[[
    创建技能伤害弹跳文字label
]]
ActionNodeFactory.createSkillDamageLabel = function(heroData, num, enabledPlaySpeed)
    if enabledPlaySpeed == nil then enabledPlaySpeed = true end
    local bLabel = ActionNodeFactory._createBounceLabel(
        tostring(num),
        SKILL_FONT_NAME,
        ActionNodeFactory._getHeroDirection(heroData:getTeam()),
        enabledPlaySpeed
    )
    ActionNodeFactory._setHeaderParams(bLabel, heroData)

    return bLabel
end

--[[
    创建治愈弹跳文字label
]]
ActionNodeFactory.createHealLabel = function(heroData, num, enabledPlaySpeed)
    if enabledPlaySpeed == nil then enabledPlaySpeed = true end
    local bLabel = ActionNodeFactory._createBounceLabel(
        '+' .. tostring(num),
        HEAL_FONT_NAME,
        ActionNodeFactory._getHeroDirection(heroData:getTeam()),
        enabledPlaySpeed
    )
    ActionNodeFactory._setHeaderParams(bLabel, heroData)

    return bLabel
end

--[[
    创建飘动的属性更新提示label
]]
ActionNodeFactory.createUpdateTipsLabel = function(heroData, buffType, enabledPlaySpeed)
    if enabledPlaySpeed == nil then enabledPlaySpeed = true end

    local str = ActionNodeFactory._updateStatusText[buffType] or ''
    local label = ActionNodeFactory.createTipsLabel(str, heroData, enabledPlaySpeed)

    return label
end

--[[
    创建可设置字体的飘动文字Label

    fontIdx: 默认为1
        1 : 黄色字体
]]
ActionNodeFactory.createFontTipsLabel = function(text, fontIdx, heroData, enabledPlaySpeed)
    local fontName = FontMap[fontIdx]
    if fontName == nil then fontName = FontMap[1] end
    local label = cc.Label:createWithBMFont(fontName, text)
    
    if enabledPlaySpeed then
        GlobalBattleHelper.bindScheduler(label)
    end

    local action = cc.Sequence:create(
        cc.Spawn:create(
            cc.EaseSineOut:create(cc.MoveBy:create(FONT_FLUTTER_TIME, cc.p(0, FLUTTER_HEIGHT))),
            cc.FadeOut:create(FONT_FLUTTER_TIME)
        ),
        cc.RemoveSelf:create(),
        nil
    )

    label:runAction(action)
    ActionNodeFactory._setTipsHeaderParams(label, heroData)

    return label
end

--[[
    创建飘动文字Label
]]
ActionNodeFactory.createTipsLabel = function(text, heroData, enabledPlaySpeed)
    local label = cc.Label:createWithTTF(text, FONT_DEFAULT_NAME_BOLD, FLUTTER_FONT_SIZE)
    
    if enabledPlaySpeed then
        GlobalBattleHelper.bindScheduler(label)
    end

    local action = cc.Sequence:create(
        cc.Spawn:create(
            cc.EaseSineOut:create(cc.MoveBy:create(FLUTTER_TIME, cc.p(0, FLUTTER_HEIGHT))),
            cc.FadeOut:create(FLUTTER_TIME)
        ),
        cc.RemoveSelf:create(),
        nil
    )

    label:runAction(action)

    label:enableShadow()
    ActionNodeFactory._setTipsHeaderParams(label, heroData)

    return label
end

ActionNodeFactory._setHeaderParams = function(node, heroData)
    local dFactor = -1
    if ActionNodeFactory._getHeroDirection(heroData:getTeam()) then
        dFactor = 1
    end

    local heroNode = heroData:getBattleNode()
    local heroSize = heroNode:getContentSize()
    local position = clone(heroData:getPosition())
    position.x = position.x + dFactor*80
    position.y = position.y + heroSize.height * heroNode:getScaleY()
    node:setPosition(position)
    node:setScale(FLUTTER_FONT_SCALE)
    node:setLocalZOrder(ACTION_NODE_ZORDER)
end

ActionNodeFactory._setTipsHeaderParams = function(node, heroData)
    local heroNode = heroData:getBattleNode()
    local heroSize = heroNode:getContentSize()
    local position = clone(heroData:getPosition())
    position.x = position.x
    position.y = position.y + heroSize.height * heroNode:getScaleY()
    node:setPosition(position)
    node:setScale(FLUTTER_FONT_SCALE)
    node:setLocalZOrder(ACTION_NODE_ZORDER)
end

ActionNodeFactory._getHeroDirection = function(team)
    return team == BattleHeroData.TeamType.Player
end


ActionNodeFactory._createBounceLabel = function(str, fontName, isMirror, enabledPlaySpeed)
    local dFactor = isMirror and -1 or 1
    local label = cc.Label:createWithBMFont(fontName, str)
    if enabledPlaySpeed then
        GlobalBattleHelper.bindScheduler(label)
    end

    local jumpAction = cc.Sequence:create(
        cc.JumpBy:create(0.3, cc.p(dFactor*15, 0), 100, 1),
        cc.JumpBy:create(0.3, cc.p(dFactor*10, 0), 60, 1),
        cc.JumpBy:create(0.3, cc.p(dFactor*5, 0), 20, 1),
        cc.Spawn:create(
            cc.MoveBy:create(0.7, cc.p((20 + math.random(0, 10)) * dFactor, 0)),
            cc.EaseSineIn:create(cc.FadeOut:create(0.7))
        ),
        cc.RemoveSelf:create(),
        nil
    )

    label:setScale(BOUNCE_FONT_SCALE)
    local scaleAction = cc.Sequence:create(
        cc.EaseSineIn:create(cc.ScaleTo:create(0.3, 2.5*BOUNCE_FONT_SCALE)),
        cc.EaseSineOut:create(cc.ScaleTo:create(0.3, BOUNCE_FONT_SCALE)),
        nil
    )

    label:runAction(jumpAction)
    label:runAction(scaleAction)

    return label
end
