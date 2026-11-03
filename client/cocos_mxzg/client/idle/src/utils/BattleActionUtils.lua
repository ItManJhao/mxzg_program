local Promise = require('src.model.Promise')
local BattleHeroData = require('src.entity.battle.BattleHeroData')
local BattleBuffInfo = require('src.entity.battle.BattleBuffInfo')
local BattleActionContext = require('src.context.BattleActionContext')

--[[
    战斗中的动作类型对应的功能函数。

    注意 : 所有的功能函数，都以<BattleActionContext>对象作为参数
          并且所有的函数在任何情况在都要在某个时机调用ctx:getCompletedHandler()返回的函数
    
    关于播放速度 : 因为战斗可以调整速度，所以在实现时，应该对速度作调整，
    **在英雄显示对象中，可以通过`getTimeScale`获取到速度缩放值**，务
    必兼容速度调整，否则将会出现不可预料的错误
]]
BattleActionUtils = {}

--[[
    特殊定义的buff类型
]]
BattleActionUtils.ActionBuffType = {
    Resurrection = 150,
    ActionResurrection = 154,
    AssistInLine = 1501,        -- 助阵
    ForcedDeath = 658,          -- 抵抗致命
}

--[[
    buff函数列表
]]
BattleActionUtils._actions = {}

--[[
    配置表里面配置的delay是帧的意思，所以需要用60去除才能算出秒
]]
local FRAME_SECOND = 60

--[[
    熏晕特效文件路径的模板
]]
local ROUND_EFFECT_PATH_TPL = 'hero-skill/effect-1-%d.png'

--[[
    沉默特效文件路径模板
]]
local SLIENT_EFFECT_PATH_TPL = 'skill-effect-slient/%d.png'

--[[
    护盾特效文件路径模板
]]
local SHIELD_EFFECT_PATH_TPL = 'skill-effect-shield/%d.png'

--[[
    格挡盾特效文件路径模板
]]
local PARRY_EFFECT_PATH_TPL = 'skill-effect-parry/%d.png'

--[[
    契约特效文件路径模板
]]
local CONTRACT_EFFECT_PATH_TPL = 'skill-effect-contract/%d.png'

--[[
    泰坦威尔顿4技能护盾特效文件路径模板
]]
local TITAN_CONTRACT_EFFECT_PATH_TPL = 'titan-skill-effect-contract/%d.png'

--[[
   朵拉熊格挡特效文件路径模板
]]
local TITAN_CONTRACT_EFFECT_PATH_TPL = 'duola-skill-effect-parry/%d.png'


--[[
    音效文件路径的模板
]]
local SKILL_AUDIO_PATH_TPL = 'music/%s.mp3'

--[[
    x方向的单位向量，方便一些计算
]]
local X_VECTOR = cc.p(1, 0)

--[[
    特效的Y轴固定偏移量
]]
local EFFECT_Y_FIXED_OFFSET = -0.07

-- shader tags
local FROZEN_SHADER_TAG  = 4
local PETRIFY_SHADER_TAG = 5

-- shake
local SHAKE_ENABLED    = 1
local SHAKE_ACTION_TAG = 100030
local SHAKE_RANGE      = 5
local SHAKE_TIMES      = 5
local SHAKE_SLOW_DOWN  = 1

-- action
local MOVE_TIME       = 0.1
local ATTACK_TIME     = 0.0
local ACTION_TIME     = 0.0
local ATTACK_DELAY    = 0.0
local BACK_TIME       = 0.0
local ACTION_DURATION = 0.05

-- dimly
local DIMLY_ENABLED    = 1
local DIMLY_NODE_TAG   = 100040
local DIMLY_ACTION_TAG = 100040
local DIMLY_TIME_IN    = 0.5
local DIMLY_TIME_OUT   = 0.5
local DIMLY_TIME_DELAY = 1.0
local DIMLY_EX_SIZE = cc.size(50, 50)

--[[
    入口函数，通过buff类型和相关的context对象选择执行buff的函数
]]
BattleActionUtils.playBuff = function(ctx)
    local ctrlCtx = ctx:getControlContext()
    local effect = ctx:getEffect()
    local buff = effect:getBuff()
    local buffType = buff.type

    local delayTime = 0
    if ctx:isDelay() then delayTime = buff.delay / FRAME_SECOND end

    local action = cc.Sequence:create(
        cc.DelayTime:create(delayTime),
        cc.CallFunc:create(function()
            if buff.shake == SHAKE_ENABLED then
                BattleActionUtils._playShake(ctx:getLayerContext():getLayer())
            end
        end),
        cc.CallFunc:create(function()
            if buff.dimly == DIMLY_ENABLED and not ctrlCtx:isBackground() then
                BattleActionUtils._playDimly(ctx:getLayerContext():getFullEffectLayer(), buff.ani_base)
            end
        end),
        cc.CallFunc:create(function()
            -- 如果遇到没有实现的动作类型，那么直接跳过，并且当做已完成
            -- (这样做不利于测试，会隐藏一些既有的错误)
            local actionHandler = BattleActionUtils._actions[buffType]
            if actionHandler then
                actionHandler(ctx)
            else
                ctx:getCompletedHandler()()
            end
        end),
        cc.CallFunc:create(function()
            for k,v in ipairs(effect:getBuffs()) do
                local subBuff = v:getBuff()
                
                if subBuff.buff_icon ~= "" and subBuff.buff_icon ~= 0 then
                    if v:getExpiredRound() == -1 then
                        BattleActionUtils.clearBuff(v, ctx:getControlContext():getEventHandler())
                    elseif v:getHit() ~= BattleBuffInfo.HitType.Miss and v:getExpiredRound() ~= 0 then
                        local heroData = v:getHeroData()
                        heroData:getBattleNode():addBuffIcon(subBuff.idx, subBuff.buff_icon)
                    end
                end
            end
        end),
        cc.CallFunc:create(function()
            if type(buff.sound) ~= 'table' or ctrlCtx:isBackground() then return end

            for i,v in ipairs(buff.sound) do
                local audioPath = string.format(SKILL_AUDIO_PATH_TPL, v)
                ex.AudioManager:playEffect(audioPath)
            end
        end),
        cc.CallFunc:create(function()
            -- 做飘字处理
            local buff = ctx:getEffect():getBuff()
            local buffs = ctx:getEffect():getBuffs()
            for k,v in ipairs(buffs) do
                local heroNode = v:getHeroData():getBattleNode()
                if v:getExpiredRound() >= 0 and heroNode.addBuffTip and buff.buff_name_lang ~= nil and buff.buff_name_lang > 0 then
                    heroNode:addBuffTip(buff.buff_name_lang, buff.buff_name_color)
                end
            end
        end),
        cc.CallFunc:create(function()
            -- 朵拉 熊格挡动画
            local buffs = ctx:getEffect():getBuffs()
            for _,v in ipairs(buffs) do
                if v._resistances ~= nil then
                    for _,k in ipairs(v._resistances) do
                        if k == 1 then
                            v:getHeroData():getBattleNode():palyParryEffect()
                        end   
                    end
                end  
            end
        end),
        nil
    )

    ctx:getActionHeroData():getBattleNode():runAction(action)
