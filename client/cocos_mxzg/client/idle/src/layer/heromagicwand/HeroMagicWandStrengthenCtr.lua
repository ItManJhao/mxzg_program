local HeroMagicWandStrengthenCtr = class("HeroMagicWandStrengthenCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMagicWandStrengthenLayer = class("HeroMagicWandStrengthenLayer", require("src.layer.ui.UI_HeroMagicWandStrengthenLayer"))
------------------------------------------------
function HeroMagicWandStrengthenLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroMagicWandStrengthenLayer")

	ex.Tools:setLimitWidth(self.lbl_title, 150)
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_STRENGTHEN, handler(self, self.updateLayer))
end

function HeroMagicWandStrengthenLayer:resetData(magic_id)
	self.magic_id = magic_id
	self:updateLayer()
end

function HeroMagicWandStrengthenLayer:updateLayer()
	local magic_data = ex.Player.backpack_data:getMagicWand(self.magic_id)
	if magic_data == nil then
		return
	end
	local config = cfg.magicwandtype.magicwandtype[magic_data.item_type]
	
	self.btn_equip:refreshData(magic_data.item_type, 0, magic_data.magic_id)
	self.lbl_level:setString(string.format("+%d", magic_data.strengthen_lv))
	self.lbl_level:setTextColor(COLOR_RARE[config.rare])
	
	self.lbl_rare:setString(ex.Tools:getLang(57190 + config.rare))
	self.lbl_rare:setTextColor(COLOR_RARE[config.rare])

	local config_item = cfg.item.item[magic_data.item_type]
	self.lbl_equip_name:setString(ex.Tools:getLang(config_item.name))
	
	for i,v in ipairs(magic_data.base_attrs) do
		self["lbl_attr"..i]:setString(ex.Tools:getAttrText(v.attr_id, v.attr_value_old))
		ex.Tools:setSpriteFrameAsyn(self["spr_icon"..i], string.format("hero-info-2/spr-attribute-%s.png", v.attr_id), "hero-info-2")
	end

	local attr_visible_list, level_list = ex.Player.hero_data.magic_wand:getRandAttrVisible(magic_data.item_type, magic_data.strengthen_lv)

	for i,v in ipairs(magic_data.random_attrs) do
		self["lbl_attr_rand"..i]:setString(ex.Tools:getAttrText(v.attr_id, v.attr_value_old))
	end
	
	for i=1, 4 do
		self["node_attr_rand"..i]:setVisible(attr_visible_list[i] > 0)
		if attr_visible_list[i] == 1 then
			self["lbl_attr_rand"..i]:setString(string.format(ex.Tools:getLang(57164), i, level_list[i]))
		elseif attr_visible_list[i] == 2 then
			self["lbl_attr_rand"..i]:setTextColor(cc.c3b(4, 149, 196))
			ex.Tools:setSpriteFrameAsyn(self["spr_icon_rand"..i], "hero-info-2/spr-act-1.png", "hero-info-2")
		end
	end
	
	local cfg_lv = TableEx.findValueFunction(cfg.magicwandstrengthen.magicwandstrengthen, function(v)
		return (v.item_type == magic_data.item_type) and ((v.level == magic_data.strengthen_lv))
	end) 

	-- 满级了
	if cfg_lv == nil or table.nums(cfg_lv.cost) <= 0 then
		self.node_res_need_1:setVisible(false)
		self.node_res_need_2:setVisible(false)
		self.btn_max_level:setVisible(true)
		self.btn_enter:setVisible(false)
		self.lbl_attr_up1:setVisible(false)
		self.lbl_attr_up2:setVisible(false)
		self.spr_attr_up1:setVisible(false)
		self.spr_attr_up2:setVisible(false)
		self.lbl_cost_tip:setVisible(false)
	else
		self.btn_max_level:setVisible(false)
		self.btn_enter:setVisible(true)
		local is_max, max_level = self:getMaxLevel(magic_data)
		local cfg_lv_next = TableEx.findValueFunction(cfg.magicwandstrengthen.magicwandstrengthen, function(v)
			return (v.item_type == magic_data.item_type) and ((v.level == (is_max and max_level or magic_data.strengthen_lv + 1)))
		end) 

		for i,v in ipairs(cfg_lv_next.attrs) do
			self["lbl_attr_up"..i]:setString(ex.Tools:getAttrValue(v.attr, v.value))
		end
		
		for i,v in ipairs(cfg_lv.cost) do
			local has_num = ex.Player:getItemNum(v.item_type)

			self["node_res_need_"..i]:setVisible(true)
			self["lbl_res_need_"..i]:setString(string.format("%s/%s",
											   ex.StringUtil.getScientificNumber(has_num),
											   ex.StringUtil.getScientificNumber(v.item_num)))
			ex.Tools:setCostColor(self["lbl_res_need_"..i], has_num > v.item_num)
			self["btn_res_info"..i].item_type = v.item_type
			ex.Tools:setSpriteFrame(self["spr_res_need_"..i], string.format("backpack/%d.png", v.item_type))
		end
	end
  
	self:resetLyt()
end

function HeroMagicWandStrengthenLayer:onInfo(tag, pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(57177), ex.Tools:getLang(57178))
end

function HeroMagicWandStrengthenLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemSrc(pSender.item_type)
end

function HeroMagicWandStrengthenLayer:onPreview(tag, pSender)
	local magic_data = ex.Player.backpack_data:getMagicWand(self.magic_id)
	if magic_data then
		local position = cc.p(-0, -0)
		position = pSender:convertToWorldSpace(position)
		require("src.layer.heromagicwand.HeroMagicWandAttrPreviewCtr"):instance():openWindow(position, magic_data.item_type)
	end
end

function HeroMagicWandStrengthenLayer:onUplevel()
	local magic_data = ex.Player.backpack_data:getMagicWand(self.magic_id)
	if magic_data == nil then
		return
	end

	local c = TableEx.findValueFunction(cfg.magicwandstrengthen.magicwandstrengthen, function(v)
		return v.level == magic_data.strengthen_lv
	end)

	if c and ex.Tools:hasItemList(c.cost, true) == false then
		return
	end

	local req = HeroMagicWand_pb.GReqMagicWandStrengthen()
	req.hero_id = magic_data.hero_id
	req.magic_id = magic_data.magic_id
	NetManager:sendMessage(ProtocolID.GReqMagicWandStrengthen, req)
end

--优化 强化的数值显示
function HeroMagicWandStrengthenLayer:getMaxLevel(magic_data)
	local max_level = 0
	local is_max = false
	for i,v in ipairs(cfg.magicwandstrengthen.magicwandstrengthen) do
		if v.item_type == magic_data.item_type and v.level >= max_level then
			max_level = v.level
		end		
	end
	if (magic_data.strengthen_lv + 1) > max_level  then
		is_max = true
	end
	return is_max, max_level	
end


-----------------------------------------------
function HeroMagicWandStrengthenCtr:loadLayer()
	local tmp_layer = HeroMagicWandStrengthenLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroMagicWandStrengthenCtr:onCreate()
	self:setIsSingle(false)
end

function HeroMagicWandStrengthenCtr:openWindow(magic_id)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:resetData(magic_id)
end

return HeroMagicWandStrengthenCtr

