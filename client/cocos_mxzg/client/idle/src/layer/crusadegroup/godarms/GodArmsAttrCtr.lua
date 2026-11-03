local GodArmsAttrCtr = class("GodArmsAttrCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodArmsAttrLayer = class("GodArmsAttrLayer", require("src.comp.EventLayer"))

function GodArmsAttrLayer:onCreate()
    self:addBlackBackground()
end
-----------------------------------------------------------------------------
function GodArmsAttrCtr:onCreate()
    self:setCCBIPath("ccbi/GodArmsAttrLayer.ccbi")
    self:setIsSingle(false)
    self.attr_list = {{attr=220,value=0},{attr=201,value=0},{attr=223,value=0},{attr=102,value=0},{attr=224,value=0},
                    {attr=202,value=0},{attr=101,value=0},{attr=204,value=0},{attr=200,value=0},{attr=226,value=0},
                    {attr=227,value=0},{attr=207,value=0},{attr=222,value=0},{attr=203,value=0},{attr=212,value=0},
                    {attr=291,value=0},{attr=225,value=0}}
end

function GodArmsAttrCtr:getLayerClass()
    return GodArmsAttrLayer
end

function GodArmsAttrCtr:getGodArmsAttrLayer()
    return self.layer
end

function GodArmsAttrCtr:openWindow(attr_data)
    if self:isOpened() then
        return
    end

    self:loadLayer()
    self:open()
    self:initData(attr_data)
end

function GodArmsAttrCtr:initData(attr_data)
    local attr_list = {}

    --去重 找出每个属性
    for k, v in pairs(attr_data) do
        local boor = true
        if #attr_list ~= 0 then
            for i,j in ipairs(attr_list) do
                if v.attr == j.attr then
                    boor = false
                end 
            end
        end
        if boor then
            local data = clone(v)
            data.value = 0
            table.insert( attr_list, data ) 
        end   
    end

    for i, v in pairs(attr_list) do
        for j, k in pairs(attr_data) do
            if v.attr == k.attr then
               v.value = v.value + k.value
            end
        end
    end

    local spe_percentage = 0
    local atk_percentage = 0
    local hp_percentage = 0
    local def_percentage = 0

    for i,p in pairs(attr_list) do
        for i,v in ipairs(self.attr_list) do
            if p.attr == v.attr then
                v.value = p.value
            end
        end
       
    end
    self:updateView()
end

function GodArmsAttrCtr:updateView()

    local content_size = self.layer:getContentSize()
    for i, v in ipairs( self.attr_list) do
        local lbl_name = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)

        lbl_name:setString(ex.Tools:getLang(122000 + v.attr))
        if v.attr ~= 101 and v.attr ~= 220 and v.attr ~= 223 and v.attr ~= 224 then
            lbl_name:setString(ex.Tools:getLang(122000 + v.attr).."%")
        end
        lbl_name:setColor(FONT_LIGHT_YELLOW)
        lbl_name:setAnchorPoint(0, 0.5)
        lbl_name:setScale(0.5)
        lbl_name:setPosition(30, content_size.height - (i - 0.5) * 27 - 10)
        self.layer:addChild(lbl_name)

        local lbl_num = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 36)
        if v.attr ~= 101 and v.attr ~= 220 and v.attr ~= 223 and v.attr ~= 224 then
             lbl_num:setString(v.value / 100 + 100 .. "%")
            if v.value == 0 then
                lbl_num:setString(v.value .. "%")
            end
        else
            lbl_num:setString(v.value)
        end
        lbl_num:setColor(FONT_LIGHT_YELLOW)
        lbl_num:setAnchorPoint(1, 0.5)
        lbl_num:setScale(0.5)
        lbl_num:setPosition(content_size.width - 30, lbl_name:getPositionY())
        self.layer:addChild(lbl_num)
    end
end

return GodArmsAttrCtr