end

--[[
    清除一些附身buff
]]
BattleActionUtils.clearBuff = function(buffInfo, eventHandler)
    local buff = buffInfo:getBuff()
    local buffType = buff.type
    local heroData = buffInfo:getHeroData()

    if heroData:getBattleNode().removeBuffIcon then
        heroData:getBattleNode():removeBuffIcon(buff.idx)
    end

    print('remove buff: ' .. buffInfo:getUnitId() .. ' - ' .. buff.idx)
    heroData:getBattleNode():removeRoundBuffEffect(buffInfo:getUnitId(), buff.type)
    
    local handler = BattleActionUtils._clearHandlers[buffType]
    if handler == nil then return end

    handler(buffInfo, eventHandler)
end

--[[
    动作类型1 : 空动作
]]
BattleActionUtils._actions[1] = function(ctx)
    local heroData = ctx:getActionHeroData()
    local effect = ctx:getEffect()
    local buff = effect:getBuff()

    local isMove = false
    local movePosition = heroData:getPosition()
    
    if #effect:getBuffs() > 0 then
        local targetHeroData = effect:getBuffs()[1]:getHeroData()
    
        isMove = (type(buff.ani_base) == 'table' and buff.ani_base.move_time)
        if isMove then
            movePosition = BattleActionUtils._calcBeattackHeroPosition(targetHeroData)
        end
    end

    BattleActionUtils._attackingAction(
        ctx:getLayerContext(),
        ctx:getActionHeroData(),
        buff,
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler(),
        {
            isMove       = isMove,
            movePosition = movePosition,
            playAttack = false,
        }
    )
end

--[[
    动作类型2 : 近身攻击
]]
BattleActionUtils._actions[2] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()
    local targetHeroData = effect:getBuffs()[1]:getHeroData()

    BattleActionUtils._attackingAction(
        ctx:getLayerContext(),
        ctx:getActionHeroData(),
        buff,
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler(),
        {
            isMove       = true,
            movePosition = BattleActionUtils._calcBeattackHeroPosition(targetHeroData)
        }
    )
end

--[[
    动作类型3 : 远程攻击
]]
BattleActionUtils._actions[3] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()
    local buffs = effect:getBuffs()

    local attackTime = buff.ani_base.attack_time or ATTACK_TIME

    for k,v in ipairs(buffs) do
        local targetHeroData = v:getHeroData()
        local action = cc.Sequence:create(
            cc.DelayTime:create(attackTime),
            cc.CallFunc:create(function()
                BattleActionUtils._appendBuffEffect(ctx:getLayerContext(), targetHeroData, buff, ctx:getEnabledPlaySpeed())
            end),
            nil
        )
        targetHeroData:getBattleNode():runAction(action)
    end

    BattleActionUtils._attackingAction(
        ctx:getLayerContext(),
        ctx:getActionHeroData(),
        buff,
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler()
    )
end

--[[
    动作类型4 : 原地动画
]]
BattleActionUtils._actions[4] = function(ctx)
    BattleActionUtils._attackingAction(
        ctx:getLayerContext(),
        ctx:getActionHeroData(),
        ctx:getEffect():getBuff(),
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler()
    )
end

--[[
    动作类型5 : 投掷动画
]]
BattleActionUtils._actions[5] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()
    local buffs = effect:getBuffs()

    for k,v in ipairs(buffs) do
        local targetHeroData = v:getHeroData()
        BattleActionUtils._rangeAttackingAction(ctx:getLayerContext(), ctx:getActionHeroData(), targetHeroData, buff, ctx:getEnabledPlaySpeed())
    end

    BattleActionUtils._attackingAction(
        ctx:getLayerContext(),
        ctx:getActionHeroData(),
        buff,
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler()
    )
end

--[[
    动作类型6 : 在英雄位置播放特效
]]
BattleActionUtils._actions[6] = function(ctx)
    BattleActionUtils._playBuffOnHero(
        ctx:getLayerContext(),
        ctx:getActionHeroData(),
        ctx:getEffect():getBuff(),
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler()
    )
