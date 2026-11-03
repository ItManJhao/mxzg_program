local OnlineRewardResponse = class("OnlineRewardResponse")

function OnlineRewardResponse:onlineRewardInit(data,byte_array)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResInitOnlineReward, byte_array)
	print("OnlineRewardResponse:onlineRewardInit")
	-- dump_pbmsg(data) 
	ex.Player.onlineReward_data:InitData(data)
	-- dump(data)
end

function OnlineRewardResponse:onlineRewardAgain(data)
	-- dump(data)

	ex.Player.onlineReward_data:setAgainStatus(data.idx)
	-- ex.Player.onlineReward_data:setRewardId(data.reward_id)
	-- ex.Player.onlineReward_data:setEndTime(data.end_time)
	-- ex.Player.onlineReward_data:setOnlineTime(data.online_time)
	-- ex.Player.onlineReward_data:checkRewardId()
	-- dump(data)

	local addHero = function (data)
		local HeroAbilityData = require("src.data.HeroAbilityData")
		local hero = HeroAbilityData.new()
		hero.hero_id = data.hero_id
		hero.hero_type = data.hero_type
		hero.level = data.level
		hero.stage = data.stage
		hero.star = data.star
		hero.elem = data.elem
		hero.fighting = data.fighting
		hero.occupation = data.occupation
		hero.is_lock = data.is_lock == 1
		hero.hp_up_level = data.hp_up_level
		hero.atk_up_level = data.atk_up_level
		hero.equip = {}
		-- hero.bat = 2000 + math.random(1, 1000)
		ex.Player.hero_data:addHero(hero)
		dump(ex.Player.hero_data.hero_list)
	end
	
	ex.Player.hero_data:initSort()

	if data.hero.hero_id ~= 0 then 
		-- addHero(data.hero)
		
		for k,v in pairs(ex.Player.hero_data.promote:getBattleList()) do
			ex.Player.hero_data.promote:checkUpStar(k)
		end

		local creatHero = ex.Player.hero_data.promote:getCreatHeroData()
		for k,v in pairs(creatHero) do
			ex.Player.hero_data.promote:checkUpStar(v,true)
		end
		local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
		local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, bool or artifact_red)
		ex.Player.hero_data.promote:checkCreatHeroRedPoint()
		local item = {}
		item.item_id = "0"
		item.item_num = 1
		item.item_type = data.hero.hero_type
		local list  = {}
		table.insert(list,item)
		require("src.layer.ItemRewardCtr"):instance():openWindow(list)
	end

	-- local tag = ex.Player.backpack_data:getPropType(data.items.item_type)
	-- if tag == IT_INVALID then 

	-- else
	-- 	-- ProtocolResponse.PSHeroData()
	-- end

	

	local open = ex.Player.onlineReward_data:isOpen()

	if not open then 
		ex.EventManager:fire(EVENT.ONLINE_REWARD.CLOSE)
		ex.EventManager:fire(EVENT.ONLINE_REWARD.CLOSE_OTHER)
		require("src.layer.onlinereward.OnlineRewardCtr"):instance():closeWindow()
	else
		ex.EventManager:fire(EVENT.ONLINE_REWARD.GET_REWARD_RESULT)
	end
end

-- function OnlineRewardResponse:onlineRewardResult(byte_array)
-- 	local data = NetManager:resLuaData(ProtocolResponse.ResOnlineRewardResult, byte_array)
-- 	-- dump(data)
-- 	local pre_id = ex.Player.onlineReward_data:getRewardId()
-- 	ex.Player.onlineReward_data:setStatus(pre_id,1)
-- 	ex.Player.onlineReward_data:setRewardId(data.reward_id)
-- 	ex.Player.onlineReward_data:setEndTime(data.end_time)

-- 	require("src.layer.ItemRewardCtr"):instance():openWindow(data.itmes)

-- 	if data.reward_id == 0 then 	--全部领取完成
-- 		ex.Player.onlineReward_data.can = false
-- 		ex.EventManager:fire(EVENT.ONLINE_REWARD.CLOSE)
-- 	else
-- 		ex.EventManager:fire(EVENT.ONLINE_REWARD.GET_REWARD_RESULT)
-- 		ex.Player.onlineReward_data:startTimer()
-- 	end

