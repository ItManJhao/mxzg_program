local PubTaskData = class("PubTaskData")

function PubTaskData:ctor()
	self.task_count = 0
	self.can_do_num = 0
	self.taskList = {}
	self.taskHeroList = {} --做任务的英雄列表

	self.luxury = 0  -- 豪华
	self.high = 0   -- 高级
	self.free_refresh = 0
	self.adventure_count = 0
end

function PubTaskData:clear()
	self.completed = 0
	self.resetTime = 0
	self.taskList = {}
	self.taskHeroList = {}
end

function PubTaskData:addTaskHero(hero)
	for _,v in pairs(hero) do
		if v ~= "" then
			table.insert(self.taskHeroList, v)
		end
	end
	--ex.log("addTaskHero...")
	--ex.out(self.taskHeroList)
end

function PubTaskData:removeTaskHero(hero)
	for _,v in pairs(hero) do
		repeat
			for i,id in ipairs(self.taskHeroList) do
				if v == id then
					table.remove(self.taskHeroList, i)
					break
				end
			end
		until true
	end
end

function PubTaskData:getTask(task_id)
	for _,v in pairs(self.taskList) do
		if v.task_id == task_id then
			return v
		end
	end

	return nil
end

function PubTaskData:hasHighStarTask()
	local task_warning = ex.Tools:getSysCfg("tavern_refresh_warning_star")

	for _,v in pairs(self.taskList) do
		if v.used_time <= 0 then
			local config = cfg.tavern.pubTask[v.task_type]
			if config ~= nil then
				if config.star >= task_warning and v.task_lock == 0 then
					return true
				end
			end
		end
	end

	return false
end

function PubTaskData:addTask(newTask)
	table.insert(self.taskList, newTask)
end

function PubTaskData:removeTask(task_id)
	for i,v in ipairs(self.taskList) do
		if v.task_id == task_id then
			self:removeTaskHero(v.hero) -- 删除做任务的英雄
			table.remove(self.taskList, i)
			return
		end
	end
end

function PubTaskData:doneTask(task_id, hero)
	-- ex.log(">>doneTask:")
	-- ex.log("task_id: "..task_id)
	-- ex.out(hero)

	-- ex.log("taskHeroList.....begin")
	-- ex.out(self.taskHeroList)
	
	local task = self:getTask(task_id)
	if task == nil then
		return
	end

	local config = cfg.tavern.pubTask[task.task_type]
	if config == nil then
		return
	end

	task.used_time = config.time + ex.Game:getServerTime()

	self:addTaskHero(hero)

	-- ex.log("taskHeroList.....END")
	-- ex.out(self.taskHeroList)

	-- 吞噬任务界面
 	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_PUB_TASK)
    if cur_layer then
    	cur_layer:touchSwallowTouches(true)
    end

	-- 发送协议
	local req_task_start = PubTask_pb.GReqPubTaskStart()
	req_task_start.task_id = task_id

	for _,v in pairs(hero) do
		table.insert(task.hero, v)
		table.insert(req_task_start.hero_id, v)
	end

	NetManager:sendMessage(ProtocolID.GReqPubTaskStart, req_task_start)
end


function PubTaskData:checkProgress()

	local save_progress = 0
	local save_task_id = 0
	local now = ex.Game:getServerTime()
	for _,v in pairs(self.taskList) do
		if v.used_time > 0 then
			local sub_time = now - v.used_time  

			if sub_time > 0 then 
				save_progress = sub_time
				save_task_id = v.task_type
				break
			end 
			if save_progress > sub_time then 
				save_progress = sub_time
				save_task_id = v.task_type
			end 
		end
	end

	if save_progress > 0 then 
		return 100
	else 

	
		local config = cfg.tavern.pubTask[save_task_id]
		if config == nil then
			return 0
		end
		local abs_nums = math.abs( save_progress )
		local nums = (config.time -abs_nums )  /  config.time * 100
		return  nums

	end 


end


function PubTaskData:checkRedDot()
	
	if not ex.JumpManager:checkOpenConditionByAtomNoMsg("main_pub_task") then
		return
	end

	local is_visible = false
	local now = ex.Game:getServerTime()
	for _,v in pairs(self.taskList) do
		if v.used_time > 0 and v.used_time <= now then
			is_visible = true
		end
	end

	-- 判断是否有完成的任务
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_JG, is_visible)

	return is_visible
end

return PubTaskData
