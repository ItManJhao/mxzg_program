local BattleHeroNode = class('BattleHeroNode', cc.Node)

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

-- round buff
local ROUND_BUFF_BOTTOM_OFFSET = -50*NODE_SCALE

-- hero node
local HERO_SCALE = 0.715
local DIE_ACTION_TIME = 1.0

-- shadow
local SHADOW_RES_PATH = 'hero/hero-shadow.png'
local SHADOW_SCALE    = 0.7
local SHADOW_ZORDER   = -10

-- action tag
local ACTION_DIE_TAG = 50001

-- animation
local AnimationEvent = {
    End = 'end',
    Complete = 'complete'
}

--[[
    英雄的动作定义
]]
BattleHeroNode.Action = {
    Null   = 'null',
    Stand  = 'stand',
    Run    = 'run',
    Attack = 'attack',
    Skill  = 'attack2',
    Skill2 = 'attack3',
    Hit    = 'hit',
    Transform       = 'skill',
    Transform_Ex    = 'skill_l',
    Stand_Ex        = 'stand_l',
    Attack_Ex       = 'attack_l',
    Skill_Ex        = 'attack2_l',
    Skill2_Ex       = 'attack3_l',
    Hit_Ex          = 'hit_l',
}

--[[
    initData : 初始化的数据结构体
    {
        isGoddess  : <boolean> 是否是羁绊女神
        hero_id    : <int>     英雄的ID
        fashion_id : <int>     英雄的皮肤ID
        level      : <int>     英雄的等级
        star       : <int>     英雄的星级
        hp         : <int>     英雄血量
        max_hp     : <int>     英雄的最大血量
        energy     : <int>     英雄的能量值
        max_energy : <int>     英雄的最大能量值
        element    : <int>     英雄的元素标识
    }
]]
function BattleHeroNode:ctor(initData)
    self._heroId    = initData.hero_id
    self._fashionId = initData.fashion_id
    self._star      = initData.star
    self._level     = initData.level
    self._evolve    = initData.evolve
    self._kind      = initData.kind
    self._isTransform = false   -- 是否已经变身
    self.now_position  = initData.position
    self._isEnemy  = initData.isEnemy --是否是敌人
    self._changepos = nil           --是否已变换位置


    --[[
        英雄遭受buff記錄列表
    ]]
    self._vecBuff = {}

    --[[
        英雄buff文本提示缓冲队列
    ]]
    self._buffShowTipList = {}

    --[[
        英雄buff文本提示是否正在显示
    ]]
    self._buffShowTipShowing = false

    --[[
        是否显示buff飘字(默认为true)
    ]]
    self._isShowBuffTip = true

    self._proc1List = {}
    self._proc2List = {}

    self:setScale(NODE_SCALE)
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
    local name = nil
    if self._fashionId and self._fashionId ~= 0 then
        name = ex.Tools:getHeroSkinByStar(self._fashionId, self._star, self._evolve)
    else
        name = ex.Tools:getHeroSkinByStar(self._heroId, self._star, self._evolve)
    end
    print("hero spine type = ", name)
    self._heroSpine = HeroSpineFactory.create(name, HERO_SCALE)
    self._heroSpine:setPositionX(NODE_HALF_WIDTH)
    self._heroWrapper:addChild(self._heroSpine)

    -- 如果是boss类型，则放大他的大小，并拉高血条和状态栏位置
    local offset = 0
    if self._kind == 2 then
        self._heroSpine:setScale(3)
        offset = 300
    end

    self._heroSpine:registerSpineEventHandler(function(e)
        self:_spineEventHandler(e)
    end, sp.EventType.ANIMATION_COMPLETE)

    --[[
        英雄基本信息(血量、能量、元素标记)的节点
    ]]
    self._heroInfoNode = BattleHeroInfoNode.new(initData)
    self._mainNode:addChild(self._heroInfoNode)

    NodeUtils.adjustTop(self._heroInfoNode, offset)

    --[[
        buff状态栏的容器
    ]]
    self._buffBarNode = BattleBuffBarNode.new()
    self._mainNode:addChild(self._buffBarNode)
    NodeUtils.adjustTop(self._buffBarNode, BUFF_BAR_TOP_OFFSET + offset)

    --[[
        特效buff挂接点
    ]]
    self._buffWrapper = cc.Node:create()
    self._mainNode:addChild(self._buffWrapper)

    --[[
        回合性buff特效的挂接点
    ]]
    self._roundBuffEffectNodeTop = cc.Node:create()
    self._mainNode:addChild(self._roundBuffEffectNodeTop)
    NodeUtils.adjustTop(self._roundBuffEffectNodeTop, ROUND_BUFF_TOP_OFFSET)

    self._roundBuffEffectNodeBottom = cc.Node:create()
    self._mainNode:addChild(self._roundBuffEffectNodeBottom)
    NodeUtils.adjustBottom(self._roundBuffEffectNodeBottom, ROUND_BUFF_BOTTOM_OFFSET)

    --[[
        buff飘字挂接点
    ]]
    self._buffTipNode = cc.Node:create()
    self._mainNode:addChild(self._buffTipNode)
    NodeUtils.center(self._buffTipNode)

    if false then
        self._hpLabel = cc.Label:createWithTTF('', FONT_DEFAULT_NAME_BOLD, 20)
        self._hpLabel:enableOutline(FONT_BLACK_C4B, 2)
        self._mainNode:addChild(self._hpLabel)
        NodeUtils.adjustTop(self._hpLabel, 60)
        self:_updateHpLabel()

        self._energyLabel = cc.Label:createWithTTF('', FONT_DEFAULT_NAME_BOLD, 24)
        self._energyLabel:enableOutline(FONT_LIGHT_BLUE_C4B, 1)
        self._mainNode:addChild(self._energyLabel)
        NodeUtils.adjustTop(self._energyLabel, 80)
        self:_updateEnergyLabel()

        local heroNameLabel = cc.Label:createWithTTF(ex.Tools:getLang(self._heroId), FONT_DEFAULT_NAME_BOLD, 24)
        heroNameLabel:enableOutline(FONT_BLACK_C4B, 2)
        self._mainNode:addChild(heroNameLabel)
        NodeUtils.adjustTop(heroNameLabel, 110)
    end
    
    self:_initShadow()
