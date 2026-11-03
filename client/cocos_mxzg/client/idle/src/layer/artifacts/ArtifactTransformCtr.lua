local ArtifactTransformCtr = class("ArtifactTransformCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ArtifactTransformLayer = class("ArtifactTransformLayer", require("src.comp.EventLayer"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function ArtifactTransformLayer:onCreate()
    -- self:setAutoClose(false)
    self:setSwallowTouches(false)
    self:addBlackBackground()
    self.btn_transform:registerScriptTapHandler(handler(self,self.onClickTransform))

	self.btn_lbl_text = cc.Label:createWithTTF(ex.Tools:getLang(75021), FONT_DEFAULT_NAME_BOLD, 24)
	self.btn_transform:addChild(self.btn_lbl_text)
	self.btn_lbl_text:setPosition(self.btn_transform:getContentSize().width / 2 , self.btn_transform:getContentSize().height / 2)
    self.btn_lbl_text:setColor(cc.c3b(255,255,255))
    self.btn_lbl_text:enableOutline(cc.c3b(131,43,22),2)
    
    for i=1,2 do
        local btn = self["btn_artifact_"..i]
        btn:setEnableAction(false)
        self:initBtn(btn)
    end

    self.cur_panel = require("src.layer.artifacts.ArtifactTransformItem"):createWithCCBIFile("ccbi/ArtifactTransformItem.ccbi")
    self.target_panel = require("src.layer.artifacts.ArtifactTransformItem"):createWithCCBIFile("ccbi/ArtifactTransformItem.ccbi")
    self:addChild(self.cur_panel)
    self:addChild(self.target_panel)
    self.cur_panel:setPosition(self.node_cur:getPosition())
    self.target_panel:setPosition(self.node_next:getPosition())
end

function ArtifactTransformLayer:initBtn(btn)

    local size = btn:getContentSize()
    btn.rare = cc.Sprite:create()
    btn.rare:setPosition(size.width / 2 , size.height / 2)
    btn:addChild(btn.rare)

    btn.icon = cc.Sprite:create()
    -- btn.icon:setVisible(false)
    btn:addChild(btn.icon)
    btn.icon:setPosition(btn:getContentSize().width / 2,btn:getContentSize().height / 2)

end

function ArtifactTransformLayer:updateBtn(btn,cfg_data)
    -- btn.icon:setVisible(true)
    btn.rare:setSpriteFrame(string.format("backpack/rare-%d.png",  cfg.item.item[cfg_data.idx].rare_mark))
    btn.icon:setSpriteFrame(string.format("backpack/%d.png",  cfg_data.idx))
end

function ArtifactTransformLayer:updateView( )
    local cur_cfg = cfg.reikiequip.reikiequip[self.data.sys_id]
    local transform_cfg = cfg.reikiequip.reikiequip[cur_cfg.transform_target]
    self:updateBtn(self.btn_artifact_1,cur_cfg)
    self:updateBtn(self.btn_artifact_2,transform_cfg)
    self.lbl_artifact_1:setString(ex.Tools:getLang(cfg.item.item[cur_cfg.idx].name))
    self.lbl_artifact_2:setString(ex.Tools:getLang(cfg.item.item[transform_cfg.idx].name))

    self:updateRes(cur_cfg.transform_cost)

    self.cur_panel:reset(cur_cfg)
    self.target_panel:reset(transform_cfg)
end

function ArtifactTransformLayer:updateRes(cost)
    local item_data = cost[1]
    local item_data = cost[1]
    local icon = self["spr_res_" .. 1]
    local lbl = self["lbl_res_" .. 1]
    local bg = self["res_bg_".. 1]
    icon:setSpriteFrame(string.format("backpack/%d.png",  item_data.item_type))
    local has_num = ex.Player:getItemNum(item_data.item_type)
    lbl:setString(string.format("%s/%s",ex.Tools:convertNumToStr(has_num),ex.Tools:convertNumToStr(item_data.item_num)))

    -- for i=1,2 do
    --     local item_data = cost[i]
    --     local icon = self["spr_res_" .. i]
    --     local lbl = self["lbl_res_" .. i]
    --     local bg = self["res_bg_".. i ]
    --     icon:setVisible(item_data ~= nil)
    --     lbl:setVisible(item_data ~= nil)
    --     bg:setVisible(item_data ~= nil)
    --     if item_data ~= nil then 
    --         icon:setSpriteFrame(string.format("backpack/%d.png",  item_data.item_type))
    --         local has_num = ex.Player:getItemNum(item_data.item_type)
    --         lbl:setString(string.format("%s/%s",has_num,item_data.item_num))
    --     end
    -- end
end

function ArtifactTransformLayer:onClickTransform(tag,pSender)
    local reiki_cfg = cfg.reikiequip.reikiequip[self.data.sys_id]
    local transform_cfg = reiki_cfg.transform_cost
    local has_num = ex.Player:getItemNum(transform_cfg[1].item_type)
    if has_num < transform_cfg[1].item_num then 
        ex.Tools:onClickItemSrc(transform_cfg[1].item_type)
        return 
    end
    local req = ReikiEquip_pb.GReqTransformReikiEquip()
    req.reiki_equip_id = self.data.reiki_equip_id
    NetManager:sendMessage(ProtocolID.GReqTransformReikiEquip,req)
    ArtifactTransformCtr:instance():closeWindow()
end


-----------------------------------------------------------------------------


function ArtifactTransformCtr:onCreate()
	self:setCCBIPath("ccbi/ArtifactTransformLayer.ccbi")
	self:setIsSingle(false)
end

function ArtifactTransformCtr:getLayerClass()
	return ArtifactTransformLayer
end

function ArtifactTransformCtr:getArtifactActiveLayer()
	return self.layer
end

function ArtifactTransformCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
    self:open()
    self.layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
	self:initData(data)
end

function ArtifactTransformCtr:initData(data)
    local layer = self.layer
    layer.data = data

	layer:updateView()

end

function ArtifactTransformCtr:updateLayer(data)
	if not self:getLayer() then
		return
	end
    local layer = self.layer
    layer:updateLayer(data)

end

return ArtifactTransformCtr
