local HeroArriveData = class("HeroArriveData")

function HeroArriveData:ctor()
	self.end_time = 0
	self.status = {}
	self.red_point = {}
	self.data = {}
end

function HeroArriveData:setEndTime(time)
	self.end_time = time
end

function HeroArriveData:getEndTime()
	return self.end_time
end

--status : 0 未领取 1 已领取
function HeroArriveData:setHeroArriveStatus(idx,status)
	self.status[idx] = status
end

function HeroArriveData:getHeroArriveStatus(idx)
	return self.status[idx]
end

function HeroArriveData:setHeroArriveData(data)
	self.data[data.idx] = data
end

function HeroArriveData:getHeroArriveData(idx)
	return self.data[idx]
end

-- 红点 ： true false
function HeroArriveData:setHeroArriveRedPoint(idx,red)
	self.red_point[idx] = red
end

function HeroArriveData:getHeroArriveRedPoint(idx)
	return self.red_point[idx]
end

function HeroArriveData:checkRedPoint()
	local kind_1_table, kind_2_table = {}, {}
	for k,v in pairs(cfg.promotionbefall.befall) do
		if v.kind == 1 then
			table.insert(kind_1_table, v)
		elseif v.kind == 2 then
			table.insert(kind_2_table, v)
		end
	end

	local kind_1_undone = false
	for i,config in ipairs(kind_1_table) do
		local bool = false
		if self.status[config.idx] ~= nil and self.data[config.idx] ~= nil then
			bool = self.status[config.idx] == 0 and self.data[config.idx].num >= config.num and config.can_reward == 1
			kind_1_undone = kind_1_undone or self.status[config.idx] == 0
		else
			kind_1_undone = kind_1_undone or true
		end

		self:setHeroArriveRedPoint(config.idx,bool)
	end

	for i,config in ipairs(kind_2_table) do
		self:setHeroArriveRedPoint(config.idx, not kind_1_undone)
	end
end

function HeroArriveData:stardTimer()
	self.timer_id = ex.Timer:addTimer(1000, handler(self,self.changTime), true)
end

function HeroArriveData:changTime()
	local serverTime = ex.Game:getServerTime()
	if not self.end_time then self.end_time = 0 end
	local time = self.end_time - serverTime
	if time <= 0 then 
		ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_hero_arrive")
		self:removeTargetTimer()
		return 
	end
end

function HeroArriveData:isFinishTaskByIdx(idx)
	for i,v in ipairs(self.data) do
		if v.idx == idx then
			local config = cfg.promotionbefall.getConfigByIdx(v.idx)
			if config ~= nil and v.num >= config.num then
				return true
			end
		end
	end
	return false
end

function HeroArriveData:checkRedPointByMainCity()
	local red = false
	for i,v in ipairs(self.red_point) do
		if v == true then red = v break end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_YXJL, red)
	return red
end

function HeroArriveData:isOpenAct()
	local serverTime = ex.Game:getServerTime()
	local time = self.end_time - serverTime
	
	local is_exist_finish = false	-- 是否存在已完成任务(新需求，有任何一个已完成则显示入口)
	for i,v in ipairs(self.data) do
		if self:isFinishTaskByIdx(v.idx) then
			is_exist_finish = true
			break
		end
	end

	local is_all_got = true		-- 是否都领取完成
	for k,v in pairs(cfg.promotionbefall.befall) do
		if self:getHeroArriveStatus(v.idx) ~= 1 then
			is_all_got = false
			break
		end
	end
	return time > 0 and is_exist_finish and not is_all_got
end

function HeroArriveData:removeTimer()
	if self.timer_id then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end
end

-- 清除
function HeroArriveData:clear()
	self:removeTimer()
	self.end_time = nil
	self.status = nil
	self.red_point = nil
	self.data = nil
end

return HeroArriveData