-- end

function OnlineRewardResponse:onlineRewardResult(data,byte_array)
	print("OnlineRewardResponse:onlineRewardResult")
	-- local data = NetManager:resLuaData(ProtocolResponse.ResOnlineRewardResult, byte_array)
	-- local pre_id = ex.Player.onlineReward_data:getRewardId()
	ex.Player.onlineReward_data:setStatus(data.idx_list.key,data.idx_list.value)
	-- ex.Player.onlineReward_data:setRewardId(data.reward_id)
	-- ex.Player.onlineReward_data:setEndTime(data.end_time)
	-- ex.Player.onlineReward_data:setOnlineTime(data.online_time)
	-- ex.Player.onlineReward_data:checkRewardId()
	-- dump(data)

	local addHero = function (data)
		local HeroAbilityData = require("src.data.HeroAbilityData")
		local hero = HeroAbilityData.new()
		hero.hero_id = data.hero_id
		hero.hero_type = data.hero_type
		hero.level = data.level
		hero.stage = data.stage
		hero.star = data.star
		hero.elem = data.elem
		hero.fighting = data.fighting
		hero.occupation = data.occupation
		hero.is_lock = data.is_lock == 1
		hero.hp_up_level = data.hp_up_level
		hero.atk_up_level = data.atk_up_level
		hero.equip = {}
		-- hero.bat = 2000 + math.random(1, 1000)
		ex.Player.hero_data:addHero(hero)
		dump(ex.Player.hero_data.hero_list)
	end
	
	ex.Player.hero_data:initSort()

	if data.hero.hero_id ~= 0 then 
		-- addHero(data.hero)
		
		for k,v in pairs(ex.Player.hero_data.promote:getBattleList()) do
			ex.Player.hero_data.promote:checkUpStar(k)
		end

		local creatHero = ex.Player.hero_data.promote:getCreatHeroData()
		for k,v in pairs(creatHero) do
			ex.Player.hero_data.promote:checkUpStar(v,true)
		end
		local bool = ex.Player.hero_data.promote:checkMainCityRedPoint()
		local artifact_red = ex.Player.hero_data.artifact:checkMainCityRedPoint()
		ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHYX_YXT, bool or artifact_red)
		ex.Player.hero_data.promote:checkCreatHeroRedPoint()
		local item = {}
		item.item_id = "0"
		item.item_num = 1
		item.item_type = data.hero.hero_type
		local list  = {}
		table.insert(list,item)
		require("src.layer.ItemRewardCtr"):instance():openWindow(list)
	end

	-- local tag = ex.Player.backpack_data:getPropType(data.items.item_type)
	-- if tag == IT_INVALID then 

	-- else
	-- 	-- ProtocolResponse.PSHeroData()
	-- end

	

	local open = ex.Player.onlineReward_data:isOpen()

	if not open then 
		ex.EventManager:fire(EVENT.ONLINE_REWARD.CLOSE)
		ex.EventManager:fire(EVENT.ONLINE_REWARD.CLOSE_OTHER)
		require("src.layer.onlinereward.OnlineRewardCtr"):instance():closeWindow()
	else
		ex.EventManager:fire(EVENT.ONLINE_REWARD.GET_REWARD_RESULT)
	end

	-- if ex.Player.onlineReward_data:getRewardId() == 0 then 	--全部领取完成
	-- 	ex.Player.onlineReward_data.can = false

	-- else

	-- end

end

function OnlineRewardResponse:onlineRewardStatus(data,byte_array)
	print("OnlineRewardResponse:onlineRewardStatus")
	-- dump_pbmsg(data)
	-- local data = NetManager:resLuaData(ProtocolResponse.ResOnlineRewardStatus, byte_array)
	ex.Player.onlineReward_data:setCanGetId(data.reward_id)
	ex.Player.onlineReward_data:setEndTime(data.end_time)
	ex.Player.onlineReward_data:startTimer()
	-- dump(data)
	ex.EventManager:fire(EVENT.ONLINE_REWARD.UPDATE_STATUS)
end

return OnlineRewardResponse
