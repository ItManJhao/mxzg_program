local CountryWarInvincibleCtr = class("CountryWarInvincibleCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CountryWarInvincibleLayer = class("CountryWarInvincibleLayer", require("src.comp.EventLayerAdaptiveWidth"))

-------------------------------------------------------------------------------------------------------------
function CountryWarInvincibleLayer:onCreate()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
    self:addBlackBackground()

    -- ex.EffectFactory:createEffectWithNodeByNameAsyn("countrywar_invincible", self.spr_bg, cc.p(0, 0), 1)
    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("countrywar_invincible", cc.CallFunc:create(function()
        if self.callback ~= nil then
            self.callback();
        end

        if self.callback_close ~= nil then
            self.callback_close();
        end
    end))
    self.node_effect:addChild(spr_effect)

    self.spr_invincible:setOpacity(0)
    self.spr_invincible:runAction(cc.Sequence:create(cc.FadeIn:create(0.6), cc.DelayTime:create(0.8), cc.FadeOut:create(0.8)))
end

-----------------------------------------------------------------------------
function CountryWarInvincibleCtr:onCreate()
    self:setCCBIPath("ccbi/CountryWarInvincibleLayer.ccbi")
    self:setIsSingle(false)
end

function CountryWarInvincibleCtr:getLayerClass()
    return CountryWarInvincibleLayer
end

function CountryWarInvincibleCtr:openWindow(callback)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData(callback)
end

function CountryWarInvincibleCtr:initData(callback)
    self.layer.callback = callback

    self.layer.callback_close = function()
        self:closeWindow()
    end
end

return CountryWarInvincibleCtr
