local HeroMagicWandRefineCtr = class("HeroMagicWandRefineCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HeroMagicWandRefineLayer = class("HeroMagicWandRefineLayer", require("src.layer.ui.UI_HeroMagicWandRefineLayer"))
------------------------------------------------
function HeroMagicWandRefineLayer:onCreate()
	self.super.onCreate(self)
	self:setName("HeroMagicWandRefineLayer")

	ex.Tools:setLimitWidth(self.lbl_title, 140)
	ex.Tools:setLimitWidth(self.lbl_rand_pre, 150)
	self:addEvent(EVENT.HERO_INFO_EVENT.MAGIC_WAND_REFINE, handler(self, self.updateLayer))
end

function HeroMagicWandRefineLayer:resetData(magic_id)
	self.magic_id = magic_id
	self:updateLayer()
end

function HeroMagicWandRefineLayer:onInfo()
	ex.InfoCtr:openWindow(ex.Tools:getLang(57187), ex.Tools:getLang(57188))
end

function HeroMagicWandRefineLayer:updateLayer()
	local magic_data = ex.Player.backpack_data:getMagicWand(self.magic_id)
	if magic_data == nil then
		return
	end

	local config = cfg.magicwandtype.magicwandtype[magic_data.item_type]
	self.btn_equip:refreshData(magic_data.item_type, 0, magic_data.magic_id)

	self.lbl_rand_pre:setString(string.format("%s [%s]", ex.Tools:getLang(57162), ex.Tools:getLang(57181)))
	self.lbl_rand_now:setString(string.format("%s [%s]", ex.Tools:getLang(57162), ex.Tools:getLang(57182)))

	self.lbl_level:setString(string.format("+%d", magic_data.strengthen_lv))
	self.lbl_level:setTextColor(COLOR_RARE[config.rare])
	
	self.lbl_rare:setString(ex.Tools:getLang(57190 + config.rare))
	self.lbl_rare:setTextColor(COLOR_RARE[config.rare])

	self.lbl_refine_num:setString(string.format("%s%s", ex.Tools:getLang(57190), magic_data.wash_times))

	local config_item = cfg.item.item[magic_data.item_type]
	self.lbl_equip_name:setString(ex.Tools:getLang(config_item.name))

	local isRefinding = table.nums(magic_data.wash_attrs) > 0

	local cfg_rf = TableEx.findValueFunction(cfg.magicwandtype.magicwandtype, function(v)
		return (v.type_id == magic_data.item_type)
	end) 

	for i,v in ipairs(cfg_rf.cost) do
		local has_num = ex.Player:getItemNum(v.item_type)

		self["node_res_need_"..i]:setVisible(true)
		self["lbl_res_need_"..i]:setString(string.format("%s/%s",
										   ex.StringUtil.getScientificNumber(has_num),
										   ex.StringUtil.getScientificNumber(v.item_num)))
		ex.Tools:setCostColor(self["lbl_res_need_"..i], has_num > v.item_num)
		self["btn_res_info"..i].item_type = v.item_type
		ex.Tools:setSpriteFrame(self["spr_res_need_"..i], string.format("backpack/%d.png", v.item_type))
	end

	if isRefinding then
		self.btn_refine:setPositionX(-80)
		self.btn_save:setPositionX(80)
		self.btn_save:setVisible(true)
	else
		self.btn_refine:setPositionX(0)
		self.btn_save:setVisible(false)
	end

	local attr_visible_list, level_list = ex.Player.hero_data.magic_wand:getRandAttrVisible(magic_data.item_type, magic_data.strengthen_lv)

	-- 旧属性
	for i,v in ipairs(magic_data.random_attrs) do
		local cfg_range = TableEx.findValueFunction(cfg.magicwandrange.magicwandrange, function(a)
			return a.attr_type == v.attr_id and a.rare == config.rare
		end)
		self["lbl_attr"..i]:setString(ex.Tools:getAttrTextOnly(v.attr_id))
		self["lbl_attr_num"..i]:setString(ex.Tools:getAttrValue(v.attr_id, v.attr_value_old))
		self["prog_attr"..i]:setPercentage( v.attr_value_old / cfg_range.max * 100)
	end

	for i=1, 4 do
		self["node_attr"..i]:setVisible(attr_visible_list[i] > 0)
		if attr_visible_list[i] == 1 then
			self["prog_attr"..i]:setVisible(false)
			self["lbl_attr_num"..i]:setVisible(false)
			self["lbl_attr"..i]:setString(string.format(ex.Tools:getLang(57164), i, level_list[i]))
		end

		if attr_visible_list[i] == 2 then
			ex.Tools:setSpriteFrameAsyn(self["spr_icon"..i], "hero-info-2/spr-act-1.png", "hero-info-2")
		end
	end


	-- 新属性
	for i=1, 4 do
		local v = magic_data.wash_attrs[i]
		if v then
			self["lbl_attr_rand"..i]:setString(ex.Tools:getAttrTextOnly(v.attr_id))
			self["lbl_attr_num_rand"..i]:setString(ex.Tools:getAttrValue(v.attr_id, v.attr_value_old))
			self["prog_attr_rand"..i]:setVisible(true)
			self["lbl_attr_num_rand"..i]:setVisible(true)

			local cfg_range = TableEx.findValueFunction(cfg.magicwandrange.magicwandrange, function(a)
				return a.attr_type == v.attr_id and a.rare == config.rare
			end)
			self["prog_attr_rand"..i]:setPercentage(v.attr_value_old / cfg_range.max * 100)
			ex.Tools:setSpriteFrameAsyn(self["spr_icon_rand"..i], "hero-info-2/spr-act-1.png", "hero-info-2")

		else
			self["node_attr_rand"..i]:setVisible(attr_visible_list[i] > 0)

			-- 品质解锁提示
			if attr_visible_list[i] == 1 then
				self["prog_attr_rand"..i]:setVisible(false)
				self["lbl_attr_num_rand"..i]:setVisible(false)
				self["lbl_attr_rand"..i]:setString(string.format(ex.Tools:getLang(57164), i, level_list[i]))
			end

			-- 已经解锁
			if attr_visible_list[i] == 2 then
				if v == nil then
					self["prog_attr_rand"..i]:setVisible(false)
					self["lbl_attr_num_rand"..i]:setVisible(false)
					self["lbl_attr_rand"..i]:setString(ex.Tools:getLang(57163))
				else
					self["lbl_attr_rand"..i]:setString(string.format(ex.Tools:getLang(57164), i, level_list[i]))
				end

				self:removeNodeLoadRes(self["spr_icon_rand"..i])
				ex.Tools:setSpriteFrameAsyn(self["spr_icon_rand"..i], "hero-info-2/spr-act-1.png", "hero-info-2")
			end
		end
	end


	-- -- 新属性
	-- if isRefinding then
	-- 	for i,v in ipairs(magic_data.wash_attrs) do
	-- 		self["lbl_attr_rand"..i]:setString(ex.Tools:getAttrTextOnly(v.attr_id))
	-- 		self["lbl_attr_num_rand"..i]:setString(ex.Tools:getAttrValue(v.attr_id, v.attr_value_old))
	-- 		self["prog_attr_rand"..i]:setVisible(true)
	-- 		self["lbl_attr_num_rand"..i]:setVisible(true)

	-- 		local cfg_range = TableEx.findValueFunction(cfg.magicwandrange.magicwandrange, function(a)
	-- 			return a.attr_type == v.attr_id and a.rare == config.rare
	-- 		end)
	-- 		self["prog_attr_rand"..i]:setPercentage(v.attr_value_old / cfg_range.max * 100)
	-- 	end
	-- else
	-- 	for i=1, 4 do
	-- 		self["lbl_attr_rand"..i]:setString(ex.Tools:getLang(57163))
	-- 		self["prog_attr_rand"..i]:setVisible(false)
	-- 		self["lbl_attr_num_rand"..i]:setVisible(false)
	-- 		-- self["lbl_attr_num_rand"..i]:setString(ex.Tools:getAttrValue(v.attr_id, v.attr_value_old))
	-- 	end
	-- end

	-- for i=1, 4 do
	-- 	self["node_attr_rand"..i]:setVisible(attr_visible_list[i] > 0)

	-- 	if attr_visible_list[i] == 1 then
	-- 		self["prog_attr_rand"..i]:setVisible(false)
	-- 		self["lbl_attr_rand"..i]:setString(string.format(ex.Tools:getLang(57164), i, level_list[i]))
	-- 	end

	-- 	if attr_visible_list[i] == 2 then
	-- 		ex.Tools:setSpriteFrameAsyn(self["spr_icon_rand"..i], "hero-info-2/spr-act-1.png", "hero-info-2")
	-- 	end
	-- end

	-- jumpToTop
	self.scroll_attr:setContentOffset(cc.p(0, math.min(0, self.scroll_attr:getViewSize().height - self.scroll_attr:getContentSize().height)))
	self.scroll_attr_rand:setContentOffset(cc.p(0, math.min(0, self.scroll_attr_rand:getViewSize().height - self.scroll_attr_rand:getContentSize().height)))

	self.prog_attr1:setPositionX(self.lbl_attr1:getPositionX() + self.lbl_attr1:getContentSize().width * self.lbl_attr1:getScaleX() + 5)
	self:resetLyt()
end

function HeroMagicWandRefineLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemSrc(pSender.item_type)
end

function HeroMagicWandRefineLayer:onPreview(tag, pSender)
	local magic_data = ex.Player.backpack_data:getMagicWand(self.magic_id)
	if magic_data then
		local position = cc.p(-0, -0)
		position = pSender:convertToWorldSpace(position)
		require("src.layer.heromagicwand.HeroMagicWandAttrPreviewCtr"):instance():openWindow(position, magic_data.item_type)
	end
end

function HeroMagicWandRefineLayer:onSave()
	local magic_data = ex.Player.backpack_data:getMagicWand(self.magic_id)
	if magic_data == nil then
		return
	end

	local req = HeroMagicWand_pb.GReqMagicWandSave()
	req.hero_id = magic_data.hero_id
	req.magic_id = magic_data.magic_id
	NetManager:sendMessage(ProtocolID.GReqMagicWandSave, req)
end

function HeroMagicWandRefineLayer:onRefine()
	local magic_data = ex.Player.backpack_data:getMagicWand(self.magic_id)
	if magic_data == nil then
		return
	end

	local c = TableEx.findValueFunction(cfg.magicwandtype.magicwandtype, function(v)
		return v.type_id == magic_data.item_type
	end)

	if c and ex.Tools:hasItemList(c.cost, true) == false then
		return
	end
	
	local req = HeroMagicWand_pb.GReqMagicWandBaptism()
	req.hero_id = magic_data.hero_id
	req.magic_id = magic_data.magic_id
	NetManager:sendMessage(ProtocolID.GReqMagicWandBaptism, req)
end

-----------------------------------------------
function HeroMagicWandRefineCtr:loadLayer()
	local tmp_layer = HeroMagicWandRefineLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function HeroMagicWandRefineCtr:onCreate()
	self:setIsSingle(false)
end

function HeroMagicWandRefineCtr:openWindow(magic_id)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self.layer:resetData(magic_id)
end

return HeroMagicWandRefineCtr

