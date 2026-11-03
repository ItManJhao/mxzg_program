local UISliderVertical = class("UISliderVertical", function ( ... )
    return cc.Node:create(...)
end)


function UISliderVertical:ctor()

    self.offset_y = 0
    -- self.is_back = false
    self.scale_callback = nil
    self.scale_coe = nil
    self.max_offset_y = 200
    self.old_scale = 1
    self.old_scale_callback = nil

    self.velocity_y = 0

    self.spr_slider_bg = ccui.Scale9Sprite:create()
    self.spr_slider_bg:setVisible(false)
    self:addChild(self.spr_slider_bg)

    self.spr_slider = cc.Sprite:create()
    self:addChild(self.spr_slider)

    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(true)
    self.listener_touch:registerScriptHandler(function(touch, event)
        self.touch_position = touch:getLocation()
        local touchLocation = self.spr_slider:getParent():convertToNodeSpace(self.touch_position)
        local bBox = self.spr_slider:getBoundingBox()
        local is_contains = cc.rectContainsPoint(bBox, touchLocation)

        if is_contains and self.old_scale_callback then
            self.old_scale = self.old_scale_callback()
            self.spr_slider_bg:setOpacity(255)
            self.spr_slider_bg:setVisible(true)
        end

        return is_contains
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    self.listener_touch:registerScriptHandler(function(touch)
        local touch_position = touch:getLocation()
        -- if math.abs(touch_position.x - self.touch_position.x) <= 5 or math.abs(touch_position.y - self.touch_position.y) <= 5 then
        --     return
        -- end
        self:stopScheduler()

        self.offset_y = touch_position.y - self.touch_position.y
        self.offset_y = Maths.clampf(self.offset_y, -self.max_offset_y, self.max_offset_y)

        self.spr_slider:setPositionY(self.offset_y)
        self.spr_slider_bg:setOpacity(255)

        if self.scale_callback then
            self.scale_callback(self.old_scale, self.offset_y / self.max_offset_y)
        end

    end, cc.Handler.EVENT_TOUCH_MOVED)

    self.listener_touch:registerScriptHandler(function(touch, event)
        local touch_position = touch:getLocation()
        -- if math.abs(touch_position.x - self.touch_position.x) <= 5 or math.abs(touch_position.y - self.touch_position.y) <= 5 then
        --     return
        -- end

        -- self.is_back = true
        self:startScheduler()
        -- local scheduler = cc.Director:getInstance():getScheduler()
        -- self.scheduler_id = scheduler:scheduleScriptFunc(handler(self, self.checkRecharge), 2, false)
    end, cc.Handler.EVENT_TOUCH_ENDED)

    local event_dispatcher = self.spr_slider:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, self.spr_slider)

    self:registerScriptHandler(handler(self, self.eventHandler))
end

function UISliderVertical:eventHandler(eventType)
    if eventType == "exit" then
        self:stopScheduler()
    end
end

function UISliderVertical:startScheduler()
    self:stopScheduler()
    local scheduler = cc.Director:getInstance():getScheduler()
    self.scheduler_id = scheduler:scheduleScriptFunc(handler(self, self.updateBack), 0.016, false)
end

function UISliderVertical:stopScheduler()
    if self.scheduler_id ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler_id)
		self.scheduler_id = nil
	end
end

function UISliderVertical:updateBack(dt)
    -- local y = self.spr_slider:getPositionY()
    -- local offset = y > 0 and math.max(-y, -5) or math.min(-y, 5)
    -- self.spr_slider:setPositionY(self.spr_slider:getPositionY() + offset)
    -- if math.abs(offset) < 5 then
    --     self:stopScheduler()
    -- end

    local new_y = 0
    new_y, self.velocity_y = Maths.smoothDamp(self.spr_slider:getPositionY(), 0, self.velocity_y, 0.3, 300000, dt)
    self.spr_slider:setPositionY(new_y)
    
    local max_opacity_y = self.max_offset_y * 0.3
    self.spr_slider_bg:setOpacity(math.min(math.abs(new_y), max_opacity_y) / max_opacity_y * 255)
    if math.abs(new_y) < 0.5 then
        self.spr_slider:setPositionY(0)
        self.spr_slider_bg:setVisible(false)
        self:stopScheduler()
    end
end

function UISliderVertical:setSliderFrame(frame)
    self.spr_slider:setSpriteFrame(frame)
end

function UISliderVertical:setSliderBgFrame(frame, rect, size)
    -- self.spr_slider_bg:setCapInsets(rect)
    self.spr_slider_bg:setSpriteFrame(cc.SpriteFrameCache:getInstance():getSpriteFrame(frame), rect)
    self.spr_slider_bg:setPreferredSize(size)
    self.max_offset_y = size.height * 0.5
end

function UISliderVertical:setOldScaleCallback(callback)
    self.old_scale_callback = callback
end

function UISliderVertical:setScaleCallback(callback)
    self.scale_callback = callback
end

return UISliderVertical