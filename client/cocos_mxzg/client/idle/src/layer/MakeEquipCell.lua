local MakeEquipCell = class("HeroMakeEquipCell",require("src.comp.LuaLayerBase"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function MakeEquipCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.menu:setSwallowsTouches(false)
	self._num = 0
	local scale = 1
	self.need_item  = UIItemBackpack:createWithData(0, 0)
	self.menu:addChild(self.need_item)
	self.need_item:setPosition(self.need_node:getPosition())
	self.need_item:setEnableAction(true)
	self.btn_sub:registerScriptTapHandler(handler(self, self.onClickSub))
	self.btn_add:registerScriptTapHandler(handler(self, self.onClickAdd))
	self.need_item:registerScriptTapHandler(handler(self, self.onClickTips))
	self.need_item:setScale(scale)
	if self.need_item.lbl_str then 
		self.need_item.lbl_str:setScale(scale)
	end

	self.cur_item  = UIItemBackpack:createWithData(0, 0)
	self.menu:addChild(self.cur_item)
	self.cur_item:setPosition(self.cur_node:getPosition())
	self.cur_item:setEnableAction(true)
	self.cur_item:registerScriptTapHandler(handler(self, self.onClickTips))
	self:createEditBox()
	self.cur_item:setScale(scale)

end

function MakeEquipCell:reset(data)
	if not data then return end
	self.data = data 
	self:onFlush()
end 

function MakeEquipCell:onFlush()
	local hasNum = ex.Player.backpack_data:getEquipTypeNum(self.data.need_equipment[1].item_type)
	local str = hasNum .. "/" .. self.data.need_equipment[1].item_num
	local color = hasNum < self.data.need_equipment[1].item_num and TIPS_RED or cc.c3b(255,255,255)

	self.max = math.min(math.floor(hasNum / self.data.need_equipment[1].item_num) , math.floor(ex.Player.gold / self.data.need_gold) )
	self.num = self.max == 0 and 1 or self.max
	-- self.btn_sub:setEnabled(self.max > 0)
	-- self.btn_add:setEnabled(false)

	self.need_item:setIconType(self.data.need_equipment[1].item_type)
	self.need_item:setNumByStr(str)
	self.need_item:setLblStrNumColor(color)
	local config = cfg.item.item[self.data.need_equipment[1].item_type]
	self.need_item:resetBg(nil,config.rare_mark)

	self.lbl_gold_need:setString(ex.StringUtil.getScientificNumber(self.data.need_gold * self.max))
	self:setGoldNum(self.data.need_gold * (self.max == 0 and 1 or self.num))
	self.lbl_gold_need:setPositionX(self:getContentSize().width / 2)
	-- self.selectCount:setText(self.max == 0 and 1 or self.max)
	self.selectCount:setText(self.num)

	local start_pos_x = self.spr_gold_need:getPositionX() + self.spr_gold_need:getContentSize().width * self.spr_gold_need:getScaleX() / 2
	if self.lbl_gold_need:getPositionX() - self.lbl_gold_need:getContentSize().width * self.lbl_gold_need:getScaleX() / 2 < start_pos_x then
		self.lbl_gold_need:setPositionX(start_pos_x + self.lbl_gold_need:getContentSize().width * self.lbl_gold_need:getScaleX() / 2)
	end

	self.cur_item:setIconType(self.data.equipment_type, 0)
	config = cfg.item.item[self.data.equipment_type]
	self.cur_item:resetBg(nil, config.rare_mark)

	if self.need_item.lbl_str then 
		self.need_item.lbl_str:setScale(0.4)
	end

	local max = self.max == 0 and 1 or self.max
	if self.num < max then 
		self.num = self.num + 1
	end
	self.btn_sub:setEnabled(self.num > 1)
	self.btn_add:setEnabled(self.num < max)

end

function MakeEquipCell:onClickSub(tag,pSender)
	if self.num > 1 then 
		self.num = self.num - 1
	end 
	self.selectCount:setText(self.num)
	-- self.lbl_gold_need:setString(self.num * self.data.need_gold)
	self:setGoldNum(self.num * self.data.need_gold)
	self.btn_sub:setEnabled(self.num > 1)
	local max = self.max == 0 and 1 or self.max
	self.btn_add:setEnabled(self.num < max)

end

function MakeEquipCell:onClickAdd(tag,pSender)
	local max = self.max == 0 and 1 or self.max
	if self.num < max then 
		self.num = self.num + 1
	end
	self.selectCount:setText(self.num)
	-- self.lbl_gold_need:setString(self.num * self.data.need_gold)
	self:setGoldNum(self.num * self.data.need_gold)
	self.btn_sub:setEnabled(self.num > 1)
	self.btn_add:setEnabled(self.num < max)

end

function MakeEquipCell:onClickTips(tag,pSender)
	local config = cfg.equipmenttype.equip[pSender:getType()]
	local ctr = require("src.layer.AbilityInfoCtr"):instance()
	ctr:openWindow()
	:addEquipInfo(config,{})
end

function MakeEquipCell:createEditBox()
	local size =  self.edit_box_bg:getContentSize()
	self.selectCount = ccui.EditBox:create(size,"other/spr-null.png", 1)
	self.selectCount:setPosition(self.edit_box_bg:getPosition())
	-- self.selectCount:anch(cc.p(0.5,0.5))
	self.selectCount:setAnchorPoint(cc.p(0.5,0.5))
	self.selectCount:setFontName(FONT_DEFAULT_NAME_BOLD)
	self.selectCount:setFontSize(20)
	self.selectCount:setFontColor(cc.WHITE)
	self.selectCount:setPlaceHolder(ex.Tools:getLang(47294))
	self.selectCount:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	self.selectCount:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
	self.selectCount:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
	self:addChild(self.selectCount)
end

function MakeEquipCell:editboxHandle( strEventName,sender )


	if strEventName == "began" then 
		-- sender:selectedAll()
	elseif strEventName == "ended" then 
		local str = sender:getText()
		-- print(type(str), tonumber(str))
		if tonumber(str) ~= nil then 
			self:setEditboxNum(math.max(1, tonumber(string.format("%d", tonumber(str)))))
			self.btn_sub:setEnabled(self.num > 1)
			self.btn_add:setEnabled(self.num < self.max)
		else
			sender:setText(1)
			self:setEditboxNum(1)
			self.num = 1

			ex.MessageView:add(ex.Tools:getLang(47294))
		end

	elseif strEventName == "changed" then

	end
end

function MakeEquipCell:setEditboxNum(num)
	self.num = math.min(num, self.max)
	print("max"..self.num,self.max)
	-- if self.num > self.max then 
	-- 	self.num = self.max
	-- end

	-- self.selectCount:setText(self.num)
	self.selectCount:setText(self.num)
	-- self.lbl_gold_need:setString(math.min( self.num,self.max )* self.data.need_gold)
	self:setGoldNum(self.num * self.data.need_gold)
	self.btn_sub:setEnabled(self.num > 1)
	self.btn_add:setEnabled(self.num < self.max)
end

function MakeEquipCell:setGoldNum(num)
	local gold = ex.Player.gold
	local color = gold < num and TIPS_RED or cc.c3b(255,255,255)
	self.lbl_gold_need:setColor(color)
	self.lbl_gold_need:setString(ex.StringUtil.getScientificNumber(num))
end

function MakeEquipCell:can()
	-- body
	local type = 0
	if self.max < self.num then 
		local hasNum = ex.Player.backpack_data:getEquipTypeNum(self.data.need_equipment[1].item_type)
		if hasNum < self.data.need_equipment[1].item_num then 
			type = 1
		elseif ex.Player.gold < self.data.need_gold then 
			type = 2
		end 
	end 
	return self.max >= self.num, type
end

function MakeEquipCell:getNum()
	return self.num 
end

function MakeEquipCell:getData()
	return self.data 
end

return MakeEquipCell
