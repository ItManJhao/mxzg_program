local HeroMagicWandWearCtr = class("HeroMagicWandWearCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMagicWandWearLayer = class("HeroMagicWandWearLayer", require("src.layer.ui.UI_HeroMagicWandWearLayer"))
------------------------------------------------
function HeroMagicWandWearLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroMagicWandWearLayer")

	-- self:runEnterAnim()
	self.hero_id = 0
	
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_WEAR, handler(self, self.updateLayer))
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_STRENGTHEN, handler(self, self.updateLayer))
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_REFINE, handler(self, self.updateLayer))
end

function HeroMagicWandWearLayer:resetData(hero_id)
	self.hero_id = hero_id
	self:updateLayer()
end

function HeroMagicWandWearLayer:updateLayer()

	local magic_data = ex.Player.hero_data.magic_wand:getMagicWandByHeroId(self.hero_id)
	local c = ex.Tools:getSysCfg("magic_wand_strengthen_unlock_level")
	local list_level = ex.StringUtil.splist(c, "_")

	
	local red = magic_data and ex.Player.hero_data.magic_wand:checkStrengthenReddotByData(magic_data) or false
	ex.Tools:addRedPoint(self.btn_up_level, red, cc.p(0.9,0.9))

	if magic_data then
		self.lbl_tip_null:setVisible(false)
		self.btn_select:setVisible(false)

		self.btn_info:setVisible(true)
		self.btn_preview:setVisible(true)
		self.btn_equip:setVisible(true)

		self.node_attr1:setVisible(true)
		self.node_attr2:setVisible(true)
		self.btn_up_level:setVisible(true)
		self.btn_refine:setVisible(true)
		self.btn_take_off:setVisible(true)
		self.btn_wear:setVisible(true)

		self.btn_equip:refreshData(magic_data.item_type, 0, magic_data.magic_id)
		self.btn_equip:setStrengthen(magic_data.strengthen_lv)

		local attr_visible_list, level_list = ex.Player.hero_data.magic_wand:getRandAttrVisible(magic_data.item_type, magic_data.strengthen_lv)
		
		for i,v in ipairs(magic_data.base_attrs) do
			self["lbl_attr"..i]:setString(ex.Tools:getAttrText(v.attr_id, v.attr_value_old))
			ex.Tools:setSpriteFrameAsyn(self["spr_icon"..i], string.format("hero-info-2/spr-attribute-%s.png", v.attr_id), "hero-info-2")
		end
	
		for i,v in ipairs(magic_data.random_attrs) do
			self["lbl_attr_rand"..i]:setString(ex.Tools:getAttrText(v.attr_id, v.attr_value_old))
		end
		
		for i=1, 4 do
			self["node_attr_rand"..i]:setVisible(attr_visible_list[i] > 0)
			if attr_visible_list[i] == 1 then
				self["lbl_attr_rand"..i]:setString(string.format(ex.Tools:getLang(57164), i, level_list[i]))
			end

			if attr_visible_list[i] == 2 then
				ex.Tools:setSpriteFrameAsyn(self["spr_icon_rand"..i], "hero-info-2/spr-act-1.png", "hero-info-2")
			end
		end
	else
		self.lbl_tip_null:setVisible(true)
		self.btn_select:setVisible(true)

		self.btn_info:setVisible(false)
		self.btn_preview:setVisible(false)
		self.btn_equip:setVisible(false)

		self.node_attr1:setVisible(false)
		self.node_attr2:setVisible(false)
		self.btn_up_level:setVisible(false)
		self.btn_refine:setVisible(false)
		self.btn_take_off:setVisible(false)
		self.btn_wear:setVisible(false)

		for i=1, 4 do
			local s = ""
			if i == 1 then
				s = "???"
			else
				s = string.format(ex.Tools:getLang(57209), i, list_level[i-1])
			end

			self["lbl_attr_rand"..i]:setString(s)
		end
	end
end

function HeroMagicWandWearLayer:onSelectEquip()
	require("src.layer.heromagicwand.HeroMagicWandSelectCtr"):instance():openWindow(1, self.hero_id)
end

function HeroMagicWandWearLayer:onEquip()
	local magic_data = ex.Player.hero_data.magic_wand:getMagicWandByHeroId(self.hero_id)
	if magic_data then
		ex.Tools:onClickItemInfo(magic_data.item_type, magic_data.magic_id)
	else
		require("src.layer.heromagicwand.HeroMagicWandSelectCtr"):instance():openWindow(1, self.hero_id)
	end
end

function HeroMagicWandWearLayer:onAttrPreview(tag, pSender)
	local magic_data = ex.Player.hero_data.magic_wand:getMagicWandByHeroId(self.hero_id)
	if magic_data then
		local position = cc.p(-0, -0)
		position = pSender:convertToWorldSpace(position)
		require("src.layer.heromagicwand.HeroMagicWandAttrPreviewCtr"):instance():openWindow(position, magic_data.item_type)
	end
end

function HeroMagicWandWearLayer:onSelect( )
	
end

function HeroMagicWandWearLayer:onUpLevel( )
	local magic_data = ex.Player.hero_data.magic_wand:getMagicWandByHeroId(self.hero_id)
	if magic_data then
		require("src.layer.heromagicwand.HeroMagicWandStrengthenCtr"):instance():openWindow(magic_data.magic_id)
	end
end

function HeroMagicWandWearLayer:onRefine()
	local magic_data = ex.Player.hero_data.magic_wand:getMagicWandByHeroId(self.hero_id)
	if magic_data then
		local c = cfg.magicwandtype.magicwandtype[magic_data.item_type]
		if c.random_attr_max <= 0 then
			ex.MessageView:add(ex.Tools:getLang(57208))
			return
		end
		require("src.layer.heromagicwand.HeroMagicWandRefineCtr"):instance():openWindow(magic_data.magic_id)
	end
end

function HeroMagicWandWearLayer:onTakeOff()
	local magic_data = ex.Player.hero_data.magic_wand:getMagicWandByHeroId(self.hero_id)

	if magic_data == nil then
		return
	end

	local req = HeroMagicWand_pb.GReqHeroMagicWandOff()
	req.hero_id = magic_data.hero_id
	req.magic_id = magic_data.magic_id
	NetManager:sendMessage(ProtocolID.GReqHeroMagicWandOff, req)
end

function HeroMagicWandWearLayer:onInfo()
	ex.InfoCtr:openWindow(ex.Tools:getLang(57179), ex.Tools:getLang(57180))
end

function HeroMagicWandWearLayer:onWear()
	require("src.layer.heromagicwand.HeroMagicWandSelectCtr"):instance():openWindow(1, self.hero_id)
end


function HeroMagicWandWearLayer:onIllustrate()
	require("src.layer.heromagicwand.HeroMagicWandSelectCtr"):instance():openWindow(0)
end

-----------------------------------------------
function HeroMagicWandWearCtr:loadLayer()
	local tmp_layer = HeroMagicWandWearLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroMagicWandWearCtr:onCreate()
	self:setIsSingle(false)
end

function HeroMagicWandWearCtr:openWindow(hero_id)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self.layer:resetData(hero_id or 0)
end

return HeroMagicWandWearCtr

