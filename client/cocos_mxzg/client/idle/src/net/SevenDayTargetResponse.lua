local SevenDayTargetResponse = class("SevenDayTargetResponse")

function SevenDayTargetResponse:sevenDayTargetInitData(data,byte_array)
	-- local end_time = byte_array:readInt()
	-- local cur_day = byte_array:readInt()
	local end_time = data.end_time
	local cur_day = data.cur_day
	local point = data.point
	ex.Player.seventdaytarget_data:setEndTime(end_time)
	ex.Player.seventdaytarget_data:setCurDay(cur_day)
	
	-- local point = byte_array:readInt()

	ex.Player.seventdaytarget_data:setPoint(point)
	-- local count = byte_array:readInt()

	-- for i=1,count do
	for i,v in ipairs(data.list) do
		local data_item = {}
		data_item.idx = v.idx 
		data_item.num = v.num 
		data_item.day = v.day
		ex.Player.seventdaytarget_data:setSevenDayData(data_item)

	end
	-- count = byte_array:readInt()
	-- for i=1,count do
	for i,v in ipairs(data.box) do
		local idx = v.idx
		local status = v.status
		ex.Player.seventdaytarget_data:setSevenDayBox(idx,status)
	end

	-- count = byte_array:readInt()
	-- for i=1,count do
	for i,v in ipairs(data.status_list) do
		local idx = v.idx
		local status = v.status
		ex.Player.seventdaytarget_data:setSevenDayStatus(idx,status)

	end

	ex.Player.seventdaytarget_data:initBoxRedPoint()
	ex.Player.seventdaytarget_data:initSevenDayRedPoint()
	local type_red = ex.Player.seventdaytarget_data:getSevenDayRedPoint()
	local box_red = ex.Player.seventdaytarget_data:getBoxRedPoint()
	local red = type_red or box_red

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTMB, red)

	ex.Player.seventdaytarget_data:stardTargetTimer()
end

function SevenDayTargetResponse:upSevenDayByType(data,byte_array)
	-- local count = byte_array:readInt()
	local tag --= cfg.promotion7daytarget.target[idx].tag
	for i,v in ipairs(data.data) do
		local data = {}
		data.idx = v.idx 
		data.num = v.num 
		data.day = v.day 
		ex.Player.seventdaytarget_data:setSevenDayData(data)
		local bool = ex.Player.seventdaytarget_data:checkSevenDayRedPoint(data.idx)
		ex.Player.seventdaytarget_data:setSevenDayRedPoint(data.idx,bool)
		if not tag then tag = ex.Player.promotion_data.promotion7daytarget_value[data.idx].tag end
	end

	-- local not_get = ex.Player.seventdaytarget_data:getSevenDayStatus(data.idx) < 1
	-- local config = cfg.cfg.promotion7daytarget.target[data.idx]
	local type_red = ex.Player.seventdaytarget_data:getSevenDayRedPoint()
	local box_red = ex.Player.seventdaytarget_data:getBoxRedPoint()
	local red = type_red or box_red
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTMB, red)
	ex.EventManager:fire(EVENT.SEVEN_TARGET_DATA_EVENT.UPDATE_SEVEN_DAY_DATA,tag)
end

function SevenDayTargetResponse:sevenDayTargetRewardResult(data,byte_array)
	print("SevenDayTargetResponse:sevenDayTargetRewardResult")
	-- dump_pbmsg(data)
	-- local point = byte_array:readInt()
	local point = data.point
	ex.Player.seventdaytarget_data:setPoint(point)
	local idx = data.status.idx
	local status = data.status.status

	local config = ex.Player.promotion_data.promotion7daytarget_value[idx]
	if config ~= nil then 
		if config.kind == 2 then 
			ex.Player:addGem(-config.num)
		end
	end
	-- print("SevenDayTargetResponse sevenDayTargetRewardResult",idx,status,point)
	ex.Player.seventdaytarget_data:setSevenDayStatus(idx,status)
	ex.Player.seventdaytarget_data:setSevenDayRedPoint(idx,false)

	-- local count = byte_array:readInt()
	local items = {}
	for i,v in ipairs(data.data) do

		local item = {}
		item.item_id = v.id
		item.item_type = v.type
		item.item_num = v.num
		table.insert(items,item)
		-- ex.Player:addItemByNet(item.item_id,item.item_type,item.item_num)
	end

	ex.Player.seventdaytarget_data:initBoxRedPoint()
	local type_red = ex.Player.seventdaytarget_data:getSevenDayRedPoint()
	local box_red = ex.Player.seventdaytarget_data:getBoxRedPoint()
	local red = type_red or box_red

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTMB, red)
	ex.EventManager:fire(EVENT.SEVEN_TARGET_DATA_EVENT.REWARD_RESULT,items)

	-- ex.AudioManager:playEffect("music/item-get.mp3")
	require('src.layer.ItemRewardCtr'):instance():openWindow(items)
end

