local ArtifactIllustrationCtr = class("ArtifactIllustrationCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ArtifactIllustrationLayer = class("ArtifactIllustrationLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

local ArtifactIllustrationCell = class("ArtifactIllustrationCell", require("src.comp.LuaLayerBase"))
function ArtifactIllustrationCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)
end

function ArtifactIllustrationCell:initData(data)
    self.data = data

    local item_config = cfg.item.item[data.equipment_type]
    self.lbl_name:setString(ex.Tools:getLang(item_config.name))
    self.lbl_suit_name:setString(ex.Tools:getLang(72400 + data.settype))
    -- self.spr_suit_icon:setSpriteFrame("artifact/spr-suit-type-"..data.settype..".png")
    ex.Tools:setSpriteFrame(self.spr_suit_icon, "artifact/spr-suit-type-"..data.settype..".png")
    
    self.spr_star_num:setSpriteFrame("backpack/lbl-star-"..data.star..".png")
    self.spr_item_icon:setSpriteFrame(""..item_config.icon..".png")
end

-----------------------------------------------------------------------------
function ArtifactIllustrationLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()

    self.scroll_view:setItemSize(cc.size(270,135))
    self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function ArtifactIllustrationCtr:onCreate()
	self:setCCBIPath("ccbi/ArtifactIllustrationLayer.ccbi")
	self:setIsSingle(false)
end

function ArtifactIllustrationCtr:getLayerClass()
	return ArtifactIllustrationLayer
end

function ArtifactIllustrationCtr:getArtifactIllustrationLayer()
	return self.layer
end

function ArtifactIllustrationCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function ArtifactIllustrationCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer_type = 1
    
    self:initScrollViewTab()
    self:updateLayer()
end

function ArtifactIllustrationCtr:initScrollViewTab()
    local menu_tab = cpp.UIMenu:create()
    menu_tab:setIsTouchInsideNode(self.layer.scroll_view_tab)
    menu_tab:setSwallowsTouches(false)
    menu_tab:setPosition(cc.p(0, 0))
    self.layer.scroll_view_tab:addChild(menu_tab)

    -- 添加导航条
    local margin_x, space_x, item_size, scale = 4, 10, nil, 1
    for i= 1, 5 do
        self.layer["btn_tab_"..i] = cpp.UIMenuItemTab:create("button/btn-tab-3.png", "button/btn-tab-4.png", "", 1, 1)
        self.layer["btn_tab_"..i]:setScale(scale)
        if not item_size then 
            item_size = self.layer["btn_tab_"..i]:getContentSize()
            item_size.width = item_size.width * scale
            item_size.height = item_size.height * scale
        end
        self.layer["btn_tab_"..i]:setTag(i)
        self.layer["btn_tab_"..i]:registerScriptTapHandler(handler(self, self.onTab))
        self.layer["btn_tab_"..i]:setAnchorPoint(ex.a.bottom_center)
        self.layer["btn_tab_"..i]:setPosition(margin_x + (i - 0.5) * item_size.width + (i - 1) * space_x, 0)
        menu_tab:addChild(self.layer["btn_tab_"..i])
        self.layer["btn_tab_"..i]:setLabelText(ex.Tools:getLang(72610 + i))
        self.layer["btn_tab_"..i]:setLabelColor(cc.c4b(122,71,45,255))
        self.layer["btn_tab_"..i]:setLabelOffset(cc.p(0, -3))
    end
    self.layer.scroll_view_tab:setContentSize(cc.size(2 * margin_x + 5 * item_size.width + (5 - 1) * space_x, self.layer.scroll_view_tab:getViewSize().height))
    self.layer.scroll_view_tab:setContentOffset(self.layer.scroll_view_tab:maxContainerOffset())

    self.layer.btn_tab_1:setChecked(true)
end

function ArtifactIllustrationCtr:updateLayer()
    if self.layer == nil then
        return
    end

    local item_list = {}
    for k,v in pairs(cfg.godequipment.godequipment) do
        if v.star == self.layer_type and v.rare > 3 then
            table.insert(item_list, v)
        end
    end
    table.sort(item_list, function(a, b)
        if a.settype ~= b.settype then return a.settype < b.settype end
        return a.equipment_type < b.equipment_type
    end)

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.nodeTouched = handler(self, self.onItemInfo)
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
        local cell = ArtifactIllustrationCell:createWithCCBIFile("ccbi/ArtifactIllustrationCell.ccbi")
        cell:setIgnoreAnchorPointForPosition(false)
        cell:setAnchorPoint(0.5, 0.5)
    
        cell:initData(data)
    
        return cell
    end

    self.layer.scroll_view:reloadData(item_list)
end

function ArtifactIllustrationCtr:onTab(tag, pSender)
    self.layer_type = tag

    self:updateLayer()
end

function ArtifactIllustrationCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.data.equipment_type)
end

return ArtifactIllustrationCtr