local SummonResponse = class("SummonResponse")

-- 展示奖励界面
local function showAward(award_type, data_list)
    -- local cur_scene, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_SUMMON)
    -- if not cur_scene or not cur_layer then
    -- 	return
	-- end
	
	local cur_scene = ex.MainSceneCtr
	local cur_layer = cur_scene:getCurLayer()

	 local node = require("src.layer.RewardLayer"):createAward(award_type, data_list, true, function()
		if cur_layer.touchSwallowTouches ~= nil then 
			cur_layer:touchSwallowTouches(false)
		end
    end)
    cur_scene.scene:addChild(node, 1000000)
	if cur_layer.updateCompleted then 
		cur_layer:updateCompleted()
	end

	ex.AudioManager:playEffect("music/summon-begin.mp3")
end

-- 完成度 开机请求一次
function SummonResponse:summonCompleted(data)
	-- print("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--")
	-- dump_pbmsg(data)
	ex.Player.summon_data:clear()

	--for i=1,3 do
	--	ex.Player.summon_data:setFreeTime(i, data.free_time)
	--end

	--for i=1,3 do
	--	ex.Player.summon_data:setFree(i, data.senior_free_time)
	--end
	
	ex.Player.summon_data:setFreeTime(1, data.free_time)
	ex.Player.summon_data:setFreeTime(3, data.senior_free_time)

	ex.Player.summon_data:setReshrefTime()

	-- 客户端界面进度刷新
 	local _, cur_layer = GetMainSceneLayer(MainSceneType.MAINCITY_SUMMON)
 	if cur_layer and cur_layer.updateCompleted then
    	cur_layer:updateCompleted()
    end
	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZHFZ, ex.Player.summon_data:checkRedDot())
end


-- 招募 一次 十次
function SummonResponse:summonList(data)
	print("SummonResponse:summonList")
	dump(data)
	ex.Player.summon_data.summon_list = {}
	local HeroAbilityData = require("src.data.HeroAbilityData")
	for i,v in ipairs(data.list) do
		ex.Player.summon_data.summon_list[i] = v.hero_type

		-- local hero = HeroAbilityData.new()
		-- hero.hero_id = v.hero_id
		-- hero.hero_type = v.hero_type
		-- hero.level = v.level
		-- hero.stage = v.stage
		-- hero.star = v.star
		-- hero.elem = v.elem
		-- hero.fighting = v.fighting
		-- hero.occupation = v.occupation
		-- hero.is_lock = v.is_lock == 1
		-- ex.Player.hero_data:addHero(hero)
	end
	
	--ex.out(ex.Player.summon_data.summon_list)

	-- 显示招募的英雄
	showAward(1, ex.Player.summon_data.summon_list)
	
	ex.Player.promotion_data:reqSummonTimesLists()
	ex.Player.hero_data:initSort()
	ex.Player.hero_data.promote:initUpStarRedPoint()


	NetManager:sendMessage(ProtocolID.GReqHeroPrayerData)
end

-- 完成进度 获取奖励
function SummonResponse:summonAward(data)
	print("SummonResponse:summonList")
	dump_pbmsg(data)
	ex.Player.summon_data.award_list = {}
	local HeroAbilityData = require("src.data.HeroAbilityData")

	for i,v in ipairs(data.list) do
		ex.Player.summon_data.award_list[i] = v.hero_type

		-- local hero = HeroAbilityData.new()
		-- hero.hero_id = v.hero_id
		-- hero.hero_type = v.hero_type
		-- hero.level = v.level
		-- hero.stage = v.stage
		-- hero.star = v.star
		-- hero.elem = v.elem
		-- hero.fighting = v.fighting
		-- hero.occupation = v.occupation
		-- hero.is_lock = v.is_lock == 1
		-- ex.Player.hero_data:addHero(hero)
	end
	
	--ex.out(ex.Player.summon_data.award_list)

	-- 显示进度奖励
	showAward(2, ex.Player.summon_data.award_list)
	ex.Player.hero_data:initSort()
	ex.Player.hero_data.promote:initUpStarRedPoint()

	ex.RedDotManager:setRedNodeVisible(RedDotType.ZCJ_DHZC_ZHFZ, ex.Player.summon_data:checkRedDot())

end

return SummonResponse