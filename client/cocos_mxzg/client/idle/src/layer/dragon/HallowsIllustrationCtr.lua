local HallowsIllustrationCtr = class("HallowsIllustrationCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HallowsIllustrationLayer = class("HallowsIllustrationLayer", require("src.comp.EventLayerAdaptiveWidth"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

-----------------------------------------------------------------------------
function HallowsIllustrationLayer:onCreate()
    self:setAutoClose(true)
    self:addBlackBackground()

    self.scroll_view:setItemSize(cc.size(125,125))
    -- self.scroll_view:setItemType(1)
end

-----------------------------------------------------------------------------
function HallowsIllustrationCtr:onCreate()
	self:setCCBIPath("ccbi/HallowsIllustrationLayer.ccbi")
	self:setIsSingle(false)
end

function HallowsIllustrationCtr:getLayerClass()
	return HallowsIllustrationLayer
end

function HallowsIllustrationCtr:getHallowsIllustrationLayer()
	return self.layer
end

function HallowsIllustrationCtr:openWindow()
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function HallowsIllustrationCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

    self.layer:addEvent(EVENT.DRAGON_EVENT.UPDATE_COLLECTION, handler(self, self.updateLayer))

    self.layer_type = 1
    
    self:initScrollViewTab()
    self:updateLayer()

    NetManager:sendMessage(ProtocolID.GReqDragonCollection)
end

function HallowsIllustrationCtr:initScrollViewTab()
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
        self.layer["btn_tab_"..i]:setLabelText(ex.Tools:getLang(74516 + i))
        self.layer["btn_tab_"..i]:setLabelColor(cc.c4b(122,71,45,255))
        self.layer["btn_tab_"..i]:setLabelOffset(cc.p(0, -3))
    end
    self.layer.scroll_view_tab:setContentSize(cc.size(2 * margin_x + 5 * item_size.width + (5 - 1) * space_x, self.layer.scroll_view_tab:getViewSize().height))
    self.layer.scroll_view_tab:setContentOffset(self.layer.scroll_view_tab:maxContainerOffset())

    self.layer.btn_tab_1:setChecked(true)
end

function HallowsIllustrationCtr:updateLayer()
    if self.layer == nil then
        return
    end

    local item_list = {}
    local collect_num = 0
    for _,v in pairs(cfg.dragonrelic.dragonrelic) do
        if v.star == self.layer_type then

            local data = clone(v)
            data.is_collect = false
            for _,v2 in pairs(ex.Player.dragon_data.vec_collection) do
                if v2 == data.relic_type then
                    data.is_collect = true
                    collect_num = collect_num + 1
                end
            end

            table.insert(item_list, data)
        end
    end
    table.sort(item_list, function(a, b)
        if a.is_collect ~= b.is_collect then return a.is_collect end
        return a.relic_type < b.relic_type
    end)

    self.layer.scroll_view:getContainer():removeAllChildren()
    self.layer.scroll_view.createItemFunction = function(data)
        -- 创建ccbi cell
		local item = UIMenuItemBackpack:createWithData(data.is_collect and data.relic_type or 1, 0)
        -- item:setScale(0.75)
        item:registerScriptTapHandler(handler(self, self.onItemInfo))
        
        if data.is_collect == nil or data.is_collect == false then
            item:setEnabled(false)
        end
    
        return item
    end

    self.layer.scroll_view:reloadData(item_list)

    -- 收集进度显示
    self.layer.lbl_num:setString(string.format(ex.Tools:getLang(74533), collect_num, #item_list))
end

function HallowsIllustrationCtr:onTab(tag, pSender)
    self.layer_type = tag

    self:updateLayer()
end

function HallowsIllustrationCtr:onItemInfo(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

return HallowsIllustrationCtr