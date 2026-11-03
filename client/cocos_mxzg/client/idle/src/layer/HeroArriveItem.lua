local HeroArriveItem = class("HeroArriveItem",require("src.comp.LuaLayerBase"))

function HeroArriveItem:onCreate()
	self:setAutoClose(false)
	self:setSwallowTouches(false)

	-- self.goto_text = cc.Label:createWithTTF(ex.Tools:getLang(47260), FONT_DEFAULT_NAME_BOLD, 24)
	-- self.btn_goto:addChild(self.goto_text)
	-- self.goto_text:setPosition(self.btn_goto:getContentSize().width / 2 , self.btn_goto:getContentSize().height / 2 + 1)
	-- self.goto_text:setColor(FONT_BROWN)

	-- local get_text = cc.Label:createWithTTF(ex.Tools:getLang(47444), FONT_DEFAULT_NAME_BOLD, 24)
	-- self.btn_get:addChild(get_text)
	-- get_text:setPosition(self.btn_get:getContentSize().width / 2 , self.btn_get:getContentSize().height / 2 + 1)
	-- get_text:setColor(FONT_BROWN)

	-- local str = string.format(ex.Tools:getLang(47378),10,75)
	-- self.lbl_progress:setString(str)

	self.btn_goto:registerScriptTapHandler(handler(self, self.onClickGoto))
	self.btn_get:registerScriptTapHandler(handler(self, self.onClickGet))
end

function HeroArriveItem:onClickGoto(tag,pSender)
	if self.data.idx == 2 then 
		local is_open = cfg.funcopen["act_sevent_day_gift"].isVisible()
		if is_open then 
			require("src.layer.SevenDayGiftCtr"):instance():openWindow()
			local layer = ex.MainSceneCtr:changeLayer(MainSceneType.MAINCITY_LAYER)
			require("src.layer.HeroArriveCtr"):instance():closeWindow()
		end
		return 
	end
	local isOpen = ex.JumpManager:jumpByActType(self.data.type)
	print(self.__cname,isOpen)
	if isOpen then 
		require("src.layer.HeroArriveCtr"):instance():closeWindow()
	end
end

function HeroArriveItem:onClickGet(tag,pSender)
    -- local req_reward = cpp.ByteArray:create()
    -- req_reward:writeInt(ProtocolID.GReqHeroArriveReward)
    -- req_reward:writeInt(self.data.idx)
	-- cpp.NetManager:instance():sendByteArray(req_reward)
	local req_reward = HeroArrive_pb.GReqHeroArriveReward()
    req_reward.idx = self.data.idx
	NetManager:sendMessage(ProtocolID.GReqHeroArriveReward,req_reward)
end

function HeroArriveItem:reset(data)
	if not data then return end
	self.data = data

	if self.item ~= nil then 
		self.item:removeFromParent()
		self.item = nil 
	end

	self.item = ex.Tools:createBackpackItem(data.reward[1].item_type, data.reward[1].item_num)
    self.menu:addChild(self.item)
    self.item:setScale(1)
    

	local str 
	if data.idx == 1 then 
		local has_data = ex.Player.heroarrive_data:getHeroArriveData(data.idx)
		local num  = has_data and has_data.num or 0
		str = string.format(ex.Tools:getLang(49000 + data.idx),num,data.num)
	else
		str = ex.Tools:getLang(49000 + data.idx)
	end
	self.lbl_progress:setString(str)
	local status = ex.Player.heroarrive_data:getHeroArriveStatus(data.idx) or 0
	local is_finish = ex.Player.heroarrive_data:isFinishTaskByIdx(data.idx)

	if data.can_reward == 0 then	-- 不可以领奖
		self.btn_get:setVisible(false)
		self.btn_goto:setVisible(status == 0)
		self.spr_geted:setVisible(status == 1)
	else							-- 可以领奖
		self.btn_get:setVisible(status == 0 and is_finish)
		self.btn_goto:setVisible(status == 0 and not is_finish)
		self.spr_geted:setVisible(status == 1)
	end
	
	self.item:setAllGray(status == 1)
	print(self.__cname,data.idx,status)

	-- if data.idx <= 2 then 
	-- 	-- self.goto_text:setString(ex.Tools:getLang(41077))
	-- 	-- self.btn_goto:setEnabled(false)
	-- 	self.btn_get:setVisible(false)
	-- 	self.btn_goto:setVisible(status == 0)
	-- end
	local red = ex.Player.heroarrive_data:getHeroArriveRedPoint(self.data.idx)
	ex.Tools:addRedPoint(self.btn_get,red)
end


return HeroArriveItem
