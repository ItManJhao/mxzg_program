local AliceUnicornCtr = class("AliceUnicornCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local AliceUnicornLayer = class("AliceUnicornLayer", require("src.layer.ui.UI_AliceUnicornLayer"))

------------------------------------------------
function AliceUnicornLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceUnicornLayer")

	self:addBlackBackground()

	self.btn_preview:setContentSize(self.spr_preview:getContentSize().width + self.lbl_preview:getContentSize().width, self.spr_preview:getContentSize().height)
	
    self:addEvent(EVENT.ALICE.ALICE_UNICORN_UPDATE, handler(self, self.updateLayer))
    self:addEvent(EVENT.ALICE.ALICE_UNICORN_WASH, handler(self, self.updateLayer))
    self:addEvent(EVENT.ALICE.ALICE_UNICORN_RESET, handler(self, self.updateLayer))
end

function AliceUnicornLayer:initData()
	self:runAction(cc.Sequence:create(cc.DelayTime:create(0.15), cc.CallFunc:create(handler(self, self.updateLayer))))
end

function AliceUnicornLayer:updateLayer()
	local unicorn_data = ctr.alice.data:getUnicornDataByHeroId(self.hero_id)
	if unicorn_data == nil then
		return
	end

	local red_point_stage = ctr.alice.data:checkNobilityReddot(self.hero_id, self.unicorn_type)
	ex.Tools:addRedPoint(self.btn_wash, red_point_stage == 0 , ex.r.p9)
	ex.Tools:addRedPoint(self.btn_upgrade, red_point_stage == 1 , ex.r.p9)

	local config_cur = cfg.aliceunicornstrengthen.getConfig(self.unicorn_type, unicorn_data.grade, unicorn_data.strengthen_lv)
	local config_level_next = cfg.aliceunicornstrengthen.getConfig(self.unicorn_type, unicorn_data.grade, unicorn_data.strengthen_lv + 1)
	local config_grade_next = cfg.aliceunicornstrengthen.getConfig(self.unicorn_type, unicorn_data.grade + 1, 0)
	
	ex.Tools:setSpriteFrameAsyn(self.spr_unicorn_type, "alice/spr-unicorn-type-"..self.unicorn_type..".png", "alice")
	local str_level = (config_level_next == nil and config_grade_next == nil) and ex.Tools:getLang(580590) or ("+"..unicorn_data.strengthen_lv)
	self.lbl_name:setString(ex.Tools:getLang(580507 + self.unicorn_type))
	self.lbl_grade:setString(ex.Tools:getLang(580502 + unicorn_data.grade)..str_level)
	
	local grade_need = ex.Tools:getSysCfg("alice_unicorn_wash_open_grade")
	ex.Tools:setGrayAuto(self.btn_wash:getNormalImage(), unicorn_data.grade < grade_need)
	ex.Tools:setGrayAuto(self.btn_upgrade:getNormalImage(), config_level_next == nil and config_grade_next == nil)

	self.lbl_wash_tip:setVisible(unicorn_data.grade < grade_need)
	self.btn_upgrade:setLabelText(ex.Tools:getLang(config_level_next == nil and 5349 or 57106))

	self:updateEquip(unicorn_data.grade, unicorn_data.strengthen_lv, config_level_next == nil)
	self:updateElemBase(config_cur, config_level_next or config_grade_next)
	self:updateElemRare(unicorn_data.rare_attr)
	self:updateResNeed(unicorn_data.grade, unicorn_data.strengthen_lv)
end

function AliceUnicornLayer:updateEquip(grade, level, is_max)
	for i=1,99 do
		local lbl_equip = self["lbl_equip_strenthen_"..i]
		if lbl_equip == nil then
			break
		end

		lbl_equip:setString("+"..(grade + (level >= i and 1 or 0)))
	end

	local node_equip = self["node_equip_"..(level + 1)]
	if node_equip == nil or is_max then
		self.spr_equip_select:setVisible(false)
	else
		self.spr_equip_select:setVisible(true)

		self.spr_equip_select:setPosition(node_equip:getPosition())
	end
end

function AliceUnicornLayer:updateElemBase(config_now, config_next)
	if config_now == nil and config_next == nil then
		return
	end

	for i=1,99 do
		local node_attr = self["node_attr_base_"..i]
		if node_attr == nil then
			break
		end

		local attr_type = config_now and config_now.cur_attr[i].attr or config_next.cur_attr[i].attr
		
		local attr_num_now = (config_now and config_now.cur_attr[i].value or 0)
		if config_next == nil then
			ex.Tools:setSpriteFrameAsyn(self["spr_attr_base_"..i], string.format("backpack-info/spr-attribute-%d.png", attr_type), "backpack-info")
			self["lbl_attr_base_"..i]:setString(ex.Tools:getLang(2150000 + attr_type))
			self["lbl_attr_base_extra_"..i]:setPositionX(self["lbl_attr_base_"..i]:getPositionX() + self["lbl_attr_base_"..i]:getContentSize().width + 10)
			self["lbl_attr_base_extra_"..i]:setVisible(true)

			local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + attr_type), "##" , attr_num_now, "<font color='#219A00'>%s</font>")
			if not flag then
				self["lbl_attr_base_extra_"..i]:setString(attr_num_now)
			else
				self["lbl_attr_base_extra_"..i]:setString(string.format("%.1f", attr_num_now / 100) .. "%")
			end
		else
			ex.Tools:setSpriteFrameAsyn(self["spr_attr_base_"..i], string.format("backpack-info/spr-attribute-%d.png", attr_type), "backpack-info")
			self["lbl_attr_base_"..i]:setString(ex.Tools:getLang(2150000 + attr_type))
			self["lbl_attr_base_extra_"..i]:setPositionX(self["lbl_attr_base_"..i]:getPositionX() + self["lbl_attr_base_"..i]:getContentSize().width + 10)
			self["lbl_attr_base_extra_"..i]:setVisible(true)

			if config_next.cur_attr[i].value > attr_num_now then
				local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + attr_type), "##" , config_next.cur_attr[i].value, "<font color='#219A00'>%s</font>")
				if not flag then
					self["lbl_attr_base_extra_"..i]:setString(attr_num_now.." +"..(config_next.cur_attr[i].value - attr_num_now))
				else
					self["lbl_attr_base_extra_"..i]:setString(string.format("%.1f", attr_num_now / 100).."% +"..string.format("%.1f", config_next.cur_attr[i].value / 100 - attr_num_now / 100).."%")
				end
			else
				if config_now == nil then
					local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + attr_type), "##" , 0, "<font color='#219A00'>%s</font>")
					if not flag then
						self["lbl_attr_base_extra_"..i]:setString(0)
					else
						self["lbl_attr_base_extra_"..i]:setString("0%")
					end
				else
					local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + attr_type), "##" , attr_num_now, "<font color='#219A00'>%s</font>")
					if not flag then
						self["lbl_attr_base_extra_"..i]:setString(attr_num_now)
					else
						self["lbl_attr_base_extra_"..i]:setString(string.format("%.1f", attr_num_now / 100) .. "%")
					end
				end
			end
		end
	end
