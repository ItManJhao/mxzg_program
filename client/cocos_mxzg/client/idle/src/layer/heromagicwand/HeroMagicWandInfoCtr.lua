local HeroMagicWandInfoCtr = class("HeroMagicWandInfoCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMagicWandInfoLayer = class("HeroMagicWandInfoLayer", require("src.layer.ui.UI_HeroMagicWandInfoLayer"))
------------------------------------------------
function HeroMagicWandInfoLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroMagicWandInfoLayer")
end

function HeroMagicWandInfoLayer:updateLayer(magic_wand_data, type)
	type = type or 0

	self.magic_wand_data = magic_wand_data
	local item_config = cfg.item.item[self.magic_wand_data.item_type]
	local cfg_magic_wand = cfg.magicwandtype.magicwandtype[self.magic_wand_data.item_type]

	local max_rare = 0
	for i,v in pairs(cfg.magicwandtype.magicwandtype) do
		max_rare = v.rare > max_rare and v.rare or max_rare
	end

	self.lbl_rare_tip:setVisible(max_rare <= cfg_magic_wand.rare)
	if cfg_magic_wand.type > 0 then
		self.lbl_rare_tip:setString(string.format(ex.Tools:getLang(57207), ex.Tools:getLang(57150 + cfg_magic_wand.type)))
		ex.Tools:setLimitWidth(self.lbl_rare_tip, 200);
	end

	if type == 0 then
		self.menu_wear:setVisible(self.magic_wand_data.hero_id > 0)
		self.menu_unwear:setVisible(self.magic_wand_data.hero_id <= 0)
	elseif type == 1 then
		self.menu_wear:setVisible(false)
		self.menu_unwear:setVisible(false)
		self.lbl_desc:setVisible(true)
		self.lbl_desc:setString(ex.Tools:getLang(item_config.content))
	end

	self.lbl_name:setString(ex.Tools:getLang(item_config.name))
	self.lbl_name:setTextColor(COLOR_RARE[item_config.rare_mark])

	-- backpack-info-spr-banner-backpack-1
	self:removeNodeLoadRes(self.spr_rare)
	ex.Tools:setSpriteFrameAsyn(self.spr_rare, string.format("backpack-info/spr-banner-backpack-%d.png", item_config.rare_mark), "backpack-info")

	self.btn_equip:refreshData(self.magic_wand_data.item_type, 0, self.magic_wand_data.magic_id)
	self.btn_equip:setStrengthen(self.magic_wand_data.strengthen_lv)

	-- 没有基础属性。则显示配置表中的基本属性
	local base_attrs = clone(self.magic_wand_data.base_attrs)
	for i,v in ipairs(cfg_magic_wand.base_attrs) do
		if base_attrs[i] == nil then
			base_attrs[i] = {}
			base_attrs[i].attr_id = v.attr
			base_attrs[i].attr_value_old = v.value
		end
	end

	-- 基礎屬性顯示
	for i=1, 2 do
		local v = base_attrs[i]
		self["lbl_attr_"..i]:setString(ex.Tools:getAttrTextOnly(v.attr_id) .. ": ")
		self["lbl_value_"..i]:setString(ex.Tools:getAttrValue(v.attr_id, v.attr_value_old))
		ex.Tools:setSpriteFrameAsyn(self["spr_attr"..i], string.format("hero-info-2/spr-attribute-%s.png", v.attr_id), "hero-info-2")
	end


	-- 隨機屬性顯示
	local attr_visible_list, level_list = ex.Player.hero_data.magic_wand:getRandAttrVisible(self.magic_wand_data.item_type, self.magic_wand_data.strengthen_lv)
	
	for i=1,4 do
		local v = self.magic_wand_data.random_attrs[i]
		local str = v and ex.Tools:getAttrText(v.attr_id, v.attr_value_old) or ex.Tools:getLang(57163)
		self["lbl_attr_rand"..i]:setString(str)

		if v and v.attr_id ~= 0 then
			self["lbl_attr_rand"..i]:setTextColor(cc.c3b(57, 250, 0))
			ex.Tools:setSpriteFrameAsyn(self["spr_attr_rand"..i], string.format("hero-info-2/spr-attribute-%s.png", v.attr_id), "hero-info-2")
		end
	end

	for i=1, 4 do
		self["node_attr_rand"..i]:setVisible(attr_visible_list[i] > 0)
		if attr_visible_list[i] == 1 then
			self["lbl_attr_rand"..i]:setString(string.format(ex.Tools:getLang(57164), i, level_list[i]))
		end

		if attr_visible_list[i] == 2 then
			ex.Tools:setSpriteFrameAsyn(self["spr_icon_rand"..i], "hero-info-2/spr-act-1.png", "hero-info-2")
		end
		ex.Tools:setLimitWidth(self["lbl_attr_rand"..i],280)
	end


	if cfg_magic_wand then
		self.lbl_null_tip:setVisible(cfg_magic_wand.random_attr_max <= 0)
		self.spr_null_tip:setVisible(cfg_magic_wand.random_attr_max <= 0)
		self.btn_preview:setVisible(cfg_magic_wand.random_attr_max > 0)
	end

	
	self:resetLyt()
	self:setPositionCenter()
end

-- function HeroMagicWandInfoLayer:allResLoadDone()
-- 	local item_config = cfg.item.item[self.magic_wand_data.item_type]

-- end

-- 強化
function HeroMagicWandInfoLayer:onStrengthen()
	require("src.layer.heromagicwand.HeroMagicWandStrengthenCtr"):instance():openWindow(self.magic_wand_data.magic_id)

	self:onClose()
end

-- 洗練
function HeroMagicWandInfoLayer:onRefine()
	local c = cfg.magicwandtype.magicwandtype[self.magic_wand_data.item_type]
	if c.random_attr_max <= 0 then
		ex.MessageView:add(ex.Tools:getLang(57208))
		return
	end

	require("src.layer.heromagicwand.HeroMagicWandRefineCtr"):instance():openWindow(self.magic_wand_data.magic_id)
	self:onClose()
end

function HeroMagicWandInfoLayer:onPreview(tag, pSender)
	local position = cc.p(-0, -0)
	position = pSender:convertToWorldSpace(position)
	require("src.layer.heromagicwand.HeroMagicWandAttrPreviewCtr"):instance():openWindow(position, self.magic_wand_data.item_type)
end

-- 脫下
function HeroMagicWandInfoLayer:onTakeOff()
	self:onClose()
end

-- 替換
function HeroMagicWandInfoLayer:onReplace()
	require("src.layer.heromagicwand.HeroMagicWandSelectCtr"):instance():openWindow(self.magic_wand_data.hero_id)

	self:onClose()
end

-- 穿戴
function HeroMagicWandInfoLayer:onWear()
	ex.JumpManager:jumpByAtom("main_hero")

	self:onClose()
end

-- 售出
function HeroMagicWandInfoLayer:onSell()
	require("src.layer.heromagicwand.HeroMagicWandSellConfirmCtr"):instance():openWindow({self.magic_wand_data}, handler(self, self.onSellDone))
end

function HeroMagicWandInfoLayer:onSellDone(sale_list)
    if not sale_list or #sale_list <= 0 then
        return
    end

	local req = HeroMagicWand_pb.GReqMagicWandDecompose()
	for i,v in ipairs(sale_list) do
		table.insert(req.magic_ids, v.magic_id)
	end
	NetManager:sendMessage(ProtocolID.GReqMagicWandDecompose, req)

	self:onClose()
end

function HeroMagicWandInfoLayer:onInfo()
	require("src.layer.heromagicwand.HeroMagicWandPreviewCtr"):instance():openWindow()
end

-----------------------------------------------
function HeroMagicWandInfoCtr:loadLayer()
	local tmp_layer = HeroMagicWandInfoLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroMagicWandInfoCtr:onCreate()
	self:setIsSingle(false)
end

function HeroMagicWandInfoCtr:openWindow(magic_wand_data, type)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:updateLayer(magic_wand_data, type)
end

return HeroMagicWandInfoCtr

