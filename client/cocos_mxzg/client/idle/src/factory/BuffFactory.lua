BuffFactory = {}

local DEFAULT_DURATION      = 0.05
local EFFECT_Y_FIXED_OFFSET = -0.07

--[[
    在创建战斗相关的对象时要注意添加战斗专属的调度器和动作管理器，
    否则对象无法兼容战斗速度
]]



----------------------------- 预定义函数 -----------------------------
local selfRemoveEffect = function(aniBase, enabledPlaySpeed)
    return BuffFactory._createSelfRemoveEffect(aniBase, enabledPlaySpeed)
end

local repeatForeverEffect = function(aniBase, enabledPlaySpeed)
    return BuffFactory._createRepeatForeverEffect(aniBase, enabledPlaySpeed)
end



--[[
    buffType : <int> buff的类型
    aniBase  : <object> buff动作的描述结构
]]
BuffFactory.create = function(buffType, aniBase, enabledPlaySpeed)
    local handler = BuffFactory._map[buffType]
    if handler == nil then return nil end
    
    return handler(aniBase, enabledPlaySpeed)
end

--[[
    获取指定动画的帧数量
]]
BuffFactory.getAnimateCount = function(aniBase)
    local nameFormat = aniBase.format

    local frames = {}
    local sfc = cc.SpriteFrameCache:getInstance()

    local i = 0
    repeat
        local frameName = string.format(nameFormat, i)
        local frame = sfc:getSpriteFrame(frameName)
        if frame ~= nil then
            table.insert(frames, frame)
        end
        i = i + 1
    until(frame == nil)

    return i
end



----------------------------- 以下是特定类型的buff创建函数 -----------------------------

--[[
    不同buff类型的工厂函数列表，
    以buff的类型为key
]]
BuffFactory._map = {}

--[[
    自删除的buff类型
]]
BuffFactory._map[3]  = selfRemoveEffect
BuffFactory._map[6]  = selfRemoveEffect
BuffFactory._map[7]  = selfRemoveEffect
BuffFactory._map[9]  = selfRemoveEffect
BuffFactory._map[10] = selfRemoveEffect

--[[
    持续性的buff类型
]]
BuffFactory._map[5] = repeatForeverEffect

--[[
    回合性的buff类型
]]
BuffFactory._map[234] = repeatForeverEffect
BuffFactory._map[199] = repeatForeverEffect
BuffFactory._map[1001] = repeatForeverEffect
BuffFactory._map[1005] = repeatForeverEffect
BuffFactory._map[1008] = repeatForeverEffect
BuffFactory._map[351] = repeatForeverEffect

----------------------------- 以下是辅助用的函数 -----------------------------



BuffFactory._createSelfRemoveEffect = function(aniBase, enabledPlaySpeed)
    if type(aniBase) ~= 'table' or aniBase.format == nil then return nil end
    
    local duration = aniBase.duration or DEFAULT_DURATION
    local sprite = EffectFactory.createSprite(aniBase.format, duration, {
        enabledPlaySpeed = enabledPlaySpeed
    })
    BuffFactory._setBaseAttributes(sprite, aniBase)

    return sprite
end

BuffFactory._createRepeatForeverEffect = function(aniBase, enabledPlaySpeed)
    if type(aniBase) ~= 'table' or aniBase.format == nil then return nil end
    
    local duration = aniBase.duration or DEFAULT_DURATION
    local sprite = EffectFactory.createSprite(aniBase.format, duration, {
        enabledPlaySpeed = enabledPlaySpeed,
        isForever = true
    })
    BuffFactory._setBaseAttributes(sprite, aniBase)

    return sprite
end

BuffFactory._setBaseAttributes = function(sprite, aniBase)
    local scaleX = sprite:getScaleX()
    local scaleY = sprite:getScaleY()

    if aniBase.scale_x then
        scaleX = scaleX * tonumber(aniBase.scale_x) or scaleX
    end
    if aniBase.scale_y then
        scaleY = scaleY * tonumber(aniBase.scale_y) or scaleY
    end

    sprite:setScaleX(scaleX)
    sprite:setScaleY(scaleY)
    
    if aniBase.rotation then
        sprite:setRotation(tonumber(aniBase.rotation))
    end

    local anchorPoint = cc.p(0.5, 0.5)
    if aniBase.anchor_x then
        anchorPoint.x = tonumber(aniBase.anchor_x) or anchorPoint.x
    end
    if aniBase.anchor_y then
        anchorPoint.y = tonumber(aniBase.anchor_y) or anchorPoint.y
    end
    anchorPoint.y = anchorPoint.y + EFFECT_Y_FIXED_OFFSET
    sprite:setAnchorPoint(anchorPoint)

    if aniBase.flipped == 1 then
        sprite:setFlippedX(true)
    end
end