end

function AliceUnicornLayer:updateElemRare(rare_attr)
	if rare_attr == nil then
		rare_attr = {}
	end

	for i=1,99 do
		local node_attr = self["node_attr_"..i]
		if node_attr == nil then
			break
		end
		self["lbl_attr_"..i]:setColor(cc.c4b(253,252,224,255))

		if rare_attr[i] == nil then
			ex.Tools:setSpriteFrameAsyn(self["spr_attr_"..i], "backpack-info/spr-attribute-lock.png", "backpack-info")
			self["lbl_attr_"..i]:setString(ex.Tools:getLang(580516 + i))
			self["lbl_attr_extra_"..i]:setVisible(false)
		else
			ex.Tools:setSpriteFrameAsyn(self["spr_attr_"..i], string.format("backpack-info/spr-attribute-%d.png", rare_attr[i].attr_type), "backpack-info")
			self["lbl_attr_"..i]:setString(ex.Tools:getLang(2150000 + rare_attr[i].attr_type))
			self["lbl_attr_extra_"..i]:setPositionX(self["lbl_attr_"..i]:getPositionX() + self["lbl_attr_"..i]:getContentSize().width + 10)
			self["lbl_attr_extra_"..i]:setVisible(true)
			if rare_attr[i].attr_type == 343 or rare_attr[i].attr_type == 344 then
				self["lbl_attr_"..i]:setColor(cc.c4b(246,247,0,255))
			end
			
			local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + rare_attr[i].attr_type), "##" , rare_attr[i].attr_value, "<font color='#219A00'>%s</font>")
			if not flag then
				self["lbl_attr_extra_"..i]:setString(rare_attr[i].attr_value)
			else
				self["lbl_attr_extra_"..i]:setString(string.format("%.1f", rare_attr[i].attr_value / 100) .. "%")
			end
		end
	end
