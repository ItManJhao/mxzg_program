--[[
* @Description: 洗炼
* @Author: 熊梦
* @Date: 2020-05-21 19:46:00
* ]]
local FettersInfoBaptismCell = class("FettersInfoBaptismCell", require("src.comp.EventLayer"))

function FettersInfoBaptismCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)


	self:addEvent(EVENT.FETTER_EVENT.BAPTISM, handler(self, self.updateLayer))

	self:addRedDotNode(RedDotType.ZCJ_DHJB_XLT_JBXL, self.btn_level)
end

function FettersInfoBaptismCell:updateLayer()
	-- 更新属性显示
	local info_layer = self:getParent()
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	self.type = fetter_data.type

	local max_level = ex.Player.fetter_data:getBaptismMaxLevel()
	self.lbl_max_level:setString(max_level)
	local wash_level = fetter_data.wash_level
	local config = cfg.goddesswashattr.goddesswashattr[wash_level]
	
	-- 没有达到最大等级
	if config then
		self.lbl_now_level:setString(wash_level)
		self.lbl_next_level:setString(wash_level + 1)
		

		if config.cost_res ~= "" then
			for i,v in ipairs(config.cost_res) do
				local has_material = ex.Player:getItemNum(v.item_type)
				self["lbl_material" .. i]:setString(string.format("%s/%s", ex.StringUtil.getScientificNumber(has_material), ex.StringUtil.getScientificNumber(v.item_num)))
				ex.Tools:setSpriteFrame(self["spr_material" .. i], string.format("backpack/%d.png", v.item_type))
				ex.Tools:setCostColor(self["lbl_material" .. i], has_material >= v.item_num)
				self["btn_iteminfo" .. i].item_type = v.item_type
				self["btn_iteminfo" .. i]:setContentSize(cc.size(self.spr_battle_count_icon_bg:getContentSize().width * self.spr_battle_count_icon_bg:getScaleX(), 
													  self.spr_battle_count_icon_bg:getContentSize().height * self.spr_battle_count_icon_bg:getScaleY()))
			end
		end
	else
		config = cfg.goddesswashattr.goddesswashattr[max_level]
	end

	self.node_maxlevel:setVisible(wash_level >= max_level)
	self.node_up:setVisible(wash_level < max_level)

	if fetter_data.level < config.level then
		self.node_lower:setVisible(false)
		self.node_gradelimit:setVisible(true)
		self.lbl_limit:setString(string.format(ex.Tools:getLang(47392), config.level))
		self.lbl_limit:setColor(cc.c3b(162, 0, 0))
	else
		self.node_lower:setVisible(wash_level < max_level)
		self.node_gradelimit:setVisible(false)
	end

	-- 显示属性
	local vec_attr = ex.Player.fetter_data:getBaptismAttr(wash_level)

	local str_attr_fix = ex.Tools:getLang(41325) or ""
	--for k,v in pairs(vec_attr) do
		local str = ex.Tools:getLang(2140000 + vec_attr[1].attr)		
		str = ex.StringUtil.formatAttrStr(str, "##" , vec_attr[1].value)
		self.lbl_attr1:setString(str_attr_fix .. str)
	--end

	--for k,v in pairs(vec_attr2) do
		local str2 = ex.Tools:getLang(2140000 + vec_attr[2].attr)		
		str2 = ex.StringUtil.formatAttrStr(str2, "##" , vec_attr[2].value)
		self.lbl_attr3:setString(str_attr_fix .. str2)
	--end
end

function FettersInfoBaptismCell:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function FettersInfoBaptismCell:onLevel()
	local info_layer = self:getParent()

	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	local config = cfg.goddesswashattr.goddesswashattr[fetter_data.wash_level]


	for i,v in ipairs(config.cost_res) do
		local has_material = ex.Player:getItemNum(v.item_type)
		if has_material < v.item_num then
			ex.Tools:showEnoughTip(v.item_type)
			return
		end
	end

	ex.Player.fetter_data:baptism()
end

return FettersInfoBaptismCell
