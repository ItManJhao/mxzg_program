local RCGRechargeCell = class("RCGRechargeCell", require("src.comp.EventLayer"))

-------------------------------------RCGRechargeCell----------------------------------------------------
function RCGRechargeCell:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	-- self.lbl_price:setTextColor(FONT_BLACK)
    self.lbl_price:enableOutline(cc.c4b(67,44,14,255), 2)

	-- self.lbl_buy_num:setTextColor(cc.WHITE)
    self.lbl_buy_num:enableOutline(cc.c4b(67,44,14,255), 2)

	-- self.lbl_reward_num:setTextColor(cc.WHITE)
    self.lbl_reward_num:enableOutline(cc.c4b(67,44,14,255), 2)

	-- self.lbl_reward_text:setTextColor(cc.WHITE)
    self.lbl_reward_text:enableOutline(cc.c4b(67, 44, 14, 255), 2)
end

return RCGRechargeCell