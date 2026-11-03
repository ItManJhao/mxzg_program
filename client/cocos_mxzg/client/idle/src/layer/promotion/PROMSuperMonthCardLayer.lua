local PROMSuperMonthCardLayer = class("PROMSuperMonthCardLayer", require("src.layer.promotion.PromotionCardBaseLayer"))

function PROMSuperMonthCardLayer:onCreateDone()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	
	local config = cfg.promotioncard.card[2]
	local cost = config.item[1]

	
	self.spr_bg:setPositionY(self.layer_promotion:getTopY())

	-- self:resetDesc(config.type, ex.Tools:getLang(2709), cost.item_type, cost.item_num, config.day)
	self.card_type = config.type

	local card_data = ex.Player.promotion_data:getMonthCardData(config.type)
	if not card_data then
		self:addCompletedNode(0, config.total_charge)
		return
	end

	if card_data.over_time - ex.Game:getServerTime() < 0 then
		self:addCompletedNode(card_data.completed, config.total_charge)
	else
		self:addGainCell(cost.item_type, cost.item_num, card_data.gain_days, card_data.over_time, card_data.is_gain)
	end

	self:addEvent(EVENT.MAIN_PROMOTION_CARD.UPDATE_DAY, handler(self,self.updateDays))
end



return PROMSuperMonthCardLayer