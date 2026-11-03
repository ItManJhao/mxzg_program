-- 出征英雄选择弹框
local CrusadeGroupSetOffSelectCtr = class("CrusadeGroupSetOffSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local CrusadeGroupSetOffSelectLayer = class("CrusadeGroupSetOffSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))
local CrusadeGroupHeroItem = require("src.layer.crusadegroup.CrusadeGroupHeroItem")

function CrusadeGroupSetOffSelectLayer:onCreate()
    self:addBlackBackground()
    self:setAutoClose(true)
    self:setSwallowTouches(true)

    self.scroll_view:setItemSize(cc.size(120, 120))
    self.scroll_view:setItemType(1)
end

function CrusadeGroupSetOffSelectLayer:reloadData()
    local lbl_tip = require("src.comp.RichTextEx"):create():setFontSize(22):setFontFace(FONT_DEFAULT_NAME_BOLD):setAnchorPoint(0.5, 0.5)
    local str = string.format(
        ex.Tools:getLang(77935),
        cfg.system.crusade_group_init_energy
    )
    lbl_tip:setXmlTextLua(str)
    lbl_tip:formatText()
    local x, y = self.node_tip:getPosition()
    local size = self.node_tip:getContentSize()
    lbl_tip:setPosition(self.node_tip:getContentSize().width / 2, self.node_tip:getContentSize().height / 2)
    self.node_tip:addChild(lbl_tip)
    ex.Tools:setLimitWidth(lbl_tip, 500)

    self.scroll_view:getContainer():removeAllChildren()
    self.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = CrusadeGroupHeroItem:createWithCCBIFile("ccbi/CrusadeGroupHeroItem.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
        cell:reloadData(data, CRUSADE_GROUP_HERO_ITEM_TYPE.SET_OFF_SELECT)
        cell.btn_item.data = data
        cell.btn_item:registerScriptTapHandler(handler(self, self.onSelectItem))
        cell.menu:setSwallowsTouches(false)
        cell.menu:setIsTouchInsideNode(self.scroll_view)
        return cell
    end

    local hero_list = ctr.crusade_group:getCanSetOffHeroList()
    self.scroll_view:reloadData(hero_list)
end

function CrusadeGroupSetOffSelectLayer:onSelectItem(tag, sender)
    local cell = sender:getParent():getParent()
    if cell == self.select_item then
        return
    end

    if self.select_item and self.select_item.spr_selected then
        self.select_item.spr_selected:setVisible(false)
    end
    
    self.select_item = cell
    self.select_data = sender.data

    if cell then
        cell.spr_selected:setVisible(true)
    end
end

-----------------------------------------------------------------------------
function CrusadeGroupSetOffSelectCtr:onCreate()
    self:setCCBIPath("ccbi/CrusadeGroupSetOffSelectLayer.ccbi")
    self:setIsSingle(false)
end

function CrusadeGroupSetOffSelectCtr:getLayerClass()
    return CrusadeGroupSetOffSelectLayer
end

function CrusadeGroupSetOffSelectCtr:openWindow(box_id)
    if self:isOpened() then
        return
    end

    self.layer_type = 1

    self:loadLayer()
    self:open()
    self:initData(box_id)
end

function CrusadeGroupSetOffSelectCtr:initData(box_id)
    self.box_id = box_id

    self.layer.btn_certain:registerScriptTapHandler(handler(self, self.onSetOff))
    self.layer:reloadData()
end

function CrusadeGroupSetOffSelectCtr:onSetOff()
    if self.layer.select_data then
        local hero_id = self.layer.select_data.hero_id
        ctr.crusade_group:requestSetHero(self.box_id, hero_id)
    end

    self:closeWindow()
end

return CrusadeGroupSetOffSelectCtr
