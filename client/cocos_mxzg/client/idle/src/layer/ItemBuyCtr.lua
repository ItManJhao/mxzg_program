local ItemBuyCtr = class("ItemBuyCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local ItemBuyLayer = class("ItemBuyLayer", require("src.comp.LuaLayerBase"))


function ItemBuyLayer:onCreate()
	self:addBlackBackground()

	local btn_size = self.btn_done:getContentSize()
	local lbl_btn_txt = cc.Label:createWithTTF(ex.Tools:getLang(2401), FONT_DEFAULT_NAME_BOLD, 26)
	:setTextColor(FONT_BLACK)
	:setPosition(btn_size.width / 2, btn_size.height / 2)
	self.btn_done:addChild(lbl_btn_txt)
end


function ItemBuyLayer:initDone(buy_item_type, cost_num)
	self.buy_num = 1
	self.cost_num = cost_num -- 这里要读配置

	self.max_num = math.floor(ex.Player.gem / self.cost_num)
	if self.max_num < 1 then
		self.max_num = 1
	elseif self.max_num > 100 then
		self.max_num = 100
	end

	self:setText()

	self.lbl_title:setString(ex.Tools:getLang(41007)) -- 道具购买
	self.lbl_name:setString(ex.Tools:getLang(buy_item_type))

	local btn_info = ex.Player.backpack_data:createWithData(buy_item_type, 0)
	btn_info:setPosition(self.lbl_name:getPositionX(),
		(self.lbl_name:getPositionY() + self.lbl_buy_num:getPositionY()) / 2 + 5)
    btn_info:registerScriptTapHandler(handler(self, self.onBtnInfo))
    self.btn_done:getParent():addChild(btn_info)

    self.btn_done:setTag(buy_item_type)
end

function ItemBuyLayer:onBtnInfo(tag, pSender)
	ex.Tools:onClickItemInfo(pSender.item_type)
end

function ItemBuyLayer:setText()
	self.lbl_buy_num:setString(tostring(self.buy_num))
	self.lbl_need_num:setString(tostring(self.buy_num * self.cost_num))
end

function ItemBuyLayer:onAdd()
	self.buy_num = self.buy_num + 1
	if self.buy_num > self.max_num then
		self.buy_num = self.max_num

		if self.max_num < 100 then
			ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
		end
	end

	self:setText()
end

function ItemBuyLayer:onSub()
	self.buy_num = self.buy_num - 1
	if self.buy_num < 1 then
		self.buy_num = 1
	end

	self:setText()
end


---------------------------------------------------

function ItemBuyCtr:onCreate()
	self:setCCBIPath("ccbi/ItemBuyLayer.ccbi")
	self:setIsSingle(false)
end

function ItemBuyCtr:getLayerClass()
	return ItemBuyLayer
end

function ItemBuyCtr:openWindow(buy_item_type, cost_num, callback)
	if self:isOpened() then
		return
	end

	self.callback = callback

	self:loadLayer()
	self:open()
	self:initDone(buy_item_type, cost_num)
end

function ItemBuyCtr:initDone(buy_item_type, cost_num)
    self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
    
	self.layer.btn_done:registerScriptTapHandler(handler(self, self.onBtnDone))

	self.layer.btn_add:registerScriptTapHandler(handler(self, self.onBtnAdd))
	self.layer.btn_sub:registerScriptTapHandler(handler(self, self.onBtnSub))

	self.layer:initDone(buy_item_type, cost_num)
end

function ItemBuyCtr:onBtnDone(tag, pSender)
	local need_gem = self.layer.buy_num * self.layer.cost_num
	if ex.Player.gem < need_gem then
		ex.MessageView:add(ex.Tools:getLang(1109)) -- 钻石不足
        return
	end

	-- local act_eas = cc.CallFunc:create(handler(obj, method))

	-- ex.Player:addGem(-need_gem)
	-- ex.Player:addItem(tag, self.layer.buy_num)

	-- 你成功购买了%s*%d
	-- ex.MessageView:add(string.format(ex.Tools:getLang(41012),
	-- 	ex.Tools:getLang(tag),
	-- 	self.layer.buy_num), 0)

	-- -- 发送数据
	-- local req_buy_item = cpp.ByteArray:create()
	-- req_buy_item:writeInt(ProtocolID.GReqBuyItem)
	-- req_buy_item:writeInt(tag) -- item_type
	-- req_buy_item:writeInt(self.layer.buy_num) -- item_num
	-- cpp.NetManager:instance():sendByteArray(req_buy_item)

	if self.callback then
		self.callback(self.layer.buy_num)
	end
	
	self:closeWindow(nil, self,layer)
end

function ItemBuyCtr:onBtnAdd(tag, pSender)
	self.layer:onAdd()
end

function ItemBuyCtr:onBtnSub(tag, pSender)
	self.layer:onSub()
end

return ItemBuyCtr
