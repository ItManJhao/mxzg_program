local BattleGoddessNode = class('BattleGoddessNode', cc.Node)

local Promise = require('src.model.Promise')
local BattleHeroInfoNode = require('src.entity.battle.BattleHeroInfoNode')
local BattleBuffBarNode = require('src.entity.battle.BattleBuffBarNode')

local NODE_ANCHOR = cc.p(0.5, 0)
local NODE_SIZE = cc.size(140, 120)
local NODE_SCALE = 0.65
local GODDESS_SCALE = 0.45
local NODE_HALF_WIDTH = 0.5 * NODE_SIZE.width

-- goddess energy bar
local PROC_BG_PATH = 'hero/goddess-energy-bg.png'
local ENERGY_BAR_PROC_PATH = 'hero/goddess-energy-process-1.png'
local ENERGY_BAR_FRAME_PATH = 'hero/goddess-energy-process-2.png'
local PROC_BG_SCALE = 1.0
local PROC_BAR_OFFSET = 0.0

-- goddess
local GODDESS_ENERGY_Y_OFFSET = 10

-- buff bar
local BUFF_BAR_TOP_OFFSET = 35*NODE_SCALE

-- round buff
local ROUND_BUFF_TOP_OFFSET = 50*NODE_SCALE

-- hero node
local HERO_SCALE = 0.715
local DIE_ACTION_TIME = 1.0

-- action tag
local ACTION_DIE_TAG = 50002

-- animation
local AnimationEvent = {
    End = 'end',
    Complete = 'complete'
}

--[[
    女神的动作定义
]]
BattleGoddessNode.Action = {
    Null   = 'null',
    Stand  = 'stand',
    Run    = 'run',
    Attack = 'attack',
    Skill  = 'attack2',
    Skill2 = 'attack3',
    Hit    = 'hit',
}

--[[
    initData : 初始化的数据结构体
    {
        hero_id    : <int>     女神的ID
        level      : <int>     女神的等级
        energy     : <int>     女神的能量值
        max_energy : <int>     女神的最大能量值
    }
]]
function BattleGoddessNode:ctor(initData)
    self._heroId    = initData.hero_id
    self._level     = initData.level
    self._fashionId = initData.fashion_id

    self._proc1List = {}
    self._proc2List = {}

    self:setScale(GODDESS_SCALE)
    self:setAnchorPoint(NODE_ANCHOR)
    self:setContentSize(NODE_SIZE)

    self._currentAnimation = nil

    --[[
        回合性buff节点列表
        
        {<buff id> : <cc.Node>}
    ]]
    self._roundBuffNodes = {}

    self._mainNode = cc.Node:create()
    self._mainNode:setPositionX(NODE_HALF_WIDTH)
    self._mainNode:setContentSize(cc.size(0, NODE_SIZE.height))
    self:addChild(self._mainNode)

    self._heroWrapper = cc.Node:create()
    self._heroWrapper:setContentSize(NODE_SIZE)
    self._heroWrapper:setAnchorPoint(NODE_ANCHOR)
    self._mainNode:addChild(self._heroWrapper)

    -- init hero model
    local name = tonumber(self._fashionId)
    if name == nil or name <= 0 then
        name = ex.Player.fetter_data:getSkinByLevel(self._heroId, self._level)
    end
    print("hero spine type = ", name)
    self._heroSpine = HeroSpineFactory.create(name, HERO_SCALE)
    self._heroSpine:setPositionX(NODE_HALF_WIDTH)
    self._heroWrapper:addChild(self._heroSpine)

    self._heroSpine:registerSpineEventHandler(function(e)
        self:_spineEventHandler(e)
    end, sp.EventType.ANIMATION_COMPLETE)

    --[[
        英雄基本信息(血量、能量、元素标记)的节点
    ]]
    self._heroInfoNode = BattleHeroInfoNode.new(initData)
    self._mainNode:addChild(self._heroInfoNode)
    NodeUtils.adjustTop(self._heroInfoNode)

    --[[
        buff状态栏的容器
    ]]
    self._buffBarNode = BattleBuffBarNode.new()
    self._mainNode:addChild(self._buffBarNode)
    NodeUtils.adjustTop(self._buffBarNode, BUFF_BAR_TOP_OFFSET)

    --[[
        特效buff挂接点
    ]]
    self._buffWrapper = cc.Node:create()
    self._mainNode:addChild(self._buffWrapper)

    --[[
        回合性buff特效的挂接点
    ]]
    self._roundBuffEffectNode = cc.Node:create()
    self._mainNode:addChild(self._roundBuffEffectNode)
    NodeUtils.adjustTop(self._roundBuffEffectNode, ROUND_BUFF_TOP_OFFSET)

    self._goddessEnergyBar = self:_createGoddessEnergyBar()
    self._goddessEnergyFront = self:_createGoddessEnergyFront()
    self._heroInfoNode:setVisible(false)
end

