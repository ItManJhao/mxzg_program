local FantasyTowerBuyCtr = class("FantasyTowerBuyCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
local FantasyTowerBuyLayer = class("FantasyTowerBuyLayer", require("src.comp.LuaLayerBase"))

function FantasyTowerBuyLayer:onCreate()
	self:addBlackBackground()
	local win_size = cc.Director:getInstance():getWinSize();
	local height = Maths.min(self:getContentSize().height, win_size.height);
	self:setScale(height / self:getContentSize().height);

	-- 设置透明背景大小
	self.spr_bg:setContentSize(win_size.width * 2, win_size.height * 2)
	self.btn_buy:setLabelText(ex.Tools:getLang(47120))
	self.btn_buy:setLabelOutLine(FONT_BROWN_C4B, 4)

	self.buy_num = 1
end

-----------------------------------------------------------------------------
function FantasyTowerBuyCtr:onCreate()
	self:setCCBIPath("ccbi/FantasyTowerBuyLayer.ccbi")
	self:setIsSingle(false)
end

function FantasyTowerBuyCtr:getLayerClass()
	return FantasyTowerBuyLayer
end

function FantasyTowerBuyCtr:getFantasyTowerBuyLayer()
	return self.layer
end

function FantasyTowerBuyCtr:openWindow()
	if self:isOpened() then
		return
	end
	
	self:loadLayer()
	self:open()
	self:initData()
end

function FantasyTowerBuyCtr:initData()
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	
    self.layer.btn_sub1:registerScriptTapHandler(handler(self, self.onSub))
	self.layer.btn_add1:registerScriptTapHandler(handler(self, self.onAdd))

	self.layer.btn_buy:registerScriptTapHandler(handler(self, self.onBuy))

	self:updateLayer()
end

function FantasyTowerBuyCtr:updateLayer()
	if not self:getLayer() then
		return
	end

	local layer = self.layer
	layer.lbl_gem_num:setString(string.format("%d", ex.Player.gem))
	layer.lbl_energy_num:setString(string.format("%d", ex.Player.tower_data.energy))

	layer.spr_icon:setSpriteFrame(string.format("backpack/%d.png", ItemType.IT_GEM))
	layer.spr_icon:setScale(0.5)
	layer.spr_gem:setSpriteFrame(string.format("backpack/%d.png", ItemType.IT_GEM))
	layer.spr_gem:setScale(0.5)

	local price = layer.buy_num * ex.Tools:getSysCfg("tower_tickets_gem_cost")
	layer.lbl_buy_num:setString(string.format("%d", layer.buy_num))
	layer.lbl_need_gem:setString(string.format("%d", price))
end

function FantasyTowerBuyCtr:onSub(tag, pSender)
	local layer = self.layer
	layer.buy_num = math.max(1, layer.buy_num - 1)
	self:updateLayer()
end

function FantasyTowerBuyCtr:onAdd(tag, pSender)
	local layer = self.layer

	local max_num = ex.Player.gem / ex.Tools:getSysCfg("tower_tickets_gem_cost")
	local num = layer.buy_num + 1
	if num <= max_num then
		layer.buy_num = num
	end
	self:updateLayer()
end


function FantasyTowerBuyCtr:onBuy(tag, pSender)
	local layer = self.layer
	local price = layer.buy_num * ex.Tools:getSysCfg("tower_tickets_gem_cost")

	if price > ex.Player.gem then
		ex.MessageView:add(ex.Tools:getLang(47428))
		return
	end

	-- ex.Player:addGem(-price)
	-- local req_buy = ProtocolRequest.ReqTowerEnergyBuy
	-- req_buy.num.value = layer.buy_num
	-- NetManager:sendLuaData(req_buy)
	
	local req_buy = Tower_pb.GReqTowerEnergyBuy()
	req_buy.num = layer.buy_num
    NetManager:sendMessage(ProtocolID.GReqTowerEnergyBuy, req_buy)

	self:closeWindow(tag, pSender)
end


return FantasyTowerBuyCtr
