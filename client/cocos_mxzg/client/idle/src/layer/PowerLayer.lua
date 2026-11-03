local PowerLayer = class("PowerLayer", require("src.comp.EventLayer"))

function PowerLayer:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
    -- self:setCascadeOpacityEnabled(true)
    self.lbl_power = cc.Label:createWithBMFont("res/hd/font/red-26.fnt", "+9999");
    self:addChild(self.lbl_power)
    self.lbl_power:setAnchorPoint(cc.p(0,0.5))
    self.lbl_power:setPosition(cc.p(165,14))
    self:addEvent(EVENT.POWER_EFFECT.CLOSE_EFFECT_LAYER,handler(self,self.onClose))
end

function PowerLayer:onClose(event,data)
    self:removeTimerByName("power")
    self:removeFromParent()
end

function PowerLayer:setPower(oldPower,newPower)
    self:removeTimerByName("power")
    self.old_power = oldPower
    self.new_power = newPower
    self.div = (newPower - oldPower) / 8
    self:changeLabel()
    self:updateLabel()
end

function PowerLayer:updateLabel()
    self:addTimer("power",200,handler(self,self.changeLabel),true)
end

function PowerLayer:changeLabel()
    self.old_power = math.ceil(self.old_power + self.div) >= self.new_power and self.new_power or math.ceil(self.old_power + self.div)
    self.lbl_power:setString("+" .. self.old_power)
    if self.old_power == self.new_power then 
        self.old_power = self.new_power 
        self:removeTimerByName("power")
        self:removeLayer()
    end
    
    -- if self.old_power == self.new_power then self:removeFromParent() end
end

function PowerLayer:removeLayer()
    local fandeout = cc.FadeOut:create(1)
    local callback = cc.CallFunc:create(function () 
        self:removeFromParent()
    end)
    local seq = cc.Sequence:create(fandeout,callback)
    self:runAction(seq)
    
end

return PowerLayer