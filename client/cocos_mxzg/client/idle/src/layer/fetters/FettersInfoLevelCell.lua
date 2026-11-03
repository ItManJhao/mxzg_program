local FettersInfoLevelCell = class("FettersInfoLevelCell", require("src.comp.EventLayer"))

function FettersInfoLevelCell:onCreate()
	self:setAutoClose(false)
    self:setSwallowTouches(false)


 --    local spr_progress = ccui.Scale9Sprite:createWithSpriteFrameName("fetters/jdt3.png", cc.rect(16, 16, 1, 1))
 --    spr_progress:setContentSize(self.spr_exp_bg:getContentSize())

 --    self.progress_exp = cc.ProgressTimer:create(spr_progress)
	-- progress_exp:setType(cc.PROGRESS_TIMER_TYPE_BAR)
 --    progress_exp:setMidpoint(cc.p(0, 0.5))
 --    progress_exp:setBarChangeRate(cc.p(1, 0))
 --    progress_exp:setPosition(prog_bg:getPositionX(), prog_bg:getPositionY())
 --    progress_exp:setScale(prog_bg:getScale())
 --    progress_exp:setPercentage(0)
 --    self:addChild(progress_exp, 19)
	self.progress_exp = cc.ProgressTimer:create(cc.Sprite:createWithSpriteFrameName("fetters/spr-jdt2.png"))
	:setType(cc.PROGRESS_TIMER_TYPE_BAR)
	:setMidpoint(cc.p(0, 0.5))
	:setBarChangeRate(cc.p(1, 0)) --(1, 0)x变化 (0, 1)y变化
	:setAnchorPoint(cc.p(0.5, 0.5))
	self.progress_exp:setPosition(cc.p(self.spr_exp_bg:getContentSize().width * 0.5,
										self.spr_exp_bg:getContentSize().height * 0.5))
	self.progress_exp:setPercentage(0)
 	self.spr_exp_bg:addChild(self.progress_exp)

 	self.lbl_exp:setLocalZOrder(1)

	self:addEvent(EVENT.FETTER_EVENT.UPLEVEL, handler(self, self.updateLayer))
	self:addEvent(EVENT.FETTER_EVENT.CHANGE_TYPE, handler(self, self.stopAutoUplevelSchedule))
	
	self.schedule_auto_uplevel = nil

	self:addRedDotNode(RedDotType.ZCJ_DHJB_SJT_JBSJ, self.btn_level)
end


function FettersInfoLevelCell:onExit()
	self:stopAutoUplevelSchedule()
end

function FettersInfoLevelCell:startAutoUplevelSchedule()
	if self.schedule_auto_uplevel then
        return
    end

    if self:onLevel() ~= true then
    	return
    end

    -- 定时器
    self.schedule_auto_uplevel = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.autoUplevel), 0.3, false)
end

function FettersInfoLevelCell:stopAutoUplevelSchedule()
   	if self.schedule_auto_uplevel then
      	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_auto_uplevel)
	  	self.schedule_auto_uplevel = nil
  	end
end


function FettersInfoLevelCell:autoUplevel()
   	if self:onLevel() ~= true then
   		self:stopAutoUplevelSchedule()
	  
		self:updateLayer()
	end 
end

function FettersInfoLevelCell:updateLayer()
	-- 更新属性显示
	local info_layer = self:getParent()
	-- print("info_layer.selected_idx", info_layer.selected_idx)
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	self.type = fetter_data.type

	local max_level = table.nums(cfg.goddesslevel.goddesslevel)
	local config = cfg.goddesslevel.goddesslevel[math.max(fetter_data.level, 1)]

	-- 没有达到最大等级
	if fetter_data.level < max_level then
		local max_exp = config.need_point
		-- local need_gold = config.cost_900001
		-- local need_material = config.cost_901501
		-- local has_material = ex.Player:getItemNum(ItemType.IT_FETTER_UNITY)
		
		self.progress_exp:setPercentage(fetter_data.exp / max_exp * 100)
		self.lbl_exp:setString(string.format("%d/%d", fetter_data.exp, max_exp))
		
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
		config = cfg.goddesslevel.goddesslevel[max_level]
		-- -- print("11111")
		-- self.node_up:setVisible(false)
		-- self.lbl_tip:setVisible(true)
	end

	if self.schedule_auto_uplevel then
		self.btn_auto:setLabelText(ex.Tools:getLang(47453))
	else
		self.btn_auto:setLabelText(ex.Tools:getLang(47045))
	end
	
	self.lbl_tip:setVisible(fetter_data.level >= max_level)
	self.node_up:setVisible(fetter_data.level < max_level)

	local vec_attr = ex.Player.fetter_data:getLevelAttr(fetter_data.level, fetter_data.exp)
	local vec_soul_attr = ex.Player.fetter_data:getSoulLevelAttr(fetter_data.type, fetter_data.soul_level)
	local vec_uplimit_attr = ex.Player.fetter_data:getUplimitAttr(fetter_data.uplimit_level)

	for k,v in pairs(vec_soul_attr) do
		vec_attr[k] = vec_attr[k] and vec_attr[k] + v or v
	end

	-- 计算突破
	vec_attr[AbilityType.AT_HP_ADD] = vec_attr[AbilityType.AT_HP_ADD] * (1 + (vec_uplimit_attr[AbilityType.AT_HP_MAX_BASE] or 0) * 0.0001)
	vec_attr[AbilityType.AT_ATTACK_ADD] = vec_attr[AbilityType.AT_ATTACK_ADD] * (1 + (vec_uplimit_attr[AbilityType.AT_ATTACK_UP] or 0) * 0.0001)


	self.lbl_hp:setString(string.format("%d", vec_attr[AbilityType.AT_HP_ADD]))
	self.lbl_attack:setString(string.format("%d", vec_attr[AbilityType.AT_ATTACK_ADD]))

end

function FettersInfoLevelCell:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function FettersInfoLevelCell:onLevel()
	local info_layer = self:getParent()
	
	local fetter_data = ex.Player.fetter_data:getFetterDataByIdx(info_layer.selected_idx)
	local config = cfg.goddesslevel.goddesslevel[math.max(fetter_data.level, 1)]

	local cost_res = config.cost_res ~= "" and config.cost_res or {}
	for i,v in ipairs(cost_res) do
		local has_material = ex.Player:getItemNum(v.item_type)
		if has_material < v.item_num then
			ex.Tools:showEnoughTip(v.item_type)
			-- ex.MessageView:add(string.format(ex.Tools:getLang(47098), ex.Tools:getLang(v.type)))
			return
		end
	end

	if fetter_data.level >= table.nums(cfg.goddesslevel.goddesslevel) then
		return false
	end

	-- if ex.Player:getItemNum(ItemType.IT_GOLD) < config.cost_900001 or ex.Player:getItemNum(ItemType.IT_FETTER_UNITY) < config.cost_901501 then
	-- 	ex.MessageView:add(ex.Tools:getLang(47678))
	-- 	return
	-- end
	ex.Player.fetter_data:uplevel(self.type)

	ex.AudioManager:playEffect("music/clan-tec.mp3")

	return true
end

function FettersInfoLevelCell:onAutoUplevel()
	if self.schedule_auto_uplevel then
		self:stopAutoUplevelSchedule()
	else
		self:startAutoUplevelSchedule()
	end

	self:updateLayer()
end

return FettersInfoLevelCell
