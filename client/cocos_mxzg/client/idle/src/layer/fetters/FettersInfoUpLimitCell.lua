local FettersInfoUpLimitCell = class("FettersInfoUpLimitCell", require("src.comp.EventLayer"))

function FettersInfoUpLimitCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)

	self:addEvent(EVENT.FETTER_EVENT.UPLIMIT, handler(self, self.updateLayer))
	self:addRedDotNode(RedDotType.ZCJ_DHJB_TPT_JBTP, self.btn_level)
end

function FettersInfoUpLimitCell:updateLayer()
	-- 更新属性显示
	local info_layer = self:getParent()
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	self.type = fetter_data.type


	local max_level = table.nums(cfg.goddessbreak.goddessbreak) - 1
	local uplimit_level = math.max(fetter_data.uplimit_level, 0)
	local config = cfg.goddessbreak.goddessbreak[uplimit_level]

	-- 没有达到最大等级
	if config then
		local need_gold = config.cost_900001
		local need_material = config.cost_901502
		local has_material = ex.Player:getItemNum(ItemType.IT_FETTER_SIGNAL)
		
		self.lbl_now_level:setString(ex.Tools:getLang(5021) .. uplimit_level)
		self.lbl_next_level:setString(ex.Tools:getLang(5021) .. uplimit_level + 1)
		self.lbl_now_level_max:setString(ex.Tools:getLang(5021) .. uplimit_level)
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
		else
			
		end
		-- self.lbl_gold:setString(string.format("%s/%s",cpp.StringUtil:convertScientific(ex.Player.gold), cpp.StringUtil:convertScientific(need_gold)))
		-- self.lbl_gold:setColor(ex.Player.gold >= need_gold and cc.c3b(255,255,255) or cc.c3b(255,0,0))
	
		-- self.lbl_material:setString(string.format("%s/%s",cpp.StringUtil:convertScientific(has_material), cpp.StringUtil:convertScientific(need_material)))
		-- self.lbl_material:setColor(has_material >= need_material and cc.c3b(255,255,255) or cc.c3b(255,0,0))
	else
		config = cfg.goddessbreak.goddessbreak[max_level]
	end


	-- self.node_up:setVisible(uplimit_level < max_level)
	-- self.lbl_tip:setVisible(uplimit_level >= max_level)
	-- self.node_attr3:setVisible(uplimit_level < max_level)
	-- -- self.lbl_text2:setVisible(uplimit_level < max_level)
	-- self.lbl_next_level:setVisible(uplimit_level < max_level)

	self.node_up:setVisible(uplimit_level < max_level)
	self.node_in:setVisible(uplimit_level < max_level)
	self.node_lower:setVisible(uplimit_level >= max_level)
	
	-- 显示属性
	local vec_attr1 = ex.Player.fetter_data:getUplimitAttr(uplimit_level)
	local vec_attr2 = ex.Player.fetter_data:getUplimitAttr(uplimit_level + 1)

	for i=1,4 do
		self["node_attr"..i]:setVisible(false)
	end

	local str_attr_fix = ex.Tools:getLang(41325) or ""

	local index = 1
	for k,v in pairs(vec_attr1) do
		local str = ex.Tools:getLang(2140000 + k)		
		str = ex.StringUtil.formatAttrStr(str, "##" , v)

		self["node_attr"..index]:setVisible(true)
		self["lbl_attr"..index]:setString(str_attr_fix .. str)
		if index == 1 or index == 2 then
			self["lbl_attr"..index.."_max"]:setString(str_attr_fix .. str)
		end
		index = index + 1
	end


	for k,v in pairs(vec_attr2) do
		if v == 0 then
			break
		end

		local str = ex.Tools:getLang(2140000 + k)		
		str = ex.StringUtil.formatAttrStr(str, "##" , v)

		self["node_attr"..index]:setVisible(true)
		self["lbl_attr"..index]:setString(str_attr_fix .. str)
		index = index + 1
	end

	-- self.lbl_attr1:setString(vec_attr1[AbilityType.AT_SKILL_ADD])
	-- self.lbl_attr3:setString(vec_attr2[AbilityType.AT_SKILL_ADD])
end


function FettersInfoUpLimitCell:onLevel()
	local info_layer = self:getParent()

	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	local config = cfg.goddessbreak.goddessbreak[fetter_data.uplimit_level]
	-- if ex.Player:getItemNum(ItemType.IT_GOLD) < config.cost_900001 or ex.Player:getItemNum(ItemType.IT_FETTER_SIGNAL) < config.cost_901502 then
	-- 	ex.MessageView:add(ex.Tools:getLang(47678))
	-- 	return
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

	ex.Player.fetter_data:uplimit(self.type)

	ex.AudioManager:playEffect("music/item-get.mp3")
end

function FettersInfoUpLimitCell:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

return FettersInfoUpLimitCell