end

function AliceUnicornLayer:updateResNeed(grade, level)
	local config_level = cfg.aliceunicornstrengthen.getConfig(self.unicorn_type, grade, level + 1)
	if config_level ~= nil and #config_level.up_cost > 0 then
		self.node_res_need_1:setVisible(true)
		self.node_res_need_2:setVisible(true)

		ex.Tools:setSpriteFrameAsyn(self.btn_res_need_1:getNormalImage(), "backpack/"..config_level.up_cost[1].item_type..".png", "backpack-5")
		self.btn_res_need_1.item_type = config_level.up_cost[1].item_type
		ex.Tools:setSpriteFrameAsyn(self.btn_res_need_2:getNormalImage(), "backpack/"..config_level.up_cost[2].item_type..".png", "backpack-5")
		self.btn_res_need_2.item_type = config_level.up_cost[2].item_type

		local cur_num_1 = ex.Player:getItemNum(config_level.up_cost[1].item_type)
		self.lbl_res_need_1:setString(ex.StringUtil.getScientificNumber(cur_num_1).."/"..ex.StringUtil.getScientificNumber(config_level.up_cost[1].item_num))
		self.lbl_res_need_1:setColor(cur_num_1 >= config_level.up_cost[1].item_num and FONT_LIGHT_YELLOW or FONT_RED)
		local cur_num_2 = ex.Player:getItemNum(config_level.up_cost[2].item_type)
		self.lbl_res_need_2:setString(ex.StringUtil.getScientificNumber(cur_num_2).."/"..ex.StringUtil.getScientificNumber(config_level.up_cost[2].item_num))
		self.lbl_res_need_2:setColor(cur_num_2 >= config_level.up_cost[2].item_num and FONT_LIGHT_YELLOW or FONT_RED)
		return
	end

	local config_grade = cfg.aliceunicornstrengthen.getConfig(self.unicorn_type, grade + 1, 0)
	if config_grade ~= nil and #config_grade.up_cost > 0 then
		self.node_res_need_1:setVisible(true)
		self.node_res_need_2:setVisible(true)

		ex.Tools:setSpriteFrameAsyn(self.btn_res_need_1:getNormalImage(), "backpack/"..config_grade.up_cost[1].item_type..".png", "backpack-5")
		self.btn_res_need_1.item_type = config_grade.up_cost[1].item_type
		ex.Tools:setSpriteFrameAsyn(self.btn_res_need_2:getNormalImage(), "backpack/"..config_grade.up_cost[2].item_type..".png", "backpack-5")
		self.btn_res_need_2.item_type = config_grade.up_cost[2].item_type

		local cur_num_1 = ex.Player:getItemNum(config_grade.up_cost[1].item_type)
		self.lbl_res_need_1:setString(ex.StringUtil.getScientificNumber(cur_num_1).."/"..ex.StringUtil.getScientificNumber(config_grade.up_cost[1].item_num))
		self.lbl_res_need_1:setColor(cur_num_1 >= config_grade.up_cost[1].item_num and FONT_LIGHT_YELLOW or FONT_RED)
		local cur_num_2 = ex.Player:getItemNum(config_grade.up_cost[2].item_type)
		self.lbl_res_need_2:setString(ex.StringUtil.getScientificNumber(cur_num_2).."/"..ex.StringUtil.getScientificNumber(config_grade.up_cost[2].item_num))
		self.lbl_res_need_2:setColor(cur_num_2 >= config_grade.up_cost[2].item_num and FONT_LIGHT_YELLOW or FONT_RED)
		return
	end

	self.node_res_need_1:setVisible(false)
	self.node_res_need_2:setVisible(false)
end

function AliceUnicornLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function AliceUnicornLayer:onInfo(tag, pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(580501), ex.Tools:getLang(580564))
end

