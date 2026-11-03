--[[
    周向阳
    time:2020-09-24 14:18:50
]]
local GodArmsComposeCtr = class("GodArmsComposeCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local GodArmsComposeLayer = class("GodArmsComposeLayer", require("src.comp.EventLayerAdaptiveWidth"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function GodArmsComposeLayer:onCreate()
    self:addBlackBackground()

end

function GodArmsComposeCtr:onCreate()
    self:setCCBIPath("ccbi/GodArmsComposeLayer.ccbi")
    self:setIsSingle(false)
end

function GodArmsComposeCtr:getLayerClass()
    return GodArmsComposeLayer
end

function GodArmsComposeCtr:GodArmsComposeLayer()
    return self.layer
end

function GodArmsComposeCtr:openWindow(hole, job, sb_id, corelv, state)
    if self:isOpened() then
        return
    end
    self:loadLayer()
    self:open()
    self:initData(hole, job, sb_id, corelv, state)
end

function GodArmsComposeCtr:initData(hole, job, sb_id, corelv, state)
    self.equip = {}
    self.equip.hole = hole
    self.equip.job = job
    self.equip.sb_id = sb_id
    self.equip.corelv = corelv
    self.equip.state = state
    self.equip.num = 0
    local role_god_arms_info = ctr.crusade_group.data.role_god_arms_info.roleShenBins
	for i,v in ipairs(role_god_arms_info) do
		if  self.equip.sb_id == v.item_type then
            self.equip.num = v.itemNum
        end
	end
    self.layer.btn_compose:registerScriptTapHandler(handler(self, self.onCompose))
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.lbl_resolve_name:setAnchorPoint(cc.p(1,0.5))
    self.layer.lbl_resolve_name:setPositionX(230)
    self.layer.lbl_resolve_name:setString(ex.Tools:getLang(77504))
    self.layer.spr_node:removeAllChildren()
    for i=1,6 do
        self.layer["lbl_attribute_"..i]:setVisible(false)
    end
    self.layer.resolve_node:setVisible(false)

    local item = UIItemBackpack:createWithData(self.equip.sb_id, 0)
        item:setScale(0.8)
        -- 这个参数代表当前装备的状态 0 不可合成 1 可合成但未合成 2 可装备 3 已经穿戴装备，即为已经点亮 
        item.state = self.equip.state
        -- 装备部位
        item.tag = self.equip.hole
        -- item:registerScriptTapHandler(handler(self, self.onEquip))
        self.layer.spr_node:add(item)
    local shenbing = cfg.crusadegroupshenbin.crusadegroupshenbin
    for i, v in ipairs(shenbing) do
        if self.equip.sb_id == v.sb_id then
            self.layer.lbl_title:setString(ex.Tools:getLang(self.equip.sb_id))
            ex.Tools:setScale9SpriteFrame(self.layer.spr_quality, string.format("backpack-info/spr-banner-backpack-%d.png", v.quality))
            self.layer.lbl_quality:setString(ex.Tools:getLang(76845)..ex.Tools:getLang(77754 + v.quality))
            self.layer.equip_num:setString(string.format(ex.Tools:getLang(77858), self.equip.num))
            self.layer.lbl_describe:setString(ex.Tools:getLang(self.equip.sb_id))
            for j,k in ipairs(v.attr) do
                if k.attr == 101 or k.attr == 220 or k.attr == 223 or k.attr == 224 then
                    self.layer["lbl_attribute_"..j]:setString(ex.Tools:getLang(122000 + k.attr)..":".. k.value)
                else
                    self.layer["lbl_attribute_"..j]:setString(ex.Tools:getLang(122000 + k.attr)..":".. k.value / 10000 * 100 .."%") 
                end
                self.layer["lbl_attribute_"..j]:setVisible(true)
            end
        end
    end
    if self.equip.state == 0 then
        --合成方式
        self.layer.btn_compose:setLabelText(ex.Tools:getLang(77860))
    elseif self.equip.state == 1 then
        --合成神兵
        self.layer.btn_compose:setLabelText(ex.Tools:getLang(77859))
    elseif self.equip.state == 2 then
        --装备
        self.layer.btn_compose:setLabelText(ex.Tools:getLang(77861))
    elseif self.equip.state == 3 then
        --无任何显示
        self.layer.btn_compose:setVisible(false)
    elseif self.equip.state == 4 then
        --分解
        self.layer.btn_compose:setLabelText(ex.Tools:getLang(3921))
        self.layer.lbl_resolve_num:setString(self:getResolveNum())
        self.layer.resolve_node:setVisible(true)
    end
end

function GodArmsComposeCtr:getResolveNum(  )
    local config = cfg.crusadegroupshenbin.crusadegroupshenbin
    local config_1 = cfg.crusadegroupshenbinresolve.crusadegroupshenbinresolve
    for i,v in ipairs(config) do
        if v.sb_id == self.equip.sb_id then
            for i,j in ipairs(config_1) do
                if  v.quality == j.id then
                    local can_comopse = ctr.crusade_group.data:getMaterial(self.equip.sb_id, 1)
                    local resolvenum = can_comopse * j.percent / 100
                    return resolvenum
                end
            end
        end
    end
end

function GodArmsComposeCtr:onCompose()
    if self.equip.state == 2 then
        local is_not_skip = cc.UserDefault:getInstance():getBoolForKey("is_not_skip", false)
            require("src.layer.crusadegroup.godarms.GodArmsEquipTipsCtr"):instance():openWindow(ex.Tools:getLang(77864), 
            string.format(ex.Tools:getLang(77866)), 
            function()
                local req = CrusadeGroupShenBin_pb.GReqShenBinEquip()
                req.job = self.equip.job
                req.place = self.equip.hole
                NetManager:sendMessage(ProtocolID.GReqShenBinEquip,req)
                self:closeWindow()
            end,is_not_skip)
    elseif self.equip.state == 4 then
        --分解
        local req = CrusadeGroupShenBin_pb.GReqShenBinResolve()
        req.equip_type =  self.equip.sb_id
        req.equipNum =  self.equipNum or 1
        NetManager:sendMessage(ProtocolID.GReqShenBinResolve,req)
        self:closeWindow()
    else
        require("src.layer.crusadegroup.godarms.GodArmsOneKeyComposeCtr"):instance():openWindow( self.equip.hole,  self.equip.job,  self.equip.sb_id,  self.equip.corelv,  self.equip.state)
        self:closeWindow()
   end
end

return GodArmsComposeCtr