function SevenDayTargetResponse:sevenDayTargetBoxRewardResult(data,byte_array)
	-- local count = byte_array:readInt()
	local items = {}
	-- for i=1,count do
	for i,v in ipairs(data.data) do

		local item = {}
		item.item_id = v.id 
		item.item_type = v.type 
		item.item_num = v.num
		table.insert(items,item)
		-- ex.Player:addItemByNet(item.item_id,item.item_type,item.item_num)
	end

	-- local idx = byte_array:readInt()
	-- local status = byte_array:readInt8()
	local idx = data.box.idx 
	local status = data.box.status
	ex.Player.seventdaytarget_data:setSevenDayBox(idx,status)
	ex.Player.seventdaytarget_data:setBoxRedPoint(idx,false)

	local type_red = ex.Player.seventdaytarget_data:getSevenDayRedPoint()
	local box_red = ex.Player.seventdaytarget_data:getBoxRedPoint()
	local red = type_red or box_red

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTMB,red)
	ex.EventManager:fire(EVENT.SEVEN_TARGET_DATA_EVENT.BOX_REWARD_RESULT,items)

	-- ex.AudioManager:playEffect("music/item-get.mp3")
	-- require('src.layer.ItemRewardCtr'):instance():openWindow(items)
end

function SevenDayTargetResponse:sevenDayTargetUpdateDay(data,byte_array)
	-- local cur_day = byte_array:readInt()
	local cur_day = data.cur_day
	ex.Player.seventdaytarget_data:setCurDay(cur_day)
	ex.EventManager:fire(EVENT.SEVEN_TARGET_DATA_EVENT.UPDATE_SEVEN_DAY_TARGET_CHANGE)
end

-------------------------------------------

function SevenDayTargetResponse:sevenDayInitData(data)
	-- print("SevenDayTargetResponse:sevenDayInitData")
	-- dump_pbmsg(data)
	local end_time = data.end_time
	local cur_day = data.cur_day
	ex.Player.seven_login_data:setLoginEndTime(end_time)
	ex.Player.seven_login_data:setLoginCurDay(cur_day)

	for i,v in ipairs(data.list) do
		local day = v.idx
		local status = v.status
		ex.Player.seven_login_data:setSevenDayLoginStatus(day,status)
	end
	ex.Player.seven_login_data:changLoginTime()
	ex.Player.seven_login_data:stardLoginTimer()
	local red = ex.Player.seven_login_data:checkLoginRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTDL,red)
end

function SevenDayTargetResponse:sevenDayRewardResult(data)
	-- local day = byte_array:readInt()
	-- local status = byte_array:readInt8()
	local day = data.status.idx
	local status = data.status.status
	ex.Player.seven_login_data:setSevenDayLoginStatus(day,status)
	-- local count = byte_array:readInt()
	print("SevenDayTargetResponse:sevenDayRewardResult")
	dump_pbmsg(data)
	local items = {}
	-- for i=1,count do
	-- for i,v in ipairs(data.data) do
	-- 	local item = {}
	-- 	item.item_id = v.id 
	-- 	item.item_type = v.type 
	-- 	item.item_num = v.num 
	-- 	table.insert(items,item)
	-- 	ex.Player:addItemByNet(item.item_id,item.item_type,item.item_num)
	-- end 
	ex.EventManager:fire(EVENT.SEVEN_TARGET_DATA_EVENT.SEVENT_DAY_REWARD_RESULE,items)
	ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_sevent_day_gift")
	local red = ex.Player.seven_login_data:checkLoginRedPoint()
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZCQTDL,red)
end

function SevenDayTargetResponse:sevenDayLoginUpdataDay(data)
	-- local cur_day = byte_array:readInt()
	print("SevenDayTargetResponse:sevenDayLoginUpdataDay")
	dump_pbmsg(data)
	local cur_day = data.cur_day
	ex.Player.seven_login_data:setLoginCurDay(cur_day)
	ex.EventManager:fire(EVENT.SEVEN_TARGET_DATA_EVENT.UPDATE_SEVEN_DAY_CHANGE)
end


---------------------------------------------------新版--------------------------------------------------------------------
function SevenDayTargetResponse:setGResSevenDayTargetList( data )
	ex.Player.seventdaytarget_data:setSevenDayTargetList(data)

	ex.Player.seventdaytarget_data:refreshDayRed()

	ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

--  领取奖励
function SevenDayTargetResponse:setGResSevenDayTargetGetReward( data )

	ex.Player.seventdaytarget_data:getSevenDayGift(data)

	ex.EventManager:fire(EVENT.SEVEN_TARGET_DATA_EVENT.REWARD_RESULT)

	ex.Player.seventdaytarget_data:refreshDayRed()
	ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)
end

-- 领取成就
function SevenDayTargetResponse:setGResSevenDayTargetBoxGetReward( data )

	ex.Player.seventdaytarget_data:setRewardBox(data.box_id)

	ex.EventManager:fire(EVENT.SEVEN_TARGET_DATA_EVENT.BOX_REWARD_RESULT)

	ex.Player.seventdaytarget_data:refreshDayRed()
	ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end

--主动推送
function SevenDayTargetResponse:setGResUpdateSevenDayTarget( data )
	for i,v in ipairs(data.update_tasks) do
		local ndata = {}
		ndata.idx = v.idx
		ndata.process = v.process
		ndata.state = v.state
		ex.Player.seventdaytarget_data:setChangeSevenDayTarget(ndata)
	end

	ex.Player.seventdaytarget_data:refreshDayRed()
	ex.EventManager:fire(EVENT.MAIN_CITY.REFRESH_BTN_STATUS)

end



return SevenDayTargetResponse