end

--[[
    动作类型7 : 在目标位置播放特效
]]
BattleActionUtils._actions[7] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()
    local buffs = effect:getBuffs()

    local promises = {}
    for k,v in ipairs(buffs) do
        local targetHeroData = v:getHeroData()
        local promise = Promise.new(function(resolve)
            BattleActionUtils._playBuffOnHero(
                ctx:getLayerContext(),
                targetHeroData,
                buff,
                ctx:getEnabledPlaySpeed(),
                resolve
            )
        end)
        table.insert(promises, promise)
    end

    Promise.all(promises):next(function()
        ctx:getCompletedHandler()()
    end)
end

--[[
    动作类型8 : 移动到地图任意位置停留一段时间并执行攻击动作
]]
BattleActionUtils._actions[8] = function(ctx)
    local actionHeroData = ctx:getActionHeroData()
    local buff = ctx:getEffect():getBuff()

    local layer = ctx:getLayerContext():getLayer()
    local size = layer:getContentSize()

    local pos = cc.p(0, 0)

    if buff.ani_base.offset_x then
        local offsetX = tonumber(buff.ani_base.offset_x)
        if actionHeroData:getTeam() ~= BattleHeroData.TeamType.Player then
            offsetX = 1.0 - offsetX
        end
        pos.x = offsetX * size.width
    end
    
    if buff.ani_base.offset_y then
        local offsetY = tonumber(buff.ani_base.offset_y)
        pos.y = offsetY * size.height
    end

    BattleActionUtils._attackingAction(
        ctx:getLayerContext(),
        actionHeroData,
        buff,
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler(),
        {
            isMove       = true,
            movePosition = pos
        }
    )
end

--[[
    动作类型9 : 在指定位置释放特效
]]
BattleActionUtils._actions[9] = function(ctx)
    BattleActionUtils._playBuffOnPosition(
        ctx:getLayerContext(),
        ctx:getActionHeroData(),
        ctx:getEffect():getBuff(),
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler()
    )
end

--[[
    动作类型10 : 投掷到指定位置
]]
BattleActionUtils._actions[10] = function(ctx)
    local layer = ctx:getLayerContext():getLayer()
    local heroData = ctx:getActionHeroData()
    local heroNode = heroData:getBattleNode()

    local effect = ctx:getEffect()
    local buff = effect:getBuff()

    local attackTime = buff.ani_base.attack_time or ATTACK_TIME
    local actionTime = buff.ani_base.action_time or ACTION_TIME
    local duration   = buff.ani_base.duration or ACTION_DURATION
    
    local action = cc.Sequence:create(
        cc.CallFunc:create(function()
            if buff.ani_base.action == 'skill' then
                heroNode:actionSkill()
            elseif buff.ani_base.action == 'skill2' then
                heroNode:actionSkill2()
            else
                heroNode:actionAttack()
            end
        end),
        cc.DelayTime:create(attackTime),
        cc.CallFunc:create(function()
            local buffSprite = BuffFactory.create(buff.type, buff.ani_base, ctx:getEnabledPlaySpeed())
            local heroSize = heroNode:getContentSize()
            
            if buffSprite then
                local frameCount = BuffFactory.getAnimateCount(buff.ani_base)

                local actionCenterPos = cc.p(
                    0,
                    heroNode:getScale() * heroSize.height / 2
                )
                
                local startPosition = cc.pAdd(heroData:getIndexPosition(), actionCenterPos)
                buffSprite:setPosition(startPosition)

                local targetPosition = BattleActionUtils._calcOffsetPosition(layer, buff.ani_base)
                
                local targetVec = cc.pSub(targetPosition, startPosition)
                local rotation = Maths.radiansToDegrees(cc.pGetAngle(targetVec, X_VECTOR))
                buffSprite:setRotation(rotation)
                
                local action = cc.Sequence:create(
                    cc.MoveTo:create(frameCount*duration, targetPosition),
                    cc.RemoveSelf:create(),
                    nil
                )
                buffSprite:runAction(action)
                BattleActionUtils._appendEffectWithTeam(heroData:getTeam(), ctx:getLayerContext(), buffSprite)
            end
        end),
        cc.DelayTime:create(actionTime),
        cc.CallFunc:create(ctx:getCompletedHandler()),
        nil
    )
    
    heroNode:runAction(action)
end

--[[
    动作类型11 : 移动到目标前执行动画
]]
BattleActionUtils._actions[11] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()
    local targetHeroData = effect:getBuffs()[1]:getHeroData()

    BattleActionUtils._attackingAction(
        ctx:getLayerContext(),
        ctx:getActionHeroData(),
        buff,
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler(),
        {
            isMove       = true,
            movePosition = BattleActionUtils._calcBeattackHeroPosition(targetHeroData)
        }
    )
end

--[[
    动作类型13 : 變身動作
]]
BattleActionUtils._actions[13] = function(ctx)
    BattleActionUtils._attackingAction(
        ctx:getLayerContext(),
        ctx:getActionHeroData(),
        ctx:getEffect():getBuff(),
        ctx:getEnabledPlaySpeed(),
        ctx:getCompletedHandler()
    )
end



---------- 伤害型打击系列 ----------

--[[
    打击产生伤害系列的通用函数
]]
local hitHarmUtilsHandler = function(ctx)
    BattleActionUtils._hitBuff(
        ctx:getActionHeroData(),
        ctx:getEffect():getBuff(),
        ctx:getHitHandler(),
        ctx:getCompletedHandler(),
        {
            hitType = BattleActionContext.HitType.Harm
        }
    )
