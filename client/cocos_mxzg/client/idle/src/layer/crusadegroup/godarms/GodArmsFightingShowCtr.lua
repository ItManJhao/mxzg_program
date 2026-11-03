local GodArmsFightingShowCtr = class("GodArmsFightingShowCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodArmsFightingLayer = class("GodArmsFightingLayer", require("src.comp.EventLayer"))

function GodArmsFightingLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()

    for i=1,3 do
        self["lbl_num_"..i]:setPositionX(self["lbl_name_"..i]:getContentSize().width + self["lbl_name_"..i]:getPositionX())
    end
end
-----------------------------------------------------------------------------
function GodArmsFightingShowCtr:onCreate()
    self:setCCBIPath("ccbi/GodArmsFightingLayer.ccbi")
    self:setIsSingle(false)
end

function GodArmsFightingShowCtr:getLayerClass()
    return GodArmsFightingLayer
end

function GodArmsFightingShowCtr:getGodArmsFightingLayer()
    return self.layer
end

function GodArmsFightingShowCtr:openWindow(base,all)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData(base,all)
end

function GodArmsFightingShowCtr:initData( base,all )

    local fighting = math.floor( all / base * 10000 )  
    self.layer.lbl_num_1:setString(base)
    self.layer.lbl_num_2:setString(all)
    if fighting > 0 then
        self.layer.lbl_num_3:setString(fighting / 100 .. "%")
    else
        self.layer.lbl_num_3:setString(0 .. "%")
    end
    
    
end

return GodArmsFightingShowCtr
