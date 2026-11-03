local EquipCell = class("HeroEquipCell",require("src.comp.LuaLayerBase"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function EquipCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.menu:setSwallowsTouches(false)
	-- self.lbl_bat_tips:setString(ex.Tools:getLang(50))
	self.btn_up_change:registerScriptTapHandler(handler(self,self.onEquipChange))
    self.btn_up_change:setLabelText(ex.Tools:getLang(47326))
	-- self.btn_up_change:setLabelColor(FONT_BLACK)
	self.spr_select:setVisible(false)

	self.btn_up_change:setLabelSize(48)
	self.btn_up_change:setLabelColor(cc.WHITE)
    self.btn_up_change:setLabelOutLine(FONT_BLACK_C4B)


	self.text_refresh = require("src.comp.RichTextEx"):create()
    :setFontSize(20)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    :setAnchorPoint(0, 0.5)
    self.show_attr_rich:addChild(self.text_refresh)
    self.text_refresh:setPosition(0,0)

	-- self.btn_up_change:setLabelText(ex.Tools:getLang(47343))
	-- self.btn_up_change:setLabelColor(FONT_BLACK)
end

function EquipCell:onEquipChange(tag,pSender)

    local hero_id = ex.Player.hero_data.promote:getSelectHeroById()
    local place = cfg.equipmenttype.equip[self.data.item_type].place
    -- local req_equip_chang = cpp.ByteArray:create()
    -- req_equip_chang:writeInt(ProtocolID.GReqHeroEquipChange)
    -- req_equip_chang:writeInt64(hero_id)
    -- req_equip_chang:writeInt64(self.data.item_id)
	-- req_equip_chang:writeInt8(place)
	
	local req_equip_chang = Hero_pb.GReqHeroEquipChange()
	req_equip_chang.hero_id = hero_id
	req_equip_chang.sys_id = self.data.item_type
	NetManager:sendMessage(ProtocolID.GReqHeroEquipChange,req_equip_chang)

    -- print("hero_id = " .. hero_id , "equip_id = " .. equip_data.item_id , "place = " .. place)
    -- cpp.NetManager:instance():sendByteArray(req_equip_chang)
    local ctr = require("src.layer.HeroEquipCtr"):instance()
    ctr:closeWindow(nil,ctr.layer)
end

function EquipCell:reset(data)
	self.data = data 
	local item  = UIItemBackpack:createWithData(data.item_type, 0)
	self.menu:addChild(item)
	item:setPosition(20,20)

	self.lbl_name:setString(ex.Tools:getLang(data.item_type))

	self.lbl_score:setString(string.format( ex.Tools:getLang(54431), ex.Player.hero_data.equip:getEquipScore(data.item_type)))

	local data = cfg.equipmenttype.equip[data.item_type]
	if not data then return end 

	local str = ""
	for i,v in ipairs(data.ability) do

		local attstr = ex.Tools:getLang(2141000 + v.attr)
		attstr = ex.StringUtil.formatAttrStrNum(attstr, "##" , v.value, "<font color='#219A00'>%s</font>")
		str = str ..  string.format( "<br><font color='#7A472D'>%s</font></br>" , attstr)
	end

    self.text_refresh:setXmlTextLua(str)
    self.text_refresh:formatText()

    self.rich_height = self.text_refresh:getContentSize().height

    self.text_refresh:setContentSize(cc.size(225, self.text_refresh:getContentSize().height))

    self.text_refresh:setPosition(0,  self.text_refresh:getContentSize().height * 0.5 - 34)



end 

function EquipCell:getData()
	return self.data 
end

return EquipCell
