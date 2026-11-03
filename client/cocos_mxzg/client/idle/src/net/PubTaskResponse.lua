local PubTaskResponse = class("PubTaskResponse")

local function getTaskLayer()
	-- 刷新任务界面
 	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_PUB_TASK)
    return cur_layer
end


function PubTaskResponse:pubAdventureCount( data)
	ex.Player.pub_task.adventure_count = data.adventure_count

	ex.EventManager:fire(EVENT.PUB_TASK_EVENT.PUB_POINTS)
end


function PubTaskResponse:oneKeyGetReward(data)

	ex.Player.pub_task:clear()

	for i,v in ipairs(data.list) do
		local task = {}
		task.task_id = v.task_id
		task.task_type = v.task_type
		task.used_time = v.used_time
		task.task_lock = v.task_lock
		task.hero = {}

		for ih,vh in ipairs(v.heroIds) do
			if vh ~= 0 then
				table.insert(task.hero, vh)
			end
		end

		ex.Player.pub_task:addTask(task)

		-- 正在做任务的英雄
		if task.used_time ~= 0 then
			ex.Player.pub_task:addTaskHero(task.hero)
		end
	end


	ex.out(ex.Player.pub_task.taskList)

	require("src.layer.MainTaskCtr"):instance():refreshItemNum()
	require("src.layer.MainTaskCtr"):instance():showTaskList()

	ex.Player.pub_task:checkRedDot()



	ex.Player.promotion_data:reqTavernWeeklyList()
	ex.Player.promotion_data:reqPubArriveInfo()


	
end 



-- 任务列表
function PubTaskResponse:pubTaskList(data, byte_array)
	ex.Player.pub_task.luxury = data.luxury
	ex.Player.pub_task.high = data.high

	ex.Player.pub_task:clear()
	ex.Player.pub_task.free_refresh = data.free_refresh
	ex.Player.pub_task.adventure_count = data.adventure_count
	
	for i,v in ipairs(data.list) do
		local task = {}
		task.task_id = v.task_id
		task.task_type = v.task_type
		task.used_time = v.used_time
		task.task_lock = v.task_lock
		task.hero = {}

		for ih,vh in ipairs(v.heroIds) do
			if vh ~= 0 then
				table.insert(task.hero, vh)
			end
		end

		ex.Player.pub_task:addTask(task)

		-- 正在做任务的英雄
		if task.used_time ~= 0 then
			ex.Player.pub_task:addTaskHero(task.hero)
		end
	end

	-- 刷新任务界面
	ex.EventManager:fire(EVENT.PUB_TASK_EVENT.UPDATE)
	
	ex.Player.pub_task:checkRedDot()
end


-- 使用券 刷新一个任务
function PubTaskResponse:pubtaskRereshOne(data)
	dump_pbmsg(data,">>>>>")

	ex.Player.pub_task:clear()
	ex.Player.pub_task.free_refresh = data.free_refresh
	
	for i,v in ipairs(data.list) do
		local task = {}
		task.task_id = v.task_id
		task.task_type = v.task_type
		task.used_time = v.used_time
		task.task_lock = v.task_lock
		task.hero = {}

		for ih,vh in ipairs(v.heroIds) do
			if vh ~= 0 then
				table.insert(task.hero, vh)
			end
		end

		ex.Player.pub_task:addTask(task)

		-- 正在做任务的英雄
		if task.used_time ~= 0 then
			ex.Player.pub_task:addTaskHero(task.hero)
		end
	end


	ex.out(ex.Player.pub_task.taskList)

	

	-- 刷新任务界面
 	-- local layer_pubTask = getTaskLayer()
	-- if layer_pubTask then
	-- 	-- layer_pubTask:addTaskByTicket(task.task_id)
	-- 	layer_pubTask:updateScrollView()
	-- 	layer_pubTask:updateRefreshGemBtn()
	-- 	layer_pubTask:setBtnItemNum(layer_pubTask.btn_refresh_t1, ex.Player:getItemNum(ItemType.IT_PUB_TICKET_SMALL))
	-- 	layer_pubTask:setBtnItemNum(layer_pubTask.btn_refresh_t2, ex.Player:getItemNum(ItemType.IT_PUB_TICKET_HIGH))
	-- 	layer_pubTask:updateRefreshGemBtn()
	-- end

	require("src.layer.MainTaskCtr"):instance():refreshItemNum()
	require("src.layer.MainTaskCtr"):instance():showTaskList()


	ex.Player.pub_task:checkRedDot()
end

function PubTaskResponse:pubTaskStart(data, byte_array)
	local task_id = data.task_id--byte_array:readInt64()
	-- 刷新任务界面
 	-- local layer_pubTask = getTaskLayer()
	-- if layer_pubTask then
	-- 	layer_pubTask:startTask(task_id)
	-- 	layer_pubTask:updateRefreshGemBtn()
	-- end

	require("src.layer.MainTaskCtr"):instance():startTask(task_id)
	require("src.layer.MainTaskCtr"):instance():refreshItemNum()
	-- require("src.layer.MainTaskCtr"):instance():showTaskList()
	require("src.layer.MainTaskCtr"):instance():refreshTaskList()
	
	ex.Player.pub_task:checkRedDot()
end

-- 获取奖励
function PubTaskResponse:pubTaskAward(data, byte_array)
	ex.Player.pub_task.can_do_num = ex.Player.pub_task.can_do_num - 1

	-- 删除任务
	local task_id = data.task_id -- byte_array:readInt64()
	ex.Player.pub_task:removeTask(task_id)

	-- 消耗的钻石数
	-- ex.Player:addGem(-data.used_gem)

	local award_list = {}

	-- -- 奖励
	-- local list_count = byte_array:readInt()
	-- for i=1,list_count do
	-- 	local data = {}
	-- 	data.item_id = byte_array:readInt64()
	-- 	data.item_type = byte_array:readInt()
	-- 	data.item_num = byte_array:readInt()
	-- 	ex.Player:addItem(data.item_type, data.item_num, data.item_id)

	-- 	table.insert(award_list, data)
	-- end
	
	for i,v in ipairs(data.list) do
		local bag_data = {}
		bag_data.item_id = v.id
		bag_data.item_type = v.type
		bag_data.item_num = v.num
		-- ex.Player:addItem(bag_data.item_type, bag_data.item_num, bag_data.item_id)
		table.insert(award_list, bag_data)
	end


	-- 刷新任务界面
    -- local layer_pubTask = getTaskLayer()
	-- if layer_pubTask then
	-- 	--layer_pubTask:removeTaskByGain(task_id)
	-- 	layer_pubTask:updateScrollView()
	-- end

	require("src.layer.MainTaskCtr"):instance():showTaskList()


	require("src.layer.ItemRewardCtr"):instance():openWindow(award_list)

	ex.Player.pub_task:checkRedDot()

	ex.Player.promotion_data:reqTavernWeeklyList()
	ex.Player.promotion_data:reqPubArriveInfo()


end

function PubTaskResponse:updataLockStatus(data)
	local task_data = ex.Player.pub_task:getTask(data.task_id)
	if not task_data then return end 
	task_data.task_lock = data.task_lock
	ex.EventManager:fire(EVENT.PUB_TASK_EVENT.LOCK_STATUS_UPDATE,data.task_id)
end

return PubTaskResponse