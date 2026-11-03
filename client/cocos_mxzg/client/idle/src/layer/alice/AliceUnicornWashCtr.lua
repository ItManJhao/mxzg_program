local AliceUnicornWashCtr = class("AliceUnicornWashCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

local AliceUnicornWashLayer = class("AliceUnicornWashLayer", require("src.layer.ui.UI_AliceUnicornWashLayer"))
------------------------------------------------
function AliceUnicornWashLayer:onCreate()
	self.super.onCreate(self)
	self:setName("AliceUnicornWashLayer")

	self:addBlackBackground()

    self:addEvent(EVENT.ALICE.ALICE_UNICORN_WASH, handler(self, self.updateLayer))

	self.lock_list = {}
end

function AliceUnicornWashLayer:updateLayer()
	self:updateElemBefore()
	self:updateElemAfter()
	self:updateLock()
	self:updateResNeed()

	if self.unicorn_data.wash_rare_attr == nil or #self.unicorn_data.wash_rare_attr <= 0 then
		self.btn_save:setVisible(false)
		self.btn_wash:setPositionX(0)
	else
		self.btn_save:setVisible(true)
		self.btn_wash:setPositionX(-120)
	end
end

function AliceUnicornWashLayer:updateLock()
	for i=1,99 do
		local btn_lock = self["btn_lock_"..i]
		if btn_lock == nil then
			break
		end

		local is_have = false
		for _,v in ipairs(self.lock_list) do
			if v == i then
				is_have = true
				break
			end
		end

		ex.Tools:setSpriteFrameAsyn(btn_lock:getNormalImage(), (is_have and "alice/btn-lock.png" or "alice/btn-unlock.png"), "alice")
	end
end

function AliceUnicornWashLayer:updateElemBefore()
	for i=1,99 do
		local node_elem = self["node_attr_before_"..i]
		if node_elem == nil then
			break
		end

		local attr_data = self.unicorn_data.rare_attr[i]
		if attr_data ~= nil then
			ex.Tools:setSpriteFrameAsyn(self["spr_attr_before_"..i], string.format("backpack-info/spr-attribute-%d.png", attr_data.attr_type), "backpack-info")
			self["lbl_attr_before_"..i]:setString(ex.Tools:getLang(2150000 + attr_data.attr_type))
			self["lbl_attr_extra_before_"..i]:setPositionX(self["lbl_attr_before_"..i]:getPositionX() + self["lbl_attr_before_"..i]:getContentSize().width + 10)
			self["lbl_attr_extra_before_"..i]:setVisible(true)

			local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + attr_data.attr_type), "##" , attr_data.attr_value, "<font color='#219A00'>%s</font>")
			if not flag then
				self["lbl_attr_extra_before_"..i]:setString(attr_data.attr_value)
			else
				self["lbl_attr_extra_before_"..i]:setString(string.format("%.1f", attr_data.attr_value / 100) .. "%")
			end
		else
			self["lbl_attr_before_"..i]:setString(ex.Tools:getLang(580516 + i))
			self["lbl_attr_extra_before_"..i]:setVisible(false)
		end
	end
end

function AliceUnicornWashLayer:updateElemAfter()
	for i=1,99 do
		local node_elem = self["node_attr_after_"..i]
		if node_elem == nil then
			break
		end

		-- 如果属性存在则显示出来，否则显示问号
		local attr_data = self.unicorn_data.wash_rare_attr[i]
		if attr_data ~= nil and attr_data.attr_type ~= nil then
			ex.Tools:setSpriteFrameAsyn(self["spr_attr_after_"..i], string.format("backpack-info/spr-attribute-%d.png", attr_data.attr_type), "backpack-info")
			self["lbl_attr_after_"..i]:setString(ex.Tools:getLang(2150000 + attr_data.attr_type))
			self["lbl_attr_extra_after_"..i]:setPositionX(self["lbl_attr_after_"..i]:getPositionX() + self["lbl_attr_after_"..i]:getContentSize().width + 10)
			self["lbl_attr_extra_after_"..i]:setVisible(true)

			local flag = ex.StringUtil.formatAttrStrBool(ex.Tools:getLang(2141000 + attr_data.attr_type), "##" , attr_data.attr_value, "<font color='#219A00'>%s</font>")
			if not flag then
				self["lbl_attr_extra_after_"..i]:setString(attr_data.attr_value)
			else
				self["lbl_attr_extra_after_"..i]:setString(string.format("%.1f", attr_data.attr_value / 100) .. "%")
			end
		else
			self["lbl_attr_after_"..i]:setString("????????")
			self["lbl_attr_extra_after_"..i]:setVisible(false)
		end
	end
