local ProphetTreeShopCtr = class("ProphetTreeShopCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))
--local ShopLayer = class("ShopLayer", require("src.comp.EventLayer"))
local ProphetTreeShopLayer = class("ProphetTreeShopLayer", require("src.layer.shop.ShopLayer"))

-------------------------------------------------------------------
function ProphetTreeShopCtr:onCreate()
	self:setCCBIPath("ccbi/ProphetTreeShopLayer.ccbi")
	self:setIsSingle(false)

	self.cur_filter = 0
	self.data = {}
end

function ProphetTreeShopCtr:getLayerClass()
	return ProphetTreeShopLayer
end

function ProphetTreeShopCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self.data = data
	self.cur_filter = 0

	self:loadLayer()
	self:open()

	-- 移除内部事件调用，改用这里控制
	self.layer:removeEvent()
	self.layer:addEvent(EVENT.SHOP_EVENT.UPDATE,handler(self,self.refresh))
	self:initData()
end

function ProphetTreeShopCtr:initData()
    local layer = self.layer
	layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
	if not self.data or table.nums(self.data) <= 0 then 
		ex.MessageView:add(ex.Tools:getLang(47239))
		return 
	end

	layer.btn_elem0:setTag(0)
	layer.btn_elem0:registerScriptTapHandler(handler(self, self.onFilter))
	layer.btn_elem1:setTag(1)
	layer.btn_elem1:registerScriptTapHandler(handler(self, self.onFilter))
	layer.btn_elem2:setTag(2)
	layer.btn_elem2:registerScriptTapHandler(handler(self, self.onFilter))
	layer.btn_elem3:setTag(3)
	layer.btn_elem3:registerScriptTapHandler(handler(self, self.onFilter))
	layer.btn_elem4:setTag(4)
	layer.btn_elem4:registerScriptTapHandler(handler(self, self.onFilter))
	layer.btn_elem5:setTag(5)
	layer.btn_elem5:registerScriptTapHandler(handler(self, self.onFilter))
	
	self.btn_elem_select = require("src.layer.HeroElemSelect"):new()
	self.btn_elem_select:bindSelect(layer.btn_elem0)
	self.btn_elem_select:bindSelect(layer.btn_elem1)
	self.btn_elem_select:bindSelect(layer.btn_elem2)
	self.btn_elem_select:bindSelect(layer.btn_elem3)
	self.btn_elem_select:bindSelect(layer.btn_elem4)
	self.btn_elem_select:bindSelect(layer.btn_elem5)

	self:refreshViewByElem(self.cur_filter, true)
	layer:changeTime()
end

function ProphetTreeShopCtr:refresh( )
	if not self:isOpened() then
		return
	end

	self.data = ex.Player.market_data:getMarketDataByType(SHOP_TYPE.PROPHECY)

	self:refreshViewByElem(self.cur_filter, true)
end

function ProphetTreeShopCtr:refreshViewByElem(elem, is_force)
	if elem == self.cur_filter and not is_force then
		return
	end

	self.cur_filter = elem

	self.btn_elem_select:setSelected(elem)

	self.layer:updateView(self:doFilter(elem))
end

function ProphetTreeShopCtr:doFilter(elem)
	local result = {}

	if elem == 0 then
		result = self.data
		return result
	end

	for i,v in ipairs(self.data) do
		local conf = ex.Player.market_data:getMarketItemCfg(v.type, v.idx)

		local piece_type = conf.item_type[1].item_type
		for _, k in pairs(cfg.elitepieces.pieces) do
			if k.item_type == piece_type and k.element == elem then
				table.insert(result, v)
			end
		end
	end

	return result
end

function ProphetTreeShopCtr:onFilter(tag, pSender)
	self:refreshViewByElem(tag)
end

return ProphetTreeShopCtr