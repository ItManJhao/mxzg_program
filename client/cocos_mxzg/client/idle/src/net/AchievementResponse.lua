local AchievementResponse = class("AchievementResponse")

-- function AchievementResponse:achievementInitData(data)
-- 	for i,v in ipairs(data.list) do
-- 		local type = v.type
-- 		local level = v.level
-- 		-- print(type,level,"AchievementResponse,geted")
-- 		ex.Player.achievement_data:setAchievementLevelByType(type ,level)
-- 	end

-- 	for i,v in ipairs(data.data_list) do
-- 		local type = v.type
-- 		local num = v.num
-- 		-- print(type,num,"AchievementResponse data")
-- 		ex.Player.achievement_data:setAchievementDataByType(type ,num)
-- 	end
-- 	ex.Player.achievement_data:initCurAchievementCfg()
-- 	local red = ex.Player.achievement_data:checkRedPoint()
		
-- 	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJCJT, red)
-- 	-- cpp.LoadingSceneCtr:instance():receivedProtocol(ProtocolID.GResAchievementLevel)
-- 	require("src.scene.LoadingSceneCtr"):instance():receivedProtocol(ProtocolID.GResAchievementLevel)
-- 	-- print("chievementResponse:achievementInitData")
-- 	-- dump_pbmsg(data)
-- end

-- function AchievementResponse:upAchievementByType(data,byte_array)
-- 	-- local type = byte_array:readInt()
-- 	-- local num = byte_array:readInt()
-- 	local type = data.data.type 
-- 	local num = data.data.num
-- 	ex.Player.achievement_data:setAchievementDataByType(type ,num)
-- 	-- ex.Player.achievement_data: 
-- 	-- print(type,num,"AchievementResponse update")
-- 	local red = ex.Player.achievement_data:checkRedPoint()
-- 	-- print("AchievementResponse2", type, num)
-- 	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJCJT,red)
-- end

-- function AchievementResponse:achievementRewardResult(data , byte_array)
-- 	-- local type = byte_array:readInt()
-- 	-- local level = byte_array:readInt8()
-- 	local type = data.record.type 
-- 	local level = data.record.level 

-- 	ex.Player.achievement_data:setAchievementLevelByType(type ,level)
-- 	ex.Player.achievement_data:initCurAchievementCfg()
-- 	ex.Player.achievement_data:checkRedPoint()

-- 	-- local count = byte_array:readInt()
-- 	local items = {}
-- 	-- for i=1,count do
-- 	-- for i,v in ipairs(data.list) do
-- 	-- 	local item = {}
-- 	-- 	item.item_id = v.item_id
-- 	-- 	item.item_type = v.item_type
-- 	-- 	item.item_num = v.item_num
-- 	-- 	table.insert(items,item)
-- 	-- 	ex.Player:addItemByNet(item.item_id,item.item_type,item.item_num)
-- 	-- end
-- 	local red = ex.Player.achievement_data:checkRedPoint()
-- 	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJCJT, red)
-- 	-- require("src.layer.ItemRewardCtr"):instance():openWindow(items)
-- 	ex.EventManager:fire(EVENT.ACHIEVEMENT_EVENT.REWARD_RESULT)

-- end

-- function AchievementResponse:dailyInitData(data)
-- 	local point = data.point
-- 	ex.Player.achievement_data:setDailyPoint(point)
-- 	for i,v in ipairs(data.data_list) do
-- 		local type = v.type
-- 		local num = v.num
-- 		-- print("daily_data type:", type , " num :" , num )
-- 		ex.Player.achievement_data:setDailyDataByType(type ,num)
-- 	end

-- 	for i,v in ipairs(data.list) do
-- 		local type = v.type
-- 		local num = v.level
-- 		ex.Player.achievement_data:setDailyGetedByType(type ,num)
-- 	end

-- 	for i,v in ipairs(data.box_list) do
-- 		local idx = v.idx
-- 		local status = v.status
-- 		ex.Player.achievement_data:setDailyBoxByType(idx ,status)
-- 	end
-- 	ex.Player.achievement_data:stardTimer()

-- 	local red = ex.Player.achievement_data:checkDailyRedPoint()
-- 	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJRCT,red)
-- 	cpp.LoadingSceneCtr:instance():receivedProtocol(ProtocolID.GResDailyData)
-- 	require("src.scene.LoadingSceneCtr"):instance():receivedProtocol(ProtocolID.GResDailyData)
-- 	-- print("chievementResponse:dailyInitData")
-- 	-- dump_pbmsg(data)
-- end

-- function AchievementResponse:dailyRewardResult(data,byte_array)
-- 	local record = data.record

-- 	ex.Player.achievement_data:setDailyGetedByType(record.type,record.level)
-- 	ex.Player.achievement_data:setDailyPoint(data.point)
-- 	local items = {}
-- 	-- local count = byte_array:readInt()
-- 	-- for i,v in ipairs(data.list) do
-- 	-- 	local item = {}
-- 	-- 	item.item_id = v.id
-- 	-- 	item.item_type = v.type
-- 	-- 	item.item_num = v.num
-- 	-- 	table.insert(items,item)
-- 	-- 	ex.Player:addItemByNet(item.item_id,item.item_type,item.item_num)
-- 	-- end

