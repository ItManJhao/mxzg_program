EffectFactory = {}

--[[
    format   : 获取特效资源的格式化字符串
    duration : 帧间隔时间
    options:
    {
        isForever        : 是否循环播放特效(default: false)
        enabledPlaySpeed : 是否启用战斗加速功能(请参考: GlobalBattleHelper.bindScheduler)
    }
]]
EffectFactory.createSprite = function(format, duration, options)
    local animate = EffectFactory._createAnimate(format, duration)

    local action = nil
    if options.isForever then
        action = cc.RepeatForever:create(animate)
    else
        action = cc.Sequence:create(
            animate,
            cc.RemoveSelf:create(),
            nil
        )
    end
    
    local sprite = cc.Sprite:create()
    local firstSpriteFrame = EffectFactory._genSpriteFrame(format, 0)
    if firstSpriteFrame ~= nil then
        sprite:setSpriteFrame(firstSpriteFrame)
    end
    if options.enabledPlaySpeed then
        GlobalBattleHelper.bindScheduler(sprite)
    end
    sprite:runAction(action)

    return sprite
end

EffectFactory._createAnimate = function(nameFormat, duration)
    local frames = EffectFactory._genSpriteFrames(nameFormat)
    local animation = cc.Animation:createWithSpriteFrames(frames, duration)
    local animate = cc.Animate:create(animation)
    return animate
end

--[[
    获取指定规则的帧数据
]]
EffectFactory._genSpriteFrames = function(nameFormat)
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

    return frames
end

EffectFactory._genSpriteFrame = function(nameFormat, i)
    local frameName = string.format(nameFormat, i)
    return cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
end