end

--[[
    动作类型10X : 造成一定的伤害
]]
BattleActionUtils._actions[100] = hitHarmUtilsHandler
BattleActionUtils._actions[101] = hitHarmUtilsHandler
BattleActionUtils._actions[102] = hitHarmUtilsHandler
BattleActionUtils._actions[103] = hitHarmUtilsHandler
BattleActionUtils._actions[104] = hitHarmUtilsHandler
BattleActionUtils._actions[105] = hitHarmUtilsHandler
BattleActionUtils._actions[106] = hitHarmUtilsHandler
BattleActionUtils._actions[107] = hitHarmUtilsHandler
BattleActionUtils._actions[108] = hitHarmUtilsHandler
BattleActionUtils._actions[109] = hitHarmUtilsHandler
BattleActionUtils._actions[110] = hitHarmUtilsHandler
BattleActionUtils._actions[111] = hitHarmUtilsHandler
BattleActionUtils._actions[112] = hitHarmUtilsHandler
BattleActionUtils._actions[113] = hitHarmUtilsHandler
BattleActionUtils._actions[114] = hitHarmUtilsHandler
BattleActionUtils._actions[143] = hitHarmUtilsHandler
BattleActionUtils._actions[148] = hitHarmUtilsHandler



---------- 治愈型打击系列 ----------

--[[
    打击产生治愈系列的通用函数
]]
local hitHealUtilsHandler = function(ctx)
    BattleActionUtils._hitBuff(
        ctx:getActionHeroData(),
        ctx:getEffect():getBuff(),
        ctx:getHitHandler(),
        ctx:getCompletedHandler(),
        {
            hitType = BattleActionContext.HitType.Heal
        }
    )
end

--[[
    动作类型130 ~ 134 : 治愈
]]
BattleActionUtils._actions[130] = hitHealUtilsHandler
BattleActionUtils._actions[131] = hitHealUtilsHandler
BattleActionUtils._actions[132] = hitHealUtilsHandler
BattleActionUtils._actions[133] = hitHealUtilsHandler
BattleActionUtils._actions[134] = hitHealUtilsHandler
BattleActionUtils._actions[146] = hitHealUtilsHandler
BattleActionUtils._actions[200] = hitHealUtilsHandler
BattleActionUtils._actions[237] = hitHealUtilsHandler
BattleActionUtils._actions[146] = hitHealUtilsHandler

--[[
    分摊伤害15* : 复活
]]
local rebornUtilsHandler = function(ctx)
    ctx:getHitHandler()()
    ctx:getCompletedHandler()()
end

BattleActionUtils._actions[150] = rebornUtilsHandler
BattleActionUtils._actions[154] = rebornUtilsHandler
BattleActionUtils._actions[307] = rebornUtilsHandler

--[[
    动作类型1501 : 援助英雄上阵
]]
BattleActionUtils._actions[1501] = rebornUtilsHandler



---------- 属性变更系列 ----------

local attributeUpdateHandler = function(ctx)
    BattleActionUtils._hitBuff(
        ctx:getActionHeroData(),
        ctx:getEffect():getBuff(),
        ctx:getHitHandler(),
        ctx:getCompletedHandler(),
        {
            hitType = BattleActionContext.HitType.Common
        }
    )
end

BattleActionUtils._actions[160] = attributeUpdateHandler
BattleActionUtils._actions[162] = attributeUpdateHandler
BattleActionUtils._actions[163] = attributeUpdateHandler
BattleActionUtils._actions[164] = attributeUpdateHandler
BattleActionUtils._actions[166] = attributeUpdateHandler



---------- 被动触发的伤害 ----------
BattleActionUtils._actions[231] = attributeUpdateHandler
BattleActionUtils._actions[232] = attributeUpdateHandler
BattleActionUtils._actions[243] = attributeUpdateHandler



---------- 状态效果buff系列 ----------

local statusUpdateHandler = function(ctx)
    ctx:getCompletedHandler()()
end

--[[
    沉默
]]
BattleActionUtils._actions[1001] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()

    local buffs = effect:getBuffs()
    if type(buff.ani_base) ~= 'table' then
        buff.ani_base = {}
    end
    buff.ani_base.format = SLIENT_EFFECT_PATH_TPL

    for k,v in ipairs(buffs) do
        local heroData = v:getHeroData()
        if v:getHit() == BattleBuffInfo.HitType.Hit and v:getExpiredRound() ~= -1 then
            local buffSprite = BuffFactory.create(buff.type, buff.ani_base, ctx:getEnabledPlaySpeed())
            if buffSprite then
                heroData:getBattleNode():addRoundBuffEffect(v:getUnitId(), buff.type, buffSprite)
            end
        end
    end

    statusUpdateHandler(ctx)
end

BattleActionUtils._actions[1002] = statusUpdateHandler
BattleActionUtils._actions[1003] = statusUpdateHandler

--[[
    冰冻
]]
BattleActionUtils._actions[1004] = function(ctx)
    local effect = ctx:getEffect()
    local buffs = effect:getBuffs()
    
    for k,v in ipairs(buffs) do
        local heroData = v:getHeroData()
        if v:getHit() == BattleBuffInfo.HitType.Hit and v:getExpiredRound() ~= -1 then
            local heroNode = heroData:getBattleNode()
            heroNode:addHeroShader(1004, FROZEN_SHADER_TAG)
        end
    end

    statusUpdateHandler(ctx)
end

