-- 出征英雄卸下弹框
local CrusadeGroupUnloadCtr = class("CrusadeGroupUnloadCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupUnloadLayer = class("CrusadeGroupUnloadLayer", require("src.comp.EventLayerAdaptiveWidth"))
local CrusadeGroupHeroItem = require("src.layer.crusadegroup.CrusadeGroupHeroItem")

function CrusadeGroupUnloadLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)
end

function CrusadeGroupUnloadLayer:reloadData(data)
    local hero_icon = CrusadeGroupHeroItem:createWithCCBIFile("ccbi/CrusadeGroupHeroItem.ccbi")
    hero_icon:reloadData(data, CRUSADE_GROUP_HERO_ITEM_TYPE.UNLOAD)
    hero_icon:setIgnoreAnchorPointForPosition(false)
    hero_icon:setAnchorPoint(0.5, 0.5)
    hero_icon:setPosition(self.node_icon:getContentSize().width / 2, self.node_icon:getContentSize().height / 2)
    self.node_icon:addChild(hero_icon)

    self.lbl_tip = require("src.comp.RichTextEx"):create()
        :setFontSize(24)
        :setFontFace(FONT_DEFAULT_NAME_BOLD)
        :setAnchorPoint(0.5, 0.5)
    self.node_lbl:addChild(self.lbl_tip)

    local str = string.format(ex.Tools:getLang(77455), data.physical_strength)
    self.lbl_tip:setXmlTextLua(str)
    self.lbl_tip:formatText()
    self.lbl_tip:setPosition(self.lbl_tip:getContentSize().width / 4, self.lbl_tip:getContentSize().height / 2)
end

-----------------------------------------------------------------------------
function CrusadeGroupUnloadCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupUnloadLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupUnloadCtr:getLayerClass()
    return CrusadeGroupUnloadLayer
end

function CrusadeGroupUnloadCtr:openWindow(data)
    if self:isOpened() then
        return
    end

    self.layer_type = 1

    self:loadLayer()
    self:open()
    self:initData(data)
end

function CrusadeGroupUnloadCtr:initData(data)
    self.data = data
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_cancle:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_certain:registerScriptTapHandler(handler(self, self.onUnload))

    self.layer:reloadData(data)
end

function CrusadeGroupUnloadCtr:onUnload()
    ctr.crusade_group:requestUnloadHero(self.data.box_id)
    self:closeWindow()
end

return CrusadeGroupUnloadCtr
