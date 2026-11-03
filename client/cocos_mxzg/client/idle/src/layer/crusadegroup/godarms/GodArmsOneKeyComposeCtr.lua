--[[
    周向阳
    time:2020-09-24 14:18:50
]]
local GodArmsOneKeyComposeCtr = class("GodArmsOneKeyComposeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodArmsOneKeyComposeLayer = class("GodArmsOneKeyComposeLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function GodArmsOneKeyComposeCtr:getAsynImage()
    local vec_image = {
        -- {image_name = "ccbi-res/map-bg-blessing-pool-1.jpg", remove_type=1},
        {image_name = "ccbi-res/crusade-group.pvr.ccz", plist_name = "ccbi-res/crusade-group.plist", remove_type=2},
    }
    return vec_image
end
function GodArmsOneKeyComposeLayer:onCreate()
    self:addBlackBackground()
    local spr_bg = cc.Sprite:createWithSpriteFrameName("crusade-group/spr-seleted.png")
    spr_bg:setPosition(self.btn_compose_equip:getPosition())
    self.btn_content:add(spr_bg)
end

function GodArmsOneKeyComposeCtr:onCreate()
    self:setCCBIPath("ccbi/GodArmsOneKeyComposeLayer.ccbi")
    self:setIsSingle(false)


end

function GodArmsOneKeyComposeCtr:getLayerClass()
    return GodArmsOneKeyComposeLayer
end

function GodArmsOneKeyComposeCtr:GodArmsOneKeyComposeLayer()
    return self.layer
end

function GodArmsOneKeyComposeCtr:openWindow(hole, job, sb_id, corelv, iscompose, isdecompose, data)
    if self:isOpened() then
        return
    end
    self:loadLayer()
    self:open()
    self:initData(hole, job, sb_id, corelv, iscompose, isdecompose,data)
    self.need_data = {}
    self.need_data.hole = hole
    self.need_data.job = job
    self.need_data.sb_id = sb_id
    self.need_data.corelv = corelv
    self.need_data.iscompose = iscompose
    self.need_data.isdecompose = isdecompose

end

function GodArmsOneKeyComposeCtr:initData(hole, job, sb_id, corelv, iscompose, isdecompose,data)
   
    self.hole = hole
    self.job = job
    self.sb_id = sb_id
    self.corelv = corelv
    self.iscompose = iscompose
    self.isdecompose = isdecompose
    if data ~= nil and data.sb_id ~= 0 then
        self.hole = data.hole or 0
        self.job = data.job or 0
        self.sb_id = data.sb_id or 0
        self.corelv = data.corelv or 0
        self.iscompose = data.iscompose or 0
        self.isdecompose = data.isdecompose or 0
    end
    ex.EventManager:add(EVENT.CRUSADE_GROUP.UPDATE_GOD_ARMS_CLOSE, handler(self, self.closeWindow))
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_one_key:registerScriptTapHandler(handler(self, self.onCompose))
    self.id_tabel = {}
    self:updateData(sb_id)
end

--判断是否在最上方显示装备 true 显示
function GodArmsOneKeyComposeCtr:isAdd(sb_id)
    if self.id_tabel == nil or #self.id_tabel == 0 then
        return true
    else
        for i, v in ipairs(self.id_tabel) do
            if sb_id == v then
                for j = #self.id_tabel, i + 1, -1 do
                    table.remove(self.id_tabel, j)
                end
                return false
            end
        end
    end
    return true
end

function GodArmsOneKeyComposeCtr:updateData(sb_id)
    self.data = {}
    self.sb_id = sb_id
    local state = 0
    local isbe = false

    -- --在最上面添加点击的神兵
    if self:isAdd(sb_id) then
        table.insert(self.id_tabel, sb_id)
    else
        if #self.id_tabel > 0 then
            if #self.id_tabel >= 5 then
                return
            end
            for i = #self.id_tabel + 1, 5 do
                self.layer["btn_" .. i]:removeAllChildren()
            end
        end
    end
    --显示选中的状态
    self.layer.spr_seleted:setPosition(self.layer["btn_" .. #self.id_tabel]:getPosition())

    for i, v in ipairs(self.id_tabel) do
        local item = UIMenuItemBackpack:createWithData(v, 0)
        item:registerScriptTapHandler(handler(self, self.onClickItem))
        item:setScale(0.8)
        self.layer["btn_" .. i]:add(item)
    end

    self.layer.lbl_name:setString(ex.Tools:getLang(sb_id))

    --重置状态
    if #self.layer.btn_compose_equip:getChildren() ~= 0 then
        self.layer.btn_compose_equip:removeAllChildren()
    end
    for i = 1, 3 do
        --清除每个神兵按钮下的子节点
        if #self.layer["btn_material_show_" .. i]:getChildren() ~= 0 then
            self.layer["btn_material_show_" .. i]:removeAllChildren()
        end
        --重置线的状态
        self.layer["node_line_" .. i]:setVisible(false)
    end

    --把每个神兵所需要的材料放进新的表里
    self.item_need_2 = {}
    self.item_need_1 = {}
    self.equip = cfg.crusadegroupshenbin.crusadegroupshenbin
    -- self.tabel = ctr.crusade_group.data:getShenbinCost(sb_id)
    for i, v in ipairs(self.equip) do
        if sb_id == v.sb_id then
            if v.compose_item ~= nil and v.compose_item ~= "" and #v.compose_item ~= 0 then
                self.item_need_2 = v.compose_item
            else
                self.item_need_1 = v.compose_sb
            end
        end
    end

    --添加所选的神兵
    local item = UIMenuItemBackpack:createWithData(sb_id, 0)
    item:registerScriptTapHandler(handler(self, self.onClickItem))
    self.layer.btn_compose_equip:add(item)
    -- local spr_bg = cc.Sprite:createWithSpriteFrameName("crusade-group/spr-seleted.png")
    -- spr_bg:setPosition(self.layer.btn_compose_equip:getPosition())
    -- self.layer.btn_content:add(spr_bg)
    for i, v in ipairs(self.data) do
        table.remove(self.data, i)
    end

    self.role_god_arms_info = ctr.crusade_group.data.role_god_arms_info.roleShenBins
    ----------- 显示当前神兵所需要的总材料
    local god_arms_num = 0

    for j, k in ipairs(self.role_god_arms_info) do
        if k.item_type == 902048 then
            god_arms_num = k.itemNum
        end
    end
    local equip_need_material_num = ctr.crusade_group.data:getComposeEquip(sb_id, 1)
    self.layer.compose_need_num:setString(god_arms_num .. "/" .. equip_need_material_num)
    ex.Tools:setLimitWidth(self.layer.compose_need_num , self.layer.spr_compose_need_num:getContentSize().width - 30 )
    if god_arms_num < equip_need_material_num then
        self.layer.compose_need_num:setColor(cc.RED)
        state = 2
    else
        self.layer.compose_need_num:setColor(cc.WHITE)
        state = 1
    end
    ------------------

    --判断是否由最基础材料合成
    if self.item_need_2 ~= nil and self.item_need_2 ~= "" and #self.item_need_2 ~= 0 then
        table.insert(self.data, self.item_need_2[1])
        --生成最基础材料道具放到中间位置
        local item_1 = UIMenuItemBackpack:createWithData(self.item_need_2[1].item_type, nil)
        local lbl_num_text = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
        lbl_num_text:setString(god_arms_num .. "/" .. self.item_need_2[1].item_num)
        lbl_num_text:setPosition(item_1:getContentSize().width - 10 , 15)
        lbl_num_text:setAnchorPoint(1,0.5)
        ex.Tools:setLimitWidth(lbl_num_text,item_1:getContentSize().width * 0.8 )
        item_1:addChild(lbl_num_text,100)
        item_1:setScale(0.8)
        if god_arms_num < self.item_need_2[1].item_num then
            lbl_num_text:setColor(cc.RED)
            -- item_1:setNum(god_arms_num .. "/" .. self.item_need_2[1].item_num, cc.RED)
        end
        -- state = 2
        item_1:registerScriptTapHandler(handler(self, self.onClickItem))
        self.layer.btn_material_show_2:setPosition(self.layer.node_pos_1_1:getPosition())
        self.layer.btn_material_show_2:add(item_1)
        --显示并设置连接线的宽度
        self.layer.node_line_1:setVisible(true)
        self.layer.line_width:setContentSize(5, self.layer.line_width:getContentSize().height)
    else
        for i = 1, #self.item_need_1 do
            --通过合成材料的多少来设置材料显示的位置以及连接线的显示
            self.layer["btn_material_show_" .. i]:setPosition(self.layer["node_pos_" .. #self.item_need_1 .. "_" .. i]:getPosition())
            self.layer.line_width:setContentSize((#self.item_need_1 - 1) * 100 + 5, self.layer.line_width:getContentSize().height)
            self.layer["node_line_" .. #self.item_need_1]:setVisible(true)
        end

        for i, v in ipairs(self.item_need_1) do
            for j, k in ipairs(self.role_god_arms_info) do
                god_arms_num = 0
                if v.item_type == k.item_type then
                    god_arms_num = k.itemNum
                    break
                end
            end
            table.insert(self.data, v)
            --生成所需要合成的材料
            local item_2 = UIMenuItemBackpack:createWithData(v.item_type, nil)
            item_2:setScale(0.8)
            local lbl_num_text = cc.Label:createWithTTF("", FONT_DEFAULT_NAME_BOLD, 20)
            lbl_num_text:setString(god_arms_num .. "/" .. v.item_num)
            lbl_num_text:setPosition(item_2:getContentSize().width - 10 , 15)
            lbl_num_text:setAnchorPoint(1,0.5)
            ex.Tools:setLimitWidth(lbl_num_text,item_2:getContentSize().width * 0.8 )
            item_2:addChild(lbl_num_text,100)
            if god_arms_num < v.item_num then
                lbl_num_text:setColor(cc.RED)
                -- item_2:setNum(god_arms_num .. "/" .. v.item_num, cc.RED)
            end

            item_2:registerScriptTapHandler(handler(self, self.onClickItem))
            self.layer["btn_material_show_" .. i]:add(item_2)
        end
    end
    self.iscompose = state

    --合成神兵按钮状态的判断
    if self.iscompose == 0 then
    elseif self.iscompose == 1 then
        -- 一键合成
        self.layer.btn_one_key:setLabelText(ex.Tools:getLang(77863))
        if #self.item_need_1 == 0 then
            self.layer.btn_one_key:setLabelText(ex.Tools:getLang(77859))
        end
    elseif self.iscompose == 2 then
        -- 合成神兵
        self.layer.btn_one_key:setLabelText(ex.Tools:getLang(77859))
    else
        --无任何显示
    end
end

function GodArmsOneKeyComposeCtr:onCompose()
    if self.iscompose == 1 then
        require("src.layer.crusadegroup.godarms.GodArmsOneKeyComposeTipsCtr"):instance():openWindow(self.hole, self.job, self.corelv, self.sb_id, ctr.crusade_group.data:getComposeEquip(self.sb_id, 1), self.iscompose ,  self.need_data)
    elseif self.iscompose == 2 then
        -- 神兵材料不足，无法合成
        ex.MessageView:add(ex.Tools:getLang(77871))
    end
end

function GodArmsOneKeyComposeCtr:onClickItem(tag, pSender)
    if pSender.item_type == 902048 then
        ex.Tools:onClickItemInfo(pSender.item_type)
        return
    end
    self.id = pSender.item_type
    self:updateData(pSender.item_type)
end

return GodArmsOneKeyComposeCtr
