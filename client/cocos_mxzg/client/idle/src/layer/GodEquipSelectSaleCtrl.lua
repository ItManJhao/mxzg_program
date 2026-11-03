--[[
    func: 神装出售选择界面
    author:徐东浩
    time:2020-03-29 03:41:44
    版权所有:广州暗耀晶石网络信息科技有限公司
]]

local GodEquipSelectSaleCtr = class("GodEquipSelectSaleCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodEquipSelectSaleLayer = class("GodEquipSelectSaleLayer", require("src.comp.EventLayer"))

function GodEquipSelectSaleLayer:onCreate()
    self:addBlackBackground()

    self.btn_star_array = {}
    for i = GOD_EQUIP_STAR_GRADE.One, GOD_EQUIP_STAR_GRADE.Four do
        local btn = self["btn_star_"..i]
        btn:setChecked(false)
        btn:setTag(i)
        table.insert(self.btn_star_array, btn)
    end

    self.btn_rare_array = {}
    for i = GOD_EQUIP_RARE_GRADE.PuTong - 1, GOD_EQUIP_RARE_GRADE.XiYou - 1 do
        local btn = self["btn_rare_"..i]
        btn:setChecked(false)
        btn:setTag(i + 1)
        table.insert(self.btn_rare_array, btn)
    end
end

function GodEquipSelectSaleLayer:getSelected()
    local star_grade, rare_grade = 1, 1

    for i,v in ipairs(self.btn_star_array) do
        if v:isChecked() then
            star_grade = v:getTag()
            break
        end
    end

    for i,v in ipairs(self.btn_rare_array) do
        if v:isChecked() then
            rare_grade = v:getTag()
            break
        end
    end

    return star_grade, rare_grade
end

function GodEquipSelectSaleLayer:setDefault(star_grade, rare_grade)
    local btn = self.btn_star_array[star_grade]
    if btn then btn:setChecked(true) end

    btn = self.btn_rare_array[rare_grade - 1]
    if btn then btn:setChecked(true) end
end

-----------------------------------------------------------------------------
function GodEquipSelectSaleCtr:onCreate()
    self:setCCBIPath("ccbi/GodEquipSelectSaleLayer.ccbi")
    self:setIsSingle(false)

    self.ok_callback = nil
end    

function GodEquipSelectSaleCtr:getLayerClass()
    return GodEquipSelectSaleLayer
end    

function GodEquipSelectSaleCtr:getGodEquipSelectSaleLayer()
    return self.layer
end    

function GodEquipSelectSaleCtr:openWindow(callback)
    if self:isOpened() then
        return
    end

    self.ok_callback = callback

    self:loadLayer()
    self:open()
    self:updateLayer()

    self.layer.btn_cancel:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_ok:registerScriptTapHandler(handler(self, self.onOk))
end

function GodEquipSelectSaleCtr:updateLayer()
    self.layer:setDefault(GOD_EQUIP_STAR_GRADE.One, GOD_EQUIP_RARE_GRADE.PuTong)
end

function GodEquipSelectSaleCtr:onOk(tag ,pSender)
    local star_grade, rare_grade = self.layer:getSelected()

    -- 获得选择出售的神装
    local god_equip_list = ex.Player.backpack_data:getFreeGodEquipsForRareAndStar(rare_grade, star_grade)
    if not god_equip_list or #god_equip_list <= 0 then
        -- 没有选中的神装
        ex.MessageView:add(ex.Tools:getLang(72756))
        return 
    end

    require("src.layer.GodEquipSaleCtrl"):instance():openWindow(god_equip_list, self.ok_callback)
    self:closeWindow()
end

return GodEquipSelectSaleCtr
