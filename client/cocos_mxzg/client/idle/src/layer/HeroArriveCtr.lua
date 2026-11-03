local HeroArriveLayer = class("HeroArriveLayer", require("src.comp.EventLayerAdaptiveWidthFull"))
local HeroArriveCtr = class("HeroArriveCtr", require("src.comp.LuaNodeCtr"), require("src.common.SingleInstance"))

function HeroArriveLayer:onCreate()

	self:resetScaleAtWidth(true, 30)

	self:addBlackBackground()
	self:setAutoClose(true)
	self:setSwallowTouches(true)

	-- self.btn_lbl_text = cc.Label:createWithTTF(ex.Tools:getLang(47081), FONT_DEFAULT_NAME_BOLD, 30)
	-- self.btn_goto:addChild(self.btn_lbl_text)
	-- self.btn_lbl_text:setPosition(self.btn_goto:getContentSize().width / 2 , self.btn_goto:getContentSize().height / 2 + 3)
	-- self.btn_lbl_text:setColor(FONT_BROWN)

	self.items = {}
	local can = self:checkCanGetReward()
	self.btn_get:setVisible(can)
	self.btn_goto:setVisible(not can )

	self.btn_get:registerScriptTapHandler(handler(self, self.onClickGoto))
	self.btn_info:registerScriptTapHandler(handler(self, self.onClickInfo))
	self:createItem()
	local data = {}
	for k,v in pairs(cfg.promotionbefall.befall) do
		if v.kind == 2 then 
			self.show_data = v
		end
	end

	self:updateView()
	self:addEvent(EVENT.HERO_ARRIVE_EVENT.UPDATE,handler(self,self.updateView))
	self:addEvent(EVENT.HERO_ARRIVE_EVENT.REWARD_RESULT,handler(self,self.updateView))
	self:addEvent(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,handler(self,self.actEnd))
	self:changTimer()
	self:addTimer("timer",1000,handler(self,self.changTimer),true)
end

function HeroArriveLayer:changTimer()
	local time = ex.Player.heroarrive_data:getEndTime() - ex.Game:getServerTime()
	if time <= 0 then 
		-- self:removeTimerByName("timer")
		-- HeroArriveCtr:instance():closeWindow()
	end
	local d,h,m,s = ex.Tools:formatTime(time)
	local str = string.format(ex.Tools:getLang(47289),d,h)
	-- print(time,self.__cname,str,ex.Game:getServerTime(),ex.Player.heroarrive_data:getEndTime())
	self.lbl_time:setString(str)
end

function HeroArriveLayer:actEnd(event,atom)
	if atom == "act_hero_arrive" then 
		HeroArriveCtr:instance():closeWindow()
	end
end

function HeroArriveLayer:changePrpgress()
	local all = 0
	local total = 0
	for k,v in pairs(cfg.promotionbefall.befall) do
		if v.kind == 1 then 
			all = all + 1
			local status = ex.Player.heroarrive_data:getHeroArriveStatus(v.idx)
			if status == 1 then total = total + 1 end
		end
	end
	local str = ex.Tools:getLang(49000 + self.show_data.idx)

	self.lbl_progress:setString(string.format(str,total,all))
end

function HeroArriveLayer:createItem()
	local node = require("src.layer.HeroArriveItem"):createWithCCBIFile("ccbi/HeroArriveItem.ccbi")
	local size = node:getContentSize()
	local margin = 0
	local startX  = -((size.width + margin) * 3 - margin ) / 2
	local posY = self.menu_items:getPositionY() - size.height / 2

	for i=1,3 do
		node = require("src.layer.HeroArriveItem"):createWithCCBIFile("ccbi/HeroArriveItem.ccbi")
		self.node:addChild(node)
		self.items[i] = node 
		node:setPosition(startX + (i - 1) * (size.width + margin) , posY)
	end

end

function HeroArriveLayer:reset(data)
	for k,v in pairs(self.items) do
		local cell_data = data[k]
		if cell_data ~= nil then 
			v:reset(cell_data)
		end
	end
end

function HeroArriveLayer:updateView(event,data)

	local cell_data = {}
	for k,v in pairs(cfg.promotionbefall.befall) do
		if v.kind == 1 then 
			cell_data[k] = v
		end
	end
	self:reset(cell_data)

	local can = self:checkCanGetReward()
	self.btn_get:setVisible(can)
	ex.Tools:addRedPoint(self.btn_get,can)
	self.btn_goto:setVisible(not can )
	self:changePrpgress()
end

function HeroArriveLayer:checkCanGetReward()
	local can = true 
	for k,v in pairs(cfg.promotionbefall.befall) do
		if v.kind == 1 then 
			local status = ex.Player.heroarrive_data:getHeroArriveStatus(v.idx)
			can = status == 1
			if can == false then break end
		end
	end

	return can 
end

function HeroArriveLayer:onClickGoto(tag,pSender)
	-- body
	local can = self:checkCanGetReward()
	if not can then return end

	local req_reward = HeroArrive_pb.GReqHeroArriveReward()
    req_reward.idx = self.show_data.idx
	NetManager:sendMessage(ProtocolID.GReqHeroArriveReward,req_reward)
end

function HeroArriveLayer:onClickInfo(tag,pSender)
	-- body
	local type = self.show_data.reward[1].item_type - 10000000
	local star = cfg.herotype.star[type].star

	local callback = function ()
		ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
	end

	local layer = ex.MainSceneCtr:changeLayer(MainSceneType.HERO_ILLUSTRAT_INFO_LAYER)
	layer:showData(type, star, callback)
	HeroArriveCtr:instance():closeWindow()
end

----------------------------------------------------------

function HeroArriveCtr:onCreate()
	self:setCCBIPath("ccbi/HeroArriveLayer.ccbi")
	
	self:setIsSingle(false)
end

function HeroArriveCtr:getLayerClass()
	return HeroArriveLayer
end

function HeroArriveCtr:getLayer()
	return self.layer
end

function HeroArriveCtr:openWindow(data)
	if self:isOpened() then
		return
	end

	self:loadLayer()
	self:open()
	self:initData(data)
end

function HeroArriveCtr:initData(data)
	self.layer.btn_close:registerScriptTapHandler(handler(self, self.closeWindow))
end


return HeroArriveCtr
