local UIProgreeBar = class("UIProgreeBar", function(...)
    return ccui.Scale9Sprite:create()
end)

function UIProgreeBar:ctor(...)
    self.bar = cc.ProgressTimer:create(cc.Sprite:create())
    self:addChild(self.bar)
end

function UIProgreeBar:setContentSize(w, h)
    self.bar:setPosition(w / 2, h / 2)
    cc.Node.setContentSize(self, w, h)
end

function UIProgreeBar:setBgSpriteFrame(plist, texture, frameName, rect)
    local asyn_call = function(...)
        local params = {...}
        if tolua.isnull(self) then
            return
        end

        local size = self:getContentSize()
        display.loadSpriteFrames(plist, texture)
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)

        if frame then
            self:setSpriteFrame(frame, rect)
            self:setPreferredSize(size)
        end

    end
    display.loadImage(texture, asyn_call)
end

function UIProgreeBar:setBarSpriteFrame(plist, texture, frame)
    local asyn_call = function(...)
        local params = {...}
        if tolua.isnull(self) then
            return
        end

        local spr = cc.Sprite:createWithSpriteFrameName(frame)
        self.bar:setSprite(spr)
    end
    display.loadImage(texture, asyn_call)
end

function UIProgreeBar:setType(t)
    self.bar:setType(t)
end

function UIProgreeBar:setMidpoint(p)
    self.bar:setMidpoint(p)
end

function UIProgreeBar:setBarChangeRate(p)
    self.bar:setBarChangeRate(p)
end

function UIProgreeBar:setBarAnchorPoint(p)
    self.bar:setBarAnchorPoint(p)
end

function UIProgreeBar:setBarPosition(p)
    self.bar:setBarPosition(p)
end

function UIProgreeBar:setPercentage(p)
    self.bar:setPercentage(p)
end

return UIProgreeBar
