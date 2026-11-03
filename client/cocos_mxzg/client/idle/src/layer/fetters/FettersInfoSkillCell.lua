local FettersInfoSkillCell = class("FettersInfoSkillCell", require("src.comp.EventLayer"))

function FettersInfoSkillCell:onCreate()
    self:setAutoClose(false)
    self:setSwallowTouches(false)

	self:addEvent(EVENT.FETTER_EVENT.UPSKILL, handler(self, self.updateLayer))
	self:addRedDotNode(RedDotType.ZCJ_DHJB_JNT_JBJN, self.btn_level)
end

function FettersInfoSkillCell:updateLayer()
	-- 更新属性显示
	local info_layer = self:getParent()
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	self.type = fetter_data.type

	local config = cfg.goddessskillcost.goddessskillcost[math.max(fetter_data.skill_level, 1)]

	-- local need_gold = config.cost_900001
	-- local need_material = config.cost_901503
	-- local has_material = ex.Player:getItemNum(ItemType.IT_FETTER_STONE)
	local max_level = table.nums(cfg.goddessskillcost.goddessskillcost)

	-- 满级了
	local is_show_tip = (config ~= nil and fetter_data.level < config.need_base_level) or fetter_data.skill_level >= max_level

	local skill_type = ex.Player.fetter_data:getSkillType(fetter_data.type)
	local str_name = ex.Player.hero_data:getSkillName(skill_type) .. "+" .. fetter_data.skill_level
	str_name = str_name .. (fetter_data.refine_level > 0 and (ex.Tools:getLang(47235) .. fetter_data.refine_level .. ex.Tools:getLang(47586)) or "" )

	self.lbl_name:setString(str_name)
	self.lbl_des:setString(ex.Player.hero_data:getSkillDescription(skill_type, math.max(fetter_data.skill_level, 1), fetter_data.refine_level))

	ex.Tools:setSpriteFrame(self.spr_icon, string.format("skill-icon/%d.png", skill_type + 10000000))

	if config and config.cost_res ~= "" then
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



	-- self.lbl_gold:setString(string.format("%s/%s",cpp.StringUtil:convertScientific(ex.Player.gold), cpp.StringUtil:convertScientific(need_gold)))
	-- self.lbl_gold:setColor(ex.Player.gold >= need_gold and cc.c3b(255,255,255) or cc.c3b(255,0,0))

	-- self.lbl_material:setString(string.format("%s/%s",cpp.StringUtil:convertScientific(has_material), cpp.StringUtil:convertScientific(need_material)))
	-- self.lbl_material:setColor(has_material >= need_material and cc.c3b(255,255,255) or cc.c3b(255,0,0))

	self.btn_level:setVisible(true)
	self.lbl_tip:setVisible(is_show_tip)
	if fetter_data.skill_level >= max_level then
		self.lbl_tip:setString(ex.Tools:getLang(47059))
		self.lbl_tip:setColor(cc.c3b(139, 71, 21))
		self.btn_level:setVisible(false)
	else
		self.lbl_tip:setString(string.format(ex.Tools:getLang(47392), config.need_base_level))
		self.lbl_tip:setColor(cc.c3b(162, 0, 0))
	end

	self.node_res:setVisible(is_show_tip == false)
end

function FettersInfoSkillCell:onLevel()
	local info_layer = self:getParent()
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	local config = cfg.goddessskillcost.goddessskillcost[math.max(fetter_data.skill_level, 1)]
	local is_show_tip = fetter_data.level < config.need_base_level
	if is_show_tip == true then
		return false
	end

	-- 判断材料
	-- local config = cfg.goddessskillcost.goddessskillcost[math.max(fetter_data.skill_level, 1)]
	-- if ex.Player:getItemNum(ItemType.IT_GOLD) < config.cost_900001 or ex.Player:getItemNum(ItemType.IT_FETTER_STONE) < config.cost_901503 then
	-- 	ex.MessageView:add(ex.Tools:getLang(47678))
	-- 	return false
	-- end
	
	local cost_res = config.cost_res ~= "" and config.cost_res or {}
	for i,v in ipairs(cost_res) do
		local has_material = ex.Player:getItemNum(v.item_type)
		if has_material < v.item_num then
			ex.Tools:showEnoughTip(v.item_type)
			-- ex.MessageView:add(string.format(ex.Tools:getLang(47098), ex.Tools:getLang(v.type)))
			return
		end
	end

	ex.AudioManager:playEffect("music/item-get.mp3")

	local info_layer = self:getParent()
	ex.Player.fetter_data:upskill(self.type)
end

function FettersInfoSkillCell:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

return FettersInfoSkillCell