function BattleGoddessNode:actionStand()
    self._heroSpine:setAnimation(0, BattleGoddessNode.Action.Stand, true)
    self._currentAnimation = BattleGoddessNode.Action.Stand
end

function BattleGoddessNode:actionRun()
    self._heroSpine:setAnimation(0, BattleGoddessNode.Action.Run, true)
    self._currentAnimation = BattleGoddessNode.Action.Run
end

function BattleGoddessNode:actionAttack()
    self._heroSpine:setAnimation(0, BattleGoddessNode.Action.Attack, false)
    self._currentAnimation = BattleGoddessNode.Action.Attack
end

function BattleGoddessNode:actionSkill()
    self._heroSpine:setAnimation(0, BattleGoddessNode.Action.Skill, false)
    self._currentAnimation = BattleGoddessNode.Action.Skill
end

function BattleGoddessNode:actionSkill2()
    self._heroSpine:setAnimation(0, BattleGoddessNode.Action.Skill2, false)
    self._currentAnimation = BattleGoddessNode.Action.Skill2
end

function BattleGoddessNode:actionHit()
    self._heroSpine:setAnimation(0, BattleGoddessNode.Action.Hit, false)
    self._currentAnimation = BattleGoddessNode.Action.Hit
end

function BattleGoddessNode:animationStop()
    self._heroSpine:setTimeScale(0.0)
end

function BattleGoddessNode:animationResume()
    self._heroSpine:setTimeScale(1.0)
end

function BattleGoddessNode:visible()
    self:setVisible(true)
    self._heroSpine:setVisible(true)
    self._heroSpine:setOpacity(255)
end

function BattleGoddessNode:invisible()
    self:setVisible(false)
    self._heroSpine:setVisible(false)
    self._heroSpine:setOpacity(0)
end

function BattleGoddessNode:revive()
    self._heroSpine:stopActionByTag(ACTION_DIE_TAG)
    self:stopActionByTag(ACTION_DIE_TAG)
    
    self:visible()
    self:actionStand()
end

function BattleGoddessNode:die()
    self._heroSpine:stopActionByTag(ACTION_DIE_TAG)
    self:stopActionByTag(ACTION_DIE_TAG)
    
    local dieAction = cc.Sequence:create(
        cc.FadeTo:create(DIE_ACTION_TIME, 0),
        nil
    )
    dieAction:setTag(ACTION_DIE_TAG)
    self._heroSpine:runAction(dieAction)
    
    local hideAction = cc.Sequence:create(
        cc.DelayTime:create(DIE_ACTION_TIME),
        cc.Hide:create(),
        nil
    )
    hideAction:setTag(ACTION_DIE_TAG)
    self:runAction(hideAction)
end

function BattleGoddessNode:fadeIn(time)
    self:setOpacity(0)
    self._heroSpine:setOpacity(0)
    self._heroInfoNode:setVisible(false)
    
    self:runAction(cc.FadeIn:create(time))
    self._heroSpine:runAction(cc.FadeIn:create(time))
end

function BattleGoddessNode:faceToRight()
    self._heroWrapper:setScaleX(-1)
    self._buffWrapper:setScaleX(-1)
    self._goddessEnergyBar:setScaleX(self._goddessEnergyBar:getScaleY())
    self._goddessEnergyBar:setPositionX(15)
    self._goddessEnergyFront:setScaleX(self._goddessEnergyFront:getScaleY())
    self._goddessEnergyFront:setPositionX(15)
    self._goddessEnergyLabel:setScaleX(self._goddessEnergyLabel:getScaleY())
end

function BattleGoddessNode:faceToLeft()
    self._heroWrapper:setScaleX(1)
    self._buffWrapper:setScaleX(1)
    self._goddessEnergyBar:setScaleX(-self._goddessEnergyBar:getScaleY())
    self._goddessEnergyBar:setPositionX(57 * self._goddessEnergyBar:getScaleY())
    self._goddessEnergyFront:setScaleX(-self._goddessEnergyFront:getScaleY())
    self._goddessEnergyFront:setPositionX(57 * self._goddessEnergyFront:getScaleY())
    self._goddessEnergyLabel:setScaleX(-self._goddessEnergyLabel:getScaleY())
end

function BattleGoddessNode:addBuffIcon(buffId, skillId)
    self._buffBarNode:addBuff(buffId, skillId)
end

function BattleGoddessNode:removeBuffIcon(buffId)
    self._buffBarNode:removeBuff(buffId)
end

function BattleGoddessNode:clearBuffIcons()
    self._buffBarNode:clearBuffs()
end

function BattleGoddessNode:addRoundBuffEffect(buffId, node)
    if self._roundBuffNodes[buffId] then return end

    self._roundBuffNodes[buffId] = node
    self._roundBuffEffectNode:addChild(node)
end

