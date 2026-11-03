local OnlineRewardData = class("OnlineRewardData")

function OnlineRewardData:ctor()
	self.status = {}
	self.totoal_time = {}
	self.again_status = {}
	self.end_time = 0
	self.reward_id = 0
	self.again_num = 0
	self.can = false
	self.has_month_card = false
	self.can_get_id = 0
	self.target_id = 0
	self.online_time = 0
	self:initCfgData()
	self:registerEvent()
end

function OnlineRewardData:setAgainStatus(idx)
	self.again_status[idx] = true
end

function OnlineRewardData:getGainStatus(idx)
	return self.again_status[idx] == true
end

function OnlineRewardData:getHasMonthCard( )
	return self.has_month_card
end

function OnlineRewardData:getTargetIdx()
	return self.target_id
end

function OnlineRewardData:setOnlineTime(time)
	self.online_time = time
end

function OnlineRewardData:initCfgData()
	self.cfg = {}
	for k,v in pairs(cfg.promotiononlinereward.online) do
		table.insert(self.cfg,v)
	end
	local function sor(a,b)
		return a.idx < b.idx
	end
	table.sort(self.cfg,sor)

	local time = 0
	for i,v in ipairs(self.cfg) do
		time = time + v.time
		self.totoal_time[v.idx] = time 
		if v.once_again == 1 then 
			self.again_num = self.again_num + 1
		end 
	end
end

function OnlineRewardData:checkCanRewardId()
	for i,v in ipairs(self.cfg) do
		local status = self:getStatus(v.idx)
		local time = self.totoal_time[v.idx]
		if status == 0 and self.online_time < time then 
			self.target_id = v.idx
			local pre_cfg = self.cfg[i - 1]
			if pre_cfg then 
				self.can_get_id = pre_cfg.idx
			end
			break
		end
	end
	if self.target_id == 0 then 
		for i,v in ipairs(self.cfg) do
			local status = self:getStatus(v.idx)
			local time = self.totoal_time[v.idx]
			if status == 0 and self.online_time >= time then 
				self.target_id = v.idx
			end
		end
	end
	-- dump(self.status)
end

function OnlineRewardData:getCanGetId()
	-- body
	return self.can_get_id 
end

function OnlineRewardData:InitData(data)
	-- self:setEndTime(data.end_time)
	-- self:setRewardId(data.reward_id)
	for k,v in ipairs(data.idx_list) do
		self.status[v.key] = v.value
	end
	self.online_time = data.online_time

	for k,v in ipairs(data.once_again_list) do
		self:setAgainStatus(v)
	end
	-- self:setCanGetId(data.online_idx)
	-- self:startTimer()
	-- dump(self.status)
	self:checkCanRewardId()
	self:startTimer()
end

function OnlineRewardData:setStatus(idx,status)
	self.status[idx] = status
end

function OnlineRewardData:getStatus(idx)
	return self.status[idx]
end

function OnlineRewardData:registerEvent()
	self.event_list = {
		ex.EventManager:add(EVENT.MAIN_PROMOTION_CARD.ADD_MONTH_CARD,handler(self,self.onMonthCard))
	}
end

function OnlineRewardData:onMonthCard(event,data)
	self.has_month_card = table.nums(ex.Player.promotion_data.month_card) > 0
	self.month_card_time = 0
	for i,v in ipairs(ex.Player.promotion_data.month_card) do
		if v.over_time > self.month_card_time then 
			self.month_card_time = v.over_time
		end
	end

	self:removeOnMonthCardTimer()
	self.check_month_card_time = ex.Timer:addTimer(1000, handler(self,self.onMonthCardTimer), true)
end

function OnlineRewardData:onMonthCardTimer( )
	local cur_time = ex.Game:getServerTime()
	if cur_time > self.month_card_time then 
		self.has_month_card = self.month_card_time > cur_time
		self:removeOnMonthCardTimer()
		ex.EventManager:fire(EVENT.ONLINE_REWARD.UPDATE_MONTH_CARD_STATUS)
	end
end

function OnlineRewardData:removeOnMonthCardTimer()
	if self.check_month_card_time ~= nil then 
		ex.Timer:removeTimerById(self.check_month_card_time)
		self.check_month_card_time = nil 
	end
end

-- function OnlineRewardData:checkRewardId()
-- 	for i,v in ipairs(self.cfg) do
-- 		local time = self.totoal_time[v.idx]
-- 		if self.online_time > time and self.can_get_id <= v.idx then 
-- 			self.can_get_id = v.idx
-- 		end 
-- 	end
-- end

function OnlineRewardData:startTimer()
	self:removeTimer()
	self.timer_id = ex.Timer:addTimer(1000, handler(self,self.changeTime), true)
end

function OnlineRewardData:changeTime()
	self.online_time = self.online_time + 1
	-- local id = self.can_get_id == 0 and self.target_id or self.can_get_id
	local id = self.target_id
	if self.online_time > self.totoal_time[id] then 
		for i,v in ipairs(self.cfg) do
			if v.idx == id then 
				if self.cfg[i+1] ~= nil then 
					-- self.can_get_id = self.cfg[i+1].idx
					self.can_get_id = v.idx
					self.target_id = self.cfg[i+1].idx
					break
				else
					self.can_get_id = self.target_id
					self:removeTimer()
				end 
			end
		end
	elseif self.totoal_time[id] == nil then 
		self:removeTimer()
	end 
	-- print(self.__cname,self.online_time,self.can_get_id,self.target_id)
end

function OnlineRewardData:removeTimer()
	if self.timer_id then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end
end

function OnlineRewardData:removeEvent()
	if self.event_list ~= nil then 
		for k,v in pairs(self.event_list) do
			ex.EventManager:remove(v)
		end
	end
end

function OnlineRewardData:getTotalTimeByIdx(idx)
	return self.totoal_time[idx] or 0
end

function OnlineRewardData:getOnlineTime()
	return self.online_time
end

function OnlineRewardData:isOpen()
	local open = false 
	for i,v in pairs(self.status) do
		if v == 0 then 
			open = true
			break
		end
	end
	return open
end

function OnlineRewardData:hasReward()
	local has = false 
	for i,v in ipairs(self.cfg) do
		if v.idx <= self.can_get_id then 
			has = self:getStatus(v.idx) == 0
			if has == true then break end 
		end
	end
	return has
end

function OnlineRewardData:clear()
	self:removeTimer()
	self:removeOnMonthCardTimer()
	self:removeEvent()

	self.status = nil
	self.totoal_time = nil
	self.again_status = nil
	self.end_time = nil
	self.reward_id = nil
	self.can = nil
	self.has_month_card = nil
	self.can_get_id = nil
	self.target_id = nil
	self.online_time = nil
	self.cfg = nil
	self.again_num = nil
end

return OnlineRewardData