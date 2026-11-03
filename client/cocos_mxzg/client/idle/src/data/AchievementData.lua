local AchievementData = class("AchievementData")

function AchievementData:ctor()

	-- self.achievement_cfg = {}		-- 成就配置
	-- self.achievement_geted = {} 	-- 成就获取记录
	-- self.cur_achievement_cfg = {} 	-- 当先要显示的配置
	self.achievement_data = {}		-- 成就服务器数据
	self.achievement_reds = {}		-- 单个红点
	self.achievement_red = false	-- 成就红点

	self.daily_cfg = {}				-- 日常配置
	self.daily_data = {}			-- 日常服务器数据
	-- self.daily_geted = {}			-- 日常获取记录
	self.point = 0					-- 活跃度
	self.point_box_geted = {}		-- 箱子领取
	-- self.box_reds = {}				-- 箱子红点
	self.total_time = 0				-- 累计时间
	self.daily_reds = {}			-- 日常单个红点
	self.daily_red = false			-- 日常红点

	-- self:initDailyfg()
	-- self:initAchievementCfg()
end

function AchievementData:reqAchievement()
	NetManager:sendMessage(ProtocolID.GReqAchievementList)
	NetManager:sendMessage(ProtocolID.GReqDailyTaskList)
end

function AchievementData:registerEvent()
	self.event_list = {
		-- ex.EventManager:add(EVENT.BACKPACK_RES_CHANGE.ROLE_LEVEL,handler(self,self.onLevel))
	}
end

-- function AchievementData:onLevel(event,data)
-- 	for k,v in pairs(self.daily_data) do
-- 		self:setDailyRedPoint(v)
-- 	end
-- 	self:checkDailyRedpoint()
-- end

function AchievementData:removeEvent()
	if self.event_list ~= nil then 
		for k,v in pairs(self.event_list) do
			ex.EventManager:remove(v)
		end
	end
end

function AchievementData:clear()
	self:removeEvent()
	self:removeTimer()
	self.achievement_cfg = nil
	self.achievement_geted = nil
	self.cur_achievement_cfg = nil
	self.achievement_data = nil
	self.daily_cfg = nil
	self.daily_data = nil
	self.daily_geted = nil
	self.point = nil
	self.point_box_geted = nil
	self.total_time = nil
end

function AchievementData:stardTimer()
	if self.timer_id ~= nil then return end
	if not self.daily_cfg[1003] then return end
	self.timer_id = ex.Timer:addTimer(1000,function(dt)
		if self.total_time >= 60 then 
			self.total_time = 0
			dump(self.daily_data[1003])
			self.daily_data[1003] = self.daily_data[1003] + 1
			-- print(self.__cname,self.daily_data[1003])
			ex.EventManager:fire(EVENT.ACHIEVEMENT_EVENT.DAILY_DATA)
		end

		local config = self.daily_cfg[1003]
		if (self.daily_data[1003] or 0) >= config.num then 
			-- print(self.__cname,"removeTimer")
			self:removeTimer()
		end

		self.total_time = self.total_time + 1
	end,true)
	-- print(self.timer_id,self.__cname,">>>>>>")
end

function AchievementData:removeTimer()
	if self.timer_id ~= nil then 
		ex.Timer:removeTimerById(self.timer_id)
		self.timer_id = nil
	end
end

--------------------------------------------------
function AchievementData:initAchievementData(data)
	for i,v in ipairs(data.task) do
		self:updateTask(v)
		self:setAchievementRedPoint(v)
	end
	ex.EventManager:fire(EVENT.ACHIEVEMENT_EVENT.DAILY_BOX)
end

function AchievementData:setAchievementRedPoint(data)
	local conf = cfg.achievement.achievement[data.idx]
	if not conf then 
		print("achievement id :" .. data.idx .. " is nil ")
		self.achievement_reds[data.idx] = false
		return 
	end
	local target = conf.task.target
	local red = data.process >= conf.task.target and data.state == 0
	self.achievement_reds[data.idx] = red
	-- self:checkAchievementRedPoint()