-- 	local red = ex.Player.achievement_data:checkDailyRedPoint()
-- 	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJRCT,red)
-- 	-- require("src.layer.ItemRewardCtr"):instance():openWindow(items)

-- 	ex.EventManager:fire(EVENT.ACHIEVEMENT_EVENT.DAILY_REWARD_RESULT)
-- end

-- function AchievementResponse:dailyBoxRewardResult(data ,byte_array)
-- 	local box = data.box
-- 	ex.Player.achievement_data:setDailyBoxByType(box.idx,box.status)
-- 	-- local count = byte_array:readInt()
-- 	local items = {}
-- 	-- for i=1,count do
-- 	-- for i,v in ipairs(data.list) do
-- 	-- 	local item = {}
-- 	-- 	item.item_id = v.id
-- 	-- 	item.item_type = v.ype
-- 	-- 	item.item_num = v.num
-- 	-- 	table.insert(items,item)
-- 	-- 	ex.Player:addItemByNet(item.item_id,item.item_type,item.item_num)
-- 	-- end

-- 	local red = ex.Player.achievement_data:checkDailyRedPoint()
-- 	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJRCT,red)
-- 	-- require("src.layer.ItemRewardCtr"):instance():openWindow(items)
-- 	ex.EventManager:fire(EVENT.ACHIEVEMENT_EVENT.DAILY_BOX)
-- end

-- function AchievementResponse:upDailyByType(data , byte_array)
-- 	-- local type = byte_array:readInt()
-- 	-- local num = byte_array:readInt()
-- 	print("AchievementResponse:upDailyByType")
-- 	local type = data.data.type 
-- 	local num = data.data.num
-- 	ex.Player.achievement_data:setDailyDataByType(type ,num)

-- 	local red = ex.Player.achievement_data:checkDailyRedPoint()
-- 	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCCJ_ZCCJRCT,red)
-- end

function AchievementResponse:initAchievementData(data)
	-- print("AchievementResponse:initAchievementData")
	-- dump_pbmsg(data)
	ex.Player.achievement_data:initAchievementData(data)
	ex.Player.achievement_data:checkAchievementRedPoint()
end

function AchievementResponse:onAchievementReward(data)
	-- print("AchievementResponse:onAchievementReward")
	-- dump_pbmsg(data)
	ex.Player.achievement_data:removeTask(data.idx)
	if next(data.add_tasks) ~= nil then 
		for i,v in ipairs(data.add_tasks) do
			ex.Player.achievement_data:updateTask(v)
		end
	end

	if next(data.last_task) ~= nil then 
		ex.Player.achievement_data:updateTask(data.last_task)
	end

	ex.Player.achievement_data:checkAchievementRedPoint()
	ex.EventManager:fire(EVENT.ACHIEVEMENT_EVENT.REWARD_RESULT)

	ex.Tools:resetAchievementStatus(data.idx)
end

-- 更新成就进度
function AchievementResponse:updateAchievement(data)
	-- print("AchievementResponse:updateAchievement")
	-- dump_pbmsg(data)
	for i,v in ipairs(data.update_tasks) do
		ex.Player.achievement_data:updateTask(v)
	end
	ex.Player.achievement_data:checkAchievementRedPoint()
end

-- 更新成就完成进度
function AchievementResponse:updateAchievementComplete(data)
	for i,v in ipairs(data.complete_ids) do
		ex.Player.achievement_data:updateTaskComplete(v)
	end
end

function AchievementResponse:initDailyData(data)
	-- print("AchievementResponse:initDailyData")
	-- dump_pbmsg(data)
	ex.Player.achievement_data:initDailyData(data)
end

function AchievementResponse:getDailyReward(data)
	-- print("AchievementResponse:getDailyReward")
	-- dump_pbmsg(data)
	for i,v in ipairs(data.task) do
		ex.Player.achievement_data:updateDailyData(v)
	end
	ex.Player.achievement_data:setPoint(data.daily_value)
	ex.Player.achievement_data:checkDailyRedpoint()
	ex.EventManager:fire(EVENT.ACHIEVEMENT_EVENT.DAILY_REWARD_RESULT)

	ex.Tools:resetAchievementStatus(data.daily_value)
end

function AchievementResponse:getDailyBoxReward(data)
	-- print("AchievementResponse:getDailyBoxReward")
	-- dump_pbmsg(data)
	ex.Player.achievement_data:setBoxGeted(data.box_id)
	ex.Player.achievement_data:checkDailyRedpoint()
	ex.EventManager:fire(EVENT.ACHIEVEMENT_EVENT.DAILY_BOX)
end

function AchievementResponse:upDailyByTask(data)
	-- print("AchievementResponse:upDailyByTask")
	-- dump_pbmsg(data)
	for i,v in ipairs(data.update_tasks) do
		ex.Player.achievement_data:updateDailyData(v)
	end
	ex.Player.achievement_data:checkDailyRedpoint()
end


return AchievementResponse