function BattleGoddessNode:removeRoundBuffEffect(buffId)
    local node = self._roundBuffNodes[buffId]
    if not node then return end

    self._roundBuffNodes[buffId] = nil
    self._roundBuffEffectNode:removeChild(node)
end

function BattleGoddessNode:setSpineShader(shader)
    self._heroSpine:setGLProgram(shader)
end

function BattleGoddessNode:setCustomScheduler(scheduler)
    self:setScheduler(scheduler)
    self._heroSpine:setScheduler(scheduler)
end

function BattleGoddessNode:setCustomActionManager(manager)
    self:setActionManager(manager)
    self._heroSpine:setActionManager(manager)
end

function BattleGoddessNode:getHeroType()
    return self._heroId
end

function BattleGoddessNode:getHeroId() return self._heroId end
function BattleGoddessNode:getFashionId() return self._fashionId end
function BattleGoddessNode:getStar() return self._star end
function BattleGoddessNode:getLevel() return self._heroInfoNode:getLevel() end
function BattleGoddessNode:getEnergy() return self._heroInfoNode:getEnergy() end
function BattleGoddessNode:getMaxEnergy() return self._heroInfoNode:getMaxEnergy() end

function BattleGoddessNode:setEnergy(energy)
    if energy < 0 then energy = 0 end
    
    self._heroInfoNode:setEnergy(energy)
    self:_updateGoddessEnergyBar()
    self:_updateEnergyLabel()
end

function BattleGoddessNode:setMaxEnergy(maxEnergy)
    self._heroInfoNode:setMaxEnergy(maxEnergy)
    self:_updateGoddessEnergyBar()
    self:_updateEnergyLabel()
end

function BattleGoddessNode:_createGoddessEnergyBar()
    local bgScale = PROC_BG_SCALE / GODDESS_SCALE

    local bg = cc.Sprite:createWithSpriteFrameName(PROC_BG_PATH)
    bg:setPositionY(GODDESS_ENERGY_Y_OFFSET)
    bg:setAnchorPoint(cc.p(0.5, 0.5))
    bg:setLocalZOrder(-1)
    bg:setScale(bgScale)
    
    self:addChild(bg)

    local name = ex.Tools:getLang(3000000 + self._heroId)
    self._goddessEnergyLabel = cc.Label:createWithTTF(name, FONT_DEFAULT_NAME_BOLD, 12)
    self._goddessEnergyLabel:setAnchorPoint(cc.p(0.5, 0.5))
    self._goddessEnergyLabel:setPosition(cc.p(145, 22))
    self._goddessEnergyLabel:enableOutline(FONT_BLACK_C4B, 1)
    bg:addChild(self._goddessEnergyLabel)

    return bg
end

function BattleGoddessNode:_createGoddessEnergyFront()
    local scale = PROC_BG_SCALE / GODDESS_SCALE

    local layer = cc.Sprite:create()
    layer:setPositionY(GODDESS_ENERGY_Y_OFFSET)
    layer:setScale(scale)
    self:addChild(layer)

    local procPosList = {
        cc.p(-13 * scale, 16 * scale),
        cc.p(-25 * scale, 3 * scale),
        cc.p(-13 * scale, -10 * scale),
    }

    self._proc1List = {}
    for i,v in ipairs(procPosList) do
        local proc = cc.Sprite:createWithSpriteFrameName(ENERGY_BAR_PROC_PATH)
        proc:setPosition(clone(v))
        layer:addChild(proc)

        table.insert(self._proc1List, proc)
    end

    self._proc2List = {}
    for i,v in ipairs(procPosList) do
        local proc = cc.Sprite:createWithSpriteFrameName(ENERGY_BAR_FRAME_PATH)
        proc:setPosition(clone(v))
        proc:setVisible(false)
        layer:addChild(proc)

        table.insert(self._proc2List, proc)
    end

    return layer
end
function BattleGoddessNode:_updateGoddessEnergyBar()
    local energy = self._heroInfoNode:getEnergy()

    for i,v in ipairs(self._proc2List) do
        if energy >= i then
            v:setVisible(true)
            self._proc1List[i]:setVisible(false)
        else
            v:setVisible(false)
            self._proc1List[i]:setVisible(true)
        end
    end
end

function BattleGoddessNode:_spineEventHandler(e)
    if e.type == AnimationEvent.Complete then
        if e.animation == BattleGoddessNode.Action.Attack
        or e.animation == BattleGoddessNode.Action.Skill
        or e.animation == BattleGoddessNode.Action.Skill2
        or e.animation == BattleGoddessNode.Action.Hit then
            self:actionStand()
        end
    end
end

function BattleGoddessNode:_updateEnergyLabel()
    if false then
        local energyStr = self:_genEnergyString()
        self._energyLabel:setString(energyStr)
    end
end

function BattleGoddessNode:_genEnergyString()
    local energy = self:getEnergy()
    local maxEnergy = self:getMaxEnergy()
    return energy .. ' / ' .. maxEnergy
end

return BattleGoddessNode