--[[
    眩晕
]]
BattleActionUtils._actions[1005] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()

    local buffs = effect:getBuffs()
    if type(buff.ani_base) ~= 'table' then
        buff.ani_base = {}
    end
    buff.ani_base.format = ROUND_EFFECT_PATH_TPL

    for k,v in ipairs(buffs) do
        local heroData = v:getHeroData()
        if v:getHit() == BattleBuffInfo.HitType.Hit and v:getExpiredRound() ~= -1 then
            local buffSprite = BuffFactory.create(buff.type, buff.ani_base, ctx:getEnabledPlaySpeed())
            if buffSprite then
                heroData:getBattleNode():addRoundBuffEffect(v:getUnitId(), buff.type, buffSprite)
            end
        end
    end
    
    statusUpdateHandler(ctx)
end

--[[
    契约
]]
BattleActionUtils._actions[199] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()

    local buffs = effect:getBuffs()
    if type(buff.ani_base) ~= 'table' then
        buff.ani_base = {}
    end
    buff.ani_base.format = CONTRACT_EFFECT_PATH_TPL

    for k,v in ipairs(buffs) do
        local heroData = v:getHeroData()
        if v:getHit() == BattleBuffInfo.HitType.Hit and v:getExpiredRound() ~= -1 then
            local buffSprite = BuffFactory.create(buff.type, buff.ani_base, ctx:getEnabledPlaySpeed())
            if buffSprite then
                buffSprite:setAnchorPoint(0.5, 0.2)
                heroData:getBattleNode():addRoundBuffEffect(v:getUnitId(), buff.type, buffSprite, true)
            end
        end
    end
    
    statusUpdateHandler(ctx)
end

--[[
    泰坦威尔顿4技能护盾
    该方法用在 BattleController 类中，在这个类中没有调用，写在此处是为了以后拓展
]]
BattleActionUtils._actions[351] = function(ctx)

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

--[[
    石化
]]
BattleActionUtils._actions[1006] = function(ctx)
    local effect = ctx:getEffect()
    local buffs = effect:getBuffs()
    
    for k,v in ipairs(buffs) do
        local heroData = v:getHeroData()
        if v:getHit() == BattleBuffInfo.HitType.Hit and v:getExpiredRound() ~= -1 then
            local heroNode = heroData:getBattleNode()
            heroNode:addHeroShader(1006, PETRIFY_SHADER_TAG)
        end
    end

    statusUpdateHandler(ctx)
end

--[[
    护盾
]]
BattleActionUtils._actions[1008] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()

    local buffs = effect:getBuffs()
    if type(buff.ani_base) ~= 'table' then
        buff.ani_base = {}
    end
    buff.ani_base.format = SHIELD_EFFECT_PATH_TPL
    if buff.ani_base.anchor_x == nil then
        buff.ani_base.anchor_x = 0.5
    end
    if buff.ani_base.anchor_y == nil then
        buff.ani_base.anchor_y = 0.8
    end

    buff.ani_base.scale_x = 2.0
    buff.ani_base.scale_y = 2.0

    buff.ani_base.duration = 0.15

    for k,v in ipairs(buffs) do
        local heroData = v:getHeroData()
        if v:getHit() == BattleBuffInfo.HitType.Hit and v:getExpiredRound() ~= -1 then
            local buffSprite = BuffFactory.create(buff.type, buff.ani_base, ctx:getEnabledPlaySpeed())
            if buffSprite then
                heroData:getBattleNode():addRoundBuffEffect(v:getUnitId(), buff.type, buffSprite)
            end
        end
    end
    
    statusUpdateHandler(ctx)
end

--[[
    格挡盾
]]
BattleActionUtils._actions[234] = function(ctx)
    local effect = ctx:getEffect()
    local buff = effect:getBuff()

    local buffs = effect:getBuffs()
    if type(buff.ani_base) ~= 'table' then
        buff.ani_base = {}
    end
    buff.ani_base.format = PARRY_EFFECT_PATH_TPL
    if buff.ani_base.anchor_x == nil then
        buff.ani_base.anchor_x = 0.5
    end
    if buff.ani_base.anchor_y == nil then
        buff.ani_base.anchor_y = 0.8
    end

    buff.ani_base.scale_x = 2.0
    buff.ani_base.scale_y = 2.0

    buff.ani_base.duration = 0.15

    for k,v in ipairs(buffs) do
        local heroData = v:getHeroData()
        if v:getHit() == BattleBuffInfo.HitType.Hit and v:getExpiredRound() ~= -1 then
            local buffSprite = BuffFactory.create(buff.type, buff.ani_base, ctx:getEnabledPlaySpeed())
            if buffSprite then
                heroData:getBattleNode():addRoundBuffEffect(v:getUnitId(), buff.type, buffSprite)
            end
        end
    end
    
    statusUpdateHandler(ctx)
end

BattleActionUtils._actions[1104] = hitHarmUtilsHandler

BattleActionUtils._actions[1201] = statusUpdateHandler
BattleActionUtils._actions[1202] = statusUpdateHandler
BattleActionUtils._actions[1203] = statusUpdateHandler
BattleActionUtils._actions[1204] = statusUpdateHandler
BattleActionUtils._actions[1205] = statusUpdateHandler
BattleActionUtils._actions[1206] = statusUpdateHandler
BattleActionUtils._actions[1207] = function(ctx)
    ctx:getHitHandler()()
    statusUpdateHandler(ctx)
end
BattleActionUtils._actions[1208] = statusUpdateHandler
BattleActionUtils._actions[1301] = statusUpdateHandler
BattleActionUtils._actions[1302] = statusUpdateHandler

