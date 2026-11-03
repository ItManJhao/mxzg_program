local ArtifactSelectCtr = class("ArtifactSelectCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ArtifactSelectLayer = class("ArtifactSelectLayer",require("src.comp.EventLayerAdaptiveWidth"))

------------------------------------

function ArtifactSelectLayer:onCreate()
    self:addBlackBackground()
	self:setExitCallback(handler(self,self.onExitCB))
end

function ArtifactSelectLayer:onExitCB()

end

function ArtifactSelectLayer:showWearEquip( obj , equip  , size , margin)
    if equip == nil or equip.item_type == 0 then return end
    self.item = obj:createWithCCBIFile("ccbi/ArtifactSelectCell.ccbi")
    self.item:setName("wear_item")
    self.item.btn_up_change:registerScriptTapHandler(handler(self,self.onClickDisboard))
    self.spr_bg:addChild(self.item)
    
    self.item.btn_up_change:setLabelText(ex.Tools:getLang(47622))
    -- self.item.btn_up_change:setLabelColor(FONT_BLACK)

	self.item.btn_up_change:setLabelSize(48)
	self.item.btn_up_change:setLabelColor(cc.WHITE)
    self.item.btn_up_change:setLabelOutLine(FONT_BLACK_C4B)

    self.item:reset(equip)
    self.item.spr_select:setVisible(true)

    local hero_id = ex.Player.hero_data.promote:getSelectHeroById()
    local equip_data = ex.Player.hero_data.artifact:getArtifactDataByHeroId(hero_id)
    local equip = equip_data[self.index] or nil

    local itemSize = self.item:getContentSize()

    if equip then  
         size.height = size.height - itemSize.height - margin * 2
         self.item:setAnchorPoint(0,0)
         self.item:setPosition(10,10+size.height)
    end

     self.item:setAnchorPoint(0,0)
     self.item:setPosition(10,10+size.height)
end

function ArtifactSelectLayer:onClickDisboard(tag , pSender)
    
    local hero_id = ex.Player.hero_data.promote:getSelectHeroById()
    local equip_data = ex.Player.hero_data.artifact:getArtifactDataByHeroId(hero_id)
    local equip = equip_data[self.index]
    local place = cfg.reikiequip.reikiequip[equip.sys_id].place
    -- local req_equip_disboard = cpp.ByteArray:create()
    -- req_equip_disboard:writeInt(ProtocolID.GReqHeroEquipDisboard)
    -- req_equip_disboard:writeInt64(hero_id)
    -- req_equip_disboard:writeInt64(equip.item_id)
    -- req_equip_disboard:writeInt8(place)
    -- cpp.NetManager:instance():sendByteArray(req_equip_disboard)
    local req_equip_disboard = ReikiEquip_pb.GReqDisboardReikiEquip()
    -- req_equip_disboard.hero_id = hero_id
    req_equip_disboard.reiki_equip_id = equip.reiki_equip_id
    NetManager:sendMessage(ProtocolID.GReqDisboardReikiEquip,req_equip_disboard)
    local ctr = require("src.layer.artifacts.ArtifactSelectCtr"):instance()
    ctr:closeWindow(nil,ctr.layer)
end

------------------------------------

function ArtifactSelectCtr:onCreate()
	self:setCCBIPath("ccbi/ArtifactSelectLayer.ccbi")
	self:setIsSingle(false)
end

function ArtifactSelectCtr:getLayerClass()
	return ArtifactSelectLayer
end

function ArtifactSelectCtr:getArtifactSelectLayer()
	return self.layer
end

function ArtifactSelectCtr:openWindow(data)
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData(data)
end

function ArtifactSelectCtr:initData(index)

    -- dump(equip_data)

	self:updateLayer(index)
end

function ArtifactSelectCtr:updateLayer(index)
    print(self.__cname,index)
	self.layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
	-- self.layer.data = data 
    self.layer.index = index 
    self.data = ex.Player.hero_data.artifact:getNotWearArtifactByPlace(index)
    local hero_id = ex.Player.hero_data.promote:getSelectHeroById()
    local equip_data = ex.Player.hero_data.artifact:getArtifactDataByHeroId(hero_id)
    local equip = equip_data[index] or nil
    -- self.layer:showWearEquip(require("src.layer.ArtifactSelectCell"),equip,handler(self,self.onClickDisboard))
    -- local equip_tyep = equip_data[index] ~= nil and equip_data.equip_list[index].item_type or 0

    -- local data = {}
    -- for k,v in pairs(self.data) do
    --     if v.sys_id ~= sys_id then 
    --         table.insert(data,v)
    --     end
    -- end


    local sort = function (a, b)
        return a.sys_id > b.sys_id
        -- local compA = a.item_type
        -- compA = compA + (cfg.item.item[a.item_type] and cfg.item.item[a.item_type].rare_mark * 1000000000 or 0)

        -- local compB = b.item_type
        -- compB = compB + (cfg.item.item[b.item_type] and cfg.item.item[b.item_type].rare_mark * 1000000000 or 0)

        -- return compA > compB
    end
    table.sort( self.data, sort )

    -- self.data = data
	local size = self.layer.spr_bg:getContentSize()
	size.width = size.width - 10
	size.height = size.height - 10
	local margin = 5
    self.layer:showWearEquip(require("src.layer.artifacts.ArtifactSelectCell"),equip,size , margin)
	self.layer.tableView = ex.Tools:initTableView(self.layer.spr_bg,self.data,{require("src.layer.artifacts.ArtifactSelectCell") , "ccbi/ArtifactSelectCell.ccbi" },size,margin,cc.p(5,5))
end

return ArtifactSelectCtr
