local GrowUpLayer = class("GrowUpLayer", require("src.layer.promotion.PromotionBaseLayer"))

function GrowUpLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	self:editCellData()
	
	local notch_height = require("src.model.Game"):instance():getNotchHeight()
	
    self.banner_layer = require("src.layer.promotion.GrowUpGiftBanner"):createWithCCBIFile("ccbi/GrowUpGiftBanner.ccbi")
	
	local top_y = self.layer_promotion:getTopY()
	self.banner_layer:setScale(ex.s.global_scale)
	self.banner_layer:setAnchorPoint(ex.a.left_bottom)
    self.banner_layer:setPosition(0, top_y - self.banner_layer:getContentSize().height * ex.s.global_scale) -- + self.banner_layer:getContentSize().height * 0.5)
	self:addChild(self.banner_layer)
	local level = self:getLevel()
	local day_reward = cfg.growthgift.vip[level]
	self.banner_layer:reset(day_reward)
	
	top_y = top_y - self.banner_layer:getContentSize().height * ex.s.global_scale - 10
	local table_size = cc.size(620, top_y - self.layer_promotion:getBottomY() - 20)
	self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.promotion.GrowUpGiftCell"),"ccbi/GrowUpGiftCell.ccbi"}, table_size, 4,cc.p(10, self.layer_promotion:getBottomY() + 20))

	local posX = (ex.p.width - table_size.width) / 2
	self.tableView:setPositionX(posX)
	self:addEvent(EVENT.PROMOTION_EVENT.MONTH_CARD_GETED,handler(self,self.onMonthCard))
	self:addEvent(EVENT.PROMOTION_EVENT.VIP_REWARD_BUY,handler(self,self.updateLayer)) 
	self:addEvent(EVENT.PROMOTION_EVENT.VIP_REWARD_GET,handler(self,self.updateLayer))
	self:addEvent(EVENT.ROLE_RESOURCE_EVENT.UPDATE_GEM,handler(self,self.onCharge))
end

function GrowUpLayer:getLevel()
	local idx = 0
	for k,v in ipairs(cfg.growthgift.vip) do
		-- print("???????",ex.Player.total_charge,v.need_recharge)
		if ex.Player.total_charge >= v.need_recharge then 
			idx = v.idx 
		end 
	end
	-- print(self.__cname,idx,ex.Player.total_charge ,ex.Player.total_charge,">>>>>>????")
	return idx
end


function GrowUpLayer:editCellData()
 
	local data = cfg.growthgift.vip
	self.cell_data = {}
	for k,v in pairs(data) do
		if v.show_need_recharge <= ex.Player.total_charge and v.idx > 0 then 
			table.insert(self.cell_data,v)
		end
	end

	local function sor(a,b)
		-- body
		return a.idx < b.idx
	end

	table.sort(self.cell_data,sor)

	self:sortCellData()

end

function GrowUpLayer:sortCellData()

	local function sor(a,b)
		local a_is_buy = TableEx.findFunction(ex.Player.promotion_data.vip_list, function(value)
	        if value == a.idx then
	            return true
	        end
	    end)

	    local b_is_buy = TableEx.findFunction(ex.Player.promotion_data.vip_list, function(value)
	        if value == b.idx then
	            return true
	        end
	    end)

		if a_is_buy then
			if b_is_buy then
				return a.idx < b.idx
			else
				return false
			end
		else
			if b_is_buy then
				return true
			else
				return a.idx < b.idx
			end
		end
	    -- local a_can_get = ex.Player.promotion_data:getGrowUpByLevel(a.idx) == 0
	    -- local b_can_get = ex.Player.promotion_data:getGrowUpByLevel(b.idx) == 0

	    -- local proA = 0
	    -- local proB = 0

	    -- if not a_is_buy or a_can_get then 
	    -- 	proA = 100
	    -- end

	    -- if not b_is_buy or b_can_get then 
	    -- 	proB = 100
	    -- end

	    -- if proA == proB then 
	    -- 	return a.idx < b.idx 
	    -- else
	    -- 	return proA > proB
	    -- end
	end

	table.sort(self.cell_data,sor)

end

function GrowUpLayer:onCharge(event,data)
	local data =  cfg.growthgift.vip
	local level = self:getLevel()
	local day_reward = data[level]
	self.banner_layer:reset(day_reward)
	self:updateLayer(event,data)
end

function GrowUpLayer:onMonthCard(event,data)
	local data =  cfg.growthgift.vip
	local level = self:getLevel()
	local day_reward = data[level]
	self.banner_layer:reset(day_reward)
end

function GrowUpLayer:updateLayer(event,data)
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

return GrowUpLayer
