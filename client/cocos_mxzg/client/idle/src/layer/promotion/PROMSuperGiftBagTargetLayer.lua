local PROMSuperGiftBagTargetLayer = class("PROMSuperGiftBagTargetLayer", require("src.layer.promotion.PromotionBaseLayer"))

function PROMSuperGiftBagTargetLayer:onCreateDone()
    self:setSwallowTouches(false)
    self:setAutoClose(false)

    self.promotion_id = 39
    self.time_info = {}

    self:addBannerImage(ex.Player.promotion_data:getPromotionConfigByIdx(402))

    self:addTimeProgress()
    self:initdDone()

    self:addEvent(EVENT.MAIN_CITY_PROMOTION.SUPER_WELFARE,handler(self,self.updateList))
end

function PROMSuperGiftBagTargetLayer:updateCDTime()
    local remain_time = self.time_info.end_time - ex.Game:getServerTime()

    if ex.Game:getServerTime() < self.time_info.start_time then 
		self.time_text:setXmlTextLua(ex.Tools:getLang(41052));
		return 
	end 

	if remain_time < 0 then 
		self.time_text:setXmlTextLua(ex.Tools:getLang(41053));

		self:removeTimerByName("super_gift_timer")
		return
	end

    if remain_time > 86400 then
        self.time_text:setXmlTextLua(string.format(ex.Tools:getLang(41130),
            math.floor(remain_time / 86400)))
    else
        self.time_text:setXmlTextLua(string.format(ex.Tools:getLang(41129), 
            math.floor(remain_time / 3600),
            math.floor(remain_time / 60 % 60),
            math.floor(remain_time % 60)))
    end
end

function PROMSuperGiftBagTargetLayer:initdDone()
    local bg_size = self.gift_list:getContentSize()

    self.cell_data =  self:generateData()
    
    local sub_size = cc.size(60, 60)

    local viewSize = sub_size
    local posx = self.gift_list:getPositionX()
    local posy = self.gift_list:getPositionY()

	if  self.layer_promotion then
		local top_y = self.layer_promotion:getTopY()
		top_y = top_y - 20 - 95	-- banner高106
    	
        viewSize = cc.size(ex.p.width - sub_size.width, top_y - self.layer_promotion:getBottomY() - sub_size.height)
        posx = ex.p.width * 0.5 - viewSize.width * 0.5
        posy = self.layer_promotion:getBottomY() + sub_size.height * 0.5
	end

    if viewSize.width > bg_size.width then 
        viewSize.width = bg_size.width
        posx = ex.p.width * 0.5 - viewSize.width * 0.5
    end

    self.tableView = ex.Tools:initTableView(self,self.cell_data, {require("src.layer.promotion/PROMSuperGiftTargetCell"),"ccbi/PROMSuperGiftTargetCell.ccbi"} , viewSize, 7 , cc.p(posx, posy))

    self:addTimer("super_gift_timer", 1000, handler(self, self.updateCDTime), true)
    self:updateCDTime()

end

function  PROMSuperGiftBagTargetLayer:generateData()
    self.time_info = ex.Player.promotion_data:getPromotionDatas(self.promotion_id)
    if self.time_info == nil then
        self.time_info = {start_time = 0, end_time = 0, clear_time = 0}
    end

    local result = {}
    for i,v in ipairs(cfg.promotionovervaluegift.promotionovervaluegift) do
        if cfg.buygem.buygem[v.production_id] ~= nil then
            table.insert(result, {data = {
                idx = v.idx, 
                buy_times = ex.Player.promotion_data:getTimesOverValueForIdx(v.idx),
                can_buy = ex.Player.promotion_data:canBuyOverValueForIdx(v.idx),
                rmb = cfg.buygem.buygem[v.production_id].rmb
            }, config = v})
        end
    end

    --检测剩余排序
    table.sort(result, function(a, b)
        if not a.data.can_buy and not b.data.can_buy then return a.config.idx < b.config.idx end

        if not a.data.can_buy then return false end
        if not b.data.can_buy then return true end

        return a.config.idx < b.config.idx
    end)

    return result
end

function PROMSuperGiftBagTargetLayer:updateList(event,data)
    if not self.tableView then return end
    local offsetY = self.tableView:getContainer():getPositionY()
    self.cell_data =  self:generateData()
    self.tableView:initData(self.cell_data)
    self.tableView:reloadData()
    self.tableView:setContentOffset(cc.p(0,offsetY))
end

return PROMSuperGiftBagTargetLayer
