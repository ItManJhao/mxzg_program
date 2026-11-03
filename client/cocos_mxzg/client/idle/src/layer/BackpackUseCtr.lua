
local BackpackUseCtr = class("BackpackUseCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local BackpackUsePanel = class("HeroBackpackUsePanel",require("src.comp.LuaLayerBase"))
local UIItemBackpack = require("src.comp.menu.UIMenuItemBackpack")
local UIItemHeroPiece = require("src.comp.menu.UIMenuItemHeroPiece")

function BackpackUsePanel:onCreate()
	-- self:setAutoClose(false)
	-- self:setSwallowTouches(false)
	self.menu:setSwallowsTouches(false)
	self.num = 0
	self.max = 0
	self:addBlackBackground()

	self.btn_sub:registerScriptTapHandler(handler(self, self.onClickSub))
	self.btn_add:registerScriptTapHandler(handler(self, self.onClickAdd))

	self:createEditBox()

end

function BackpackUsePanel:onClickSub(tag,pSender)
	if self.num > 0 then 
		self.num = self.num - 1
	end 
	self.selectCount:setText(self.num)
	-- self.lbl_gold_need:setString(self.num * self.data.need_gold)
	self.btn_sub:setEnabled(self.num > 0)
	self.btn_add:setEnabled(self.num < self.max)
end

function BackpackUsePanel:onClickAdd(tag,pSender)
	if self.num < self.max then 
		self.num = self.num + 1
	end
	self.selectCount:setText(self.num)
	-- self.lbl_gold_need:setString(self.num * self.data.need_gold)
	self.btn_sub:setEnabled(self.num > 0)
	self.btn_add:setEnabled(self.num < self.max)

end

function BackpackUsePanel:createEditBox()
	local size =  self.edit_box_bg:getContentSize()
	self.selectCount = ccui.EditBox:create(size,"other/spr-null.png", 1)
	self.selectCount:setPosition(self.edit_box_bg:getPosition())
	-- self.selectCount:anch(cc.p(0.5,0.5))
	self.selectCount:setAnchorPoint(cc.p(0.5,0.5))
	self.selectCount:setFontSize(18)
	self.selectCount:setFontColor(cc.WHITE)
	self.selectCount:setPlaceHolder(ex.Tools:getLang(47294))
	self.selectCount:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	self.selectCount:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
	self.selectCount:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
	self:addChild(self.selectCount)

end

function BackpackUsePanel:editboxHandle( strEventName,sender )


	if strEventName == "began" then 
		-- sender:selectedAll()
	elseif strEventName == "ended" then 
		local str = sender:getText()
		-- print(type(str), tonumber(str))
		if tonumber(str) ~= nil then 
			if tonumber(str) > 0 then
				self:setEditboxNum(math.floor(tonumber(str)))
			else
				self:setEditboxNum(0)
			end
		else
			self:setEditboxNum(0)
			ex.MessageView:add(ex.Tools:getLang(47294))
		end

	elseif strEventName == "changed" then

	end
end

function BackpackUsePanel:setEditboxNum(num)
	self.num = num
	if self.num > self.max then 
		self.num = self.max
	end
	self.selectCount:setText(self.num)
	self.btn_sub:setEnabled(self.num > 0)
	self.btn_add:setEnabled(self.num < self.max)
end

function BackpackUsePanel:getNum()
	return self.num 
end

function BackpackUsePanel:getData()
	return self.data 
end

-----------------------------

function BackpackUseCtr:onCreate()
	self:setCCBIPath("ccbi/BackpackUsePanel.ccbi")
	self:setIsSingle(false)
end

function BackpackUseCtr:getLayerClass()
	return BackpackUsePanel
end

function BackpackUseCtr:getHeroCreatLayer()
	return self.layer
end

function BackpackUseCtr:openWindow(type)
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData(type)
end

function BackpackUseCtr:initData(type)
	self:updateLayer(type)
end

function BackpackUseCtr:onClickUpgrade(tag,pSender)

end

function BackpackUseCtr:updateLayer(type)
	local layer = self.layer
	layer.btn_close:registerScriptTapHandler(handler(self,self.closeWindow))
	self.item_type = type

	local config = cfg.item.item[type]
	local num = ex.Player:getItemNum(type)
	self.is_piece = ex.Player.backpack_data:isPiece(type)
	if config.use_type == 4 then
		num = math.floor(num / config.use_value)
	else
		
	end

	layer.max = num
	layer.num = num
	layer.selectCount:setText(layer.num)
	local str = self.is_piece and ex.Tools:getLang(47438) or ex.Tools:getLang(47473)
	layer.btn_enter:setLabelText(str)

	local menu = cpp.UIMenu:create()
	layer.node_item:addChild(menu)
	menu:setPosition(0,0)

	local obj = self.is_piece and UIItemHeroPiece or UIItemBackpack
	local item = obj:createWithData(type)
	menu:addChild(item)
	item:setPosition(0,0)
	item:setScale(0.75)
	if not self.is_piece then 
		if item.lbl_num then 
			item.lbl_num:setVisible(false)
		end 
	end

	layer.lbl_name:setString(ex.Tools:getLang(type))
	layer.btn_sub:setEnabled(layer.num > 0)
	layer.btn_add:setEnabled(layer.num < layer.max)

	layer.btn_enter:registerScriptTapHandler(handler(self,self.onOpen))
end

function BackpackUseCtr:onOpen(tag,pSender)

	local config = cfg.item.item[self.item_type]
	if not config then
		return
	end

	if self.layer.num <= 0 then
		self:closeWindow()
		return
	end
	
	if ex.Player.level < config.level_require then
		ex.MessageView:add(ex.Tools:getLang(string.format(1341, config.level_require)))
		return
	end

	if self.layer.max > 0 then 
		if config.use_type == 4 then
			local req_piece = BackPack_pb.GReqElitePieceHero()
			req_piece.item_type = self.item_type
			req_piece.num = self.layer.num
		   	NetManager:sendMessage(ProtocolID.GReqElitePieceHero, req_piece)
		elseif self.is_piece then 
			-- 判断英雄背包空格是否足够
			local left = ex.Player.hero_data:getCapacity() - ex.Player.hero_data:getLen()
			if left < self.layer.num then
				ex.MessageView:add(ex.Tools:getLang(1121))
				return
			end

			-- print("self.layer.num", self.layer.num)

			-- local req_piece = cpp.ByteArray:create()
		 --    req_piece:writeInt(ProtocolID.GReqPieceReward)
		 --    req_piece:writeInt(self.item_type)
		 --    req_piece:writeInt(self.layer.num)
		 --    cpp.NetManager:instance():sendByteArray(req_piece)

		 	local req_piece = BackPack_pb.GReqPieceReward()
		 	req_piece.item_type = self.item_type
		 	req_piece.use_num = self.layer.num
			NetManager:sendMessage(ProtocolID.GReqPieceReward, req_piece)
			
		else
		    -- local req_box = cpp.ByteArray:create()
		    -- req_box:writeInt(ProtocolID.GReqOpenBoxReward)
		    -- req_box:writeInt(self.item_type)
		    -- req_box:writeInt(self.layer.num)
		    -- cpp.NetManager:instance():sendByteArray(req_box)
		    print("self.layer.num", self.layer.num)
		    local req_box = BackPack_pb.GReqOpenBoxReward()
		    req_box.item_type = self.item_type
		    req_box.use_num = self.layer.num
			NetManager:sendMessage(ProtocolID.GReqOpenBoxReward, req_box)
		end
	end
	-- require("src.layer.BackpackUseCtr"):instance():openWindow(self.item_type)
	self:closeWindow()
end


return BackpackUseCtr
