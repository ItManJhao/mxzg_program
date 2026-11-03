local BlessingPoolResponse = class("BlessingPoolResponse")

local parseResBlessingPoolData = function(pbdata)
	local item = {}
	if pbdata ~= nil and pbdata.position ~= nil then
		item.index = pbdata.position
		item.item_id = pbdata.item.id
		item.item_type = pbdata.item.type
		item.item_num = pbdata.item.num
		item.times = pbdata.times
	end

	return item
end

function BlessingPoolResponse:blessingPoolList(data)
	-- dump(data, "BlessingPoolResponse:blessingPoolList")

	ex.Player.blessing_pool:clear()
	
	for i,v in ipairs(data.blessing_data) do
		ex.Player.blessing_pool:addRefreshTimes(v.type, v.refresh_times)
		ex.Player.blessing_pool:setRefreshTime(v.type, v.refresh_time)
		ex.Player.blessing_pool:setLuckyValue(v.type, v.lucky_value)
		ex.Player.blessing_pool:setLuckyRewardList(v.type, v.lucky_reward_id)

		for i2,v2 in ipairs(v.pool_data) do
			ex.Player.blessing_pool:addAward(v.type, parseResBlessingPoolData(v2))
		end
	end

	-- 刷新奖品
	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_BLESSING_POOL)
 	if cur_layer then
		cur_layer:updateBlessingPool()
		cur_layer:refreshLuckyInfoPanel()
	end
	
	ex.Player.blessing_pool:checkBlessingPoolRedDot()
end

function BlessingPoolResponse:lockItemList(data)
	-- dump(data, "BlessingPoolResponse:lockItemList")
	-- dump(data.blessing_data.pool_data, "BlessingPoolResponse:lockItemList")

	-- require("src.net.BlessingPoolResponse"):blessingPoolList(data)
	if data.blessing_data.type == 1 then
		ex.Player.blessing_pool.common_list = {}
	elseif data.blessing_data.type == 2 then
		ex.Player.blessing_pool.senior_list = {}
	end

	ex.Player.blessing_pool:addRefreshTimes(data.blessing_data.type, data.blessing_data.refresh_times)
	ex.Player.blessing_pool:setRefreshTime(data.blessing_data.type, data.blessing_data.refresh_time)
	ex.Player.blessing_pool:setLuckyValue(data.blessing_data.type, data.blessing_data.lucky_value)
	ex.Player.blessing_pool:setLuckyRewardList(data.blessing_data.type, data.blessing_data.lucky_reward_id)

	for i2,v2 in ipairs(data.blessing_data.pool_data) do
		ex.Player.blessing_pool:addAward(data.blessing_data.type, parseResBlessingPoolData(v2))
	end

	-- 刷新奖品
	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_BLESSING_POOL)
 	if cur_layer then
		cur_layer:updateBlessingPool()
		cur_layer:refreshLuckyInfoPanel()
	end
	
	ex.Player.blessing_pool:checkBlessingPoolRedDot()
end

function BlessingPoolResponse:awardList(data)
	-- dump(data, "BlessingPoolResponse:awardList")

	-- 刷新每个奖品的信息
	if data.blessing_data.type == 1 then
		ex.Player.blessing_pool.common_list = {}
	elseif data.blessing_data.type == 2 then
		ex.Player.blessing_pool.senior_list = {}
	end

	ex.Player.blessing_pool:addRefreshTimes(data.blessing_data.type, data.blessing_data.refresh_times)
	ex.Player.blessing_pool:setRefreshTime(data.blessing_data.type, data.blessing_data.refresh_time)
	ex.Player.blessing_pool:setLuckyValue(data.blessing_data.type, data.blessing_data.lucky_value)
	ex.Player.blessing_pool:setLuckyRewardList(data.blessing_data.type, data.blessing_data.lucky_reward_id)

	for i2,v2 in ipairs(data.blessing_data.pool_data) do
		ex.Player.blessing_pool:addAward(data.blessing_data.type, parseResBlessingPoolData(v2))
	end

	-- 记录当前所获得奖品信息
	ex.Player.blessing_pool.award_list = {}

	local resultIndex = data.index

	for i,v in ipairs(data.award) do
		local item = {}
		item.item_id = v.id
		item.item_type = v.type
		item.item_num = v.num

		ex.Player.blessing_pool:addAwardData(item)
	end

	-- 停止位置
 	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_BLESSING_POOL)
 	if cur_layer then
		cur_layer:startTurn(resultIndex)
		cur_layer:refreshLuckyInfoPanel()
	else
		local btn_content = {}
		btn_content.item = ex.Player.blessing_pool:getNeedItem(ex.Player.blessing_pool.cur_pool_type, ex.Player.blessing_pool.tag)
		btn_content.count = table.nums(data.award)
		local callback = function ()
			ex.Player.blessing_pool:runTurn()
		end
		require("src.layer.LuckRewardCtr"):instance():openWindow(ex.Player.blessing_pool.award_list, btn_content, callback)
    end 
	ex.EventManager:fire(EVENT.BLESSINGPOOL_EVENT.UPDATE_CURRENCY)

	ex.Player.blessing_pool:checkBlessingPoolRedDot()
end


function BlessingPoolResponse:HandleBlessingPoolLuckyReward(data)
	-- dump(data, "HandleBlessingPoolLuckyReward:awardList")
	if data.blessing_data.type == 1 then
		ex.Player.blessing_pool.common_list = {}
	elseif data.blessing_data.type == 2 then
		ex.Player.blessing_pool.senior_list = {}
	end

	ex.Player.blessing_pool:addRefreshTimes(data.blessing_data.type, data.blessing_data.refresh_times)
	ex.Player.blessing_pool:setRefreshTime(data.blessing_data.type, data.blessing_data.refresh_time)
	ex.Player.blessing_pool:setLuckyValue(data.blessing_data.type, data.blessing_data.lucky_value)
	ex.Player.blessing_pool:setLuckyRewardList(data.blessing_data.type, data.blessing_data.lucky_reward_id)

	for i2,v2 in ipairs(data.blessing_data.pool_data) do
		ex.Player.blessing_pool:addAward(data.blessing_data.type, parseResBlessingPoolData(v2))
	end

	-- 刷新幸运值
	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_BLESSING_POOL)
	 if cur_layer then
		cur_layer:refreshLuckyInfoPanel()
		cur_layer:refreshTabRedDot()
	end
	
	ex.Player.blessing_pool:checkBlessingPoolRedDot()
end

return BlessingPoolResponse