end

function BattleHeroNode:actionStand()
    self._heroSpine:setAnimation(0, self._isTransform and BattleHeroNode.Action.Stand_Ex or BattleHeroNode.Action.Stand, true)
    self._currentAnimation = self._isTransform and BattleHeroNode.Action.Stand_Ex or BattleHeroNode.Action.Stand
end

function BattleHeroNode:actionRun()
    self._heroSpine:setAnimation(0, BattleHeroNode.Action.Run, true)
    self._currentAnimation = BattleHeroNode.Action.Run
end

function BattleHeroNode:actionAttack()
    self._heroSpine:setAnimation(0, self._isTransform and BattleHeroNode.Action.Attack_Ex or BattleHeroNode.Action.Attack, false)
    self._currentAnimation = self._isTransform and BattleHeroNode.Action.Attack_Ex or BattleHeroNode.Action.Attack

    self:cleanHeroShader()
end

function BattleHeroNode:actionSkill()
    self._heroSpine:setAnimation(0, self._isTransform and BattleHeroNode.Action.Skill_Ex or BattleHeroNode.Action.Skill, false)
    self._currentAnimation = self._isTransform and BattleHeroNode.Action.Skill_Ex or BattleHeroNode.Action.Skill

    self:cleanHeroShader()
end

function BattleHeroNode:actionSkill2()
    self._heroSpine:setAnimation(0, self._isTransform and BattleHeroNode.Action.Skill2_Ex or BattleHeroNode.Action.Skill2, false)
    self._currentAnimation = self._isTransform and BattleHeroNode.Action.Skill2_Ex or BattleHeroNode.Action.Skill2

    self:cleanHeroShader()
end