end

function AchievementData:checkAchievementRedPoint()
	self.achievement_red = false
	for k,v in pairs(self.achievement_reds) do
		if v == true then 
			self.achievement_red = true 
			break
		end
	end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJCJT, self.achievement_red)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZD_RCCJ_CJ, self.achievement_red)
end

function AchievementData:removeTask(id)
	self.achievement_data[id] = nil
	self.achievement_reds[id] = nil
	-- self:checkAchievementRedPoint()
end

function AchievementData:updateTask(task)
	local data = {}
	data.idx = task.idx 
	data.process = task.process
	data.state = task.state
	self.achievement_data[data.idx] = data
	self:setAchievementRedPoint(data)
end

function AchievementData:updateTaskComplete(task_idx)
	local stat = ex.Tools:getAchievementStatus(task_idx)
	if stat then
		ex.Tools:getAchievementStatus(task_idx, true)
		require("src.layer.AchievementGetCtr"):instance():show(1, task_idx)
	end
end

function AchievementData:getCurAchievementCfg()
	local cfg_data = {}

	for k,v in pairs(self.achievement_data) do
		local conf = cfg.achievement.achievement[v.idx]
		table.insert(cfg_data,conf)
	end
	return cfg_data
end

function AchievementData:getAchievementIsRedById(id)
	return self.achievement_reds[id]
end

function AchievementData:getAchievementServerDataById(id)
	return self.achievement_data[id]
end

-------------------------------------------------------
function AchievementData:initDailyData(data)
	self.daily_data = {}
	self.point_box_geted = {}
	for i,v in ipairs(data.task) do
		self:updateDailyData(v)
	end
	
	for i,v in ipairs(data.reward_box_idx) do
		self:setBoxGeted(v)
	end

	self:setPoint(data.daily_value)

	self:checkDailyRedpoint()
end

function AchievementData:updateDailyData(data)
	local daily_data = {}
	daily_data.idx = data.idx
	daily_data.process = data.process
	daily_data.state = data.state

	self.daily_data[data.idx] = daily_data
	self:setDailyRedPoint(daily_data)
end

function AchievementData:updateDailyRedPoint()
	for k,v in pairs(self.daily_data) do
		self:setDailyRedPoint(v)
	end
end

function AchievementData:setDailyRedPoint(data)
	local conf = cfg.dailytaskmain.daily[data.idx]

	if not conf then 
		print("Daily id :" .. data.idx .. " is nil ")
		self.daily_reds[data.idx] = false
		return 
	end
	local target = conf.task.target
	local red = data.process >= conf.task.target and data.state == 0 and conf.open_level <= ex.Player.level
	self.daily_reds[data.idx] = red
end

function AchievementData:setBoxGeted(idx)
	self.point_box_geted[idx] = true
end

function AchievementData:checkBoxIsGeted(idx)
	return self.point_box_geted[idx]
end

function AchievementData:setPoint(point)
	self.point = point
end

function AchievementData:getDailyPoint()
	return self.point
end

function AchievementData:checkBoxRedPoint()
	local conf = cfg.dailytaskpoint.box
	for k,v in pairs(conf) do
		local geted = self:checkBoxIsGeted(v.idx)
		self.point_box_geted[v.idx] = not geted and self.point >= v.point
	end
end

function AchievementData:checkDailyRedpoint()
	local task_red = false 
	local box_red = false 
	for k,v in pairs(self.daily_reds) do
		if v == true then 
			task_red = true 
			break
		end
	end

	for k,v in pairs(cfg.dailytaskpoint.box) do
		if (not self.point_box_geted[v.idx] and self.point >= v.point) then 
			box_red = true 
			break
		end
	end
	self.daily_red = task_red or box_red
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJRCT,self.daily_red)
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZD_RCCJ_RC,self.daily_red)
end

function AchievementData:getDailyIsRedById(id)
	return self.daily_reds[id]
end

function AchievementData:getDailyServerDataById(id)
	return self.daily_data[id]
end

return AchievementData
