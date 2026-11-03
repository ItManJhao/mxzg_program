local HeroMagicWandSelectCtr = class("HeroMagicWandSelectCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local HeroMagicWandSelectLayer = class("HeroMagicWandSelectLayer", require("src.layer.ui.UI_HeroMagicWandSelectLayer"))
------------------------------------------------
function HeroMagicWandSelectLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroMagicWandSelectLayer")

	self:addBlackBackground()
	self.type = 0
	self.type_sub = 1
	self.hero_id = 0
	ex.Tools:setLimitWidth(self.lbl_title, 150)
	ex.Tools:setLimitWidth(self.btn_get:getLabel(), 120)
	ex.Tools:setLimitWidth(self.btn_illustrate:getLabel(), 120)
	ex.Tools:setLimitWidth(self.btn_preview:getLabel(), 120)
	ex.Tools:setLimitWidth(self.lbl_tip2, 520)
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_WEAR, handler(self, self.updateLayer))
end

function HeroMagicWandSelectLayer:resetData(type, hero_id)
	self.type, self.hero_id = type, hero_id;

	self:updateLayer()
end

function HeroMagicWandSelectLayer:updateLayer()
	self["btn_tab"..self.type_sub]:setChecked(true)
	
	if self.type == 0 then
		self.lbl_title:setString(ex.Tools:getLang(57172))

		self:updateIllustrate()
		self.lbl_tip1:setVisible(false)
		self.lbl_tip2:setVisible(false)
		self.lbl_tip3:setVisible(false)

		-- self.btn_get:setVisible(false)
		self.btn_preview:setVisible(false)
		self.btn_illustrate:setVisible(false)
		self.btn_get:setPositionX(self.btn_illustrate:getPositionX())
	else
		self.lbl_title:setString(ex.Tools:getLang(57186)) 
		self.btn_get:setPositionX(self.btn_illustrate:getPositionX() - (self.btn_preview:getPositionX() - self.btn_illustrate:getPositionX()))
		self:updateSelect()
	end
	ex.Tools:setTabBtnWidth({self.btn_tab1, self.btn_tab2, self.btn_tab3, self.btn_tab4, self.btn_tab5, self.btn_tab6}, 95)
end

function HeroMagicWandSelectLayer:updateIllustrate()
	self.scroll_view.createItemFunction = function(data, scale)
		local item = require("src.layer.heromagicwand.HeroMagicWandIllustrateCell"):create()
		item:resetData(data)
		return item
	end

	local data = TableEx.getTableByTag(cfg.magicwandtype.magicwandtype, function(v)
		return v.type == 0 or v.type == self.type_sub
	end)

	table.sort(data, function(a, b)
		if a.rare ~= b.rare then
			return a.rare > b.rare
		end
		
		return a.type_id > b.type_id
	end)

    self.scroll_view:reloadData(data)
end

function HeroMagicWandSelectLayer:updateSelect()
	self.scroll_view.createItemFunction = function(data, scale)
		local item = require("src.layer.heromagicwand.HeroMagicWandSelectCell"):create()
		item:resetData(data.magic_id, data, handler(self, self.onWear))
		if item.setScrollView ~= nil then
			item:setScrollView(self.scroll_view)
		end
		return item
	end

	local data = ex.Player.backpack_data:getFreeMagicWandForType(self.type_sub)
    self.scroll_view:reloadData(data)
end

function HeroMagicWandSelectLayer:onTab(tag)
	if self.type_sub == tag then
		return
	end

	self.type_sub = tag
	self:updateLayer()
end

function HeroMagicWandSelectLayer:onWear(magic_id, item)
	if self.hero_id == 0 then
		return
	end

	local req = HeroMagicWand_pb.GReqHeroMagicWandOn()
	req.hero_id = self.hero_id
	req.magic_id = magic_id
	NetManager:sendMessage(ProtocolID.GReqHeroMagicWandOn, req)
end

function HeroMagicWandSelectLayer:onIllustrate()
	HeroMagicWandSelectCtr:instance():closeWindow()
	HeroMagicWandSelectCtr:instance():openWindow(0)
end

function HeroMagicWandSelectLayer:onGet()
	if ex.JumpManager:checkOpenConditionByAtom("main_country_war") then
		require("src.comp.LuaNodeCtr"):closeOtherWindow()
		ex.JumpManager:jumpByAtom("main_country_war")
	end
end

function HeroMagicWandSelectLayer:onPreview()
	require("src.layer.heromagicwand.HeroMagicWandPreviewCtr"):instance():openWindow()
end

-----------------------------------------------
function HeroMagicWandSelectCtr:loadLayer()
	local tmp_layer = HeroMagicWandSelectLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroMagicWandSelectCtr:onCreate()
	self:setIsSingle(false)
end

function HeroMagicWandSelectCtr:openWindow(type, hero_id)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self.layer:resetData(type, hero_id)
    -- self.layer:updateLayer()
end

return HeroMagicWandSelectCtr