function BattleHeroNode:actionHit()
    self._heroSpine:setAnimation(0, self._isTransform and BattleHeroNode.Action.Hit_Ex or BattleHeroNode.Action.Hit, false)
    self._currentAnimation = self._isTransform and BattleHeroNode.Action.Hit_Ex or BattleHeroNode.Action.Hit
end

function BattleHeroNode:animationStop()
    self._heroSpine:setTimeScale(0.0)
end

function BattleHeroNode:animationResume()
    self._heroSpine:setTimeScale(1.0)
end

function BattleHeroNode:visible()
    self:setVisible(true)
    self._heroSpine:setVisible(true)
    self._heroSpine:setOpacity(255)
end

function BattleHeroNode:invisible()
    self:setVisible(false)
    self._heroSpine:setVisible(false)
    self._heroSpine:setOpacity(0)
end

function BattleHeroNode:revive()
    self._heroSpine:stopActionByTag(ACTION_DIE_TAG)
    self:stopActionByTag(ACTION_DIE_TAG)
    
    self:visible()
    self:actionStand()
end

function BattleHeroNode:transform(is_reverse)
    if is_reverse == nil then
        is_reverse = self._isTransform
    elseif self._isTransform ~= is_reverse then
        return
    end

    self._isTransform = not is_reverse

    if self._isTransform then
        self._heroSpine:setAnimation(0, BattleHeroNode.Action.Transform, false)
        self._currentAnimation = BattleHeroNode.Action.Transform
    else
        self._heroSpine:setAnimation(0, BattleHeroNode.Action.Transform_Ex, false)
        self._currentAnimation = BattleHeroNode.Action.Transform_Ex
    end
end

function BattleHeroNode:die()
    -- 清除buff的icon
    self._buffBarNode:clearBuffs()

    -- 清除buff的特效
    for _,node in pairs(self._roundBuffNodes) do
        self._roundBuffEffectNodeBottom:removeChild(node)
        self._roundBuffEffectNodeTop:removeChild(node)
    end
    self._roundBuffNodes = {}

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

function BattleHeroNode:fadeIn(time)
    self:setOpacity(0)
    self._heroSpine:setOpacity(0)
    self._heroInfoNode:setVisible(false)
    
    self:runAction(cc.FadeIn:create(time))
    self._heroSpine:runAction(cc.FadeIn:create(time))

    self._heroInfoNode:runAction(cc.Sequence:create(
        cc.DelayTime:create(time),
        cc.Show:create(),
        nil
    ))
end

function BattleHeroNode:faceToRight()
    self._heroWrapper:setScaleX(1)
    self._buffWrapper:setScaleX(1)
end

function BattleHeroNode:faceToLeft()
    self._heroWrapper:setScaleX(-1)
    self._buffWrapper:setScaleX(-1)
end

function BattleHeroNode:addBuffIcon(buffId, skillId)
    self._buffBarNode:addBuff(buffId, skillId)
end

function BattleHeroNode:removeBuffIcon(buffId)
    self._buffBarNode:removeBuff(buffId)
end

function BattleHeroNode:clearBuffIcons()
    self._buffBarNode:clearBuffs()
end

function BattleHeroNode:addRoundBuffEffect(buffId, buffType, node, is_in_bottom)
    if self._roundBuffNodes[buffId] then return end

    local is_have = false
    for _,v in pairs(self._roundBuffNodes) do
        if v.buff_type == buffType then
            is_have = true
            node = v
            break
        end
    end

    node.buff_type = buffType

    self._roundBuffNodes[buffId] = node

    if not is_have then
        if is_in_bottom == true then
            self._roundBuffEffectNodeBottom:addChild(node)
        else
            self._roundBuffEffectNodeTop:addChild(node)
        end
    end
end

function BattleHeroNode:removeRoundBuffEffect(buffId, buffType)
    local node = self._roundBuffNodes[buffId]
    if not node then return end

    self._roundBuffNodes[buffId] = nil

    local is_have = false
    for _,v in pairs(self._roundBuffNodes) do
        if v.buff_type == node.buff_type then
            is_have = true
            break
        end
    end

    if not is_have then
        self._roundBuffEffectNodeBottom:removeChild(node)
        self._roundBuffEffectNodeTop:removeChild(node)
    end