end

function AliceUnicornWashLayer:updateResNeed()
	local lock_num = table.nums(self.lock_list)
	local config = cfg.aliceunicornwash.aliceunicornwash[lock_num]
	if config == nil then
		return
	end

	ex.Tools:setSpriteFrameAsyn(self.btn_res_need:getNormalImage(), "backpack/"..config.cost[1].item_type..".png", "backpack-5")
	self.btn_res_need.item_type = config.cost[1].item_type

	local cur_num = ex.Player:getItemNum(config.cost[1].item_type)
	self.lbl_res_need:setString(ex.StringUtil.getScientificNumber(cur_num).."/"..ex.StringUtil.getScientificNumber(config.cost[1].item_num))
	self.lbl_res_need:setColor(cur_num >= config.cost[1].item_num and FONT_LIGHT_YELLOW or FONT_RED)
end

function AliceUnicornWashLayer:onItemInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function AliceUnicornWashLayer:onInfo(tag, pSender)
	ex.InfoCtr:openWindow(ex.Tools:getLang(580583), ex.Tools:getLang(580582))
end

function AliceUnicornWashLayer:onElemInfo(tag, pSender)
	require("src.layer.alice.AliceUnicornElemInfoCtr"):instance():openWindow(self.unicorn_type)
end

-- 属性锁定
function AliceUnicornWashLayer:onLock(tag, pSender)
	if tag <= 0 then
		return
	end

	if self.unicorn_data.rare_attr[tag] == nil then
		ex.MessageView:add(ex.Tools:getLang(580587))
		return
	end

	local is_have = false
	for i,v in ipairs(self.lock_list) do
		if v == tag then
			table.remove(self.lock_list, i)

			is_have = true

			break
		end
	end

	if not is_have then
		table.insert(self.lock_list, tag)
	end

	ex.Tools:setAllGrayAuto(self.btn_wash:getNormalImage(), #self.lock_list == 5)
	self.btn_wash:setEnabled( not (#self.lock_list == 5))

	self:updateLock()
	self:updateResNeed()
end

-- 属性洗练
function AliceUnicornWashLayer:onWash(tag, pSender)
	if self.unicorn_data == nil then
		return
	end

	local lock_num = table.nums(self.lock_list)
	local config = cfg.aliceunicornwash.aliceunicornwash[lock_num]
	if config == nil then
		return
	end

	for _,item_data in ipairs(config.cost) do
		if ex.Player:getItemNum(item_data.item_type) < item_data.item_num then
			ex.Tools:showEnoughTip(item_data.item_type, true)
			return
		end
	end

	local req = AliceUnicorn_pb.GReqAliceUnicornWash()
	req.hero_id = self.unicorn_data.hero_id
	for _,v in pairs(self.lock_list) do
		table.insert(req.lock_grade, v)
	end
	NetManager:sendMessage(ProtocolID.GReqAliceUnicornWash, req)
end

-- 属性保存
function AliceUnicornWashLayer:onSave(tag, pSender)
	if self.unicorn_data == nil then
		return
	end

	if self.unicorn_data.wash_rare_attr == nil or #self.unicorn_data.wash_rare_attr <= 0 then
		ex.MessageView:add(ex.Tools:getLang(580588))
		return
	end

	local req = AliceUnicorn_pb.GReqAliceUnicornWashSave()
	req.hero_id = self.unicorn_data.hero_id
	NetManager:sendMessage(ProtocolID.GReqAliceUnicornWashSave, req)
end

-----------------------------------------------
function AliceUnicornWashCtr:loadLayer()
    local tmp_layer = AliceUnicornWashLayer:create()
    self:setLayer(tmp_layer)
	self:registerTouchListen()
end

function AliceUnicornWashCtr:onCreate()
	self:setIsSingle(false)
end

function AliceUnicornWashCtr:openWindow(hero_id, unicorn_type)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
    self:initData(hero_id, unicorn_type)
end

function AliceUnicornWashCtr:initData(hero_id, unicorn_type)
	local unicorn_data = ctr.alice.data:getUnicornDataByHeroId(hero_id)
	if unicorn_data == nil then
		return
	end
	
	self.layer.unicorn_data = unicorn_data
	self.layer.unicorn_type = unicorn_type

	self.layer:updateLayer()
end

return AliceUnicornWashCtr

