local HallowsResolveCtr = class("HallowsResolveCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local HallowsResolveLayer = class("HallowsResolveLayer", require("src.comp.EventLayer"))

local UIMenuItemBackpack = require("src.comp.menu.UIMenuItemBackpack")

function HallowsResolveLayer:onCreate()
    self:setAutoClose(true)
	self:addBlackBackground()
end

function HallowsResolveLayer:updateSelectNum(cur_num, price)
    self.lbl_res_get:setString(ex.StringUtil.getScientificNumber(cur_num * price))
end

function HallowsResolveLayer:setItemInfo(item_type)
	local config_item = cfg.item.item[item_type]
	if config_item == nil then
		return
	end

	if self.item ~= nil then
		self.item:removeFromParent()
		self.item = nil
	end
	self.item = UIMenuItemBackpack:createWithData(item_type, 0)
	self.item:setPosition(85, 330)
	self:addChild(self.item, 10)

	self.lbl_item_name:setString(ex.Tools:getLang(config_item.name))
end

function HallowsResolveLayer:setPriceType(item_type)
	self.spr_res_get:setSpriteFrame(cfg.item.item[item_type].icon..".png")
end

-----------------------------------------------------------------------------
function HallowsResolveCtr:onCreate()
	self:setCCBIPath("ccbi/HallowsResolveLayer.ccbi")
	self:setIsSingle(false)
end

function HallowsResolveCtr:getLayerClass()
	return HallowsResolveLayer
end

function HallowsResolveCtr:openWindow(item_type)
	if self:isOpened() then
		return
	end
	
	self.item_type = item_type
	self.item_num = ex.Player:getItemNum(self.item_type)

	if self.item_num <= 0 then
		return
	end
    
	self:loadLayer()
	self:open()
	self:initData()
end

function HallowsResolveCtr:initData()
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    self.layer.btn_confirm:registerScriptTapHandler(handler(self, self.onConfirm))
    self.layer.btn_add:registerScriptTapHandler(handler(self, self.onAdd))
	self.layer.btn_sub:registerScriptTapHandler(handler(self, self.onSub))
	
	self.select_num = 1

	local config_relic = cfg.dragonrelic.dragonrelic[self.item_type]
	self.item_price_type = config_relic.sell[1].item_type
	self.item_price_num = config_relic.sell[1].item_num

	self.layer:setItemInfo(self.item_type)
	self.layer:setPriceType(self.item_price_type)

	self:createEditBox()

    self:updateLayer()
end

function HallowsResolveCtr:updateLayer()
	self.layer:updateSelectNum(self.select_num, self.item_price_num)
	
	self.layer.edit_box:setText(self.select_num)
end

function HallowsResolveCtr:createEditBox()
	local size =  self.layer.edit_box_bg:getContentSize()
	self.layer.edit_box = ccui.EditBox:create(size,"other/spr-null.png", 1)
	self.layer.edit_box:setPosition(self.layer.edit_box_bg:getPosition())
	-- self.layer.edit_box:anch(cc.p(0.5,0.5))
	self.layer.edit_box:setAnchorPoint(cc.p(0.5,0.5))
	self.layer.edit_box:setFontName(FONT_DEFAULT_NAME_BOLD)
	self.layer.edit_box:setFontSize(20)
	self.layer.edit_box:setFontColor(cc.WHITE)
	-- self.layer.edit_box:setPlaceHolder(ex.Tools:getLang(47294))
	self.layer.edit_box:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
	self.layer.edit_box:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC) 
	self.layer.edit_box:registerScriptEditBoxHandler(handler(self,self.editboxHandle))
	self.layer:addChild(self.layer.edit_box)
end

function HallowsResolveCtr:editboxHandle(strEventName, sender)
	if strEventName == "began" then 
		
	elseif strEventName == "ended" then 
		local str = sender:getText()
		
		if tonumber(str) ~= nil then 
			self:setEditboxNum(tonumber(str))
		else
			if str == "" then 
				print(str,self.__cname)
				self:setEditboxNum(0)
			end
			ex.MessageView:add(ex.Tools:getLang(47294))
		end

	elseif strEventName == "changed" then

	end
end

function HallowsResolveCtr:setEditboxNum(num)
    self.select_num = num
    if self.select_num > self.item_num then
        self.select_num = self.item_num
	elseif self.select_num < 1 then
        self.select_num = 1
    end
	
	self:updateLayer()
end

function HallowsResolveCtr:onAdd(tag, pSender)
    self.select_num = self.select_num + 1
    if self.select_num > self.item_num then
        self.select_num = self.item_num
	end

	self:updateLayer()
end

function HallowsResolveCtr:onSub(tag, pSender)
    self.select_num = self.select_num - 1
    if self.select_num < 1 then
        self.select_num = 1
    end

	self:updateLayer()
end

function HallowsResolveCtr:onConfirm(tag, pSender)
	local req = Dragon_pb.GReqDragonResolve()
	req.sys_id = self.item_type
	req.num = self.select_num
	NetManager:sendMessage(ProtocolID.GReqDragonResolve, req)

	self:closeWindow()
end

return HallowsResolveCtr