end

function BattleHeroNode:addHeroShader(buff_type, gl_shader)
    local glp = cpp.ShaderFactory:instance():getGLProgram(gl_shader)
    self:setSpineShader(glp)
    self:animationStop()

    table.insert(self._vecBuff, {buff_type = buff_type, eff_type = 1, gl_program = gl_shader})
end

function BattleHeroNode:removeHeroShader(buff_type)
    for i,v in ipairs(self._vecBuff) do
        if v.buff_type == buff_type then
            table.remove(self._vecBuff, i)
            break
        end
    end

    self:checkHeroShader()
end

function BattleHeroNode:cleanHeroShader()
    self._vecBuff = {}
    self:animationResume()
    self:recoverHeroShader()
end

function BattleHeroNode:resumeHeroAnimation()
    self:animationResume()
    self:actionStand()
end

function BattleHeroNode:recoverHeroShader()
    local glp = cpp.ShaderFactory:instance():getGLProgram(ShaderType.ST_POSITION_TEXTURE_DEFAULT)
    self:setSpineShader(glp)
end

function BattleHeroNode:checkHeroShader()
    local select_buff = nil
    for i,v in ipairs(self._vecBuff) do
        if v.eff_type == 1 then
            select_buff = v
            break
        end
    end

    if select_buff == nil then
        self:resumeHeroAnimation()
        self:recoverHeroShader()
    else
        local glp = cpp.ShaderFactory:instance():getGLProgram(select_buff.gl_program)
        self:setSpineShader(glp)
    end
end

function BattleHeroNode:setSpineShader(shader)
    self._heroSpine:setGLProgram(shader)
end

function BattleHeroNode:setCustomScheduler(scheduler)
    self:setScheduler(scheduler)
    self._heroSpine:setScheduler(scheduler)
end

function BattleHeroNode:setCustomActionManager(manager)
    self:setActionManager(manager)
    self._heroSpine:setActionManager(manager)
end

function BattleHeroNode:showInfoNode()
    self._heroInfoNode:setVisible(true)
end

function BattleHeroNode:hideInfoNode()
    self._heroInfoNode:setVisible(false)
end

function BattleHeroNode:getHeroType()
    if self._fashionId ~= nil and self._fashionId ~= 0 then return self._fashionId end
    return self._heroId
end

function BattleHeroNode:getHeroId() return self._heroId end
function BattleHeroNode:getFashionId() return self._fashionId end
function BattleHeroNode:getStar() return self._star end
function BattleHeroNode:getLevel() return self._heroInfoNode:getLevel() end
function BattleHeroNode:getEvolve() return self._evolve end
function BattleHeroNode:getHp() return self._heroInfoNode:getHp() end
function BattleHeroNode:getMaxHp() return self._heroInfoNode:getMaxHp() end
function BattleHeroNode:getEnergy() return self._heroInfoNode:getEnergy() end
function BattleHeroNode:getMaxEnergy() return self._heroInfoNode:getMaxEnergy() end
function BattleHeroNode:getElement() return self._heroInfoNode:getElement() end
function BattleHeroNode:getNowPosition() return self.now_position end
function BattleHeroNode:getIsEnemy() return self._isEnemy end
function BattleHeroNode:getChangePos() return self._changepos end

function BattleHeroNode:setHp(hp)
    if hp < 0 then hp = 0 end
    if hp > self._heroInfoNode:getMaxHp() then hp = self._heroInfoNode:getMaxHp() end
    
    self._heroInfoNode:setHp(hp)
    self:_updateHpLabel()
end

function BattleHeroNode:setMaxHp(maxHp)
    self._heroInfoNode:setMaxHp(maxHp)
    self:_updateHpLabel()
end

