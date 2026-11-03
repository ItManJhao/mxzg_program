local UIMenuEx = class("UIMenuEx", function ()
	return cc.Node:create()
end)

local UI_ENABLE_MOVE_DISTANCE = 5

local MenuState = {
    WAITING = 1,
    TRACKING_TOUCH = 2,
}

function UIMenuEx:ctor()
    self._selectedItem = nil
    self._state = MenuState.WAITING;
    self._isEnabled = true

    self.isMove = false
    self._touchBegan = cc.p(0, 0)

    self._touchInsideNode = nil

    self.listener_touch = cc.EventListenerTouchOneByOne:create()  --创建一个单点事件监听
    self.listener_touch:setSwallowTouches(true)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
    self.listener_touch:registerScriptHandler(handler(self, self.onTouchCancelled), cc.Handler.EVENT_TOUCH_CANCELLED)

    local event_dispatcher = self:getEventDispatcher() 
    event_dispatcher:addEventListenerWithSceneGraphPriority(self.listener_touch, self)
end

function UIMenuEx:setSwallowsTouches(b)
    self.listener_touch:setSwallowTouches(b)
    return self
end

function UIMenuEx:setIsTouchInsideNode(node)
    self._touchInsideNode = node
    return self
end

function UIMenuEx:setEnabled(b)
    self._isEnabled = b    
end

function UIMenuEx:isEnabled( )
    return self._isEnabled
end

function UIMenuEx:onTouchBegan(touch, event)
    -- 检查自己是否合法
    if self._state ~= MenuState.WAITING or self:isVisible() == false or self:isEnabled() == false then
        return false
    end

    if self._touchInsideNode and self._touchInsideNode:getParent() then
        if cc.rectContainsPoint(self._touchInsideNode:getBoundingBox(), self._touchInsideNode:getParent():convertToNodeSpace(touch:getLocation())) == false then
            return false
        end
    end


    self.isMove = false

    -- 检查父节点是否合法
    local parent = self:getParent()
    while parent ~= nil do
        if parent:isVisible() == false then
            return false
        end
        parent = parent:getParent()
    end

    self._touchBegan = touch:getLocation()
    self._selectedItem = self:getItemForTouch(touch)

    if self._selectedItem then
        self._state = MenuState.TRACKING_TOUCH
        cc.MenuItem.selected(self._selectedItem)
        return true
    end

    return false
end

function UIMenuEx:onTouchEnded(touch, event)
    self:retain()

    if self._selectedItem then
        -- self._selectedItem:unselected()
        -- self._selectedItem:activate()
        cc.MenuItem.unselected(self._selectedItem)

        if self.isMove == false then
            cc.MenuItem.activate(self._selectedItem)
        end
    end

    self._state = MenuState.WAITING
    self:release()
end

function UIMenuEx:onTouchCancelled(touch, event)
    self:retain()
    if self._selectedItem then
        -- self._selectedItem:unselected()
        cc.MenuItem.unselected(self._selectedItem)
    end
    self._state = MenuState.WAITING
    self:release()
end

function UIMenuEx:onTouchMoved(touch, event)

    if math.abs(self._touchBegan.x - touch:getLocation().x) > UI_ENABLE_MOVE_DISTANCE or
       math.abs(self._touchBegan.y - touch:getLocation().y) > UI_ENABLE_MOVE_DISTANCE
    then
        self.isMove = true
    end


    local currentItem = self:getItemForTouch(touch)
    if self._selectedItem ~= currentItem then
        if self._selectedItem then
            -- self._selectedItem:unselected()
            cc.MenuItem.unselected(self._selectedItem)
        end
        self._selectedItem = currentItem
        if self._selectedItem then
            -- self._selectedItem:selected()
            cc.MenuItem.selected(self._selectedItem)
        end
    end
end

function UIMenuEx:getItemForTouch(touch)
    local touchLocation = touch:getLocation()
    local children = self:getChildren()
    for i,c in ipairs(children) do
        if c:isVisible() and c:isEnabled() then
            if cc.rectContainsPoint(c:getBoundingBox(), self:convertToNodeSpace(touchLocation)) then
                return c
            end
        end
    end
    return nil
end

return UIMenuEx