function AliceUnicornLayer:onPreview(tag, pSender)
	require("src.layer.alice.AliceUnicornPreviewCtr"):instance():openWindow(self.unicorn_type)
end

function AliceUnicornLayer:onElemInfo(tag, pSender)
	require("src.layer.alice.AliceUnicornElemInfoCtr"):instance():openWindow(self.unicorn_type)
end

function AliceUnicornLayer:onWash(tag, pSender)
	local unicorn_data = ctr.alice.data:getUnicornDataByHeroId(self.hero_id)
	if unicorn_data == nil then
		return
	end
	
	local grade_need = ex.Tools:getSysCfg("alice_unicorn_wash_open_grade")
	if unicorn_data.grade < grade_need then
		ex.MessageView:add(ex.Tools:getLang(580584))
		return
	end

	require("src.layer.alice.AliceUnicornWashCtr"):instance():openWindow(self.hero_id, self.unicorn_type)
end

function AliceUnicornLayer:onReset(tag, pSender)
	local unicorn_data = ctr.alice.data:getUnicornDataByHeroId(self.hero_id)
	if unicorn_data == nil then
		return
	end
	
	if unicorn_data.grade <= 0 and unicorn_data.strengthen_lv <= 0 then
		ex.MessageView:add(ex.Tools:getLang(580585))
		return
	end

	local rate = ex.Tools:getSysCfg("alice_unicorn_reset_rate")
	local vec_reward = cfg.aliceunicornstrengthen.getTotalCost(self.unicorn_type, unicorn_data.grade, unicorn_data.strengthen_lv)
	table.sort(vec_reward, function(a, b)
		return a.item_type < b.item_type
	end )
	for _,v in ipairs(vec_reward) do
		v.item_num = math.floor(v.item_num * rate / 100)
	end

	require("src.layer.alice.AliceUnicornResetCtr"):instance():openWindow(self.hero_id, vec_reward)
end

function AliceUnicornLayer:onUpgrade(tag, pSender)
	local unicorn_data = ctr.alice.data:getUnicornDataByHeroId(self.hero_id)
	if unicorn_data == nil then
		return
	end

	local config_level = cfg.aliceunicornstrengthen.getConfig(self.unicorn_type, unicorn_data.grade, unicorn_data.strengthen_lv + 1)
	local config_grade = cfg.aliceunicornstrengthen.getConfig(self.unicorn_type, unicorn_data.grade + 1, 0)
	if config_level ~= nil then
		for _,v in ipairs(config_level.up_cost) do
			if ex.Player:getItemNum(v.item_type) < v.item_num then
				ex.Tools:showEnoughTip(v.item_type, true)
				return
			end
		end
		local req = AliceUnicorn_pb.GReqAliceUnicornStrength()
		req.hero_id = self.hero_id
		NetManager:sendMessage(ProtocolID.GReqAliceUnicornStrength, req)
	elseif config_grade ~= nil then
		for _,v in ipairs(config_grade.up_cost) do
			if ex.Player:getItemNum(v.item_type) < v.item_num then
				ex.Tools:showEnoughTip(v.item_type, true)
				return
			end
		end
		local req = AliceUnicorn_pb.GReqAliceUnicornUpGrade()
		req.hero_id = self.hero_id
		NetManager:sendMessage(ProtocolID.GReqAliceUnicornUpGrade, req)
	else
		ex.MessageView:add(ex.Tools:getLang(580586))
		return
	end
end

-----------------------------------------------
function AliceUnicornCtr:loadLayer()
    local tmp_layer = AliceUnicornLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceUnicornCtr:onCreate()
	self:setIsSingle(false)
end

function AliceUnicornCtr:openWindow(hero_id, unicorn_type)
	if self:isOpened() then
		return
	end

	local sfc = cc.SpriteFrameCache:getInstance()
    sfc:addSpriteFrames("ccbi-res/alice.plist")
    sfc:addSpriteFrames("ccbi-res/backpack.plist")
	sfc:addSpriteFrames("ccbi-res/backpack-info.plist")

	self:loadLayer()
	self:open()
    self:initData(hero_id, unicorn_type)
end

function AliceUnicornCtr:initData(hero_id, unicorn_type)
	self.layer.hero_id = hero_id
	self.layer.unicorn_type = unicorn_type
	self.layer:updateLayer()
	-- self.layer:initData()
end

return AliceUnicornCtr
