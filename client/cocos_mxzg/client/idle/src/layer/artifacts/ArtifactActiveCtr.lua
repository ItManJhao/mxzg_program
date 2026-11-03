local ArtifactActiveCtr = class("ArtifactActiveCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ArtifactActiveLayer = class("ArtifactActiveLayer", require("src.comp.EventLayerAdaptiveWidthFull"))

function ArtifactActiveLayer:onCreate()
    self:addBlackBackground()

    local rare = cc.Sprite:create() 
    self.btn_item:addChild(rare)
    rare:setPosition(self.btn_item:getContentSize().width / 2,self.btn_item:getContentSize().height / 2)
    self.btn_item.rare = rare

    local spr = cc.Sprite:create() 
    self.btn_item:addChild(spr)
    spr:setPosition(self.btn_item:getContentSize().width / 2,self.btn_item:getContentSize().height / 2)
    self.btn_item.icon = spr

    -- local scaleX = self.spr_bg:getContentSize().width / cc.Director:getInstance():getWinSize().width
    -- self.spr_bg:setScaleX(ex.s.global_scale)
    -- self.spr_bg:setScaleX(self.spr_bg:getContentSize().width/ 2)
    

    self.btn_item:registerScriptTapHandler(handler(self,self.onTips))
    self.btn_active:registerScriptTapHandler(handler(self,self.onActive))
    self:addEvent(EVENT.ARTIFACTS.ARTIFACT_ACTIVE,handler(self,self.closeWindow))
end

function ArtifactActiveLayer:closeWindow(event,data)
    ArtifactActiveCtr:instance():closeWindow()
end

function ArtifactActiveLayer:onTips(tag,pSender)
    print(self.__cname,tag,pSender)
    local data = {}
    data.equip = {sys_id = self.data.reiki_equip_id}
    local equip_list = {}
    equip_list[1] = self.data.reiki_equip_id
    data.equip_list = equip_list
    local ctr = require("src.layer.artifacts.ArtifactTipsCtr"):instance()
    ctr:openWindow()
    :addEquipInfo(data)
    dump(self.data)
end

function ArtifactActiveLayer:onActive(tag,pSender)
    print(self.__cname,tag,pSender)

    local has_num = ex.Player:getItemNum(self.data.cost_item[1].item_type)
    local can_active = has_num >= self.data.cost_item[1].item_num

    if not can_active then 
        -- ex.MessageView:add(string.format(ex.Tools:getLang(1108),ex.Tools:getLang(cfg.item.item[self.data.cost_item[1].item_type].name)))
        ex.Tools:onClickItemSrc(self.data.cost_item[1].item_type)
        return 
    end 

	local req = ReikiEquip_pb.GReqActiveReikiEquipPlace()
    req.hero_id = self.data.hero_id
    req.place = self.data.place
	NetManager:sendMessage(ProtocolID.GReqActiveReikiEquipPlace,req)
end

function ArtifactActiveLayer:updateLayer(data)
    self.data = data
    dump(data)
    local has_num = ex.Player:getItemNum(data.cost_item[1].item_type)
    local can_active = has_num >= data.cost_item[1].item_num
    -- self.btn_active:setEnabled(can_active)
    -- local normal_img = self.btn_active:getNormalImage()
    -- ex.Tools:setGrayAuto(normal_img,not can_active)

    local place = data.place
    
    self.btn_item.rare:setSpriteFrame(string.format("backpack/rare-%d.png",  cfg.item.item[data.reiki_equip_id].rare_mark)) 
    self.btn_item.icon:setSpriteFrame(string.format("backpack/%d.png",  data.reiki_equip_id)) 
    -- self.title:setSpriteFrame(string.format("artifacts/jihuo%d.png",place))
    -- self.tips:setSpriteFrame(string.format("artifacts/tips%d.png",place))

    ex.Tools:setSpriteFrame(self.title, string.format("artifacts/jihuo%d.png",place))
    ex.Tools:setSpriteFrame(self.tips, string.format("artifacts/tips%d.png",place))

    --cc.Sprite:createWithSpriteFrameName(string.format("backpack/%s.png", data.reiki_equip_id))
    
    
    self.btn_item:setEnableAction(false)
    self.lbl_name:setString(ex.Tools:getLang(cfg.item.item[data.reiki_equip_id].name))
    self:updateRes()
end

function ArtifactActiveLayer:updateRes()
    self.spr_res_need:setSpriteFrame(string.format("backpack/%d.png",  self.data.cost_item[1].item_type))
    self.lbl_res_need:setString(string.format(ex.Tools:getLang(75003),self.data.cost_item[1].item_num))
end


-----------------------------------------------------------------------------
function ArtifactActiveCtr:onCreate()
	self:setCCBIPath("ccbi/ArtifactActiveLayer.ccbi")
	self:setIsSingle(false)
end

function ArtifactActiveCtr:getLayerClass()
	return ArtifactActiveLayer
end

function ArtifactActiveCtr:getArtifactActiveLayer()
	return self.layer
end

function ArtifactActiveCtr:openWindow(data)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData(data)
end

function ArtifactActiveCtr:initData(data)
	local layer = self.layer

	self:updateLayer(data)

end

function ArtifactActiveCtr:updateLayer(data)
	if not self:getLayer() then
		return
	end
    local layer = self.layer
    layer:updateLayer(data)

end



return ArtifactActiveCtr
