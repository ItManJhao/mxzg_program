local BattleDragonNode = class('BattleDragonNode', cc.Node)

local LOCK_ICON_BG = "hero/dragon/lock-icon-bg.png"
local ICON_BG      = "hero/dragon/icon-bg.png"
local ICON_SHADOW  = "hero/dragon/icon-shadow.png"
local BG           = "hero/dragon/bg.png"

local SKILL_ICON_PATH_TPL = 'skill-icon/%d.png'

local MAX_SKILL_NUM = 4

local NODE_ANCHOR = cc.p(0.5, 0)
local NODE_SIZE = cc.size(140, 120)
local NODE_SCALE = 0.65
local NODE_HALF_WIDTH = 0.5 * NODE_SIZE.width

local ICON_SCALE = 0.7

local BG_OFFSET_Y   = -3
local ICON_OFFSET_X = 22.5
local ICON_GAP_X    = 45.5

-- animation
local AnimationEvent = {
    End = 'end',
    Complete = 'complete'
}

--[[
    女神的动作定义
]]
BattleDragonNode.Action = {
    Null   = 'null',
    Stand  = 'stand',
    Attack = 'attack'
}

--[[
    initData:
    {
        hero_id     : <int>     圣龙的ID
        level       : <int>     圣龙的等级
        skillIds    : [<int>]   圣龙的技能ID列表
        flipped     : <bool>    是否翻转
    }
]]
function BattleDragonNode:ctor(initData)
    self._heroId        = initData.hero_id
    self._dragon_idx    = initData.dragon_idx
    self._skillIds      = initData.skillIds
    self._flipped       = initData.flipped

    -- 获取神龙类型，并获得技能解锁个数
    self._dragonType = cfg.dragonlevel.dragonlevel[self._dragon_idx].relic_unlock
    for i=1,self._dragonType do
        if self._skillIds[i] == nil then
            self._skillIds[i] = {
                skill_id = 0,
                cd = 0
            }
        end
    end

    self._mainNode = cc.Node:create()
    self._mainNode:setPositionX(NODE_HALF_WIDTH)
    self._mainNode:setContentSize(cc.size(0, NODE_SIZE.height))
    self:addChild(self._mainNode)

    self._heroWrapper = cc.Node:create()
    self._heroWrapper:setContentSize(NODE_SIZE)
    self._heroWrapper:setAnchorPoint(NODE_ANCHOR)
    self._mainNode:addChild(self._heroWrapper)

    self:_initBg()
    self:_initIcons()
end

function BattleDragonNode:actionStand()
    
end

function BattleDragonNode:actionRun()
    
end

function BattleDragonNode:actionAttack()
    
end

function BattleDragonNode:actionSkill()
    
end

function BattleDragonNode:actionSkill2()
    
end

function BattleDragonNode:actionHit()
    
end

function BattleDragonNode:visible()
    self:setVisible(true)
end

function BattleDragonNode:invisible()
    self:setVisible(false)
end

function BattleDragonNode:fadeIn(time)
    self:setOpacity(0)
    
    self:runAction(cc.FadeIn:create(time))
end

function BattleDragonNode:addBuffIcon(buffId, skillId)
    
end

function BattleDragonNode:removeBuffIcon(buffId)
    
end

function BattleDragonNode:clearBuffIcons()
    
end

function BattleDragonNode:setSpineShader(shader)
    
end

function BattleDragonNode:setCustomScheduler(scheduler)
    self:setScheduler(scheduler)
end

function BattleDragonNode:setCustomActionManager(manager)
    self:setActionManager(manager)
end

function BattleDragonNode:getHeroId() return self._heroId end
function BattleDragonNode:getDragonType() return self._dragonType end

-- 设置对应技能的cd
function BattleDragonNode:setSkillCd(cur_round, skill_id, next_round)
    for _,v in pairs(self._skillIds) do
        if v.skill_id == skill_id then
            v.cd = next_round

            if self._cdNodeList[v.skill_id] ~= nil then
                self._cdNodeList[v.skill_id]:setVisible(v.cd > cur_round)
                self._cdNodeList[v.skill_id].lbl_cd:setString(v.cd - cur_round)
            end

            break
        end
    end
end

-- 设置对应技能的cd，自减1
function BattleDragonNode:setSkillCdNextRound(cur_round)
    for _,v in pairs(self._skillIds) do
        if self._cdNodeList[v.skill_id] ~= nil then
            self._cdNodeList[v.skill_id]:setVisible(v.cd > cur_round)
            self._cdNodeList[v.skill_id].lbl_cd:setString(v.cd - cur_round)
        end
    end
end

function BattleDragonNode:_initBg()
    local bg = cc.Sprite:createWithSpriteFrameName(BG)
    bg:setAnchorPoint(cc.p(0, 0.5))
    bg:setPosition(0, BG_OFFSET_Y)
    self:addChild(bg)

    if self._flipped then
        bg:setAnchorPoint(cc.p(1, 0.5))
        bg:setFlippedX(true)
    end
end

function BattleDragonNode:_initIcons()
    self._cdNodeList = {}

    local start_x = ICON_OFFSET_X
    if self._flipped then
        start_x = start_x - 4 * ICON_GAP_X
    end

    for i = 1, MAX_SKILL_NUM do
        local skillId = self._skillIds[i]
        local x = start_x + (i-1) * ICON_GAP_X

        local iconBg = nil
        
        if skillId == nil then
            iconBg = cc.Sprite:createWithSpriteFrameName(LOCK_ICON_BG)
        elseif skillId.skill_id <= 0 then
            iconBg = cc.Sprite:createWithSpriteFrameName(ICON_BG)
        else
            iconBg = cc.Sprite:createWithSpriteFrameName(ICON_BG)

            local path = string.format(SKILL_ICON_PATH_TPL, skillId.skill_id)
            local iconSprite = cc.Sprite:createWithSpriteFrameName(path)

            iconSprite:setScale(ICON_SCALE)
            iconSprite:setPositionX(x)
            iconSprite:setLocalZOrder(1)
            
            self:addChild(iconSprite)

            -- 添加cd节点
            local node_cd = cc.Node:create()
            node_cd:setPosition(iconSprite:getPosition())
            self:addChild(node_cd, 10)

            node_cd:setVisible(skillId.cd > 0)

            self._cdNodeList[skillId.skill_id] = node_cd

            node_cd.spr_shadow = cc.Sprite:createWithSpriteFrameName(ICON_SHADOW)
            node_cd:addChild(node_cd.spr_shadow, 10)

            node_cd.lbl_cd = cc.Label:createWithTTF(tostring(skillId.cd), FONT_DEFAULT_NAME_BOLD, 56)
            node_cd.lbl_cd:setScale(0.5)
            node_cd.lbl_cd:setColor(cc.c3b(255,223,178))
            node_cd.lbl_cd:enableOutline(cc.c3b(64,12,2), 2)
            node_cd:addChild(node_cd.lbl_cd, 20)
        end
        
        iconBg:setPositionX(x)
        self:addChild(iconBg)
    end
end

function BattleDragonNode:_spineEventHandler(e)
    if e.type == AnimationEvent.Complete then
        if e.animation == BattleDragonNode.Action.Attack
        or e.animation == BattleDragonNode.Action.Skill
        or e.animation == BattleDragonNode.Action.Skill2
        or e.animation == BattleDragonNode.Action.Hit then
            self:actionStand()
        end
    end
end

return BattleDragonNode