--[[
    天气转换
]]
local changeWeatherHandler = function(layerCtx, weather_type)
    local eventHandler = layerCtx:getEventHandler()
    eventHandler(1002, weather_type)
end

--[[
    天气转换-雷暴
]]
BattleActionUtils._actions[1401] = function(ctx)
    changeWeatherHandler(ctx:getControlContext(), WEATHER_TYPE.THUNDER)
    
    statusUpdateHandler(ctx)
end

--[[
    变身
]]
-- BattleActionUtils._actions[1451] = function(ctx)
--     local effect = ctx:getEffect()
--     local buffs = effect:getBuffs()
    
--     for k,v in ipairs(buffs) do
--         local heroData = v:getHeroData()
--         heroData:getBattleNode():transform(false)
--     end
    
--     statusUpdateHandler(ctx)
-- end

--[[
    斗转星移 --位置变换
]]
BattleActionUtils._actions[650] = function(ctx)
        for _,v in ipairs(ctx:getEffect():getBuffs()) do
            for _,k in ipairs(v:getUpdates()) do
                if k:getType() == 2 then
                    local pos = k:getValue()
                    local bfSize = ctx:getActionHeroData():getBfSize() 
                    v:getHeroData():getBattleNode():setHeroPosition(pos,bfSize)
                end
                
            end
           
        end
    statusUpdateHandler(ctx)
end

--[[
    分身
]]
BattleActionUtils._actions[653] = function(ctx)
    local buffs = ctx:getEffect():getBuffs()
    for _,v in ipairs(ctx:getEffect():getBuffs()) do
        local target_unitid = v:getTargetUnitId()
        print(target_unitid)
        if target_unitid then
            statusUpdateHandler(ctx)
        end
        local heroData = v:getHeroData()
        local target_hero_data = heroData:getHeroDataByUnitId(target_unitid)
        local hero_node = target_hero_data:getBattleNode()
        local position = v:getUpdates()[1]:getValue()
        local bfSize = ctx:getActionHeroData():getBfSize()
        local hp = v:getUpdates()[2]:getValue()
        hero_node:setMaxHp(hp)
        hero_node:setHp(hp)
        hero_node:setSeparationRevive(position,bfSize)
    end
    ctx:getCompletedHandler()()
end

-- --[[
--      化身死亡
--  ]]
--  BattleActionUtils._actions[654] = function(ctx)
--     for _,v in ipairs(ctx:getEffect():getBuffs()) do
--         v:getHeroData():getBattleNode():die()
--     end
--     ctx:getCompletedHandler()()
-- end



--[[
    清除特殊的附身buff的执行器

    例如，有些buff会修改显示对象的shader。有些buff可能会减慢显示对象的动画播放速度甚至停止。
    那么就需要在这里创建特定buff的映射来实现恢复/清除逻辑。
]]
BattleActionUtils._clearHandlers = {}

--[[
    清除冰冻
]]
BattleActionUtils._clearHandlers[1004] = function(buffInfo)
    buffInfo:getHeroData():getBattleNode():removeHeroShader(1004)
end

--[[
    清除石化
]]
BattleActionUtils._clearHandlers[1006] = function(buffInfo)
    buffInfo:getHeroData():getBattleNode():removeHeroShader(1006)
end

--[[
    天气清除
]]
local cleanWeatherHandler = function(buffInfo, eventHandler)
    eventHandler(1002, WEATHER_TYPE.NIL)
end

BattleActionUtils._clearHandlers[1401] = cleanWeatherHandler

--[[
    变身
]]
-- BattleActionUtils._clearHandlers[1451] = function(ctx)
--     local heroData = ctx:getActionHeroData()
--     local heroNode = heroData:getBattleNode()
    
--     heroNode:transform(true)
-- end

--[[
    清除斗转星移
]]
BattleActionUtils._clearHandlers[650] = function(buffInfo)
    local bfSize = buffInfo:getHeroData():getBfSize()
    local pos = buffInfo:getHeroData():getBattleNode():getNowPosition()
    buffInfo:getHeroData():getBattleNode():setHeroPosition(pos,bfSize)
end


