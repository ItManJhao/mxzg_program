
local EventLayer = require("src.comp.EventLayer");
local CCCBaseClass = require("src.comp.CCCBaseClass");
local CCCLayerBase = class("CCCLayerBase", EventLayer, CCCBaseClass)

function CCCLayerBase:ctor()
    CCCBaseClass.ctor(self)
    EventLayer.ctor(self)
    self:setPositionCenter()

    print(self:getName())
end

function CCCLayerBase:setPositionCenter()
    local win_size = cc.Director:getInstance():getWinSize()
    self:setPositionX(win_size.width / 2 - ( (0.5 - self:getAnchorPoint().x) * self:getContentSize().width) * self:getScaleX())
    self:setPositionY(win_size.height / 2 - ( (0.5 - self:getAnchorPoint().y) * self:getContentSize().height) * self:getScaleY())
end

function CCCLayerBase:onEventLayerEnter()
    CCCBaseClass.onEventLayerEnter(self)
    EventLayer.onEventLayerEnter(self)
end

function CCCLayerBase:onClose()
    if self.node_ctr then
        self.node_ctr:closeWindow()
    end
end

function CCCLayerBase:removeImage()
    -- print("111")
    CCCBaseClass.removeImage(self)
    EventLayer.removeImage(self)
end

function CCCLayerBase:runEnterAnim()
	self:setAnchorPoint(cc.p(0.5, 0.5))
	self:setIgnoreAnchorPointForPosition(false)
	self:setPositionCenter()
	
	local duration = 0.2
	local scale = self:getScale()
	self:setScale(scale * 0.9)
	local act_enter = cc.EaseExponentialOut:create(cc.Spawn:create(
													cc.Sequence:create(cc.ScaleTo:create(duration * 0.85, scale * 1.07), cc.ScaleTo:create(duration * 0.15, scale * 1)),	
									  				cc.FadeTo:create(duration, 255)));
    self:runAction(act_enter)
end

return CCCLayerBase
