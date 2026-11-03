--[[
    讨伐团开启提示界面
    在讨伐团开启阶段服务器推送调用
]]

local CrusadeGroupTipCtr = class("CrusadeGroupTipCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupTipLayer = class("CrusadeGroupTipLayer", require("src.comp.EventLayerAdaptiveWidth"))

-----------------------------------------------------------------------------
function CrusadeGroupTipLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

-----------------------------------------------------------------------------
function CrusadeGroupTipCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupTipLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupTipCtr:getLayerClass()
    return CrusadeGroupTipLayer
end

function CrusadeGroupTipCtr:openWindow()
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData()
end

function CrusadeGroupTipCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

    self:updateLayer()
end

function CrusadeGroupTipCtr:updateLayer()
    
end

-- 进入讨伐团场景
function CrusadeGroupTipCtr:onConfirm(tag, pSender)
    ex.JumpManager:jumpByAtom("main_crusade_group")

    local sign_up_ctr = require("src.layer.crusadegroup.CrusadeGroupSignUpCtr"):instance()
    if sign_up_ctr:isOpened() then
        sign_up_ctr:closeWindow()
    end

    self:closeWindow()
end

return CrusadeGroupTipCtr