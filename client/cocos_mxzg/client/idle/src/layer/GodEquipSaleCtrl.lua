--[[
    func: 神装出售界面
    author:徐东浩
    time:2020-03-30 16:13:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local GodEquipSaleCtr = class("GodEquipSaleCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodEquipSaleLayer = class("GodEquipSaleLayer", require("src.comp.EventLayer"))

function GodEquipSaleLayer:onCreate()
    self:addBlackBackground()

    self.col_num = 4

    self.lbl_desc = ex.Tools:createRichText(self.node_desc, "", 18, false, cc.tex2F(0, 0), CommonUIDefine.UIDefine.ComponentOriginType.LEFT_TOP, nil, 1, ex.a.left_top)
    self.lbl_desc:ignoreContentAdaptWithSize(false)
	self.lbl_desc:setWrapMode(1)
    self.lbl_desc:setContentSize(cc.size(self.node_desc:getContentSize().width * 2, self.node_desc:getContentSize().height * 2))
    
    self.menu = cpp.UIMenu:create()
    self.menu:setIsTouchInsideNode(self.scroll_view)
    self.menu:setSwallowsTouches(false)
    self.menu:setPosition(cc.p(0, 0))
    self.scroll_view:addChild(self.menu)
end

function GodEquipSaleLayer:refershTip(num)
    self.lbl_desc:setXmlTextLua(string.format(ex.Tools:getLang(72755), num))
end

function GodEquipSaleLayer:refreshRewardList(reward_list)
    self.menu:removeAllChildren()

    local count = #reward_list

    local count_row = math.ceil(count / self.col_num)

    local item_size, count_height = nil, 0
    local scale, margin_x, space_x, space_y, margin_top, margin_bottom = 0.87, 6, 6, 6, 6, 6
    for i,v in ipairs(reward_list) do
        local row, col = math.ceil(i / self.col_num), 1 + ((i - 1) % self.col_num)
        local item = ex.Tools:createBackpackItem(v.item_type, v.item_num)
        item:setScale(scale)
        if not item_size then
            item_size = item:getContentSize()
            item_size = cc.size(item_size.width * scale, item_size.height * scale)

            count_height = margin_bottom + margin_top + count_row * item_size.height + (count_row - 1) * space_y
            count_height = math.max(self.scroll_view:getViewSize().height, count_height)
        end

        self.menu:addChild(item)
        item:registerScriptTapHandler(handler(self, self.onItem))
        
        item:setPosition(margin_x + (col - 0.5) * item_size.width + (col - 1) * space_x, count_height - margin_top - (row - 0.5) * item_size.height - (row - 1) * space_y)
    end

    self.scroll_view:setContentSize(cc.size(self.scroll_view:getViewSize().width, math.max(self.scroll_view:getViewSize().height, count_height)))
    self.scroll_view:setContentOffset(self.scroll_view:minContainerOffset())
end

function GodEquipSaleLayer:onItem(tag, pSender)
    ex.Tools:onClickItemInfo(pSender.item_type)
end

-----------------------------------------------------------------------------
function GodEquipSaleCtr:onCreate()
    self:setCCBIPath("ccbi/GodEquipSaleLayer.ccbi")
    self:setIsSingle(false)

    self.ok_callback = nil
    self.sale_list = {}
end

function GodEquipSaleCtr:getLayerClass()
    return GodEquipSaleLayer
end

function GodEquipSaleCtr:getGodEquipSaleLayer()
    return self.layer
end

function GodEquipSaleCtr:openWindow(god_equip_list, callback)
    if self:isOpened() then
        return
    end

    self.sale_list = god_equip_list
    self.ok_callback = callback

    self:loadLayer()
    self:open()
    self:updateLayer()

    self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_ok:registerScriptTapHandler(handler(self, self.onOk))
end

function GodEquipSaleCtr:updateLayer()
    self.layer:refershTip(#self.sale_list)

    local res_list = self:getRecycleRes(self.sale_list)
    self.layer:refreshRewardList(res_list)
end

function GodEquipSaleCtr:getRecycleRes(list)
    local res_list = {}

    local add_res = function(type, num)
        for i,v in ipairs(res_list) do
            if v.item_type == type then
                v.item_num = v.item_num + num
                return
            end
        end

        table.insert(res_list, {item_type = type, item_num = num})
    end

    for i,v in ipairs(list) do
        local config = cfg.godequipment.getConfigByType(v.item_type)
        for j, item_data in ipairs(config.recover_reward) do
            add_res(item_data.item_type, item_data.item_num)
        end

        if v.wash_num > 0 then  -- 洗练过，则计算洗练资源
            local config = cfg.godequipmentrare.getConfigByRare(config.rare)
            for i2, v2 in ipairs(config.wash_cost) do
                add_res(v2.item_type, v2.item_num * v.wash_num)
            end
        end
    end

    return res_list
end

function GodEquipSaleCtr:onOk(tag ,pSender)
    if self.ok_callback then
        self.ok_callback(self.sale_list)
    end

    self:closeWindow()
end

return GodEquipSaleCtr