--[[
    正在攻击的英雄的动作序列

    heroData    : <BattleHeroData> 英雄数据对象
    buffConf    : buff配置表项数据
    compHandler : 完成动作函数
    options     : 可选配置
    {
        isMove       : <boolean> 是否移动(default: false)
        movePosition : <{x,y}> 移动的位置(default: 英雄当前站位)，只有当isMove = true时才生效
        playAttack   : <boolean> 是否播放攻击动画(default: true)
        jointBuff    : <boolean> 是否挂上buff特效(default: false)
    }

    执行流程:
    - 执行前的延迟
    - 移动到指定点(默认0.0秒移动到原本的位置，即不移动)
    - 播放攻击动画(如果需要)
    - 打击帧延迟
    - 在英雄身上附加特效(如果需要)
    - 攻击动作的延迟
    - 等待动作执行的延迟
    - 返回到原来位置的延迟
    - 恢复原来的渲染层级
    - 返回到原来位置(默认0.0秒返回到原来的位置，即不移动)
    - 执行动作完成的函数
]]
BattleActionUtils._attackingAction = function(layerCtx, heroData, buffConf, enabledPlaySpeed, compHandler, options)
    if type(options) ~= 'table' then
        options = {}
    end

    local heroNode = heroData:getBattleNode()

    local originZOrder = heroNode:getLocalZOrder()
    local moveTime = 0
    local movePosition = options.movePosition or heroData:getPosition()
    if options.isMove then
        moveTime = buffConf.ani_base.move_time or MOVE_TIME
    end
    
    local attackTime = buffConf.ani_base.attack_time or ATTACK_TIME
    local actionTime = buffConf.ani_base.action_time or ACTION_TIME
    local attackDelay = buffConf.ani_base.attack_delay or ATTACK_DELAY
    local backTime = buffConf.ani_base.move_back or BACK_TIME

    local action = cc.Sequence:create(
        cc.MoveTo:create(moveTime, movePosition),
        cc.CallFunc:create(function()
            heroNode:setLocalZOrder(GlobalBattleHelper.LayerZOrder.HeroBase - heroNode:getPositionY() + 1)
            if options.playAttack == nil or options.playAttack then
                if buffConf.ani_base.action == 'skill' then
                    heroNode:actionSkill()
                elseif buffConf.ani_base.action == 'skill2' then
                    heroNode:actionSkill2()
                elseif buffConf.ani_base.action == 'transform' then
                    heroNode:transform()
                else
                    heroNode:actionAttack()
                end
            end
        end),
        cc.DelayTime:create(attackTime),
        cc.CallFunc:create(function()
            if options.jointBuff then
                BattleActionUtils._appendBuffEffect(layerCtx, heroData, buffConf, enabledPlaySpeed)
            end
        end),
        cc.DelayTime:create(attackDelay),
        cc.DelayTime:create(actionTime),
        cc.DelayTime:create(backTime),
        cc.CallFunc:create(function()
            heroNode:setLocalZOrder(originZOrder)
        end),
        cc.MoveTo:create(moveTime, heroData:getPosition()),
        cc.CallFunc:create(compHandler),
        nil
    )

    heroNode:runAction(action)
end

--[[
    远程类攻击专用的特效，也就是说，如果有特效则会把特效沿路飞到目标上

    layerCtx    : <BattleLayerContext> 战斗层上下文对象
    heroData    : <BattleHeroData> 英雄数据对象
    buffConf    : buff配置表项数据
]]
BattleActionUtils._rangeAttackingAction = function(layerCtx, actionHeroData, heroData, buffConf, enabledPlaySpeed)
    local actionHeroNode = actionHeroData:getBattleNode()
    local heroNode = heroData:getBattleNode()

    local actionHeroSize = actionHeroNode:getContentSize()
    local heroSize = heroNode:getContentSize()

    local attackTime = buffConf.ani_base.attack_time or ATTACK_TIME
    local duration   = buffConf.ani_base.duration or ACTION_DURATION

    local action = cc.Sequence:create(
        cc.DelayTime:create(attackTime),
        cc.CallFunc:create(function()
            local buffSprite = BuffFactory.create(buffConf.type, buffConf.ani_base, enabledPlaySpeed)
            if buffSprite then
                local frameCount = BuffFactory.getAnimateCount(buffConf.ani_base)

                local actionCenterPos = cc.p(
                    0,
                    actionHeroNode:getScale() * actionHeroSize.height / 2
                )
                local centerPos = cc.p(
                    0,
                    heroNode:getScale() * heroSize.height / 2
                )

                local startPosition = cc.pAdd(actionHeroData:getIndexPosition(), actionCenterPos)
                buffSprite:setPosition(startPosition)
                
                local targetPosition = clone(heroData:getIndexPosition())
                targetPosition.x = layerCtx:getLayer():getContentSize().width - targetPosition.x
                targetPosition = cc.pAdd(targetPosition, centerPos)

                local targetVec = cc.pSub(targetPosition, startPosition)
                local rotation = Maths.radiansToDegrees(cc.pGetAngle(targetVec, X_VECTOR))
                buffSprite:setRotation(rotation)

                local action = cc.Sequence:create(
                    cc.MoveTo:create((frameCount)*duration, targetPosition),
                    cc.RemoveSelf:create(),
                    nil
                )
                BattleActionUtils._appendEffectWithTeam(actionHeroData:getTeam(), layerCtx, buffSprite)
                buffSprite:runAction(action)
            end
        end),
        nil
    )

    heroNode:runAction(action)
end

--[[
    在指定的英雄身上播放buff特效

    layerCtx    : <BattleLayerContext> 战斗层上下文对象
    heroData    : <BattleHeroData> 英雄数据对象
    buffConf    : buff配置表项数据
    compHandler : 完成动作函数

    执行流程:
    - 执行前的延迟
    - 在英雄身上附加特效(如果需要)
    - 执行动作完成的函数
]]
BattleActionUtils._playBuffOnHero = function(layerCtx, heroData, buffConf, enabledPlaySpeed, compHandler)
    local action = cc.Sequence:create(
        cc.CallFunc:create(function()
            BattleActionUtils._appendBuffEffect(layerCtx, heroData, buffConf, enabledPlaySpeed)
        end),
        cc.CallFunc:create(compHandler),
        nil
    )
    
    heroData:getBattleNode():runAction(action)
end

--[[
    在地图上的指定位置播放特效

    layerCtx    : <BattleLayerContext> 战斗层上下文对象
    heroData    : <BattleHeroData> 英雄数据对象
    buffConf    : buff配置表项数据
    compHandler : 完成动作函数
]]
BattleActionUtils._playBuffOnPosition = function(layerCtx, heroData, buffConf, enabledPlaySpeed, compHandler)
    local buffSprite = BuffFactory.create(buffConf.type, buffConf.ani_base, enabledPlaySpeed)
    if buffSprite then
        local position = BattleActionUtils._calcOffsetPosition(layerCtx:getLayer(), buffConf.ani_base)
        buffSprite:setPosition(position)
        BattleActionUtils._appendEffectWithTeam(heroData:getTeam(), layerCtx, buffSprite)
    end
    compHandler()
