local HeroGodEquipStateCtr = class("HeroGodEquipStateCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local HeroGodEquipStateLayer = class("HeroGodEquipStateLayer", require("src.comp.EventLayerAdaptiveWidth"))


local HeroGodEquipStateCell = class("HeroGodEquipStateCell", require("src.comp.EventLayer"))
function HeroGodEquipStateCell:onCreate()
    self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	self.text_refresh = require("src.comp.RichTextEx"):create()
    :setFontSize(20)
    :setFontFace(FONT_DEFAULT_NAME_BOLD)
    :setAnchorTextShadow(true)
    :setWrapMode(1)
    :setAnchorPoint(0, 0.5)
    self.show_attr_rich:addChild(self.text_refresh)
    self.text_refresh:setPosition(0,0)
	

    self.btn_enter:registerScriptTapHandler(handler(self, self.onDoneEnter))
    self.btn_stone_down:registerScriptTapHandler(handler(self, self.onStoneDown))
    self.btn_stone_up:registerScriptTapHandler(handler(self, self.onStoneUp))

	self.btn_stone_up:setPosition(self.btn_enter:getPositionX(), self.btn_enter:getPositionY())

	self.btn_stone_up:setLabelSize(48)
	self.btn_stone_up:setLabelColor(cc.WHITE)
    self.btn_stone_up:setLabelOutLine(FONT_BLACK_C4B)

	self.btn_stone_up:setLabelText(ex.Tools:getLang(47482))
	self.btn_enter:setLabelText(ex.Tools:getLang(47343))

	self.btn_stone_down:setLabelSize(48)
	self.btn_stone_down:setLabelColor(cc.WHITE)
	self.btn_stone_down:setLabelOutLine(FONT_BLACK_C4B)
	
	self.btn_enter:setLabelSize(48)
	self.btn_enter:setLabelColor(cc.WHITE)
    self.btn_enter:setLabelOutLine(FONT_BLACK_C4B)
	
end 

function HeroGodEquipStateCell:setCallBack( enter_callback, stone_down_callback, stone_up_callback )
	self.btn_enter_callback = enter_callback
	self.btn_stone_down_callback = stone_down_callback
	self.btn_stone_up_callback = stone_up_callback
end


function HeroGodEquipStateCell:onShowInfo(tag,pSender)
    ex.Tools:onClickItemInfo(pSender.item_type, pSender.item_id)
end

function HeroGodEquipStateCell:onDoneEnter( tag,pSender)
	-- if self.btn_enter_callback then 
	-- 	self.btn_enter_callback(self.item_type)
	-- end 	
	local req = GodEquip_pb.GReqWearGodEquip()
	req.hero_id = self.hero_id
	req.equip_id = self.equip_data.item_id
	NetManager:sendMessage(ProtocolID.GReqWearGodEquip, req)

end

function HeroGodEquipStateCell:onStoneDown( tag,pSender)
	-- if self.btn_stone_down_callback then 

	-- 	self.btn_stone_down_callback(self.hero_now_place_data.jewel_id)
	-- end 


end

function HeroGodEquipStateCell:onStoneUp( tag,pSender)
	-- if self.btn_stone_up_callback then 
	-- 	self.btn_stone_up_callback(self.item_type)
	-- end 
	local req = GodEquip_pb.GReqDisboardGodEquip()
	req.equip_id = self.equip_data.item_id
	NetManager:sendMessage(ProtocolID.GReqDisboardGodEquip, req)
end

function HeroGodEquipStateCell:reset(data)
	self:initDone(data)
end 


function HeroGodEquipStateCell:initDone(new_equip_data)

	self.equip_data = new_equip_data.equip_data
	self.hero_id = 	new_equip_data.hero_id
	self.position = new_equip_data.position

	local config = cfg.item.item[self.equip_data.item_type]
	if not config then return end 

	local equip_ment_config = cfg.godequipment.godequipment[self.equip_data.item_type]
	if not equip_ment_config then return end 

	if self.equip_data.hero_id == 0 then 
		self.btn_enter:setVisible(true)
		self.btn_stone_down:setVisible(false)
		self.btn_stone_up:setVisible(false)

	else 
		self.btn_enter:setVisible(false)
		self.btn_stone_down:setVisible(false)
		self.btn_stone_up:setVisible(true)
	end 

	--加一个显示五片
	local equip_item = ex.Player.backpack_data:createWithData(self.equip_data.item_type, 1)
	equip_item.item_id = self.equip_data.item_id
	equip_item:setPosition(80, 80)
	equip_item:setScale(1)
	equip_item:registerScriptTapHandler(handler(self, self.onShowInfo))
	self.menu:addChild(equip_item)

	--mingcheng 
	self.lbl_name:setString(ex.Tools:getLang(config.name))
	self.lbl_score:setString("")
			
    -- ex.Tools:generationStar(self.stone_item, jeweltype_config.star, "other/star-%d.png", 0.6, -10, cc.p(self.stone_item:getContentSize().width * 0.5, 15), 1000)

	local str = ex.Tools:getLang(47340)
	for i,v in ipairs(equip_ment_config.ability) do

		local attstr = ex.Tools:getLang(2141000 + v.attr)
		attstr = ex.StringUtil.formatAttrStrNum(attstr, "##" , v.value, "<font color='#219A00'>%s</font>")		
		str = str ..  string.format( "<font color='#7A472D'>%s</font>，" , attstr)
	end

	local  flag = false
	for i,v in ipairs(self.equip_data.attrs) do
		local rand_attr = ex.Player.backpack_data:getgodequipmentrandomability(equip_ment_config.place, equip_ment_config.star, v.sys_id, v.level)
		
		for ki,kv in ipairs(rand_attr) do
				local attstr = ex.Tools:getLang(2141000 + kv.attr)
				attstr = ex.StringUtil.formatAttrStrNum(attstr, "##" , kv.value, "<font color='#219A00'>%s</font>")		
				
				if flag == false then 
					str = str ..  string.format( ex.Tools:getLang(47060) , attstr)
					flag = true 
				else 
					str = str ..  string.format( "<br><font color='#7A472D'>　　　%s</font></br>" , attstr)
				end 
		end 
	end



	-- str = str .. ex.Tools:getLang(47227)
	-- local need_rand_attr = false

	-- if need_rand_attr == false then 
	-- 	str = str .. ex.Tools:getLang(47549)
	-- end 

	-- str = str .. "</br>"

    self.item_star = equip_ment_config.star

    self.text_refresh:setXmlTextLua(str)
    self.text_refresh:formatText()

    self.rich_height = self.text_refresh:getContentSize().height

    self.text_refresh:setContentSize(cc.size(225, self.text_refresh:getContentSize().height))

    self.text_refresh:setPosition(0,  self.text_refresh:getContentSize().height * 0.5 - 34)

end 


------------------------------------------------
function HeroGodEquipStateLayer:onCreate()
	self:addBlackBackground()

	self.lbl_title:setString(ex.Tools:getLang(47679))

	local item_size = cc.size(550, 180)

    local viewSize = cc.size(self.spr_scroll_bg:getContentSize().width, self.spr_scroll_bg:getContentSize().height - 10 )


	item_size = cc.size(item_size.width , item_size.height + 10)
	
	local posx = self.spr_scroll_bg:getPositionX()
	local posy = self.spr_scroll_bg:getPositionY()
    self.tableView = ex.Tools:initTableView(self,{}, {HeroGodEquipStateCell,"ccbi/HeroStoneStateCell.ccbi"} , viewSize, 7 , cc.p(posx, posy))


end

function HeroGodEquipStateLayer:initDone(position, hero_id)

	self.position = position
	self.hero_id = hero_id
	self:updateScroll()
end


function HeroGodEquipStateLayer:checkNowPlace( )
	-- local hero_jewel_data = ex.Player.hero_data:getHeroJewelListForHeroid(self.hero_id)
	-- if not hero_jewel_data.jewel_list then hero_jewel_data.jewel_list = {} end 
	
	-- for i,v in ipairs(hero_jewel_data.jewel_list) do
	-- 	if v.place == self.position then 
	-- 		self.place_data = clone(v)
	-- 		return v.jewel_type
	-- 	end 
	-- end
	return nil
end


function HeroGodEquipStateLayer:updateScroll( )
    -- self.scroll_view:getContainer():removeAllChildren()

	local cur_jewel_type = 0
	if self:checkNowPlace( ) then 
		cur_jewel_type = self:checkNowPlace( )
	end 

	local item_list = ex.Player.backpack_data:getGodEquipByPlaceAndHeroid(self.position, self.hero_id)
    local index = 0
	self.cellList = {}

	-- 重新组装数据
	local deal_data_list = {}
	for i,v in ipairs(item_list) do
		local cur_equip_data = {}
		cur_equip_data.equip_data = v
		cur_equip_data.hero_id = self.hero_id
		cur_equip_data.position = self.position
		
		table.insert(deal_data_list, cur_equip_data)
	end

	local sort = function ( a, b )
		if a.equip_data.hero_id == b.equip_data.hero_id then 
			return a.equip_data.item_type > b.equip_data.item_type
		end
		return a.equip_data.hero_id > b.equip_data.hero_id		 
	end
	table.sort( deal_data_list, sort )

    self.tableView:initData(deal_data_list)
    self.tableView:reloadData()

end

------------------------------------------------
function HeroGodEquipStateCtr:onCreate()
	self:setCCBIPath("ccbi/HeroStoneStateLayer.ccbi")
	self:setIsSingle(false)
end

function HeroGodEquipStateCtr:getLayerClass()
	return HeroGodEquipStateLayer
end

function HeroGodEquipStateCtr:openWindow(position, hero_id)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:initDone(position, hero_id)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))

end

return HeroGodEquipStateCtr

