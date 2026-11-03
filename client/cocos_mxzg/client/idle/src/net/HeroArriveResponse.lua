local HeroArriveResponse = class("HeroArriveResponse")

-------------------------------------------

function HeroArriveResponse:heroArriveInitData(data)
	-- print("HeroArriveResponse:heroArriveInitData")
	-- dump_pbmsg(data)
	local end_time = data.end_time

	ex.Player.heroarrive_data:setEndTime(end_time)


	for i,v in ipairs(data.list) do
		local idx = v.idx
		local status = v.status

		ex.Player.heroarrive_data:setHeroArriveStatus(idx,status)
	end

	for i,v in ipairs(data.data_list) do

		local data = {}
		data.idx = v.id
		data.num = v.num 
		data.type = v.type

		ex.Player.heroarrive_data:setHeroArriveData(data)
		ex.Player.heroarrive_data:checkRedPoint()
	end
	ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_hero_arrive")
	ex.Player.heroarrive_data:checkRedPointByMainCity()
end

function HeroArriveResponse:heroArriveRewardResult(data)
	print("HeroArriveResponse:heroArriveRewardResult")
	dump_pbmsg(data)
	local idx = data.status.idx
	local status = data.status.status

	ex.Player.heroarrive_data:setHeroArriveStatus(idx,status)

	ex.Player.heroarrive_data:checkRedPoint()
	
	ex.EventManager:fire(EVENT.HERO_ARRIVE_EVENT.REWARD_RESULT)
	ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_hero_arrive")

	ex.Player.heroarrive_data:checkRedPointByMainCity()
end

function HeroArriveResponse:heroArriveUpdate(data)
	print("HeroArriveResponse:heroArriveUpdate")
	dump_pbmsg(data)
	local arr_data = {}
	arr_data.idx = data.data.id
	arr_data.num = data.data.num 
	arr_data.type = data.data.type
	ex.Player.heroarrive_data:setHeroArriveData(arr_data)
	ex.Player.heroarrive_data:checkRedPoint()
	ex.Player.heroarrive_data:checkRedPointByMainCity()
	ex.EventManager:fire(EVENT.HERO_ARRIVE_EVENT.UPDATE)
	ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_hero_arrive")
end

function HeroArriveResponse:rewardStatus(data)
	print("HeroArriveResponse:rewardStatus")
	dump_pbmsg(data)

	local idx = data.status[1].idx
	local status = data.status[1].status

	ex.Player.heroarrive_data:setHeroArriveStatus(idx,status)

	ex.Player.heroarrive_data:checkRedPoint()
	ex.Player.heroarrive_data:checkRedPointByMainCity()
	
	ex.EventManager:fire(EVENT.HERO_ARRIVE_EVENT.REWARD_RESULT)
	ex.EventManager:fire(EVENT.MAIN_CITY_ACT.ACTIVITY_IS_END,"act_hero_arrive")
end


return HeroArriveResponse
