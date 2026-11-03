--[[
    func: 神装选择界面
    author:徐东浩
    time:2020-04-01 16:23:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local GodEquipSelectCtr = class("GodEquipSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodEquipSelectLayer = class("GodEquipSelectLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function GodEquipSelectLayer:onCreate()
    self:addBlackBackground()

    self.btn_tabs = {}
    self.check_callback = nil
    self.filter_callback = nil

    self.menu_tab = cpp.UIMenu:create()
    self.menu_tab:setIsTouchInsideNode(self.btn_scroll_view)
    self.menu_tab:setSwallowsTouches(false)
    self.menu_tab:setPosition(cc.p(0, 0))
    self.btn_scroll_view:addChild(self.menu_tab)

    self.spr_box_size_origin = self.spr_box:getContentSize()
    self.scroll_view_size_origin = cc.size(self.spr_box_size_origin.width, self.spr_box_size_origin.height - 10)

    self.item_size = cc.Sprite:createWithSpriteFrameName("backpack/rare-0.png"):getContentSize()
    self.item_size = cc.size(self.item_size.width + 15, self.item_size.height + 12)

    self.scroll_view = require("src.comp.UIScrollViewBackpack"):createWithSize(self.scroll_view_size_origin)
    self.scroll_view:setPosition(0, 5)
    self.scroll_view:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.scroll_view:setItemSize(cc.size(self.item_size.width + 10, self.item_size.height + 10))
    self.scroll_view:setItemOffset(cc.p(0, 5))
    self.scroll_view:setCreateNum(4)
    self.spr_box:addChild(self.scroll_view)
end

function GodEquipSelectLayer:refreshTabBar(tab_kind, settype)
    self.menu_tab:removeAllChildren()

    local margin_x, space_x, item_size, scale = 4, 10, nil, 1
    for i= 1, #tab_kind do
        local item = cpp.UIMenuItemTab:create("button/btn-tab-1.png", "button/btn-tab-2.png", "", 1, 1)
        item:setScale(scale)
        if not item_size then 
            item_size = item:getContentSize()
            item_size.width = item_size.width * scale
            item_size.height = item_size.height * scale
        end
        item.local_data = tab_kind[i]
        item:registerScriptTapHandler(handler(self, self.onTabChange))
        item:setAnchorPoint(ex.a.bottom_center)
        item:setPosition(margin_x + (i - 0.5) * item_size.width + (i - 1) * space_x, 0)
        self.menu_tab:addChild(item)
        item:setLabelText(ex.Tools:getLang(72400 + tab_kind[i]))
        item:setLabelColor(FONT_BROWN)
        item:setLabelOffset(cc.p(0, -2))

        table.insert(self.btn_tabs, item)
    end
    self.btn_scroll_view:setContentSize(cc.size(2 * margin_x + #tab_kind * item_size.width + (#tab_kind - 1) * space_x, self.btn_scroll_view:getViewSize().height))
    self.btn_scroll_view:setContentOffset(self.btn_scroll_view:maxContainerOffset())

    self:setTabSelected(settype)
end

function GodEquipSelectLayer:isExistSelect(table, item_id)
    for k, v in pairs(table) do
        if v.item_id == item_id then
            return true
        end
    end

    return false
end

function GodEquipSelectLayer:refreshGodEquip(filter_data, cur_selected)
    self.scroll_view:setLoaded(false)
    
    self.scroll_view.createItemFunction = function(item_data, scale, index, pos)
        -- 添加对应物品
        local item = UIItemBackpack:createWithData(item_data.item_type, item_data.item_num)
        item:setScale(scale)
        item.local_data = item_data
        item:registerScriptTapHandler(handler(self, self.onShowInfo))
        
        local item_size = item:getContentSize()
        -- item_size.width = item_size.width * scale
        -- item_size.height = item_size.height * scale

        -- 添加复选框
        local menu_toggle = cpp.UIMenu:create()
        -- menu_toggle:setIsTouchInsideNode(self.btn_scroll_view)
        menu_toggle:setSwallowsTouches(true)
        menu_toggle:setPosition(cc.p(item_size.width, item_size.height))
        item:addChild(menu_toggle, 1000)
        
        local check_box = cpp.UIMenuItemCheckBox:create("button/btn-check-1.png", "button/btn-check-2.png", nil)
        check_box.local_data = item_data
        check_box:setScale(1)
        check_box:setIgnoreAnchorPointForPosition(false)
        check_box:setAnchorPoint(ex.a.center)
        local box_size = check_box:getContentSize()
        check_box:setPosition(-box_size.width / 2, 6 - box_size.height / 2)
        menu_toggle:addChild(check_box)
        check_box:registerScriptTapHandler(handler(self, self.onChecked))

        check_box:setChecked(self:isExistSelect(cur_selected, item_data.item_id))
        return item
    end

    self.scroll_view:reloadData(filter_data)
end

function GodEquipSelectLayer:onTabChange(tag ,pSender)
    if self.filter_callback then
        local settype = pSender.local_data
        self.filter_callback(settype)
    end
end

function GodEquipSelectLayer:onChecked(tag ,pSender)
    local is_check = pSender:isChecked()
    local equip = pSender.local_data

    if self.check_callback then
        if is_check ~= self.check_callback(is_check, equip) then
            pSender:setChecked(not is_check)
        end
    end
end

function GodEquipSelectLayer:onShowInfo(tag ,pSender)
	local equip = ex.Player.backpack_data:getGodEquipDataByID(pSender.local_data.item_id)
    local info_ctr = require("src.layer.heroinfo.HeroGodEquipAbilityInfoCtr"):instance()
    info_ctr:openWindow()
    :setDataInfo(equip)
    -- :addWearButtion(
    --     {str = ex.Tools:getLang(47751), call = handler(self, self.onGodEquipSaleDirect), data = equip }    ,            
    --     {str = ex.Tools:getLang(47618), call = handler(self, self.onGodEquipWash), data = equip},    
    --     {str = ex.Tools:getLang(47326), call = handler(self, self.onGodEquipWear), data = pSender.local_data.item_id},            
    --     {str = ex.Tools:getLang(47438), call = handler(self, self.onGodEquipMerge), data = nil}
    --     )
end

function GodEquipSelectLayer:refreshSelectLabel(num)
    self.lbl_selected:setString(string.format(ex.Tools:getLang(72508), num))
end

function GodEquipSelectLayer:setTabSelected(settype)
    for i,v in ipairs(self.btn_tabs) do
        v:setChecked(v.local_data == settype)
    end
end

-----------------------------------------------------------------------------
function GodEquipSelectCtr:onCreate()
    self:setCCBIPath("ccbi/GodEquipSelectLayer.ccbi")
    self:setIsSingle(false)

    self.ok_callback = nil
    self.cur_selected = {}  -- 选中神装
    self.god_equip_list = {}    -- 全部自由神装
    self.god_equip_kind = {}    -- 神装种类表
end

function GodEquipSelectCtr:getLayerClass()
    return GodEquipSelectLayer
end    

function GodEquipSelectCtr:getGodEquipSelectLayer()
    return self.layer
end

function GodEquipSelectCtr:openWindow(callback, selected_ids)
    if self:isOpened() then
        return
    end

    self.ok_callback = callback
    selected_ids = selected_ids or {}

    self:refreshData()

    self:setSelectList(selected_ids)

    self:loadLayer()
    self:open()
    self:updateLayer()

    self.layer.check_callback = handler(self, self.setCheckData)
    self.layer.filter_callback = handler(self, self.onFilter)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_ok:registerScriptTapHandler(handler(self, self.onOk))
end

function GodEquipSelectCtr:refreshData()
    self.god_equip_list = {}

    self.god_equip_list = ex.Player.backpack_data:getGodEquipByHeroid(0)
    table.sort(self.god_equip_list, handler(self, self.sortFunc))

    self.god_equip_kind = cfg.godequipment.getGodEquipGroupKind()
    table.insert(self.god_equip_kind, 1, 0)
end

function GodEquipSelectCtr:setSelectList(selected_ids)
    self.cur_selected = {}

    local find_equip = function(table, item_id)
        for k, v in pairs(table) do
            if v.item_id == item_id then
                return v
            end
        end
    end

    if selected_ids then
        for k, v in pairs(selected_ids) do
            local equip = find_equip(self.god_equip_list, v)

            if equip and (#self.cur_selected <= 0 or self.cur_selected[1].item_type == equip.item_type) then
                table.insert(self.cur_selected, equip)
            end
        end
    end
end

function GodEquipSelectCtr:sortFunc(a, b)
    return a.item_type > b.item_type
end

function GodEquipSelectCtr:filterList(equip_list, settype)
    if settype == 0 then
        return equip_list
    end

    local filter_data = {}

    for i, v in ipairs(equip_list) do
        local config = cfg.godequipment.getConfigByType(v.item_type)
        if config and config.settype == settype then
            table.insert(filter_data, v)
        end
    end

    table.sort(filter_data, handler(self, self.sortFunc))

    return filter_data
end

function GodEquipSelectCtr:updateLayer(settype)
    settype = settype or 0
    self.layer:refreshTabBar(self.god_equip_kind, settype)

    local filter_data = self:filterList(self.god_equip_list, settype)
    self.layer:refreshGodEquip(filter_data, self.cur_selected)

    self.layer:refreshSelectLabel(#self.cur_selected)
end

function GodEquipSelectCtr:onFilter(settype)
    settype = settype or 0

    local filter_data = self:filterList(self.god_equip_list, settype)
    self.layer:refreshGodEquip(filter_data, self.cur_selected)
end

function GodEquipSelectCtr:setCheckData(is_check, equip)
    if is_check then
        if #self.cur_selected > 0 then
            if self.cur_selected[1].item_type ~= equip.item_type then
                -- 类型不同，无法合并
                ex.MessageView:add(ex.Tools:getLang(72512))
                return not is_check
            end

            if #self.cur_selected >= 3 then
                -- 数量足够了
                ex.MessageView:add(ex.Tools:getLang(72511))
                return not is_check
            end
        end

        table.insert(self.cur_selected, equip)
    else
        for i, v in ipairs(self.cur_selected) do
            if v.item_id == equip.item_id then
                table.remove(self.cur_selected, i)
                break
            end
        end
    end

    self.layer:refreshSelectLabel(#self.cur_selected)

    return is_check
end

function GodEquipSelectCtr:onOk(tag ,pSender)
    local item_ids = {}

    local length = math.min(3, #self.cur_selected)
    for i = 1, length do
        table.insert(item_ids, self.cur_selected[i].item_id)
    end

    if self.ok_callback then
        self.ok_callback(item_ids)
    end

    self:closeWindow()
end

return GodEquipSelectCtr
