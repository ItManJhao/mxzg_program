local HeroEquipCtr = class("HeroEquipCtr",require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local EquipChangeLayer = class("EquipChangeLayer",require("src.comp.EventLayerAdaptiveWidth"))

------------------------------------

function EquipChangeLayer:onCreate()
    self:addBlackBackground()
	self:setExitCallback(handler(self,self.onExitCB))
end

function EquipChangeLayer:onExitCB()

end

function EquipChangeLayer:showWearEquip( obj , equip  , size , margin)
    if equip == nil or equip.item_type == 0 then return end
    self.item = obj:createWithCCBIFile("ccbi/EquipCell.ccbi")
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
    local equip_data = ex.Player.hero_data.equip:getHeroEquip(hero_id)

    local itemSize = self.item:getContentSize()

    if equip_data.equip_list ~= nil and equip_data.equip_list[self.index] ~= nil then  
         size.height = size.height - itemSize.height - margin * 2
         self.item:setAnchorPoint(0,0)
         self.item:setPosition(10,10+size.height)
    end

     self.item:setAnchorPoint(0,0)
     self.item:setPosition(10,10+size.height)
end

function EquipChangeLayer:onClickDisboard(tag , pSender)
    
    local hero_id = ex.Player.hero_data.promote:getSelectHeroById()
    local equip_data = ex.Player.hero_data.equip:getHeroEquip(hero_id)
    local equip = equip_data.equip_list[self.index]
    local place = cfg.equipmenttype.equip[equip.item_type].place
    -- local req_equip_disboard = cpp.ByteArray:create()
    -- req_equip_disboard:writeInt(ProtocolID.GReqHeroEquipDisboard)
    -- req_equip_disboard:writeInt64(hero_id)
    -- req_equip_disboard:writeInt64(equip.item_id)
    -- req_equip_disboard:writeInt8(place)
    -- cpp.NetManager:instance():sendByteArray(req_equip_disboard)
    local req_equip_disboard = Hero_pb.GReqHeroEquipDisboard()
    req_equip_disboard.hero_id = hero_id
    req_equip_disboard.equip_id = equip.item_id
    NetManager:sendMessage(ProtocolID.GReqHeroEquipDisboard,req_equip_disboard)
    local ctr = require("src.layer.HeroEquipCtr"):instance()
    ctr:closeWindow(nil,ctr.layer)
end

------------------------------------

function HeroEquipCtr:onCreate()
	self:setCCBIPath("ccbi/EquipChangeLayer.ccbi")
	self:setIsSingle(false)
end

function HeroEquipCtr:getLayerClass()
	return EquipChangeLayer
end

function HeroEquipCtr:getEquipChangeLayer()
	return self.layer
end

function HeroEquipCtr:openWindow(data)
	if self:isOpened() then
		return
    end
    
	self:loadLayer()
	self:open()
	self:initData(data)
end

function HeroEquipCtr:initData(index)

    -- dump(equip_data)

	self:updateLayer(index)
end

function HeroEquipCtr:updateLayer(index)
    print(self.__cname,index)
	self.layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
	-- self.layer.data = data 
    self.layer.index = index 
    self.data = ex.Player.backpack_data:getEquipByPlace(index)
    local hero_id = ex.Player.hero_data.promote:getSelectHeroById()
    local equip_data = ex.Player.hero_data.equip:getHeroEquip(hero_id)
    local equip = equip_data.equip_list and equip_data.equip_list[index] or nil
    -- self.layer:showWearEquip(require("src.layer.EquipCell"),equip,handler(self,self.onClickDisboard))
    local equip_tyep = equip_data.equip_list[index] ~= nil and equip_data.equip_list[index].item_type or 0

    local data = {}
    for k,v in pairs(self.data) do
        if v.item_type ~= equip_tyep then 
            table.insert(data,v)
        end
    end


    local sort = function (a, b)
        local compA = a.item_type
        compA = compA + (cfg.item.item[a.item_type] and cfg.item.item[a.item_type].rare_mark * 1000000000 or 0)

        local compB = b.item_type
        compB = compB + (cfg.item.item[b.item_type] and cfg.item.item[b.item_type].rare_mark * 1000000000 or 0)

        return compA > compB
    end
    table.sort( data, sort )

    self.data = data
	local size = self.layer.spr_bg:getContentSize()
	size.width = size.width - 10
	size.height = size.height - 10
	local margin = 5
    self.layer:showWearEquip(require("src.layer.EquipCell"),equip,size , margin)
	self.layer.tableView = ex.Tools:initTableView(self.layer.spr_bg,self.data,{require("src.layer.EquipCell") , "ccbi/EquipCell.ccbi" },size,margin,cc.p(5,5))
end

return HeroEquipCtr