function BattleHeroNode:setEnergy(energy)
    if energy < 0 then energy = 0 end
    
    self._heroInfoNode:setEnergy(energy)
    self:_updateEnergyLabel()
end

function BattleHeroNode:setMaxEnergy(maxEnergy)
    self._heroInfoNode:setMaxEnergy(maxEnergy)
    self:_updateEnergyLabel()
end

--斗转星移
function BattleHeroNode:setHeroPosition(pos,bfSize)  
    self:stopActionByTag(6666)
    local indexPosition = BattleUtils.getHeroPosition(pos, bfSize)
    local heroPosition = clone(indexPosition)
    heroPosition.x = bfSize.width - heroPosition.x
    if self:getIsEnemy() then
        heroPosition.x = bfSize.width - heroPosition.x
    end
    self._changepos = heroPosition
    local action = cc.MoveTo:create(0.2, heroPosition)
    action:setTag(6666)
    self:runAction(action)
end

function BattleHeroNode:palyParryEffect()
    self:removeChildByTag(6667)
    local pos_x = NODE_HALF_WIDTH + 50
    local pos_y = 80
    local effect_node = cc.Sprite:create()
    effect_node:setPosition(pos_x,pos_y)
    effect_node:setTag(6667)
    if not self:getIsEnemy() then
        effect_node:setScaleX(-1)
        effect_node:setPosition(NODE_HALF_WIDTH - 50,pos_y)
    end
    self:addChild(effect_node)
    local act_anim = ex.EffectFactory:createAnimate("skill-effect/duola-skill-effect-parry.plist", 'duola-skill-effect-parry/%d.png', 0.025)
    effect_node:runAction(act_anim)
end

--欧亚三技能分身特殊复活
function BattleHeroNode:setSeparationRevive(pos,bfSize)
    local indexPosition = BattleUtils.getHeroPosition(pos, bfSize)
    local heroPosition = clone(indexPosition)
    heroPosition.x = bfSize.width - heroPosition.x
    if self:getIsEnemy() then
        heroPosition.x = bfSize.width - heroPosition.x
    end
    self._changepos = heroPosition
    self:setPosition(heroPosition)
    self:fadeIn(0.5)
    self:revive()
end

--[[
    是否显示buff飘字
]]
function BattleHeroNode:setIsShowBuffTip(visible)
    self._isShowBuffTip = visible
end

function BattleHeroNode:addBuffTip(buff_name_lang, buff_name_color)
    if self._isShowBuffTip ~= true then
        return
    end

    if buff_name_lang <= 0 then return end
    if buff_name_color ~= nil then 
        buff_name_color = cc.c3b(buff_name_color.R, buff_name_color.G, buff_name_color.B)
    else
        buff_name_color = cc.c3b(255, 253, 178)
    end

    table.insert(self._buffShowTipList, {lang = buff_name_lang, color = buff_name_color})
    -- table.insert(self._buffShowTipList, {lang = config.buff_name_lang, color = buff_name_color})
    -- table.insert(self._buffShowTipList, {lang = config.buff_name_lang, color = buff_name_color})

    if self._buffShowTipShowing == false then
        self._buffShowTipShowing = false
        self:_nextBuffTip()
    end
end

function BattleHeroNode:_initShadow()
    local sp = cc.Sprite:createWithSpriteFrameName(SHADOW_RES_PATH)
    sp:setScale(SHADOW_SCALE)
    self._mainNode:addChild(sp, SHADOW_ZORDER)
end

function BattleHeroNode:_spineEventHandler(e)
    if e.type == AnimationEvent.Complete then
        if e.animation == BattleHeroNode.Action.Attack
        or e.animation == BattleHeroNode.Action.Skill
        or e.animation == BattleHeroNode.Action.Skill2
        or e.animation == BattleHeroNode.Action.Hit
        or e.animation == BattleHeroNode.Action.Transform
        or e.animation == BattleHeroNode.Action.Transform_Ex
        or e.animation == BattleHeroNode.Action.Attack_Ex
        or e.animation == BattleHeroNode.Action.Skill_Ex
        or e.animation == BattleHeroNode.Action.Skill2_Ex
        or e.animation == BattleHeroNode.Action.Hit_Ex then
            self:actionStand()
        end
    end
