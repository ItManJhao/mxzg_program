local CustomizedBanner = class("CustomizedBanner", require("src.comp.EventLayer"))

function CustomizedBanner:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)
	self.open_data = ex.Player.promotion_data:getPromotionDatas(62)
	self:changTime()
	self:addTime()
	self:addFont()
	local win_size = cc.Director:getInstance():getWinSize()
	local banner_size = self.spr_banner:getContentSize()
	self.spr_banner:setScaleX(win_size.width / banner_size.width)
end

function CustomizedBanner:addTime( )
	self:addTimer("remaining",1000,handler(self,self.changTime),true)
end

function CustomizedBanner:changTime()
	if self.open_data == nil or self.open_data.end_time < ex.Game:getServerTime() then 
		self:removeTimerByName("remaining")
		return
	end

	local time = self.open_data.end_time - ex.Game:getServerTime()
	local str = ex.Tools:formatTime4(time)
	self.lbl_time:setString(str)
end

function CustomizedBanner:addFont()

end

return CustomizedBanner
