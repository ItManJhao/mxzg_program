local MakeEquipOneKeyTipsCtr = class("MakeEquipOneKeyTipsCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local MakeEquipOneKeyTipsLayer = class("MakeEquipOneKeyTipsLayer", require("src.comp.EventLayer"))

function MakeEquipOneKeyTipsLayer:onCreate()
	self:addBlackBackground()
	local hs_ctr = MakeEquipOneKeyTipsCtr:instance()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);
	-- ex.Player.hero_data.promote:resetStarCount()
	-- self.hero_data = ex.Player.hero_data.promote:getSelectHero()

	-- self.select_list = {}


	self.viewSize = cc.size(474, 166)

	self.scroll_view = cc.ScrollView:create(self.viewSize)
    :setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    :setPosition(51, 98)
    self:addChild(self.scroll_view)
    -- self:setExitCallback(handler(self,self.onExitCB))

    self.lbl_btn_update = cc.Label:createWithTTF(ex.Tools:getLang(47589), FONT_DEFAULT_NAME_BOLD, 32)
    self.btn_confirm:addChild(self.lbl_btn_update)
    self.lbl_btn_update:setPosition(self.btn_confirm:getContentSize().width / 2,self.btn_confirm:getContentSize().height / 2)
    self.lbl_btn_update:enableOutline(ex.c3b.BLUE, 1)

end

function MakeEquipOneKeyTipsLayer:onExit()
	-- ex.Player.hero_data.equip:setOneKeyNeedGold(0)
end


-----------------------------------------------------------------------------
function MakeEquipOneKeyTipsCtr:ctor()
	local ccbi_file = "ccbi/MakeEquipOneKeyTipsLayer.ccbi"
	self:setCCBIPath(ccbi_file)
	self:registerCCBLoader()
	self:setIsSingle(false)
end

function MakeEquipOneKeyTipsCtr:loadLayer()
	local layer = MakeEquipOneKeyTipsLayer
	local ccbi_file = self:getCCBIPath()
	self.layer = layer:create(ccbi_file)
	self:setLayer(self.layer)

    -- 创建点击事件
    self:registerTouchListen()
end


function MakeEquipOneKeyTipsCtr:getMakeEquipOneKeyTipsLayer()
	return self.layer
end

function MakeEquipOneKeyTipsCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function MakeEquipOneKeyTipsCtr:initData(data)
	self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))

	self:updateLayer(data)
end

function MakeEquipOneKeyTipsCtr:updateLayer(data)
	-- dump(data, "MakeEquipOneKeyTipsCtr:updateLayer")

	local layer = self.layer
	layer.index = self.index
	self.data = data
	local function sor(a,b)
		local typeA = a.max_compose_type
		local typeB = b.max_compose_type
		return typeA > typeB
	end
	table.sort(self.data.equip,sor)
	local equips = data.equip

	local srcoll_view = layer.scroll_view

	local height 
	srcoll_view:getContainer():removeAllChildren()
	local menu = cpp.UIMenu:create()
    :setIsTouchInsideNode(srcoll_view)
    :setSwallowsTouches(false)
    :setPosition(cc.p(0, 0))
    srcoll_view:getContainer():addChild(menu)
    local UIMenuItemHero = require("src.comp.menu.UIMenuItemBackpack")
	local cell_content 
	local scale = 0.8
    if #equips > 0 then 
	    for i=1,#equips do

			local cell_props = UIMenuItemHero:createWithData(equips[i].max_compose_type,0)
			cell_props:setNumByStr(equips[i].compose_num)
			cell_content = cell_props:getContentSize()
			menu:add(cell_props)
			cell_props:registerScriptTapHandler(handler(self,self.onClickHero))
			if not height then height = math.ceil((#equips / 5)) * (cell_content.height+10) end

			local idx = (i - 1) % 5
			local posX = (cell_content.width + 10) * (idx) * scale + 15
			local posY = height - (math.ceil(i / 5)) * (cell_content.height + 10) * scale
			cell_props:setAnchorPoint(0,0)
			cell_props:setPosition(posX,posY)
			cell_props.lbl_str:setScale(0.4)
			cell_props:setScale(scale)
		end

		local size = cc.size(layer.viewSize.width,math.ceil((#equips / 5)) * (cell_content.height+10) + 10)
		srcoll_view:setContentSize(size)
		srcoll_view:setContentOffset(cc.p(0,layer.viewSize.height - height)) 
		-- srcoll_view:setTouchEnabled(false)
	end
	layer.lbl_select:setString(string.format(ex.Tools:getLang(41040),data.need_gold)) 
	layer.btn_confirm:registerScriptTapHandler(handler(self,self.enterMake))
	ex.Player.hero_data.equip:setOneKeyNeedGold(data.need_gold)
end

function MakeEquipOneKeyTipsCtr:onClickHero(tag,pSender)
	local config = cfg.equipmenttype.equip[pSender:getType()]
	local ctr = require("src.layer.AbilityInfoCtr"):instance()
	ctr:openWindow()
	:addEquipInfo(config,{})
end

function MakeEquipOneKeyTipsCtr:enterMake(tag,pSender)

	local hasNum = ex.Player:getItemNum(ItemType.IT_GOLD)

	if hasNum < self.data.need_gold then 
		ex.MessageView:add(string.format(ex.Tools:getLang(1108),
            ex.Tools:getLang(ItemType.IT_GOLD)))
		return 
	end 


	local max_compose_type = 0
	for i,v in ipairs(self.data.equip) do
		if v.max_compose_type > max_compose_type then 
			max_compose_type = v.max_compose_type
		end
	end


	print("xxx", cfg.equipmenttype.equip[max_compose_type].place)

	local req_make_all = BackPack_pb.GReqOneKeyMakeEquip()
	req_make_all.equip_type = cfg.equipmenttype.equip[max_compose_type].place
    NetManager:sendMessage(ProtocolID.GReqOneKeyMakeEquip, req_make_all)

    print(ex.Player.gold,self.data.need_gold)
	self:closeWindow(nil,self.layer)
end

return MakeEquipOneKeyTipsCtr
