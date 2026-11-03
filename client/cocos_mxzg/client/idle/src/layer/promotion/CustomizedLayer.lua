local CustomizedLayer = class("CustomizedLayer", require("src.layer.promotion.PromotionBaseLayer"))

function CustomizedLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self.model = ex.Player.promotion_data.customized_data

	self:editCellData()
	
	local notch_height = require("src.model.Game"):instance():getNotchHeight()
	
	self.banner_layer = require("src.layer.promotion.CustomizedBanner"):createWithCCBIFile("ccbi/CustomizedBanner.ccbi")
	
	local top_y = self.layer_promotion:getTopY()
	self.banner_layer:setAnchorPoint(ex.a.left_bottom)
    self.banner_layer:setPosition(0, top_y - self.banner_layer:getContentSize().height) -- + self.banner_layer:getContentSize().height * 0.5)
	self:addChild(self.banner_layer)
	-- local level = self:getLevel()
	
	top_y = top_y - self.banner_layer:getContentSize().height - 10
	local table_size = cc.size(620, top_y - self.layer_promotion:getBottomY() * ex.s.global_scale - 60 * ex.s.global_scale)
	self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.promotion.CustomizedCell"),"ccbi/CustomizedCell.ccbi"}, table_size, 4,cc.p(10, self.layer_promotion:getBottomY() * ex.s.global_scale + 60 * ex.s.global_scale + table_size.height * (1 -ex.s.global_scale)))
	local posX = (ex.p.width - table_size.width * ex.s.global_scale) / 2
	self.tableView:setPositionX(posX * ex.s.global_scale)
	self.tableView:setScale(ex.s.global_scale)
	self:addEvent(EVENT.CUSTOMIZED.UPDATE_CUSTOMIZED_ITEM,handler(self,self.onCustomized))
	self:addEvent(EVENT.CUSTOMIZED.UPDATE_BUY_RECORD_DATA,handler(self,self.onBuyRecord))

	-- 已看过私人定制界面的，再次登录前不再显示红点
	ex.Player.promotion_data.customized_data:setShowCustomizedAlready()
end

function CustomizedLayer:onCustomized(event,data)
	self.tableView:reloadData()
end

function CustomizedLayer:onBuyRecord(event,data)
	self:editCellData()
	self.tableView:initData(self.cell_data)
end


function CustomizedLayer:editCellData()
 
	local cfg_cell = self.model:getCfg()
	self.cell_data = {}

	for k,v in pairs(cfg_cell) do
		table.insert(self.cell_data,v)
	end

	local function sor(a,b)

		local custom_data_a = self.model:getCustomById(a.product_id)
		local custom_data_b = self.model:getCustomById(b.product_id)

		local buy_count_a = custom_data_a ~= nil and custom_data_a.buy_count or 0
		local buy_count_b = custom_data_b ~= nil and custom_data_b.buy_count or 0

		local cfg_a = cfg.buygem.buygem[a.product_id]
		local cfg_b = cfg.buygem.buygem[b.product_id]

		local can_buy_a = buy_count_a < cfg_a.limit_times
		local can_buy_b = buy_count_b < cfg_b.limit_times

		local proA = can_buy_a and 100 or 0
		local proB = can_buy_b and 100 or 0

		if proA == proB then return a.product_id < b.product_id end 
		return proA > proB
	end

	table.sort(self.cell_data,sor)
	
end

function CustomizedLayer:updateLayer(event,data)
	-- body
	self:editCellData()

	local save_pos = data == true
	local posY = 0
	if save_pos == true then 
		posY = self.tableView:getContainer():getPositionY()
	end
	self.tableView:initData(self.cell_data)
	if save_pos == true then self.tableView:setContentOffset(cc.p(0,posY)) end
end

return CustomizedLayer
