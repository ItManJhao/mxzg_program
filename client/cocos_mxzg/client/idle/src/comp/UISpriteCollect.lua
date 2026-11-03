-- 创建一个文字气泡
-- 角标会指向锚点

local UISpriteCollect = class("UISpriteCollect", function(...)
    return cc.Sprite:createWithSpriteFrameName(...)
end)

function UISpriteCollect:ctor()
    self.end_pos = cc.p(0, 0)
    self.velocity = cc.p(0, 0)
    self.speed = 0.1
    self:registerScriptHandler(handler(self, self.eventHandler))
end

function UISpriteCollect:eventHandler(eventType)
    if eventType == "exit" then
        self:stopScheduler()
    end
end

function UISpriteCollect:startScheduler()
    self:stopScheduler()
    local scheduler = cc.Director:getInstance():getScheduler()
    self.scheduler_id = scheduler:scheduleScriptFunc(handler(self, self.updateBack), 0.016, false)
end

function UISpriteCollect:stopScheduler()
    if self.scheduler_id ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
		self.scheduler_id = nil
	end
end

function UISpriteCollect:updateBack(dt)
    local new_x = 0
    local new_y = 0
    new_x, self.velocity.x = Maths.smoothDamp(self:getPositionX(), self.end_pos.x, self.velocity.x, self.speed, 300000, dt)
    new_y, self.velocity.y = Maths.smoothDamp(self:getPositionY(), self.end_pos.y, self.velocity.y, self.speed, 300000, dt)
    -- print(new_x, new_y)
    self:setPosition(new_x, new_y)
    if math.abs(new_x - self.end_pos.x) <= 10 and math.abs(new_y - self.end_pos.y) <= 10 then
        self:startScheduler()
        self:removeFromParent() 
    end
end

function UISpriteCollect:runAnim(beg_pos, end_pos)
    self.end_pos = end_pos
    self.speed = self.speed + math.random(40) * 0.01
    local act_stay = cc.Spawn:create(cc.FadeTo:create(0.1, 255),
                                     cc.EaseExponentialOut:create(cc.MoveTo:create(0.5, cc.p(beg_pos.x + math.random(200) - 100, beg_pos.y + math.random(200) - 100))))

    self:runAction(cc.Sequence:create(act_stay, cc.DelayTime:create(1), cc.CallFunc:create(function()
        self:startScheduler()
    end)))
end


return UISpriteCollect
