local FettersInfoRefineCell = class("FettersInfoRefineCell", require("src.comp.EventLayer"))

function FettersInfoRefineCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

	self:addEvent(EVENT.FETTER_EVENT.REFINE, handler(self, self.updateLayer))
end



function FettersInfoRefineCell:updateLayer()
	-- 更新属性显示
	local info_layer = self:getParent()
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	self.type = fetter_data.type

	local max_level = ex.Player.fetter_data:getRefineMaxLevel(self.type)
	local refine_level = fetter_data.refine_level
	local config = cfg.goddessskillrefine.goddessskillrefine[refine_level]

	-- 没有达到最大等级
	if config then
		-- local need_gold = config.cost_900001
		-- local need_material = config.cost_901504
		local has_material = ex.Player:getItemNum(ItemType.IT_FETTER_REFINE)
		
		self.lbl_now_level:setString(refine_level)
		self.lbl_next_level:setString(refine_level + 1)
		
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
		-- self.lbl_gold:setString(string.format("%s/%s",cpp.StringUtil:convertScientific(ex.Player.gold), cpp.StringUtil:convertScientific(need_gold)))
		-- self.lbl_gold:setColor(ex.Player.gold >= need_gold and cc.c3b(255,255,255) or cc.c3b(255,0,0))
	
		-- self.lbl_material:setString(string.format("%s/%s",cpp.StringUtil:convertScientific(has_material), cpp.StringUtil:convertScientific(need_material)))
		-- self.lbl_material:setColor(has_material >= need_material and cc.c3b(255,255,255) or cc.c3b(255,0,0))
	else
		config = cfg.goddessskillrefine.goddessskillrefine[max_level]
	end

	self.node_up:setVisible(refine_level < max_level)
	self.lbl_tip:setVisible(refine_level >= max_level)
	self.node_attr3:setVisible(refine_level < max_level)
	self.lbl_text2:setVisible(refine_level < max_level)
	self.lbl_next_level:setVisible(refine_level < max_level)

	-- 显示属性
	local vec_attr1 = ex.Player.fetter_data:getRefineAttr(self.type, refine_level)
	local vec_attr2 = ex.Player.fetter_data:getRefineAttr(self.type, refine_level + 1)

	self.lbl_attr1:setString(vec_attr1[AbilityType.AT_SKILL_ADD])
	self.lbl_attr3:setString(vec_attr2[AbilityType.AT_SKILL_ADD])
end


function FettersInfoRefineCell:onLevel()
	local info_layer = self:getParent()

	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	local config = cfg.goddessskillrefine.goddessskillrefine[fetter_data.refine_level]


	for i,v in ipairs(config.cost_res) do
		local has_material = ex.Player:getItemNum(v.item_type)
		if has_material < v.item_num then
			ex.Tools:showEnoughTip(v.item_type)
			-- ex.MessageView:add(string.format(ex.Tools:getLang(47098), ex.Tools:getLang(v.type)))
			return
		end
	end

	-- if ex.Player:getItemNum(ItemType.IT_GOLD) < config.cost_900001 or ex.Player:getItemNum(ItemType.IT_FETTER_REFINE) < config.cost_901504 then
	-- 	ex.MessageView:add(ex.Tools:getLang(47678))
	-- 	return
	-- end

	ex.Player.fetter_data:refine(self.type)
end

function FettersInfoRefineCell:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end


return FettersInfoRefineCell