end

function BattleHeroNode:_updateHpLabel()
    if false then
        local hpStr = self:_genHpString()
        self._hpLabel:setString(hpStr)
    end
end

function BattleHeroNode:_updateEnergyLabel()
    if false then
        local energyStr = self:_genEnergyString()
        self._energyLabel:setString(energyStr)
    end
end

function BattleHeroNode:_genHpString()
    local hp = self:getHp()
    local maxHp = self:getMaxHp()
    return hp .. ' / ' .. maxHp
end

function BattleHeroNode:_genEnergyString()
    local energy = self:getEnergy()
    local maxEnergy = self:getMaxEnergy()
    return energy .. ' / ' .. maxEnergy
end

function BattleHeroNode:_nextBuffTip()
    if self._buffShowTipShowing == true or table.nums(self._buffShowTipList) <= 0 then
        return
    end

    self._buffShowTipShowing = true

    local data = self._buffShowTipList[1]

    local o_scale = 0.6
    local lbl_text = cc.Label:createWithTTF(ex.Tools:getLang(data.lang), FONT_DEFAULT_NAME_BOLD, 48)
    lbl_text:setAnchorPoint(cc.p(0.5, 0.5))
    lbl_text:setColor(data.color)
    lbl_text:setScale(o_scale * 0.5)
    lbl_text:setOpacity(0)
    -- lbl_text:enableOutline(ex.c3b.BLACK, 2)
    lbl_text:setPosition(0, 0)
    self._buffTipNode:addChild(lbl_text)

    local bg = ccui.Scale9Sprite:createWithSpriteFrameName("hero/spr-bg-1.png")
    :setCapInsets(cc.rect(35, 10, 1, 1))
    :setIgnoreAnchorPointForPosition(false)
    bg:setAnchorPoint(cc.p(0.5, 0.5))
    bg:setOpacity(0)
    bg:setPosition(lbl_text:getContentSize().width / 2, lbl_text:getContentSize().height / 2)
    bg:setContentSize(cc.size(300, 60))
    lbl_text:addChild(bg, -1)

    table.remove(self._buffShowTipList, 1)

    local time_total = tonumber(ex.Tools:getSysCfg("hero_buff_tip_last")) or 1
    local time_stage_1 = 0.15 * time_total
    local time_stage_2 = 0.85 * time_total
    lbl_text:runAction(cc.Sequence:create(cc.ScaleTo:create(time_stage_1, 1.5 * o_scale), 
                                          cc.CallFunc:create(function()
                                            self._buffShowTipShowing = false
                                            self:_nextBuffTip()
                                          end),
                                          cc.ScaleTo:create(time_stage_2, 1 * o_scale), 
                                          cc.RemoveSelf:create(), 
                                          nil))
    -- lbl_text:runAction(cc.Sequence:create(cc.EaseExponentialOut:create(cc.MoveBy:create(time_stage_1, cc.p(0, 60))), 
    --                                       cc.MoveBy:create(time_stage_2, cc.p(0, 160)), 
    --                                       nil))
    lbl_text:runAction(cc.Sequence:create(cc.MoveBy:create(time_stage_1, cc.p(0, 60)), 
                                          cc.MoveBy:create(time_stage_2, cc.p(0, 120)), 
                                          nil))
    lbl_text:runAction(cc.Sequence:create(cc.FadeIn:create(time_stage_1), 
                                          cc.DelayTime:create(time_stage_2 / 3), 
                                          cc.FadeOut:create(time_stage_2 / 3 * 2), 
                                          nil))
    bg:runAction(cc.Sequence:create(cc.FadeIn:create(time_stage_1), 
                                    cc.DelayTime:create(time_stage_2 / 3), 
                                    cc.FadeOut:create(time_stage_2 / 3 * 2), 
                                    nil))
end

return BattleHeroNode