end

--[[
    打击专用buff

    heroData    : <BattleHeroData> 英雄数据对象
    buffConf    : buff配置表项数据
    hitHandler  : 打击函数
    compHandler : 完成动作函数
    options     : 可选配置
    {
        hitType : <BattleActionContext.HitType> 打击类型(default: BattleActionContext.HitType.Common)
    }
]]
BattleActionUtils._hitBuff = function(heroData, buffConf, hitHandler, compHandler, options)
    local action = cc.Sequence:create(
        cc.CallFunc:create(function()
            hitHandler(options.hitType or BattleActionContext.HitType.Common)
        end),
        cc.CallFunc:create(compHandler),
        nil
    )
    heroData:getBattleNode():runAction(action)
end

--[[
    添加buff特效到指定的特效层上

    layerCtx : <BattleLayerContext> 战斗层上下文
    heroData : <BattleHeroData> 英雄数据对象
    buffConf : buff配置表项数据
]]
BattleActionUtils._appendBuffEffect = function(layerCtx, heroData, buffConf, enabledPlaySpeed)
    local pos = cc.p(
        heroData:getBattleNode():getPositionX(),
        heroData:getBattleNode():getPositionY()
    )

    local buffSprite = BuffFactory.create(buffConf.type, buffConf.ani_base, enabledPlaySpeed)
    if buffSprite then
        BattleActionUtils._setBaseHeroEffectAttributes(buffSprite, heroData, buffConf.ani_base)
        buffSprite:setPosition(pos)
        if heroData:getTeam() ~= BattleHeroData.TeamType.Player then
            buffSprite:setPositionX(layerCtx:getLayer():getContentSize().width - buffSprite:getPositionX())
        end
        BattleActionUtils._appendEffectWithTeam(heroData:getTeam(), layerCtx, buffSprite)
    end
end

--[[
    根据英雄所在团队选择将特效添加到指定的node上
]]
BattleActionUtils._appendEffectWithTeam = function(team, layerCtx, effectNode)
    local layer = nil
    if team == BattleHeroData.TeamType.Player then
        layer = layerCtx:getRightEffectLayer()
    else
        layer = layerCtx:getLeftEffectLayer()
    end

    layer:addChild(effectNode)
end

--[[
    计算攻击目标英雄的近身位置
]]
BattleActionUtils._calcBeattackHeroPosition = function(heroData)
    return BattleUtils.getHeroAttackPosition(
        heroData:getPosition(),
        heroData:getTeam() == BattleHeroData.TeamType.Player
    )
end

--[[
    通过偏移位置的比例数据计算出场景中的某个位置

    layer    : 战场显示对象
    team     : 释放的特效基于哪个队伍
    aniBase  : 特效动作描述结构
]]
BattleActionUtils._calcOffsetPosition = function(layer, aniBase)
    local size = layer:getContentSize()

    local pos = cc.p(0, 0)

    if aniBase.offset_x then
        local offsetX = tonumber(aniBase.offset_x)
        pos.x = offsetX * size.width
    end
    
    if aniBase.offset_y then
        local offsetY = tonumber(aniBase.offset_y)
        pos.y = offsetY * size.height
    end

    return pos
end

BattleActionUtils._setBaseHeroEffectAttributes = function(sprite, heroData, aniBase)
    local heroNode = heroData:getBattleNode()
    local heroSize = heroNode:getContentSize()

    local anchorPoint = sprite:getAnchorPoint()
    
    if aniBase.offset_x then
        local offsetX = tonumber(aniBase.offset_x)
        anchorPoint.x = anchorPoint.x + offsetX
    end
    
    if aniBase.offset_y then
        local offsetY = tonumber(aniBase.offset_y)
        anchorPoint.y = anchorPoint.y + offsetY
    end
    
    sprite:setAnchorPoint(anchorPoint)
end

--[[
    播放震动特效
]]
BattleActionUtils._playShake = function(layer)
    local shakeAction = BattleActionFactory.createShake(SHAKE_RANGE, SHAKE_TIMES, SHAKE_SLOW_DOWN)
    shakeAction:setTag(SHAKE_ACTION_TAG)
    layer:getParent():runAction(shakeAction)
end

--[[
    播放变暗效果
]]
BattleActionUtils._playDimly = function(layer, aniBase)
    local timeIn = aniBase.time_in or DIMLY_TIME_IN
    local timeOut = aniBase.time_out or DIMLY_TIME_OUT
    local timeDelay = aniBase.time_delay or DIMLY_TIME_DELAY

    local dimlyNode = layer:getChildByTag(DIMLY_NODE_TAG)
    if dimlyNode then
        dimlyNode:removeFromParent()
    end

    local layerSize = clone(layer:getScene():getContentSize())
    layerSize.width = layerSize.width + DIMLY_EX_SIZE.width
    layerSize.height = layerSize.height + DIMLY_EX_SIZE.height
    local cLayer = cc.LayerColor:create(cc.c4b(0,0,0,0), layerSize.width, layerSize.height)
    cLayer:setPosition(cc.p(
        -DIMLY_EX_SIZE.width/2,
        -DIMLY_EX_SIZE.height/2
    ))
    GlobalBattleHelper.bindScheduler(cLayer)
    cLayer:setTag(DIMLY_NODE_TAG)
    layer:addChild(cLayer)

    local dimlyAction = BattleActionFactory.createDimly(timeIn, timeOut, timeDelay)
    local action = cc.Sequence:create(
        dimlyAction,
        cc.RemoveSelf:create(),
        nil
    )
    cLayer:runAction(action)
end
