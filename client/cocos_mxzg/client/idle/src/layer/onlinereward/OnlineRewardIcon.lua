local OnlineRewardIcon = class("OnlineRewardIcon", function (params1, params2, params3)
	return cpp.UIMenuItemImage:createWithSpriteFrameName(params1, params2, params3)
end)


function OnlineRewardIcon:onNodeEvent(event)
    if event == "exit" then
        self:onExit()
    end
end

function OnlineRewardIcon:onExit()
	-- self:removeTimer()
	if self.timer_id then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end

    for k,v in pairs(self.event_list) do
    	ex.EventManager:remove(v)
    end
end

function OnlineRewardIcon:reset()
	self:startTimer()

	local str 

	local cur_id --= ex.Player.onlineReward_data:getCanGetId()
	local can_id = ex.Player.onlineReward_data:getCanGetId()
	if ex.Player.onlineReward_data:hasReward() then 
		-- cur_id = ex.Player.onlineReward_data:getCanGetId()
		for i,v in ipairs(self.list) do
			if can_id >= v then 
				local status = ex.Player.onlineReward_data:getStatus(v) 
				if status == 0 then cur_id = v break end
			end
		end
	else
		cur_id = ex.Player.onlineReward_data:getTargetIdx()
	end

	local online_reward = cfg.promotiononlinereward.online[cur_id]
    if not online_reward then return end
	local item_config = cfg.item.item[online_reward.reward[1].item_type]
	self.icon:setSpriteFrame(string.format("%s.png",item_config.icon))
end

function OnlineRewardIcon:getData()
	return self.data 
end

-- function OnlineRewardIcon:initNode()

-- end

function OnlineRewardIcon:createWithData(data)
	local pRet = OnlineRewardIcon:create("", nil, nil)
	if pRet then
		pRet:initDone()
		pRet:reset(data)
		return pRet
	end
	pRet = nil
	return nil
end

function OnlineRewardIcon:initDone()
	local sfc = cc.SpriteFrameCache:getInstance()
	sfc:addSpriteFrames("ccbi-res/online-reward.plist")

	local spr_bg = cc.Sprite:createWithSpriteFrameName("online-reward/spr-act-icon.png")
	self:addChild(spr_bg)
	spr_bg:setAnchorPoint(0,0)

	local content_size = spr_bg:getContentSize()
	self:setContentSize(content_size)
	self:setPosition(content_size.width / 2,content_size.height / 2)

    local spr_effect = ex.EffectFactory:createEffectWithNodeByName("eff_online_reward_2")
    spr_effect:setPosition(content_size.width * 0.5 - 3, content_size.height * 0.5 + 8)
    self:addChild(spr_effect, 0, 10)

	self.icon = cc.Sprite:createWithSpriteFrameName("backpack/900002.png")
	self:addChild(self.icon)
	self.icon:setAnchorPoint(0.5,0.5)
	self.icon:setPosition(content_size.width / 2, 70)
	self.icon:setScale(0.6)
	self.icon:setLocalZOrder(30)

	self.lbl_get = cc.Label:createWithTTF(ex.Tools:getLang(47301), FONT_DEFAULT_NAME_BOLD, 20)
	self.lbl_get:enableOutline(cc.c4b(129,59,8,255), 1)
	self:addChild(self.lbl_get)
	self.lbl_get:setAnchorPoint(0.5,0.5)
	self.lbl_get:setPosition(content_size.width / 2, 19)
	self.lbl_get:setLocalZOrder(20)

	self.lbl_time = cc.Label:createWithTTF(ex.Tools:getLang(47301), FONT_DEFAULT_NAME_BOLD, 20)
	self.lbl_time:enableOutline(cc.c4b(129,59,8,255), 1)
	self:addChild(self.lbl_time)
	self.lbl_time:setAnchorPoint(0.5,0.5)
	self.lbl_time:setPosition(content_size.width / 2, -2)
	self.lbl_time:setLocalZOrder(20)

	self:sortRewardId()

	self:changeTime()
	self:startTimer()

	self:registerEvent()
end

function OnlineRewardIcon:sortRewardId()
	local function sor(a,b)
		return a < b
	end

	self.list = {}
	for k,v in pairs(cfg.promotiononlinereward.online) do
		table.insert( self.list, v.idx )
	end
	table.sort(self.list,sor)
end

function OnlineRewardIcon:registerEvent()
	self:registerScriptHandler(handler(self, self.onNodeEvent))

	self.event_list = {
		ex.EventManager:add(EVENT.ONLINE_REWARD.GET_REWARD_RESULT,handler(self,self.onOnlineRewardResult)),
		ex.EventManager:add(EVENT.ONLINE_REWARD.CLOSE,handler(self,self.onClose))
	}
end

function OnlineRewardIcon:onClose(event,data)
	-- body
	if self.timer_id then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end
	self:removeFromParent()
end

function OnlineRewardIcon:onOnlineRewardResult(event,data)
	-- print(self.__cname,event)
	self:reset()
end

function OnlineRewardIcon:startTimer()
	if self.timer_id then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end
	self.timer_id = ex.Timer:addTimer(1000, handler(self,self.changeTime), true)
end

function OnlineRewardIcon:changeTime()

	local cur_id 

	local has = ex.Player.onlineReward_data:hasReward()
	-- if has then 
	-- 	cur_id = ex.Player.onlineReward_data:getCanGetId()
	-- else
	-- 	cur_id = ex.Player.onlineReward_data:getTargetIdx()
	-- end

	-- local can_id = ex.Player.onlineReward_data:getCanGetId()
	-- if has then 
	-- 	-- cur_id = ex.Player.onlineReward_data:getCanGetId()
	-- 	for i,v in ipairs(self.list) do
	-- 		if can_id >= v then 
	-- 			local status = ex.Player.onlineReward_data:getStatus(v) 
	-- 			if status == 0 then cur_id = v break end
	-- 		end
	-- 	end
	-- else
	-- 	cur_id = ex.Player.onlineReward_data:getTargetIdx()
	-- end

	local target_id =  ex.Player.onlineReward_data:getTargetIdx()
	local total_time = ex.Player.onlineReward_data:getTotalTimeByIdx(target_id)
	local online_time = ex.Player.onlineReward_data:getOnlineTime()
	self.lbl_time:setVisible(not has)
	
	local str = has and ex.Tools:getLang(47078) or ex.Tools:getLang(47175)
	self.lbl_get:setString(str)
	
	if not has then 
		local time = total_time - online_time
		if time <= 0 then time = 0 end 
		local _,h,m,s = ex.Tools:formatTime(time)
		local str = string.format("%02d:%02d:%02d",h,m,s)
		self.lbl_time:setString(str)
	end

end

function OnlineRewardIcon:removeTimer()
	if self.timer_id then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end
end

return OnlineRewardIcon
